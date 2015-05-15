require 'test_helper'

class TemporaryNotesControllerTest < ActionController::TestCase
  setup do
    @temporary_note = temporary_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:temporary_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create temporary_note" do
    assert_difference('TemporaryNote.count') do
      post :create, temporary_note: {  }
    end

    assert_redirected_to temporary_note_path(assigns(:temporary_note))
  end

  test "should show temporary_note" do
    get :show, id: @temporary_note
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @temporary_note
    assert_response :success
  end

  test "should update temporary_note" do
    patch :update, id: @temporary_note, temporary_note: {  }
    assert_redirected_to temporary_note_path(assigns(:temporary_note))
  end

  test "should destroy temporary_note" do
    assert_difference('TemporaryNote.count', -1) do
      delete :destroy, id: @temporary_note
    end

    assert_redirected_to temporary_notes_path
  end
end
