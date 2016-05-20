require 'ss2/version'
require 'ss2/engine'
require 'rack/get_data'
require 'httparty'
require 'addressable/uri'

module Ss2
	class URI::Parser
	  def split url
	    a = Addressable::URI::parse url
	    [a.scheme, a.userinfo, a.host, a.port, nil, a.path, nil, a.query, a.fragment]
	  end
	end

	class ShieldsquareRequest
		attr_accessor :_zpsbd0, :_zpsbd1, :_zpsbd2, :_zpsbd3, :_zpsbd4, :_zpsbd5, :_zpsbd6, :_zpsbd7, :_zpsbd8, :_zpsbd9, :_zpsbda, :__uzma, :__uzmb, :__uzmc, :__uzmd

		def initialize(sid, shieldsquare_pid, request, ip_address, shieldsquare_calltype, shieldsquare_username, current_time)
			@_zpsbd0 = false
			@_zpsbd1 = sid
			@_zpsbd2 = shieldsquare_pid
			@_zpsbd3 = if request.headers['HTTP_REFERER'].nil? || request.headers['HTTP_REFERER'].empty?
				""
			else
				request.headers['HTTP_REFERER']
			end
			@_zpsbd4 = if request.headers['REQUEST_URI'].nil? || request.headers['REQUEST_URI'].empty?
				""
			else
				request.headers['REQUEST_URI']
			end
			@_zpsbd5 = if request.session_options[:id].nil? || request.session_options[:id].empty?
				""
			else
				request.session_options[:id]
			end
			@_zpsbd6 = ip_address
			@_zpsbd7 = if request.headers['HTTP_USER_AGENT'].nil? || request.headers['HTTP_USER_AGENT'].empty?
				""
			else
				request.headers['HTTP_USER_AGENT']
			end
			@_zpsbd8 = shieldsquare_calltype
			@_zpsbd9 = if shieldsquare_username.nil? || shieldsquare_username.empty?
				""
			else
				shieldsquare_username
			end
			@_zpsbda = current_time
			@__uzma = ""
			@__uzmb = 0
			@__uzmc = ""
			@__uzmd = 0		
		end
	end

	class ShieldsquareResponse
		attr_accessor :pid, :responsecode, :url, :reason, :dynamic_JS

		def initialize(pid, url)
	    @pid          = pid
	    @responsecode = 0
	    @url          = url
	    @reason       = ""		
	    @dynamic_JS   = ""	
		end
	end

	mattr_accessor :ss2_domain
	mattr_accessor :sid
	mattr_accessor :mode
	mattr_accessor :async_http_post
	mattr_accessor :timeout_value
	mattr_accessor :js_url
	mattr_accessor :_ipaddr
	mattr_accessor :_deployment_number
	mattr_accessor :domain_ttl
	mattr_accessor :domain_cache_file


  def self.setup
    yield self
  end

	#Shieldsquare Codes
	SHIELDSQUARE_CODES_ALLOW   = 0
	SHIELDSQUARE_CODES_MONITOR = 1
	SHIELDSQUARE_CODES_CAPTCHA = 2
	SHIELDSQUARE_CODES_BLOCK   = 3
	SHIELDSQUARE_CODES_FFD   = 4
	SHIELDSQUARE_CODES_ALLOW_EXP = -1

	# Call Types
	PAGE_LOAD = 1
	FORM_SUBMIT = 2
	CAPTCHA_PAGE = 4
	CAPTCHA_SUCCESS = 5
	$IP_ADDRESS = ""

	def self.shieldsquare_ValidateRequest( shieldsquare_username, shieldsquare_calltype, shieldsquare_pid, request, cookies ) 
		shieldsquare_low  = 10000
		shieldsquare_high = 99999
		shieldsquare_a = 1
		shieldsquare_b = 3
		shieldsquare_c = 7
		shieldsquare_d = 1
		shieldsquare_e = 5
		shieldsquare_f = 10
		shieldsquare_service_url = "http://" + get_domain_ip(@@ss2_domain) + "/getRequestData"
		shieldsquare_current_time = Time.now.to_i
		$IP_ADDRESS = request.remote_ip

		if @@timeout_value > 2000
			puts "Content-type: text/html"
			puts ''
			puts 'ShieldSquare Timeout cant be greater then 1000 Milli seconds'
			exit
		end	
		
		if @@_ipaddr == "REMOTE_ADDR" || @@_ipaddr == "auto"
			$IP_ADDRESS = request.headers["REMOTE_ADDR"]
		else
			$IP_ADDRESS = request.headers[@@_ipaddr]
		end

		if $IP_ADDRESS.blank?
			$IP_ADDRESS = "0.0.0.0"
		end 

		if shieldsquare_pid.blank?
			shieldsquare_pid = shieldsquare_generate_pid @@sid
		end

		shieldsquare_request = ShieldsquareRequest.new(@@sid, shieldsquare_pid, request, $IP_ADDRESS, shieldsquare_calltype, shieldsquare_username, shieldsquare_current_time)
		shieldsquare_response = ShieldsquareResponse.new(shieldsquare_pid, @@js_url)

		if is_cookie_set(cookies['__uzma']) && is_cookie_set(cookies['__uzmb']) && is_cookie_set(cookies['__uzmc']) && is_cookie_set(cookies['__uzmd'])
			shieldsquare_lastaccesstime =  cookies['__uzmd']
			shieldsquare_uzmc=0
			shieldsquare_uzmc= cookies['__uzmc']
			shieldsquare_uzmc=shieldsquare_uzmc[shieldsquare_e..shieldsquare_uzmc.length-shieldsquare_f]
			shieldsquare_a = ((shieldsquare_uzmc.to_i-shieldsquare_c)/shieldsquare_b) + shieldsquare_d
			shieldsquare_uzmc= rand(shieldsquare_low..shieldsquare_high).to_s + (shieldsquare_c+shieldsquare_a*shieldsquare_b).to_s + rand(shieldsquare_low..shieldsquare_high).to_s
			cookies[:__uzmc] = { :value => shieldsquare_uzmc, :expires => Time.now + 3600*24*365*10} 
			shieldsquare_request.__uzma = cookies["__uzma"]
			shieldsquare_request.__uzmb = cookies["__uzmb"]
			shieldsquare_request.__uzmc = shieldsquare_uzmc
		else
			id = DateTime.now.strftime('%Q')
			shieldsquare_uzma = id.to_i(36).to_s
			shieldsquare_lastaccesstime = Time.now.to_i
			shieldsquare_uzmc= rand(shieldsquare_low..shieldsquare_high).to_s + (shieldsquare_c+shieldsquare_a*shieldsquare_b).to_s + rand(shieldsquare_low..shieldsquare_high).to_s
			cookies[:__uzma] = { :value => shieldsquare_uzma, :expires => Time.now + 3600*24*365*10} 
			cookies[:__uzmb] = { :value => Time.now.to_i.to_s, :expires => Time.now + 3600*24*365*10} 
			cookies[:__uzmc] = { :value => shieldsquare_uzmc, :expires => Time.now + 3600*24*365*10} 
			shieldsquare_request.__uzma = shieldsquare_uzma
			shieldsquare_request.__uzmb = Time.now.to_i
			shieldsquare_request.__uzmc = shieldsquare_uzmc
		end
		cookies[:__uzmd] = { :value => shieldsquare_current_time.to_s, :expires => Time.now + 3600*24*365*10} 
		shieldsquare_request.__uzmd = shieldsquare_current_time.to_s
		if @@mode == 'Active' && (shieldsquare_calltype != 4 && shieldsquare_calltype != 5)
			shieldsquare_request._zpsbd0 = true;
			shieldsquare_request_hash = JSON.parse(shieldsquare_request.to_json)
			shieldsquare_request_json = get_request_json(request, shieldsquare_request_hash)
			shieldsquare_response = handle_active_mode(shieldsquare_response, shieldsquare_service_url, shieldsquare_request_json, @@timeout_value)
		else
			shieldsquare_request._zpsbd0 = false;
			shieldsquare_request_hash = JSON.parse(shieldsquare_request.to_json)
			shieldsquare_request_json = get_request_json(request, shieldsquare_request_hash)
			shieldsquare_response = handle_monitor_mode(shieldsquare_response, shieldsquare_service_url, shieldsquare_request_json, @@timeout_value, shieldsquare_calltype)
		end
		shieldsquare_response
	end

	def self.handle_active_mode(shieldsquare_response, url, payload, timeout)
		shieldsquare_response_from_ss = shieldsquare_post_sync url, payload, timeout
		if shieldsquare_response_from_ss.nil?
			shieldsquare_response.responsecode = SHIELDSQUARE_CODES_ALLOW_EXP
			shieldsquare_response.reason = "Request Timed Out/Server Not Reachable"
		else
			shieldsquare_response_from_ss = JSON.parse(shieldsquare_response_from_ss)
			shieldsquare_response.dynamic_JS = shieldsquare_response_from_ss['dynamic_JS']
			n = shieldsquare_response_from_ss['ssresp'].to_i
			case n
			when 0..4
				shieldsquare_response.responsecode = n
			else
				shieldsquare_response.responsecode = SHIELDSQUARE_CODES_ALLOW_EXP
				shieldsquare_response.reason = "Request Timed Out/Server Not Reachable"
			end
		end
		shieldsquare_response
	end

	def self.handle_monitor_mode(shieldsquare_response, url, payload, timeout, shieldsquare_calltype)
		if @@async_http_post == true || shieldsquare_calltype == 4 || shieldsquare_calltype == 5
			shieldsquare_response_from_ss = shieldsquare_post_async url, payload, timeout
			shieldsquare_response.responsecode = SHIELDSQUARE_CODES_ALLOW
			shieldsquare_response.dynamic_JS = "var __uzdbm_c = 2+2"
		else
			shieldsquare_response_from_ss = shieldsquare_post_sync url, payload, timeout
			if shieldsquare_response_from_ss.nil?
				shieldsquare_response.responsecode = SHIELDSQUARE_CODES_ALLOW_EXP
				shieldsquare_response.reason = "Request Timed Out/Server Not Reachable"
			else
				shieldsquare_response_from_ss = JSON.parse(shieldsquare_response_from_ss)
				shieldsquare_response.responsecode = SHIELDSQUARE_CODES_ALLOW
				shieldsquare_response.dynamic_JS = shieldsquare_response_from_ss['dynamic_JS']				
			end
		end		

		shieldsquare_response
	end

	def self.shieldsquare_post_async(url, payload, timeout)
		response = nil
		Thread.new do
			response = shieldsquare_post_sync url, payload, timeout
		end		
		response
	end	

	def self.shieldsquare_post_sync(url, payload, timeout)
		# Sendind the Data to the ShieldSquare Server
		params = payload
		headers = Hash['Content-Type'=>'application/json', 'Accept'=>'application/json']
		unless timeout.blank?
			timeout = timeout.to_f / 1000
		else
			timeout = 1
		end		
		begin
			response = HTTParty.post(url.to_s, :body => params,:headers => headers, :timeout => timeout)
			if response.code != 200
				response = nil
			end
		rescue Exception => e
			response=nil
		end
		response	
	end

	def self.is_cookie_set(cookie)
		!cookie.nil? && !cookie.empty?
	end	

	def self.get_request_json(request, shieldsquare_request_hash)
		unless request.headers["REMOTE_ADDR"].blank?
			shieldsquare_request_hash["i0"] = request.headers["REMOTE_ADDR"]
		end
		unless request.headers["X-Forwarded-For"].blank?
			shieldsquare_request_hash["i1"] = request.headers["X-Forwarded-For"]
		end
		unless request.headers["HTTP_CLIENT_IP"].blank?
			shieldsquare_request_hash["i2"] = request.headers["HTTP_CLIENT_IP"]
		end
		unless request.headers["HTTP_X_FORWARDED_FOR"].blank?
			shieldsquare_request_hash["i3"] = request.headers["HTTP_X_FORWARDED_FOR"]
		end
		unless request.headers["x-real-ip"].blank?
			shieldsquare_request_hash["i4"] = request.headers["x-real-ip"]
		end
		unless request.headers["HTTP_X_FORWARDED"].blank?
			shieldsquare_request_hash["i5"] = request.headers["HTTP_X_FORWARDED"]
		end
		unless request.headers["Proxy-Client-IP"].blank?
			shieldsquare_request_hash["i6"] = request.headers["Proxy-Client-IP"]
		end
		unless request.headers["WL-Proxy-Client-IP"].blank?
			shieldsquare_request_hash["i7"] = request.headers["WL-Proxy-Client-IP"]
		end
		unless request.headers["HTTP_X_FORWARDED"].blank?
			shieldsquare_request_hash["i8"] = request.headers["HTTP_X_FORWARDED"]
		end
		unless request.headers["HTTP_X_CLUSTER_CLIENT_IP"].blank?
			shieldsquare_request_hash["i9"] = request.headers["HTTP_X_CLUSTER_CLIENT_IP"]
		end
		unless request.headers["HTTP_FORWARDED_FOR"].blank?
			shieldsquare_request_hash["i10"] = request.headers["HTTP_FORWARDED_FOR"]
		end
		unless request.headers["HTTP_FORWARDED"].blank?
			shieldsquare_request_hash["i11"] = request.headers["HTTP_FORWARDED"]
		end
		unless request.headers["HTTP_VIA"].blank?
			shieldsquare_request_hash["i12"] = request.headers["HTTP_VIA"]
		end
		unless request.headers["X-True-Client-IP"].blank?
			shieldsquare_request_hash["i13"] = request.headers["X-True-Client-IP"]
		end
		unless request.remote_ip.blank?
			shieldsquare_request_hash["il1"] = request.remote_ip
		end
		unless request.ip.blank?
			shieldsquare_request_hash["il2"] = request.ip
		end
		unless @@_deployment_number.blank?
			shieldsquare_request_hash["idn"] = @@_deployment_number
		end
		shieldsquare_request_hash.to_json
	end

	def self.get_domain_ip(host)
		result = ""
		cache_loaded_time = 0

		ttl = @@domain_ttl
		file_path = "#{@@domain_cache_file}ss_nr_cache"

		if ttl == -1
			host
		else
			unless File.exist?(file_path)
				ip = load_domain_ip(host, file_path);
			else
				File.open(file_path, "r") do |opened_file|
					result = opened_file.read
					cache_loaded_time = opened_file.mtime
				end
				if result == nil || result.length == 0
					ip = load_domain_ip(host, file_path);
				else
					if (Time.now - cache_loaded_time) > ttl
						ip = load_domain_ip(host, file_path);
					else
						ip = result
					end
				end
			end
			ip
		end
	end

	def self.load_domain_ip(host, file_path)
		ip = Resolv.getaddress(host)
		begin
			ip_cache_file = File.new(file_path, "w")
			ip_cache_file.write(ip)
			ip_cache_file.close
		rescue => e
			puts e
		end
		ip
	end

	def self.microtime()
		epoch_mirco = Time.now.to_f
		epoch_full = Time.now.to_i
		epoch_fraction = epoch_mirco - epoch_full
		epoch_fraction.to_s + ' ' + epoch_full.to_s
	end

	def self.shieldsquare_generate_pid(shieldsquare_sid)
		t=microtime
		dt=t.split(" ")
		p = @@sid.split("-")
		sid_min = p[3].to_i(16)
		rmstr1=("00000000"+(dt[1].to_i).to_s(16)).split(//).last(4).join("").to_s
		rmstr2=("0000" + ((dt[0].to_f * 65536).round).to_s(16)).split(//).last(4).join("").to_s
		sprintf('%08s-%04x-%04s-%04s-%04x%04x%04x', shieldsquare_IP2Hex(),sid_min,rmstr1,rmstr2,(rand() * 0xffff).to_i,(rand() * 0xffff).to_i,(rand() * 0xffff).to_i)
	end

	def self.shieldsquare_IP2Hex()
		hexx=""
		ip=$IP_ADDRESS
		part=ip.split('.')
		hexx=''
		for i in 0..part.count-1
			hexx= hexx + ("0"+(part[i].to_i).to_s(16)).split(//).last(2).join("").to_s
		end
		hexx
	end

	def self.send_js_request(request, params)
		data = params['jsonString']
		url = 'http://' + @@ss2_domain + '/getss2data'
		data.delete! '\\'
		data.delete! '['
		data.delete! ']'
		shieldsquare_request = JSON.parse(data)
		shieldsquare_request["sid"] = @@sid
		shieldsquare_request["host"] = request.ip
		shieldsquare_post_data = shieldsquare_request
		if @@async_http_post == true
			shieldsquare_post_async url, shieldsquare_post_data, @@timeout_value
		else
			shieldsquare_post_sync url, shieldsquare_post_data, @@timeout_value
		end		
	end
end