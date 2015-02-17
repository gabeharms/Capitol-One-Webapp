class Comment < ActiveRecord::Base
  
  belongs_to :employee
  belongs_to :ticket
  
  
   validates :message, presence: true, length: { maximum: 140 }
  
   validate :at_least_one
   
   mount_uploader :picture, PictureUploader
   
   validate  :picture_size
   
   private
   
     def at_least_one
        if ticket.blank? and employee.blank?
            errors.add(:base, "You must fill in at least one field")
        end
     end
      
     # Validates the size of an uploaded picture.
      def picture_size
        if picture.size > 5.megabytes
          errors.add(:picture, "should be less than 5MB")
        end
      end
    
end
