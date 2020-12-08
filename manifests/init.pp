# Class: rsa_securid_auth_agent_for_pam
class rsa_securid_auth_agent_for_pam {
  file { '/var/ace':
    ensure => directory,
    mode   => '0700',
  }
  file { '/var/ace/sdopts.rec':
    content => "CLIENT_IP=${::facts[networking][ip]}\n",
    mode    => '0600',
  }
  exec { 'extract PAM-Agent_v7.1.0.1.16.05_06_13_02_04_01.tar':
    command => '/usr/bin/tar -x -C /opt -f /opt/PAM-Agent_v7.1.0.1.16.05_06_13_02_04_01.tar',
    creates => '/opt/PAM-Agent_v7.1.0.1.16.05_06_13_02_04_01',
    require => File['/opt/PAM-Agent_v7.1.0.1.16.05_06_13_02_04_01.tar'],
  }
  ensure_packages(['expect'], { ensure => installed })
  file { '/opt/PAM-Agent_v7.1.0.1.16.05_06_13_02_04_01.expect':
    mode   => '0755',
    source => "puppet:///modules/${module_name}/PAM-Agent_v7.1.0.1.16.05_06_13_02_04_01.expect",
  }
  if $::facts[os][architecture] == 'x86_64' {
    $bits = '64'
  }
  else {
    $bits = ''
  }
  exec { '/opt/PAM-Agent_v7.1.0.1.16.05_06_13_02_04_01.expect':
    creates => "/usr/lib${bits}/security/pam_securid.so",
    require => [
      Package['expect'],
      Exec['extract PAM-Agent_v7.1.0.1.16.05_06_13_02_04_01.tar'],
    ],
  }
  file { '/etc/sd_pam.conf':
    source => "puppet:///modules/${module_name}/sd_pam.conf",
  }
}
