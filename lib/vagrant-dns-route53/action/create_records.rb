require "log4r"


module VagrantPlugins
  module Dns
    module Route53
      module Action
        class CreateRecords

          def initialize(app, env)
            @app    = app
            @logger = Log4r::Logger.new("vagrant_route53_updater::action::create_record")
          end

          def call(env)
            if env[:machine].config.route53.enable == true && !env[:alias_map].empty?
              if env[:machine_action] == :resume && env[:machine].config.route53.enable_suspend_resume == false
                return
              end

              env[:alias_map].each do |hostname, ip|
                @logger.info("Checking for existing '#{hostname}' Route53 record...")
                env[:ui].info("Checking for existing '#{hostname}' Route53 record...")

                record_name = hostname + "." unless hostname.end_with?(".")

                begin
                  zone = env[:route53].zones.get(env[:machine].config.route53.zone_id)
                  record = zone.records.get(record_name)
                rescue Fog::DNS::AWS::Error => err
                  @logger.info("AWS error: #{err.message}")
                  env[:ui].info("AWS error: #{err.message}")
                end

                if record.nil? || record.attributes[:name] != record_name
                  @logger.info("Creating Route53 record...")
                  env[:ui].info("Creating Route53 record...")

                  begin
                    new_record = zone.records.new({
                      :value => ip,
                      :name  => record_name,
                      :type  => "A",
                      :ttl   => "60"
                    })
                    new_record.save
                  rescue Fog::DNS::AWS::Error => err
                    @logger.info("AWS error: #{err.message}")
                    env[:ui].info("AWS error: #{err.message}")
                  end

                elsif record.attributes[:value][0] != ip
                  @logger.info("Route53 Record already exists for #{hostname}. Please update manually. Skipping...")
                  env[:ui].info("Route53 Record already exists for #{hostname}. Please update manually. Skipping...")
                end
              end
            end
          end
        end
      end
    end
  end
end
