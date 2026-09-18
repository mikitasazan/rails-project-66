# frozen_string_literal: true

class CheckRepositoryService
  class << self
    def check(check)
      begin
        check.run_check!

        bash_runner = ApplicationContainer[:bash_runner]
        git = ApplicationContainer[:git]

        repository = check.repository

        repository_path = path_to_repository(repository)

        clean_repository_path(bash_runner, repository_path)

        git.clone(repository.clone_url, repository_path)

        check.commit_id = commit_id(bash_runner, repository_path)

        check_command = map_language_to_check_command(repository)
        check_log, exit_status = bash_runner.execute(check_command)

        check.check_log = check_log
        check.passed = exit_status.zero?
        check.mark_as_finish!
      rescue StandardError => e
        check.passed = false
        check.mark_as_fail!
        Rails.logger.error e
      end

      if check.failed?
        CheckResultMailer.with(user: check.repository.user, check:).error_check_email.deliver_later
      elsif !check.passed
        CheckResultMailer.with(user: check.repository.user, check:).failed_check_email.deliver_later
      else
        CheckResultMailer.with(user: check.repository.user, check:).passed_check_email.deliver_later
      end
    end

    private

    def clean_repository_path(bash_runner, repository_path)
      return unless Dir.exist?(repository_path)

      clean_dir_command = "rm -rf #{repository_path}"
      output, exit_status = bash_runner.execute(clean_dir_command)

      return if exit_status.zero?

      raise "Could not clean repository path"
    end

    def commit_id(bash_runner, repository_path)
      commit_id_command = "cd #{repository_path} && git rev-parse --short HEAD"
      commit_id_output, exit_status = bash_runner.execute(commit_id_command)

      raise "Could not get commit id" unless exit_status.zero?

      commit_id_output.chop
    end

    def map_language_to_check_command(repository)
      path_to_repository = repository.path_to_directory
      mapping = {
        javascript: "node_modules/eslint/bin/eslint.js #{path_to_repository} --format=json --no-eslintrc",
        ruby: "bundle exec rubocop #{path_to_repository} --format=json --fail-level warning"
      }

      mapping[repository.language.to_sym]
    end

    def path_to_repository(repository)
      File.join(Dir.tmpdir, "hexlet_quality_repositories/", repository.full_name)
    end
  end
end
