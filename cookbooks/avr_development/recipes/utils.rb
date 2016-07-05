login_user = node['avr_development']['user']

%w{
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
