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
	// 	KindEditor.ready(function(K) {
	// 		var options = {
	// 			cssPath : 'resources/kindeditor/plugins/code/prettify.css',
	// 			filterMode : true
	// 		};
	// 		var editor = K.create('textarea[name="content"]', options);
	// 		prettyPrint();
	// 	});

	//自己的昵称
	var nickname = "风清扬" + Math.random();
	//建立一条与服务器之间的连接
	var socket = new WebSocket(
			"ws://${pageContext.request.getServerName()}:${pageContext.request.getServerPort()}${pageContext.request.contextPath}/websocket");
	//接收服务器的消息
	socket.onmessage = function(ev) {
		var obj = eval('(' + ev.data + ')');
		addMessage(obj)
	}
	//发送按钮被点击时
	$("#send")
			.click(
					function() {
						if (!um.hasContents()) { // 判断消息输入框是否为空
							// 消息输入框获取焦点
							um.focus();
							// 添加抖动效果
							$('.edui-container').addClass('am-animation-shake');
							setTimeout(
									"$('.edui-container').removeClass('am-animation-shake')",
									1000);
						} else {
							//获取输入框的内容
							var txt = um.getContent();
							//构建一个标准格式的JSON对象
							var obj = JSON.stringify({
								nickname : nickname,
								content : txt
							});
							// 发送消息
							socket.send(obj);
							// 清空消息输入框
							um.setContent('');
							// 消息输入框获取焦点
							um.focus();
						}
					});
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
		<div class="editarea">
			<textarea id="editor_id" name="content"
				style="width: 800px; height: 100px;">
&lt;strong&gt;HTML内容&lt;/strong&gt;
</textarea>
		</div>
	</div>
</body>
</html>