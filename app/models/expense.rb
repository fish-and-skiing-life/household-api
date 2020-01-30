class Expense < ApplicationRecord
  has_many :household
  belongs_to :user
  def self.list(user_id)
    Expense.where(user_id: user_id)
  end

  def self.list_by_group(group_token)
    Expense.where(group_token: group_token)
  end

  def self.create_expense(info,group_token)
    info = info.permit(:name, :product,:description, :user_id)  
    info['group_token'] = group_token
    create!(info)
  end

  def update_expense(info, group_token)
    info = info.permit(:product, :description, :user_id, :group_token) 
    self.update!(info)
  end

  def update_group(group_token)
    self.update!({group_token: group_token})
  end

  def self.delete_expense(id)
    find(id).destroy!
  end
end
