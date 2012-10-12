PURPOSE: 
    Use Sprinkle to provision a running Linode with rbenv, ruby 1.9.3, and nginx.

TO USE: 
   (local)  Install Ruby / Sprinkle / Erubis / i18n 
   (remote) Use Linode console to spin-up an alestic-based 12.04 instance 
   (remote) Assign new instance an IP address and update DNS
   (remote) Login to new instance:    # ssh  
   (remote) Set timezone              # dpkg-reconfigure tzdata
   (remote) # apt-get update	      # Good idea prior to sprinkle
   (remote) # apt-get upgrade         # Good idea prior to sprinkle
   (remote) # ls /var/run | grep reboot # see if a "reboot-required" file exists
   (remote) # reboot                    # reboot if a "reboot-required" file is found
   (local) Copy install.rb.example to install.rb.server and adjust as necessary
   (local) # sprinkle -t -v -c -s install.rb.<servername>
   (local) # sprinkle    -v -c -s install.rb.<servername>
   
After server is provisioned, manually follow up with: 
   (remote)        # htpasswd -c  /etc/nginx/htpasswd.<servername>
   (local=>remote) Copy certificate files to /etc/nginx/ssl/servername.domainname.{key|crt} 
   (remote)        # reboot 

NOTE: 
 This sprinkle script is usually followed by  a cap deploy of a rails application 
    that includes necessary unicorn file to tie-in with these nginx configuration files. 
