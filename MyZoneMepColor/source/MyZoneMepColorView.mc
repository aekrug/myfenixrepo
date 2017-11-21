using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class MyZoneMepColorView extends Ui.DataField {

    hidden var mValue;
    hidden var meps;
    hidden var zone0;
    hidden var zone1;
    hidden var zone2;
    hidden var zone3;
    hidden var zone4;
    hidden var zone5;
    hidden var hrzone;
    hidden var hrmax;
    hidden var currentHR;

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
        hrmax = hrzone[5];
        currentHR = 0;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) {

        View.setLayout(Rez.Layouts.MainLayout(dc));
        var labelView = View.findDrawableById("label");
        labelView.locY = labelView.locY - 16;
        var valueView = View.findDrawableById("value");
        valueView.locY = valueView.locY + 7;


        View.findDrawableById("label").setText(Rez.Strings.label);
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
        currentHR = getHR(info);
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        // Set the background color
        View.findDrawableById("Background").setColor(Gfx.COLOR_WHITE);
        View.onUpdate(dc);
        
        //Get colors
    	var colors = getHrColor(currentHR);
        
        //Draw HR bubble
        dc.setColor(colors[1], colors[1]);
        dc.fillCircle(70, 60, 70);
        
        dc.setColor(colors[0], colors[1]);
        dc.drawText(70, 25, Gfx.FONT_SMALL, "HR", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(70, 50, Gfx.FONT_NUMBER_THAI_HOT, currentHR.format("%.0f"), Gfx.TEXT_JUSTIFY_CENTER);
        
        
        //Draw HR percent bubble
        dc.setColor(colors[1], colors[1]);
        dc.fillCircle(180, 120, 45);
        
        dc.setColor(colors[0], colors[1]);
        dc.drawText(180, 85, Gfx.FONT_SMALL, "HR%", Gfx.TEXT_JUSTIFY_CENTER);
        var hrper = gethrper(currentHR);
        dc.drawText(180, 110, Gfx.FONT_NUMBER_MEDIUM, hrper.format("%.0f").toString() + "%", Gfx.TEXT_JUSTIFY_CENTER);
        
        //Draw MEP bubble
        dc.setColor(colors[1], colors[1]);
        dc.fillCircle(80, 185, 45);
        
        dc.setColor(colors[0], colors[1]);
        dc.drawText(80, 147, Gfx.FONT_SMALL, "MEPs", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(80, 172, Gfx.FONT_NUMBER_MEDIUM, meps.format("%.0f"), Gfx.TEXT_JUSTIFY_CENTER);


    }

	function updatehrZoneTimeAndMeps(info) {
		if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
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
                //do nothing
            }
        }
	}

	function calculateMeps() {
		meps = ((zone5/60)*4) + ((zone4/60)*4) + ((zone3/60)*3) + ((zone2/60)*2);
	}
	
	function getHR(info) {
		var currentHr = 0;
		
		if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
            	currentHr = info.currentHeartRate; 
            } else {
                currentHr = 0;
            }
        }
        
        return currentHr;
	}
	
	function getHrColor(value) {
		var colors = new[2];
		
		if (value > hrzone[4]) {
			colors[0] = Gfx.COLOR_WHITE;
			colors[1] = Gfx.COLOR_RED;
		} else if (value > hrzone[3]) {
			colors[0] = Gfx.COLOR_BLACK;
			colors[1] = 0xfff200;
		} else if (value > hrzone[2]) {
			colors[0] = Gfx.COLOR_BLACK;
			colors[1] = Gfx.COLOR_GREEN;
		} else if (value > hrzone[1]) {
			colors[0] = Gfx.COLOR_BLACK;
			colors[1] = Gfx.COLOR_BLUE;
		} else if (value > hrzone[0]) {
			colors[0] = Gfx.COLOR_BLACK;
			colors[1] = Gfx.COLOR_DK_GRAY;
		} else {
			colors[0] = Gfx.COLOR_BLACK;
			colors[1] = Gfx.COLOR_LT_GRAY;
		}
		
		
		return colors;
	}
	
	function gethrper(current) {
		var percent = 1;
		if (hrmax != 0) {
			percent = current.toDouble()/hrmax.toDouble();
		}
					
		return percent * 100.0;
	}
}
