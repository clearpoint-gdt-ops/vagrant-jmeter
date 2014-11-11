Exec {
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

import 'classes/*.pp'

node default {

    include apt
    include jmeter

    package { xterm:
        require     => Class['apt'],
    }

    package { vim:
        require     => Class['apt'],
    }

}
