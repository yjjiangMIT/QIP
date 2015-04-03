/*

   File:   nmrx.c
   Date:   20-Apr-97
   Author: I. Chuang <ike@lanl.gov>

   MEX file for matlab to talk with NMR spectometer using netnmr.

   02-Dec-02 ILC: revised for MIT Junior Lab - other end is running under 
                  linux version of xwinnmr

   $Id: nmrx.c,v 1.1 2002/12/03 03:46:31 ike Exp $

   $Log: nmrx.c,v $
   Revision 1.1  2002/12/03 03:46:31  ike
   Initial revision


*/

#define DOMEX /**/

#define MYPORT "3221" /**/
/* #define MYPORT "3222" /**/
/* #define MYHOST "qip-1.mit.edu"	/**/
#define MYHOST "192.168.1.10"	/**/

#define VERBOSE 0

#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <signal.h>
#include <sys/types.h>
#include <string.h>
#include <sys/wait.h>
#include <ctype.h>

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <unistd.h>
#include <netinet/in.h>
#include <limits.h>
#include <netdb.h>
#include <arpa/inet.h>

/******************************************************************************/
/* socket utility functions */

/* Take a service name, and a service type, and return a port number.  If the
   service name is not found, it tries it as a decimal number.  The number
   returned is byte ordered for the network. */
int atoport(service, proto)
char *service;
char *proto;
{
  #if VERBOSE
  printf("running atoport. ");
  #endif
  int port;
  long int lport;
  struct servent *serv;
  char *errpos;

  /* First try to read it from /etc/services */
  serv = getservbyname(service, proto);
  if (serv != NULL)
    port = serv->s_port;
  else { /* Not in services, maybe a number? */
    lport = strtol(service,&errpos,0);
    if ( (errpos[0] != 0) || (lport < 1) || (lport > 65535) )
      return -1; /* Invalid port address */
    port = htons(lport);
  }
  return port;
}

/* Converts ascii text to in_addr struct.  NULL is returned if the address
   can not be found. */
struct in_addr *atoaddr(address)
char *address;
{
  struct hostent *host;
  static struct in_addr saddr;

  /* First try it as aaa.bbb.ccc.ddd. */
  saddr.s_addr = inet_addr(address);
  if (saddr.s_addr != -1) {
    return &saddr;
  }
  host = gethostbyname(address);
  if (host != NULL) {
    return (struct in_addr *) *host->h_addr_list;
  }
  return NULL;
}

/* This function listens on a port, and returns connections.  It forks
   returns off internally, so your main function doesn't have to worry
   about that.  This can be confusing if you don't know what is going on.
   The function will create a new process for every incoming connection,
   so in the listening process, it will never return.  Only when a connection
   comes in, and we create a new process for it will the function return.
   This means that your code that calls it should _not_ loop.

   The parameters are as follows:
     socket_type: SOCK_STREAM or SOCK_DGRAM (TCP or UDP sockets)
     port: The port to listen on.  Remember that ports < 1024 are
       reserved for the root user.  Must be passed in network byte
       order (see "man htons").
     listener: This is a pointer to a variable for holding the file
       descriptor of the socket which is being used to listen.  It
       is provided so that you can write a signal handler to close
       it in the event of program termination.  If you aren't interested,
       just pass NULL.  Note that all modern unixes will close file
       descriptors for you on exit, so this is not required. */
int get_connection(socket_type, port, listener)
int socket_type;
u_short port;
int *listener;
{
#if VERBOSE
  printf("running get_connection.\n");
#endif
  struct sockaddr_in address;
  int listening_socket;
  int connected_socket = -1;
  int new_process;
  int reuse_addr = 1;

  /* Setup internet address information.  
     This is used with the bind() call */
  memset((char *) &address, 0, sizeof(address));
  address.sin_family = AF_INET;
  address.sin_port = port;
  address.sin_addr.s_addr = htonl(INADDR_ANY);

  listening_socket = socket(AF_INET, socket_type, 0);
  if (listening_socket < 0) {
    perror("socket");
    exit(EXIT_FAILURE);
  }

  if (listener != NULL)
    *listener = listening_socket;

  setsockopt(listening_socket, SOL_SOCKET, SO_REUSEADDR, &reuse_addr, 
    sizeof(reuse_addr));

  if (bind(listening_socket, (struct sockaddr *) &address, 
    sizeof(address)) < 0) {
    perror("bind");
    close(listening_socket);
    exit(EXIT_FAILURE);
  }

  if (socket_type == SOCK_STREAM) {
    listen(listening_socket, 5); /* Queue up to five connections before
                                  having them automatically rejected. */

    while(connected_socket < 0) {
      connected_socket = accept(listening_socket, NULL, NULL);
      if (connected_socket < 0) {
        /* Either a real error occured, or blocking was interrupted for
           some reason.  Only abort execution if a real error occured. */
        if (errno != EINTR) {
          perror("accept");
          close(listening_socket);
          exit(EXIT_FAILURE);
        } else {
          continue;    /* don't fork - do the accept again */
        }
      }

      new_process = fork();
      if (new_process < 0) {
        perror("fork");
        close(connected_socket);
        connected_socket = -1;
      }
      else { /* We have a new process... */
        if (new_process == 0) {
          /* This is the new process. */
          close(listening_socket); /* Close our copy of this socket */
	  if (listener != NULL)
	          *listener = -1; /* Closed in this process.  We are not 
				     responsible for it. */
        }
        else {
          /* This is the main loop.  Close copy of connected socket, and
             continue loop. */
          close(connected_socket);
          connected_socket = -1;
        }
      }
    }
    return connected_socket;
  }
  else
    return listening_socket;
}

/* This is a generic function to make a connection to a given server/port.
   service is the port name/number,
   type is either SOCK_STREAM or SOCK_DGRAM, and
   netaddress is the host name to connect to.
   The function returns the socket, ready for action.*/
int make_connection(service, type, netaddress)
char *service;
int type;
char *netaddress;
{
  #if VERBOSE
  printf("running make_connection...");
  #endif
  /* First convert service from a string, to a number... */
  int port = -1;
  struct in_addr *addr;
  int sock, connected;
  struct sockaddr_in address;

  if (type == SOCK_STREAM) 
    port = atoport(service, "tcp");
  if (type == SOCK_DGRAM)
    port = atoport(service, "udp");
  if (port == -1) {
    fprintf(stderr,"make_connection:  Invalid socket type.\n");
    return -1;
  }
  addr = atoaddr(netaddress);
  if (addr == NULL) {
    fprintf(stderr,"make_connection:  Invalid network address.\n");
    return -1;
  }
 
  memset((char *) &address, 0, sizeof(address));
  address.sin_family = AF_INET;
  address.sin_port = (port);
  address.sin_addr.s_addr = addr->s_addr;

  sock = socket(AF_INET, type, 0);

  /* printf("Connecting to %s on port %d.\n",inet_ntoa(*addr),htons(port)); */

  if (type == SOCK_STREAM) {
    connected = connect(sock, (struct sockaddr *) &address, 
      sizeof(address));
    if (connected < 0) {
      perror("connect");
      return -1;
    }
#if VERBOSE
    printf(" type SOCK_STREAM found. returning sock from make_connection.\n");
#endif
    return sock;
  }
  /* Otherwise, must be for udp, so bind to address. */
  if (bind(sock, (struct sockaddr *) &address, sizeof(address)) < 0) {
    perror("bind");
    #if VERBOSE
    printf("returning -1 from make_connection.\n");
    #endif
    return -1;
  }
  #if VERBOSE
  printf("returning sock from make_connection.\n");
  #endif
  return sock;
}

/* This is just like the read() system call, accept that it will make
   sure that all your data goes through the socket. */
int sock_read(sockfd, buf, count)
int sockfd;
char *buf;
size_t count;
{
  #if VERBOSE
  printf("running sock_read...\n");
  #endif
  size_t bytes_read = 0;
  int this_read =0;

  while (bytes_read < count) {
    #if VERBOSE
    printf("bytes_read: %zd. this_read: %i. *buf: %c\n",bytes_read,this_read,*buf);
    #endif
    do
      this_read = read(sockfd, buf, count - bytes_read);
    while ( (this_read < 0) && (errno == EINTR) );
    if (this_read < 0){
      #if VERBOSE
      printf("done sock_read <0.\n");
      #endif
      return this_read;}
      else if (this_read == 0){
      #if VERBOSE
      printf("done sock_read ==0.\n");
      #endif
      return bytes_read;}
    bytes_read += this_read;
    buf += this_read;
  }
  #if VERBOSE
  printf("done sock_read all the way. got %zd bytes\n", bytes_read);
  #endif
  return count;
}

/* This is just like the write() system call, accept that it will
   make sure that all data is transmitted. */
int sock_write(sockfd, buf, count)
int sockfd;
char *buf;
size_t count;
{
  #if VERBOSE
  printf("running sock_write...");
  #endif
  size_t bytes_sent = 0;
  int this_write;

  while (bytes_sent < count) {
    do
      this_write = write(sockfd, buf, count - bytes_sent);
    while ( (this_write < 0) && (errno == EINTR) );
    if (this_write <= 0)
      return this_write;
    bytes_sent += this_write;
    buf += this_write;
  }
  #if VERBOSE
  printf("done sock_write.\n");
  #endif
  return count;
}

/* This function reads from a socket, until it recieves a linefeed
   character.  It fills the buffer "str" up to the maximum size "count".

   This function will return -1 if the socket is closed during the read
   operation.

   Note that if a single line exceeds the length of count, the extra data
   will be read and discarded!  You have been warned. */
int sock_gets(sockfd, str, count)
int sockfd;
char *str;
size_t count;
{
  #if VERBOSE
  printf("running sock_gets...");
  #endif
  int bytes_read;
  int total_count = 0;
  char *current_position;
  char last_read = 0;

  current_position = str;
  while (last_read != 10) {
    bytes_read = read(sockfd, &last_read, 1);
    if (bytes_read <= 0) {
      /* The other side may have closed unexpectedly */
      #if VERBOSE
      printf("done sock_gets -1.\n");
      #endif
      return -1; /* Is this effective on other platforms than linux? */
    }
    if ( (total_count < count) && (last_read != 10) && (last_read !=13) ) {
      current_position[0] = last_read;
      current_position++;
      total_count++;
    }
  }
  if (count > 0)
    current_position[0] = 0;
  #if VERBOSE
  printf("done sock_gets, all the way.\n");
  #endif
  return total_count;
}

/* This function writes a character string out to a socket.  It will 
   return -1 if the connection is closed while it is trying to write. */
int sock_puts(sockfd, str)
int sockfd;
char *str;
{
  #if VERBOSE
   printf("running sock_puts...sending it to sock_write\n");
   #endif
  return sock_write(sockfd, str, strlen(str));
}

/* This ignores the SIGPIPE signal.  This is usually a good idea, since
   the default behaviour is to terminate the application.  SIGPIPE is
   sent when you try to write to an unconnected socket.  You should
   check your return codes to make sure you catch this error! */
void ignore_pipe(void)
{
  struct sigaction sig;

  sig.sa_handler = SIG_IGN;
  sig.sa_flags = 0;
  sigemptyset(&sig.sa_mask);
  sigaction(SIGPIPE,&sig,NULL);
}

/******************************************************************************/
/* main program */

static char buffer[1024];

char *
do_nmr_command(char *cmd, char *host, char *port)
{
  #if VERBOSE
  printf("running do_nmr_command...\n");
  #endif
  int sock;

  ignore_pipe();
  sock = make_connection(port, SOCK_STREAM, host);
  if (sock == -1) {
    fprintf(stderr,"make_connection failed.\n");
    return NULL;
  }
  strcpy(buffer,cmd);
  if(buffer[strlen(buffer)-1]!='\n') strcat(buffer,"\n");
  sock_puts(sock,buffer);
  sock_gets(sock,buffer,sizeof(buffer));
  close(sock);
  #if VERBOSE
  printf("... done with do_nmr_command.\n");
  #endif
  return(buffer);
}

char *
do_putpp(char *fname, char *host, char *port)
{
  int sock,nread,nwrite,fsize;
  char *ptr;
  FILE *fp;
  struct stat sb;

  ignore_pipe();
  sock = make_connection(port, SOCK_STREAM, host);
  if (sock == -1) {
    fprintf(stderr,"make_connection failed.\n");
    return NULL;
  }

  /* get the file size */  

  if(stat(fname,&sb)<0){
    perror("[do_putpp] stat");
    return(NULL);
  }
  fsize = sb.st_size;
  
  /* open file to read */

  if((fp=fopen(fname,"r"))==NULL){
    perror("[do_putpp] fopen");
    return(NULL);
  }
  
  /* send the putpp command + filename + file size*/

  if((ptr = strrchr(fname,'/'))==NULL) ptr=fname-1;
  sock_puts(sock,"putpp ");
  sock_puts(sock,ptr+1);
  sock_puts(sock,"\n");
  fsize = htonl(fsize);
  sock_write(sock,&fsize,sizeof(fsize));

  /* send the file */

  while((nread=fread(buffer,1,sizeof(buffer),fp))>0){
    if((nwrite=sock_write(sock,buffer,nread))!=nread){
      fprintf(stderr,"oops! short write %d expected %d\n",nwrite,nread);
      fclose(fp);
      close(sock);
      return(NULL);
    }
  }
  fclose(fp);
  sock_gets(sock,buffer,sizeof(buffer));
  close(sock);
  return(buffer);
}

int
do_getdat(char *host, char *port, int **buf, long *ndat, char *fname)
{
  #if VERBOSE
 printf("running do_getdat.\n");
 #endif
  int sock,nread;
  char dum[128];
  int myndat;  /*13feb13 SPR: wierdness to get the number of bytes right*/


  ignore_pipe();
  sock = make_connection(port, SOCK_STREAM, host);
  if (sock == -1) {
    fprintf(stderr,"make_connection failed.\n");
    return -1;
  }
  #if VERBOSE
  printf("putting getdat in the sock.\n");
  #endif
  sock_puts(sock,"getdat\n");	/* send command */
  #if VERBOSE
  printf("getdat is in the sock. getting fname from the sock.\n");
  #endif
  sock_gets(sock,fname,128);	/* get fname */
  #if VERBOSE
  printf("fname gotten from the sock. getting dum/sync from the sock.\n");
  #endif
  sock_gets(sock,dum,128);	/* get sync */
  #if VERBOSE
  printf("dum/sync gotten from the sock.\n");
  #endif
  /*  fprintf(stderr,"[nmrx] getdat - fname=%s\n",fname);
      fprintf(stderr,"[nmrx] getdat - dum=%s\n",dum);*/

  if(strcmp(dum,"sync")){
    fprintf(stderr,"oops! sync error in getdat! aborting transfer...\n");
    fprintf(stderr,"msg: %s\n",dum);
    *buf = malloc(sizeof(int));
    **buf = 0;
    *ndat = 0;
    return(-1);
    close(sock);
  }
  #if VERBOSE
  printf("read 4 bytes from the sock.\n");
  #endif
  /* sock_read(sock,ndat,sizeof(long)); 13feb13 SPR: cchanged this to the below two lines to get the number of bytes to work after switching to 64-bit architecture*/
  sock_read(sock,&myndat,4);
  *ndat=myndat;
  #if VERBOSE
  printf("Now,read %d ->  ndat=%ld.\n",myndat, *ndat);
  #endif
  /* *ndat = ntohl(*ndat); /* not needed with linux xwinnmr */
  /*  fprintf(stderr,"[nmrx] do_getdat: expecting %ld bytes...\n",*ndat);
      fprintf(stderr,"[nmrx] ndat = %08x (sizeof long = %d)\n",*ndat,sizeof(long));*/

  /* *ndat = 159744; */
   #if VERBOSE
   printf("check the data size with a sock_read.\n");
   #endif
  *buf = malloc((*ndat));
  if((nread=sock_read(sock,*buf,(*ndat)))!=(*ndat)){
    fprintf(stderr,"shortchanged! only %d bytes. Expected %ld.\n",nread,*ndat);
      return(-1);
  }
  #if VERBOSE
  printf("do_getdat: %ld bytes read from the sock.\n", *ndat); 
  fflush(stdout);
  #endif

  /*  fprintf(stderr,"got it!\n");*/

  close(sock);
  #if VERBOSE
  printf("done with do_getdat.\n");
  #endif
  return(0);
}

/*****************************************************************************/
/* Matlab interface */

#ifdef DOMEX

/* #define V4_COMPAT */
#include "mex.h" /**/

void
mex_do_getdat(char *host, char *port, int nlhs, mxArray *plhs[])
{
  #if VERBOSE
  printf("running mex_do_getdat...\n");
  #endif
  int *buf;
  int k;
  long ndat;
  double *dbufr,*dbufi;
  char fname[128],*ptr;

  if(do_getdat(host,port,&buf,&ndat,fname)<0){
    /* mexErrMsgTxt("[nmrx] do_getdat failed!"); SPR changed*/
     mexErrMsgTxt("[nmrx] call to do_getdat in mex_do_getdat failed!\n");
  }    
  ndat /= sizeof(int);	/* convert from # bytes to # ints */

  if(nlhs==2){
    ptr = (char*) mxCalloc(strlen(fname),1);
    strcpy(ptr,fname);
    plhs[1] = mxCreateString(ptr);
  }
    
  if(nlhs>=1){
    plhs[0] = mxCreateDoubleMatrix(1,ndat/2,mxCOMPLEX);	/* even/odd data -> re/imag */
    dbufr = mxGetPr(plhs[0]);
    dbufi = mxGetPi(plhs[0]);
    /* convert int to doubles */
    for(k=0;k<ndat/2;k++){
#if 1
      /*      dbufr[k] = (signed long int) ntohl(buf[2*k  ]);
	      dbufi[k] = (signed long int) ntohl(buf[2*k+1]); 
      */
      /* SCN Longs ain't what they used to be (32-> 64 bit) */
      dbufr[k] = (signed int) ntohl(buf[2*k  ]);
      dbufi[k] = (signed int) ntohl(buf[2*k+1]); 
#else
      dbufr[k] = (signed long int) (buf[2*k  ]);
      dbufi[k] = (signed long int) (buf[2*k+1]);
#endif
    }
  }
  free(buf);	/* deallocate transfer memory */
  #if VERBOSE
  printf("done with mex_do_getdat.\n");
  #endif
}

/*****************************************************************************/
/* MAIN ENTRY POINT */

void 
mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  char cmd[128],*ret,*ptr,host[128],port[36];
  #if VERBOSE
  printf("running mexFunction.\n");
  #endif
  /* get filename */

  if(nrhs<1) return;
  if(mxIsChar(prhs[0]))
    mxGetString(prhs[0],cmd,128);
  else
    mexErrMsgTxt("[nmrx] args: cmd [host] [port]");

  /* set host & port with defaults */

  if(nrhs<3)   strcpy(port,MYPORT);
  else         mxGetString(prhs[2],port,36);

  if(nrhs<2)   strcpy(host,MYHOST);
  else         mxGetString(prhs[1],host,128);

  /* check for special commands */

  if(!strcmp(cmd,"getdat")) {
    #if VERBOSE
    printf("if you're reading this, then !strcmp(cmd,'getdat'). Time to run mex_do_getdat.\n");
    #endif
    mex_do_getdat(host,port,nlhs,plhs);
    return;
  }

  if(!strncmp(cmd,"putpp",5)) {
    ret = do_putpp(cmd+6,host,port);
    if(ret==NULL) mexErrMsgTxt("[nmrx] do_putpp failed!");
    if(nlhs>0){
      ptr = (char*) mxCalloc(strlen(ret)+10,1);
      strcpy(ptr,ret);
      plhs[0] = mxCreateString(ptr);
    }
    return;
  }

  #if VERBOSE
  printf("if you're reading this, then it's time to run do_nmr_command...\n");
  #endif
  ret = do_nmr_command(cmd,host,port);	/* ok do normal command */
  #if VERBOSE
  printf("...got past do_nmr_command.\n");
  #endif
  if(ret==NULL) mexErrMsgTxt("[nmrx] do_nmr_command failed!");

  if(nlhs>0){
    ptr = (char*) mxCalloc(strlen(ret)+10,1);
    strcpy(ptr,ret);
    plhs[0] = mxCreateString(ptr);
  }
  #if VERBOSE
  printf("done with mexFunction.\n");
  #endif
}

#else

main(int argc, char *argv[])
{
  fprintf(stderr,"hello\n");
  printf("%s\n",do_nmr_command("foo",MYHOST,MYPORT));
  {
    int *buf;
    int ndat;
    char fname[128];
    do_getdat(MYHOST,MYPORT,&buf,&ndat,fname);
  }
  fprintf(stderr,"bye!\n");
}
#endif