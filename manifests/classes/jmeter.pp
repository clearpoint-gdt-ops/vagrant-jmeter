class jmeter {
    require apt
    require jre

    $jmeter_base    = "apache-jmeter-2.11"
    $jmeter_dir     = "/home/jmeter"
    $jmeter_url     = "http://www.carfab.com/apachesoftware/jmeter/binaries/${jmeter_base}.tgz"
    $jmeter_md5_url = "http://www.apache.org/dist/jmeter/binaries/${jmeter_base}.tgz.md5"

    user { 'jmeter user':
        name        => 'jmeter',
        ensure      => present,
        home        => $jmeter_dir,
        password    => '$6$1n11if5m$6gIgpAYO57IZWJojUuII3ppla0dvcMI0sXbBmn34ec7C87ihAUak9VxmxBGL1AxSa/fSLRsC1.kN1XmE5mgm.0', #sha1('jmeter'),
    }

    file { $jmeter_dir:
        ensure      => directory,
        owner       => 'jmeter',
        group       => 'jmeter',
        mode        => 755,
        require     => [
            User['jmeter user'],
        ],
    }

    package { 'curl':
    }

    exec { 'download jmeter':
        command	    => "curl -o ${jmeter_dir}/${jmeter_base}.tgz ${jmeter_url}",
        path        => ['/usr/bin', '/bin'],
        creates     => "${jmeter_dir}/${jmeter_base}.tgz",
        user        => 'jmeter',
        require     => [
            Package['curl'],
        ],
    }

    exec { 'download jmeter checksum':
        command	    => "curl -o ${jmeter_dir}/${jmeter_base}.tgz.md5 ${jmeter_md5_url}",
        path        => ['/usr/bin', '/bin'],
        creates     => "${jmeter_dir}/${jmeter_base}.tgz.md5",
        user        => 'jmeter',
        require     => [
            Package['curl'],
        ],
    }

    exec { 'check jmeter download':
        command     => "test \"$(awk '{print \$1}' <'${jmeter_dir}/${jmeter_base}.tgz.md5')\" = \"$(md5sum '${jmeter_dir}/${jmeter_base}.tgz' | awk '{print \$1}')\"",
        require     => [
            Exec['download jmeter'],
            Exec['download jmeter checksum'],
        ],
    }

    package { 'tar':
    }

    exec { 'unpack jmeter':
        command     => "tar -xzf ${jmeter_dir}/${jmeter_base}.tgz -C ${jmeter_dir}",
        path        => ['/usr/bin', '/bin'],
        creates     => "${jmeter_dir}/${jmeter_base}/",
        user        => 'jmeter',
        require     => [
            File[$jmeter_dir],
            User['jmeter user'],
            Exec['check jmeter download'],
            Package['tar'],
        ],
    }

    file { "${jmeter_dir}/GDT_preprod_info_001.jmx":
        owner       => 'jmeter',
        group       => 'jmeter',
        mode        => 664,
        source      => "file:///vagrant/manifests/files/jmeter/GDT_preprod_info_001.jmx",
        require     => [
            File[$jmeter_dir],
        ],
    }

}
