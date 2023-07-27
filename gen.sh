if [[ -z "$DNS" ]] ; then
  echo "DNS env variable is required!"
  echo "EXIT!"
  exit 1
fi

## Generate certificate
generate() {
    createCnf
    openssl req -config tmp/conf.cnf -new -x509 -days 825 -out certs/server-cert.pem -keyout private/server-key.pem
    rm -rf tmp
    echo 'Done!'
    exit 1
}

## Create certificate config
createCnf() {
    rm -rf tmp
    mkdir -p certs private tmp
    touch tmp/conf.cnf
    eval "echo \"$(cat openssl_template.cnf)\"" > tmp/conf.cnf
}

## Generate new cert if not exists
if ! [ -e certs/server-cert.pem ] || ! [ -e private/server-key.pem ]; then
    echo 'Cert or key not found! Generating new cert...'
    generate
fi

## DEPRECATED ##

# CERTMD5="$(openssl x509 -noout -modulus -in certs/server-cert.pem | openssl md5)"
# KEYMD5="$(openssl rsa -noout -modulus -in private/server-key.pem | openssl md5)"
# if [ "$CERTMD5" != "$KEYMD5" ] ; then
#     echo "Cert doesn't match to key! Recreating..."
#     generate
# fi

# ## Check information about the certificate with:
# CERT_DNS=`openssl x509 -in certs/server-cert.pem -text -noout | grep -o "DNS:.*" | sed -e "s/DNS://"`

# if [[ "$DNS" != "$CERT_DNS" ]]; then
#     echo 'DNS in cert is different with env arg. Recreating cert...'
#     generate
# fi

# ## 30 days before expiration in seconds
# EXPIRATION=$((30*24*60*60))

# ## Check expiration date
# if ! (openssl x509 -checkend $EXPIRATION -noout -in certs/server-cert.pem); then
#     echo "Certificate has expired or will do so within 30 days!"
#     echo "Recreating certificate"
#     generate
# fi

## DEPRECATED ##

echo 'Finish!'