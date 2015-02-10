require 'test_helper'

class EmployeesEditTest < ActionDispatch::IntegrationTest
  
  
  def setup
    @employee = employees(:michael)
  end

  test "unsuccessful edit" do
    employee_log_in_as(@employee)
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    patch employee_path(@employee), employee: { name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'employees/edit'
  end
  
  test "successful edit with friendly forwarding" do
    get edit_employee_path(@employee)
    employee_log_in_as(@employee)
    assert_redirected_to edit_employee_path(@employee)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch employee_path(@employee), employee: { name:  name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @employee
    @employee.reload
    assert_equal @employee.name,  name
    assert_equal @employee.email, email
  end
end
