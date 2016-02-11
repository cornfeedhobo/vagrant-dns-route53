require "vagrant"

module VagrantPlugins
  module Dns
    module Route53
      class Config < Vagrant.plugin("2", :config)
        # Toggle
        #
        # @return [String]
        attr_accessor :enable

        # Destroy and Create records on suspend/resume
        #
        # @return [String]
        attr_accessor :enable_suspend_resume

        # The version of the AWS api to use
        #
        # @return [String]
        attr_accessor :version

        # The access key ID for accessing AWS.
        #
        # @return [String]
        attr_accessor :access_key_id

        # The secret access key for accessing AWS.
        #
        # @return [String]
        attr_accessor :secret_access_key

        # The token associated with the key for accessing AWS.
        #
        # @return [String]
        attr_accessor :session_token

        # The Route53 Zone ID
        #
        # @return [String]
        attr_accessor :zone_id

        # The aliases to insert to the specified Zone
        #
        # @return [String]
        attr_accessor :aliases

        def initialize(region_specific=false)
          @enable                = UNSET_VALUE
          @enable_suspend_resume = UNSET_VALUE
          @version               = UNSET_VALUE
          @access_key_id         = UNSET_VALUE
          @secret_access_key     = UNSET_VALUE
          @session_token         = UNSET_VALUE
          @zone_id               = UNSET_VALUE
          @aliases               = UNSET_VALUE
        end

        def finalize!
          @enable                = false if @enable                == UNSET_VALUE
          @enable_suspend_resume = false if @enable_suspend_resume == UNSET_VALUE
          @version               = nil   if @version               == UNSET_VALUE
          @zone_id               = nil   if @zone_id               == UNSET_VALUE
          @aliases               = nil   if @aliases               == UNSET_VALUE

          # Try to get access keys from standard AWS environment variables; they
          # will default to nil if the environment variables are not present.
          @access_key_id     = ENV['AWS_ACCESS_KEY']    if @access_key_id     == UNSET_VALUE
          @secret_access_key = ENV['AWS_SECRET_KEY']    if @secret_access_key == UNSET_VALUE
          @session_token     = ENV['AWS_SESSION_TOKEN'] if @session_token     == UNSET_VALUE
        end

        def validate(machine)
          errors = _detected_errors

          if @enable
            errors << I18n.t("vagrant_dns_route53.config.zone_id_required") if @zone_id.nil?
            errors << I18n.t("vagrant_dns_route53.config.access_key_id_required") if @access_key_id.nil?
            errors << I18n.t("vagrant_dns_route53.config.secret_access_key_required") if @secret_access_key.nil?
          end

          { "DNS Route53" => errors }
        end
      end
    end
  end
end
