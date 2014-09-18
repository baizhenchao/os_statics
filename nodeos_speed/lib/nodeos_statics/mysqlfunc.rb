#! ruby
# 和数据库有关的东西可以封入一个对象，回一下Active Record
$mydb=Db.new $config["db"]
def getrange(hostlist)
		range=""
		range=hostlist.join(",")
		return range
end
def gethostbyOs(os,date,hostlist)
		trange=getrange(hostlist)
		rslt=$mydb.query("select host from Server_osstatics where os=\"#{os}\" and date=\"#{date}\" and host in (#{trange})")
		res=Array.new
		while row=rslt.fetch_row do
				res.push(row[0])
		end
		return res
end
def getOss(date,hostlist)
		trange=getrange(hostlist)
		rslt=$mydb.query("select distinct os from Server_osstatics where date=\"#{date}\" and host in (#{trange})")
		res=Array.new
		while row=rslt.fetch_row do
			res.push(row[0])
		end
		return res
end
def getOslist(date,hostlist)
		trange=getrange(hostlist)
		rslt=$mydb.query("select os,count(*) from Server_osstatics where date=\"#{date}\" and host in (#{trange}) group by osname")
		res={}
		while row=rslt.fetch_row do
				res[row[0]]=row[1].to_f
		end
		return res.to_a
end
def seriesin(series,hash)
		i=0
		series.each do |tmp|
				if tmp["name"]==hash["name"]
						return i
				end
				i+=1
		end
		return -1
end
def getOsnum(hostlist)
	result={}
	rslt=$mydb.query("select distinct date from Server_osstatics")
	res=[]
	while row=rslt.fetch_row do
			res.push(row[0])
	end
	result["categories"]=res
	series=[]
	res.each do |time|
			oslist=getOslist(time,hostlist)
			oslist.each do |osnum|
					tmphash={}
					tmphash["name"]=osnum[0]
					tmphash["data"]=osnum[1]
			if seriesin(series,tmphash)!=-1
					series[seriesin(series,tmphash)]["data"].push(tmphash["data"])
			else
					tarray=[tmphash["data"]]
					tmphash["data"]=tarray
					series.push(tmphash)
			end
			end
	end
	result["series"]=series
	return result
end
$mydb.dbclose
#os=getOslist("20140822")
#p os[0][0]
#os.each do |h|
#		puts h[0]
#end
#oslist=gethostlist("BAIDU_ECOM_SDC_MA_WEB")
#os=getOsnum(oslist)
#p os
#host=gethostbyOs("CentOS release 4.3 (Final)","20140822")
#host.each do |h|
#p h
#end
#res=getOsnum
#p res
