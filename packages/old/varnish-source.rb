package :varnish_302_from_source do
  requires :pkgconfig
  requires :libpcre
  source 'http://repo.varnish-cache.org/source/varnish-3.0.2.tar.gz'
  verify  { has_executable '/usr/local/sbin/varnishd' }
end

