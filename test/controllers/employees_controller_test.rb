require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
  
  def setup
    @employee = employees(:michael)
    @other_user = employees(:archer)
  end

  def teardown
    @employee = nil
    @other_user = nil
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @employee
    assert_not flash.empty?
    assert_redirected_to employee_login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @employee, employee: { first_name: @employee.first_name, last_name: @employee.last_name, email: @employee.email }
    assert_not flash.empty?
    assert_redirected_to employee_login_url
  end
  
  test "should redirect edit when logged in as wrong user" do
    employee_log_in_as(@other_user)
    get :edit, id: @employee
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    employee_log_in_as(@other_user)
    patch :update, id: @employee, employee: { first_name: @employee.first_name, last_name: @employee.last_name, email: @employee.email }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
