require "fog"
require "log4r"
require "vagrant/util/ssh"

module VagrantPlugins
  module Dns
    module Route53
      module Action
        # This action connects to AWS, verifies credentials work, and
        # puts the AWS connection object into the `:aws_compute` key
        # in the environment.
        class ConnectAWS
          # For quick access to the `SSH` class.
          include Vagrant::Util

          def initialize(app, env)
            @app    = app
            @logger = Log4r::Logger.new("vagrant_dns_route53::action::connect_aws")
          end

          def call(env)
            if env[:machine].config.route53.enable == true
              # Build the map of aliases and ips
              env[:alias_map] = {}

              aliases = Array(env[:machine].config.vm.hostname)
              aliases.concat(env[:machine].config.route53.aliases) if env[:machine].config.route53.aliases

              env[:machine].config.vm.networks.each do |network|
                if network[0] == :private_network || network[0] == :public_network
                  ip = network[1][:ip]

                  if network[1][:route53] == "skip"
                    env[:ui].info("[vagrant-dns-route53] Skipping route53 entries for #{ip}")
                  else
                    aliases.each do |hostname|
                      env[:alias_map][hostname] = ip if !ip.nil?
                    end
                  end
                end
              end

              # Build the fog config
              fog_config = {
                :provider              => :aws,
                :aws_access_key_id     => env[:machine].config.route53.access_key_id,
                :aws_secret_access_key => env[:machine].config.route53.secret_access_key,
                :aws_session_token     => env[:machine].config.route53.session_token
              }
              fog_config[:version]  = env[:machine].config.route53.version if env[:machine].config.route53.version

              @logger.info("Connecting to AWS...")
              env[:ui].info("Connecting to AWS...")
              env[:route53] = Fog::DNS.new(fog_config)
            end

            @app.call(env)
          end
        end
      end
    end
  end
end
