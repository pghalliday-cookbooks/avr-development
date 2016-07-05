login_user = node['avr_development']['user']
simulavr_src = '/usr/local/src/simulavr'

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

git simulavr_src do
  repository 'git://git.savannah.nongnu.org/simulavr.git'
  enable_checkout false
  checkout_branch 'master'
  revision 'master'
  action :sync
  notifies :run, 'bash[install_simulavr]', :immediately
end

bash 'install_simulavr' do
  code <<-EOH
  set -e
  cd #{simulavr_src}
  ./bootstrap
  ./configure
  make
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

remote_file "/usr/local/src/mfile.tar.gz" do
  source 'http://www.sax.de/~joerg/mfile/mfile.tar.gz'
  checksum 'e374c5b686db504b01ad6bfed155b431f2f85bbcd3699fb758da82920adb21e7'
  notifies :run, 'bash[install_mfile]', :immediately
end

bash 'install_mfile' do
  code <<-EOH
  set -e
  tar zxf /usr/local/src/mfile.tar.gz -C /usr/local/share
  sed -i 's|^#!/usr/local/bin/tixwish|#!/usr/bin/wish|' /usr/local/share/mfile/mfile.tcl
  ln -fs /usr/local/share/mfile/mfile.tcl /usr/local/bin/mfile
  EOH
  action :nothing
end

# update mfile with up to date device list
remote_file '/usr/local/share/mfile/mfile.tcl' do
  source 'https://raw.githubusercontent.com/zarthcode/MFile/master/mfile.tcl'
  checksum '8c0d1cca7233c606b8ed8b7738e090845adaa73c0028a15d51f0b6fc94a009d0'
end
