#!/usr/bin/env ruby

class Dbconfig < Hash
	def initialize config_file=nil
		self.merge! default_value
		if config_file
			begin
				c=YAML.load_file(config_file)
				self.merge! c
			rescue=>e
				raise "Con't find #{config_file} : #{e}"
			end
		end
	end
	def default_value
		{
			
				"ip"=>"10.50.35.55",
				"port"=>"3336",
				"user"=>"xiaobai",
				"pass"=>"123",
				"database"=>"xiaobai"
			
		}
	end
end
