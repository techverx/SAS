class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :email
  validates_presence_of :digital_pin
  validates_presence_of :password
  validates_presence_of :password_confirmation
  has_one :profile
  has_many :emergency_contacts
  has_many :groups, through: :group_users
  has_many :group_users
  accepts_nested_attributes_for :emergency_contacts
  accepts_nested_attributes_for :profile
end
