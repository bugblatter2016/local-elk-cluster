#!/usr/bin/env bash

wget -O accounts.json https://github.com/elastic/elasticsearch/blob/master/docs/src/test/resources/accounts.json\?raw\=true

curl -s -H "Content-Type: application/json" -XPOST "elastic:changeme@localhost:9200/accounts/docs/_bulk" --data-binary "@accounts.json"\n