class Personality

  attr_reader :user, :word_count, :needs, :personality_traits, :values

def initialize(personality, user)
  @user = user
  @word_count = personality["word_count"]
  @needs = personality["needs"]
  @personality_traits = personality["personality"]
  @values = personality["values"]
end

def emotion_output(emotion)
  emotion_stats = emotion.map { |emotion| "#{emotion['name']}: #{(emotion['percentile']*100).round(0)}%\n" }
  emotion_stats.join(" ")
end

def full_response(msg_count)
  "Personality profile for #{user} after analyzing #{word_count} words in the past #{msg_count} messages \n \n (Powered by IBM Watson :robot:)  \n \n __**Needs**__ \n #{emotion_output(needs)} \n __**Values**__ \n #{emotion_output(values)} \n __**Personality Traits**__ \n #{emotion_output(personality_traits)} "
end


end
