#!usr/bin/env ruby

class NodeOs_Statics < Sinatra::Base

	$config = Dbconfig.new(File.join($home,"config/dbconfig.yml"))
	sinatra_cfg=$config["sinatra"]
	set :public_folder, File.join($home,'/public')
	set :views, File.join($home,'/views')
	set :port, sinatra_cfg["port"]
	set :bind, sinatra_cfg["bind"]
	set :protection, :except => :frame_options
	configure :production, :development do
		enable :logging
	end
	enable :sessions

	@@redis=Urlredis.new
		
	get '/centos' do
		nodename=params[:nodename]
		nodeid=params[:nodeid]
		if nodeid==nil
			nodeid=""
		end
		if nodename==nil
			nodename=""
		end

		api=Apifunc.new
		session[:nodepath]=api.getnodepath(nodeid,nodename)
		session[:date]=Date.today.strftime('%Y%m%d')
		
		@oslist=JSON.parse(api.func_oslist(@@redis,session[:date],session[:nodepath])
)
		#@oslist=getOslist(session[:date],session[:hostlist])
		# 可以通过参数方式给view传参数，而不是使用全局变量
		erb :statics
	end

	get '/centos_pie' do
		api=Apifunc.new
		api.func_oslist(@@redis,session[:date],session[:nodepath])
	end

	get '/centos_line' do
		# 同样的代码出现了三次，考虑下封装。
		api=Apifunc.new
		api.func_osnum(@@redis,session[:date],session[:nodepath])
	end

	get '/centos_host' do
		api=Apifunc.new
		hostlist=api.gethostlist(@@redis,session[:date],session[:nodepath])
		hostl=gethostbyOs(params[:osname],session[:date],hostlist)
		str="<ul class=\"list-group\">"
		hostl.each do |host|
			str+="<li class=\"list-group-item\">"+host+"</li>"
		end
		str+="</ul>"
	end

end
