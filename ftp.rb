#!/usr/bin/env ruby
#
# Copyrigth (C) 2014 - Benny Ojeda
# Description: FTP Client
# Version: 1.0
# License: GPLv3

require 'net/ftp'
require 'socket'

def welcome
	puts @ftp.welcome
	s = TCPSocket.open(@host, 21)
	puts s.gets
	s.close
	puts @ftp.system
	if @ftp.passive == true
		puts "PASSIVE MODE: on"
	else
		puts "PASSIVE MODE: off"
	end
	puts @ftp.status

end

def exit
	puts "Goodbye!"
end

def debugon
	@ftp.debug_mode = true
end

def debugoff
	@ftp.debug_mode = false
end

def help
	puts "help\t clear ls status system" 
	puts "pwd cd size size_h get send"
	puts "gettext sendtext last debug[on/off]"
 	puts "mkdir rmdir delete rename passive"
end

def clear
	system "clear"
end

def ls
	dir_lst = @shell.split(/\s/)
	puts @ftp.list(dir_lst[1])
end

def status
	puts @ftp.status
end

def passive
	puts @ftp.passive
end

def pwd
	puts @ftp.pwd
end

def ftpsystem
	puts @ftp.system
end

def cd
	begin
		folder_name = @shell.split(/\s/)
		@ftp.chdir(folder_name[1])
	rescue
		puts "cannot change to \'#{folder_name[1]}\'."
	end

end

def size
	begin
		s_name = @shell.split(/\s/)
		puts @ftp.size(s_name[1])
	rescue
		puts "incorrect file \'#{s_name[1]}\'."
	end
end

def size_h
	begin
		sh_name = @shell.split(/\s/)
		result = @ftp.size(s_name[1]) / 1024
		print result.to_f
		puts " Kb"
	rescue
		puts "incorrect file \'#{sh_name[1]}\'."
	end
end

def get
	begin
		b_name = @shell.split(/\s/)
		@ftp.getbinaryfile(b_name[1], b_name[1], 1024)
	rescue
		puts "cannot get \'#{b_name[1]}\'."
	end
end

def send
	begin
		lbin_name = @shell.split(/\s/)
		@ftp.putbinaryfile(lbin_name[1], lbin_name[1], 1024)
	rescue
		puts "cannot send \'#{lbin_name[1]}\'."
	end
end

def gettext
	begin
		t_name = @shell.split(/\s/)
		@ftp.gettextfile(t_name[1])
	rescue
		puts "cannot get \'#{t_name[1]}\'."
	end
end

def sendtext
	begin
		lt_name = @shell.split(/\s/)
		@ftp.puttextfile(lt_name[1], lt_name[1])
	rescue
		puts "cannot send \'#{lt_name[1]}\'."
	end
end

def delete
	begin
		d_name = @shell.split(/\s/)
		@ftp.delete(d_name[1])
	rescue
		puts "cannot delete \'#{d_name[1]}\'."
	end
end

def mkdir
	begin
		dir_name = @shell.split(/\s/)
		@ftp.mkdir(dir_name[1])
	rescue
		puts "cannot create directory \'#{dir_name[1]}\'."
	end
end

def rmdir
	begin
		rd_name = @shell.split(/\s/)
		@ftp.rmdir(rd_name[1])
	rescue
		puts "cannot remove directory \'#{rd_name[1]}\'."
	end
end

def rename
	begin
		re_name = @shell.split(/\s/)
		@ftp.rename(re_name[1], re_name[2])
	rescue
		puts "cannot rename \'#{re_name[1]}\'."
	end
end

def last
	puts @ftp.lastresp
end

def bash
	while TRUE
		print "local@bash> "
		STDOUT.flush
		bash = STDIN.gets
		break if not bash
		bash.chop!
		if bash == "exit"
			break
		elsif bash == ""
		else
			system "#{bash};"
		end
	end
end

def lls
	Dir["*"].each do |cont|
		puts cont
	end
end

def lcp
	begin
		file = @shell.split(/\s/)
		FileUtils.cp file[1], file[2]
	rescue
		puts "cannot copy \'#{file[1]}\' to \'#{file[2]}\'."
	end
end

def default
	puts "Invalid command: #{@shell}"
end

host = ARGV[0]
@host = host
print "Host: " unless ARGV[0]
host = STDIN.gets unless ARGV[0]
host.chop! unless ARGV[0]

username = ARGV[1]
@username = username
print "User: " unless ARGV[1]
username = STDIN.gets unless ARGV[1]
username.chop! unless ARGV[1]

password = ARGV[2]
@password = password
print "Password: " unless ARGV[2]
password = STDIN.gets unless ARGV[2]
password.chop! unless ARGV[2]

#if host == 'localhost' || host == '127.0.0.1' || host =~ /192.168/
	Net::FTP.open(host) do |ftp|
	@ftp = ftp
        ftp.login(user=username.to_s, passwd=password.to_s, acct=nil)
	welcome()
	
	while TRUE
        	print "ftp> "
        	STDOUT.flush
        	shell = STDIN.gets
        	break if not shell
        	shell.chop!
		@shell = shell

		if shell == ""
		elsif shell == "exit"			 then	exit	;break
		elsif shell == "debug on"		 then	debugon
		elsif shell == "debug off"		 then 	debugoff
		elsif shell == "help"			 then 	help
		elsif shell == "clear"			 then 	clear
		elsif shell == "status"			 then	status
		elsif shell == "passive"		 then	passive
		elsif shell == "pwd"			 then	pwd
		elsif shell == "system"			 then	ftpsystem
		elsif shell == "last"			 then	last
		elsif shell == "bash"			 then	bash
		elsif shell == "lls"			 then	lls
		elsif shell.split(/\s/)[0] == "ls"	 then	ls
		elsif shell.split(/\s/)[0] == "cd"	 then	cd
		elsif shell.split(/\s/)[0] == "size"	 then	size
		elsif shell.split(/\s/)[0] == "size_h"	 then	size_h
		elsif shell.split(/\s/)[0] == "get"	 then	get
		elsif shell.split(/\s/)[0] == "send"	 then	send
		elsif shell.split(/\s/)[0] == "gettext"	 then	gettext
		elsif shell.split(/\s/)[0] == "sendtext" then	sendtext
		elsif shell.split(/\s/)[0] == "delete"	 then	delete
		elsif shell.split(/\s/)[0] == "mkdir"	 then	mkdir
		elsif shell.split(/\s/)[0] == "rmdir"	 then	rmdir
		elsif shell.split(/\s/)[0] == "rename"	 then	rename
		elsif shell.split(/\s/)[0] == "lcp"	 then	lcp
        	else						default
        	end
	end
	end
#else
#	puts "[-] Incorrect host"
#end
