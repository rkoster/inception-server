cookbook_file "/var/vcap/store/microboshes/Gemfile" do
  source "Gemfile.micro"
  owner node.user.username
  group node.user.username
  mode "0644"
end

directory "/var/vcap/store/microboshes" do
  owner node.user.username
  group node.user.username
  mode "0755"
  recursive true
  action :create
end

rvm_shell "install bosh micro" do
  code "bundle install"
  cwd "/var/vcap/store/microboshes"
  # user node.user.username
  # environment ({'HOME' => "/home/#{node.user.username}"})
  action :run
end

cookbook_file "/var/vcap/store/systems/Gemfile" do
  source "Gemfile.cf"
  owner node.user.username
  group node.user.username
  mode "0644"
end

rvm_shell "install bosh cf" do
  code "bundle install"
  cwd "/var/vcap/store/systems"
  # user node.user.username
  # environment ({'HOME' => "/home/#{node.user.username}"})
  action :run
end
