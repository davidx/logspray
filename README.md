# AMQP based network logger.

Created out of the need for a simple network based logger for Apache, can be used with other deamons as well. eg. mysql-proxy. see examples. 

### To use with Apache:

Standard log entry:

<pre>
LogLevel debug
ErrorLog "/var/log/apache/error/error.log"
CustomLog "/var/log/apache/access/access.log" combined
</pre>

This is better but still requires compression and cleanup on each cluster server. Not ideal if you want aggregrate log flow transparancy.

<pre>
LogLevel debug
ErrorLog "|/usr/sbin/cronolog /var/log/apache/error/%Y%m%d-error.log"
CustomLog "|/usr/sbin/cronolog /var/log/apache/access/%Y%m%d-access.log" combined
</pre>

This sends a message to an AMQP queue for each log entry, which can be replicated, persisted, normalized, consumed in various ways.

<pre>
LogLevel debug
CustomLog "|/data/logspray/current/bin/logspray.rb --host=myamqploghost --queue=apache_access_log" combined
ErrorLog "|/data/logspray/current/bin/logspray.rb --host=myamqploghost --queue=apache_error_log"
</pre>

# Dependency: 
- Setup a rabbitmq or amqp compliant server on 'myamqploghost'

_ubuntu_: <pre> 
	apt-get install rabbitmq-server && 
	update-rc add rabbitmq-server && 
	/etc/init.d/rabbitmq-server start 
	</pre>

_gentoo_: <pre>
	emerge rabbitmq && 
	rc-update add rabbitmq default && 
	/etc/init.d/rabbitmq start 
	</pre>




add this cronjob on your log server:


* * * * *       ruby /usr/local/logspray/bin/consume_logspray_queue.rb --host=myamqploghost --queue=apache_access_log
* * * * *       ruby /usr/local/logspray/bin/consume_logspray_queue.rb --host=myamqploghost --queue=apache_error_log
