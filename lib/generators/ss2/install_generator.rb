require 'rails'

module Ss2
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "Creates ss2_config initializer"

    def copy_initializer
    	modes = ["Monitor", "Active"]
    	puts "Server name: "
    	puts "    1. Asia/India - ss_sa.shieldsquare.net"
    	puts "    2. North America - ss_scus.shieldsquare.net"
    	puts "    3. Europe - ss_ew.shieldsquare.net"
    	puts "    4. Australia - ss_au.shieldsquare.net"
    	server_code = gets.chomp
  		case server_code.to_i
  		when 1
  			@server_name = "ss_sa.shieldsquare.net"
  		when 2
  			@server_name = "ss_scus.shieldsquare.net"
  		when 3
  			@server_name = "ss_ew.shieldsquare.net"
  		when 4
  			@server_name = "ss_au.shieldsquare.net"
  		else
  			@server_name = "ss_sa.shieldsquare.net"
  		end
    	print "Sid: "
    	@sid = gets.chomp
    	puts "Mode: "
    	puts "   1. Monitor"
    	puts "   2. Active"
    	@mode = gets.chomp
    	case @mode
    	when 1
    		@mode = "Monitor"
    	when 2
    		@mode = "Active"
    	else
    		@mode = "Monitor"
    	end
      template '../templates/ss2_config.rb', 'config/initializers/ss2_config.rb'
    end
  end
end