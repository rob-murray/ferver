require File.join(File.dirname(__FILE__), 'src/', 'ferver')


def main

	# use the first argument as the file path to serve from
	ferver_path = (ARGV.length == 1 && ARGV[0]) || nil
	Ferver.set :ferver_path, ferver_path

	#  Run!
	Ferver.run!

end


if __FILE__ == $0
	main()
end

