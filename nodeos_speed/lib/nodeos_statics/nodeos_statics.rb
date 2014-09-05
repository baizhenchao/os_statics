#!usr/bin/env ruby

class NodeOs_Statics < Sinatra::Base
		set :public_folder, File.join(File.dirname(__FILE__),'../../public')
		set :views, File.join(File.dirname(__FILE__),'../../views')
		set :port, '8569'
		set :bind, '0.0.0.0'
		set :protection, :except => :frame_options
		configure :production, :development do
				enable :logging
		end

		get '/centos' do
				nodename=params[:nodename]
				nodeid=params[:nodeid]
				if nodeid==nil
						nodeid=""
				end
				if nodename==nil
						nodename=""
				end
				$redis=Urlredis.new
				$nodepath=getnodepath(nodeid,nodename)
				$hostlist=gethostlist($nodepath)
				$date=Date.today.strftime('%Y%m%d')

				if !$redis.check($date+"oslist_"+$nodepath)
					os=getOslist($date,$hostlist)
					os=os.to_json
					$redis.set($date+"oslist_"+$nodepath,os)
				end
				@oslist=JSON.parse($redis.get($date+"oslist_"+$nodepath))

				
				#@oslist=getOslist($date,$hostlist)
				erb :statics
		end

		get '/centos_pie' do
			if !$redis.check($date+"oslist_"+$nodepath)
				os=getOslist($date,$hostlist)
				os=os.to_json
				$redis.set($date+"oslist_"+$nodepath,os)
			end
			res=JSON.parse($redis.get($date+"oslist_"+$nodepath))
			res.to_json
		end

		get '/centos_line' do
			if !$redis.check($date+"osnum_"+$nodepath)
				osnum=getOsnum($hostlist)
				osnum=osnum.to_json
				$redis.set($date+"osnum_"+$nodepath,osnum)
			end
			$redis.get($date+"osnum_"+$nodepath)
		end

		get '/centos_host' do
				hostl=gethostbyOs(params[:osname],$date,$hostlist)
				str="<ul class=\"list-group\">"
				hostl.each do |host|
						str+="<li class=\"list-group-item\">"+host+"</li>"
				end
				str+="</ul>"
		end

end
