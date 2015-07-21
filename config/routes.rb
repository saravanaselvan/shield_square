Rails.application.routes.draw do
	namespace "ss2" do
  	resource :get_data, :path => "getData"
	end
end