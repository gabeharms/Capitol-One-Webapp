require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  
  def setup
    @customer = customers(:michael)
    @other_user = customers(:archer)
    @employee = employees(:michael)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    get :edit, id: @customer
    assert_not flash.empty?
    assert_redirected_to customer_login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @customer, customer: { first_name: @customer.first_name, last_name: @customer.last_name, email: @customer.email }
    assert_not flash.empty?
    assert_redirected_to customer_login_url
  end
  
  test "should redirect edit when logged in as wrong user" do
    customer_log_in_as(@other_user)
    get :edit, id: @customer
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    customer_log_in_as(@other_user)
    patch :update, id: @customer, customer: { first_name: @customer.first_name, last_name: @customer.last_name, email: @customer.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to employee_login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Customer.count' do
      delete :destroy, id: @customer
    end
    assert_redirected_to employee_login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    customer_log_in_as(@other_user)
    assert_no_difference 'Customer.count' do
      delete :destroy, id: @customer
    end
    assert_redirected_to employee_login_url
  end
  
end
