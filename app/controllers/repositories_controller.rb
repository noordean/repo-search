class RepositoriesController < ApplicationController
  def index
  end

  def search
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("search_result", params[:search_term])
      end
    end
  end
end
