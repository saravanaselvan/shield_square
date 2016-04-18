Ss2.setup do |config|
	# Set the ShieldSquare domain based on your Server Locations

	#Asia/India - ss_sa.shieldsquare.net
	#North America - ss_scus.shieldsquare.net
	#Europe - ss_ew.shieldsquare.net
	#Australia - ss_au.shieldsquare.net
	config.ss2_domain = '<%= @server_name %>'

	if Rails.env.production?
		#Enter your SID
		config.sid = "<%= @prod_sid %>"

		#Please specify the mode in which you want to operate
		#mode = 'Active'
		#mode = 'Monitor'
		config.mode = 'Active'

		#Asynchronous HTTP Data Post  
		#Setting this value to true will reduce the page load time when you are in Monitor mode. 
		#Note: Enable this only if you are hosting your applications on Linux environments. 
		config.async_http_post = false
	else
		#Enter your SID
		config.sid = "<%= @staging_sid %>"

		#Please specify the mode in which you want to operate
		#mode = 'Active'
		#mode = 'Monitor'
		config.mode = 'Monitor'

		#Asynchronous HTTP Data Post  
		#Setting this value to true will reduce the page load time when you are in Monitor mode. 
		#Note: Enable this only if you are hosting your applications on Linux environments. 
		config.async_http_post = true		
	end

	#* Timeout in Seconds or Milliseconds
	config.timeout_value = 500

	#* Enter the URL for the JavaScript Data Collector
	config.js_url = '/getData'

	config._ipaddr = "REMOTE_ADDR"

	config._deployment_number = "deployment_number"


	# 
	# Set the DNS cache time in seconds
	# Default is one hour
	# Set -1 to disable caching
	# Note: To use this feature your application server [Apache/Nginx] 
	# should have write access to folder specified in domain_cache_file. 
	config.domain_ttl = 3600


	# Set DNS Cache file path
	# Default is /dev/shm/ folder.
	# Note: To use this feature your application server [Apache/Nginx] 
	# should have write access to folder specified. 
	# Also add '/' in the end of the path 
	# eg. /dev/shm/
	config.domain_cache_file = '/dev/shm/'
end
