Vagrant::Dns::Route53
=====================

Vagrant Plugin to manage AWS Route53 DNS Records



# Installation

```
vagrant plugin install vagrant-dns-route53
```


# Usage

- [optional] `enable` Toggles the plugin (default: false)
- [optional] `enable_suspend_resume` Toggles adding/removing records upon suspend/resume (default: false)
- [optional] `version` AWS api version to use. Don't set unless you know what you are doing
- [required] `access_key_id` The access key ID for accessing AWS
- [required] `secret_access_key` The secret access key for accessing AWS
- [optional] `session_token` The token associated with the key for accessing AWS
- [required] `zone_id` The Route53 Zone ID
- [optional] `aliases` The aliases to insert to the specified Zone


## Hostname and Aliases

The hostname and any aliases will be used to create records on route53

```
config.vm.hostname = "www.example.com"
config.route53.aliases = ["alias.example.com", "alias2.example.com"]
```


## Route53

```
config.route53.access_key_id     = "a1b2c3d4e5f6"
config.route53.secret_access_key = "a1b2c3d4e5f6"
config.route53.zone_id           = "a1b2c3d4e5f6"
```


## Network

This plugin works only for `:private_network` and `:public_network` utilizing a *static* ip address

```
config.vm.network :private_network, ip: "192.168.1.100"
```

or

```
config.vm.network :public_network, bridge: "wlan0", ip: "192.168.1.100"
```


## Skipping a network

To skip a network, add `route53: "skip"` option to network configuration:

```
config.vm.network "private_network", ip: "192.168.1.100", route53: "skip"
```


## Adding/Removing Records on Suspend/Halt

```
config.route53.enable_suspend_resume = true
```


# Caveats

- Only supports static IP addresses
- Only supports one domain/zone


# IAM Permissions

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:CreateHostedZone",
                "route53:GetHostedZone",
                "route53:ListHostedZones",
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/1A2B3C4D5E6F"
            ]
        }
    ]
}
```


# Sponsors

This plugin was made possible by [Shiftgig](https://www.shiftgig.com)


# Contributing

Pull Requests are welcome. I don't code much ruby, so I hope someone with more experience can clean things up maybe?


# License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

