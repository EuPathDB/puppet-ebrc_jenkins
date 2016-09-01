
class ebrc_jenkins::params {

  # process and files owner
  $uid       = 822
  $gid       = 824
  $user      = 'jenkins'
  $group     = 'jenkins'
  $user_home = '/usr/local/home/jenkins'

  $instances = {
    'DEFAULT' => {
      'version'   => 'latest',
      'http_port' => 9181,
      'jmx_port'  => 9120,
    },
  }


}