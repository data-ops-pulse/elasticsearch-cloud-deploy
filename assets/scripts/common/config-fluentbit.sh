# Required variables
# - monitoring_host
# - monitoring_port
# - monitoring_user
# - monitoring_secret_arn
# - elasticsearch_logs_dir

monitoring_password="$(aws secretsmanager get-secret-value --secret-id $monitoring_secret_arn --region eu-west-1 | jq -r '.SecretString' | jq -r '.password.result')"

if [ "${monitoring_host}" != "" ]; then
	cat <<EOF >/etc/fluent-bit/fluent-bit.conf

  [SERVICE]
      Flush        5
      Log_Level    info
      Parsers_File parsers.conf

  [INPUT]
      Name          tail
      Path          $elasticsearch_logs_dir/*.json
      Parser        json
      Tag           elasticsearch_logs

  [OUTPUT]
      Name          opensearch
      Match         elasticsearch_logs
      Host          $monitoring_host
      Port          $monitoring_port
      Index         elasticsearch-logs
			Suppress_Type_Name On
      HTTP_User     $monitoring_user
      HTTP_Passwd   $monitoring_password
			tls           On
EOF

systemctl restart fluent-bit

fi
