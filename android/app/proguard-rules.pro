-ignorewarnings
-keepattributes *Annotation*,EnclosingMethod,Signature

-dontwarn co.hyperverge.**
-keepclassmembers class * implements javax.net.ssl.SSLSocketFactory {
	private javax.net.ssl.SSLSocketFactory delegate;
}

-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}

-keep class com.amazon.** { *; }
-keep class com.amazonaws.** { *; }
-keep class com.amplifyframework.** { *; }


-keepclassmembers class * {   @android.webkit.JavascriptInterface <methods>;}
-keepattributes JavascriptInterface
-keepattributes *Annotation*