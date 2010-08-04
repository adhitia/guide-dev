require 'test_helper'

class TipsControllerTest < ActionController::TestCase
  test "create" do
    get :create, {:id => 1, :new_tip_name => 'my tip'}, {:id => 1}
    assert_template 'tips/_edit_row'
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
  end

  test "update - no user" do
    get :update, {:id => 1, :tips => {}}
    assert_response 401
  end

  test "update - wrong user" do
    get :update, {:id => 1, :tips => {}}, {:id => 2}
    assert_response 403
  end

  test "follow url" do
    get :follow_url, {:id => 1, :tip_id => 2}
    assert_redirected_to 'go-museum.com'
  end

  test "unbind" do
    get :unbind, {:occurrence_id => 1}, {:id => 1}
    assert_response :success
    assert_equal 1, Calendar.find(1).show_places.size
    assert_raise(ActiveRecord::RecordNotFound) {
      ShowPlace.find(1)
    }
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
    assert_equal 2, Calendar.find(1).show_places.size
    assert_equal 4, ShowPlace.find(1).condition_id
    assert_equal 3, ShowPlace.find(1).weekday_id
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
    assert_equal 2, Calendar.find(1).show_places.size
    assert_equal 2, ShowPlace.find(1).condition_id
    assert_equal 2, ShowPlace.find(1).weekday_id
    assert_equal 1, ShowPlace.find(2).condition_id
    assert_equal 2, ShowPlace.find(2).weekday_id
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
