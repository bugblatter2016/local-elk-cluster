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

### Reload Logstash config on the fly
If you update the ./pipeline/logstash.conf file then changes will be reflected inside the Docker image.  Using SIGHUP 
provides a convenient way to test Logstash configurations by forcing a reload of the Logstash service.
```bash
docker exec -u root logstash-01 bash -c 'kill -HUP 1'
```

## Filebeat

### Install the client
On your test environment (use following link for detailed instructions)
- https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation.html

### Copy config file for Filebeat
MAC OS
```bash
cp filebeat.yml /usr/local/etc/metricbeat/filebeat.yml
```
Linux
```bash
cp filebeat.yml /etc/metricbeat/filebeat.yml
```

### Configure Index and configure System module and dashboards
```bash
filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["elastic:changeme@localhost:9200"]'
filebeat modules enable system
filebeat setup --dashboards
```

### Run some logs into Logstash
```bash
filebeat -e
```

## Metricbeat

### Install the client
On your test environment (use following link for detailed instructions)
- https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-installation.html

### Copy config file for Metricbeat
MAC OS
```bash
cp metricbeat.yml /usr/local/etc/metricbeat/metricbeat.yml
```
Linux
```bash
cp metricbeat.yml /etc/metricbeat/metricbeat.yml
```

### Configure Metricbeat Dashboards
```bash
metricbeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["elastic:changeme@localhost:9200"]'
metricbeat setup --dashboards
```

### Run some metrics into Logstash
```bash
metricbeat -e
```

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



# Changes made to run the stack on a Linux Box
Elasticsearch require vm.max_map_count to be set as 262144.
To fix the problem with vm.max_map_count too small run to increase it on the box

```
sudo sysctl -w vm.max_map_count=262144
```
