require File.dirname(__FILE__) + '/../test_helper'
require 'modelos_controller'

# Re-raise errors caught by the controller.
class ModelosController; def rescue_action(e) raise e end; end

class ModelosControllerTest < Test::Unit::TestCase
  fixtures :modelos

  def setup
    @controller = ModelosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = modelos(:first).id
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

    assert_not_nil assigns(:modelos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:modelo)
    assert assigns(:modelo).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:modelo)
  end

  def test_create
    num_modelos = Modelo.count

    post :create, :modelo => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_modelos + 1, Modelo.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:modelo)
    assert assigns(:modelo).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Modelo.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Modelo.find(@first_id)
    }
  end
end
