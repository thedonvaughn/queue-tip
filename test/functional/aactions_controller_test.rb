require 'test_helper'

class AactionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:aactions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_aaction
    assert_difference('Aaction.count') do
      post :create, :aaction => { }
    end

    assert_redirected_to aaction_path(assigns(:aaction))
  end

  def test_should_show_aaction
    get :show, :id => aactions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => aactions(:one).id
    assert_response :success
  end

  def test_should_update_aaction
    put :update, :id => aactions(:one).id, :aaction => { }
    assert_redirected_to aaction_path(assigns(:aaction))
  end

  def test_should_destroy_aaction
    assert_difference('Aaction.count', -1) do
      delete :destroy, :id => aactions(:one).id
    end

    assert_redirected_to aactions_path
  end
end
