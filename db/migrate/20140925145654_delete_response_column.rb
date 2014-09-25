class DeleteResponseColumn < ActiveRecord::Migration
  def change
    remove_column :responses, :response
  end
end
