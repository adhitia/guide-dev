require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase
  test "show" do
    get :show, {:id => 4}
    assert_template :show
    assert_response :success
    assert_equal 4, assigns['calendar'].id
  end

  test "show - guide not found" do
    get :show, {:id => 33}
    assert_template :missing
    assert_response :success
  end

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
#    puts "!!!!!!!!! #{assigns}"
#    assigns["errors"] = {}
    get :create, {:calendar_name_location => 'Rio', :calendar_name_target => 'kids',
                   :location_code => 'BRXX0201', :location_name => 'Rio de Janeiro, Brazil'}, {:id => 1}
    assert_template :new_overview
    assert_response :success
    assert_no_errors
  end

  test "create guide - no user" do
    get :create, {:calendar_name_location => 'Rio', :calendar_name_target => 'kids',
                   :location_code => 'BRXX0201', :location_name => 'Rio de Janeiro, Brazil'}
    assert_redirected_to 'login'
  end

  test "create guide - no input" do
    get :create, {}, {:id => 1}
    assert_template :new
    assert_response :success
    assert_equal 3, assigns["errors"].size
    assert_not_nil assigns["errors"][:calendar_name_location]
    assert_not_nil assigns["errors"][:calendar_name_target]
    assert_not_nil assigns["errors"][:location_name]
  end

  test "create guide - new location" do
    get :create, {:calendar_name_location => 'Rio', :calendar_name_target => 'kids',
                   :location_code => 'NEW_CODE', :location_name => 'New York'}, {:id => 1}
    assert_template :new
    assert_response :success
    assert_no_errors
    assert_equal 'NEW_CODE', Location.last.code
    assert_equal 'New York', Location.last.name  
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

    assert_no_errors

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

  test "edit guide by condition - no guide" do
    get :edit_condition, {:id => 33, :condition_id => 3}, {:id => 1}
    assert_template :missing
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

  test "update guide" do
    get :update, {:id => 1, :location_name => 'Moscow', :location_code => 'Code', :access_type => 'false'}, {:id => 1}
    assert_response :success
    assert_equal 'Code', Location.last.code
    assert_equal 'Moscow', Location.last.name
    assert_equal false, Calendar.find(1).public?
  end

  test "update guide 2" do
    get :update, {:id => 1, :location_name => 'Paris, France', :location_code => 'FRXX0076'}, {:id => 1}
    assert_response :success
    assert_equal 2, Location.all.size
    assert_equal true, Calendar.find(1).public?
    assert_equal 2, Calendar.find(1).location_id
  end

  test "update guide - no user" do
    get :update, {:id => 1, :location_name => 'Moscow', :location_code => 'Code', :access_type => 'false'}
    assert_redirected_to 'login'
  end

  test "update guide - wrong user" do
    get :update, {:id => 1, :location_name => 'Moscow', :location_code => 'Code', :access_type => 'false'}, {:id => 2}
    assert_redirected_to 'unauthorized'
  end

  test "share" do
    get :share, {:id => 1}
    assert_template :share
    assert_response :success
  end

  test "share - not found" do
    get :share, {:id => 33}
    assert_template :missing
    assert_response :success
  end
end
