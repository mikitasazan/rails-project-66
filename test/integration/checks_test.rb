# frozen_string_literal: true

require "test_helper"

class ChecksTest < ActionDispatch::IntegrationTest
  include InlineJobsConcern

  test "#create runs a check synchronously and it finishes" do
    sign_in_by_test_session("one@test.com")
    post repositories_path, params: { repository: { github_id: 1 } }
    repository = Repository.find_by!(github_id: 1)

    assert_difference -> { Repository::Check.count }, 1 do
      post repository_checks_path(repository)
    end

    assert_redirected_to repository_path(repository)

    check = repository.checks.last
    assert { check.finished? }
    assert { check.passed == true }

    get repository_check_path(repository, check)

    assert_response :success
    assert { @response.body.include?("Завершена") }
  end

  test "#show redirects while the check is not finished" do
    sign_in_by_test_session("one@test.com")
    repository = repositories(:one)
    repository.checks.create!

    get repository_check_path(repository, repository.checks.last)

    assert_redirected_to repository_path(repository)
  end

  private

  def sign_in_by_test_session(email)
    post test_session_path, params: { email: }
  end
end
