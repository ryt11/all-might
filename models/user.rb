require_relative '../config/databasable.rb'

class User

  attr_reader :user_name, :discord_id, :table_name, :uniqueness, :welcome

  include Databasable

  def initialize(discord_id, user_name)
    @discord_id = discord_id
    @user_name = user_name
    @table_name = "users"
    @uniqueness = "You are already registered, #{@user_name}."
    @welcome = "Welcome, #{@user_name} you have successfully registered."
  end


  def self.goals(discord_id)
    Databasable.connection.exec_params("SELECT * FROM goals WHERE goals.user_id = #{User.find(discord_id)["id"]} ORDER BY start_date DESC")
  end

  def self.find(discord_id)
    Databasable.connection.exec_params("SELECT * FROM users WHERE discord_id = '#{discord_id}'").first
  end

  def prim_key_entry
    res = Databasable.connection.exec_params("SELECT max(id) FROM #{table_name}")
    res.values.flatten.first.nil? ? 1 : res.values.flatten.first.to_i + 1
  end

  def nonexistent
    res = Databasable.connection.exec_params("SELECT discord_id FROM users WHERE discord_id = '#{discord_id}'")
    empty_query(res)
  end

  def empty_query(pg_res)
    pg_res.num_tuples.zero?
  end

  def register
    Databasable.connection.exec_params("INSERT INTO #{table_name} VALUES ('#{prim_key_entry}', '#{discord_id}', '#{user_name}')")
  end
end
