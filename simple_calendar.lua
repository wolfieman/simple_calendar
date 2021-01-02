--[[
    Display to Conky LUA 1.0
    Author : wolfie
    Release date : 19 December 2020
    Tested on : Deepin 20
    Feel free to modity this script.
]]
-- This is a lua script for use in Conky.

require 'cairo'

font = "Mono"
font_size = 12
xpos, ypos = 10, 20
increment = 20
red, green, blue, alpha = 1, 1, 1, 1
font_slant = CAIRO_FONT_SLANT_NORMAL
font_face_normal = CAIRO_FONT_WEIGHT_NORMAL
font_face_bold = CAIRO_FONT_WEIGHT_BOLD

current_year = os.date("%Y")
current_month_spelled = os.date("%B")
current_month_number = os.date("%m") 
first_of_the_month = 1
month_full_dates = ""
week_days_short_names = ""

first_day_of_the_month = os.date("*t", myTimeStamp)

daysOfTheWeekLong = { 
    en = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday" }
}

daysOfTheWeekShort = {
	en = { "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" }
}

function get_month_full_dates (month_table)
	monthly_full = ""
	
	for key, value in pairs( month_table ) do
	    monthly_full = monthly_full .. value .. "  "
	end
	
	return (monthly_full)
end

function get_month_week (i_initial, i_final, j_initial)
	week = ""
	j = j_initial
	for i = i_initial, i_final, 1 do
		if i < first_day_of_the_month.wday then
	    week = week .. "    "
	  else
	  	if j <= 9 then 
	  		week = week .. " " .. j .. "  "
	  	else
	  		week = week .. "" .. j .. "  "
	  	end
	  	j = j + 1
	  end 
	end

	return (week)
end

function get_week_short_names (week)
	short_names = ""
	
	for key, value in pairs( week ) do
	    short_names = short_names .. value .. "  "
	end
	
	return (short_names)
end

week_days_short_names = get_week_short_names(daysOfTheWeekShort.en)

function is_leap_year(year)
    return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

function get_days_in_month (month, year)
    return month == 2 and is_leap_year(year) and 29
           or ("\31\28\31\30\31\30\31\31\30\31\30\31"):byte(month)
end

function conky_main ()

    if conky_window == nil then
        return
    end
    local cairo_surface = cairo_initialize()
    cairo_object = cairo_create (cairo_surface)
    cairo_set_object(cairo_object)

    for i = 1, get_days_in_month(current_month_number, current_year), 1 do
    	j = 1
    	if i == 1 then
    		cairo_move (cairo_object, xpos, ypos, current_month_spelled)
    		cairo_move (cairo_object, xpos, ypos + increment, week_days_short_names)
    		cairo_move (cairo_object, xpos, ypos + (i+1)*increment, get_month_week (i, i+6, j))
        end
    	if i == 8 then
    		j = 3
    		cairo_move (cairo_object, xpos, ypos + (3)*increment, get_month_week (i, i+6, j))
    	end
    	if i == 15 then
    		j = 10
    		cairo_move (cairo_object, xpos, ypos + (4)*increment, get_month_week (i, i+6, j))
    	end
    	if i == 22 then
    		j = 17
    		cairo_move (cairo_object, xpos, ypos + (5)*increment, get_month_week (i, i+6, j))
    	end
    	if i == 29 then
    		j = 24
    		cairo_move (cairo_object, xpos, ypos + (6)*increment, get_month_week (i, i+6, j))
    	end
    	if i == get_days_in_month(current_month_number, current_year) then
    		j = 31
    		cairo_move (cairo_object, xpos, ypos + (7)*increment, get_month_week (36, 36, j))
    	end
    end
    cairo_destroy_all(cairo_object, cairo_surface)
end

function cairo_initialize ()
		cairo_surface = cairo_xlib_surface_create (conky_window.display,
			conky_window.drawable,
			conky_window.visual,
			conky_window.width,
			conky_window.height)
		return cairo_surface
end

function cairo_set_object (cairo_object)
		cairo_select_font_face (cairo_object, font, font_slant, font_face_bold);
		cairo_set_font_size (cairo_object, font_size)
		cairo_set_source_rgba (cairo_object, red, green, blue, alpha)
end

function cairo_move (cairo_object, xpos, ypos, calendar_string)
		cairo_move_to(cairo_object, xpos, ypos)
		cairo_select_font_face (cairo_object, font, font_slant, font_face_normalc);
		cairo_show_text (cairo_object, calendar_string)
end

function cairo_destroy_all (cairo_object, cairo_surface)
		cairo_destroy (cairo_object)
    cairo_surface_destroy (cairo_surface)
    cairo_object = nil
end