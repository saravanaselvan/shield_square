module Rack
	class GetData
    def initialize(app)
      @app=app
    end

    def call(env)
      @status, @headers, @response = @app.call(env)
      [@status, @headers, @response.body]
    end		
	end
end
