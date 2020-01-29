class Group < ApplicationRecord
  def self.list(id)
    find(id)
  end

  def self.create_group(info, token)
    info = info.permit(:name) 
    info['group_token'] = token 
    create!(info)
  end

  def self.update_group(info)
    info = info.permit(:name) 
    self.update!(info)
  end

  def self.delete_group(id)
    find(id).destroy!
  end
end
