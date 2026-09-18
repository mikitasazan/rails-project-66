# frozen_string_literal: true

class GithubClientStub
  def initialize(*); end

  def repo(_github_id)
    {
      id: 2,
      language: "ruby",
      full_name: "Hexlet/hexlet-cv123",
      clone_url: "https://github.com/Hexlet/hexlet-cv123",
      ssh_url: "git@github.com:Hexlet/hexlet-cv123.git"
    }
  end

  def hooks(_repo)
    []
  end

  def create_hook(_repo, _name, _config, _options); end

  def repos(*)
    fixture_path = Rails.root.join("test/fixtures/files/user_repositories.json")

    content = File.read(fixture_path)

    repositories = JSON.parse content, symbolize_names: true

    repositories.map { |repo| GithubRepositoryStub.new(repo) }
  end
end
