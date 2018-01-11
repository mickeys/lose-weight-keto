set datafile separator ","				# needed to process CSV files
file='loseit.csv'						# our input comes from here
set output 'images/my_weight.svg'		# our output goes there

start_hack="11/27/2009"
today_hack="01/11/2018"
# keto loss rate
#start_day='72'					# https://days.to/30-october/2017
#start_weight='220.0'
#end_weight='186.2'
#(220.0-186.2)/72=0.45

timefmt='%m/%d/%Y'
set timefmt timefmt						# incoming as "12/10/2017"
set key autotitle columnhead			# consume first line
woe_color="black"
atkins_start="3/5/2012"
low_carb_start="2/17/2014"
keto_start="10/30/2017"

#set arrow filled nohead  ls 2 \
#	from start_hack,"172" to today_hack,"172"

set xdata time							# this is time data
set format x "%Y"						# show only the year
set xrange [start_hack:today_hack]

# global changes for all plots
#set pointsize 1						# globally set points to this size
#set style data linespoints				# globally set lines to this style
title_color="#a9a9a9"

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
set terminal svg \
	size 768,512 \
	fname 'Arial bold' \
	background rgb 'white' \
	linewidth 1							# global default

# -----------------------------------------------------------------------------
# chart title and axes labels
# -----------------------------------------------------------------------------
set title textcolor rgb title_color
set title 'My Weight and WOEs (Ways of Eating) over time' \
	font ',18' offset 0,-1,0 \
	textcolor rgb title_color
#set xlabel 'Time' font ',14' offset 0,0.2,0
set ylabel 'Weight (pounds)' font ',14' offset 1.75,0,0 \
	textcolor rgb title_color
set y2label 'Weight (kilograms)' \
	font ',14' offset -3.75,0,0 \
	textcolor rgb title_color

# axes labels
set tics font ', 11' textcolor rgb 'red' nomirror scale 0
set ytics rotate by 45 right

# y2 axis now shows kilograms
#set ytics nomirror
set y2tics rotate by -45 right offset 1,0
set link y2 via y*0.45 inverse y/0.45			# kilograms!

# x2 axis now shows my age
##set link x2 via str2num(strftime(timefmt,$1))-1963 inverse x*1
#set x2tics
#set link x2 via strftime('%m/%d/%Y',x)-1963 inverse x

# scale axes
#set xrange["26/10/2010 13:00:00":"01/06/2018"]
set yrange["170":"240"]

# -----------------------------------------------------------------------------
# background grid (linetype 0 = dashed lines)
# -----------------------------------------------------------------------------
set grid linetype 0 linewidth 2 linecolor rgb '#ededed' back

# -----------------------------------------------------------------------------
# key (legend)
# -----------------------------------------------------------------------------
unset key

# -----------------------------------------------------------------------------
# ideal body weight
# -----------------------------------------------------------------------------
ideal_color='black'
set label 95 at start_hack,"171.1" offset 1,0.45 \
	textcolor rgb ideal_color \
	"Ideal Body Weight  171 lbs 77 kg"

# I hate hard-coding, but using graph 0, "171.1" fails somehow...
set arrow nohead linewidth 1 linecolor rgb ideal_color \
	from start_hack, "171.1" to today_hack, "171.1"

# -----------------------------------------------------------------------------
# textboxes - labels & arrows
# -----------------------------------------------------------------------------
set style textbox \
	border bordercolor "green" \
	fillcolor "red" # margins 1,1 
set label 1 font ',11' at graph 0.65, graph 0.15 front \
	"What one eats between Christmas\nand New Years is not as important\nas what one eats between\nNew Years and Christmas!" front boxed
set label 2 font ',11' at low_carb_start, graph 0.97 offset 2,-4 \
	textcolor rgb "red" \
	"Keto weight-loss phase\n10/30/2017 start - 220.0 lbs / 100 kg\n01/10/2018 today - 186.2 lbs / 84.5 kg\ndays since start = 72\nweight lost = 33.8 lbs / 15.3 kg\nloss/day = 0.45 lbs / 0.2 kg"
set arrow nohead linewidth 2 linecolor rgb "black" \
	from graph 0.8, graph 0.17 to "12/23/2017","196.4"

# -----------------------------------------------------------------------------
# WoE rects (from left to right)
# -----------------------------------------------------------------------------
#set style rect fc lt -1 fillstyle transparent solid 0.5 noborder transparent

#set obj 17 rect fc rgb "#93b1a7" \
#	from graph 0, graph 1 to "03/05/2012", graph 0
set label 96 at start_hack, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color \
	"CICO"

#set obj 18 rect fc rgb "#99c2a2" \
#	from atkins_start, graph 1.1 to low_carb_start, graph 0
set label 98 at atkins_start, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color "Atkins"
set arrow nohead linewidth 1 linecolor rgb title_color \
	from atkins_start, graph 1.0 to atkins_start, "235.2"

#set obj 19 rect fc rgb "#c5edac" \
#	from low_carb_start, graph 1.1 to keto_start, graph 0
set label 97 at low_carb_start, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color \
	"Lazy carb and many foreign trips"
set arrow nohead linewidth 1 linecolor rgb title_color \
	from low_carb_start, graph 1.0 to low_carb_start, "174.0"

#set obj 20 rect fc rgb "#dbfeb8" \
#	from keto_start, graph 1 to graph 1, graph 0
set label 99 at keto_start, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color \
	"Keto"
set arrow nohead linewidth 1 linecolor rgb title_color \
	from keto_start, graph 1.0 to keto_start, "220.0"

# -----------------------------------------------------------------------------
# Now actually plot the data
# -----------------------------------------------------------------------------
set style fill transparent solid 0.5 noborder
unset border

plot \
	file using 1:2 with filledcurves x1 \
		 lc rgb "#CCE5FF" lw 1, \
	file using 1:2 with lines \
		lc rgb "#66b2ff" lw 5, \
	file using 1:2:(0.33) with points \
		pointtype 7 lc rgb "red" ps variable