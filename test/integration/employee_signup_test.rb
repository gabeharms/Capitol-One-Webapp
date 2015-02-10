require 'test_helper'

class EmployeeSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get employee_signup_path
    assert_no_difference 'Employee.count' do
      post employees_path, employee: { name:  "",
                               email: "employee@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'employees/new'
  end
  
  test "valid signup information" do
    get employee_signup_path
    assert_difference 'Employee.count', 1 do
      post_via_redirect employees_path, employee: { name:  "Example User",
                                            email: "employee@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'employees/show'
  end
end
