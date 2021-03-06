package com.shoutem.calendar;

import android.content.Intent;
import android.provider.CalendarContract;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

public class CalendarManagerModule extends ReactContextBaseJavaModule {
    public CalendarManagerModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "CalendarManager";
    }

    @ReactMethod
    public void addEvent(ReadableMap details) {
        String name = details.getString("name");
        String location = details.getString("location");
        // Double is used since int is not big enough to fit all values of a JavaScript Number
        Double startTime = details.getDouble("startTime"); // millis since Unix epoch
        Double endTime = details.getDouble("endTime"); // millis since Unix epoch

        Intent intent = new Intent(Intent.ACTION_INSERT)
                .setData(CalendarContract.Events.CONTENT_URI)
                .putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.longValue())
                .putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.longValue())
                .putExtra(CalendarContract.Events.TITLE, name)
                .putExtra(CalendarContract.Events.EVENT_LOCATION, location);

        getCurrentActivity().startActivity(intent);
    }
}
