class Household < ApplicationRecord
  belongs_to :user
  belongs_to :expense
  def self.list(user_id)
    where(user_id: user_id)
  end

  def self.list_by_group(group_token)
    where(group_token: group_token)
  end

  def self.list_by_expense(expense_id)
    where(expense_id: expense_id)
  end

  def self.list_period_by_group(started_at, ended_at, group_token)
    where(group_token: group_token).where(buy_at: started_at..ended_at)
  end

  def self.list_period_by_user(started_at, ended_at, user_id)
    where(user_id: user_id).where(buy_at: started_at..ended_at)
  end

  def self.create_household(info,group_token)
    info = info.permit(:product, :price, :description, :user_id, :expense_id,:buy_at)  
    info['group_token'] = group_token
    create!(info)
  end

  def update_household(info)
    info = info.permit(:id,:product, :price, :description, :user_id, :expense_id,:buy_at,:created_at,:updated_at, :group_token) 
    self.update!(info)
  end

  def update_group(group_token)
    self.update!({group_token: group_token})
  end

  def self.delete_household(id)
    find(id).destroy!
  end
end
