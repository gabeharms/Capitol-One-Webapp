require 'test_helper'

class CustomerSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get customer_signup_path
    assert_no_difference 'Customer.count' do
      post customers_path, customer: { first_name:  "",
                              last_name: "",
                               email: "customer@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'customers/new'
  end
  
  test "valid signup information" do
    get customer_signup_path
    assert_difference 'Customer.count', 1 do
      post_via_redirect customers_path, customer: { first_name:  "Example",
                                            last_name: "User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'customers/show'
    assert is_customer_logged_in?
  end
end
