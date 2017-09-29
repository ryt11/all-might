require 'pg'

module Databasable

  def self.connection
    @conn ||= PG::Connection.open(:dbname => 'all_might')
  end

end
