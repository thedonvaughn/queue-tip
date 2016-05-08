require 'test_helper'

class AgentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:agents)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_agent
    assert_difference('Agent.count') do
      post :create, :agent => { }
    end

    assert_redirected_to agent_path(assigns(:agent))
  end

  def test_should_show_agent
    get :show, :id => agents(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => agents(:one).id
    assert_response :success
  end

  def test_should_update_agent
    patch :update, :id => agents(:one).id, :agent => { }
    assert_redirected_to agent_path(assigns(:agent))
  end

  def test_should_destroy_agent
    assert_difference('Agent.count', -1) do
      delete :destroy, :id => agents(:one).id
    end

    assert_redirected_to agents_path
  end
end
