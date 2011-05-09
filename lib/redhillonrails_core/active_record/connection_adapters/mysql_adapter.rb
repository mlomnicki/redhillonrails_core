module RedhillonrailsCore
  module ActiveRecord
    module ConnectionAdapters
      module MysqlAdapter
        def self.included(base)
          base.class_eval do
            alias_method_chain :remove_column, :redhillonrails_core
            alias_method_chain :structure_dump, :views
          end
        end

        def remove_foreign_key(table_name, foreign_key_name, options = {})
          execute "ALTER TABLE #{quote_table_name(table_name)} DROP FOREIGN KEY #{foreign_key_name}"
        end

        def remove_column_with_redhillonrails_core(table_name, column_name)
          foreign_keys(table_name).select { |foreign_key| foreign_key.column_names.include?(column_name.to_s) }.each do |foreign_key|
            remove_foreign_key(table_name, foreign_key.name)
          end
          remove_column_without_redhillonrails_core(table_name, column_name)
        end

        def foreign_keys(table_name, name = nil)
          results = execute("SHOW CREATE TABLE #{quote_table_name(table_name)}", name)

          foreign_keys = []

          results.each do |row|
            row[1].lines.each do |line|
              if line =~ /^  CONSTRAINT [`"](.+?)[`"] FOREIGN KEY \([`"](.+?)[`"]\) REFERENCES [`"](.+?)[`"] \((.+?)\)( ON DELETE (.+?))?( ON UPDATE (.+?))?,?$/
                name = $1
                column_names = $2
                references_table_name = $3
                references_column_names = $4
                on_update = $8
                on_delete = $6
                on_update = on_update.downcase.gsub(' ', '_').to_sym if on_update
                on_delete = on_delete.downcase.gsub(' ', '_').to_sym if on_delete

                foreign_keys << ForeignKeyDefinition.new(name,
                                                         table_name, column_names.gsub('`', '').split(', '),
                                                         references_table_name, references_column_names.gsub('`', '').split(', '),
                                                         on_update, on_delete)
              end
            end
          end

          foreign_keys
        end

        def reverse_foreign_keys(table_name, name = nil)
          results = execute(<<-SQL, name)
        SELECT constraint_name, table_name, column_name, referenced_table_name, referenced_column_name
          FROM information_schema.key_column_usage
         WHERE table_schema = SCHEMA()
           AND referenced_table_schema = table_schema
         ORDER BY constraint_name, ordinal_position;
          SQL
          current_foreign_key = nil
          foreign_keys = []

          results.each do |row|
            next unless table_name.casecmp(row[3]) == 0
            if current_foreign_key != row[0]
              foreign_keys << ForeignKeyDefinition.new(row[0], row[1], [], row[3], [])
              current_foreign_key = row[0]
            end

            foreign_keys.last.column_names << row[2]
            foreign_keys.last.references_column_names << row[4]
          end

          foreign_keys
        end

        def views(name = nil)
          views = []
          execute("SHOW FULL TABLES WHERE TABLE_TYPE='VIEW'", name).each{|row| views << row[0]}
          views
        end

        def view_definition(view_name, name = nil)
          select_one("SHOW CREATE VIEW #{quote_table_name(view_name)}", name)["Create View"]
        end

        def structure_dump_with_views
          structure = structure_dump_without_views

          views.each do |view|
            structure += view_definition(view) + ";\n\n"
          end

          structure
        end

      end
    end
  end
end
