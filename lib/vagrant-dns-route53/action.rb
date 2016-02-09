require "vagrant/action/builder"

module VagrantPlugins
  module Dns
    module Route53
      module Action
        # Include the built-in modules so we can use them as top-level things.
        include Vagrant::Action::Builtin

        def self.create_records
          Vagrant::Action::Builder.new.tap do |b|
            b.use ConfigValidate
            b.use ConnectAWS
            b.use CreateRecords
          end
        end

        def self.delete_records
          Vagrant::Action::Builder.new.tap do |b|
            b.use ConfigValidate
            b.use ConnectAWS
            b.use DeleteRecords
          end
        end

        def self.reload_records
          Vagrant::Action::Builder.new.tap do |b|
            b.use ConfigValidate
            b.use ConnectAWS
            b.use DeleteRecords
            b.use CreateRecords
          end
        end

        # The autoload farm
        action_root = Pathname.new(File.expand_path("../action", __FILE__))
        autoload :ConnectAWS, action_root.join("connect_aws")
        autoload :CreateRecords, action_root.join("create_records")
        autoload :DeleteRecords, action_root.join("delete_records")
      end
    end
  end
end
