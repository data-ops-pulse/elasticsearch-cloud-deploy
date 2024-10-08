#!/bin/bash
set +e

. /opt/cloud-deploy-scripts/common/env.sh
. /opt/cloud-deploy-scripts/$cloud_provider/env.sh

/opt/cloud-deploy-scripts/$cloud_provider/autoattach-disk.sh

/opt/cloud-deploy-scripts/common/config-es.sh
/opt/cloud-deploy-scripts/common/config-fluentbit.sh
/opt/cloud-deploy-scripts/$cloud_provider/config-es.sh
/opt/cloud-deploy-scripts/$cloud_provider/config-es-discovery.sh

cat <<'EOF' >>/etc/elasticsearch/elasticsearch.yml
node.roles: [ master ]
EOF

# Start Elasticsearch
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
