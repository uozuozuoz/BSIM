package cn.sunnada.util;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;


@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		
		 System.out.println("....注册......");
		    registry.addHandler(myhandler(), "/websocket").addInterceptors(myInterceptors()); 
	}
	
	@Bean  
	public WebSocketHandler myhandler() { 
	    System.out.println("....服务端......");
	    return new WebsocketEndPoint();  
	}  
	
	@Bean  
	public HandshakeInterceptor myInterceptors() { 
	    System.out.println("....握手拦截器......");
	    return new HandshakeInterceptor();  
	}  

}
