class Product < ApplicationRecord
  #id (default)
  # name
  # description
  # price
  # stock
  # img lower priority
  # order_item_id (relational migration)
  # review_id (relation migration) lower priority
  # category_id *lower priority

  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_and_belongs_to_many :categories


  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true

  def avg_rating
    all_ratings = reviews.map { |review| review.rating}
    return nil if all_ratings.empty?

    average = all_ratings.sum / all_ratings.length.to_f
    return average / 10 == 0 ? average : average.round(1)
  end

  def retire
    if self.active
      return self.update(active: false)
    else
      return self.update(active: true)
    end
  end

end
