class Employee < ActiveRecord::Base
  
  # Associations/Relations

  has_many :tickets
  
  before_save { email.downcase! }
  
  validates :first_name,  presence: true, length: { maximum: 50 }
  validates :last_name,   presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    
  validates :password, length: { minimum: 6 }, allow_blank: true        
  has_secure_password
  
  # Named Scopes and Logic Functions
  

  
   # Returns the hash digest of the given string.
  def Employee.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def update_rating(stars)
      self.num_of_ratings = self.num_of_ratings + 1
      self.total_stars = self.total_stars + stars
      
      self.save
  end
  
  def avg_rating
     if self.num_of_ratings == 0
        0
     else
      self.total_stars/self.num_of_ratings
     end
     
  end
  
end
