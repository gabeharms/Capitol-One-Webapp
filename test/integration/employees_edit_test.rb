require 'test_helper'

class EmployeesEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @employee = employees(:michael)
  end

  def teardown
    @employee = nil
  end

  test "unsuccessful edit" do
    employee_log_in_as(@employee)
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    patch employee_path(@employee), employee: { first_name:  "",
                               last_name: "",
                               email: "employee@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    assert_template 'employees/edit'
  end
  
  test "successful edit with friendly forwarding" do
    get edit_employee_path(@employee)
    employee_log_in_as(@employee)
    assert_redirected_to employee_tickets_path
    follow_redirect!
    
    assert_template 'employees/display_tickets'
    first_name  = "Foo"
    last_name   = "Bar"
    email = "foo@bar.com"
    patch employee_path(@employee), employee: { first_name:  first_name,
                                    last_name: last_name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @employee
    @employee.reload
    assert_equal @employee.first_name,  first_name
    assert_equal @employee.last_name,  last_name
    assert_equal @employee.email, email
  end
end
