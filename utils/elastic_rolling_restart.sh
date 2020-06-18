#!/usr/bin/env bash


# Rolling Restarts

## Check cluster is green
curl "localhost:9200/_cat/health?v" -u elastic:changeme

## Set cluster to only allocate new primaries (reduces cluster from excessive rebalancing
curl -X PUT "localhost:9200/_cluster/settings?pretty" -u elastic:changeme -H "Content-Type: application/json" -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "new_primaries"
  }
}'

## After restart of a node, check that cluster is green again
curl "localhost:9200/_cat/health?v" -u elastic:changeme

## Once all Nodes restarted remove the cluster setting override
curl -X PUT "localhost:9200/_cluster/settings?pretty" -u elastic:changeme -H "Content-Type: application/json" -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": null
  }
}'