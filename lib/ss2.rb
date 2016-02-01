require "ss2/version"
require 'ss2/engine'
require 'rack/get_data'
require 'cgi'
require 'httparty'
require 'addressable/uri'

module Ss2
	class URI::Parser
	  def split url
	    a = Addressable::URI::parse url
	    [a.scheme, a.userinfo, a.host, a.port, nil, a.path, nil, a.query, a.fragment]
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
	#Request Variables
	shieldsquare_request = {
		_zpsbd0: false,
		_zpsbd1:"",
		_zpsbd2: "",
		_zpsbd3: "",
		_zpsbd4: "",
		_zpsbd5: "",
		_zpsbd6: "",
		_zpsbd7: "",
		_zpsbd8: "",
		_zpsbd9: "",
		_zpsbda: "",
		__uzma: "",
		__uzmb: 0,
		__uzmc: "",
		__uzmd: 0
	}

	#Curl Response Variables
	$ShieldsquareCurlResponseCode_error_string = ""
	$ShieldsquareCurlResponseCode_responsecode = 0

	#Response Variables
	$ShieldsquareResponse_pid = ""
	$ShieldsquareResponse_responsecode= 0
	$ShieldsquareResponse_url = ""
	$ShieldsquareResponse_reason =""

	#Codes Variables
	$ShieldsquareCodes_ALLOW   = 0
	$ShieldsquareCodes_MONITOR = 1
	$ShieldsquareCodes_CAPTCHA = 2
	$ShieldsquareCodes_BLOCK   = 3
	$ShieldsquareCodes_FFD   = 4
	$ShieldsquareCodes_ALLOW_EXP = -1

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
		
		shieldsquare_pid = shieldsquare_generate_pid @@sid
		
		
		if @@_ipaddr == "REMOTE_ADDR"
			$IP_ADDRESS = request.remote_ip
		else
			$IP_ADDRESS = request.headers[@@_ipaddr]
		end

		if $IP_ADDRESS.blank?
			$IP_ADDRESS = "0.0.0.0"
		end 

		if cookies['__uzma']!="" and (cookies['__uzma'].to_s).length > 3
			shieldsquare_lastaccesstime =  cookies['__uzmd']
			shieldsquare_uzmc=0
			shieldsquare_uzmc= cookies['__uzmc']
			shieldsquare_uzmc=shieldsquare_uzmc[shieldsquare_e..shieldsquare_e+1]
			shieldsquare_a = ((shieldsquare_uzmc.to_i-shieldsquare_c)/shieldsquare_b) + shieldsquare_d
			shieldsquare_uzmc= rand(shieldsquare_low..shieldsquare_high).to_s + (shieldsquare_c+shieldsquare_a*shieldsquare_b).to_s + rand(shieldsquare_low..shieldsquare_high).to_s
			cookies[:__uzmc] = { :value => shieldsquare_uzmc, :expires => Time.now + 3600*24*365*10} 
			cookies[:__uzmd] = { :value => Time.now.to_i.to_s, :expires => Time.now + 3600*24*365*10} 
			$ShieldsquareRequest__uzma = cookies["__uzma"]
			$ShieldsquareRequest__uzmb = cookies["__uzmb"]
			$ShieldsquareRequest__uzmc = shieldsquare_uzmc
			$ShieldsquareRequest__uzmd = shieldsquare_lastaccesstime
		
		else

			id = DateTime.now.strftime('%Q')# Get current date to the milliseconds
			# Reverse it
			shieldsquare_uzma = id.to_i(36).to_s
			shieldsquare_lastaccesstime = Time.now.to_i
			shieldsquare_uzmc= rand(shieldsquare_low..shieldsquare_high).to_s + (shieldsquare_c+shieldsquare_a*shieldsquare_b).to_s + rand(shieldsquare_low..shieldsquare_high).to_s
			cookies[:__uzma] = { :value => shieldsquare_uzma, :expires => Time.now + 3600*24*365*10} 
			cookies[:__uzmb] = { :value => Time.now.to_i.to_s, :expires => Time.now + 3600*24*365*10} 
			cookies[:__uzmc] = { :value => shieldsquare_uzmc, :expires => Time.now + 3600*24*365*10} 
			cookies[:__uzmd] = { :value => Time.now.to_i.to_s, :expires => Time.now + 3600*24*365*10} 
			$ShieldsquareRequest__uzma = shieldsquare_uzma
			$ShieldsquareRequest__uzmb = Time.now.to_i
			$ShieldsquareRequest__uzmc = shieldsquare_uzmc
			$ShieldsquareRequest__uzmd = shieldsquare_lastaccesstime
		end
		if @@mode == 'Active'
			shieldsquare_request._zpsbd0 = true;
		else
			shieldsquare_request._zpsbd0 = false;
		end

		shieldsquare_request._zpsbd1 = @@sid
		shieldsquare_request._zpsbd2 = shieldsquare_pid
		shieldsquare_request._zpsbd3 = request.headers['HTTP_REFERER']
		shieldsquare_request._zpsbd4 = request.headers['REQUEST_URI']
		shieldsquare_request._zpsbd5 = request.session_options[:id]
		shieldsquare_request._zpsbd6 = $IP_ADDRESS
		shieldsquare_request._zpsbd7 = request.headers['HTTP_USER_AGENT']
		shieldsquare_request._zpsbd8 = shieldsquare_calltype
		shieldsquare_request._zpsbd9 = shieldsquare_username
		shieldsquare_request._zpsbda = Time.now.to_i
		shieldsquare_json_obj = {
			:_zpsbd0 => shieldsquare_request._zpsbd0,
			:_zpsbd1 => shieldsquare_request._zpsbd1,
			:_zpsbd2 => shieldsquare_request._zpsbd2,
			:_zpsbd3 => shieldsquare_request._zpsbd3,
			:_zpsbd4 => shieldsquare_request._zpsbd4,
			:_zpsbd5 => shieldsquare_request._zpsbd5,
			:_zpsbd6 => shieldsquare_request._zpsbd6,
			:_zpsbd7 => shieldsquare_request._zpsbd7,
			:_zpsbd8 => shieldsquare_request._zpsbd8,
			:_zpsbd9 => shieldsquare_request._zpsbd9,
			:_zpsbda => shieldsquare_request._zpsbda,
			:__uzma => $ShieldsquareRequest__uzma,
			:__uzmb => $ShieldsquareRequest__uzmb,
			:__uzmc => $ShieldsquareRequest__uzmc,
			:__uzmd => $ShieldsquareRequest__uzmd 
		}
		$ShieldsquareResponse_pid = shieldsquare_pid
		$ShieldsquareResponse_url = @@js_url

		if @@mode == 'Active'
			shieldsquareCurlResponseCode=shieldsquare_post_sync shieldsquare_service_url, shieldsquare_json_obj,@@timeout_value
			if shieldsquareCurlResponseCode['response'] != 200
				$ShieldsquareResponse_responsecode = $ShieldsquareCodes_ALLOW_EXP
				$ShieldsquareResponse_reason = shieldsquareCurlResponseCode['output']
			else
				shieldsquareResponse_from_ss = JSON.parse(shieldsquareCurlResponseCode['output'])
				$ShieldsquareResponse_dynamic_JS = shieldsquareResponse_from_ss['dynamic_JS']
				n=shieldsquareResponse_from_ss['ssresp'].to_i
				if n==0
					$ShieldsquareResponse_responsecode = $ShieldsquareCodes_ALLOW
				elsif n==1
					$ShieldsquareResponse_responsecode = $ShieldsquareCodes_MONITOR
				elsif n==2
					$ShieldsquareResponse_responsecode = $ShieldsquareCodes_CAPTCHA
				elsif n==3
					$ShieldsquareResponse_responsecode = $ShieldsquareCodes_BLOCK
				elsif n==4
					$ShieldsquareResponse_responsecode = $ShieldsquareCodes_FFD
				else
					$ShieldsquareResponse_responsecode = $ShieldsquareCodes_ALLOW_EXP
					$ShieldsquareResponse_reason = shieldsquareCurlResponseCode['output']
				end 
			end

		else
			syncresponse=shieldsquare_post_sync shieldsquare_service_url, shieldsquare_json_obj,@@timeout_value
			Rails.logger.debug "Sample logging -- #{syncresponse}"
			$ShieldsquareResponse_responsecode = $ShieldsquareCodes_MONITOR
			$ShieldsquareResponse_reason = syncresponse['output']
			$ShieldsquareResponse_dynamic_JS = "var __uzdbm_c = 2+2"
		end

		shieldsquareResponse = Hash["pid" => $ShieldsquareResponse_pid, "responsecode" => $ShieldsquareResponse_responsecode,"url" => $ShieldsquareResponse_url,"reason" => $ShieldsquareResponse_reason,"dynamic_JS" =>$ShieldsquareResponse_dynamic_JS]
		return shieldsquareResponse
	end

	def self.shieldsquare_post_async(url, payload, timeout)
		Thread.new do
			response = shieldsquare_post_sync url, payload, timeout
			Rails.logger.debug response
		end		
		return
	end	

	def self.shieldsquare_post_sync(url, payload, timeout)
		# Sendind the Data to the ShieldSquare Server
		params=payload
		headers={}
		headers['Content-Type']='application/json'
		headers['Accept']='application/json'
		begin
			response = HTTParty.post(url, :query => params,:headers => headers, :timeout => timeout)
			Rails.logger.debug response
		rescue Exception => e
			Rails.logger.debug e
			response=Hash["response"=>0,"output"=>"Request Timed Out/Server Not Reachable"]
		end
		return response
	end

	def self.microtime()
		epoch_mirco = Time.now.to_f
		epoch_full = Time.now.to_i
		epoch_fraction = epoch_mirco - epoch_full
		return epoch_fraction.to_s + ' ' + epoch_full.to_s
	end

	def self.shieldsquare_generate_pid(shieldsquare_sid)
		t=microtime
		dt=t.split(" ")
		p = @@sid.split("-")
		sid_min = p[3].to_i(16)
		rmstr1=("00000000"+(dt[1].to_i).to_s(16)).split(//).last(4).join("").to_s
		rmstr2=("0000" + ((dt[0].to_f * 65536).round).to_s(16)).split(//).last(4).join("").to_s
		return sprintf('%08s-%04x-%04s-%04s-%04x%04x%04x', shieldsquare_IP2Hex(),sid_min,rmstr1,rmstr2,(rand() * 0xffff).to_i,(rand() * 0xffff).to_i,(rand() * 0xffff).to_i)
	end

	def self.shieldsquare_IP2Hex()
		hexx=""
		ip=$IP_ADDRESS
		part=ip.split('.')
		hexx=''
		for i in 0..part.count-1
			hexx= hexx + ("0"+(part[i].to_i).to_s(16)).split(//).last(2).join("").to_s
		end
		return hexx
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
