package :newrelic_apt do
  push_text 'deb http://apt.newrelic.com/debian/ newrelic non-free', '/etc/apt/sources.list.d/newrelic.list'
  verify do
    verify { file_contains '/etc/apt/sources.list/newrelic.list', 'apt.newrelic.com' }
  end
end
