require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  
  
  def setup
    @customer = Customer.new(name: "Example User", email: "user@example.com",
                                password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @customer.valid?
  end
  
  test "name should be present" do
    @customer.name = "     "
    assert_not @customer.valid?
  end
  
  test "email should be present" do
    @customer.email = "     "
    assert_not @customer.valid?
  end
  
   test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @customer.email = valid_address
      assert @customer.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @customer.email = invalid_address
      assert_not @customer.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @customer.dup
    @customer.save
    assert_not duplicate_user.valid?
  end
  
   test "password should have a minimum length" do
    @customer.password = @customer.password_confirmation = "a" * 5
    assert_not @customer.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @customer.email = mixed_case_email
    @customer.save
    assert_equal mixed_case_email.downcase, @customer.reload.email
  end
end
