package cn.sunnada.entity;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;

import com.alibaba.fastjson.JSONObject;

public class ReturnMessage {

	private String sender;
	private String receiver;
	private String time;
	private String content;
	private boolean isSelf;
	private JSONObject jsonobj;

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public JSONObject getJsonobj() {
		return jsonobj;
	}

	public void setJsonobj(JSONObject jsonobj) {
		this.jsonobj = jsonobj;
	}

	public String getSender() {
		return sender;
	}

	public void setSender(String sender) {
		this.sender = sender;
	}

	public String getReceiver() {
		return receiver;
	}

	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public boolean isSelf() {
		return isSelf;
	}

	public void setSelf(boolean isSelf) {
		this.isSelf = isSelf;
	}

	public ReturnMessage() {

	}

	public ReturnMessage(JSONObject jsonobj) {
		this.jsonobj = jsonobj;
		this.sender = jsonobj.getString("sender");
		this.receiver = jsonobj.getString("receiver");
		this.content = jsonobj.getString("content");
		this.time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
	}

	public TextMessage getTextMessage() {
		Map<String, String> map = new HashMap<String, String>();
		map.put("message", this.toString());
		String msg = JSONObject.toJSONString(map);
		return new TextMessage(msg);
	}

	@Override
	public String toString() {
		return "{\"sender\":\"" + sender + "\", \"receiver\":\"" + receiver + "\", \"content\":\"" + content+ "\", \"time\":\"" + time
				+ "\", \"isSelf\":" + isSelf + "}";
	}

}
