class GithubApi
  BASE_URL = "https://api.github.com"

  def self.search_repositories(search_term)
    return if search_term.blank?

    uri = URI("#{BASE_URL}/search/repositories?q=#{search_term}")
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      repositories = JSON.parse(res.body)["items"]
      { success: true, results: repositories }
    else
      # Log or send to an error-tracking tool
      Rails.logger.error "GithubApi Error: #{res.body}"
      { success: false, results: [] }
    end
  end
end
