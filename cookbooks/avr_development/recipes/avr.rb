login_user = node['avr_development']['user']
login_group = node['avr_development']['group']
login_home = node['avr_development']['home']

%w{
build-essential
avr-libc
gcc-avr
binutils-avr
gdb-avr
avrdude
minicom
}.each do |name|
  package name
end

# permissions for serial device
group 'dialout' do
  action :modify
  members login_user
  append true
end

# additional packages required to build simulavr
%w{
autoconf
automake
libtool
libtool-bin
texinfo
}.each do |name|
  package name
end

git "#{login_home}/simulavr" do
  repository 'git://git.savannah.nongnu.org/simulavr.git'
  user login_user
  group login_group
  revision 'master'
  action :sync
  notifies :run, 'bash[build_simulavr]', :immediately
end

bash 'build_simulavr' do
  code <<-EOH
  cd #{login_home}/simulavr
  ./bootstrap
  ./configure
  make
  EOH
  user login_user
  action :nothing
  notifies :run, 'bash[install_simulavr]', :immediately
end

bash 'install_simulavr' do
  code <<-EOH
  cd #{login_home}/simulavr
  make install
  ldconfig
  EOH
  action :nothing
end

# mfile dependencies
%w{
tk
}.each do |name|
  package name
end

remote_file "#{login_home}/mfile.tar.gz" do
  source 'http://www.sax.de/~joerg/mfile/mfile.tar.gz'
  owner login_user
  group login_group
  checksum 'e374c5b686db504b01ad6bfed155b431f2f85bbcd3699fb758da82920adb21e7'
  notifies :run, 'bash[install_mfile]', :immediately
end

bash 'install_mfile' do
  code <<-EOH
  set -e
  cd #{login_home}
  tar zxf mfile.tar.gz -C /usr/local/share
  sed -i 's|^#!/usr/local/bin/tixwish|#!/usr/bin/wish|' /usr/local/share/mfile/mfile.tcl
  ln -fs /usr/local/share/mfile/mfile.tcl /usr/local/bin/mfile
  EOH
  action :nothing
end
