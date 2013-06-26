
# Add DB drivers
$: << "#{ENV['DB_DRIVERS_DIR']}"

ActiveRecord::Base.instance_eval do
  alias orig_establish_connection establish_connection

  def establish_connection env
    result = orig_establish_connection env

    #Rails.logger.info "************** Database description:\n #{description(hash)}"
    Rails.logger.info "************** Env:\n #{env}"

    result
  end

  #def description hash
  #  hash.collect{|r| "#{r[0]}=#{r[1]}"}.join(", ")
  #end

end

# require 'active_record/connection_adapters/jdbc_adapter'

# class ActiveRecord::ConnectionAdapters::JdbcAdapter
#   # This should force every connection to be closed when it gets checked back
#   # into the connection pool
#   include ActiveRecord::ConnectionAdapters::JndiConnectionPoolCallbacks
# end
