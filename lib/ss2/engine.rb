module Ss2
  class Engine < Rails::Engine
    config.before_configuration do
      Rails.application.config.middleware.use Rack::GetData  
    end
  end
end
