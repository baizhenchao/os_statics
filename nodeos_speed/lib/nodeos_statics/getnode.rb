#! ruby
$home= File.join(File.dirname(__FILE__),'../../')
$LOAD_PATH.unshift(File.join($home,'lib'))
require 'nodeos_statics'
def getosname(date)
		path=getnodepath("","BAIDU_ECOM")
		res=`meta-query relation host -f sysOsInfo -j #{path}`
		oslist=JSON.parse(res)
		oscount={}
		oslist[path].each do |osinfo|
				if osinfo["Values"]==nil
						next
				end
				if !oscount.include?(osinfo["Name"])
						oscount[osinfo["Name"]]=osinfo["Values"]["sysOsInfo"]
				end
		end
		oscount.each do |key,value|
				case value
				when "Red Hat Enterprise Linux AS release 4 (Nahant Update 3)" then
						insertdata(date,key,value,"RedHat4.3")
				when "CentOS release 6.3 (Final)" then
						insertdata(date,key,value,"CentOS6.3")
				when "CentOS release 4.3 (Final)" then
						insertdata(date,key,value,"CentOS4.3")
				when "CentOS release 5.8 (Final)" then
						insertdata(date,key,value,"CentOS5.8")
				when "" then
						insertdata(date,key,value,"Unknown")
				when "null" then
						insertdata(date,key,value,"Unknown")
				else
						insertdata(date,key,value,"Others")
				end
		end
end
def insertdata(date,host,osname,os)
	begin
		db=Mysql.init
		db=Mysql.real_connect($config["db"]["ip"],$config["db"]["user"],$config["db"]["pass"].to_s,$config["db"]["database"],$config["db"]["port"].to_i)
		db.query("insert into Server_osstatics(date,host,osname,os) value('#{date}','#{host}','#{osname}','#{os}')")
		result=db.affected_rows
	rescue Mysql::Error=>e
		puts "Error code: #{e.errno}"
		puts "Error message: #{e.error}"
		puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
	ensure
		db.close if db
	end
	return result
end
#result=insertdata(ARGV[0],"test_machine_test001","Centos test111")
#p result
#getosname(ARGV[0])
#getosname("20140827")
getosname Date.today.strftime('%Y%m%d')
