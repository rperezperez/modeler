require File.dirname(__FILE__) + '/../test_helper'
require 'active_scaffold_controller'

# Re-raise errors caught by the controller.
class ActiveScaffoldController; def rescue_action(e) raise e end; end

class ActiveScaffoldControllerTest < Test::Unit::TestCase
  def setup
    @controller = ActiveScaffoldController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
