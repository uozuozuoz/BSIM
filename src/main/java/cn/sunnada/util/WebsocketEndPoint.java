package cn.sunnada.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.alibaba.fastjson.JSONObject;

/*
 * websocket消息处理类
 */
public class WebsocketEndPoint extends TextWebSocketHandler {

	public static final Map<String, WebSocketSession> userSocketSessionMap;
	static {
		userSocketSessionMap = new HashMap<String, WebSocketSession>();
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// TODO Auto-generated method stub
		super.handleTextMessage(session, message);

		JSONObject jsonobj = JSONObject.parseObject(message.getPayload());
		String nickname = jsonobj.getString("nickname");
		String sessionid = session.getId();
		String content = jsonobj.getString("content");
		TextMessage returnMessage = new TextMessage(sessionid+":"+content);
		Iterator<Map.Entry<String, WebSocketSession>> iterator = userSocketSessionMap.entrySet().iterator();
		while (iterator.hasNext()) {
		    Map.Entry<String, WebSocketSession> entry = iterator.next();
		    entry.getValue().sendMessage(returnMessage);
		}
		
	}

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		
		super.afterConnectionEstablished(session);
		userSocketSessionMap.put(session.getId(), session);
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		
		super.afterConnectionClosed(session, status);
		userSocketSessionMap.remove(session.getId());
	}

}
