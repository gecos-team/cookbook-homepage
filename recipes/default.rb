#
# Cookbook Name:: homepage
# Recipe:: default
#

default_prefs = "/usr/share/firefox-firma/defaults/profiles/prefs.js"

if (FileTest.exist?( default_prefs ))
    FileUtils.cp_r default_prefs, default_prefs+".orig"
    file_write = File.open(default_prefs, "w")
    File.open(default_prefs+".orig", "r") do |file_read|
        while line = file_read.gets
            if (/user_pref\(\s*\'browser.startup.homepage\'\s*\,/.match(p))
                file_write.puts "user_pref(\"browser.startup.homepage\", \""+node.homepage+"\");"
            else
                file_write.puts line
            end
        end
    end
            
else
    template default_prefs do
        owner "root"
        group "root"
        mode "0644"
        variables :homepage => node.homepage
        source "firefox-prefs.js.erb"
    end
end

for user in node.home_users do

    username = user[1]['username']
    home_user_prefs = "/home/"+username+"/.mozilla/firefox/firefox-firma/prefs.js"

    if (FileTest.exist?(home_user_prefs ))
        FileUtils.cp_r home_user_prefs, home_user_prefs+".orig"
        file_write = File.open(home_user_prefs, "w")
        File.open(home_user_prefs+".orig", "r") do |file_read|
            while line = file_read.gets
                if (/user_pref\(\s*\'browser.startup.homepage\'\s*\,/.match(p))
                    file_write.puts "user_pref(\"browser.startup.homepage\", \""+node.homepage+"\");"
                else
                    file_write.puts line
                end
            end
        end
    end
end
