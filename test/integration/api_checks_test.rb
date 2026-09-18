# frozen_string_literal: true

require "test_helper"

class ApiChecksTest < ActionDispatch::IntegrationTest
  include InlineJobsConcern

  test "#create accepts a webhook and starts a check" do
    repository = repositories(:one)

    assert_difference -> { repository.checks.count }, 1 do
      post api_checks_path, params: { repository: { full_name: repository.full_name } },
                            as: :json
    end

    assert_response :ok
  end

  test "#create answers 404 for an unknown repository" do
    post api_checks_path, params: { repository: { full_name: "unknown/repo" } }, as: :json

    assert_response :not_found
  end
end
