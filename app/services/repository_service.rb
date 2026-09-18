# frozen_string_literal: true

class RepositoryService
  class << self
    def update_info_from_github(repository)
      github_client = ApplicationContainer[:github_client]
      client = github_client.new access_token: repository.user.token, auto_paginate: true

      repository_info = client.repo(repository.github_id)

      repository.update(
        full_name: repository_info[:full_name],
        name: repository_info[:name] || repository_info[:full_name],
        language: repository_info[:language]&.downcase,
        clone_url: repository_info[:clone_url]
      )
    end
  end
end
