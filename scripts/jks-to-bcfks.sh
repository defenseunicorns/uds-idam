#!/bin/sh
#

SRCSTOREPASS=password
DSTSTOREPASS='sup3r-secret-p@ssword'

# Check the number of arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <JKS File> <BCFKS File>"
    exit 1
fi

# Assign the arguments to variables
JKS_FILE="$1"
BCFKS_FILE="$2"

# Check if arg1 is a valid input file
if [ ! -f "$JKS_FILE" ]; then
    echo "Error: Argument 1 is not a valid input file"
    exit 1
fi

keytool -importkeystore -srckeystore ${JKS_FILE}  -srcstoretype jks -srcstorepass ${SRCSTOREPASS} -destkeystore ${BCFKS_FILE} -deststorepass ${DSTSTOREPASS} -deststoretype bcfks -providerclass org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider -providerpath ../providers/bc-fips-1.0.2.3.jar
