#!/usr/bin/env ruby
class Db
	@@mydb=0
	def initialize config
		@dbcfg=config
		connect
	end
	def connect
		db=@dbcfg
		begin
			if @@mydb
			@@mydb=Mysql.new(db["ip"],db["user"],db["pass"].to_s,db["database"],db["port"].to_i)
			end
		rescue => e
			raise e
		end
	end
	def query query
		n=0
		begin
			@@mydb.query query
		rescue
			n+=1
			connect
			retry if n<3
		end
	end
	def dbclose
		@@mydb.close if @@mydb
		@@mydb=0
	end
end
