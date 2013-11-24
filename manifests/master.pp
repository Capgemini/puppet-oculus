class oculus::master(
) {

  package { 'redis-server':
    ensure => installed,
  } ->
  service { 'redis-server':
    ensure => stopped,
  } ->
  file { '/etc/init.d/redis-server':
    ensure => absent,
  } ->
  file { '/opt/oculus/config/redis.conf':
    ensure  => present,
    content => template('oculus/redis.conf.erb'),
  } ->
  file { '/etc/init/oculus-redis.conf':
    ensure  => present,
    content => template('oculus/etc/init/oculus-redis.conf'),
  } ->
  service { 'oculus-redis':
    ensure => running,
  } ->
  class { 'oculus::worker':
    redis_host => 'localhost',
  }

}
