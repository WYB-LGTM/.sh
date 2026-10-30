#!/bin/bash
#
#********************************************************************
#Name:		    wangyoubin
#QQ: 		     2634485144
#********************************************************************

SITE_NAME=www.magedu.com
CA_SUBJECT="/O=wang/CN=ca.wang.org"
SUBJECT="/C=CN/ST=henan/L=zhengzhou/O=wang/CN=$SITE_NAME"
SERIAL=34
EXPIRE=202002
FILE=$SITE_NAME

openssl req  -x509 -newkey rsa:2048 -subj $CA_SUBJECT -keyout ca.key -nodes -days 202002 -out ca.crt

openssl req -newkey rsa:2048 -nodes -keyout ${FILE}.key  -subj $SUBJECT -out ${FILE}.csr

openssl x509 -req -in ${FILE}.csr  -CA ca.crt -CAkey ca.key -set_serial $SERIAL  -days $EXPIRE -out ${FILE}.crt

chmod 600 ${FILE}.key ca.key
