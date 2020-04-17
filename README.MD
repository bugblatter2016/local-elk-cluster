# Notes on running local ELK Stack

## Pre-requisites
- docker
- docker-compose

## Elasticsearch

### Start Cluster
```bash
cd elasticsearch
docker-compose up -d
```

### Check Status of Elasticsearch
```bash
docker-compose logs
curl -X GET "localhost:9200/_cat/nodes?v&pretty"
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
```bash

```

## Metricbeat
```bash

```


# Cleanup

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
- convert to Helm 3 chart
- dedicated Master Node cluster
- dedicated Data Node cluster
- Xpack licence install

# References
- https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html
