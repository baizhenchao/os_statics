#! ruby
def getnodepath(id,path)
		result={"success"=>true,"message"=>""}
		if id==""
			url="http://noah.baidu.com/service-tree/v1/node/path_#{path}"
		elsif path==""
			url="http://noah.baidu.com/service-tree/v1/node/#{id}"
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
				getnodepath(13584,"")
		end
end
def gethostlist(path)
	redis=Urlredis.new
	os={}
		newpath=getnodepath("",path)
		res=`meta-query relation host #{newpath} -j`
		begin
			n=0
			oslist=JSON.parse(res)
		rescue
			n+=1
			gethostlist(newpath)
			retry if n<3
		end
		oslist[path].each do |osinfo|
				if !os.include?(osinfo["Name"])
						os[osinfo["Name"]]=1
				end
		end
	return os
end
#path=getnodepath("","BAIDU_ECOM_SDC_MA_WEB")
#p path

#oslist=gethostlist("BAIDU_ECOM_SDC_MA_WEB")
#arraystr=""
#oslist.each_key do |key|
#		arraystr+="\""+key+"\""+","
#end
#arraystr=arraystr.chop
