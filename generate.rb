#!/usr/bin/env ruby

if ARGV.length != 1
	puts "Execute this script with a name as the only argument (e.g. #{$0} beautiful-art)"
	exit 1
end

require "pnm"
require "chroma"

OFF_WHITE = 0
ODDS_OF_COLOR = 0.70
BLACK = [60,60,60]
YELLOW = [255,180,45]
ORANGE = [232,132,41]
ORANGE2 = [255,114,58]
RED = [232,58,41]
PURPLE = [255,48,120]
WHITE = [255-OFF_WHITE, 255-OFF_WHITE, 255-OFF_WHITE]
COLORS = [BLACK, YELLOW, ORANGE, ORANGE2, RED, PURPLE]
SIZE = 4

pixels = (0..SIZE).map do
	(0..SIZE).map do
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
command = "convert -resize 2000x2000 -extent 2000x2000 -gravity center -background \"#{"rgb(#{WHITE.join(',')})".paint.to_hex}\" -interpolate integer -filter box #{filename}.pgm #{filename}.png"
puts command
puts `#{command}`
puts "Resized"
puts `rm #{filename}.pgm`
puts "Cleaned"
puts "Done: #{filename}.png"
exec "gnome-open #{filename}.png"

