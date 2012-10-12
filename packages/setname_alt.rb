package :set_hostname do
  runner "hostname #{$servername}.#{$serverdomain}"
  runner 'mv /etc/hostname /etc/hostname.old'
  push_text "#{$servername}.#{$serverdomain}", '/etc/hostname'
  verify { file_contains '/etc/hostname', "#{$servername}.#{$serverdomain}" }
end

package :set_etc_hostname do
  push_text "#{$host_ip} #{$servername}.#{$serverdomain}", '/etc/hosts'
  verify { file_contains '/etc/hosts', "#{$servername}.#{$serverdomain}" }
end

package :set_mailname do
  requires :postfix
  push_text "#{$servername}.#{$serverdomain}", '/etc/mailname' do
    post :install, 'chmod 644 /etc/mailname'
    post :install, 'service postfix reload'
  end
  verify { file_contains '/etc/mailname', "#{$servername}.#{$serverdomain}" }
end
