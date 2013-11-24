class oculus::elasticsearch(
  $root,
  $service,
) {

  $plugin_source = "${root}/elasticsearch-oculus-plugin"

  class { 'oculus::repo': } ->
  file { $plugin_source:
    ensure  => directory,
    source  => '/opt/oculus/resources/elasticsearch-oculus-plugin',
    recurse => true,
    require => File[$root],
  } ->
  exec { 'build oculus plugin':
    cwd     => $plugin_source,
    command => '/opt/ruby/bin/rake build',
    unless  => '/usr/bin/test -f OculusPlugins.jar',
  } ->
  file { "${root}/lib/OculusPlugins.jar":
    ensure => present,
    source => "${plugin_source}/OculusPlugins.jar",
  } ->
  exec { 'add script.native config':
    cwd     => "${root}/config",
    command => '/bin/echo "
script.native:
    oculus_euclidian.type: com.etsy.oculus.tsscorers.EuclidianScriptFactory
    oculus_dtw.type: com.etsy.oculus.tsscorers.DTWScriptFactory" >> elasticsearch.yml',
    unless  => '/bin/grep "oculus_euclidian.type" elasticsearch.yml',
    notify  => Service[$service],
  } 

}
