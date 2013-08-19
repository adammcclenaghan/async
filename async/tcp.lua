-- c lib / bindings for libuv
local uv = require 'luv'

-- handle
local handle = require 'async.handle'

-- TCP server/client:
local tcp = {}

function tcp.listen(domain, cb)
   local host = domain.host
   local port = domain.port
   local server = uv.new_tcp()
   uv.tcp_bind(server, host, port)
   function server:onconnection()
      local client = uv.new_tcp()
      uv.accept(server, client)
      cb(handle(client))
      uv.read_start(client)
   end
   uv.listen(server)
   return handle(server)
end

function tcp.connect(domain, cb)
   local host = domain.host
   local port = domain.port
   local client = uv.new_tcp()
   local h = handle(client)
   uv.tcp_connect(client, host, port, function()
      cb(h)
      uv.read_start(client)
   end)
   return h
end

-- TCP lib
return tcp