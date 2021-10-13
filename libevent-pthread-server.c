/*
 * echo-server.c
 *
 * This is a modified version of the "simpler ROT13 server with
 * Libevent" from:
 * http://www.wangafu.net/~nickm/libevent-book/01_intro.html
 */

#include <netinet/in.h>
#include <sys/socket.h>
#include <fcntl.h>

#include <event2/event.h>
#include <event2/thread.h>

#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

#include <pthread.h>

#define MAX_LINE 16384

struct event_base *base;

int n = 0;

event_base_got_break(base);

void
on_accept(evutil_socket_t listener, short event, void *arg)
{
     if(n == 5){
          event_base_loopbreak(base);
     }
     struct event_base *base = arg;
     struct sockaddr_storage ss;
     socklen_t slen = sizeof(ss);
     int fd = accept(listener, (struct sockaddr*)&ss, &slen);
     if (fd < 0) {
	  perror("accept");
     } else if (fd > FD_SETSIZE) {
	  close(fd);
     } else {
	  char hello[] = "hello mate how you do!";
       write(fd, (void *)hello, sizeof(hello));
       close(fd);
       n++;
     }
}


void* dispatchLoop() {
     if (!base){
	perror("base not created");
     }
     else {
     	event_base_loop(base, EVLOOP_NO_EXIT_ON_EMPTY);
     	event_base_free(base);
     }

     pthread_exit(0);
}

int
main(int argc, char **argv)
{
     // Part 1
     // where to initialize pthread and base
     evthread_use_pthreads();
     base = event_base_new();
     pthread_t tid;
     pthread_attr_t attr;
     pthread_attr_init(&attr);
     pthread_create(&tid, &attr, dispatchLoop, NULL);

     // Part 2
     // stays same as earlier implementation
     int listener;
     struct sockaddr_in sin;
     struct event *listener_event;

     sin.sin_family = AF_INET;
     sin.sin_addr.s_addr = 0;
     sin.sin_port = htons(40713);

     listener = socket(AF_INET, SOCK_STREAM, 0);
     evutil_make_socket_nonblocking(listener);
     if (bind(listener, (struct sockaddr*)&sin, sizeof(sin)) < 0) {
	  perror("bind");
	  return 1;
     }

     if (listen(listener, 16) < 0) {
	  perror("listen");
	  return 1;
     }

     listener_event = event_new(base, listener, EV_READ | EV_PERSIST, on_accept, (void *)base);
     event_add(listener_event, NULL);

     // add waiting logic using qthreads here
     // wake up by dispatchLoop thread
     // how will the wake up work in case of multiple event observers

     pthread_join(tid, NULL);
     event_del(listener_event);
     return 0;
}
