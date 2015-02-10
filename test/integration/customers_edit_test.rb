require 'test_helper'

class CustomersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @customer = customers(:michael)
  end

  test "unsuccessful edit" do
    customer_log_in_as(@customer)
    get edit_customer_path(@customer)
    assert_template 'customers/edit'
    patch customer_path(@customer), customer: { name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'customers/edit'
  end
  
  test "successful edit with friendly forwarding" do
    get edit_customer_path(@customer)
    customer_log_in_as(@customer)
    assert_redirected_to edit_customer_path(@customer)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch customer_path(@customer), customer: { name:  name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @customer
    @customer.reload
    assert_equal @customer.name,  name
    assert_equal @customer.email, email
  end
end
