class User < ApplicationRecord
  has_many :household
  has_many :exoense

  def self.from_token_payload(payload)
    find_by(sub: payload['sub']) || create!(sub: payload['sub'])
  end

  def self.list(use_id)
    find(user_id)
  end

  def self.list_by_group(group_id)
    where(groud_id: group_id)
  end

  def self.create_user(info)
    info = info.permit(:sub, :group_id)  
    create!(info)
  end

  def self.update_group(info)
    info = info.permit(:group_id) 
    self.update!(info)
  end

  def self.update_name(info)
    logger.debug('-check---------------------------')
    info = info.permit(:id,:name)
    logger.debug('-check---------------------------')
    self.update!(info)
  end

  def self.delete_user(id)
    find(id).destroy!
  end
end
