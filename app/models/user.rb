class User < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :event_registrations
  has_one :cart  # Each user has one cart

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end




