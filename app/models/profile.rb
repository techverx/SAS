class Profile < ActiveRecord::Base
  has_many :groups
  belongs_to :user
  accepts_nested_attributes_for :groups
end
