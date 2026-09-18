# frozen_string_literal: true

class Test::SessionsController < Web::ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.find_or_create_by!(email: params[:email]) do |u|
      u.nickname = params[:email].split("@").first
      u.provider = "github"
      u.uid = SecureRandom.hex(8)
      u.token = "test_token"
    end
    sign_in user
    head :ok
  end
end
