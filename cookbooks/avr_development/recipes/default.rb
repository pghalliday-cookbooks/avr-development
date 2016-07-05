node.default['dotfiles']['user'] = node['avr_development']['user']
node.default['dotfiles']['group'] = node['avr_development']['group']
node.default['dotfiles']['home'] = node['avr_development']['home']

include_recipe 'dotfiles::default'
include_recipe 'avr_development::avr'
