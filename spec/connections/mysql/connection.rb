print "Using MySQL\n"
require 'logger'

ActiveRecord::Base.logger = Logger.new("debug.log")

ActiveRecord::Base.configurations = {
  'redhillonrails' => {
    :adapter => 'mysql',
    :database => 'rhcore_test',
    :username => 'rhcore',
    :encoding => 'utf8',
    :socket => '/var/run/mysqld/mysqld.sock',
    :min_messages => 'warning'
  }
}

ActiveRecord::Base.establish_connection 'redhillonrails'
