require File.expand_path("simple_functions.rb",File.dirname(__FILE__))

%w{DBADMIN DBREPLICATION DBAPPLICATION}.each { |cred|
  create_credential("#{cred}_USER", cred.downcase)
  create_credential_random("#{cred}_PASSWORD",13)
}
