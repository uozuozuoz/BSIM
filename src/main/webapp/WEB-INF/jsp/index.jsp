<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>与客服联系中...</title>
<style>
.session {
	position: absolute;
	top: 0;
	bottom: 0;
	left: 0;
	right: 0;
	margin: auto;
	width: 800px;
	height: 600px;
	margin: auto;
}

.chat {
	width: 800px;
	height: 400px;
	margin: auto;
	border: 3px solid black;
}

.editarea {
	width: 800px;
	height: 200px;
	margin: auto;
}

ul {
	border: 3px solid black;
}

li {
	list-style-type: none;
}
</style>
<link rel="stylesheet"
	href="resources/kindeditor/themes/default/default.css" />
<link rel="stylesheet"
	href="resources/kindeditor/plugins/code/prettify.css" />
<script charset="utf-8" src="resources/jquery/jquery.min.js"></script>
<script charset="utf-8" src="resources/kindeditor/kindeditor-all.js"></script>
<script charset="utf-8" src="resources/kindeditor/lang/zh-CN.js"></script>
<script charset="utf-8"
	src="resources/kindeditor/plugins/code/prettify.js"></script>

<script>
	var editor;
	KindEditor.ready(function(K) {
		var options = {
			cssPath : 'resources/kindeditor/plugins/code/prettify.css',
			filterMode : true
		};
		editor = K.create('textarea[name="content"]', options);
		prettyPrint();
	});

	//自己的昵称
	var nickname = "风清扬"+Math.random();
	//建立一条与服务器之间的连接
	var socket = new WebSocket(
			"ws://${pageContext.request.getServerName()}:${pageContext.request.getServerPort()}${pageContext.request.contextPath}/websocket");
	//在连接成功连接server后想服务器发送身份信息
	socket.onopen = function(ev){
		var obj = JSON.stringify({
			nickname : nickname
		});
		socket.send(obj);
	}
	//接收服务器的消息
	socket.onmessage = function(ev) {
		var data = JSON.parse(ev.data);
		var message = JSON.parse(data.message)
		console.log(message.sender);
		console.log(message.receiver);
		console.log(message.content);
		console.log(message.time);
		console.log(message.isSelf);
		
		$("ul").append("<li>" + message + "</li>");
	}

	function msg() {
		editor.sync();
		var txt = $("#editor_id").val();
		var obj = JSON.stringify({
			sender : nickname,
			receiver : "客服",
			content : txt
		});
		// 发送消息
		socket.send(obj);
		$("#editor_id").text("");
	}
</script>

</head>
<body>
	<div class="session">
		<div class="chat">
			<ul>
				<li>hello</li>
				<li>hi</li>
				<li>how r u</li>
				<li>fine</li>
				<li>2333</li>
			</ul>
		</div>
		<form class="editarea" method="post">
			<textarea id="editor_id" name="content" style="width: 100%; height: 100px;">&lt;strong&gt;HTML内容&lt;/strong&gt;</textarea>
			<input id="send" type="button" value="发送" onclick="msg()">
		</form>
	</div>
</body>
</html>