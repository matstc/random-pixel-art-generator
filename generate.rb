#!/usr/bin/env ruby

if ARGV.length != 1
	puts "Execute this script with a name as the only argument (e.g. #{$0} beautiful-art)"
	exit 1
end

require "pnm"
require "chroma"

OFF_WHITE = 0
ODDS_OF_COLOR = 0.18
PURPLE = [207,0,203]
BLACK = [0,0,0]
WHITE = [255-OFF_WHITE, 255-OFF_WHITE, 255-OFF_WHITE]
ORANGE = [229,64,48]
COLORS = [BLACK, ORANGE, PURPLE]

pixels = (0..10).map do
	(0..10).map do
		if rand(100) < (ODDS_OF_COLOR * 100)
			COLORS[rand(COLORS.length)]
		else
			WHITE
		end
	end
end

# create the image object
image = PNM.create(pixels, {:comment => "#{ARGV[0]}"})
filename = ARGV[0]
image.write("#{filename}.pgm", :ascii)

puts "Created PGM file"
command = "convert -resize 1000x1000 -extent 1800x1800 -gravity center -background \"#{"rgb(#{WHITE.join(',')})".paint.to_hex}\" -interpolate integer -filter box #{filename}.pgm #{filename}.png"
puts command
puts `#{command}`
puts "Resized"
puts `rm #{filename}.pgm`
puts "Cleaned"
puts "Done: #{filename}.png"
exec "gnome-open #{filename}.png"

