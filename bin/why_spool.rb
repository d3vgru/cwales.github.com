#!/usr/bin/env ruby

=begin
originally a bash script from https://gist.github.com/spro/5416485
"Read _why's SPOOL in real time.
Requires `lp` and a printer." (and git)

-converted to ruby
-changed curl to git, be sure to:
   git remote add cwales https://github.com/cwales/cwales.github.com.git
=end


# parse a file called index
def parse_index
	return File.open(@index_path, "rb").read.split(/\n/)
end


# figure out where script is and use parent dir as root
@bin_path = File.dirname($PROGRAM_NAME)
@root_path = File.expand_path("..", @bin_path)
@index_path = @root_path + File::Separator + "index.html"
@spool_pattern = Regexp.new("SPOOL/[A-Z]+")
Dir.chdir(@root_path)

# parse the current index
old_index = parse_index

# MAIN EVENT LOOP 
while 1 do    
    # merge the latest master (don't make people install Grit)
    system("git fetch cwales")
    system("git merge cwales/master")
    
    # parse the new index
    new_index = parse_index
    
    # find files in new_index that aren't in old index
	new_files = new_index - old_index
    
    # for each new entry..
    new_files.each do |file_line|
    	# do something with it (print. no, wait. call a plugin? let's make a framework. ;)
    	match_data = @spool_pattern.match(file_line)
        if match_data
            file_name = match_data[0]
            puts file_name
            system("lp -o raw " << file_name)
        end
    end
    old_index = new_index
    sleep 60
end
