TEAM_ID="2V2W2494TP"
TOKEN_KEY_FILE_NAME="/Users/morgan.lee/Desktop/文件/推播範例/AuthKey_965T6JG9YY.P8"
AUTH_KEY_ID="965T6JG9YY"

APNS_HOST_NAME="api.sandbox.push.apple.com"
#APNS_HOST_NAME="api.push.apple.com"

TOPIC="tw.com.mitake.touchstock.mtk.test"
DEVICE_TOKEN="e0923d613c4f474576dd1d8e25c732c16787b91578f3f569f0cd6f7ad6ba002d"

TOPIC_DYNAMIC_ISLAND="tw.com.mitake.touchstock.mtk.test.push-type.liveactivity"
DEVICE_TOKEN_DYNAMIC_ISLAND_START="80da5e5989a335637d4ecf25d36a3f6d16d28351aafe3b87814ba19f4505b180f5366d604b433ab94bfabfd07f5d911cd2b1006e97f0a9c1a42b513b4596daf18b1a3f598ab80e43bb2612df57db10bd424108f67f7195971898938c40329782169679512594b87fa33bed425cb9cec06b09b0fdb8a9748fd7f669b1b408f1b0"
DEVICE_TOKEN_DYNAMIC_ISLAND="809097ce1b7156391aaae626e714d60127bbdb3a9e669f4e32ada74426ab6eb19552929986feffe7adc75ae03468280a42823d9097e1c531b5ece7e3ad0531c09aa9e87ea200b5fbb70fcbb7d2c6498cd5b302821e11c3664817d54618541aeb00fc703a025040758d692f655bdb030afabfcf47e4998fdf83cf5528e71670ad"

JWT_ISSUE_TIME=$(date +%s)
JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"
JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

# alert
curl -v --header "apns-topic: $TOPIC" --header "apns-push-type: alert" --header "authorization: bearer $AUTHENTICATION_TOKEN" --data '{"aps":{"alert":"<a href=\"#2303\">#2303</a> LINE","badge":1,"sound":"default","mutable-content":1,"r":"20000500300000012","rt":"2","f":"0","s":"110006976","w":"ggggggggg","t":"0","d":"20220207185045","c":"幹","msgtype":"I"},"msgid":"3205805000028313032","msgtype":"IM"}' --http2 https://${APNS_HOST_NAME}/3/device/${DEVICE_TOKEN}

# dynamic island update
#curl -v --header "apns-topic: $TOPIC_DYNAMIC_ISLAND" --header "apns-push-type: liveactivity" --header "apns-priority: 10" --header "authorization: bearer $AUTHENTICATION_TOKEN" --data '{"aps":{"timestamp":'$JWT_ISSUE_TIME',"event":"update","content-state":{},"alert":{"title":"MTK Dynamic Island Update","body":""}}}' --http2 https://${APNS_HOST_NAME}/3/device/${DEVICE_TOKEN_DYNAMIC_ISLAND}

# dynamic island end
#curl -v --header "apns-topic: $TOPIC_DYNAMIC_ISLAND" --header "apns-push-type: liveactivity" --header "apns-priority: 10" --header "authorization: bearer $AUTHENTICATION_TOKEN" --data '{"aps":{"timestamp":'$JWT_ISSUE_TIME',"event":"end","dismissal-date":'$JWT_ISSUE_TIME',"content-state":{}}}' --http2 https://${APNS_HOST_NAME}/3/device/${DEVICE_TOKEN_DYNAMIC_ISLAND}

# dynamic island start
#curl -v --header "apns-topic: $TOPIC_DYNAMIC_ISLAND" --header "apns-push-type: liveactivity" --header "apns-priority: 10" --header "authorization: bearer $AUTHENTICATION_TOKEN" --data '{"aps":{"timestamp":'$JWT_ISSUE_TIME',"event":"start","content-state":{},"attributes-type":"StockActivityAttributes","attributes":{},"alert":{"title":"MTK Dynamic Island Start","body":""}}}' --http2 https://${APNS_HOST_NAME}/3/device/${DEVICE_TOKEN_DYNAMIC_ISLAND_START}
