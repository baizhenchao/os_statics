#! ruby

home = File.join(File.dirname(__FILE__),'..')
$LOAD_PATH.unshift(File.join(home,'lib'))

require 'nodeos_statics'

config = YAML.load_file File.join(home,"config/nodeos_statics.yml")
