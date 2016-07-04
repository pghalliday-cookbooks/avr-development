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
  EOH
  action :nothing
end
