package :rvm do
  apt 'ruby-rvm'
  verify do
    has_apt 'ruby-rvm'
  end
end

package :linkrvm do
  # need to add a symbolic link to old-style rvm-shell calls
  requires :rvm
  runner 'ln -s /usr/share/ruby-rvm /usr/local/rvm'
  verify do
    has_symlink '/usr/local/rvm'
  end
end
