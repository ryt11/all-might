require_relative 'user'


class Goal

  attr_reader :goal_name, :retroactivity, :table_name, :duration, :user_id

  include Databasable

  def initialize(goal_name, duration, user_id, retroactive=0)
    @goal_name = goal_name
    @retroactivity = retroactive.to_i
    @table_name = "goals"
    @duration = duration.to_i
    @user_id = user_id.to_i
  end


  def create_goal
    Databasable.connection.exec_params("INSERT INTO #{table_name} (id, goal_name, duration, retroactivity, user_id)
                                       VALUES ('#{prim_key_entry}',
                                          '#{goal_name}','#{duration}', #{retroactivity}, #{user_id})")
  end

  def prim_key_entry
    res = Databasable.connection.exec_params("SELECT max(id) FROM #{table_name}")
    res.values.flatten.first.nil? ? 1 : res.values.flatten.first.to_i + 1
  end

  def self.percent_complete(duration, total_days)
    return 0.0 if total_days <= 0
    total_days.to_f / duration.to_i * 100
  end

  def self.total_days(start_date, retroactivity)
    start = Time.parse(start_date)
    ((Time.now - start) / 60 / 60 / 24).floor + retroactivity.to_i
  end

  def self.progress_bar(percentage)
    multiplier = percentage.to_i > 0 ? percentage.floor / 2 : 0
    loading_symbols = {'=' => multiplier, ' ' => 50 - multiplier}
    "[#{'.' * loading_symbols['=']}#{' ' * loading_symbols[' ']}]"
  end

end
