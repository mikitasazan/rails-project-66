# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_to root_path, alert: t("layouts.web.flash.not_authorized")
  end
end
