FROM teddysun/xray:latest

# Переписываем дефолтный конфиг под WebSocket + TLS (порт 8080 для Render)
RUN echo '{\
  "inbounds": [{\
    "port": 8080,\
    "protocol": "vless",\
    "settings": {\
      "clients": [{\
        "id": "$UUID"\
      }],\
      "decryption": "none"\
    },\
    "streamSettings": {\
      "network": "ws",\
      "wsSettings": {\
        "path": "/vless"\
      }\
    }\
  }],\
  "outbounds": [{\
    "protocol": "freedom"\
  }]\
}' > /etc/xray/config.json

# Подставляем реальный UUID из переменных окружения перед запуском
CMD sed -i "s/\$UUID/$UUID/g" /etc/xray/config.json && xray -config /etc/xray/config.json
