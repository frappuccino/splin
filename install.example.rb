# install.rb
#
##  - Setting some global variables to simply things
## ADJUST THESE SETTINGS
$servername = "instance1001"
$serverdomain = "linode.com"
$host_ip = "192.168.0.55"  # not valide for EC2 instance; they set automatically
$ec2_host = "no"
$ssl_cert  = "no"
$mysql = "yes"
$qt4 = "no"
$sitename   = ""
$sitedomain = "example.com" 
## END ADJUST THESE SETTINGS

$identity = $sitename.empty? ? "#{$sitedomain}" : "#{$sitename}.#{$sitedomain}"
SERVERNAME = $servername
DOMAINNAME = $domainname

$thisdir = Dir.pwd
$time = Time.new
$myt = $time.strftime("%Y%m%d-%H:%M")
$filesdir = "#{$thisdir}/files"

# BE SURE customverify is the first required file
require "#{$thisdir}/custom/customverify"
# BE SURE customverify is the first required file 

if "#{$ec2_host}" == "yes"
  require "#{$thisdir}/packages/setname"
else
  require "#{$thisdir}/packages/setname_alt"
end

if "#{$mysql}" == "yes"
  require "#{$thisdir}/packages/mysql-server"
end

if "#{$ssl_cert}" == "yes"
  require "#{$thisdir}/packages/ssl"
end
require "#{$thisdir}/packages/essential"
require "#{$thisdir}/packages/rbenv.rb"

deployment do
  # mechanism for deployment
  delivery :capistrano do
    set :user, 'root'
    set :run_method, :run 
    role :app, "#{$servername}.#{$serverdomain}"
    default_run_options[:pty] = true
end
# 
#   # source based package installer defaults
  source do
    prefix   '/usr/local'           # where all source packages will be configured to install
    archives '/usr/local/sources'   # where all source packages will be downloaded to
    builds   '/usr/local/build'     # where all source packages will be built
  end
end
# 
policy :myapp, :roles => :app do
  if "#{$ec2_host}" == "yes" 
    requires :setname
    requires :copy_setname
  else
    requires :set_hostname
    requires :set_etc_hostname
    requires :set_mailname
  end
  requires :curl
  requires :git
  requires :subversion
  requires :nginx_from_ppa
  requires :nodejs_from_ppa
  if "#{$mysql}" == "yes"
    requires :mysqlserver
  end
  requires :imagemagic
  requires :libmysqlclient_dev
  if "#{$qt4}" == "yes"
    requires :libqt4_dev
  end
  requires :postfix_local
  requires :deployer_user
  requires :rbenv
  requires :rbenv_path
  requires :rbenv_bootstrap_12_04
  requires :ntp
  requires :dbstuff
  if "#{$ssl_cert}" == "yes"
    requires :copy_ssl_crt
    requires :copy_ssl_key
  end
end

