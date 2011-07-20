require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Migration" do

  let(:migration) { ActiveRecord::Migration }

  it "should allow to remove more then one column at once" do
    migration.suppress_messages do
      migration.create_table :likes, :id => false, :force => true do |t|
        t.string :remarks
        t.integer :post_id
        t.datetime :created_at
      end
      migration.remove_columns :likes, :post_id, :created_at
      migration.connection.columns(:likes).should have(1).column
      migration.drop_table :likes
    end
  end

end
