package :ssl_dir do
  runner 'mkdir -p /etc/nginx/ssl'
  verify { has_directory '/etc/nginx/ssl' } 
end

package :copy_ssl_key do
  requires :ssl_dir
  transfer "#{$filesdir}/pvt/#{$sitedomain}.key", "/etc/nginx/ssl/#{$sitedomain}.key" do
    pre :install, "if [ -f /etc/nginx/ssl/#{$sitedomain}.key ]; then cp /etc/nginx/ssl/#{$sitedomain}.key /tmp/#{$sitedomain}.key.#{$myt}; fi"
  end
  verify { match_local_remote "#{$filesdir}/pvt/#{$sitedomain}.key", "/etc/nginx/ssl/#{$sitedomain}.key" } # custom verify extension
end

package :copy_ssl_crt do
  requires :ssl_dir
  requires :copy_ssl_key
  transfer "#{$filesdir}/pvt/#{$sitedomain}.crt", "/etc/nginx/ssl/#{$sitedomain}.crt" do
    pre :install, "if [ -f /etc/nginx/ssl/#{$sitedomain}.crt ]; then cp /etc/nginx/ssl/#{$sitedomain}.crt /tmp/#{$sitedomain}.crt.#{$myt}; fi"
  end
  verify { match_local_remote "#{$filesdir}/pvt/#{$sitedomain}.crt", "/etc/nginx/ssl/#{$sitedomain}.crt" } # custom verify extension
end

# OLD STUFF used before custom verify
   
# package :copy_ssl_crt do
#   requires :ssl_dir
#   transfer "#{$filesdir}/pvt/#{$sitedomain}.crt", "/etc/nginx/ssl/#{$sitedomain}.crt" do
#     pre :install, "if [ -f /etc/nginx/ssl/#{$sitedomain}.crt ]; then cp /etc/nginx/ssl/#{$sitedomain}.crt /tmp/#{$sitedomain}.crt.#{$myt}; fi"
#   end
#   verify { file_contains "/etc/nginx/ssl/#{$sitedomain}.crt", "#{$snip_ssl_crt}" }
# end
#   
# package :copy_ssl_key do
#   requires :ssl_dir
#   transfer "#{$filesdir}/pvt/#{$sitedomain}.key", "/etc/nginx/ssl/#{$sitedomain}.key" do
#     pre :install, "if [ -f /etc/nginx/ssl/#{$sitedomain}.key ]; then cp /etc/nginx/ssl/#{$sitedomain}.key /tmp/#{$sitedomain}.key.#{$myt}; fi"
#   end
#   verify { file_contains "/etc/nginx/ssl/#{$sitedomain}.key", "#{$snip_ssl_key}" }
# end

