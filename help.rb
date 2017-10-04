class Help

  def self.goals
    "\n Before setting any goals make sure you are registered by using the '!register' command. \n To make a new goal use the !new_goal command in the following format: '!new_goal goal_name, goal_duration, retroactive_time' where goal duration is the number of days you'd like to stick to your goal and retroactive_time being the amount of days, if any, you have already alotted towards your goal. \n Ex: !new_goal no smoking, 30, 5. Use '!mygoals' to track your progress.  "
  end

  def self.my_personality
    "Type '!mypersonality' to have Watson use his quirk on you."
  end

  def self.detroit_smash
    "Type '!detroitsmash' for a random gif of me in action!"
  end

  def self.ass
    "Type '!ass' to get your daily dose of ass. Careful **NSFW**"
  end

  def self.mysmash
    "Type '!mysmash' and I will tell you which smash best suits you, young man."
  end

  def self.top_reddit
    "Type '!top_reddit subreddit limit' where limit is the top x number of posts you want to see."
  end

  def self.gif
    "Type '!gif search_param' to return a gif of your liking."
  end

  def self.help_list
    "Hopefully this will shed some light on things, hero: \n \n #{my_personality} \n #{detroit_smash} \n #{ass} \n #{mysmash} \n #{top_reddit} \n #{gif} \n #{random} \n #{tone} \n #{goals}"
  end

  def self.random
    "Type '!random', or '!random parameter' (to narrow search down) for a random gif."
  end

  def self.tone
    "Type '!tone' to have Watson get a feel for the place."
  end

end
