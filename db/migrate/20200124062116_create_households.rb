class CreateHouseholds < ActiveRecord::Migration[5.2]
  def change
    create_table :households do |t|
      t.string :product
      t.integer :expense_id
      t.integer :price
      t.string :description
      t.date :buy_at
      t.integer :user_id
      t.string :group_token

      t.timestamps
    end
  end
end
