require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'models/post'

describe "Table definition" do

  let(:connection) { ::ActiveRecord::Migration.connection }
  
  unless ::ActiveRecord::Base.connection.class.include?(
      RedhillonrailsCore::ActiveRecord::ConnectionAdapters::Sqlite3Adapter)
  
    it "sets table_name of foreign key definition when running migrations" do
      connection.drop_table :posts
  
      connection.create_table :posts, :force => true do |t|
        t.text :body
        t.integer :user_id
        t.integer :author_id
        t.foreign_key :user_id, :users, :id
      end
      
      Post.foreign_keys.size.should == 1
      Post.foreign_keys[0].table_name.should == 'posts'
    end
    
  end

end
