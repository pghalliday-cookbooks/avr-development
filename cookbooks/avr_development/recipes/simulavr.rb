simulavr_src = '/usr/local/src/simulavr'

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
