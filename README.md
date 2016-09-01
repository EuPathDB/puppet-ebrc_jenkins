# EBRC Jenkins

Installs one or more instances of a Jenkins master. This is very
specific to EBRC, including installing custom templates and scripts.

The installation sets up the jenkins account, downloads an initial war
file and launches it with an init script. Ongoing  management of the war
updates and configuration is a manual operation using the Jenkins web UI.

Jenkins manages/updates its configurations so it's not practical to manage
them with Puppet. Therefore Jenkins configuration is done manually.

Jenkins runs as a standalone java app via the builtin Winstone server. Tomcat
is not used.

A private ssh key for any slaves needs to be installed manually into the
~joeuser/.ssh account on the slave nodes. The key name must match the name set
in the  Jenkins configuration for the nodes.


## Usage

Define a hash of `ebrc_jenkins::instances` in hiera.

    ebrc_jenkins::user_home: /usr/local/home/jenkins
    ebrc_jenkins::instances:
      CI:
        version: 1.638
        http_port: 9181
        jmx_port:  9120
      DD:
        version: 1.638
        http_port: 9191
        jmx_port:  9130

This will create instances named 'CI' and 'DD'.

## Parameters

#### `ebrc_jenkins::instances`

Hash of parameters for a specific instance. For example, in hiera

    ebrc_jenkins::instances:
      CI:
        version: 1.638
        http_port: 9181
        jmx_port:  9120

#### `ebrc_jenkins::manage_user`
boolean; if true, will create user

#### `ebrc_jenkins::user`

text name for user that owns processes and files

#### `ebrc_jenkins::group`

text name for group that owns processes and files

#### `ebrc_jenkins::uid`

numeric value for UID

#### `ebrc_jenkins::gid`

numeric value for GID.

#### `ebrc_jenkins::user_home`

The full path to the home of the  `ebrc_jenkins::user`. Instance files
and data will be installed to a `Instances/<name>/` subdirectory of
`user_home`.

## Instance control

Instance services are managed with systemd.

List status of all instances

    sudo systemctl list-units 'jenkins@*.service'

Start a specific instance

    sudo systemctl start jenkins@DD


## Files provisioned

- `/usr/lib/systemd/system/jenkins@.service`
- `/usr/local/bin/jenkins_init.sh`
- `/etc/jenkins/<INSTANCENAME>.conf`
- `/usr/local/home/jenkins/` Just core software. Not including plugins or job configurations.

