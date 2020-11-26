#include <sys/types.h>
#include <sys/param.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

int tcp_connect(const char *host, const char *service);

void usage(void)
{
  fprintf(stderr, "Usage: httpget url\n");
  exit(1);
}

int main(int argc, char **argv)
{
  char host[MAXHOSTNAMELEN] = "localhost";
  char path[1024] = "/";
  char port[16] = "80";
  int s;
  char buf[1024];
  int nread;

  /* 引数を取得する */
  if(argc > 1){
    int hlen, plen = 0;
    if(sscanf(argv[1], "http://%[^/:]%n", host, &hlen) != 1)
      usage();
    if(*(argv[1] + hlen) == ':'){
      if(sscanf(argv[1] + hlen, ":%[0-9]%n", port, &plen) != 1)
        usage();
    }
    if(sscanf(argv[1] + hlen + plen, "%s", path) != 1)
      usage();
  }

  /* サーバに接続する */
  if((s = tcp_connect(host, port)) < 0){
    fprintf(stderr, "cannot connect %s:%s\n", host, port);
    exit(1);
  }

  /* GET メソッドの送出 */
  sprintf(buf, "GET %s HTTP/1.0\r\n\r\n", path);
  if(write(s, buf, strlen(buf)) != strlen(buf)){
    perror("write");
    exit(1);
  }

  /* 応答を読み取って標準出力に出力する */
  while((nread = read(s, buf, sizeof(buf))) > 0){
    fwrite(buf, nread, 1, stdout);
  }
  close(s);
  return 0;
}

static int str_isnumber(const char *s)
{
   while(*s){
     if(!isdigit(*s))
       return 0;
     s++;
   }
   return 1;
}

int tcp_connect(const char *host, const char *service)
{
  int s;
  struct sockaddr_in to;
  struct hostent *hp;
  struct servent *sv;

  memset(&to, 0, sizeof(struct sockaddr_in));
  to.sin_family = AF_INET;

  /* aaa.bbb.ccc.ddd 形式と仮定して変換を行う */
  if((to.sin_addr.s_addr = inet_addr(host)) == -1){
    /* 失敗した場合は、ホスト名と仮定する */
    if((hp = gethostbyname(host)) == NULL){
      /* それでも失敗した場合はエラー */
      fprintf(stderr, "%s: unknown host\n", host);
      return -1;
    }
    to.sin_family = hp->h_addrtype;
    /* アドレスは4バイトと仮定して代入を行う */
    to.sin_addr.s_addr = **(u_long**)hp->h_addr_list;
  }

  if(str_isnumber(service)){
    /* ポート番号が指定された場合 */
    to.sin_port = htons((u_short)atoi(service));
  }else{
    /* サービスからポートを求める */
    if((sv = getservbyname(service, "tcp")) == NULL){
      fprintf(stderr, "%s: Unknown service\n", service);
      return -1;
    }
    to.sin_port = sv->s_port;
  }

  if((s = socket(PF_INET, SOCK_STREAM, 0)) < 0){
    perror("socket");
    return -1;
  }
  if(connect(s, (struct sockaddr*)&to, sizeof(struct sockaddr_in)) < 0){
    perror("connect");
    close(s);
    return -1;
  }
  return s;
}
