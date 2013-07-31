#!/usr/bin/ruby
require 'simple_functions.rb'

old_deployment_name="RS_RAX_1"
new_deployment_name="RS_RAX_2"
old_deployment=get_deployment(old_deployment_name)
@new_deployment=get_deployment(new_deployment_name)
if @new_deployment.nil? 
  pp "Deployment not found, creating #{new_deployment_name}"
  @new_deployment=create_deployment(new_deployment_name)
end

new_cloud=get_cloud('Rackspace Open Cloud - Dallas')

@inputs=Array.new
old_deployment.inputs.index.each do |input|
  add_inputs(input.name, input.value)
end

@server_hash=Hash.new
old_deployment.servers.index.each do |s|
  @server_template_href=""
  s.show.next_instance.show.links.each do |link|
    if link["rel"] == "server_template"
      @server_template_href=link["href"]
    end
  end
  if s.description.nil?
    description="Blank Server Description"
  else
    description=s.description
  end
  server=Hash.new
  server[:server] = {
                            :name => s.name,
                            :description => description,
                            :deployment_href => @new_deployment.href,
                            :instance => {
                                            :cloud_href => new_cloud.href,
                                            :server_template_href => @server_template_href
                                         }
                          }
  
  pp "Creating Server #{s.name}"
  @server_hash=server
  @client.servers.create(server)
end

deployment_set_inputs(@new_deployment,@inputs)
