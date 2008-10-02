require 'test_helper'

class QueusControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:queus)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_queu
    assert_difference('Queu.count') do
      post :create, :queu => { }
    end

    assert_redirected_to queu_path(assigns(:queu))
  end

  def test_should_show_queu
    get :show, :id => queus(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => queus(:one).id
    assert_response :success
  end

  def test_should_update_queu
    put :update, :id => queus(:one).id, :queu => { }
    assert_redirected_to queu_path(assigns(:queu))
  end

  def test_should_destroy_queu
    assert_difference('Queu.count', -1) do
      delete :destroy, :id => queus(:one).id
    end

    assert_redirected_to queus_path
  end
end
