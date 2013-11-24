class oculus::worker(
  $redis_host,
  $redis_port = 6379,
) {

  class { 'oculus::repo':
  } ->
  package { [ 'ruby1.9.3', 'build-essential', 'libxml2-dev', 'libxslt1-dev' ]:
    ensure => installed,
  } ->
  package { 'bundler':
    ensure   => installed,
    provider => gem,
  } ->
  exec { 'install oculus gems':
    cwd     => '/opt/oculus',
    command => '/usr/local/bin/bundle install && touch .bundle-installed',
    unless  => '/usr/bin/test -f .bundle-installed'
  } -> 
  file { '/opt/oculus/Rakefile.orig':
    ensure => present,
    source => '/opt/oculus/Rakefile',
  } ->
  exec { 'set redis server':
    cwd     => '/opt/oculus',
    command => "/bin/sed s/oculusredis01:6379/${redis_host}:${redis_port}/ Rakefile.orig > Rakefile",
    onlyif  => '/usr/bin/diff Rakefile.orig Rakefile',
  } ->
  file { '/var/run/oculus':
    ensure => directory,
  } ->
  file { '/var/log/oculus':
    ensure => directory,
  } ->
  file { '/etc/init/oculus-workers.conf':
    ensure  => present,
    content => template('oculus/etc/init/oculus-workers.conf.erb'),
  } ~>
  service { 'oculus-workers':
    ensure => running,
  }

}
