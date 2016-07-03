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
autoconf
automake
libtool
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

git "#{login_home}/simulavr" do
  repository 'git://git.savannah.nongnu.org/simulavr.git'
  user login_user
  group login_group
  revision 'master'
  action :sync
end
