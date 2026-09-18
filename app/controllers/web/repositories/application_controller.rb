# frozen_string_literal: true

class Web::Repositories::ApplicationController < Web::ApplicationController
  private

  def resource_repository
    current_user.repositories.find params[:repository_id]
  end
end
