SERVERNAME = $servername
SERVERDOMAIN = $serverdomain
MYTIME     = $myt

package :setname do
  transfer "#{$filesdir}/rc.local.template", "/tmp/rc.local.template", :render => true 
end

package :copy_setname do
  requires :setname
  bkrclocal = "/tmp/rc.local." + $myt
  runner 'if [ "X(md5sum /tmp/rc.local.template |cut -d\" \" -f 1)" != "X(md5sum /etc/rc.local |cut -d\" \" -f 1)" ]; then cp /tmp/rc.local.template /etc/rc.local; fi' do     
    pre :install, "if [ -f /etc/rc.local ]; then cp /etc/rc.local #{bkrclocal}; fi"
  end
end

