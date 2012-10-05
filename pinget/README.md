pinget - Google Play Store PIN Vulnerability
----------------------------------------------

*Vuln Author: zanderman112 && trter10*

*Code Author: compl3x (@Complex360)*

Folder Contents:
----------------------------------------------
pinget.sh - Actual script to pull, extract and parse file to get account and pin

test - Folder with example of parsing account and pin

files - Contains adb binary if you don't aready have it


What's up?
----------------------------------------------

Recently, a worrying vulnerability with the Google Play Store by zanderman112.

Upon entering billing information on a device, you set a pin so that in the event your phone gets stolen, nobody can use your information. Whilst this is a smart security feature, it is totally undermined by how the Play store manages your information.

Credit/Debit card info goes to **Google Servers**

Pin data is instead stored on the **device**

See the problem? Exactly. Whilst a thief would not be able to immediately start buying Adam Sandler movies using your card, data exists on the device which if obtained would allow them to. But this information is encrypted and secured, right?

**Nope.**

Inside the /data/data/com.android.vending/shared_prefs/finsky.xml files, there is a xml value called pin_code, "What on earth could be stored here?" I hear you cry. Well, it's a plaintext copy of your Google Play Store pin.

