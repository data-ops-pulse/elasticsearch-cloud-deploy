# Required variables
# - filebeat_monitoring_host (deprecated)
# - filebeat_logstash_hosts (preferred)

# Configure Elasticsearch module for ES node logs
configure_elasticsearch_module() {
	cat <<EOF >/etc/filebeat/modules.d/elasticsearch.yml
# Module: elasticsearch
# Docs: https://www.elastic.co/guide/en/beats/filebeat/7.6/filebeat-module-elasticsearch.html

- module: elasticsearch
  server:
    enabled: true
  gc:
    enabled: false
  audit:
    enabled: false
  slowlog:
    enabled: true
  deprecation:
    enabled: true
EOF
}

# Logstash output (preferred)
if [ "${filebeat_logstash_hosts}" != "" ] && [ "${filebeat_logstash_hosts}" != "[]" ]; then
	configure_elasticsearch_module

	# Convert Terraform list format to YAML array
	# Input: ["host1:5044","host2:5044"] -> Output: YAML list
	LOGSTASH_HOSTS=$(echo "${filebeat_logstash_hosts}" | tr -d '[]"' | tr ',' '\n' | sed 's/^/    - "/;s/$/"/')

	cat <<EOF >/etc/filebeat/filebeat.yml
filebeat.config.modules.path: /etc/filebeat/modules.d/*.yml
output.logstash:
  hosts:
${LOGSTASH_HOSTS}
setup.ilm.enabled: false
setup.template.enabled: false
EOF

	systemctl daemon-reload
	systemctl enable filebeat
	systemctl restart filebeat

# Elasticsearch output (deprecated, for backwards compatibility)
elif [ "${filebeat_monitoring_host}" != "" ] && [ "${filebeat_monitoring_host}" != "false" ]; then
	configure_elasticsearch_module

	cat <<EOF >/etc/filebeat/filebeat.yml
filebeat.config.modules.path: /etc/filebeat/modules.d/*.yml
output.elasticsearch:
  hosts: ["$filebeat_monitoring_host"]
setup.ilm.enabled: false
EOF

	systemctl daemon-reload
	systemctl enable filebeat
	systemctl restart filebeat

fi