require File.dirname(__FILE__) + '/../test_helper'
require 'aaplicacions_controller'

# Re-raise errors caught by the controller.
class AaplicacionsController; def rescue_action(e) raise e end; end

class AaplicacionsControllerTest < Test::Unit::TestCase
  fixtures :aaplicacions

  def setup
    @controller = AaplicacionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = aaplicacions(:first).id
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

    assert_not_nil assigns(:aaplicacions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:aaplicacion)
    assert assigns(:aaplicacion).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:aaplicacion)
  end

  def test_create
    num_aaplicacions = Aaplicacion.count

    post :create, :aaplicacion => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_aaplicacions + 1, Aaplicacion.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:aaplicacion)
    assert assigns(:aaplicacion).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Aaplicacion.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Aaplicacion.find(@first_id)
    }
  end
end
