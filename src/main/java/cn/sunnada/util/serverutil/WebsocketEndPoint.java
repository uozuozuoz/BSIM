package cn.sunnada.util.serverutil;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.alibaba.fastjson.JSONObject;

import cn.sunnada.entity.ReturnMessage;
import cn.sunnada.util.maputil.NewMap;
import cn.sunnada.util.messageutil.MessageHandler;

/*
 * websocket消息处理类
 */
public class WebsocketEndPoint extends TextWebSocketHandler {

	public static final NewMap<String, WebSocketSession> userSocketSessionMap;
	static {
		userSocketSessionMap = new NewMap<String, WebSocketSession>();
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// TODO Auto-generated method stub
//		super.handleTextMessage(session, message);
System.out.println(this);
		new MessageHandler().handle(session, message, userSocketSessionMap);

	}

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {

		super.afterConnectionEstablished(session);

	}

	/*
	 * 当断开连接时，清楚会话
	 */
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {

		super.afterConnectionClosed(session, status);
		userSocketSessionMap.remove(userSocketSessionMap.getKeyByValue(session));
	}

}
