using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as AM;

class PolarClockView extends Ui.View {
    
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
		var level = steps*100/stepGoal;
		level = level * Math.PI*2/100;
		drawTrigonometricalMinArc(dc, level, 101, width/2, height/2);
		
    	var hour, min;
    	var clockTime = Sys.getClockTime();
    	hour = ( ( ( clockTime.hour % 12 ) * 60 ));
        hour = hour / (12 * 60.0);
        hour = hour * Math.PI * 2;
        min = ( clockTime.min / 60.0) * Math.PI * 2;
        drawTrigonometricalHourArc(dc, hour, 84, width/2, height/2);
        drawTrigonometricalMinArc(dc, min, 67, width/2, height/2);
        
        
        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);
        
        
        
    	dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_BLACK);
        dc.fillCircle(width/2, height/2, 7);
        dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
        dc.drawCircle(width/2, height/2, 7);
    }
    
    function drawTrigonometricalHourArc(dc, hour, radius, centerX, centerY) {
    	var angle;
		dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
    	for (angle = 0; angle <= hour; angle = angle + Math.PI/100) {
			var x = radius * Math.cos(angle-1.6) + centerX;
	        var y = radius * Math.sin(angle-1.6) + centerY;
	        dc.fillCircle(x, y, 5);
		}
    }
    
    function drawTrigonometricalMinArc(dc, min, radius, centerX, centerY) {
    	var angle;
		dc.setColor(Gfx.COLOR_PURPLE, Gfx.COLOR_TRANSPARENT);
    	for (angle = 0; angle <= min; angle = angle + Math.PI/100) {
			var x = radius * Math.cos(angle-1.6) + centerX;
	        var y = radius * Math.sin(angle-1.6) + centerY;
	        dc.fillCircle(x, y, 5);
		}
    }
}