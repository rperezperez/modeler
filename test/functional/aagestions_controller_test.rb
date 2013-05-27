require File.dirname(__FILE__) + '/../test_helper'
require 'aagestions_controller'

# Re-raise errors caught by the controller.
class AagestionsController; def rescue_action(e) raise e end; end

class AagestionsControllerTest < Test::Unit::TestCase
  fixtures :aagestions

  def setup
    @controller = AagestionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = aagestions(:first).id
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

    assert_not_nil assigns(:aagestions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:aagestion)
    assert assigns(:aagestion).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:aagestion)
  end

  def test_create
    num_aagestions = Aagestion.count

    post :create, :aagestion => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_aagestions + 1, Aagestion.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:aagestion)
    assert assigns(:aagestion).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Aagestion.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Aagestion.find(@first_id)
    }
  end
end
