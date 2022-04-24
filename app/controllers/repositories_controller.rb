require 'uri'
require 'net/http'

class RepositoriesController < ApplicationController
  def index
  end

  def search
    if params[:search_term].blank?
      partial = "repositories/no_search_term"
    else
      uri = URI("https://api.github.com/search/repositories?q=#{params[:search_term]}")
      res = Net::HTTP.get_response(uri)
      # puts res.body
      body = res.body if res.is_a?(Net::HTTPSuccess)
      @repositories = JSON.parse(body)["items"]
      partial = @repositories.empty? ? "repositories/no_results" : "repositories/search_result"
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "search_result",
          partial: partial,
          locals: { repositories: @repositories }
        )
      end
    end
  end
end
