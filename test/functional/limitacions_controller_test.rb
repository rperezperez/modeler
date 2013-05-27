require File.dirname(__FILE__) + '/../test_helper'
require 'limitacions_controller'

# Re-raise errors caught by the controller.
class LimitacionsController; def rescue_action(e) raise e end; end

class LimitacionsControllerTest < Test::Unit::TestCase
  fixtures :limitacions

  def setup
    @controller = LimitacionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = limitacions(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:limitacions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:limitacion)
    assert assigns(:limitacion).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:limitacion)
  end

  def test_create
    num_limitacions = Limitacion.count

    post :create, :limitacion => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_limitacions + 1, Limitacion.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:limitacion)
    assert assigns(:limitacion).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Limitacion.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Limitacion.find(@first_id)
    }
  end
end
