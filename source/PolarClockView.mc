using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as AM;

class PolarClockView extends Ui.View {
    
    hidden var EmptyBattery;
    hidden var AlmostEmpty;
    hidden var TwentyFivePercentBattery;
    hidden var FiftyPercentBattery;
    hidden var SeventyFivePercentBattery;
    hidden var AlmostFull;
    hidden var FullBattery;
    
    function initialize(sensor, index) {
        EmptyBattery = Ui.loadResource(Rez.Drawables.EmptyBattery);
        AlmostEmpty = Ui.loadResource(Rez.Drawables.AlmostEmpty);
        TwentyFivePercentBattery = Ui.loadResource(Rez.Drawables.TwentyFivePercentBattery);
        FiftyPercentBattery = Ui.loadResource(Rez.Drawables.FiftyPercentBattery);
        SeventyFivePercentBattery = Ui.loadResource(Rez.Drawables.SeventyFivePercentBattery);
        AlmostFull = Ui.loadResource(Rez.Drawables.AlmostFull);
        FullBattery = Ui.loadResource(Rez.Drawables.FullBattery);
    }
    
    function onLayout(dc) {
    	setLayout(Rez.Layouts.MainLayout(dc));
    }
    
    function onUpdate(dc) {
    	View.onUpdate(dc);
    	
    	var width, height;
    	width = dc.getWidth();
    	height = dc.getHeight();
    	
    	var activityInfo = AM.getInfo();
    	var steps = activityInfo.steps;
		var stepGoal = activityInfo.stepGoal;
		var goalLevel = steps*100/stepGoal;
		goalLevel = goalLevel * Math.PI*2/100;
		dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT);
		drawTrigonometricalMinArc(dc, goalLevel, 102, width/2, height/2);
		
    	var hour, min;
    	var clockTime = Sys.getClockTime();
    	hour = ( ( ( clockTime.hour % 12 ) * 60 ));
        hour = hour / (12 * 60.0);
        hour = hour * Math.PI * 2;
        min = ( clockTime.min / 60.0) * Math.PI * 2;
        dc.setColor(Gfx.COLOR_PURPLE, Gfx.COLOR_TRANSPARENT);
        drawTrigonometricalMinArc(dc, min, 87, width/2, height/2);
        dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
        drawTrigonometricalMinArc(dc, hour, 72, width/2, height/2);
        
        var noOfDaysInMonth = { "Jan" => 31, "Feb" => 28, "Mar" => 31, "Apr" => 30, "May" => 31, "Jun" => 30, "Jul" => 31, "Aug" => 31, "Sep" => 30, "Oct" => 31, "Nov" => 30, "Dec" => 31};
        var noOfMonth = { "Jan" => 1, "Feb" => 2, "Mar" => 3, "Apr" => 4, "May" => 5, "Jun" => 6, "Jul" => 7, "Aug" => 8, "Sep" => 9, "Oct" => 10, "Nov" => 11, "Dec" => 12};
        var noOfDayInWeek = {"Mon" => 1, "Tue" => 2, "Wed" => 3, "Thu" => 4, "Fri" => 5, "Sat" => 6, "Sun" => 7};
        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        var day = info.day;
        var month = info.month;
        var dayOfWeek = info.day_of_week;
        var year = info.year;
        day = day.toNumber();
        var dayOfMonthLevel = day*100/noOfDaysInMonth[info.month];
        if((year % 4 == 0) and (year % 100 != 0) or (year % 400 == 0)) {
        	if(info.month == "Feb") {
        		dayOfMonthLevel = day*100/29;
        	}
        }
        dayOfMonthLevel = dayOfMonthLevel * Math.PI*2/100;
        dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
        drawTrigonometricalMinArc(dc, dayOfMonthLevel, 57, width/2, height/2);
        var monthLevel = noOfMonth[info.month]*100/12;
        monthLevel = monthLevel * Math.PI*2/100;
        dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        drawTrigonometricalMinArc(dc, monthLevel, 42, width/2, height/2);
        var dayLevel = noOfDayInWeek[info.day_of_week]*100/7;
        dayLevel = dayLevel*Math.PI*2/100;
        dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
        drawTrigonometricalMinArc(dc, dayLevel, 27, width/2, height/2);
        
        var systemStats = Sys.getSystemStats();
        var batteryLevel = systemStats.battery;
		
		if (batteryLevel >= 1.0 and batteryLevel < 5.0) {
			dc.drawBitmap(width/2-9, height/2-10, EmptyBattery);
		} else if(batteryLevel >= 5.0 and batteryLevel < 14.0) {
			dc.drawBitmap(width/2-9, height/2-10, AlmostEmpty);
		} else if (batteryLevel >= 14.0 and batteryLevel < 28.0) {
			dc.drawBitmap(width/2-9, height/2-10, TwentyFivePercentBattery);
		} else if (batteryLevel >= 28.0 and batteryLevel < 42.0) {
			dc.drawBitmap(width/2-9, height/2-10, TwentyFivePercentBattery);
		} else if (batteryLevel >= 42.0 and batteryLevel < 56.0) {
			dc.drawBitmap(width/2-9, height/2-10, FiftyPercentBattery);
		} else if (batteryLevel >= 56.0 and batteryLevel < 70.0) {
			dc.drawBitmap(width/2-9, height/2-10, FiftyPercentBattery);
		} else if (batteryLevel >= 70.0 and batteryLevel < 84.0) {
			dc.drawBitmap(width/2-9, height/2-10, SeventyFivePercentBattery);
		} else if (batteryLevel >= 84.0 and batteryLevel < 98.0) {
			dc.drawBitmap(width/2-9, height/2-10, AlmostFull);
		} else if(batteryLevel >= 98.0) {
			dc.drawBitmap(width/2-9, height/2-10, FullBattery);
		}
     
    }
    
    function drawTrigonometricalMinArc(dc, min, radius, centerX, centerY) {
    	var angle;
    	for (angle = 0; angle <= min; angle = angle + Math.PI/72) {
			var x = radius * Math.cos(angle-1.6) + centerX;
	        var y = radius * Math.sin(angle-1.6) + centerY;
	        dc.fillCircle(x, y, 7);
		}
    }
}