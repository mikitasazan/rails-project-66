# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories.order(id: :desc)
  end

  def show
    @repository = Repository.find params[:id]

    authorize @repository

    @checks = @repository.checks.order(id: :desc)
  end

  def new
    github_client = ApplicationContainer[:github_client]
    client = github_client.new access_token: current_user.token, auto_paginate: true

    permitted_languages = Repository.language.values

    cache_key = "#{current_user.cache_key_with_version}/github_repositories"
    github_repositories = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      client.repos(user: current_user.nickname)
    end

    @repositories_collection = github_repositories
                                 .select { |repository| permitted_languages.include?(repository.language&.downcase) }

    @repository = current_user.repositories.build
  end

  def create
    @repository = current_user.repositories.find_or_initialize_by repository_params

    if @repository.save
      UpdateInfoRepositoryJob.perform_later(@repository.id)
      redirect_to repositories_path, notice: t(".success")
    else
      flash[:error] = @repository.errors.full_messages.join("\n")
      redirect_to action: :new
    end
  end

  private

  def repository_params
    params.expect(repository: [:github_id])
  end
end
