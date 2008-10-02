require 'test_helper'

class CactionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cactions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_caction
    assert_difference('Caction.count') do
      post :create, :caction => { }
    end

    assert_redirected_to caction_path(assigns(:caction))
  end

  def test_should_show_caction
    get :show, :id => cactions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => cactions(:one).id
    assert_response :success
  end

  def test_should_update_caction
    put :update, :id => cactions(:one).id, :caction => { }
    assert_redirected_to caction_path(assigns(:caction))
  end

  def test_should_destroy_caction
    assert_difference('Caction.count', -1) do
      delete :destroy, :id => cactions(:one).id
    end

    assert_redirected_to cactions_path
  end
end
