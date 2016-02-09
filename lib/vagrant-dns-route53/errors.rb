require "vagrant"

module VagrantPlugins
  module Dns
    module Route53
      module Errors
        class VagrantDnsRoute53Error < Vagrant::Errors::VagrantError
          error_namespace("vagrant_dns_route53.errors")
        end

        class FogError < VagrantDnsRoute53Error
          error_key(:fog_error)
        end
      end
    end
  end
end
