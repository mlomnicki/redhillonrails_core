require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'models/user'

describe "Foreign Key definition" do

  let(:definition) { RedhillonrailsCore::ActiveRecord::ConnectionAdapters::ForeignKeyDefinition.new("named_fkey", :posts, :user, :users, :id) }
  
  let(:definition_without_fkey_name) { RedhillonrailsCore::ActiveRecord::ConnectionAdapters::ForeignKeyDefinition.new(nil, :posts, :user, :users, :id) }

  let(:definition_with_no_names) { RedhillonrailsCore::ActiveRecord::ConnectionAdapters::ForeignKeyDefinition.new(nil, nil, :user, :users, :id) }

  it "it is dumped to sql with quoted values" do
    definition.to_sql.should == foreign_key_sql("named_fkey")
  end
  
  it "builds name from table and column names when no name is given" do
    definition_without_fkey_name.to_sql.should == foreign_key_sql("posts_user_fkey")
  end

  it "does not include name if no name or table_name is given" do
    definition_with_no_names.to_sql.should == foreign_key_sql(nil)
  end

  def quote_table_name(table)
    ActiveRecord::Base.connection.quote_table_name(table)
  end

  def quote_column_name(column)
    ActiveRecord::Base.connection.quote_column_name(column)
  end
  
  def foreign_key_sql(fk_name)
    [("CONSTRAINT #{fk_name}" if fk_name), "FOREIGN KEY (#{quote_column_name('user')}) "\
        "REFERENCES #{quote_table_name('users')} (#{quote_column_name('id')})"].compact.join(' ')
  end

end
