module Rack
	class GetData
    def initialize(app)
      @app=app
    end

    def call(env)
    	if env['PATH_INFO'] == '/foo'
    		request = Rack::Request.new(env)
    		if request.params['jsonString'] != ""
					Ss2.send_js_request request, request.params
				end	
    		@app.call(env)
    	else
      	@app.call(env)
    	end
    end		
	end
end
