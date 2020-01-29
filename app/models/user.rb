class User < ApplicationRecord
  has_many :household
  has_many :exoense

  def self.from_token_payload(payload)
    find_by(sub: payload['sub']) || create!(sub: payload['sub'])
  end

  def self.list(use_id)
    find(user_id)
  end

  def self.list_by_group(group_token)
    where(group_token: groud_token)
  end

  def self.create_user(info)
    info = info.permit(:sub, :group_token)  
    create!(info)
  end

  def update_user(info)
    info = info.permit(:name, :group_token, :sub) 
    self.update!(info)
  end

  def update_group(group_token)
    self.update!({group_token: group_token})
  end

  def self.delete_user(id)
    find(id).destroy!
  end
end
