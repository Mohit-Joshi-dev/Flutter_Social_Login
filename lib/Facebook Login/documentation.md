Android 
This assumes that you've done the "Associate Your Package Name and Default Class with Your App" and "Provide the Development and Release Key Hashes for Your App" in the the Facebook Login documentation for Android site.
// https://developers.facebook.com/docs/facebook-login/android


After you've done that, find out what your Facebook App ID is. You can find your Facebook App ID in your Facebook App's dashboard in the Facebook developer console.

Once you have the Facebook App ID figured out, youll have to do two things.

First, copy-paste the following to your strings resource file. If you don't have one, just create it.

<your project root>/android/app/src/main/res/values/strings.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Your App Name here.</string>

    <!-- Replace "000000000000" with your Facebook App ID here. -->
    <string name="facebook_app_id">000000000000</string>

    <!--
      Replace "000000000000" with your Facebook App ID here.
      **NOTE**: The scheme needs to start with `fb` and then your ID.
    -->
    <string name="fb_login_protocol_scheme">fb000000000000</string>
</resources>
Then you'll just have to copy-paste the following to your Android Manifest:

<your project root>/android/app/src/main/AndroidManifest.xml

<meta-data android:name="com.facebook.sdk.ApplicationId"
    android:value="@string/facebook_app_id"/>

<activity android:name="com.facebook.FacebookActivity"
    android:configChanges=
            "keyboard|keyboardHidden|screenLayout|screenSize|orientation"
    android:label="@string/app_name" />

<activity
    android:name="com.facebook.CustomTabActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="@string/fb_login_protocol_scheme" />
    </intent-filter>
</activity>