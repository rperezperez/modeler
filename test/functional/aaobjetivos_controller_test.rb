require File.dirname(__FILE__) + '/../test_helper'
require 'aaobjetivos_controller'

# Re-raise errors caught by the controller.
class AaobjetivosController; def rescue_action(e) raise e end; end

class AaobjetivosControllerTest < Test::Unit::TestCase
  fixtures :aaobjetivos

  def setup
    @controller = AaobjetivosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = aaobjetivos(:first).id
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

    assert_not_nil assigns(:aaobjetivos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:aaobjetivo)
    assert assigns(:aaobjetivo).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:aaobjetivo)
  end

  def test_create
    num_aaobjetivos = Aaobjetivo.count

    post :create, :aaobjetivo => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_aaobjetivos + 1, Aaobjetivo.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:aaobjetivo)
    assert assigns(:aaobjetivo).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Aaobjetivo.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Aaobjetivo.find(@first_id)
    }
  end
end
