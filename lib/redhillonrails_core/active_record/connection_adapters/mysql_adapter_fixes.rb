module RedhillonrailsCore
  module ActiveRecord
    module ConnectionAdapters
      module MysqlAdapterFixes

        # Starting from mysql2 0.2.7 Mysql2IndexDefinition is used.
        # In 0.2 line it is inculuded in gem itself.
        # Starting from version 0.3 it has gone to active_record mysql adapter
        # We have to additionally monkey patch it.
        def self.included(base)
          super
          if defined?(::ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition)
            ::ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition.class_eval do
              include ::RedhillonrailsCore::ActiveRecord::ConnectionAdapters::IndexDefinition
            end
          end
        end

      end
    end
  end
end
