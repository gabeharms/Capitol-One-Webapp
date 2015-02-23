require 'test_helper'

class EmployeeLoginTest < ActionDispatch::IntegrationTest

  def setup
    @employee = employees(:michael)
  end

  def teardown
    @employee = nil
  end
  
  test "login with invalid information" do
    employee_log_in_as(@employee)
    get employee_login_path
    assert_template 'employee_sessions/new'
    post employee_login_path, session: { email: "", password: "" }
    assert_template 'employee_sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with valid employee information followed by logout" do
    employee_log_in_as(@employee)
    get employee_login_path
    post employee_login_path, session: { email: @employee.email, password: 'password' }
    assert is_employee_logged_in?
    assert_redirected_to employee_tickets_path
    follow_redirect!
    assert_template 'employees/display_tickets'
    assert_select "a[href=?]", employee_login_path, count: 0
    assert_select "a[href=?]", employee_logout_path
    assert_select "a[href=?]", employee_tickets_path
    
    delete employee_logout_path
    assert_not is_employee_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    
    # Need to test to make sure _header provides proper links
    assert_select "a[href=?]", employee_login_path
    assert_select "a[href=?]", employee_logout_path,      count: 0
    assert_select "a[href=?]", employee_path(@employee), count: 0
  end
end
