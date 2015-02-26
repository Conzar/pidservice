# == Class: pidservice
#
# Installs and manages the PIDService
#
# === Parameters
#
# [*servername*]
#   The fqdn name of the server.
#
# [*enable_pidsvc_proxy*]
#   True (default) if /pidsvc should be proxied from localhost:8080/pidsvc
#
# [*proxypass*]
#   An array for the proxypass rules for the main vhost.
#
# [*rewrite_rules*]
#   An array for the rewrite rules for the main vhost.
#
# [*headers*]
#   Adds lines to replace the header for the apache vhost configuration.
#
# [*db_passwd*]
#   The database password for the pidsvc-admin user.
#
# [*postgres_password*]
#   The password to the postgresql database
#
# [*postgres_version*]
#   The postgresql version to use.  If left undef, uses the default for
#   the postgresql puppet module.
#   Default: undef
#
# [*postgis_version*]
#   Enable postgis extension for the database with the specified version.
#   Default: undef
#
# [*use_default_vhost*]
#   Allow this module to control the vhost and false otherwise. 
#   Defaults to true.  If false, proxypass and rewrite_rules are ignored.
#
# [*listen_addresses*]
#   The address range that is allowed for the postgresql db.
#
# [*ipv4_acls*]
#   Sets the acls for the postgresql server.
#
# === Variables
#
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
  $proxypass           = undef,
  $rewrite_rules       = undef,
  $headers             = undef,
  $db_passwd           = 'pass',
  $postgres_password   = undef,
  $postgres_version    = undef,
  $postgis_version     = undef,
  $use_default_vhost   = true,
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
){

  $db_user = 'pidsvc-admin'

  class { 'pidservice::install': }
  ->
  class { 'pidservice::config': }
}
