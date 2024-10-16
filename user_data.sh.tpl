#!/bin/bash
yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF> /var/www/html/index.html
<html>
<body bgcolor="magenta">
<h2>WebServer with IP: <font color="red">$myip</font></h2><br>
</body>
</html>
EOF

sudo service httpd start
chkconfig httpd on

# Owner ${f_name} ${l_name} <br> 
# %{ for x in names ~}
# Hello to ${x} from ${f_name}<br>
# %{ endfor ~}