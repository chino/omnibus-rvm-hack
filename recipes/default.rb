#
# Cookbook Name:: omnibus-rvm-hack
# Recipe:: default
#
# Copyright 2014, Facet Digital, LLC
#
# This is a workaround for the CHEF-3581 bug:
#
#   https://tickets.opscode.com/browse/CHEF-3581
#

Dir['/opt/chef/bin/*'].each do |path|

  # prefix all files with chef- if not already
  basename = File.basename path
  bettername = basename =~ /^chef-/ ? basename : "chef-#{basename}"

  cookbook_file "/usr/bin/#{bettername}" do
    owner "root"
    group "root"
    source "chef-wrapper"
    manage_symlink_source false
    force_unlink true
    mode "755"
    content "#/usr/bin/env bash\nGEM_HOME= GEM_PATH= exec \"#{path}\" \"$@\""
  end

  # For some reason, the `mode` above is not being honored.
  script "chmod /usr/bin/#{f}" do
    interpreter "bash"
    user "root"
    group "root"
    code "chmod 755 /usr/bin/#{f}"
  end
end

