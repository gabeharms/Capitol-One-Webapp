require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  
  # called before every test
  def setup
    @comment = comments(:example)
    @customer = customers(:michael)
    @employee = employees(:archer)
  end

  # called after every test
  def teardown
    @comment = nil
    @customer = nil
    @employee = nil
  end

  test "should redirect create when customer or employee not logged in" do
    assert_no_difference 'Comment.count' do
      post :create, comment: { id: @customer.tickets.first.id, message: "Lorem ipsum" }
    end
    assert_redirected_to customer_login_path
  end

  test "should redirect to root_url if customer comment not valid" do
    customer_log_in_as(@customer)
    assert_no_difference 'Comment.count' do
      post :create, comment: { id: @customer.tickets.first.id, message: "" }
    end
    assert_redirected_to Ticket.first
  end
  
  test "should add comment to customer" do
    customer_log_in_as(@customer)
    assert @customer.tickets.first.comments.build(message: "heyyy").valid?
    assert_difference 'Comment.count', 1 do
      post :create, comment: { id: @customer.tickets.first.id, message: "Lorem ipsum" }
    end
    assert_redirected_to Ticket.first
  end
  
  test "should redirect create when employee not logged in" do
    assert_no_difference 'Comment.count' do
      post :create, comment: { id: Ticket.first.id, message: "Lorem ipsum" }
    end
    assert_redirected_to customer_login_path
  end

  test "should redirect to root_url if employee comment not valid" do
    employee_log_in_as(@employee)
    assert_no_difference 'Comment.count' do
      post :create, comment: { id: Ticket.first.id, message: "" }
    end
    assert_redirected_to Ticket.first
  end
  
  test "should add comment to employee" do
    employee_log_in_as(@employee)
    assert_difference 'Comment.count', 1 do
      post :create, comment: { id: Ticket.first.id, message: "Lorem ipsum" }
    end
    assert_redirected_to Ticket.first
  end



end