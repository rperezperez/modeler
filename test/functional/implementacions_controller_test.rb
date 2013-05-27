require File.dirname(__FILE__) + '/../test_helper'
require 'implementacions_controller'

# Re-raise errors caught by the controller.
class ImplementacionsController; def rescue_action(e) raise e end; end

class ImplementacionsControllerTest < Test::Unit::TestCase
  fixtures :implementacions

  def setup
    @controller = ImplementacionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = implementacions(:first).id
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

    assert_not_nil assigns(:implementacions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:implementacion)
    assert assigns(:implementacion).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:implementacion)
  end

  def test_create
    num_implementacions = Implementacion.count

    post :create, :implementacion => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_implementacions + 1, Implementacion.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:implementacion)
    assert assigns(:implementacion).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Implementacion.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Implementacion.find(@first_id)
    }
  end
end
