class User < ApplicationRecord
  # id (default)
  # username (logged in user)
  # email (logged in user)
  # order_id (create a relation migration between order and users)


  has_many :orders
  has_many :products, dependent: :destroy
  has_many :reviews
  has_many :payment_infos



  validates :username, presence: true
  #validates :email, confirmation: true


  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.username = auth_hash["info"]["nickname"]
    user.email = auth_hash["info"]["email"]
    user.photo_url = auth_hash["info"]["image"]
    return user
  end
end
