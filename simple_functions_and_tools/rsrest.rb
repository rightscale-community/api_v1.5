require 'rubygems'
require 'rest_client'
require 'json'
require 'yaml'

class RsRest
def initialize
  parsed_file=YAML.load(File.read(File.join(ENV["HOME"],".apirc")))
  @user=parsed_file["defaults"]["user"]
  @pass=parsed_file["defaults"]["pass"]
  @account=parsed_file["defaults"]["account"]
  @rest_client = RestClient::Resource.new('https://my.rightscale.com', :user => @user, :password => @pass, :timeout => -1)
  @version=version
end

def login
    @login_path="/api/session"
    params = {
      'email' => @user.to_s,
      'password' => @pass.to_s,
      'account_href' => "/api/accounts/#{@account}"
      }
    res=@rest_client[@login_path].post(params, 'X-API-VERSION' => @version )
end

def headers
  @cookies = login
  return headers={'X_API_VERSION' => @version, :cookies => @cookies, :accept => :json, :force => 'true', :timeout => '2000', :open_timeout => '2000'}
end

def put(href,params)
  @rest_client[href].put(params,headers)
end

def get(href,params)
  @rest_client[href].get(params,headers)
end

def post(href,params)
  @rest_client[href].post(params,headers)
end
end
