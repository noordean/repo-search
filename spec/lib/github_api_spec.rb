require "rails_helper"
require "github_api"

describe GithubApi do
  describe "search_repositories" do
    let(:url) { "https://api.github.com/search/repositories?q=search%20term" }
    let(:success_response) do
      {
        status: 200,
        body: {
            total_count: 30,
            incomplete_results: false,
            items: [{id: 1, name: 'search'}]
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


    context "when a success code is returned from github" do
      it "returns fetched results" do
        stub_request(:get, url).to_return(success_response)

        response = described_class.search_repositories("search term")
        expect(response[:success]).to eq(true)
        expect(response[:results]).to eq([{"id"=> 1, "name"=>"search"}])
      end
    end

    context "when a non success code is returned from github" do
      it "returns success: false" do
        stub_request(:get, url).to_return(bad_response)

        response = described_class.search_repositories("search term")
        expect(response[:success]).to eq(false)
        expect(response[:results]).to eq([])
      end
    end

    context "when an empty search term is provided" do
      it "returns nil" do
        response = described_class.search_repositories("")
        expect(response).to eq(nil)
      end
    end
  end
end
