require 'discordrb'
require 'pry'
require_relative 'services/reddit_service'
SMASH_PREFIXES = ['Somalia', 'Kentucky Waterfall', 'Congo', 'Sudan', 'Alabama','Alaska','American Samoa','Arizona',
  'Arkansas','California','Colorado','Connecticut','Delaware','District of Columbia','Federated States of Micronesia',
  'Florida','Georgia','Guam','Hawaii','Idaho','Illinois','Indiana','Iowa', 'Kansas','Kentucky','Louisiana','Maine','Marshall Islands',
  'Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada',
  'New Hampshire','New Jersey','New Mexico','New York','North Carolina','NorthDakota','Northern Mariana Islands','Ohio','Oklahoma','Oregon','Palau','Pennsylvania','Puerto Rico','Rhode Island','South Carolina','South Dakota',
  'Tennessee','Texas','Utah','Vermont','Virgin Island','Virginia','Washington','West Virginia','Wisconsin','Wyoming']

bot = Discordrb::Commands::CommandBot.new token: 'MzQ3OTgzMzQxNTc3ODMwNDAx.DHgURA.9hQMk1X6Tniofmh19gvYaSeMvxg', client_id: 347983341577830401

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
