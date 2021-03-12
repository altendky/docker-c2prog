#!/usr/bin/bash

# https://stackoverflow.com/questions/35821245/github-server-certificate-verification-failed/63299750#63299750

# Bash "strict mode", to help catch problems and bugs in the shell
# script. Every bash script you write should include this. See
# http://redsymbol.net/articles/unofficial-bash-strict-mode/ for
# details.
set -euo pipefail

openssl s_client -showcerts -servername github.com -connect github.com:443 </dev/null 2>/dev/null | sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p'  > github-com.pem
cat github-com.pem | sudo tee -a /etc/ssl/certs/ca-certificates.crt
rm github-com.pem
