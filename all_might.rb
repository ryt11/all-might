require 'discordrb'
require 'pry'
require_relative 'services/reddit_service'
require_relative 'constants'


bot = Discordrb::Commands::CommandBot.new token: TOKEN, client_id: CLIENT_ID

puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.command :user do |event|
  "Test Complete"
end

bot.message(start_with: '!mysmash') do |event|
 event.respond "Dont worry young man, you would easily defeat your foes with your signature move: #{SMASH_PREFIXES.sample}u SMAAAASH"
end


bot.message(start_with: '!help') do |event|
  event.respond """
  Type !mysmash to find out what your smash is.
Type !top_reddit subreddit limit   (limit is the top x posts you want)
Type !ass for just some ass.
  """
end

bot.message(start_with: '!top_reddit') do |event|
  subreddit = event.message.content.split(" ")[1]
  limit = event.message.content.split(" ")[2]
  response = RedditService.new.top_posts(subreddit, limit)
  response[:data][:children].each_with_index do |post, index|
    url = post[:data][:url]
    if index == 0
      event.respond "Here you go young man #{event.user.name}: the top #{limit} posts on /r/#{subreddit} #{url}"
    else
      event.respond url
    end
  end
end

bot.message(start_with: '!ass') do |event|
  subreddit = "ass"
  limit = 5
  response = RedditService.new.top_posts(subreddit, limit)
  response[:data][:children].each_with_index do |post, index|
    url = post[:data][:preview][:images][0][:source][:url]
    if index == 0
      event.respond "Here you go young man #{event.user.name}: the top #{limit} posts on /r/#{subreddit} #{url}"
    else
      event.respond url
    end
  end
end


bot.run
