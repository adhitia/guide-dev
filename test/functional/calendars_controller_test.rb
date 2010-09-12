require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase
  test "new guide" do
    get :new, {}, {:id => 1}
    assert_template :new
    assert_response :success
  end

  test "new guide - no user" do
    get :new
    assert_redirected_to 'login'
  end

  test "create guide" do
    get :create, {:calendar_name_location => 'Rio', :calendar_name_target => 'kids', :location_code => 'BRXX0201'}, {:id => 1}
    assert_template :new_overview
    assert_response :success
  end

  test "create guide - no user" do
    get :create, {:calendar_name_location => 'Rio', :calendar_name_target => 'kids', :location_code => 'BRXX0201'}
    assert_redirected_to 'login'
  end

  test "create guide step 2" do
    tip_names = {};
    Condition.all.each do |c|
      tip_names[c.id.to_s] = {}
      Weekday.all.each do |day|
        tip_names[c.id.to_s][day.id.to_s] = ''
      end
    end
    tip_names["1"]["2"] = 'beach'
    tip_names["2"]["2"] = 'museum'

    get :create, {
            :step => 'overview',
            :calendar_name_location => 'Rio',
            :calendar_name_target => 'kids',
            :location_code => 'BRXX0201',
            :location_name => 'Rio de Janeiro, Brazil',
            :tip_name => tip_names
    }, {:id => 1}

    guide = Calendar.all.last
    assert_equal 'Rio for kids', guide.name, 'guide name'
    assert_equal 1, guide.user_id, 'guide author'
    assert_equal 1, guide.location_id, 'guide location'

    tips = Tip.all.last(2)
    assert_equal 'beach', tips[0].name, 'tip name'
    assert_equal 'museum', tips[1].name, 'tip name'

    assert_redirected_to "guides/#{guide.id}/edit"
  end

  test "edit guide" do
    get :edit, {:id => 1}, {:id => 1}
    assert_template :edit
    assert_response :success
  end

  test "edit guide - no user" do
    get :edit, {:id => 1}
    assert_redirected_to 'login'
  end

  test "edit guide - wrong user" do
    get :edit, {:id => 1}, {:id => 2}
    assert_redirected_to 'unauthorized'
  end

  test "edit guide by day" do
    get :edit_day, {:id => 1, :weekday_id => 3}, {:id => 1}
    assert_template :edit
    assert_response :success
  end

  test "edit guide by day - no user" do
    get :edit_day, {:id => 1, :weekday_id => 3}
    assert_redirected_to 'login'
  end

  test "edit guide by day - wrong user" do
    get :edit_day, {:id => 1, :weekday_id => 3}, {:id => 2}
    assert_redirected_to 'unauthorized'
  end

  test "edit guide by condition" do
    get :edit_condition, {:id => 1, :condition_id => 3}, {:id => 1}
    assert_template :edit
    assert_response :success
  end

  test "edit guide by condition - no user" do
    get :edit_condition, {:id => 1, :condition_id => 3}
    assert_redirected_to 'login'
  end

  test "edit guide by condition - wrong user" do
    get :edit_condition, {:id => 1, :condition_id => 3}, {:id => 2}
    assert_redirected_to 'unauthorized'
  end

  test "search" do
    get :search, {:search_location => 'Rio'}
    assert_template :search
    assert_response :success
    assert_equal 2, assigns["guides"].length
    assert_equal 1, assigns["guides"][0].id
    assert_equal 2, assigns["guides"][1].id
  end

  test "search all" do
    get :search, {:search_location => ''}
    assert_template :search
    assert_response :success
    assert_equal 3, assigns["guides"].length
  end

end
