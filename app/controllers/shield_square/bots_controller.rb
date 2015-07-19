class ShieldSquare::BotsController < ApplicationController
	skip_before_filter :authenticate_user!
	skip_before_filter :post_to_shield_square

	def create
		if params['jsonString']!=""
			data = params['jsonString']
			data.delete! '\\'
			data.delete! '['
			data.delete! ']'
			shieldsquare_service_url = 'http://' + Rails.configuration.shield_square[:$_ss2_domain] + '/getss2data'
			shieldsquare_request = JSON.parse(data)
			shieldsquare_request["sid"] = Rails.configuration.shield_square[:$_sid]
			shieldsquare_request["host"] = request.remote_ip
			shieldsquare_post_data = JSON.generate(shieldsquare_request)
			if Rails.configuration.shield_square[:$_async_http_post] == true
				error_code = shieldsquare_post_async shieldsquare_service_url, shieldsquare_post_data,$_timeout_value.to_s
			else
				error_code = ShieldSquare.shieldsquare_post_sync shieldsquare_service_url, shieldsquare_post_data, Rails.configuration.shield_square[:$_timeout_value]
			end
		end	
    respond_to do |format|
      format.json {
        render :json => { error_code: error_code}
      }
    end			
	end
end