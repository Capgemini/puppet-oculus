class oculus::repo(
  $bundle_install = false,
) {

  package { 'git':
    ensure => installed,
  }

  vcsrepo { '/opt/oculus':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/etsy/oculus.git',
    require  => Package['git'],
  }

  if $bundle_install {
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
      unless  => '/usr/bin/test -f .bundle-installed',
      require => Vcsrepo['/opt/oculus'],
    }
  }

}
