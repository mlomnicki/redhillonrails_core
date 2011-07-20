module RedhillonrailsCore
  module ActiveRecord
    module ConnectionAdapters
      module Column
        attr_writer :unique_scope
        attr_writer :case_sensitive

        def unique_scope
          ActiveSupport::Deprecation.warn "[redhillonrails_core] column.unique_scope is deprecated and will be removed in 2.0"
          @unique_scope
        end

        def case_sensitive
          ActiveSupport::Deprecation.warn "[redhillonrails_core] column.case_sensitive is deprecated and will be removed in 2.0"
          @case_sensitive
        end

        alias :case_sensitive? :case_sensitive

        def unique?
          ActiveSupport::Deprecation.warn "[redhillonrails_core] column.unique? is deprecated and will be removed in 2.0"
          !unique_scope.nil?
        end

        def required_on
          if null
            nil
          elsif default.nil?
            :save
          else
            :update
          end
        end
      end
    end
  end
end
