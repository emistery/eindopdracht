#!/bin/sh
#Made by Emiel Kok
#Arg 1 is client hostname, Arg 2 is client IP
cat <<EOT >> /usr/local/nagios/etc/servers/$1.cfg
define host {
        use                             linux-server
        host_name                       $1
        alias                           My client server
        address                         $2
        max_check_attempts              5
        check_period                    24x7
        notification_interval           30
        notification_period             24x7
}
EOT

