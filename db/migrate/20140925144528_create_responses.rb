class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.text :response
      t.integer :user_id
      t.integer :answer_choice_id

      t.timestamps
    end

    add_index :responses, :user_id, unique: true
    add_index :responses, :answer_choice_id
  end
end
