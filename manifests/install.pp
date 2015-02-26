# == Class: pidservice::install
#
# Installs the packages for Tomcat6, Postgresql, & PIDService.
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Michael Speth <spethm@landcareresearch.co.nz>
#
# === Copyright
# GPLv3
#
class pidservice::install {
  
  class { 'apache':
    servername    => 'test.liberator.zen.landcareresearch.co.nz',
    default_vhost => false,
  }

  include apache::mod::rewrite
  include apache::mod::proxy
  include apache::mod::headers
  include apache::mod::proxy_http

  # define resources to install for pidservice
  $tomcat_resources = {
    pidsvc => {
      'name'                                => 'jdbc/pidsvc',
      'auth'                                => 'Container',
      'type'                                => 'javax.sql.DataSource',
      'driverClassName'                     => 'org.postgresql.Driver',
      'url'                                 =>
            "jdbc:postgresql://${pidservice::servername}:5432/pidsvc",
      'username'                            => $pidservice::db_user,
      'password'                            => $pidservice::db_passwd,
      'maxActive'                           => '-1',
      'minIdle'                             => '0',
      'maxIdle'                             => '10',
      'maxWait'                             => '10000',
      'minEvictableIdleTimeMillis'          => '300000',
      'timeBetweenEvictionRunsMillis'       => '300000',
      'numTestsPerEvictionRun'              => '20',
      'poolPreparedStatements'              => true,
      'maxOpenPreparedStatements'           => '100',
      'testOnBorrow'                        => true,
      'accessToUnderlyingConnectionAllowed' => true,
      'validationQuery'                     => 'SELECT VERSION();'
    }
  }
  
  # note, java6 will be installed as a dependancy for tomcat6
  class { 'tomcat6':
    resources => $tomcat_resources,
  }
  
  Postgresql::Server::Pg_hba_rule {
    database => 'all',
    user => 'all',
  }
  
  postgresql::server::pg_hba_rule { 'local all':
    type        => 'local',
    user        => 'postgres',
    auth_method => 'peer',
    order       => '001',
  }

  postgresql::server::pg_hba_rule {
    'local is for Unix domain socket connections only':
    type        => 'local',
    user        => 'all',
    auth_method => 'peer',
    order       => '002',
  }

  postgresql::server::pg_hba_rule { 'ipv4 local connections':
    type        => 'host',
    user        => 'all',
    address     => '127.0.0.1/32',
    auth_method => 'md5',
    order       => '003',
  }

  postgresql::server::pg_hba_rule { 'landcare ipv4 connections':
    type        => 'host',
    user        => 'all',
    address     => '172.0.0.0/8',
    auth_method => 'md5',
    order       => '004',
  }

  postgresql::server::pg_hba_rule { 'allow access to ipv6 localhost':
    type        => 'host',
    address     => '::1/128',
    auth_method => 'md5',
    order       => '101',
  }

  # check if the postgresql version is to be set.
  if $pidservice::postgres_version != undef {
    class { 'postgresql::globals':
      manage_package_repo => true,
      version             => $pidservice::postgres_version,
      before              => Class['postgresql::server'],
    }
  }

  class { 'postgresql::server':
    listen_addresses     => $pidservice::listen_addresses,
    postgres_password    => $pidservice::postgres_password,
    pg_hba_conf_defaults => false,
  }
}