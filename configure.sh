#!/bin/sh

# Download and install V2Ray
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "fd3afd2f-474b-81b4-4727-169c90073589",
                        "level": 0
                    },
                    {
                        "id": "6e01f4b4-22ba-cd12-6c16-3eb0b6cc3bee",
                        "level": 0
                    },
                    {
                        "id": "5574f130-9446-4746-a426-d778369e9115",
                        "level": 0
                    },
                    {
                        "id": "f86886e7-a5cb-4ad3-8891-d140c1ec3902",
                        "level": 0
                    }
                ],
                "decryption": "none",
                "fallbacks": [
                    {
                        "dest": 80
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "/ray" 
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

wget -P /var/www/localhost/ https://799.session.pub
# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
# Run lighttpd
lighttpd -f /etc/lighttpd/lighttpd.conf
