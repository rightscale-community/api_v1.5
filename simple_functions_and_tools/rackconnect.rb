require 'simple_functions.rb'

@deployment='Rack Connect Base ServerTemplate for Linux (v13.2.1) v333'

def count_rc
@counter_one=0
@counter_two=0
@client.server_arrays.index(:filter => ["name==#{@deployment}"]).first.current_instances.index.each do |i|
  if i.public_ip_addresses.count >=2
    @counter_two +=1
  else
    @counter_one += 1
  end
end
puts "Servers with one ip:#{@counter_one}"
puts "Servers with two ips:#{@counter_two}"
end

def server_launch(count, delay)
@counter = 0
while @counter <=count do
  @client.server_arrays.index(:filter => ["name==#{@deployment}"]).first.launch
  sleep delay
  @counter += 1
  puts "Started #{@counter}"
end
end

def kill_all
  @client.server_arrays.index(:filter => ["name==#{@deployment}"]).first.multi_terminate
end

def term_op
  @client.server_arrays.index(:filter => ["name==#{@deployment}"]).first.current_instances.index.each do |i| 
    if i.state == "operational"
      i.terminate
    end
  end
end
