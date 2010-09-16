require 'test_helper'

class TipsControllerTest < ActionController::TestCase
  def setup
    # almost all requests are expected to be xhr
    @request.env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'
  end




  test "create" do
    get :create, {:id => 1, :new_tip_name => 'my tip', :result => 'edit'}, {:id => 1}
    assert_template 'tips/_edit'
    assert_response :success
  end

  test "create - no user" do
    get :create, {:id => 1, :new_tip_name => 'my tip'}
    assert_response 401
  end

  test "create - wrong user" do
    get :create, {:id => 1, :new_tip_name => 'my tip'}, {:id => 2}
    assert_response 403
  end

  test "update" do
    tip_data = {'1' => {}, '2' => {}};
    tip_data['1']['name'] = 'Ipanema beach'
    tip_data['2']['url'] = 'museum.org'
    tip_data['2']['address'] = {'address' => 'museum st. 1'}

    get :update, {:id => 1, :tips => tip_data}, {:id => 1}
    assert_response :success
    assert_equal 'Ipanema beach', Tip.find(1).name
    assert_equal 'museum.org', Tip.find(2).url
    assert_equal 'museum st. 1', Tip.find(2).address.address

    assert_no_errors
  end

  test "update - no user" do
    get :update, {:id => 1, :tips => {}}
    assert_response 401
  end

  test "update - wrong user" do
    get :update, {:id => 1, :tips => {}}, {:id => 2}
    assert_response 403
  end

  test "update - validation error" do
    tip_data = {'1' => {}, '2' => {}};
    tip_data['1']['name'] = 'Ipanema beach'
    tip_data['2']['url'] = 'museum.org'
    tip_data['2']['address'] = {'address' => 'museum st. 1'}
    tip_data['2']['name'] = ''

    get :update, {:id => 1, :tips => tip_data}, {:id => 1}
    assert_response :success


    # check that old values are there
    # can't test this, because sqlite3 (apparently) doesn't support enough of transactions
    # checked manually in development environment
#    assert_equal 'beach', Tip.find(1).name
#    assert_equal 'go-museum.com', Tip.find(2).url
#    assert_equal 'museum street 1', Tip.find(2).address.address
#    assert_equal 'museum', Tip.find(2).name

    assert_equal 1, assigns["errors"].size
    assert_not_nil assigns["errors"]['tips[2][name]']
  end

  test "follow url" do
    @request.env['HTTP_X_REQUESTED_WITH'] = nil
    get :follow_url, {:id => 1, :tip_id => 2}
    assert_redirected_to 'http://go-museum.com'
  end

  test "follow url - no guide" do
    @request.env['HTTP_X_REQUESTED_WITH'] = nil
    get :follow_url, {:id => 33, :tip_id => 2}
    assert_template :missing
    assert_response :success
  end

  test "follow url - no tip" do
    @request.env['HTTP_X_REQUESTED_WITH'] = nil
    get :follow_url, {:id => 1, :tip_id => 22}
    assert_template :missing
    assert_response :success
  end

  test "unbind" do
    get :unbind, {:occurrence_id => 1}, {:id => 1}
    assert_response :success
    assert_equal 1, Calendar.find(1).tips.size
    assert_raise(ActiveRecord::RecordNotFound) {
      Tip.find(1)
    }
  end

  test "unbind - no user" do
    get :unbind, {:occurrence_id => 1}
    assert_response 401
  end

  test "unbind - wrong user" do
    get :unbind, {:occurrence_id => 1}, {:id => 2}
    assert_response 403
  end

  test "move" do
    get :move, {:occurrence_id => 1, :condition_id => 4, :weekday_id => 3}, {:id => 1}
    assert_response :success
    assert_equal 2, Calendar.find(1).tips.size
    assert_equal 4, Tip.find(1).condition_id
    assert_equal 3, Tip.find(1).weekday_id
  end

  test "move - no user" do
    get :move, {:occurrence_id => 1, :condition_id => 4, :weekday_id => 3}
    assert_response 401
  end

  test "move - wrong user" do
    get :move, {:occurrence_id => 1, :condition_id => 4, :weekday_id => 3}, {:id => 2}
    assert_response 403
  end

  test "switch" do
    get :switch, {:occurrence_id => 1, :target_id => 2}, {:id => 1}
    assert_response :success
    assert_equal 2, Calendar.find(1).tips.size
    assert_equal 2, Tip.find(1).condition_id
    assert_equal 2, Tip.find(1).weekday_id
    assert_equal 1, Tip.find(2).condition_id
    assert_equal 2, Tip.find(2).weekday_id
  end

  test "switch - no user" do
    get :switch, {:occurrence_id => 1, :target_id => 2}
    assert_response 401
  end

  test "switch - wrong user" do
    get :switch, {:occurrence_id => 1, :target_id => 2}, {:id => 2}
    assert_response 403
  end
end
