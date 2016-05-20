//
//  LLNBSDSocketController.m
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import "LLNBSDSocketController.h"
#import <arpa/inet.h>
#import <netdb.h>

@implementation LLNBSDSocketController {
	int socketFileDescriptor;
}

- (void)loadCurrentStatus:(NSURL*)url {
    // 开始 network
	if ([self.delegate respondsToSelector:@selector(networkingResultsDidStart)]) {
		[self.delegate networkingResultsDidStart];
	}
	
    
    
    /**
     *  socket函数对应于普通文件的打开操作。普通文件的打开操作返回一个文件描述字，而socket()用于创建一个socket描述符（socket descriptor），它唯一标识一个socket。这个socket描述字跟文件描述字一样，后续的操作都有用到它，把它作为参数，通过它来进行一些读写操作。
     *
     *  @param domain   domain：即协议域，又称为协议族（family）。常用的协议族有，AF_INET、AF_INET6、AF_LOCAL（或称AF_UNIX，Unix域socket）、AF_ROUTE等等。协议族决定了socket的地址类型，在通信中必须采用对应的地址，如AF_INET决定了要用ipv4地址（32位的）与端口号（16位的）的组合、AF_UNIX决定了要用一个绝对路径名作为地址。
     *  @param type     type：指定socket类型。常用的socket类型有，SOCK_STREAM、SOCK_DGRAM、SOCK_RAW、SOCK_PACKET、SOCK_SEQPACKET等等（socket的类型有哪些？）。
     
     *  @param protocol protocol：故名思意，就是指定协议。常用的协议有，IPPROTO_TCP、IPPTOTO_UDP、IPPROTO_SCTP、IPPROTO_TIPC等，它们分别对应TCP传输协议、UDP传输协议、STCP传输协议、TIPC传输协议
     *
     *  注意：并不是上面的type和protocol可以随意组合的，如SOCK_STREAM不可以跟IPPROTO_UDP组合。当protocol为0时，会自动选择type类型对应的默认协议。
     
     当我们调用socket创建一个socket时，返回的socket描述字它存在于协议族（address family，AF_XXX）空间中，但没有一个具体的地址。如果想要给它赋值一个地址，就必须调用bind()函数，否则就当调用connect()、listen()时系统会自动随机分配一个端口。
     */
    
    // create a new Internet stream socket

 int socket(int domain, int type, int protocol);
    
	socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
	
    // socket 函数返回-1的时候,就说明操作失败
	if (socketFileDescriptor == -1) {
        // Socket 失败
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to allocate networking resources."];
		}
		
		return;
	}
	
	
    

    
/**
     * 正如上面所说bind()函数把一个地址族中的特定地址赋给socket。例如对应AF_INET、AF_INET6就是把一个ipv4或ipv6地址和端口号组合赋给socket。
     
    int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
     
     函数的三个参数分别为：
     
     sockfd：即socket描述字，它是通过socket()函数创建了，唯一标识一个socket。bind()函数就是将给这个描述字绑定一个名字。
     addr：一个const struct sockaddr *指针，指向要绑定给sockfd的协议地址。这个地址结构根据地址创建socket时的地址协议族的不同而不同，如ipv4对应的是：
     
     struct sockaddr_in {
     sa_family_t    sin_family; // address family: AF_INET
    in_port_t      sin_port;   // port in network byte order
    struct in_addr sin_addr;   // internet address
};


struct in_addr {
    uint32_t       s_addr;     // address in network byte order
};

ipv6对应的是：

struct sockaddr_in6 {
    sa_family_t     sin6_family;   // AF_INET6
    in_port_t       sin6_port;     // port number
    uint32_t        sin6_flowinfo; // IPv6 flow information
    struct in6_addr sin6_addr;     // IPv6 address
    uint32_t        sin6_scope_id; // Scope ID (new in 2.4)
};

struct in6_addr {
    unsigned char   s6_addr[16];   // IPv6 address
};

Unix域对应的是：

#define UNIX_PATH_MAX    108

struct sockaddr_un {
    sa_family_t sun_family;               // AF_UNIX
    char        sun_path[UNIX_PATH_MAX];  // pathname
};

addrlen：对应的是地址的长度。

通常服务器在启动的时候都会绑定一个众所周知的地址（如ip地址+端口号），用于提供服务，客户就可以通过它来接连服务器；而客户端就不用指定，有系统自动分配一个端口号和自身的ip地址组合。这就是为什么通常服务器端在listen之前会调用bind()，而客户端就不会调用，而是在connect()时由系统随机生成一个。
     */
  //  int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
    
   
    
    
    
    
	// convert the hostname to an IP address
    // 使用DNS查找与主机名对应的IP
	struct hostent *remoteHostEnt = gethostbyname([[url host] UTF8String]);
	
	if (remoteHostEnt == NULL) {
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to resolve the hostname of the warehouse server."];
		}
		
		return;
	}
	
	struct in_addr *remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
	
	// set the socket parameters to open that IP address
	struct sockaddr_in socketParameters;
	socketParameters.sin_family = AF_INET;
	socketParameters.sin_addr = *remoteInAddr;
	socketParameters.sin_port = htons([[url port] intValue]);
	
	// connect the socket; a return code of -1 indicates an error
	if (connect(socketFileDescriptor, (struct sockaddr *) &socketParameters, sizeof(socketParameters)) == -1) {
		NSLog(@"Failed to connect to %@", url);
		
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to connect to the warehouse server."];
		}
		
		return;
	}
	
	NSLog(@"Successfully connected to %@", url);

	NSMutableData *data = [[NSMutableData alloc] init];
	BOOL waitingForData = YES;
	
	// continually receive data until we reach the end of the data
	while (waitingForData){
		const char *buffer[1024];
		int length = sizeof(buffer);
		
		// read a buffer's amount of data from the socket; the number of bytes read is returned
		int result = recv(socketFileDescriptor, &buffer, length, 0);
		
		// if we got data, append it to the buffer and keep looping
		if (result > 0){
			[data appendBytes:buffer length:result];
			
		// if we didn't get any data, stop the receive loop
		} else {
			waitingForData = NO;
		}
	}
	
	// close the stream since we're done reading
	close(socketFileDescriptor);
	
	
	NSString *resultsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"Received string: '%@'", resultsString);
	
	LLNNetworkingResult *result = [self parseResultString:resultsString];
	
	if (result != nil) {
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidLoad:)]) {
			[self.delegate networkingResultsDidLoad:result];
		}
		
	} else {
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to parse the response from the warehouse server."];
		}
	}
}

@end