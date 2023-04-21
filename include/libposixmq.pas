unit libposixmq;

interface
	type
		mqd_t = LongInt;
		size_t = LongWord;
		ssize_t = LongInt;
		mode_t = LongInt;
		
		mq_attr = record
			mq_flags: LongInt; // Flags (ignored for mq_open())
			mq_maxmsg: LongInt; // Max. # of messages on queue
			mq_msgsize: LongInt; // Max. messages size (bytes)
			mq_curmsgs: LongInt; // # of messages currently in queue (ignored for mq_open())
		end;
		
		timespec = record
			tv_sec: LongInt; // seconds
			tv_nsec: LongInt; // nanoseconds
		end;
		
	const
		{ Message Queue Modes }
		O_RDONLY =   0;
		O_WRONLY =   1;
		O_RDWR =     2;
		O_CLOEXEC =  524288;
		O_CREAT =    64;
		O_EXCL =     128;
		O_NONBLOCK = 2048;
		{ Permission bits }
		// Owner:
		S_IRWXU	= 448; // RWX mask for owner
		S_IRUSR	= 256; // R for owner
		S_IWUSR	= 128; // W for owner
		S_IXUSR	= 64;  // X for owner
		// Group:
		S_IRWXG	= 56;  // RWX mask for group
		S_IRGRP	= 32;  // R for group
		S_IWGRP	= 16;  // W for group
		S_IXGRP	= 8;   // X for group
		// Other:
		S_IRWXO	= 7;   // RWX mask for other
		S_IROTH	= 4;   // R for other
		S_IWOTH	= 2;   // W for other
		S_IXOTH	= 1;   // X for other

	function MQ_GetError(): LongInt;
	external 'MQ_GetError@libposixmq.so cdecl';

	function MQ_GetStrError(): PChar;
	external 'MQ_GetStrError@libposixmq.so cdecl';

	function MQ_Open(name: PChar; oflag: LongInt): mqd_t;
	external 'MQ_Open@libposixmq.so cdecl';

	function MQ_OpenWithMode(name: PChar; oflag: LongInt; mode: mode_t): mqd_t;
	external 'MQ_OpenWithMode@libposixmq.so cdecl';

	function MQ_OpenWithAttr(name: PChar; oflag: LongInt; mode: mode_t; var attr: mq_attr): mqd_t;
	external 'MQ_OpenWithAttr@libposixmq.so cdecl';

	function MQ_Send(mqdes: mqd_t; msg_ptr: PChar; msg_len: size_t; msg_prio: LongWord): LongInt;
	external 'MQ_Send@libposixmq.so cdecl';

	function MQ_TimedSend(mqdes: mqd_t; msg_ptr: PChar; msg_len: size_t; msg_prio: LongWord; var abs_timeout: timespec): LongInt;
	external 'MQ_TimedSend@libposixmq.so cdecl';

	function MQ_Close(mqdes: mqd_t): mqd_t;
	external 'MQ_Close@libposixmq.so cdecl';

	function MQ_Receive(mqdes: mqd_t; var msg_ptr: String; msg_len: size_t): ssize_t;

	function MQ_ReceiveWithPrio(mqdes: mqd_t; var msg_ptr: String; msg_len: size_t; var msg_prio: LongWord): ssize_t;
	
	function MQ_TimedReceive(mqdes: mqd_t; var msg_ptr: String; msg_len: size_t; var msg_prio: LongWord; var abs_timeout: timespec): ssize_t;
	
	function MQ_GetAttr(mqdes: mqd_t; var attr: mq_attr): LongInt;
	external 'MQ_GetAttr@libposixmq.so cdecl';

	function MQ_SetAttr(mqdes: mqd_t; var newattr: mq_attr): LongInt;
	external 'MQ_SetAttr@libposixmq.so cdecl';

	function MQ_Unlink(name: PChar): LongInt;
	external 'MQ_Unlink@libposixmq.so cdecl';

implementation
	function MQ_ReceiveX(mqdes: mqd_t; msg_ptr: PChar; msg_len: size_t): ssize_t;
	external 'MQ_Receive@libposixmq.so cdecl';
	
	function MQ_ReceiveWithPrioX(mqdes: mqd_t; msg_ptr: PChar; msg_len: size_t; var msg_prio: LongWord): ssize_t;
	external 'MQ_ReceiveWithPrio@libposixmq.so cdecl';

	function MQ_TimedReceiveX(mqdes: mqd_t; msg_ptr: PChar; msg_len: size_t; var msg_prio: LongWord; var abs_timeout: timespec): ssize_t;
	external 'MQ_TimedReceive@libposixmq.so cdecl';

	function MQ_Receive(mqdes: mqd_t; var msg_ptr: String; msg_len: size_t): ssize_t;
	begin
		// Prepare string to be of size: msg_len
		SetLength(msg_ptr, msg_len);
		Result := MQ_ReceiveX(mqdes, msg_ptr, msg_len);
		if Result >= 0 then begin
			// if msg_len was greater than the message length
			// we need to reduce msg_ptr's length
			SetLength(msg_ptr, Result);
		end;
	end;
	
	function MQ_ReceiveWithPrio(mqdes: mqd_t; var msg_ptr: String; msg_len: size_t; var msg_prio: LongWord): ssize_t;
	begin
		// Prepare string to be of size: msg_len
		SetLength(msg_ptr, msg_len);
		Result := MQ_ReceiveWithPrioX(mqdes, msg_ptr, msg_len, msg_prio);
		if Result >= 0 then begin
			// if msg_len was greater than the message length
			// we need to reduce msg_ptr's length
			SetLength(msg_ptr, Result);
		end;
	end;
	
	function MQ_TimedReceive(mqdes: mqd_t; var msg_ptr: String; msg_len: size_t; var msg_prio: LongWord; var abs_timeout: timespec): ssize_t;
	begin
		// Prepare string to be of size: msg_len
		SetLength(msg_ptr, msg_len);
		Result := MQ_TimedReceiveX(mqdes, msg_ptr, msg_len, msg_prio, abs_timeout);
		if Result >= 0 then begin
			// if msg_len was greater than the message length
			// we need to reduce msg_ptr's length
			SetLength(msg_ptr, Result);
		end;
	end;
	
initialization
    begin
        WriteLn('[' + Script.Name + '] LibPosixMQ unit has been initialized.');
    end;

finalization
    begin
        WriteLn('[' + Script.Name + '] LibPosixMQ unit has been finalized.');
    end;
end.
