# frozen_string_literal: true

require "test_helper"

class RepositoriesTest < ActionDispatch::IntegrationTest
  include InlineJobsConcern

  test "#new requires sign in" do
    get new_repository_path

    assert_redirected_to root_path
  end

  test "#create adds a repository and fetches its info" do
    sign_in_by_test_session("one@test.com")

    assert_difference -> { Repository.count }, 1 do
      post repositories_path, params: { repository: { github_id: 1 } }
    end

    assert_redirected_to repositories_path
    saved = Repository.find_by!(github_id: 1)
    assert { saved.user.email == "one@test.com" }
  end

  test "#index lists repositories" do
    sign_in_by_test_session("one@test.com")
    post repositories_path, params: { repository: { github_id: 1 } }

    get repositories_path

    assert_response :success
    assert { @response.body.include?("Hexlet/hexlet-cv123") }
  end

  private

  def sign_in_by_test_session(email)
    post test_session_path, params: { email: }
  end
end
