require 'test_helper'

class CallsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:calls)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_call
    assert_difference('Call.count') do
      post :create, :call => { }
    end

    assert_redirected_to call_path(assigns(:call))
  end

  def test_should_show_call
    get :show, :id => calls(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => calls(:one).id
    assert_response :success
  end

  def test_should_update_call
    put :update, :id => calls(:one).id, :call => { }
    assert_redirected_to call_path(assigns(:call))
  end

  def test_should_destroy_call
    assert_difference('Call.count', -1) do
      delete :destroy, :id => calls(:one).id
    end

    assert_redirected_to calls_path
  end
end
