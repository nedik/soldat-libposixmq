#include <mqueue.h>
#include <cerrno>
#include <cstring>
#include <ctime>

using namespace std;

extern "C"
{
    int MQ_GetError()
    {
        return errno;
    }
    
    char* MQ_GetStrError()
    {
        return strerror(errno);
    }
    
    mqd_t MQ_Open(char *name, int oflag)
    {
        return mq_open(name, oflag);
    }
    
    mqd_t MQ_OpenWithMode(char *name, int oflag, mode_t mode)
    {
        return mq_open(name, oflag, mode, NULL);
    }

    mqd_t MQ_OpenWithAttr(char *name, int oflag, mode_t mode, mq_attr &attr)
    {
        mq_attr attributes;
        attributes.mq_flags = attr.mq_flags;
        attributes.mq_maxmsg = attr.mq_maxmsg;
        attributes.mq_msgsize = attr.mq_msgsize;
        attributes.mq_curmsgs = attr.mq_curmsgs;
        mqd_t mqdes = mq_open(name, oflag, mode, &attributes);
        attr.mq_flags = attributes.mq_flags;
        attr.mq_maxmsg = attributes.mq_maxmsg;
        attr.mq_msgsize = attributes.mq_msgsize;
        attr.mq_curmsgs = attributes.mq_curmsgs;
        return mqdes;
    }

    int MQ_Send(mqd_t mqdes, char *msg_ptr, size_t msg_len, unsigned int msg_prio)
    {
        return mq_send(mqdes, msg_ptr, msg_len, msg_prio);
    }
    
    int MQ_TimedSend(mqd_t mqdes, char *msg_ptr, size_t msg_len, unsigned int msg_prio, timespec &abs_timeout)
    {
        timespec new_abs_timeout;
        new_abs_timeout.tv_sec = abs_timeout.tv_sec;
        new_abs_timeout.tv_nsec = abs_timeout.tv_nsec;
        int result = mq_timedsend(mqdes, msg_ptr, msg_len, msg_prio, &new_abs_timeout);
        abs_timeout.tv_sec = new_abs_timeout.tv_sec;
        abs_timeout.tv_nsec = new_abs_timeout.tv_nsec;
        return result;
    }

    int MQ_Close(mqd_t mqdes)
    {
        return mq_close(mqdes);
    }

    ssize_t MQ_Receive(mqd_t mqdes, char *msg_ptr, size_t msg_len)
    {
        return mq_receive(mqdes, msg_ptr, msg_len, NULL);
    }
    
    ssize_t MQ_ReceiveWithPrio(mqd_t mqdes, char *msg_ptr, size_t msg_len, unsigned int &msg_prio)
    {
        unsigned int new_msg_prio;
        new_msg_prio = msg_prio;
        ssize_t result = mq_receive(mqdes, msg_ptr, msg_len, &new_msg_prio);
        msg_prio = new_msg_prio;
        return result;
    }
    
    ssize_t MQ_TimedReceive(mqd_t mqdes, char *msg_ptr, size_t msg_len, unsigned int &msg_prio, timespec &abs_timeout)
    {
        unsigned int new_msg_prio;
        new_msg_prio = msg_prio;
        timespec new_abs_timeout;
        new_abs_timeout.tv_sec = abs_timeout.tv_sec;
        new_abs_timeout.tv_nsec = abs_timeout.tv_nsec;
        ssize_t result = mq_timedreceive(mqdes, msg_ptr, msg_len, &new_msg_prio, &new_abs_timeout);
        abs_timeout.tv_sec = new_abs_timeout.tv_sec;
        abs_timeout.tv_nsec = new_abs_timeout.tv_nsec;
        msg_prio = new_msg_prio;
        return result;
    }
    
    int MQ_GetAttr(mqd_t mqdes, mq_attr &attr)
    {
        mq_attr attributes;
        int result = mq_getattr(mqdes, &attributes);
        attr.mq_flags = attributes.mq_flags;
        attr.mq_maxmsg = attributes.mq_maxmsg;
        attr.mq_msgsize = attributes.mq_msgsize;
        attr.mq_curmsgs = attributes.mq_curmsgs;
        return result;
    }
    
    int MQ_SetAttr(mqd_t mqdes, mq_attr &newattr)
    {
        mq_attr newAttributes;
        newAttributes.mq_flags = newattr.mq_flags;
        newAttributes.mq_maxmsg = newattr.mq_maxmsg;
        newAttributes.mq_msgsize = newattr.mq_msgsize;
        newAttributes.mq_curmsgs = newattr.mq_curmsgs;
        return mq_setattr(mqdes, &newAttributes, NULL);
    }
    
    int MQ_Unlink(char *name)
    {
        return mq_unlink(name);
    }
}
