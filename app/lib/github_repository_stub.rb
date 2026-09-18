# frozen_string_literal: true

class GithubRepositoryStub
  def initialize(params)
    @params = params
  end

  def id
    @params[:id]
  end

  def language
    @params[:language]
  end

  def full_name
    @params[:full_name]
  end
end
