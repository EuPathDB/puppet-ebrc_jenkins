# For list of valid versions, see
# http://mirrors.jenkins-ci.org/war/

class ebrc_jenkins (
  Boolean $manage_user = true,
  Hash    $instances   = $::ebrc_jenkins::params::instances,
  String  $user        = $::ebrc_jenkins::params::user,
  String  $group       = $::ebrc_jenkins::params::group,
  String  $user_home   = $::ebrc_jenkins::params::user_home,
  Integer $uid         = $::ebrc_jenkins::params::uid,
  Integer $gid         = $::ebrc_jenkins::params::gid,
) inherits ebrc_jenkins::params {

  include ::ebrc_jenkins::core

  if $manage_user {
    include ::ebrc_jenkins::user
  }

  $instances.each |$name, $instance| {
    ebrc_jenkins::instance { $name:
      http_port => $instance['http_port'],
      jmx_port  => $instance['jmx_port'],
      version   => $instance['version'],
      require   => Class['::ebrc_jenkins::core'],
    }
  }

}