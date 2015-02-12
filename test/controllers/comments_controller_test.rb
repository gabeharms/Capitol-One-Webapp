require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  
  def setup
    @comment= comments(:example)
    @customer = customers(:michael)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Comment.count' do
      post :create, comment: { id: @customer.tickets.first.id, message: "Lorem ipsum" }
    end
    assert_redirected_to customer_login_url
  end

  test "should redirect to root_url if not valid" do
    customer_log_in_as(@customer)
    assert_no_difference 'Comment.count' do
      post :create, comment: { id: @customer.tickets.first.id, message: "" }
    end
    assert_redirected_to root_url
  end
  
  test "should add comment to customer" do
    customer_log_in_as(@customer)
    assert @customer.tickets.first.comments.build(message: "heyyy").valid?
    assert_difference 'Comment.count', 1 do
      post :create, comment: { id: @customer.tickets.first.id, message: "Lorem ipsum" }
    end
    assert_redirected_to @customer
    
  end
  
end