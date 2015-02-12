class Comment < ActiveRecord::Base
  
  belongs_to :employee
  belongs_to :ticket
  
  
   validates :message, presence: true, length: { maximum: 140 }
  
   validate :at_least_one
   
   
   def at_least_one
      if ticket.blank? and employee.blank?
          errors.add(:base, "You must fill in at least one field")
      end
   end
    
  
end
