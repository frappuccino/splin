package :varnish_package do
  apt 'varnish'
  verify do
    has_apt 'varnish'
  end
end
