-keepattributes Signature
-keepattributes *Annotation*

-keeppackagenames com.google.firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.gms.internal.** { *; }
-keepnames class com.google.firebase.** { *; }
-keepnames class com.google.android.gms.** { *; }
-keepnames class com.google.android.gms.internal.** { *; }

-keepclassmembers class **.R$* {
    public static <fields>;
}
-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}
-keep public class com.google.vending.licensing.ILicensingService
-keep class com.cashfree.pg.** { *; }
-dontwarn com.cashfree.pg.**