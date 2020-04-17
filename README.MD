# Running local ELK Stack on Docker

This will build 5 containers:
- 1 x Elasticsearch Master / Ingest Node
- 2 x Elasticsearch Data Nodes
- 1 x Kibana
- 1 x Logstash

Versions of Elasticsearch and cluster password can be set using the **env.sh**.

NOTE: if you change the password you will also need to update **./pipeline/logstash.conf** too

## Pre-requisites
- docker
- docker-compose

## Elasticsearch

### set local environment vars
```bash
source ./env.sh
```

### Start Cluster
```bash
docker-compose up -d
```

### Check Status of Elasticsearch
```bash
docker-compose logs -f
curl -X GET "localhost:9200/_cat/nodes?v&pretty" -u elastic:changeme
```

### Connect to Kibana
Open browser to http://localhost:5601/

### Send some test data to Logstash
```bash
NOW=$(($(date +'%s * 1000 + %-N / 1000000')))
curl -H "Content-Type: application/json" -X POST "http://localhost:9600" -d'
  { 
    "timestamp": "'"${NOW}"'",
    "message": "This is a sample event...."
  }
'
```

## Filebeat
Todo

## Metricbeat
Todo

# Cleanup

## Stop containers
```bash
docker-compose down
```

## Prune local system
> REF: https://docs.docker.com/config/pruning/

```bash
docker container prune
docker network prune
docker image prune
docker volume prune

# or do this....
docker system prune  --volumes
```

# Todo
- Notes for testing Beats

# References
- https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html
