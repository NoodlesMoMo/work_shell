#!/bin/bash

ding_url="https://oapi.dingtalk.com/robot/send?access_token=c6ecc4afe15d1e2e4bcb807531f22bdf07dae047bfc12f7ad55964a635d65b77"
header='Content-Type: application/json'

message='
{
    "msgtype": "text",
    "text":{
        "content": "AAAAAAA"
    },
    "at": {
        "isAtAll": "true"
    }
}'

content='"## Ding Debug\n"
### 142.56.89 -- 192.168.1.4\n\n
**this is bold**\n\n
*this is italic*\n\n"
'
read ttt <<-EOF
    AAAAAA
    BBBBBB
    CCCCCC
EOF

echo $ttt

msg='
{
    "msgtype": "markdown",
    "markdown": {
        "title": "service healthy warning",
        "text": '$content'
    },
    "at": {
        "isAtAll": "true"
    }
}'


function ding_notify()
{
    curl $ding_url -H "$header" -d "$msg"
}

set -x
ding_notify
set +x
