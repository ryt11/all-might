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

def full_response
  "(Powered by IBM Watson) Personality profile for #{user} after analyzing #{word_count} words in the past 100 messages \n \n #{emotion_output(needs)} \n #{emotion_output(values)} \n #{emotion_output(personality_traits)}"
end


end
