require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'models/post'

describe "Table definition" do

  let(:connection) { ::ActiveRecord::Migration.connection }

  unless ::ActiveRecord::Base.connection.class.include?(
      RedhillonrailsCore::ActiveRecord::ConnectionAdapters::Sqlite3Adapter)

    it "sets table_name of foreign key definition when running migrations" do
      connection.create_table :votes, :force => true do |t|
        t.integer :kind
        t.integer :application_id
        t.integer :user_id
        t.foreign_key :user_id, :users, :id
      end

      Vote = Class.new(ActiveRecord::Base)
      Vote.foreign_keys.size.should == 1
      Vote.foreign_keys[0].table_name.should == 'votes'
      connection.drop_table :votes
    end

  end

end
