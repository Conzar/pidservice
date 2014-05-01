# pidservice

Author: Michael Speth <spethm@landcareresearch.co.nz>

## About

Installs the PIDService and software required to support the PIDService
such as Tomcat6 & Postgresql.

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

#### `listen_addresses`
The address range that is allowed for the postgresql db.

#### `ipv4_acls`
Sets the acls for the postgresql server.

#### `postgres_password`
The password to the postgresql database

#### `use_default_vhost`
Allow this module to control the vhost and false otherwise. 
Defaults to true.  If false, proxypass and rewrite_rules are ignored.

## Usage

	class {'pidservice':
		servername => 'localhost',
	}

## License

GPL version 3

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, [see](http://www.gnu.org/licenses/).
