class apt {

    exec { 'update the apt cache':
        command     => 'apt-get update',
        user        => 'root',
    }

}
