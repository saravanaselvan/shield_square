module Rack
  class GetData
    def initialize(app)
      @app=app
    end

    def call(env)
      if env['PATH_INFO'] == '/getData'
        request = Rack::Request.new(env)
        if request.params['jsonString'] != ""
          error_code = Ss2.send_js_request request, request.params
        end	
        [200, {"Content-Type" => 'text/plain'},["error_code: #{error_code}"]]
      else
        @app.call(env)
      end
    end		
  end
end
