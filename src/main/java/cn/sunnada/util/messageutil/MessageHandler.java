package cn.sunnada.util.messageutil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.alibaba.fastjson.JSONObject;

import cn.sunnada.entity.ReturnMessage;
import cn.sunnada.util.maputil.NewMap;

public class MessageHandler {
	
	public void handle(WebSocketSession session, TextMessage message, NewMap<String, WebSocketSession> userSocketSessionMap) throws IOException {
		JSONObject jsonobj = JSONObject.parseObject(message.getPayload());
		String nickname = jsonobj.getString("nickname");
		if (nickname != null) {
			userSocketSessionMap.put(nickname, session);
			WebSocketSession kefu = userSocketSessionMap.get("kefu");
			if(kefu!=null) {
				Map map = new HashMap<String, Set>();
				map.put("users", userSocketSessionMap.keySet());
				kefu.sendMessage(new TextMessage(JSONObject.toJSONString(map)));
			}
			return;
		}

		ReturnMessage returnMessage = new ReturnMessage(jsonobj);

		Iterator<Map.Entry<String, WebSocketSession>> iterator = userSocketSessionMap.entrySet().iterator();

		while (iterator.hasNext()) {

			Map.Entry<String, WebSocketSession> entry = iterator.next();
			String sender = returnMessage.getSender();
			String receiver = returnMessage.getReceiver();
			String thisid = entry.getKey();
			if (!thisid.equals(sender) && !thisid.equals(receiver)) {
				continue;
			} else if (thisid.equals(sender)) {
				returnMessage.setSelf(true);
				entry.getValue().sendMessage(returnMessage.getTextMessage());
			} else if (thisid.equals(receiver)) {
				returnMessage.setSelf(false);
				entry.getValue().sendMessage(returnMessage.getTextMessage());
			}
			

		}
	}

}
