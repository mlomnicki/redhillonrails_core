module RedhillonrailsCore
  module ActiveRecord
    module ConnectionAdapters
      module MysqlAdapterFixes

        # Mysql2 gem adds own Mysql2IndexDefinition in versions from 0.2.7 to 0.2.11.
        # We must include RedhillonrailsCore IndexDefinition to support
        # case sensitivness.
        # 0.3 line of mysql2 removes it again so hopefully we'll remove that
        # obsure piece of code too.
        def self.included(base)
          super
          if defined?(Mysql2::VERSION)
            major, minor, patch = Mysql2::VERSION.split('.')
            if minor.to_i == 2 && patch.to_i >= 7
              ::ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition.class_eval do
                include ::RedhillonrailsCore::ActiveRecord::ConnectionAdapters::IndexDefinition
              end
            end
          end
        end

      end
    end
  end
end
