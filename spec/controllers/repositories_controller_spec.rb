require "rails_helper"

RSpec.describe RepositoriesController, type: :controller do
  render_views

  describe "#search" do
    let(:url) { "https://api.github.com/search/repositories?q=search%20term" }
    let(:success_response_with_results) do
      {
        status: 200,
        body: {
            total_count: 30,
            incomplete_results: false,
            items: [{id: 1, name: 'my-search-repo'}]
        }.to_json,
        headers: {}
      }
    end
    let(:success_response_with_no_results) do
      {
        status: 200,
        body: {
            total_count: 30,
            incomplete_results: false,
            items: []
        }.to_json,
        headers: {}
      }
    end
    let(:bad_response) do
      {
        status: 400,
        headers: {}
      }
    end
    context "when no search term is provided" do
      it "should render no-search-term partial" do
        post :search, params: { search_term: '' }, format: :turbo_stream
        expect(response.body).to match /Search results will be displayed here/
      end
    end

    context "when there are results from Github API" do
      it "should render search-results partial" do
        stub_request(:get, url).to_return(success_response_with_results)

        post :search, params: { search_term: 'search term' }, format: :turbo_stream
        expect(response.body).to match /my-search-repo/
      end
    end

    context "when there is no result from Github API" do
      it "should render no-results partial" do
        stub_request(:get, url).to_return(success_response_with_no_results)

        post :search, params: { search_term: 'search term' }, format: :turbo_stream
        expect(response.body).to match /No results/
      end
    end

    context "when there is a bad response from Github API" do
      it "should render unexpected-error partial" do
        stub_request(:get, url).to_return(bad_response)

        post :search, params: { search_term: 'search term' }, format: :turbo_stream
        expect(response.body).to match /An unexpected error occurred. Please try again./
      end
    end
  end
end
