#!/bin/sh
##################
# Sebastien Caps #
# Guardis 2013   #
##################
if [ "$2" == "" ]; then
        echo "SSL chain validity verification"
        echo "Usage:"
        echo " ./ssl_verify.sh <hostname> <port> [<start tls protocol>]"
        echo " ./ssl_verify.sh my.comodit.com 443"
        echo " ./ssl_verify.sh my.comodit.com 143 imap"
        exit 255
fi
tlsproto=""
[ "$3" != "" ] && tlsproto="-starttls $3"

# Download latest available cacerts
wget -q 'http://curl.haxx.se/ca/cacert.pem' -O /tmp/cacert.pem

RESULT_LOG=`echo -e "^]\n\nQuit\n\nQUIT" | openssl s_client -connect $1:$2 $tlsproto -CAfile /tmp/cacert.pem 2> /dev/null | grep 'Verify return code:'`
RESULT=`echo $?`

if [ "$RESULT" == "0" ]; then
        echo "OK: $RESULT_LOG"
else
        echo "Error SSL Verify return code=$RESULT - $RESULT_LOG"
        exit 2
fi

# EOF
