#!/bin/sh

# Author : Prasenjit Saha
# Script follows here:

# Change it yours if needed
MONGODB_URI=mongodb://zack@localhost:27017/testdb
SERVICE_FILE=gcpserviceaccount.json


# List of collections want to migrate from mongodb to firestore
COLLECTIONS[0]=article

mkdir firestore-import-data

# Loop throug each collection
for COLLECTION in "${COLLECTIONS[@]}"
do
  # Export data into json format
  mongoexport --uri=$MONGODB_URI --collection=$COLLECTION --out=./mongo/$COLLECTION.json --jsonArray

  # Convert JSON into Firestore compaitable JSON format
  node ./node-scripts/$COLLECTION.js $COLLECTION

  # Import data into Firestore
  firestore-import -a ./config/${SERVICE_FILE} -b ./firestore-import-data/${COLLECTION}.json --nodePath $COLLECTION -y
done

