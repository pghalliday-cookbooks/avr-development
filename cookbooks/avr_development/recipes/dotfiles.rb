login_user = node['avr_development']['user']
login_group = node['avr_development']['group']
login_home = node['avr_development']['home']
id_rsa = node['avr_development']['ssh']['id_rsa']
authorized_keys = node['avr_development']['ssh']['authorized_keys']

ssh_dir = ::File.join login_home, '.ssh'
id_rsa_file = ::File.join ssh_dir, 'id_rsa'
authorized_keys_file = ::File.join ssh_dir, 'authorized_keys'
dotfiles_dir = ::File.join login_home, 'pghalliday-dotfiles'
dotfiles_scripts_dir = ::File.join dotfiles_dir, 'scripts'

directory ssh_dir do
  owner login_user
  group login_user
  mode 0700
end

file id_rsa_file do
  content ::File.read id_rsa
  owner login_user
  group login_group
  mode 0600
end

file authorized_keys_file do
  content ::File.read authorized_keys
  owner login_user
  group login_group
  mode 0600
end

directory dotfiles_dir do
  owner login_user
  group login_group
end

# get latest git
apt_repository 'git' do
  uri 'ppa:git-core/ppa'
  distribution node['lsb']['codename']
end

%w{
openssh-server
git
vim
tmux
}.each do |name|
  package name do
    action :upgrade
  end
end

bash 'dotfiles' do
  code <<-EOH
  export HOME=#{login_home}
  ssh-keyscan -t rsa github.com >> #{ssh_dir}/known_hosts
  git clone git@github.com:pghalliday-dotfiles/scripts.git #{dotfiles_scripts_dir}
  cd #{dotfiles_scripts_dir}
  ./terminal-setup.sh
  EOH
  user login_user
  not_if do ::File.exists?(dotfiles_scripts_dir) end
end
