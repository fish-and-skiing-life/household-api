class Expense < ApplicationRecord
  has_many :household
  belongs_to :user
  def self.list(user_id)
    where(user_id: user_id)
  end

  def self.create_expense(info)
    info = info.permit(:name, :product,:description, :user_id)  
    create!(info)
  end

  def update_expense(info)
    info = info.permit(:product, :description, :user_id) 
    self.update!(info)
  end

  def self.delete_expense(id)
    find(id).destroy!
  end
end
