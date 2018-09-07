#!/bin/sh
#
# ike-scan-trans
#
# Generates transforms for ike-scan (--trans)
# Robert Gilbert - amroot.com
# 
# Loop modified from: http://www.nta-monitor.com/wiki/index.php/Ike-scan_User_Guide
#

# Encryption algorithms: DES, Triple-DES, AES/128, AES/192 and AES/256
ENCLIST="1 5 7/128 7/192 7/256"
# Hash algorithms: MD5 and SHA1
HASHLIST="1 2"
# Authentication methods: Pre-Shared Key, RSA Signatures, Hybrid Mode and XAUTH
AUTHLIST="1 3 64221 65001"
# Diffie-Hellman groups: 1, 2 and 5
GROUPLIST="1 2 5"

if [ "$1" = "" ]; then
	echo "Usage: $0 IP ID (Cisco)"
	exit
fi

if [ "$2" = "" ]; then
	id="Cisco"
else
	id=$2
fi

for ENC in $ENCLIST; do
    for HASH in $HASHLIST; do
        for AUTH in $AUTHLIST; do
            for GROUP in $GROUPLIST; do
                if ike-scan $1 -A -M --id=$id -P$1.key --trans=$ENC,$HASH,$AUTH,$GROUP | grep '1 returned handshake'
                then echo "Found using: ike-scan $1 -A -M --id=$id -P$1.key --trans=$ENC,$HASH,$AUTH,$GROUP";
                    echo "Saved to: $1.key";
                    exit
                fi 
            done
        done
    done
done

