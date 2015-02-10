require 'test_helper'

class CustomersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @customer = customers(:michael)
  end
  
  test "login with invalid information" do
    customer_log_in_as(@customer)
    get customer_login_path
    assert_template 'customer_sessions/new'
    post customer_login_path, session: { email: "", password: "" }
    assert_template 'customer_sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with valid information followed by logout" do
    customer_log_in_as(@customer)
    get customer_login_path
    post customer_login_path, session: { email: @customer.email, password: 'password' }
    assert is_customer_logged_in?
    assert_redirected_to @customer
    follow_redirect!
    assert_template 'customers/show'
    assert_select "a[href=?]", customer_login_path, count: 0
    assert_select "a[href=?]", customer_logout_path
    assert_select "a[href=?]", customer_path(@customer)
    
    delete customer_logout_path
    assert_not is_customer_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    
    # Need to test to make sure _header provides proper links
    assert_select "a[href=?]", customer_login_path
    assert_select "a[href=?]", customer_logout_path,      count: 0
    assert_select "a[href=?]", customer_path(@customer), count: 0
  end
end
