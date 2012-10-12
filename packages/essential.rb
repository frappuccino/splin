package :server_init do
  # call this package first
  requires :add_ppa_nodejs
  requires :add_ppa_nginx 
  runner ['aptitude -q update', 'aptitude -q -y safe-upgrade'] do
    post :install, 'echo "updated" > /tmp/update.txt'
  end
  verify { file_contains '/tmp/update.txt', 'updated' }
end

package :add_ppa_nodejs do
  runner 'add-apt-repository -y ppa:chris-lea/node.js' do
    post :install, 'apt-get update'
  end
  verify do
     has_file '/etc/apt/sources.list.d/chris-lea-node_js-precise.list'
  end
end

package :add_ppa_nginx do
  runner 'add-apt-repository -y ppa:nginx/stable' do
     post :install, 'apt-get update'
  end
  verify do
     has_file '/etc/apt/sources.list.d/nginx-stable-precise.list'
  end
end

package :libssldev do
  requires :server_init
  apt 'libssl-dev'
  verify do
      has_apt 'libssl-dev'
   end
end

package :subversion do
  requires :server_init
  apt 'subversion'
    verify do
      has_apt 'subversion'
    end
end

package :git do
   requires :server_init
   apt 'git-core'
     verify do
       has_apt 'git-core'
     end
end

package :curl do
   requires :server_init
   apt 'curl'
     verify do
       has_apt 'curl'
     end
end

package :dbstuff do
  requires :server_init
  apt 'libmysqlclient-dev libxml2 libxml2-dev libxslt1-dev'
  verify do
    has_apt 'libmysqlclient-dev'
    has_apt 'libxml2'
    has_apt 'libxml2-dev'
    has_apt 'libxslt1-dev'
  end
end

package :webutilities do
  requires :server_init
  # need this for htpasswd
  apt 'apache2-utils'
  verify do 
    has_apt 'apache2-utils'
  end
end

package :postfix do
  requires :server_init
  apt 'postfix'
  verify do 
    has_apt 'postfix'
  end
end

package :postfix_local do
  requires :postfix
  replace_text 'inet_interfaces = all', 'inet_interfaces = 127.0.0.1', '/etc/postfix/main.cf'
  verify { file_contains '/etc/postfix/main.cf', 'inet_interfaces = 127.0.0.1' }
end

package :imagemagic do
  requires :server_init
  apt 'imagemagick' 
  verify do
    has_apt 'imagemagick'
  end
end

package :libmysqlclient_dev do
  requires :server_init
  apt 'libmysqlclient-dev' 
  verify do
    has_apt 'libmysqlclient-dev'
  end
end

package :libqt4_dev do
  requires :server_init
  apt 'libqt4-dev' 
  verify do
    has_apt 'libqt4-dev'
  end
end

package :nginx_from_ppa do
  requires :server_init
  requires :add_ppa_nginx
  apt 'nginx-full'	
  verify do
    has_apt 'nginx-full'
  end
end

package :nodejs_from_ppa do
  requires :server_init
  requires :add_ppa_nodejs
  apt 'nodejs'	
  verify do
    has_apt 'nodejs'
  end
end

package :monit do
  requires :server_init
  requires :postfix_local
  apt 'monit'
  verify do
    has_apt 'monit'
  end
end

package :curl do
  requires :server_init
  apt 'curl'
  verify do 
    has_apt 'curl'
  end
end

package :pkgconfig do
  requires :server_init
  apt 'pkg-config'
  verify do
    has_apt 'pkg-config'
  end
end

package :libpcre do
  requires :server_init
  apt 'libpcre3-dev'
  verify do 
    has_apt 'libpcre3-dev'
  end
end

package :ntp do
  requires :server_init
  apt 'ntp' do
    pre :install, 'ntpdate pool.ntp.org'  # it's a good idea to set the clock before starting ntp
  end
  verify do
    has_apt 'ntp'
  end
end

package :fizbeaux_packages do
  requires :server_init
  apt 'imagemagic libmysqlclient-dev libqt4-dev'
  verify do
    has_apt 'imagemagick'
  end
end

