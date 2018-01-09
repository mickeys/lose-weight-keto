set datafile separator ","				# needed to process CSV files
file='loseit.csv'						# our input comes from here
set output 'images/my_weight.svg'		# our output goes there

set timefmt '%m/%d/%Y'					# incoming as "12/10/2017"
set key autotitle columnhead			# consume first line

#set arrow filled nohead  ls 2 \
#	from "11/27/2009","172" to "01/06/2018","172"

set xdata time							# this is time data
set format x "%Y"						# show only the year

# global changes for all plots
#set pointsize 1						# globally set points to this size
#set style data linespoints				# globally set lines to this style

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
set title  'My Weight Over Time (with Ways of Eating)' font ',18' offset 0,-1,0
set xlabel 'Time' font ',14' offset 0,0.2,0
set ylabel 'Weight (pounds)' font ',14' offset 1.75,0,0
set y2label 'Weight (kilograms)' font ',14' offset -3.75,0,0

# axes labels
set tics font ', 11' textcolor rgb 'red' nomirror scale 0
set ytics rotate by 45 right

set ytics nomirror
set y2tics rotate by -45 right offset 1,0
set link y2 via y*0.45 inverse y/0.45			# kilograms!

# scale axes
#set xrange["26/10/2010 13:00:00":"01/06/2018"]
set yrange["170":"240"]

# -----------------------------------------------------------------------------
# background grid (linetype 0 = dashed lines)
# -----------------------------------------------------------------------------
set grid linetype 0 linewidth 1.5 linecolor rgb '#ededed' back

# -----------------------------------------------------------------------------
# key (legend)
# -----------------------------------------------------------------------------
#set key title 'My Weight' bottom left box linewidth 1 font ',18'
unset key

# -----------------------------------------------------------------------------
# ideal body weight
# -----------------------------------------------------------------------------
ideal_color='#104547'
set label 95 at "11/27/2009","171.1" offset 0,0.45 \
	textcolor rgb ideal_color \
	"  Ideal Body Weight  171 lbs 77 kg"

# I hate hard-coding, but using graph 0, "171.1" fails somehow...
set arrow nohead linewidth 1 linecolor rgb ideal_color \
	from "1/1/2009", "171.1" to "12/31/2018", "171.1"

# -----------------------------------------------------------------------------
# textboxes - labels & arrows
# -----------------------------------------------------------------------------
set style textbox opaque \
	border bordercolor "green" \
	fillcolor "red" # margins 1,1 
set label 1 font ",9" at graph 0.59, graph 0.15 \
	"What one eats between Christmas\nand New Years is not as important\nas what one eats between\nNew Years and Christmas!" front boxed
set arrow nohead linewidth 2 linecolor rgb "black" \
	from graph 0.72, graph 0.17 to "12/23/2017","196.4"

# -----------------------------------------------------------------------------
# WoE rects (from left to right)
# -----------------------------------------------------------------------------
set style rect fc lt -1 fillstyle transparent solid 0.5 noborder transparent

# mummy's tomb
set obj 17 rect fc rgb "#93b1a7" \
	from graph 0, graph 1 to "03/05/2012", graph 0
set label 96 at "11/27/2009", graph 0.95 "  CICO"

# cadet gray
set obj 18 rect fc rgb "#99c2a2" \
	from "3/5/2012", graph 1.1 to "2/17/2014", graph 0
set label 98 at "3/5/2012", graph 0.95 "  Atkins"

# eaton blue
set obj 19 rect fc rgb "#c5edac" \
	from "2/17/2014", graph 1.1 to "10/30/2017", graph 0
set label 97 at "2/17/2014", graph 0.95 \
	"  casual low-carb plus lots of travel"

# tea green
set obj 20 rect fc rgb "#dbfeb8" \
	from "10/30/2017", graph 1 to graph 1, graph 0
set label 99 at "10/30/2017", graph 0.95 "  keto"

plot \
	file using 1:2 with lines \
		lc rgb "#151515" lw 10, \
	file using 1:2:(0.33) with points \
		pointtype 7 lc rgb "red" ps variable