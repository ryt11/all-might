require 'faraday'
require 'json'
require_relative '../constants'

class GiphyService

  attr_reader :api_connection

  def initialize
    @api_connection = Faraday.new('http://api.giphy.com/v1/gifs/')
  end

  def search(search_param, limit=nil)
    response = api_connection.get('search') do |req|
      req.params['q'] = search_param
      req.params['limit'] = limit ? limit : 1
      req.params['api_key'] = GIPHY_API_KEY
    end

     response = JSON.parse(response.body)
     response["data"]
  end

  def random(tag=nil)
    response = api_connection.get('random') do |req|
      req.params['tag'] = tag if tag
      req.params['api_key'] = GIPHY_API_KEY
    end
    response = JSON.parse(response.body)
    response["data"]
  end


end
