Vagrant::Dns::Route53
=====================

Vagrant Plugin to manage AWS Route53 DNS Records



# Installation

```
vagrant plugin install vagrant-dns-route53
```


# Usage


## Hostname and Aliases

The hostname and any aliases will be used to create records on route53

```
config.vm.hostname = "www.example.com"
config.hostsupdater.aliases = ["alias.example.com", "alias2.example.com"]
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


# Sponsors

This plugin was made possible by [Shiftgig](https://www.shiftgig.com)


# Contributing

Pull Requests are welcome, bug reports less so.
I don't code much ruby, so I hope someone with more experience can clean things up maybe?


# License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

