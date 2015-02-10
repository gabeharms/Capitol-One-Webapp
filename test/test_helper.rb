ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  # Returns true if a test user is logged in.
  def is_customer_logged_in?
    !session[:customer_id].nil?
  end

  # Returns true if a test user is logged in.
  def is_employee_logged_in?
    !session[:employee_id].nil?
  end
  
  # Logs in a test user.
  def customer_log_in_as(customer, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post customer_login_path, session: { email:       customer.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:customer_id] = customer.id
    end
  end

  # Logs in a test user.
  def employee_log_in_as(employee, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post employee_login_path, session: { email:       employee.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:employee_id] = employee.id
    end
  end
  
  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
  
  # Add more helper methods to be used by all tests here...
end
