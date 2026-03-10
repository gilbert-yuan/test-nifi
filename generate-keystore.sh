#!/bin/bash
set -e

# ========== 配置区域 ==========
LE_CERT_DIR="/etc/letsencrypt/live/etl.data.kinlim.com"
OUTPUT_DIR="./nifi-conf"
PASSWORD_KEYSTORE="d678e5ca5557188981ae14cf74c89e9e"
PASSWORD_TRUSTSTORE="18ea1b1260bc8cc78ef27e39fd445712"
KEY_ALIAS="nifi"
ROOT_CA_NAME="isrgrootx1.pem"
ROOT_CA_URL="https://letsencrypt.org/certs/isrgrootx1.pem"
# ==============================

mkdir -p "$OUTPUT_DIR"

echo "📁 清理旧文件..."
rm -f "$OUTPUT_DIR/nifi.keystore.p12" "$OUTPUT_DIR/nifi.truststore.p12" "$OUTPUT_DIR/$ROOT_CA_NAME"

echo "🔐 生成 NiFi PKCS12 keystore..."

openssl pkcs12 -export \
  -in "$LE_CERT_DIR/fullchain.pem" \
  -inkey "$LE_CERT_DIR/privkey.pem" \
  -out "$OUTPUT_DIR/keystore.p12" \
  -name "$KEY_ALIAS" \
  -passout pass:$PASSWORD_KEYSTORE

echo "🌐 下载根证书 $ROOT_CA_NAME ..."
curl -sSfL "$ROOT_CA_URL" -o "$OUTPUT_DIR/$ROOT_CA_NAME"

echo "🔐 生成 NiFi PKCS12 truststore，导入根证书..."

keytool -importcert \
  -file "$OUTPUT_DIR/$ROOT_CA_NAME" \
  -alias "$KEY_ALIAS-trust" \
  -keystore "$OUTPUT_DIR/truststore.p12" \
  -storetype PKCS12 \
  -storepass "$PASSWORD_TRUSTSTORE" \
  -noprompt

echo ""
echo "✅ 文件生成完毕："
ls -lh "$OUTPUT_DIR/nifi.keystore.p12" "$OUTPUT_DIR/nifi.truststore.p12"

echo ""
echo "📌 请将以上文件复制到 NiFi 配置目录，例如 ./conf/，并更新 nifi.properties 如下："

cat <<EOF

nifi.security.keystore=./conf/nifi.keystore.p12
nifi.security.keystoreType=PKCS12
nifi.security.keystorePasswd=$PASSWORD_KEYSTORE

nifi.security.truststore=./conf/nifi.truststore.p12
nifi.security.truststoreType=PKCS12
nifi.security.truststorePasswd=$PASSWORD_TRUSTSTORE

# 下面两个可以保持默认
nifi.security.user.oidc.truststore.strategy=JDK
nifi.security.user.saml.http.client.truststore.strategy=JDK

EOF
