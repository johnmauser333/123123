#!/bin/sh

# Download and install V2Ray
mkdir /tmp/v2ray
wget -q https://github.com/v2fly/v2ray-core/releases/download/v5.0.3/v2ray-linux-64.zip -O /tmp/v2ray/v2ray.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
  "reverse": {
    "portals": [
      {
        "tag": "portal",
        "domain": "playstation33333.herokuapp.com"
      }
    ]
  },
  "inbounds": [
    {
      "tag": "tunnel",
      "port": $PORT,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
      "network": "ws"
     }
    }
  ],

  "outbounds": [{
  "tag": "crossfire",
  "protocol": "freedom",
  "settings": {}
  }],

  "routing": {
    "rules": [
      {
        "type": "field",
        "inboundTag": ["external"],
        "outboundTag": "portal"
      },
      {
        "type": "field",
        "inboundTag": ["tunnel"],
        "domain": ["full:playstation33333.herokuapp.com"],
        "outboundTag": "portal"
      }
    ]
  }
}
EOF

# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
