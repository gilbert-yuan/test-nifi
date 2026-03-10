#!/bin/bash

export NIFI_WEB_HTTPS_PORT=8443
export NIFI_WEB_HTTPS_HOST=0.0.0.0

export NIFI_SECURITY_KEYSTORE=/opt/nifi/nifi-current/certs/nifi.keystore.jks
export NIFI_SECURITY_KEYSTORETYPE=JKS
export NIFI_SECURITY_KEYSTOREPASSWD=changeit
export NIFI_SECURITY_KEYPASSWD=changeit

export NIFI_SECURITY_TRUSTSTORE=/opt/nifi/nifi-current/certs/nifi.truststore.jks
export NIFI_SECURITY_TRUSTSTORETYPE=JKS
export NIFI_SECURITY_TRUSTSTOREPASSWD=changeit

