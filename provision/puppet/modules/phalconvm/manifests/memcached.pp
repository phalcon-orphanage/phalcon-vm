class phalconvm::memcached(
	$enabled = false,
	$max_memory = 64,
	$tcp_port = 11211
) {
	if $enabled == true {
		class { 'memcached':
			package_ensure => 'present',
			listen_ip      => '127.0.0.1',
			tcp_port       => $tcp_port,
			max_memory     => $max_memory,
			user           => 'memcache',
		}
	} else {
		file { '/srv/log/memcached.log':
			ensure => 'absent',
		}

		service { 'memcached':
			ensure => 'stopped',
		}

		package { 'memcached':
			ensure  => 'purged',
			require => Service['memcached'],
		}

		exec { 'memcached-removed':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['memcached'],
		}
	}
}
