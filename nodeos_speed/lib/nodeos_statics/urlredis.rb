#!/usr/bin/env ruby
class Urlredis
	@@redis=0
	def initialize
		@@redis=Redis.new($config["redis"])
	end
	def set(key,js)
		@@redis.set(key,js)
	end
	def get(key)
		@@redis.get(key)
	end
	def check(key)
		@@redis.exists(key)
	end
end
#url=Urlredis.new
#p url.continue("mykey")
