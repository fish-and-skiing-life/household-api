class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.string :name
      t.string :description
      t.integer :user_id
      t.string :group_token

      t.timestamps
    end
  end
end
