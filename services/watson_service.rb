require 'pry'
require 'discordrb'
require_relative '../constants'
require_relative 'parse'
require 'JSON'
require 'excon'
class WatsonService
  attr_reader :api_connection, :payload
  def initialize
    @api_connection = "https://gateway.watsonplatform.net/personality-insights/api"
  end

  def personality(json, uid)
    messages = JSON.parse(json)
    user_messages  = messages.map { |message| message["content"] if message["author"]["id"] == uid  }.compact!
    response = Excon.post(@api_connection + "/v3/profile",
      :body     => user_messages.join(" "),
      :headers  => {
        "Content-Type"            => "text/plain",
        "Content-Language"        => "en",
        "Accept-Language"         => "en"
      },
      :query    => {
        "raw_scores"              => true,
        "consumption_preferences" => true,
        "version"                 => "10-20-2016"
      },
      :user                       => WATSON_USER,
      :password                   => WATSON_PW)

      binding.pry

      JSON.parse(response.body)
    end
end
