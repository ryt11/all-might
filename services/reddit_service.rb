require 'faraday'
require 'pry'
require 'JSON'

class RedditService

  attr_reader :api_connection

  def initialize
    @api_connection = Faraday.new('https://www.reddit.com/r/')
  end

  def top_posts(subreddit, limit=5)
    response = api_connection.get do |req|
      req.url "#{subreddit}/top.json?limit=#{limit}"
    end
     parse(response.body)
  end

  def parse(response)
    JSON.parse(response, symbolize_names: true)
  end
end
