# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  def show
    @check = resource_repository.checks.find params[:id]

    authorize @check.repository

    if !@check.finished? && !@check.failed?
      flash[:info] = t(".check_in_progress")
      redirect_to @check.repository and return
    end

    parsed_check_log = JSON.parse(@check.check_log.presence || "{}")

    @check_result = LogFormatter.format(parsed_check_log, @check.repository.language)
  end

  def create
    authorize resource_repository, :show?

    @check = resource_repository.checks.create!

    CheckRepositoryJob.perform_later(@check.id)

    flash[:notice] = t(".check_created")
    redirect_to repository_path(resource_repository)
  end
end
