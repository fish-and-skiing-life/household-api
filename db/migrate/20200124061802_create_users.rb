class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :sub
      t.string :group_token

      t.timestamps
    end
  end
end
