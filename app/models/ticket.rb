class Ticket < ActiveRecord::Base
  belongs_to :customer
  belongs_to :employee

  has_many :comments
  
 # validates :customer_id
  validates :title, presence: true, length: { maximum: 140 }
  
  default_scope -> { order(created_at: :desc) }
  
  # Named Scopes and Logic Functions
  
  scope :order_by_desc, lambda {reorder("tickets.created_at DESC") }
  scope :order_by_asc, lambda {reorder("tickets.created_at ASC") }
  
  # Returns the correct way to sort the tickets based on filter and status params
  def self.ticket_order(filter, status, category)
    if filter.nil? && status.nil? && category.nil?
      order_by_desc
    elsif filter == 'Most_Recent'
      order_by_desc
    elsif filter == 'Least_Recent'
      order_by_asc
    elsif filter == 'All'
     order_by_desc
    elsif !status.nil?
      where(ticket_status_id: status)
    elsif !category.nil?
      where(ticket_category_id: category)
    end
  end
  
end
