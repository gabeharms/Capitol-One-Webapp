class Ticket < ActiveRecord::Base
  belongs_to :customer
  belongs_to :employee

  has_many :comments
  
  ratyrate_rateable "experience"
  
 # validates :customer_id
  validates :title, presence: true, length: { maximum: 400 }
  
  default_scope -> { order(created_at: :desc) }
  
  # Named Scopes and Logic Functions
  
  scope :order_by_desc, lambda {reorder("tickets.created_at DESC") }
  scope :order_by_asc, lambda {reorder("tickets.created_at ASC") }

  def self.search_by_status( status )
    where(ticket_status_id: status)
  end
    
  
  # Returns the correct way to sort the tickets based on filter and status params
  def self.ticket_order_least_recent(filter, status, category)
    

      if filter.nil? && status.nil? && category.nil?
        order_by_desc
      elsif filter == 'All'
        order_by_desc
      elsif !status.nil?
        where(ticket_status_id: status)
      elsif category == "0"
        where(ticket_category_id: nil)
      elsif !category.nil?
        where(ticket_category_id: category)
      end

  end
  
   # Returns the correct way to sort the tickets based on filter and status params
  def self.ticket_order_most_recent(filter, status, category)
    
    
      if filter.nil? && status.nil? && category.nil?
        order_by_asc
      elsif filter == 'All'
       order_by_asc
      elsif !status.nil?
        where(ticket_status_id: status)
      elsif category == "0"
        where(ticket_category_id: nil)
      elsif !category.nil?
        where(ticket_category_id: category)
      end
      
  end
end
