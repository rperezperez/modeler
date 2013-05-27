require File.dirname(__FILE__) + '/../test_helper'
require 'temas_controller'

# Re-raise errors caught by the controller.
class TemasController; def rescue_action(e) raise e end; end

class TemasControllerTest < Test::Unit::TestCase
  fixtures :temas

  def setup
    @controller = TemasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = temas(:first).id
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

    assert_not_nil assigns(:temas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:tema)
    assert assigns(:tema).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:tema)
  end

  def test_create
    num_temas = Tema.count

    post :create, :tema => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_temas + 1, Tema.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:tema)
    assert assigns(:tema).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Tema.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Tema.find(@first_id)
    }
  end
end
