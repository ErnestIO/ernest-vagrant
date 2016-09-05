# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

deps = 'make deps'
if %w(dev test).include? node['ernest']['environment']
  deps = 'make dev-deps || true && make deps'
end

ruby_based = ['router-creator-vcloud-connector', 'router-deleter-vcloud-connector', 'execution-run-salt-connector']

directory '/opt/ernest' do
  owner node['server']['user']
  group node['server']['group']
  mode '0755'
  action :create
end

node['ernest']['services']['vcloud'].each do |name, attrs|
  git "/opt/ernest/#{name}" do
    user node['server']['user']
    group node['server']['group']
    repository "git@github.com:#{attrs[:org]}/#{name}.git"
    revision attrs[:version]
    action :sync
  end

  if ruby_based.include? name
    execute 'sudo bundle install' do
      cwd "/opt/ernest/#{name}"
    end
  else
    execute 'sudo JRUBY_OPTS="--1.9 -Xcext.enabled=true" /usr/local/jruby-1.7.13/bin/jruby -S bundle install' do
      cwd "/opt/ernest/#{name}"
    end
  end

  execute "Build service #{name}" do
    command "su #{node['server']['user']} -l -c 'git config --global url.\"git@github.com:\".insteadOf \"https://github.com/\" && cd /opt/ernest/#{name} && #{deps}'"
    action :run
  end
end
