uses libposixmq;

var
	message_to_send: String;
	cc: Char;
	mqdes: mqd_t;
	send_result: LongInt;
	getattr_result: LongInt;
	attr: mq_attr;
	message_received: Boolean;
	soldatserver_sends_descriptor: mqd_t;
	external_script_sends_descriptor: mqd_t;
	
procedure OnClockTick(Ticks: Integer);
var
	bytes_received: ssize_t;
	received_message: String;
begin
	if Ticks mod 60 = 0 then begin
		if not message_received then begin
			WriteLn('Waiting to receive a message from the external script');
			bytes_received := MQ_Receive(external_script_sends_descriptor, received_message, 9000);
			if bytes_received = -1 then begin
				// Error = 11 is EAGAIN
				// From mq_receive manual:
				// If the queue is empty, then, by default, mq_receive() blocks until a message becomes available, or the call is
				// interrupted by a signal handler.  If the O_NONBLOCK flag is enabled for the message  queue  description,  then
				// the call instead fails immediately with the error EAGAIN.
				if MQ_GetError() <> 11 then begin
					WriteLn('Couldn''t receive a message from the queue [' + IntToStr(external_script_sends_descriptor) + '] of name: /test_queue_external_script_sends');
					WriteLn(MQ_GetStrError());
				end;
			end else begin
				WriteLn('Received: ' + received_message);
				message_received := true;
			end;
		end;
	end;
end;

begin
	Game.OnClockTick := @OnClockTick;
	message_received := false;
	
	WriteLn('Opening a new queue');
	soldatserver_sends_descriptor := MQ_OpenWithMode('/soldatserver_sends', O_CREAT or O_RDWR, S_IRWXU);
	WriteLn(IntToStr(soldatserver_sends_descriptor));
	WriteLn(MQ_GetStrError());
	
	WriteLn('Opening a second queue');
	external_script_sends_descriptor := MQ_OpenWithMode('/external_script_sends', O_CREAT or O_RDWR or O_NONBLOCK, S_IRWXU);
	WriteLn(IntToStr(external_script_sends_descriptor));
	WriteLn(MQ_GetStrError());
	
	WriteLn('Sending a test message to the external script');
	message_to_send := 'Test message from soldatserver';
	send_result := MQ_Send(soldatserver_sends_descriptor, message_to_send, Length(message_to_send), 0);
	WriteLn(IntToStr(send_result));
	WriteLn(MQ_GetStrError());
	
	WriteLn('Checking attributes of the message queue');
	getattr_result := MQ_GetAttr(soldatserver_sends_descriptor, attr);
	WriteLn(IntToStr(getattr_result));
	WriteLn(IntToStr(attr.mq_flags));
	WriteLn(IntToStr(attr.mq_maxmsg));
	WriteLn(IntToStr(attr.mq_msgsize));
	WriteLn(IntToStr(attr.mq_curmsgs));
end.
