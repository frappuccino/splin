vbk = '/tmp/varnish.backup'

package :varnish_bkup do
  runner  "mkdir #{vbk}"
  verify { has_directory "#{vbk}" }
end

package :varnish_logrotate do
  requires :varnish_bkup
  src_log = "#{$filesdir}/varnish_from_source/etc_logrotate.d/varnish"
  dst_log = "/etc/logrotate.d/varnish"
  bck_log = "#{vbk}/varnish.logrotate.#{$myt}"
  transfer "#{src_log}", "#{dst_log}" do
    pre :install, "if [ -f #{dst_log} ]; then cp #{dst_log} #{bck_log}; fi"
    post :install, "chmod 644 #{src_log}"
  end
  verify { match_local_remote "#{src_log}", "#{dst_log}" } 
end

package :varnish_vcl do
  requires :varnish_bkup
  src_vcl = "#{$filesdir}/varnish_from_source/etc/varnish/default.vcl"
  dst_vcl = "/etc/varnish/default.vcl"
  bck_vcl = "#{vbk}/default.vcl.#{$myt}"
  transfer "#{src_vcl}", "#{dst_vcl}" do
    pre :install, 'if [ -d /etc/varnish ]; then mkdir -p /etc/varnish; fi'
    pre :install, "if [ -f #{dst_vcl} ]; then cp #{dst_vcl} #{bck_vcl} "
    post :install, "chmod 644 #{dst_vcl}"
  end
  verify do
    has_directory '/etc/varnish'
    match_local_remote "#{src_vcl}", "#{dst_vcl}"
  end
end

## TODO: DEAL WITH /etc/varnish/secret

package :varnish_default_config do
  requires :varnish_bkup
  src_dft_cfg = "#{$filesdir}/varnish_from_source/etc_default/varnish"
  dst_dft_cfg = "/etc/default/varnish"
  bck_dft_cfg = "#{vbk}/varnish.#{$myt}"
  transfer "#{src_dft_cfg}", "#{dst_dft_cfg}" do
    pre :install, "if [ -f #{dst_dft_cfg} ]; then cp #{dst_dft_cfg} #{bck_dft_cfg} "
    post :install, "chmod 644 #{dst_dft_cfg}"
  end
  verify { match_local_remote "#{src_dft_cfg}", "#{dst_dft_cfg}" } 
end

package :varnish_default_log do
  requires :varnish_bkup
  src_dft_log = "#{$filesdir}/varnish_from_source/etc_default/varnishlog"
  dst_dft_log = "/etc/default/varnishlog"
  bck_dft_log = "#{vbk}/varnishlog.#{$myt}"
  transfer "#{src_dft_log}", "#{dst_dft_log}" do
    pre :install, "if [ -f #{dst_dft_log} ]; then cp #{dst_dft_log} #{bck_dft_log} "
    post :install, "chmod 644 #{dst_dft_log}"
  end
  verify { match_local_remote "#{src_dft_log}", "#{dst_dft_log}" } 
end

package :varnish_default_ncsa do
  requires :varnish_bkup
  src_dft_ncsa = "#{$filesdir}/varnish_from_source/etc_default/varnishncsa"
  dst_dft_ncsa = "/etc/default/varnishncsa"
  bck_dft_ncsa = "#{vbk}/varnishncsa.#{$myt}"
  transfer "#{src_dft_ncsa}", "#{dst_dft_ncsa}" do
    pre :install, "if [ -f #{dst_dft_ncsa} ]; then cp #{dst_dft_ncsa} #{bck_dft_ncsa} "
    post :install, "chmod 644 #{dst_dft_ncsa}"
  end
  verify { match_local_remote "#{src_dft_ncsa}", "#{dst_dft_ncsa}" } 
end
