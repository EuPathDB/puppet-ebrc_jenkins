# Runs Jenkins as straight java app (builtin Winstone server, not in Tomcat)

class ebrc_jenkins::core {

  $jenkins_user_home = $::ebrc_jenkins::user_home
  $instance_base_dir = "${jenkins_user_home}/Instances"
  $user              =  $::ebrc_jenkins::user
  $group             =  $::ebrc_jenkins::user

  file { '/var/log/jenkins':
    ensure  => directory,
    owner   => $user,
    mode    => '0750',
    recurse => true,
    require => User['jenkins'],
  }

  file { $jenkins_user_home:
    ensure  => directory,
    recurse => false,
    purge   => false,
    owner   => $user,
    mode    => '0755',
    require => User['jenkins'],
  }

  file { $instance_base_dir:
    ensure  => directory,
    recurse => false,
    purge   => false,
    owner   => $user,
    mode    => '0755',
    require => File[$jenkins_user_home],
  }

  file { '/etc/security/limits.d/jenkins-limits.conf':
    source => 'puppet:///modules/ebrc_jenkins/jenkins-limits.conf',
  }

  file { '/usr/local/bin/jenkins_init.sh':
    ensure => file,
    source => 'puppet:///modules/ebrc_jenkins/jenkins_init.sh',
    mode   => '0755',
    owner  => root,
    group  => root,
  }

  file { '/etc/jenkins':
    ensure => 'directory',
    mode   => '0755',
    owner  => root,
    group  => root,
  }

  file { '/usr/lib/systemd/system/jenkins@.service':
    ensure  => present,
    content => template('ebrc_jenkins/jenkins@.service.erb'),
    mode    => '0755',
    owner   => root,
    group   => root,
  }

}
