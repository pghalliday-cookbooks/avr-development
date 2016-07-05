%w{
subversion
tk
}.each do |name|
  package name
end

directory '/usr/local/share/mfile'

subversion '/usr/local/share/mfile' do
  repository 'https://spaces.atmel.com/svn/mfile/trunk'
  revision 'HEAD'
  svn_username 'anonymous'
  svn_password ''
  action :sync
  notifies :run, 'bash[install_mfile]', :immediately
end

bash 'install_mfile' do
  code <<-EOH
  set -e
  ln -fs /usr/local/share/mfile/src/mfile.tcl /usr/local/bin/mfile
  EOH
  action :nothing
end
