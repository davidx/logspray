# AMQP based network logger.

Created out of the need for a simple network based logger for Apache, can be used with other deamons as well. eg. mysql-proxy. see examples. 

### To use with Apache:

Standard log entry:

<code>
LogLevel debug
ErrorLog "/var/log/apache/error/error.log"
CustomLog "/var/log/apache/access/access.log" combined
</code>

This is better but still requires compression and cleanup on each cluster server. Not ideal if you want aggregrate log flow transparancy.

<code>
LogLevel debug
ErrorLog "|/usr/sbin/cronolog /var/log/apache/error/%Y%m%d-error.log"
CustomLog "|/usr/sbin/cronolog /var/log/apache/access/%Y%m%d-access.log" combined
</code>

This sends a message to an AMQP queue for each log entry, which can be replicated, persisted, normalized, consumed in various ways.

<code>
LogLevel debug
CustomLog "|/data/logspray/current/bin/logspray.rb --host=myamqploghost --queue=apache_access_log" combined
ErrorLog "|/data/logspray/current/bin/logspray.rb --host=myamqploghost --queue=apache_error_log"
</code>

# Dependency: 
- Setup a rabbitmq or amqp compliant server on 'myamqploghost'

<code> ubuntu: apt-get install rabbitmq-server && update-rc add rabbitmq-server && /etc/init.d/rabbitmq-server start </code>

<code> gentoo: emerge rabbitmq && rc-update add rabbitmq default && /etc/init.d/rabbitmq start </code>




add this cronjob on your log server:


* * * * *       ruby /usr/local/logspray/bin/consume_logspray_queue.rb --host=myamqploghost --queue=apache_access_log
* * * * *       ruby /usr/local/logspray/bin/consume_logspray_queue.rb --host=myamqploghost --queue=apache_error_log
