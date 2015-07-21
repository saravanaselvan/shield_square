Rails.application.routes.draw do
  resource :get_data, :module => "ss2", :path => "getData"
end