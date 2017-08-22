require 'pry'
require 'discordrb'
require_relative '../constants'
require_relative 'parse'
require 'JSON'
require 'excon'
class WatsonService
  attr_reader :api_connection, :payload
  def initialize
    @api_connection = "https://gateway.watsonplatform.net/"
  end

  def personality(messages, uid)
    user_messages  = messages.map { |message| message["content"] if message["author"]["id"] == uid  }.compact!
    response = Excon.post(@api_connection + "personality-insights/api/v3/profile",
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
      :user                       => WATSON_PERSONALITY_USER,
      :password                   => WATSON_PERSONALITY_PW)


      JSON.parse(response.body)
    end

    def tone(messages)
      content = get_content(messages)
      response = Excon.post(@api_connection + "tone-analyzer/api/v3/tone",
       :body     => content.join(" "),
        :headers  => {
          "Content-Type"            => "text/plain",
          "Content-Language"        => "en",
          "Accept-Language"         => "en"
        },
        :query    => {
          "version"                 => "2016-05-19"
        },
        :user                       => WATSON_TONE_USER,
        :password                   => WATSON_TONE_PW)


        JSON.parse(response.body)
    end

    def get_content(messages)
      messages.map {|message| message["content"]}
    end
end
