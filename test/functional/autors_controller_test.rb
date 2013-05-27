require File.dirname(__FILE__) + '/../test_helper'
require 'autors_controller'

# Re-raise errors caught by the controller.
class AutorsController; def rescue_action(e) raise e end; end

class AutorsControllerTest < Test::Unit::TestCase
  fixtures :autors

  def setup
    @controller = AutorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = autors(:first).id
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

    assert_not_nil assigns(:autors)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:autor)
    assert assigns(:autor).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:autor)
  end

  def test_create
    num_autors = Autor.count

    post :create, :autor => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_autors + 1, Autor.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:autor)
    assert assigns(:autor).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Autor.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Autor.find(@first_id)
    }
  end
end
