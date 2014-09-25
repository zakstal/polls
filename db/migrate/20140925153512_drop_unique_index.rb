class DropUniqueIndex < ActiveRecord::Migration
  def up
    remove_index :responses, :user_id
    add_index :responses, :user_id
  end

  def down
    remove_index :responses, :user_id
    add_index :responses, :user_id, unique: true
  end
end
