# I could make this module dependent on the herculesteam/augeasproviders_ssh
# and herculesteam/augeasproviders_pam Puppet Forge modules, which would have
# made for some less-heinous augeas-ing, but I'm competent at augeas, so I
# didn't. 
class rsa_securid_auth_agent_for_pam::sshd {
  augeas { 'UsePAM':
    context => '/files/etc/ssh/sshd_config',
    changes => [ 'set UsePAM yes' ],
    notify  => Service['sshd'],
  }
  augeas { 'PasswordAuthentication':
    context => '/files/etc/ssh/sshd_config',
    changes => [ 'set PasswordAuthentication no' ],
    notify  => Service['sshd'],
  }
  augeas { 'UsePrivilegeSeparation':
    context => '/files/etc/ssh/sshd_config',
    changes => [ 'set UsePrivilegeSeparation no' ],
    notify  => Service['sshd'],
  }
  augeas { 'ChallengeResponseAuthentication':
    context => '/files/etc/ssh/sshd_config',
    changes => [ 'set ChallengeResponseAuthentication yes' ],
    notify  => Service['sshd'],
  }
  augeas { 'PubkeyAuthentication':
    context => '/files/etc/ssh/sshd_config',
    changes => [ 'set PubkeyAuthentication no' ],
    notify  => Service['sshd'],
  }
  augeas { 'auth required pam_securid.so':
    context => '/files/etc/pam.d/sshd',
    changes => [
      'ins 01 after *[type="auth"][control="include"][module="postlogin"]',
      'set 01/type auth',
      'set 01/control required',
      'set 01/module pam_securid.so',
    ],
    onlyif  => 'match *[type="auth"][control="required"][module="pam_securid.so"] size == 0',
  }
}
