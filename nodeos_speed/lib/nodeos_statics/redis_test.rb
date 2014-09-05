#!/usr/bin/env ruby
$home= File.join(File.dirname(__FILE__),'../../')
$LOAD_PATH.unshift(File.join($home,'lib'))
require "nodeos_statics"
def redis_test
	redis=Redis.new($config["redis"])
	#redis=Urlredis.new
	#redis=Redis.new(:host=>"127.0.0.1",:port=>"6379",:db=>15)
	nodepath=getnodepath("","")
	hostlist=gethostlist(nodepath)
	date=Date.today.strftime('%Y%m%d')
	myjs=getOss(date,hostlist)
	myjs=myjs.to_json
	redis.set("mykey",myjs)
	#redis.set("oslist_"+nodepath,getOslist(date,hostlist))
	#JSON.parse(redis.get("oslist_"+nodepath))
	JSON.parse(redis.get("mykey"))
	#redis_del("oslist_"+nodepath)
	#redis_del("osnum_"+nodepath)
end
def redis_del(path)
	redis=Redis.new($config["redis"])
	if redis.exists(path)
		redis.del(path)
		puts "del:"+path
	end
end
def redis_func(key,js)
	if(!redis.exists(key))
		redis=Redis.new($config["redis"])
		redis.set(key,js)
	end
	JSON.parse(redis.get(key))
end
list=redis_test
list.each do |str|
	puts str
end
#url=Urlredis.new
#p url.continue("mykey")
