#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

if [ "${DEV_MODE_scripts_s3_bucket}" != "" ]; then
	sudo aws s3 cp --recursive "s3://${DEV_MODE_scripts_s3_bucket}" /opt/cloud-deploy-scripts/
	sudo chmod -R +x /opt/cloud-deploy-scripts
fi

export cloud_provider="${cloud_provider}"
export elasticsearch_data_dir="${elasticsearch_data_dir}"
export elasticsearch_logs_dir="${elasticsearch_logs_dir}"
export heap_size="${heap_size}"
export is_voting_only="${is_voting_only}"
export es_cluster="${es_cluster}"
export es_environment="${es_environment}"
export security_groups="${security_groups}"
export aws_region="${aws_region}"
export use_g1gc="${use_g1gc}"
export security_enabled="${security_enabled}"
export monitoring_enabled="${monitoring_enabled}"
export masters_count="${masters_count}"
export client_user="${client_user}"
export s3_backup_bucket="${s3_backup_bucket}"
export xpack_monitoring_host="${xpack_monitoring_host}"
export filebeat_monitoring_host="${filebeat_monitoring_host}"
export client_pwd="${client_pwd}"
export master="${master}"
export data="${data}"
export bootstrap_node="${bootstrap_node}"
export ca_cert="${ca_cert}"
export node_cert="${node_cert}"
export node_key="${node_key}"
export log_level="${log_level}"
export log_size="${log_size}"
export security_encryption_key="${security_encryption_key}"
export reporting_encryption_key="${reporting_encryption_key}"
export auto_shut_down_bootstrap_node="${auto_shut_down_bootstrap_node}"
export monitoring_host="${monitoring_host}"
export monitoring_port="${monitoring_port}"
export monitoring_secret_arn="${monitoring_secret_arn}"
export monitoring_user="${monitoring_user}"
export monitoring_tls_verify="${monitoring_tls_verify}"

/opt/cloud-deploy-scripts/${startup_script}
