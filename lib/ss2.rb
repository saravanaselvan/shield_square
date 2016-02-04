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
			@_zpsbd3 = request.headers['HTTP_REFERER']
			@_zpsbd4 = request.headers['REQUEST_URI']
			@_zpsbd5 = request.session_options[:id]
			@_zpsbd6 = ip_address
			@_zpsbd7 = request.headers['HTTP_USER_AGENT']
			@_zpsbd8 = shieldsquare_calltype
			@_zpsbd9 = shieldsquare_username
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
		shieldsquare_service_url = "http://" + @@ss2_domain + "/getRequestData"
		$IP_ADDRESS = request.remote_ip

		if @@timeout_value > 1000
			puts "Content-type: text/html"
			puts ''
			puts 'ShieldSquare Timeout cant be greater then 1000 Milli seconds'
			exit
		end	
		
		if @@_ipaddr == "REMOTE_ADDR"
			ip_address_temp = request.remote_ip
		else
			ip_address_temp = request.headers[@@_ipaddr]
		end

		ip_address_temp = ip_address_temp.split(":")
		unless ip_address_temp[3].blank?
			$IP_ADDRESS = ip_address_temp[3]
		else
			unless ip_address_temp.blank?
				$IP_ADDRESS = ip_address_temp[0]
			end
		end

		if $IP_ADDRESS.blank?
			$IP_ADDRESS = "0.0.0.0"
		end 

		if shieldsquare_pid.blank?
			shieldsquare_pid = shieldsquare_generate_pid @@sid
		end

		shieldsquare_request = ShieldsquareRequest.new(@@sid, shieldsquare_pid, request, $IP_ADDRESS, shieldsquare_calltype, shieldsquare_username, Time.now.to_i)
		shieldsquare_response = ShieldsquareResponse.new(shieldsquare_pid, @@js_url)

		if cookies['__uzma']!="" and (cookies['__uzma'].to_s).length > 3
			shieldsquare_lastaccesstime =  cookies['__uzmd']
			shieldsquare_uzmc=0
			shieldsquare_uzmc= cookies['__uzmc']
			shieldsquare_uzmc=shieldsquare_uzmc[shieldsquare_e..shieldsquare_e+1]
			shieldsquare_a = ((shieldsquare_uzmc.to_i-shieldsquare_c)/shieldsquare_b) + shieldsquare_d
			shieldsquare_uzmc= rand(shieldsquare_low..shieldsquare_high).to_s + (shieldsquare_c+shieldsquare_a*shieldsquare_b).to_s + rand(shieldsquare_low..shieldsquare_high).to_s
			cookies[:__uzmc] = { :value => shieldsquare_uzmc, :expires => Time.now + 3600*24*365*10} 
			cookies[:__uzmd] = { :value => Time.now.to_i.to_s, :expires => Time.now + 3600*24*365*10} 
			shieldsquare_request.__uzma = cookies["__uzma"]
			shieldsquare_request.__uzmb = cookies["__uzmb"]
			shieldsquare_request.__uzmc = shieldsquare_uzmc
			shieldsquare_request.__uzmd = shieldsquare_lastaccesstime
		else
			id = DateTime.now.strftime('%Q')
			shieldsquare_uzma = id.to_i(36).to_s
			shieldsquare_lastaccesstime = Time.now.to_i
			shieldsquare_uzmc= rand(shieldsquare_low..shieldsquare_high).to_s + (shieldsquare_c+shieldsquare_a*shieldsquare_b).to_s + rand(shieldsquare_low..shieldsquare_high).to_s
			cookies[:__uzma] = { :value => shieldsquare_uzma, :expires => Time.now + 3600*24*365*10} 
			cookies[:__uzmb] = { :value => Time.now.to_i.to_s, :expires => Time.now + 3600*24*365*10} 
			cookies[:__uzmc] = { :value => shieldsquare_uzmc, :expires => Time.now + 3600*24*365*10} 
			cookies[:__uzmd] = { :value => Time.now.to_i.to_s, :expires => Time.now + 3600*24*365*10} 
			shieldsquare_request.__uzma = shieldsquare_uzma
			shieldsquare_request.__uzmb = Time.now.to_i
			shieldsquare_request.__uzmc = shieldsquare_uzmc
			shieldsquare_request.__uzmd = shieldsquare_lastaccesstime
		end

		if @@mode == 'Active'
			shieldsquare_request._zpsbd0 = true;
			shieldsquare_response = handle_active_mode(shieldsquare_response, shieldsquare_service_url, shieldsquare_request.to_json,@@timeout_value)
		else
			shieldsquare_request._zpsbd0 = false;
			shieldsquare_response = handle_monitor_mode(shieldsquare_response, shieldsquare_service_url, shieldsquare_request.to_json,@@timeout_value)
		end

		shieldsquare_response
	end

	def self.handle_active_mode(shieldsquare_response, url, payload, timeout)
		shieldsquare_response_from_ss = shieldsquare_post_sync shieldsquare_service_url, shieldsquare_request.to_json,@@timeout_value
		shieldsquare_response_from_ss = JSON.parse(shieldsquare_response_from_ss)
		shieldsquare_response.dynamic_JS = shieldsquare_response_from_ss['dynamic_JS']
		n = shieldsquare_response_from_ss['ssresp'].to_i
		case n
		when 0
			shieldsquare_response.responsecode = SHIELDSQUARE_CODES_ALLOW
		when 1
			shieldsquare_response.responsecode = SHIELDSQUARE_CODES_MONITOR
		when 2
			shieldsquare_response.responsecode = SHIELDSQUARE_CODES_CAPTCHA
		when 3
			shieldsquare_response.responsecode = SHIELDSQUARE_CODES_BLOCK
		when 4
			shieldsquare_response.responsecode = SHIELDSQUARE_CODES_FFD
		else
			shieldsquare_response.responsecode = SHIELDSQUARE_CODES_ALLOW_EXP
			shieldsquare_response.reason = shieldsquare_response_from_ss['output']
		end

		shieldsquare_response
	end

	def self.handle_monitor_mode(shieldsquare_response, url, payload, timeout)
		if @@async_http_post == true
			shieldsquare_response_from_ss = shieldsquare_post_async url, payload, timeout
			shieldsquare_response.responsecode = SHIELDSQUARE_CODES_ALLOW
			shieldsquare_response.dynamic_JS = "var __uzdbm_c = 2+2"
		else
			shieldsquare_response_from_ss = shieldsquare_post_sync url, payload, timeout
			if shieldsquare_response_from_ss.blank?
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
		params=payload
		headers={}
		headers['Content-Type']='application/json'
		headers['Accept']='application/json'
		begin
			response = HTTParty.post(url, :body => params,:headers => headers, :timeout => timeout)
		rescue Exception => e
			response = nil
		end
		response
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