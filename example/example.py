#!/bin/python3

from posix_ipc import MessageQueue


SOLDATSERVER_SENDS_MQ_NAME = '/soldatserver_sends'
EXTERNAL_SCRIPT_SENDS_MQ_NAME = '/external_script_sends'


print('Opening message queues')
soldatserver_sends_mq = MessageQueue(SOLDATSERVER_SENDS_MQ_NAME)
external_script_sends_mq = MessageQueue(EXTERNAL_SCRIPT_SENDS_MQ_NAME)

print('Waiting for a message from soldatserver');
message_from_soldatserver, _ = soldatserver_sends_mq.receive()
message_from_soldatserver = message_from_soldatserver.decode('ascii')
print('Received a message from soldatserver:', message_from_soldatserver);

print('Sending a message to soldatserver');
external_script_sends_mq.send('Hello from the external script! Returning the message: ' + message_from_soldatserver);
