class User < ApplicationRecord
  enum role: { author: 0, guest: 1 }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :confirmable, :timeoutable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  after_initialize :set_default_role, if: :new_record?

  validates :name, :email, presence: true

  private

  def set_default_role
    self.role ||= :guest
  end
end
