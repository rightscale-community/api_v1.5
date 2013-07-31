require 'rsrest.rb'
require 'simple_functions.rb'

def enterprise_child_account_rename(old_name, new_name)
  account_params = { :child_account => { :name => "#{new_name}" } }
  account_params
  child_href=@client.child_accounts.index(:filter => "name==#{old_name}").first.href.gsub(/accounts/,'child_accounts').to_s
  puts child_href
  restly = RsRest.new
  restly.put(child_href,account_params)
end


