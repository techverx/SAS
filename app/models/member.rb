class Member < ActiveRecord::Base
  belongs_to :group
  mount_uploader :avatar, AvatarUploader
end
