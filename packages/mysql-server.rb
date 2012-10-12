package :mysqlserver do
  # this will force install mysql server without a password
  # Be sure to login after and set a password 
  # This command will do the trick "mysqladmin -u root password NEWPASSWORD"
  #  require 'rubygems'
  #  require 'highline/import'

  def get_password(prompt="Enter Database Password")
     ask(prompt) {|q| q.echo = false}
   end
  thePassword = get_password()

  apt 'mysql-server' do
    requires :server_init
    post :install, "mysqladmin -u root password #{thePassword}"
  end

  verify do
      has_apt 'mysql-server'
  end
end

