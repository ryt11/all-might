

class Tone
  attr_reader :emotion_tone, :language_tone, :social_tone, :channel
  def initialize(tone_analysis, channel)
    @emotion_tone = tone_analysis["document_tone"]["tone_categories"][0]["tones"]
    @language_tone = tone_analysis["document_tone"]["tone_categories"][1]["tones"]
    @social_tone = tone_analysis["document_tone"]["tone_categories"][2]["tones"]
    @channel = channel
  end

  def tone_output(tone)
    tone_stats = tone.map { |tone| "#{tone['tone_name']}: #{(tone['score']*100).round(0)}%\n" }
    tone_stats.join(" ")
  end

  def full_response(message_len, channel_id)
    "Tone profile for <##{channel_id}> in the last #{message_len} messages: \n \n __**Emotional Tone**__ \n #{tone_output(emotion_tone)} \n \n __**Language Tone**__ \n #{tone_output(language_tone)} \n \n __**Social Tone**__ \n#{tone_output(social_tone)}"
  end

end
