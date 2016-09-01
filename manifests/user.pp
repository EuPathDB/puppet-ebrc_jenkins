# Jenkins CI process owner
class ebrc_jenkins::user (
  $user  = $::ebrc_jenkins::user,
  $group = $::ebrc_jenkins::group,
  $uid   = $::ebrc_jenkins::uid,
  $gid   = $::ebrc_jenkins::gid,
) {

  $home = $::ebrc_jenkins::user_home

  user { $user:
    ensure     => 'present',
    uid        => $uid,
    gid        => $gid,
    comment    => 'Jenkins CI,,,root',
    home       => $home,
    shell      => '/bin/bash',
    managehome => false,
  }

  group { $group:
    ensure => present,
    gid    => $gid,
  }

  file { [
    "${home}/.bashrc",
    "${home}/.bash_profile",
    "${home}/.emacs",
    "${home}/.viminfo",
    "${home}/.bash_logout",
    "${home}/.bash_history"]:
    ensure  => absent,
    require => [ User[$user], File[$::ebrc_jenkins::user_home] ],
  }

}