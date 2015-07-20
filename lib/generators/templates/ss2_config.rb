ShieldSquare.setup do |config|
	# Set the ShieldSquare domain based on your Server Locations

	#Asia/India - ss_sa.shieldsquare.net
	#North America - ss_scus.shieldsquare.net
	#Europe - ss_ew.shieldsquare.net
	#Australia - ss_au.shieldsquare.net
	config.ss2_domain = '130.211.186.67'

	#Enter your SID
	config.sid = "77a4362b-d035-4d7b-afb3-6050be9e0738"

	#Please specify the mode in which you want to operate
	#mode = 'Active'
	#mode = 'Monitor'
	config.mode = 'Monitor'

	#Asynchronous HTTP Data Post  
	#Setting this value to true will reduce the page load time when you are in Monitor mode. 
	#Note: Enable this only if you are hosting your applications on Linux environments. 
	config.async_http_post = true

	#* Timeout in Seconds or Milliseconds
	config.timeout_value = 500

	#* Enter the URL fo the JavaScript Data Collector
	config.js_url = '/getData.rb'
end

