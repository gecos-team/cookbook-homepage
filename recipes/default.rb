#
# Cookbook Name:: homepage
# Recipe:: default
#

default_prefs = "/usr/share/firefox-firma/defaults/profile/prefs.js"

def change_homepage_to(file)
  text = File.open(file).read
  text.gsub!(/user_pref\(\s*\"browser.startup.homepage\".*/,
             "user_pref(\"browser.startup.homepage\", \"#{node.homepage}\");")
  File.open(file, "w") { |file| file.write text }
end

if File.exist? default_prefs
  change_homepage_to default_prefs
else
  template default_prefs do
    owner "root"
    group "root"
    mode "0644"
    variables :homepage => node.homepage
    source "firefox-prefs.js.erb"
  end
end

node.home_users.each do |user|
  username = user[1]['username']
  home_user_prefs = "/home/#{username}/.mozilla/firefox/firefox-firma/prefs.js"

  if File.exist? home_user_prefs
    change_homepage_to home_user_prefs
  end
end
