require File.dirname(__FILE__) + '/../test_helper'
require 'ayudas_controller'

# Re-raise errors caught by the controller.
class AyudasController; def rescue_action(e) raise e end; end

class AyudasControllerTest < Test::Unit::TestCase
  fixtures :ayudas

  def setup
    @controller = AyudasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = ayudas(:first).id
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

    assert_not_nil assigns(:ayudas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:ayuda)
    assert assigns(:ayuda).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:ayuda)
  end

  def test_create
    num_ayudas = Ayuda.count

    post :create, :ayuda => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_ayudas + 1, Ayuda.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:ayuda)
    assert assigns(:ayuda).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Ayuda.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Ayuda.find(@first_id)
    }
  end
end
