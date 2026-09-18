# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  # DEMO_STUBS включает заглушки вне тестов (например, dev-сервер для съёмки демо),
  # чтобы форма /repositories/new работала без реального GitHub. По умолчанию выключено.
  if Rails.env.test? || ENV["DEMO_STUBS"].present?
    register :bash_runner, -> { BashRunnerStub }
    register :git, -> { GitStub }
    register :github_client, -> { GithubClientStub }
  else
    register :bash_runner, -> { BashRunner }
    register :git, -> { Git }
    register :github_client, -> { Octokit::Client }
  end
end
