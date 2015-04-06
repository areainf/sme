require 'test_helper'

class MasterUnitsControllerTest < ActionController::TestCase
  setup do
    @master_unit = master_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:master_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create master_unit" do
    assert_difference('MasterUnit.count') do
      post :create, master_unit: { name: @master_unit.name }
    end

    assert_redirected_to master_unit_path(assigns(:master_unit))
  end

  test "should show master_unit" do
    get :show, id: @master_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @master_unit
    assert_response :success
  end

  test "should update master_unit" do
    patch :update, id: @master_unit, master_unit: { name: @master_unit.name }
    assert_redirected_to master_unit_path(assigns(:master_unit))
  end

  test "should destroy master_unit" do
    assert_difference('MasterUnit.count', -1) do
      delete :destroy, id: @master_unit
    end

    assert_redirected_to master_units_path
  end
end
