require 'uri'
require 'net/http'

class RepositoriesController < ApplicationController
  def index
  end

  def search
    uri = URI("https://api.github.com/search/repositories?q=#{params[:search_term]}")
    res = Net::HTTP.get_response(uri)
    # puts res.body
    body = res.body if res.is_a?(Net::HTTPSuccess)
    @repositories = JSON.parse(body)["items"]

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "search_result",
          partial: "repositories/search_result",
          locals: { repositories: @repositories }
        )
      end
    end
  end
end
