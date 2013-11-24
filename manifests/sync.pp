class oculus::sync(
) {

  cron { 'oculus-sync':
    command => '/opt/oculus/scripts/import.rb > /var/log/oculus/import.log 2>&1',
    minute  => '*/2',
    require => Class['oculus::config'],
  }

}
