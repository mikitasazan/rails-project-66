# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def logout
    sign_out

    f(:success)

    redirect_to root_path
  end

  def callback
    user = User.find_or_initialize_by email: auth.info.email.downcase
    user.nickname = auth.info.nickname
    user.provider = auth.provider
    user.uid = auth.uid
    user.token = auth.credentials.token

    if user.save
      sign_in(user)
      f(:success)
    else
      f(:error)
    end

    redirect_to root_path
  end

  private

  def auth
    request.env["omniauth.auth"]
  end
end
