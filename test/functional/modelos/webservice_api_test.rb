require File.dirname(__FILE__) + '/../../test_helper'
require 'modelos/webservice_controller'

class Modelos::WebserviceController; def rescue_action(e) raise e end; end

class Modelos::WebserviceControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = Modelos::WebserviceController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
end
