require 'rails/generators'

module Databound
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      desc 'This generator adds Databound to the asset pipeline'

      def add_assets
        js_manifest = 'app/assets/javascripts/application.js'
        coffee_manifest = 'app/assets/javascripts/application.coffee'

        if File.exist?(js_manifest)
          insert_into_file js_manifest, "//= require databound\n", after: "jquery_ujs\n"
        elsif File.exist?(coffee_manifest)
          insert_into_file coffee_manifest, "#= require databound\n", after: "jquery_ujs\n"
        else
          copy_file 'application.js', js_manifest
        end
      end

      def add_databound
        copy_file 'js/dist/databound-standalone.js', 'vendor/assets/javascripts/databound.js'
      end
    end
  end
end
