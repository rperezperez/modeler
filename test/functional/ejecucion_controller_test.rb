require File.dirname(__FILE__) + '/../test_helper'
require 'ejecucion_controller'

# Re-raise errors caught by the controller.
class EjecucionController; def rescue_action(e) raise e end; end

class EjecucionControllerTest < Test::Unit::TestCase
  def setup
    @controller = EjecucionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
