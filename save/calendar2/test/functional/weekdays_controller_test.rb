require 'test_helper'

class WeekdaysControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weekdays)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weekday" do
    assert_difference('Weekday.count') do
      post :create, :weekday => { }
    end

    assert_redirected_to weekday_path(assigns(:weekday))
  end

  test "should show weekday" do
    get :show, :id => weekdays(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => weekdays(:one).to_param
    assert_response :success
  end

  test "should update weekday" do
    put :update, :id => weekdays(:one).to_param, :weekday => { }
    assert_redirected_to weekday_path(assigns(:weekday))
  end

  test "should destroy weekday" do
    assert_difference('Weekday.count', -1) do
      delete :destroy, :id => weekdays(:one).to_param
    end

    assert_redirected_to weekdays_path
  end
end
