# IMPORTANT: This only works with LTS version of Ubuntu
#            So build from source or use the default repository version if you're on an intermediate release
package :varnish_key do
  requires :curl
  runner 'curl http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -'
  verify { has_version_in_grep 'apt-key fingerprint', "#{$varish_gpg_fprint}" }
end

package :varnish_trust_pkg do
  requires :varnish_key
  runner 'echo "deb http://repo.varnish-cache.org/ubuntu/ $(lsb_release -s -c) varnish-3.0" >> /etc/apt/sources.list' do
    post :install, 'apt-get update'
  end
  verify { file_contains '/etc/apt/sources.list', 'varnish-3.0' }
end

package :varnish_lts_install do
  requires :varnish_trust_pkg
  apt 'varnish' do
    pre :install, 'apt-get update'
  end
  verify do
    has_apt 'varnish'
  end
end

#    curl http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -
#    echo "deb http://repo.varnish-cache.org/ubuntu/ $(lsb_release -s -c) varnish-3.0" >> /etc/apt/sources.list
#    apt-get update
#    apt-get install varnish


# notes: alternate runner line
#   # runner 'if ! apt-key fingerprint | grep #{$varish_gpg_fprint}; then curl http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -; fi'
