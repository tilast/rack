require 'rack'

#\ -w -p 8765

class SimpleSystemInformation
	def call(env)
		@request = Rack::Request.new(env)
		@response = Rack::Response.new

		@response.status = 200
		@response["Content-type"] = "text/html"

		@response.body = handle(@request.env["REQUEST_URI"])

		@response.finish
	end

	def handle(location)
		arr = location.split('/').slice(3..-1)

		case arr[0]
			when nil
				result = [header]
			when "memory"
				result = [header + "<h1 style='color: green'>Free memory: </h1><pre>", memory, "</pre>"]
			when "disk"
				result = [header + "<h1 style='color: red'>Disk memory: </h1><pre>", disk, "</pre>"]
		end 

		result
	end

	def header
		"<div><a href='/memory'>Free memory</a> | <a href='/disk'>Disk memory</a></div>"
	end

	def disk
		`df -h`
	end

	def memory
		`free -m`
	end
end

run SimpleSystemInformation.new