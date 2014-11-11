class jre {
    require apt

    package { 'jre':
        name   => "openjdk-7-jre",
        ensure => installed,
    }

}
