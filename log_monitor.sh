#!/bin/bash

ding_url='https://oapi.dingtalk.com/robot/send?access_token=dda52e610d3686970db9fada34405afb67e2eada0a64d439337ed84900394d79'

log_name=`date +/data01/newlogs/%Y-%m/%d/error/%H.log`
threshold=$((1024*1024*100))        # 100 MB
sleep_time=$((60*10))               # 10 Minutes
reboot_threshold=$((1024*1024*20))  # 20 MB

function monitor_forever()
{
    while true
    do
	log_name=`date +/data01/newlogs/%Y-%m/%d/error/%H.log`
        if [ -e $log_name ]
        then
            file_size=`ls -l $log_name | awk '{ print $5 }'`

            if [ $file_size -gt $threshold ]
            then
                ding_notify
            fi
            sleep $sleep_time 
            
            curr_size=`ls -l $log_name | awk '{ print $5 }'`
            if [ $(($curr_size-$file_size)) -gt $reboot_threshold ]; then
                supervisorctl -c /etc/supervisord.conf restart  solo_launcher8000
            fi
        fi
    done
}

function ding_notify()
{
    private_ip=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"]`
    public_ip=`curl -s v4.ident.me`
    file_info=`ls -lh $log_name|awk '{printf("%s size:  %s\n", $9, $5)}'`
    host_ip="server ip: $public_ip <--> $private_ip"
    txt="$host_ip $file_info" 
    message='{"msgtype": "text", "text": { "content": "'$txt'"}}'
    
    curl -s $ding_url -H 'Content-Type: application/json' \
        -d "$message" >> /dev/null
}

monitor_forever
