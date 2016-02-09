begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant DNS Route53 Plugin must be run within Vagrant"
end

#require "vagrant-dns-route53/action"

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.7.4"
  raise "The Vagrant DNS Route53 plugin is only compatible with Vagrant 1.7.4+"
end

module VagrantPlugins
  module Dns
    module Route53
      class Plugin < Vagrant.plugin("2")
        name "dns-route53"
        description <<-DESC
          A Vagrant plugin that manages route53 records
        DESC

        # This initializes the internationalization strings.
        def self.setup_i18n
          I18n.load_path << File.expand_path("locales/en.yml", Route53.source_root)
          I18n.reload!
        end

        # This sets up our log level to be whatever VAGRANT_LOG is.
        def self.setup_logging
          require "log4r"

          level = nil
          begin
            level = Log4r.const_get(ENV["VAGRANT_LOG"].upcase)
          rescue NameError
            # This means that the logging constant wasn't found,
            # which is fine. We just keep `level` as `nil`. But
            # we tell the user.
            level = nil
          end

          # Some constants, such as "true" resolve to booleans, so the
          # above error checking doesn't catch it. This will check to make
          # sure that the log level is an integer, as Log4r requires.
          level = nil if !level.is_a?(Integer)

          # Set the logging level on all "vagrant" namespaced
          # logs as long as we have a valid level.
          if level
            logger = Log4r::Logger.new("vagrant_dns_route53")
            logger.outputters = Log4r::Outputter.stderr
            logger.level = level
            logger = nil
          end
        end

        config(:route53) do
          setup_i18n
          setup_logging
          require_relative "config"
          Config
        end

        action_hook(:CreateRecords, :machine_action_up) do |hook|
          hook.append(Action.create_records)
        end

        action_hook(:DeleteRecords, :machine_action_destroy) do |hook|
          hook.append(Action.delete_records)
        end

        action_hook(:ReloadRecords, :machine_action_resume) do |hook|
          hook.append(Action.reload_records)
        end

        action_hook(:DeleteRecords, :machine_action_halt) do |hook|
          hook.append(Action.delete_records)
        end

        action_hook(:DeleteRecords, :machine_action_suspend) do |hook|
          hook.append(Action.delete_records)
        end

        action_hook(:ReloadRecords, :machine_action_resume) do |hook|
          hook.append(Action.reload_records)
        end
      end
    end
  end
end
