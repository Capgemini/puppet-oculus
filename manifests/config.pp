class oculus::config(
  $elasticsearch_servers,
  $skyline_host,
  $redis_host,
  $skyline_port          = 6379,
  $skyline_listener_port = 2015,
  $redis_port            = 6379,
) {

  file { '/opt/oculus/config/config.yml':
    ensure => present,
    content => template('oculus/config.yml.erb'),
    require => Class['oculus::repo'],
  }

}
