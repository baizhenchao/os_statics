#! ruby
# 这个方法其实可以用作nodeos_static类的私有方法，放在这里会变成main的方法
# ruby有些编程风格的习惯，可以参考http://stylesror.github.io/
class Apifunc
	def getnodepath(id,path)
		if path!=""
			#url="http://noah.baidu.com/service-tree/v1/node/path_#{path}"   #请求一下,保证path的正确性
			return path
		else
			url="http://noah.baidu.com/service-tree/v1/node/#{id}"
		end
		begin
			restc=RestClient.get url
			if restc.code==200
				res=JSON.parse(restc.to_s)
				return res["path"]
			end
		rescue=>e
			return "BAIDU_ECOM_SDC"
		end
	end
	def gethostlist(redis,date,path)
		unless redis.check("#{date}hostlist_#{path}")
			hostlist=[]
			res=`meta-query relation host #{path} -j`
			begin
				n=0
				oslist=JSON.parse(res)
			rescue
				n+=1
				retry if n<3
			end
			oslist[path].each do |osinfo|
				if !hostlist.include?("\"#{osinfo["Name"]}\"")
					hostlist << "\"#{osinfo["Name"]}\""
				end
			end
			redis.checkset("#{date}hostlist_#{path}",hostlist)
		end
		JSON.parse(redis.get("#{date}hostlist_#{path}"))
	end
	def func_oslist(redis,date,path)
		unless redis.check("#{date}oslist_#{path}")
			hostlist=gethostlist(redis,date,path)
			redis.checkset("#{date}oslist_#{path}",getOslist(date,hostlist))
		end
		redis.get("#{date}oslist_#{path}")
	end
	def func_osnum(redis,date,path)
		unless redis.check("#{date}osnum_#{path}")
			hostlist=gethostlist(redis,date,path)
			redis.checkset("#{date}osnum_#{path}",getOsnum(hostlist))
		end
		redis.get("#{date}osnum_#{path}")
	end
end
