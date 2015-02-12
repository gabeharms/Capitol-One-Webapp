class Ticket < ActiveRecord::Base
  belongs_to :customer
  belongs_to :employee

  has_many :comments
  
  validates :customer_id, presence: true
  validates :title, presence: true, length: { maximum: 140 }
  
  default_scope -> { order(created_at: :desc) }
end
