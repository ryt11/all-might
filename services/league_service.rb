require 'faraday'


class LeagueService

 :api_connection

 def initialize
   @api_connection = Faraday.new('http://na.lolesports.com/api/programmingWeek/')
 end

 def programming_blocks(date)
  api_connect.get('#{date}/-0700.json')
 end
end
