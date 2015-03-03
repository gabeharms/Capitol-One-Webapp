class Customer < ActiveRecord::Base
  
  has_many :tickets, dependent: :destroy
  
  before_save { email.downcase! }
  
  ratyrate_rater
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :first_name,  presence: true, length: { maximum: 50 }
  validates :last_name,   presence: true, length: { maximum: 50 }
  
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_blank: true         
  
  
  has_secure_password
  
  # Named Scopes and Logic Functions
  def self.search_by_id(id)
    if !id.nil?
      find(id)
    end
  end
  
  def self.search_by_all(search_field)
    where("lower(first_name) = ? OR lower(last_name) = ? OR lower(email) = ? OR id = ?" , search_field.downcase, search_field.downcase, search_field.downcase, search_field.downcase)
  end
  
   # Returns the hash digest of the given string.
  def Customer.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
