require 'test_helper'

class CustomersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @customer = customers(:michael)
  end

  test "profile display" do
    customer_log_in_as(@customer)
    get customer_path(@customer)
    assert_template 'customers/show'
    assert_select 'title', full_title(@customer.first_name)
    assert_select 'h1', text: @customer.first_name
    assert_select 'h1>img.gravatar'
    #assert_match @customer.tickets.count.to_s, response.body
    assert_select 'div.pagination'
    @customer.tickets.paginate(page: 1).each do |ticket|
      assert_match ticket.title, response.body
    end
  end
end
