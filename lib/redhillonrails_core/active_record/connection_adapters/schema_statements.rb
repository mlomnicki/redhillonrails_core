module RedhillonrailsCore::ActiveRecord::ConnectionAdapters
  module SchemaStatements
    def self.included(base)
      base.module_eval do
        alias_method_chain :create_table, :redhillonrails_core
      end
    end
  
    def create_table_with_redhillonrails_core(name, options = {})
      create_table_without_redhillonrails_core(name, options) do |table_definition|
        table_definition.name = name
        yield table_definition if block_given?
      end
    end
  end
end
