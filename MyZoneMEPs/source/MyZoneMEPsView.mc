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

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 40;
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY;
        }

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
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        // Set the foreground color and value
        var value = View.findDrawableById("value");
        var label = View.findDrawableById("label");
        value.setColor(Gfx.COLOR_WHITE);
        label.setColor(Gfx.COLOR_WHITE);
        value.setText(mValue.format("%.0f"));
        
        
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
}
