class oculus::webapp(
) {

  class { 'oculus::repo':
    bundle_install => true,
  } ->
  file { '/etc/init/oculus-webapp.conf':
    ensure  => present,
    content => template('oculus/etc/init/oculus-webapp.conf.erb'),
  } ~>
  service { 'oculus-webapp':
    ensure => running,
  }

}
