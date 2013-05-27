require File.dirname(__FILE__) + '/../test_helper'
require 'implementacion_controller'

# Re-raise errors caught by the controller.
class ImplementacionController; def rescue_action(e) raise e end; end

class ImplementacionControllerTest < Test::Unit::TestCase
  def setup
    @controller = ImplementacionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
