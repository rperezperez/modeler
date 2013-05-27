require File.dirname(__FILE__) + '/../test_helper'
require 'bibliografias_controller'

# Re-raise errors caught by the controller.
class BibliografiasController; def rescue_action(e) raise e end; end

class BibliografiasControllerTest < Test::Unit::TestCase
  fixtures :bibliografias

  def setup
    @controller = BibliografiasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = bibliografias(:first).id
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

    assert_not_nil assigns(:bibliografias)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:bibliografia)
    assert assigns(:bibliografia).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:bibliografia)
  end

  def test_create
    num_bibliografias = Bibliografia.count

    post :create, :bibliografia => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_bibliografias + 1, Bibliografia.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:bibliografia)
    assert assigns(:bibliografia).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Bibliografia.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Bibliografia.find(@first_id)
    }
  end
end
