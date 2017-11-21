using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.UserProfile;


class MyZoneMEPsView extends Ui.DataField {

    hidden var mValue;
    hidden var hrzone;
    hidden var zone0;
    hidden var zone1;
    hidden var zone2;
    hidden var zone3;
    hidden var zone4;
    hidden var zone5;
    hidden var meps;
    hidden var currentHR;
    hidden var hrmax;

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
        var meplabelView = View.findDrawableById("meplabel");
        meplabelView.locY = meplabelView.locY - 40;
        var mepvalueView = View.findDrawableById("mepvalue");
        mepvalueView.locY = mepvalueView.locY;


        View.findDrawableById("meplabel").setText(Rez.Strings.meplabel);
        View.findDrawableById("hrlabel").setText(Rez.Strings.hrlabel);
        View.findDrawableById("hrperlabel").setText(Rez.Strings.hrperlabel);
        
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
    	//Get colors
    	var colors = getHrColor(currentHR);
    	
    	// Set the background color
    	View.findDrawableById("Background").setColor(colors[0]);
    	
    	
    	
        // Set the foreground color and value
        var mepvalue = View.findDrawableById("mepvalue");
        var meplabel = View.findDrawableById("meplabel");
        mepvalue.setColor(colors[1]);
        meplabel.setColor(colors[1]);
        mepvalue.setText(mValue.format("%.0f"));
        
        var hrvalue = View.findDrawableById("hrvalue");
        var hrlabel = View.findDrawableById("hrlabel");
        hrvalue.setColor(colors[1]);
        hrlabel.setColor(colors[1]);
        hrvalue.setText(currentHR.format("%.0f"));
        
        var hrpervalue = View.findDrawableById("hrpervalue");
        var hrperlabel = View.findDrawableById("hrperlabel");
        hrpervalue.setColor(colors[1]);
        hrperlabel.setColor(colors[1]);
        var hrper = gethrper(currentHR);
        hrpervalue.setText(hrper.format("%.0f").toString() + "%");
       
        
        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);

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
			colors[0] = Gfx.COLOR_RED;
			colors[1] = Gfx.COLOR_WHITE;
		} else if (value > hrzone[3]) {
			colors[0] = 0xfff200;
			colors[1] = Gfx.COLOR_BLACK;
		} else if (value > hrzone[2]) {
			colors[0] = Gfx.COLOR_BLACK;
			colors[1] = Gfx.COLOR_GREEN;
		} else if (value > hrzone[1]) {
			colors[0] = Gfx.COLOR_BLACK;
			colors[1] = Gfx.COLOR_BLUE;
		} else if (value > hrzone[0]) {
			colors[0] = Gfx.COLOR_DK_GRAY;
			colors[1] = Gfx.COLOR_BLACK;
		} else {
			colors[0] = Gfx.COLOR_DK_GRAY;
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
