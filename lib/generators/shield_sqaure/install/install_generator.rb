module ShieldSquare
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates ss2_config initializer"

      def copy_initializer
        template '../templates/ss2_config.rb', 'config/initializers/ss2_config.rb'
      end
    end
  end
end