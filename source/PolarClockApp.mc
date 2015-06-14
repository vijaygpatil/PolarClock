using Toybox.Application as App;

class PolarClockApp extends App.AppBase {
    function getInitialView() {
        return [ new PolarClockView() ];
    }
}