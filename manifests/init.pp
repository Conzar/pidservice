# == Class: pidservice
#
# Installs and manages the PIDService
#
# === Paramaters
#
# [*servername*] the fqdn name of the server.
# [*enable_pidsvc_proxy*] true (default) if /pidsvc should be proxied from localhost:8080/pidsvc
# [*proxypass*] an array for the proxypass rules for the main vhost.
# [*rewrite_rules*] an array for the rewrite rules for the main vhost.
# [*db_passwd*] the database password for the pidsvc-admin user.
# [*listen_addresses*] the address range that is allowed for the postgresql db.
# [*ipv4_acls*] Sets the acls for the postgresql server.
# [*postgres_password*] The password to the postgresql database
# [*use_default_vhost*] allow this module to control the vhost and false otherwise. 
#                       defaults to true.  If false, proxypass and rewrite_rules are ignored.
#
# === Variables
# [*db_user*] the username of the database
#
# === Examples
#
#  class { pidservice:
#  }
#
# === Authors
#
# Michael Speth <spethm@landcareresearch.co.nz>
#
# === Copyright
# GPLv3
#
class pidservice (
  $servername,
  $enable_pidsvc_proxy = true,
  $proxypass = undef,
  $rewrite_rules = undef,
  $db_passwd = 'pass',
  $listen_addresses = '*',
  $ipv4_acls = [
'local   all             postgres                                peer',
# "local" is for Unix domain socket connections only
'local   all             all                                     peer',
# IPv4 local connections:
'host    all             all             127.0.0.1/32            md5',
'host    all             all             172.0.0.0/8           md5',
# IPv6 local connections:
'host    all             all             ::1/128                 md5'
],
  $postgres_password = undef,
  $use_default_vhost = true,
){

  $db_user = 'pidsvc-admin'

  class { 'pidservice::install': }
  ->
  class { 'pidservice::config': }
}