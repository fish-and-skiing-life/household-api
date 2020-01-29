class Household < ApplicationRecord
  belongs_to :user
  belongs_to :expense
  def self.list(user_id)
    where(user_id: user_id)
  end

  def self.list_by_expense(expense_id)
    where(expense_id: expense_id)
  end

  def self.list_period(started_at, ended_at)

    where(buy_at: started_at..ended_at)
  end

  def self.create_household(info)
    info = info.permit(:product, :price, :description, :user_id, :expense_id,:buy_at)  
    create!(info)
  end

  def update_household(info)
    info = info.permit(:id,:product, :price, :description, :user_id, :expense_id,:buy_at,:created_at,:updated_at) 
    self.update!(info)
  end

  def self.delete_household(id)
    find(id).destroy!
  end
end
