<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.bg {
	position: relative;
	width: 100%;
	height: 1000px;
	top: 0;
	bottom: 0;
	/* 	background-color: #7A378B; */
}

.up {
	width: 1000px;
	height: 1000px;
	margin: 0 auto;
	/* 	background-color: #7CCD7C; */
}

.users {
	width: 30%;
	height: 60%;
	margin-top: 100px;
	background-color: yellow;
	width: 30%;
	float: left;
}

.session {
	width: 68%;
	height: 60%;
	margin-left: 20px;
	margin-top: 100px;
	background-color: blue;
	float: left;
}

.chat {
	width: 100%;
	height: 400px;
	margin: auto;
	border: 3px solid black;
}

.editarea {
	width: 100%;
	height: 200px;
	margin: auto;
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
	var nickname = "客服";
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
		var message = JSON.parse(ev.data);
		var obj = message.users;
		
		if(obj!=null){
			$(".users ul").html("");
			for(var i=0;i<obj.length;i++){
				if(obj[i]=="客服"){
					
				}else{
					$(".users ul").append("<li>"+obj[i]+"</li>");
				}
				
			}
			
		}else{
			var msg = '(' + ev.data + ')';
			$(".session ul").append("<li>" + msg + "</li>");
		}
		
	}

	function msg() {
		editor.sync();
		var txt = $("#editor_id").val();
		var obj = JSON.stringify({
			nickname : nickname,
			content : txt
		});
		// 发送消息
		socket.send(obj);
		$("#editor_id").text("");
	}
	
	
</script>
</head>
<body>
	<div class="bg">
		<div class="up">
			<div class="users">
				<ul>
					
				</ul>
			</div>
			<div class="session">
				<div class="chat">
					<ul>
					</ul>
				</div>

				<form class="editarea" method="post">
					<textarea id="editor_id" name="content" style="width: 100%; height: 100px;">&lt;strong&gt;HTML内容&lt;/strong&gt;</textarea>
					<input id="send" type="button" value="发送" onclick="msg()">
				</form>
			</div>
		</div>
	</div>

</body>
</html>