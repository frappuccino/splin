package :rvm_update do
  description "Update rvm"
  runner "rvm get latest"
  runner "rvm reload" 
end

package :ruby192p290 do
  description "Ruby 1.9.2"
  requires :rvm
  requires :rvm_update
  requires :libssldev
  noop do
    # Install Ruby 1.9.2 P290
    pre :install, 'rvm install 1.9.2-p290'
    # Set ruby as current/default Ruby version.
    post :install, 'rvm use 1.9.2-p290 --default'
  end

  verify do
    has_version_in_grep "rvm info", "1.9.2p290"
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
