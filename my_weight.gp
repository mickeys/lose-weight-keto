set datafile separator ","				# needed to process CSV files
file='loseit.csv'						# our input comes from here
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
#	fname 'Arial bold' 
set terminal png \
	size 768,512 \
	background rgb 'white' \
	linewidth 1							# global default

set output 'i/my_weight.png'			# our output goes there

#reset
#set xdata
#timefmt='%m/%d/%Y'
#stats file using (strptime(timefmt,strcol(1)))
#print STATS_min
#print STATS_max
#set arrow nohead linewidth 10 linecolor rgb "orange" \
#	from STATS_min, graph 0.5 \
#	to STATS_max, graph 0.5

start_date='11/27/2009'
start_weight='237.0'

keto_start='10/31/2017'
keto_weight='220.0'

today_date='01/12/2018'
today_weight='185.8'

keto_days='73'							# https://days.to/30-october/2017

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# keto loss rate

start_secs=system( "/usr/local/opt/coreutils/libexec/gnubin/date -d '00:00' +%s" )
stop_secs_cmd=sprintf( "%s -d %s %s", \
	'/usr/local/opt/coreutils/libexec/gnubin/date', \
	keto_start, \
	'+%s' )
stop_secs=system( stop_secs_cmd )
keto_days=((start_secs - stop_secs) / ( 60 * 60 * 24 ) )

loss_lbs=( keto_weight - today_weight )
lbs_to_kg=0.45
keto_loss_phase_str=sprintf("%s (%d days)\n%s start - %s lbs (%.2f kg)\n%s today - %s lbs (%.2f kg)\nweight lost = %.2f lbs (%.2f kg)\naverage loss/day = %.2f lbs (%.2f kg)", \
	"Keto weight-loss phase", keto_days, \
	start_date, start_weight, ( start_weight * lbs_to_kg ), \
	today_date, today_weight, ( today_weight * lbs_to_kg ), \
	loss_lbs, ( loss_lbs * lbs_to_kg ), \
	( loss_lbs / keto_days), \
	( ( loss_lbs * lbs_to_kg ) / keto_days) \
	)
print keto_loss_phase_str

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
timefmt='%m/%d/%Y'
set timefmt timefmt						# incoming as "12/10/2017"
set key autotitle columnhead			# consume first line
woe_color="black"
atkins_start="3/5/2012"
low_carb_start="2/17/2014"
keto_start="10/30/2017"

##set style rect fc lt -1 fillstyle transparent solid 0.5 noborder
#set style rectangle front linewidth 1 fs solid 1.0 border lt -1
#set obj 16 rect fc rgb "red" \
#	from start_date, start_weight \
#	to today_date, today_weight

#set arrow filled nohead  ls 2 \
#	from start_date,"172" to today_date,"172"

set xdata time							# this is time data
set format x "%Y"						# show only the year
set xrange [start_date:today_date]

# global changes for all plots
#set pointsize 1						# globally set points to this size
#set style data linespoints				# globally set lines to this style
title_color="#a9a9a9"

# -----------------------------------------------------------------------------
# chart title and axes labels
# -----------------------------------------------------------------------------
set title textcolor rgb title_color
set title 'My Weight and WOEs (Ways of Eating) over time' \
	font ',12' offset 0,0	,0 \
	textcolor rgb title_color
#set xlabel 'Time' font ',9' offset 0,0.2,0
set ylabel 'Weight (pounds)' font ',10' offset 2,0,0 \
	textcolor rgb title_color
set y2label 'Weight (kilograms)' \
	font ',10' offset -2.75,0,0 \
	textcolor rgb title_color

# axes labels
set tics font ', 9' textcolor rgb 'red' nomirror scale 0
set ytics rotate by 45 right

# y2 axis now shows kilograms
#set ytics nomirror
set y2tics rotate by -45 right offset 1,0
set link y2 via y*lbs_to_kg inverse y/lbs_to_kg			# kilograms!

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
set grid linetype 0 linewidth 1 linecolor rgb '#ededed' back

# -----------------------------------------------------------------------------
# key (legend)
# -----------------------------------------------------------------------------
unset key

# -----------------------------------------------------------------------------
# ideal body weight
# -----------------------------------------------------------------------------
ideal_color='black'
set label 95 at start_date,"171.1" offset 1,lbs_to_kg \
	textcolor rgb ideal_color \
	"Ideal Body Weight - 171 lbs 77 kg"

# I hate hard-coding, but using graph 0, "171.1" fails somehow...
set arrow nohead linewidth 1 linecolor rgb ideal_color \
	from start_date, "171.1" to today_date, "171.1"

# -----------------------------------------------------------------------------
# textboxes - labels & arrows
# -----------------------------------------------------------------------------
#set style textbox \
#	border bordercolor "green" \
#	fillcolor "red" # margins 1,1 
set label 1 font ',9' at graph 0.65, graph 0.15 front \
	"What one eats between Christmas\nand New Years is not as important\nas what one eats between\nNew Years and Christmas!" front boxed

set style textbox border bordercolor "black"
set label 999 font ',9' textcolor rgb "red" \
	front boxed \
	at low_carb_start, graph 0.97 offset 2,-1.5 \
	sprintf( "%s", keto_loss_phase_str )

#set label 2 sprintf( "%s", keto_loss_phase_str ) \
#	at low_carb_start, graph 0.97 offset 1,-3 \
#	font ',9' textcolor rgb "red"
set arrow nohead linewidth 2 linecolor rgb "black" \
	from graph 0.8, graph 0.17 to "12/23/2017","196.4"

set label 3 sprintf( "%s", keto_weight ) \
	boxed left offset 1,0 font ',8' \
	at keto_start, keto_weight
set label 4 sprintf( "%s", today_weight ) \
	boxed left offset 1,0 font ',8' \
	at today_date, today_weight

# -----------------------------------------------------------------------------
# WoE rects (from left to right)
# -----------------------------------------------------------------------------
#set style rect fc lt -1 fillstyle transparent solid 0.5 noborder transparent
#set obj 17 rect fc rgb "#93b1a7" \
#	from graph 0, graph 1 to "03/05/2012", graph 0
set label 96 at start_date, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color font ',9' "CICO"
#	from atkins_start, graph 1.1 to low_carb_start, graph 0
set label 98 at atkins_start, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color font ',9' "Atkins"

set arrow nohead linewidth 1 linecolor rgb title_color \
	from atkins_start, graph 1.0 to atkins_start, "235.2"

#set obj 19 rect fc rgb "#c5edac" \
#	from low_carb_start, graph 1.1 to keto_start, graph 0
set label 97 at low_carb_start, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color font ',9' \
	"Lazy carb and many foreign trips"
set arrow nohead linewidth 1 linecolor rgb title_color \
	from low_carb_start, graph 1.0 to low_carb_start, "174.0"

#set obj 20 rect fc rgb "#dbfeb8" \
#	from keto_start, graph 1 to graph 1, graph 0
set label 99 at keto_start, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color font ',9' \
	"Keto"
set arrow nohead linewidth 1 linecolor rgb title_color \
	from keto_start, graph 1.0 to keto_start, "220.0"

# -----------------------------------------------------------------------------
# Now actually plot the data
# -----------------------------------------------------------------------------
set style fill transparent solid 0.67 noborder
unset border
# set size ratio -1
plot \
	file using 1:2 with filledcurves x1 \
		 lc rgb "#CCE5FF" lw 1, \
	file using 1:2 with lines \
		lc rgb "#66b2ff" lw 5, \
	file using 1:2:(0.33) with points \
		pointtype 7 lc rgb "red" ps variable, \
	'i/20100704_mickey_by_espressobuzz-cropped.jpg' \
		binary filetype=jpg center=(201,201) \
		format='%uchar' with rgbimage notitle