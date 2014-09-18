os_statics
==========
功能：
统计各个节点下机器不同系统数据，页面展示

文件介绍：
Bin: nodeos-statics 服务端启动程序

Bin: getnode.rb 后台CT任务每天6：00取SDC下所有机器系统信息存储到数据库

Config: nodeos_statics.yml默认设置

Config: dbconfig.yml 自定义设置，包括db, redis, Sinatra

Lib: nodeos_statics.rb 头文件引用

Lib: nodeos_statics: nodeos_statics.rb 服务端主程序

Lib: nodeos_statics: db.rb db基础类

Lib: nodeos_statics: urlredis.rb redis基础类

Lib: nodeos_statics: dbconfig db配置类

Lib: nodeos_statics: mysqlfunc.rb 数据库操作函数

Lib: nodeos_statics: apifunc.rb 查询系统API操作类

View: statics.erb 页面展现

Public:   css及js等文件

