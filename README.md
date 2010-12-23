<pre> 
gem install bundler && bundle install 
</pre>
- Setup a rabbitmq or amqp compliant server on 'myamqploghost'

#### Gentoo:

<pre> 
emerge rabbitmq && 
rc-update add rabbitmq default && 
/etc/init.d/rabbitmq start 
</pre>

####Ubuntu:
<pre> 
apt-get install rabbitmq-server &&
update-rc add rabbitmq-server && 
/etc/init.d/rabbitmq-server start
</pre>

### Log persistence:
- Add this cronjob on your central log storage server:

<pre>
* * * * * ruby /usr/local/logspray/bin/consume_logspray_queue.rb --host=myamqploghost --queue=apache_access_log --logfile=/var/log/logspray/apache_access_log/apache_access_log_`date +%Y%m%d`.log
* * * * * ruby /usr/local/logspray/bin/consume_logspray_queue.rb --host=myamqploghost --queue=apache_error_log --logfile=/var/log/logspray/apache_error_log/apache_error_log_`date +%Y%m%d`.log
</pre>


