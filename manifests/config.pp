# == Class: pidservice::config
#
# Configs the packages for PIDService
#
# === Parameters
#
#
# === Variables
#
# [*root*] The default location for the pidservice configuration.
#
# === Authors
#
# Michael Speth <spethm@landcareresearch.co.nz>
#
# === Copyright
# GPLv3
#
class pidservice::config {
  # files & dirs
  $root = '/etc/pidservice'

  # make sure that these directories exists
  file {[$root]:
    ensure => directory,
  } 


  if $pidservice::use_default_vhost == true {
    # setup the proxy which needs to be combined with user specified proxy.
    # used for setting up apache
    if $pidservice::enable_pidsvc_proxy == true {
      $proxypass_array = [
        { 'path' => '/pidsvc',
          'url'  => 'http://localhost:8080/pidsvc',
        }
      ]
  
      # concat the arrays.
      if $proxypass_array == undef {
        $proxypass_array_total = $pidservice::proxypass
      }else {
        $proxypass_array_total = concat($pidservice::proxypass ,$proxypass_array)
      }
    }else {
      $proxypass_array_total = $pidservice::proxypass
    }
  
  
    # apache config
    apache::vhost { $pidservice::servername:
      port                  => '80',
      docroot               => '/var/www',
      proxy_preserve_host   => true,
      proxy_pass            => $proxypass_array_total,
      redirectmatch_status  => ['permanent'],
      redirectmatch_regexp  => ['^/$ /static/'],
      rewrites              => $pidservice::rewrite_rules,
    }
  }
  
  # database config
  postgresql::server::role {'pidsvc-admin':
    password_hash => $pidservice::db_passwd,
  }
  postgresql::server::db {'pidsvc':
    user     => "$pidservice::db_user",
    owner    => "$pidservice::db_user",
    password => $pidservice::db_passwd,
    require  => Postgresql::Server::Role ['pidsvc-admin'],
  }

  file {"$root/postgresql.sql":
    ensure => file,
    source => 'puppet:///modules/pidservice/postgresql.sql', 
  }

  # create the language, need to do this via command since
  # its not in the postgresql module and not time in the project to add it properly
  include check_run

  $task_language = 'create_language'
  $task_sql = 'run_sql'
  check_run::task{$task_language:
    exec_command  => '/usr/bin/createlang plpgsql pidsvc',
    user          => 'postgres',
    require       => Postgresql::Server::Db['pidsvc'],
    returns       => ['0','1'],
  }
  ->

  #TODO appears the root/postgresql.sql is not running, debug this
  check_run::task{$task_sql:
    exec_command => "/usr/bin/psql -d pidsvc -f $root/postgresql.sql",
    user => 'postgres',
    require => [ Check_run::Task[$task_language],
                 File["$root/postgresql.sql"],
                 Postgresql::Server::Db['pidsvc'],
    ],
    returns => ['0','1','2'],
  }
  
  tomcat6::app{'pidsvc':
    war_url => 'https://cgsrv1.arrc.csiro.au/swrepo/PidService/jenkins/trunk/pidsvc-latest.war',
    jar_lib_url => 'http://jdbc.postgresql.org/download/postgresql-9.3-1100.jdbc4.jar',
  }
}
