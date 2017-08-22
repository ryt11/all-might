require 'discordrb'
require 'pry'
require_relative 'services/reddit_service'
require_relative 'services/watson_service'
require_relative 'constants'
require_relative 'personality'


bot = Discordrb::Commands::CommandBot.new token: TOKEN, client_id: CLIENT_ID

puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'



bot.message(start_with: '!top_reddit') do |event|
  subreddit = event.message.content.split(" ")[1]
  limit = event.message.content.split(" ")[2]
  response = RedditService.new.top_posts(subreddit, limit)
  posts = response[:data][:children]
  reddit_post_controller(posts, subreddit, event, limit)
end



bot.message(start_with: '!ass') do |event|
  subreddit = "ass"
  limit = 5
  response = RedditService.new.top_posts(subreddit, limit)
  posts = response[:data][:children]
  reddit_post_controller(posts, subreddit, event, limit)
end

bot.message(start_with: '!mypersonality') do |event|
  messages = []
  until messages.length == 500
    prev_count = messages.length
    messages.empty? ? messages += JSON.parse(Discordrb::API::Channel.messages(TOKEN, event.channel.id, 100)) : messages += JSON.parse(Discordrb::API::Channel.messages(TOKEN, event.channel.id, 100, messages.last["id"]))
    break if prev_count == messages.length
  end
  results = WatsonService.new.personality(messages, event.user.id.to_s)
  py = Personality.new(results, event.user.name)
  event.respond py.full_response(messages.length)
end



def message_controller(message, event, error='')
  event.respond message + error
end

def reddit_post_controller(posts, subreddit, event, limit)
  successful = "Here you go young man #{event.user.name}: the top #{posts.length} posts on /r/#{subreddit}"
  unsuccessful = " (#{limit.to_i - posts.length} missing or could not be located from original request of #{limit})"
    posts.each_with_index do |post, index|
      url = post[:data][:url]
        if index == 0 && posts.length != limit.to_i
          message_controller("#{successful} {url}", event, unsuccessful)
        elsif index == 0
          message_controller("#{successful} {url}", event)
        else
          event.respond url
        end
      end
end







bot.run
