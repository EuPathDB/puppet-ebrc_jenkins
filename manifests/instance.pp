# Management of a single named instance of Jenkins
# Gets war file from http://mirrors.jenkins-ci.org/war/${version}/jenkins.war
define ebrc_jenkins::instance (
    $http_port = undef,
    $jmx_port  = undef,
    $user      = $ebrc_jenkins::user,
    $group     = $ebrc_jenkins::group,
    $version   = 'latest',
  ) {

  include ::ebrc_jenkins::core
  include ::archive

  $instance_base_dir = "${::ebrc_jenkins::user_home}/Instances"
  $instance_dir = "${instance_base_dir}/${name}"

  file { $instance_dir:
    ensure  => directory,
    recurse => false,
    purge   => false,
    owner   => $user,
    mode    => '0755',
    require => File[$instance_base_dir],
  }

  file { [
          "${instance_dir}/war",
          "${instance_dir}/war/WEB-INF",
          "${instance_dir}/war/WEB-INF/lib",
          "${instance_dir}/init.groovy.d",
          ]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => File[$instance_dir],
  }

  # commons-jelly-tags-util is required for eupath-email-ext.jelly
  # used by the email-ext plugin
  file { "${instance_dir}/war/WEB-INF/lib/commons-jelly-tags-util-1.1.1.jar":
    ensure  => file,
    source  => 'puppet:///modules/ebrc_jenkins/commons-jelly-tags-util-1.1.1.jar',
    mode    => '0644',
    owner   => $user,
    group   => $group,
    notify  => Service["jenkins@${name}"],
    require => File["${instance_dir}/war/WEB-INF/lib/"],
  }

  file { "${instance_dir}/email-templates":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => Service["jenkins@${name}"],
  }

  file { "${instance_dir}/email-templates/eupath-email-ext.jelly":
    ensure  => file,
    source  => 'puppet:///modules/ebrc_jenkins/eupath-email-ext.jelly',
    mode    => '0644',
    owner   => $user,
    group   => $group,
    require => Service["jenkins@${name}"],
  }

  file { "/etc/jenkins/${name}.conf":
    ensure  => file,
    content => template('ebrc_jenkins/instance-conf.erb'),
    mode    => '0755',
    owner   => root,
    group   => root,
  }

  service { "jenkins@${name}":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => [
        File['/usr/lib/systemd/system/jenkins@.service'],
        File['/var/log/jenkins'],
        Archive["${instance_dir}/jenkins.war"],
    ],
  }

  archive { "${instance_dir}/jenkins.war":
    ensure  => present,
    extract => false,
    source  => "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war",
  }

}
