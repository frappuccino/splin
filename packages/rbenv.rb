package :deployer_user do
  # sprinkle user class doesn't seem to work, so..
  def get_deployer_password(prompt="Enter password for system-user, deployer")
     ask(prompt) {|q| q.echo = false}
  end

  deployerPassword = get_deployer_password()

  runner 'useradd -m -s /bin/bash -g admin deployer'
  runner "echo deployer:#{deployerPassword} | chpasswd"

  verify do
     has_user 'deployer'
  end
end
  
package :rbenv do
  requires :git
  requires :curl
  requires :deployer_user
  runner 'curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer -o /tmp/rbenv-installer'
  runner 'chmod ugo+x /tmp/rbenv-installer'
  runner 'sudo -u deployer -i /tmp/rbenv-installer'
  verify do
    has_file '/home/deployer/.rbenv/libexec/rbenv'
  end
end

package :rbenv_path do
  requires :rbenv
  transfer "#{$filesdir}/rbenv.sed", "/tmp/rbenv.sed"
  runner 'sudo -u deployer -i sed -f /tmp/rbenv.sed < /home/deployer/.bashrc > /tmp/.bashrc.new' do
     post :install, 'sudo -u deployer -i cp /tmp/.bashrc.new /home/deployer/.bashrc'
  end
  verify { file_contains '/home/deployer/.bashrc', 'rbenv init' }
end

package :rbenv_bootstrap_12_04 do
  requires :server_init
  apt 'build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev'
  verify do
    has_apt 'build-essential'
    has_apt 'zlib1g-dev'
    has_apt 'libssl-dev'
    has_apt 'libreadline-gplv2-dev'
  end
end

