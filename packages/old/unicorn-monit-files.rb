THEENV     = $theenv      # see pvt/config.rb
SITEDOMAIN = $sitedomain  # see pvt/config.rb
IDENTITY   = $identity    # see pvt/config.rb
MONITALERT = $monitalert  # see pvt/config.rb
ASSETSNAME = $assetsname  # see pvt/config.rb
ASSETSLOCATION = $assetslocation # see pvt/config.rb

# BUILD /etc/init.d/unicorn.<sitedomain> from template, create the associated rc.d link, backup existing file prior to copy
tmpucorn = "/tmp/unicorn.#{$sitedomain}.template"
ucorn    = "/etc/init.d/unicorn.#{$sitedomain}"
bkucorn  = "/tmp/unicorn.#{$sitedomain}" + $myt

package :unicorn_startup do
  transfer "#{$filesdir}/unicorn.template", "#{tmpucorn}", :render => true 
end

package :copy_unicorn_startup do
  runner "cp #{tmpucorn} #{ucorn}" do
    pre :install, "if [ -f #{ucorn} ]; then cp #{ucorn} #{bkucorn}; fi" 
  end
  verify { match_remote_remote "#{tmpucorn}", "#{ucorn}" }  # Custom verify extension
end

# package :copy_unicorn_startup do
#   requires :unicorn_startup
#   runner "if [ \"X\(md5sum #{tmpucorn} | awk \'{print $1}\' \)\" != \"X\(md5sum #{ucorn} | awk \'{print $1}\' \)\" ]; then cp #{tmpucorn} #{ucorn}; fi" do
#     pre :install, "if [ -f #{ucorn} ]; then cp #{ucorn} #{bkucorn}; fi"
#     post :install, "chmod 755 #{ucorn}"
#   end
# end

package :activate_unicorn_startup do
  requires :copy_unicorn_startup
  runner "if [ ! -h /etc/rc3.d/S20unicorn.#{$sitedomain} ]; then update-rc.d unicorn.#{$sitedomain} defaults; fi"
  # verify - Sprinkle doesn't have a verify for sym links
end

# BUILD /etc/monit/conf.d/monit.global from template, backup existing file prior to copy
tmpmongbl = "/tmp/monit.global.template"
mongbl    = "/etc/monit/conf.d/monit.global"
bkmongbl  = "/tmp/monit.global." + $myt

package :monit_global do
  requires :monit
  transfer "#{$filesdir}/monit.global.template", "#{tmpmongbl}", :render => true
end

package :copy_monit_global do
  requires :monit
  requires :monit_global
  runner "cp #{tmpmongbl} #{mongbl}" do
    pre :install, "if [ -f #{mongbl} ]; then cp #{mongbl} #{bkmongbl}; fi" 
  end
  verify do
    has_file "#{tmpmongbl}"
    match_remote_remote "#{tmpmongbl}", "#{mongbl}" # Custom verify extension
  end
end

#  package :copy_monit_global do
#    requires :monit
#    requires :monit_global
#    runner "if [ \"X\(md5sum #{tmpmongbl} | awk \'{print $1}\' \)\" != \"X\(md5sum #{mongbl} | awk \'{print $1}\' \)\" ]; then cp #{tmpmongbl} #{mongbl}; fi" do
#      pre :install, "if [ -f #{mongbl} ]; then cp #{mongbl} #{bkmongbl}; fi" 
#    end
#  end

# BUILD /etc/monit/conf.d/<sitedomain> from template, backup existing file prior to copy
tmpmonsite = "/tmp/monit.site.template"
monsite    = "/etc/monit/conf.d/#{$sitedomain}"
bkmonsite  = "/tmp/monit.site.#{$sitedomain}" + $myt

package :monit_site do
  requires :monit
  transfer "#{$filesdir}/monit.site.template", "#{tmpmonsite}", :render => true
end

package :copy_monit_site do
  requires :monit
  requires :monit_site
  runner "cp #{tmpmonsite} #{monsite}" do
    pre :install, "if [ -f #{monsite} ]; then cp #{monsite} #{bkmonsite}; fi" 
  end
  verify do
    has_file "#{tmpmonsite}"
    match_remote_remote "#{tmpmonsite}", "#{monsite}"
  end 
end
  

# package :copy_monit_site do
#   requires :monit
#   requires :monit_site
#   runner "if [ \"X\(md5sum #{tmpmonsite} | awk \'{print $1}\' \)\" != \"X\(md5sum #{monsite} | awk \'{print $1}\' \)\" ]; then cp #{tmpmonsite} #{monsite}; fi" do
#     pre :install, "if [ -f #{monsite} ]; then cp #{monsite} #{bkmonsite}; fi" 
#   end
# end
