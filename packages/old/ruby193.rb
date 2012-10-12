package :rvm_update do
  description "Update rvm"
  runner "rvm get latest"
  runner "rvm reload" 
end

package :ruby193p0 do
  description "Ruby 1.9.3p0"
  requires :rvm
  requires :rvm_update
  requires :libssldev
  noop do
    # Install Ruby 1.9.3 P0
    pre :install, 'rvm install 1.9.3-p0'
    # Set ruby as current/default Ruby version.
    post :install, 'rvm use 1.9.3-p0 --default'
  end

  verify do
    has_version_in_grep "rvm info", "1.9.3p0"
  end  
end

package :ruby193p194 do
  description "Ruby 1.9.3p194"
  requires :rvm
  requires :rvm_update
  requires :libssldev
  noop do
    # Install Ruby 1.9.3 P194
    pre :install, 'rvm install 1.9.3-p194'
    # Set ruby as current/default Ruby version.
    post :install, 'rvm use 1.9.3-p194 --default'
  end

  verify do
    has_version_in_grep "rvm info", "1.9.3p194"
  end  
end

package :bundler do
  description "Bundler - Ruby dependency manager"
  requires :rvm
  runner "rvm gem install bundler"
  verify do
    has_version_in_grep 'rvm gem list', "bundler"
  end
end

