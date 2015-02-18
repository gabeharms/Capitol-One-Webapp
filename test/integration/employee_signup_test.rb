require 'test_helper'

class EmployeeSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get employee_signup_path
    assert_no_difference 'Employee.count' do
      post employees_path, employee: { first_name:  "",
                               last_name: "",
                               email: "employee@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'employees/new'
  end
  
  test "valid signup information" do
    get employee_signup_path
    assert_difference 'Employee.count', 1 do
      post_via_redirect employees_path, employee: { first_name:  "Example",
                                            last_name: "User",
                                            email: "employee@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    #assert_template employee_tickets_path    # Fix this once employee sign up is implemented
  end
end
