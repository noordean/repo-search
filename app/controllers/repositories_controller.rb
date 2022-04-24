require 'uri'
require 'net/http'
require 'github_api'

class RepositoriesController < ApplicationController
  def index
  end

  def search
    response = GithubApi.search_repositories(params[:search_term])
    partial = result_view(response)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "search_result",
          partial: partial,
          locals: { repositories: response&.dig(:results) }
        )
      end
    end
  end

  private

  def result_view(response)
    return "repositories/no_search_term" unless response
    return "repositories/unexpected_error" unless response[:success]
    return "repositories/no_results" if response[:results].empty?

    "repositories/search_result"
  end
end
