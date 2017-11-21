using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class MyZoneWorkoutView extends Ui.DataField {

    hidden var mValue;
    hidden var currentHr;
    hidden var hrzone;
    hidden var zone0;
    hidden var zone1;
    hidden var zone2;
    hidden var zone3;
    hidden var zone4;
    hidden var zone5;
    hidden var meps;
    var bars;

    function initialize() {
        DataField.initialize();
        mValue = 0.0f;
        meps = 0;
        zone0 = 0;
        zone1 = 0;
        zone2 = 0;
        zone3 = 0;
        zone4 = 0;
        zone5 = 0;
        hrzone = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) {
        var obscurityFlags = DataField.getObscurityFlags();

        View.setLayout(Rez.Layouts.MainLayout(dc));
        var labelView = View.findDrawableById("label");
        labelView.locY = labelView.locY - 40;
        var valueView = View.findDrawableById("value");
        valueView.locY = valueView.locY;

        View.findDrawableById("label").setText(Rez.Strings.label);
        View.findDrawableById("heartrate").setText(Rez.Strings.heartrate);
        
        
        
        return true;
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        //every second, check the hr zone and increase timer
        updatehrZoneTimeAndMeps(info);
        //recalculate meps
        calculateMeps();
        mValue = meps;
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        // Set the foreground color and value
        var value = View.findDrawableById("value");
        var label = View.findDrawableById("label");
        var heartrate = View.findDrawableById("heartrate");
        var hrvalue = View.findDrawableById("hrvalue");
        var boxSize;
        
        value.setColor(Gfx.COLOR_WHITE);
        label.setColor(Gfx.COLOR_WHITE);
        heartrate.setColor(Gfx.COLOR_WHITE);
        hrvalue.setColor(getHrColor(currentHr));
        value.setText(mValue.format("%.0f"));
        hrvalue.setText(currentHr.format("%.0f"));
        
        
        // draw hr and meps
        View.onUpdate(dc);
        
        //draw big boxes
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLUE);
        dc.drawRectangle(18,60,45,80);
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);
        dc.drawRectangle(64,60,45,80);
        dc.setColor(0xfff200, 0xfff200);
        dc.drawRectangle(110,60,45,80);
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);
        dc.drawRectangle(156,60,45,80);
        
		//fill in big boxes
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLUE);
        boxSize = getBoxSize(zone2);
        dc.fillRectangle(18,boxSize[0],45,boxSize[1]);
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);
        boxSize = getBoxSize(zone3);
        dc.fillRectangle(64,boxSize[0],45,boxSize[1]);
        dc.setColor(0xfff200, 0xfff200);
        boxSize = getBoxSize(zone4);
        dc.fillRectangle(110,boxSize[0],45,boxSize[1]);
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);
        boxSize = getBoxSize(zone5);
        dc.fillRectangle(156,boxSize[0],45,boxSize[1]);
        
        //clean up small boxes
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLUE);
        dc.fillRectangle(18,141,45,24);
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);
        dc.fillRectangle(64,141,45,24);
        dc.setColor(0xfff200, 0xfff200);
        dc.fillRectangle(110,141,45,24);
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);
        dc.fillRectangle(156,141,45,24);  
        
        //add numbers to small boxes
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLUE);
        dc.drawText(40, 140, Graphics.FONT_SYSTEM_XTINY, minutesInZone(zone2), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_GREEN);
        dc.drawText(87, 140, Graphics.FONT_SYSTEM_XTINY, minutesInZone(zone3), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Gfx.COLOR_BLACK, 0xfff200);
        dc.drawText(134, 140, Graphics.FONT_SYSTEM_XTINY, minutesInZone(zone4), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_RED);
        dc.drawText(180, 140, Graphics.FONT_SYSTEM_XTINY, minutesInZone(zone5), Graphics.TEXT_JUSTIFY_CENTER);
        
		
    }

	function updatehrZoneTimeAndMeps(info) {
		if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
            	currentHr = info.currentHeartRate; 
                if (info.currentHeartRate > hrzone[4]) {
                	zone5++;
                } else if (info.currentHeartRate > hrzone[3]) {
                	zone4++;
                } else if (info.currentHeartRate > hrzone[2]) {
                	zone3++;
                } else if (info.currentHeartRate > hrzone[1]) {
					zone2++;
                } else if (info.currentHeartRate > hrzone[0]) {
                	zone1++;
                } else {
                	zone0++;
                }
            } else {
                currentHr = 0;
            }
        }
	}
	
	function calculateMeps() {
		meps = ((zone5/60)*4) + ((zone4/60)*4) + ((zone3/60)*3) + ((zone2/60)*2);
	}
	
	function minutesInZone(seconds) {
		var numSec;
		var remainingSec;
		var minutes;
				
		if ( seconds > 0 ) {
			numSec = seconds % 60;
			remainingSec = seconds - numSec;
			
			if ( remainingSec > 0 ) {
				minutes = remainingSec/60;
			} else {
				minutes = 0;
			}
		} else {
			remainingSec = 0;
			numSec = 0;
			minutes = 0;
		}
		
		return minutes;
	}
	
	function getBoxSize(secondsInZone) {	//starts at 60, for 80px box
		var totalSeconds = zone2+zone3+zone4+zone5;
		var percentageOfBox = 0.0d;
		var returnSize = new[2];
		var size = 0.0d;
		var difference = 0.0d;
		
		if ( totalSeconds > 0 ) {
			percentageOfBox = secondsInZone.toDouble()/totalSeconds.toDouble();
		}
		
		size = percentageOfBox * 80.0;  //overall box size is 80
		difference = 80 - size;
		
		//System.println(secondsInZone.toString() + " " + totalSeconds.toString() + " " + percentageOfBox.toString() + " " + size.toString() + " " + difference); 
		
		returnSize[0] = 60 + difference;
		returnSize[1] = 80 - difference;

		return returnSize;
	}
	
	function getHrColor(value) {
		if (value > hrzone[4]) {
			return Gfx.COLOR_RED;
		} else if (value > hrzone[3]) {
			return 0xfff200;
		} else if (value > hrzone[2]) {
			return Gfx.COLOR_GREEN;
		} else if (value > hrzone[1]) {
			return Gfx.COLOR_BLUE;
		} else if (value > hrzone[0]) {
			return Gfx.COLOR_DK_GRAY;
		} else {
			return Gfx.COLOR_LT_GRAY;
		}

	}
}
