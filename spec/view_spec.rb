require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'models/user'

describe "views" do

  let(:migration) { ::ActiveRecord::Migration }

  let(:dump) do
    stream = StringIO.new
    ActiveRecord::SchemaDumper.ignore_tables = %w[users comments]
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.string
  end

  let(:view_statement) { "SELECT * FROM users where deleted_at IS NULL" }

  it "should return views" do
    with_view "active_users", view_statement do
      migration.connection.views.should have(1).view
    end
  end

  it "should be included in schema dump" do
    with_view "active_users", view_statement do
      dump.should match /active_users/
       # I don't test view definition as it is transformed to different form
       # comparing to original statement
    end
  end

  protected
  def with_view(name, definition)
    migration.suppress_messages do
      migration.create_view name, definition
      yield
      migration.drop_view name
    end
  end

end
