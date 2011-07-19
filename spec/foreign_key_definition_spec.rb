require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'models/user'

describe "Foreign Key definition" do

  let(:fk_definition) { RedhillonrailsCore::ActiveRecord::ConnectionAdapters::ForeignKeyDefinition }

  it "it is dumped to sql with quoted values" do
    definition = fk_definition.new("named_fkey", :posts, :user, :users, :id)
    definition.to_sql.should == foreign_key_sql("named_fkey")
  end

  context "when name isn't given" do

    it "builds name from table and column name" do
      definition = fk_definition.new(nil, :posts, :user, :users, :id)
      definition.to_sql.should == foreign_key_sql("posts_user_fkey")
    end

    it "build name with column joined with underscore for compsite key" do
      definition = fk_definition.new(nil, :orders, [:inquiry_id, :user_id], :inquiries, [:id, :user_id])
      expected_definition = "CONSTRAINT orders_inquiry_id_user_id_fkey FOREIGN KEY \
        (#{quote_column_name("inquiry_id")}, #{quote_column_name("user_id")}) \
        REFERENCES #{quote_table_name("inquiries")} (#{quote_column_name("id")}, #{quote_column_name("user_id")})".squeeze(" ")
      definition.to_sql.should == expected_definition
    end

  end

  it "does not include name if no name or table_name is given" do
    definition = fk_definition.new(nil, nil, :user, :users, :id)
    definition.to_sql.should == foreign_key_sql(nil)
  end

  protected
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
