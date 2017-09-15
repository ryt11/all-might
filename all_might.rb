require 'discordrb'
require 'pry'
require_relative 'services/reddit_service'
require_relative 'services/watson_service'
require_relative 'services/giphy_service'
require_relative 'constants'
require_relative 'personality'
require_relative 'tone'
require_relative 'help'
# require 'imdb_party'




bot = Discordrb::Commands::CommandBot.new token: TOKEN, client_id: CLIENT_ID

puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'


bot.message(start_with: '!help') do |event|
  event.respond Help.help_list
end


bot.message do |event|
 if event.message.content.include?('http')
  event.server.channels[5].send(event.message.content) unless event.channel.id == event.server.channels[5].id
 end
end

bot.message(start_with: '!top_reddit') do |event|
  request = event.message.content.split(" ")
  subreddit = request[1]
  limit = request[2] && request[2].to_i <= 20 ? request[2] : 5
  response = RedditService.new.top_posts(subreddit, limit)
  posts = response[:data][:children]
  reddit_post_controller(posts, subreddit, event, limit)
end

bot.message(start_with: '!random') do |event|
  origin_msg = event.message.content
  response = origin_msg.length > 7 ? GiphyService.new.random(origin_msg[8..-1]) : GiphyService.new.random
  event.respond response["url"]
end

bot.message(start_with: '!gif') do |event|
  response = GiphyService.new.search(event.message.content[9..-1])

  response.each do |gif|
    event.respond gif["url"]
  end
end

bot.message(start_with: '!detroit_smash') do |event|
  response = GiphyService.new.search('detroit smash all might hero academia', 20)
  event.respond(response.sample["url"])
end

bot.message(start_with: '!buzzme') do |event|
  response = GiphyService.new.search('eric andre', 20)
  event.respond(response.sample["url"])
end

bot.message(start_with: '!ass') do |event|
  subreddit = "ass"
  limit = 5
  response = RedditService.new.top_posts(subreddit, limit)
  posts = response[:data][:children]
  reddit_post_controller(posts, subreddit, event, limit)
end

bot.message(start_with: '!tone') do |event|
  messages = retrieve_messages(2000, event)
  watson_serv = WatsonService.new(event.user.id, messages)
  response = watson_serv.tone
  tone = Tone.new(response, event.channel.name)
  event.respond " A score less than 50% indicates that the tone is unlikely to be perceived in the content; a score greater than 75% indicates a high likelihood that the tone is perceived. \n \n #{tone.full_response(messages.length, event.channel.id)}"
end

bot.message(start_with: '!mypersonality') do |event|
  messages = retrieve_messages(1000, event)
  watson_serv = WatsonService.new(event.user.id.to_s, messages)
  response = watson_serv.personality
  py = Personality.new(response, event.user.name)
  event.respond "#{event.user.name}'s random quote of the day '#{watson_serv.personality_messages.sample}'. \n \n #{py.full_response(messages.length)}"
end

def message_controller(message, event, error='', nsfw, first)
  if nsfw && first
    event.server.channels[2].send(message + error)
    event.respond("Ahh, my eyes.. go over here to look at that <##{event.server.channels[2].id}>") if event.channel.id != event.server.channels[2].id
  elsif nsfw
    event.server.channels[2].send(message + error)
  else
    event.respond(message + error)
  end
end

def reddit_post_controller(posts, subreddit, event, limit)
  successful = "Here you go young man #{event.user.name}: the top #{posts.length} posts on /r/#{subreddit}"
  unsuccessful = " (#{limit.to_i - posts.length} missing or could not be located from original request of #{limit})"
  nsfw = "Ahh, my eyes.. go over here to look at that <##{event.server.channels[2].id}>"
    posts.each_with_index do |post, index|
      nsfw = post[:data][:over_18]
      url = post[:data][:url]
      first = index == 0
        if first && posts.length != limit.to_i
          message_controller("#{successful} #{url}", event, unsuccessful, nsfw, first)
        elsif first
          message_controller("#{successful} #{url}", event, '', nsfw, first)
        else
          message_controller(url, event, '', nsfw, first)
        end
      end
end

def retrieve_messages(limit, event)
  messages = []
  until messages.length == limit
    prev_count = messages.length
    messages.empty? ? messages += JSON.parse(Discordrb::API::Channel.messages(TOKEN, event.channel.id, 100)) : messages += JSON.parse(Discordrb::API::Channel.messages(TOKEN, event.channel.id, 100, messages.last["id"]))
    break if prev_count == messages.length
  end
  data_sanitize(messages)
end

def data_sanitize(messages)
  messages.reject {|message| sanitize_check(message) }
end

def sanitize_check(message)
  message['content'][0] == '!' || message["author"]["id"] == "347983341577830401" || message['content'].include?('http')
end


bot.run
