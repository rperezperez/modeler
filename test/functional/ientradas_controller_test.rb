require File.dirname(__FILE__) + '/../test_helper'
require 'ientradas_controller'

# Re-raise errors caught by the controller.
class IentradasController; def rescue_action(e) raise e end; end

class IentradasControllerTest < Test::Unit::TestCase
  fixtures :ientradas

  def setup
    @controller = IentradasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = ientradas(:first).id
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

    assert_not_nil assigns(:ientradas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:ientrada)
    assert assigns(:ientrada).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:ientrada)
  end

  def test_create
    num_ientradas = Ientrada.count

    post :create, :ientrada => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_ientradas + 1, Ientrada.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:ientrada)
    assert assigns(:ientrada).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Ientrada.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Ientrada.find(@first_id)
    }
  end
end
