#sed -n '/TOP/{:a;n;/BOTTOM/b;\|\""|s/*/\1/p;ba}' inputfile

#sed -n '/2009/{:a;n;/2012/b;\|\"|s/(^*$)/\1/p;ba}' inputfile

#sed -n "/11.27.2009/,/03.05.2012/p" loseit.csv
# sed -n '/11\/27\/2009/{:a;n;/03\/05\/2012/b;p;ba}' loseit.csv

#sed -n '/11\/27\/2009/{:a;n;/03/05/2012/b;*p;ba}' 
#sed -n '/2009/{:a;n;/2012/b;*p;ba}' 
#sed -n '/Weight/,/03\/05\/2012/{//!p}' loseit.csv





#https://i.imgur.com/4TzBcXG.png
#
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

today_date='01/28/2018'
today_weight='175.0'

keto_start_date='10/30/2017'
keto_start_weight='220.0'

lazy_carb_start_date='02/17/2014'
lazy_carb_weight="174.0"

atkins_start_date='03/05/2012'
atkins_start_weight='235.2'

cico_start_date="11/27/2009"
cico_start_weight="237.0"

k_ideal_body_weight='171.1'				# www.calculator.net/ideal-weight-calculator.html
k_lb_to_kg=0.45							# constant conversion factor

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# keto loss rate

start_secs=system( "/usr/local/opt/coreutils/libexec/gnubin/date -d '00:00' +%s" )
stop_secs_cmd=sprintf( "%s -d %s %s", \
	'/usr/local/opt/coreutils/libexec/gnubin/date', \
	keto_start_date, \
	'+%s' )
stop_secs=system( stop_secs_cmd )
keto_days=((start_secs - stop_secs) / ( 60 * 60 * 24 ) )

# convert strings to numbers for calculation
p_keto_start_weight = keto_start_weight + 0
p_today_weight = today_weight + 0
p_keto_start_weight = keto_start_weight + 0
p_k_ideal_body_weight = k_ideal_body_weight + 0
loss_pct=sprintf ( "%0.2f", ( p_keto_start_weight - p_today_weight ) / \
	( p_keto_start_weight - p_k_ideal_body_weight ))

# -----------------------------------------------------------------------------
loss_lbs=( keto_start_weight - today_weight )

keto_phase_str=sprintf("%s (%d days)\n%s start - %s lb (%.2f kg)\n%s today - %s lb (%.2f kg)\nlost = %.2f lb (%.2f kg) %s%% done\naverage loss/day = %.2f lb (%.2f kg)", \
	"Keto weight-loss phase", keto_days, \
	cico_start_date, cico_start_weight, ( cico_start_weight * k_lb_to_kg ), \
	today_date, today_weight, ( today_weight * k_lb_to_kg ), \
	loss_lbs, ( loss_lbs * k_lb_to_kg ), loss_pct, \
	( loss_lbs / keto_days), \
	( ( loss_lbs * k_lb_to_kg ) / keto_days) \
	)
print keto_phase_str				# debug output

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
timefmt='%m/%d/%Y'
set timefmt timefmt						# incoming as "12/10/2017"
set key autotitle columnhead			# consume first line
woe_color="black"

##set style rect fc lt -1 fillstyle transparent solid 0.5 noborder
#set style rectangle front linewidth 1 fs solid 1.0 border lt -1
#set obj 16 rect fc rgb "red" \
#	from cico_start_date, cico_start_weight \
#	to today_date, today_weight

#set arrow filled nohead  ls 2 \
#	from cico_start_date,"172" to today_date,"172"

set xdata time							# this is time data
set format x "%Y"						# show only the year
set xrange [cico_start_date:today_date]

# global changes for all plots
#set pointsize 1						# globally set points to this size
#set style data linespoints				# globally set lines to this style
title_color="#a9a9a9"

# -----------------------------------------------------------------------------
# chart title and axes labels
# -----------------------------------------------------------------------------
set title textcolor rgb title_color
set title 'My Weight and WOEs (Ways of Eating) over time' \
	font ',11' offset 0,0 \
	textcolor rgb title_color
#set xlabel 'Time' font ',9' offset 0,0.2,0
set ylabel 'Weight (pounds)' font ',10' offset 2,0,0 \
	textcolor rgb title_color
set y2label 'Weight (kilograms)' \
	font ',10' offset -2.75,0,0 \
	textcolor rgb title_color

# axes labels
set tics font ', 8' textcolor rgb 'red' nomirror scale 0
set ytics rotate by 45 right

# y2 axis now shows kilograms
set y2tics rotate by -45 right offset 1,0
set link y2 via y* k_lb_to_kg inverse y/ k_lb_to_kg			# kilograms!

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
#
# fix this to use the k_ideal_body_weight variable, set above
# -----------------------------------------------------------------------------
ideal_color='white'
set label 95 at cico_start_date,"171.1" offset 1, k_lb_to_kg \
	front font ',9' textcolor rgb ideal_color \
	"Ideal Body Weight - 171 lb (77 kg)"

# I hate hard-coding, but using graph 0, "171.1" fails somehow...
set arrow nohead front linewidth 2 linecolor rgb ideal_color \
	from cico_start_date, "171.1" to today_date, "171.1"

# -----------------------------------------------------------------------------
# textboxes - labels & arrows
# -----------------------------------------------------------------------------
set label 1 font ',9' at graph 0.65, graph 0.15 front \
	"What one eats between Christmas\nand New Years is not as important\nas what one eats between\nNew Years and Christmas!" front boxed

set style textbox border bordercolor "black" opaque

# keto_phase_str
set label 999 font ',8' textcolor rgb "red" \
	front boxed \
	at lazy_carb_start_date, graph 0.97 offset 2,-1.5 \
	sprintf( "%s", keto_phase_str )

# CICO - program_start_*
set label 998 font ',8' textcolor rgb "black" \
	front boxed \
	at cico_start_date, cico_start_weight offset 1.5,-0.5 \
	sprintf( "%s lb\n%d kg", cico_start_weight, \
	( cico_start_weight * k_lb_to_kg ) )

# atkins_start_*
set label 997 font ',8' textcolor rgb "black" \
	front boxed \
	at atkins_start_date, atkins_start_weight offset 1.5,0 \
	sprintf( "%s lb\n%d kg", atkins_start_weight, \
	( atkins_start_weight * k_lb_to_kg ) )

# atkins low point
set label 996 font ',8' textcolor rgb "black" \
	front boxed \
	at "04/28/2014","173.0" offset 1,0.75 \
	sprintf( "%s lb\n%d kg", "173.0", (173 * k_lb_to_kg) )

set arrow nohead front linewidth 1 linecolor rgb "black" \
	from graph 0.8, graph 0.17 to "12/16/2017","196.3"

set label 3 sprintf( "%s lb\n%d kg", keto_start_weight, \
	keto_start_weight * k_lb_to_kg ) \
	boxed left offset 1,0 font ',8' \
	at keto_start_date, keto_start_weight

set label 4 sprintf( "%s lb\n%d kg", today_weight, today_weight * k_lb_to_kg ) \
	boxed left offset 1,0 font ',8' \
	at today_date, today_weight

# -----------------------------------------------------------------------------
# WoE rects (from left to right)
# -----------------------------------------------------------------------------
#set style rect fc lt -1 fillstyle transparent solid 0.5 noborder transparent
#set obj 17 rect fc rgb "#93b1a7" \
#	from graph 0, graph 1 to "03/05/2012", graph 0

set arrow nohead linewidth 1 linecolor rgb title_color \
	from cico_start_date, graph 1.0 to cico_start_date, "237.0"
set label 96 at cico_start_date, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color font ',9' "calories in < calories out"
set label 98 at atkins_start_date, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color font ',9' "Atkins"

set arrow nohead linewidth 1 linecolor rgb title_color \
	from atkins_start_date, graph 1.0 to atkins_start_date, "235.2"

#set obj 19 rect fc rgb "#c5edac" \
#	from lazy_carb_start_date, graph 1.1 to keto_start_date, graph 0
set label 97 at lazy_carb_start_date, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color font ',9' \
	"Lazy carb and many foreign trips"
set arrow nohead front linewidth 1 linecolor rgb title_color \
	from lazy_carb_start_date, graph 1.0 to lazy_carb_start_date, "174.0"

#set obj 20 rect fc rgb "#dbfeb8" \
#	from keto_start_date, graph 1 to graph 1, graph 0
set label 99 at keto_start_date, graph 0.97 offset 0.5,0 \
	textcolor rgb woe_color font ',9' \
	"Keto\nloss"
set arrow nohead front linewidth 1 linecolor rgb title_color \
	from keto_start_date, graph 1.0 to keto_start_date, keto_start_weight

# -----------------------------------------------------------------------------
# Now actually plot the data
# -----------------------------------------------------------------------------
set style fill transparent solid 0.67 noborder
unset border
# set size ratio -1
#	'i/20100704_mickey_by_espressobuzz-cropped.jpg' \
#		binary filetype=jpg center=(668,412) \
#		 with rgbimage notitle

# [cico_start_date:atkins_start_date]
# ["11/27/2009":"03/05/2012"] file with filledcurves x1 lc rgb "yellow" lw 1
# "<(/usr/local/bin/sed -n '/Weight/,/03\/05\/2012/{//!p}' loseit.csv)" using 1:2 every ::0::521 with filledcurves x1 \

# http://www.workwithcolor.com/hsl-color-picker-01.htm varying luminosity by 5%
# 051EE1 5366FB 374EFB 6A7BFC 808EFC 94A0FD A7B1FD B9C1FE CBD1FE DDE1FE EEF0FF

plot \
	'part_cico.csv' using 1:2 with filledcurves x1 lc rgb "#051EE1" lw 1, \
	'part_atkins.csv' using 1:2 with filledcurves x1 lc rgb "#374EFB" lw 1, \
	'part_lazy.csv' using 1:2 with filledcurves x1 lc rgb "#808EFC" lw 1, \
	'part_keto.csv' using 1:2 with filledcurves x1 lc rgb "#CBD1FE" lw 1, \
	file using 1:2 with lines lc rgb "#004b99" lw 5, \
	file using 1:2:(0.33) with points pointtype 7 lc rgb "red" ps variable