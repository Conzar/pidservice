# pidservice

[![Puppet Forge](http://img.shields.io/puppetforge/v/conzar/pidservice.svg)](https://forge.puppetlabs.com/conzar/pidservice)
[![Build Status](https://travis-ci.org/Conzar/pidservice.svg?branch=master)](https://travis-ci.org/Conzar/pidservice)

## About

Installs the [PIDService](https://www.seegrid.csiro.au/wiki/Siss/PIDService) and software required to support the PIDService such as Tomcat6 & Postgresql.

## Configuration

There is one class that needs to be declared: pidservice.  pidservice installs tomcat6 and loads itself as a webapp.

### Required Parameters

#### `servername` 
The fqdn name of the server.

### Optional Parameters

#### `enable_pidsvc_proxy`
True (default) if /pidsvc should be proxied from localhost:8080/pidsvc

#### `proxypass`
An array for the proxypass rules for the main vhost.

#### `rewrite_rules`
An array for the rewrite rules for the main vhost.

#### `db_passwd`
The database password for the pidsvc-admin user.

#### `postgres_password`
The password to the postgresql database

#### `postgres_version`
The postgresql version to use.  If left undef, uses the default for the postgresql puppet module.
Default: undef

#### `use_default_vhost`
Allow this module to control the vhost and false otherwise. 
Defaults to true.  If false, proxypass and rewrite_rules are ignored.

#### `listen_addresses`
The address range that is allowed for the postgresql db.

#### `ipv4_acls`
Sets the acls for the postgresql server.

## Usage

```
	class {'pidservice':
		servername => 'localhost',
	}
```

Open a web browser to http://<hostname>:8080/pidsvc

## Limitations

Only works with debian based OS's.

## Development

The module is open source and available on github.  Please fork!