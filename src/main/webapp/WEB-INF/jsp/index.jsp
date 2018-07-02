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
body {
	background: url(resources/img/27.jpg);
}

.session {
	position: absolute;
	top: 0;
	bottom: 0;
	left: 0;
	right: 0;
	margin: auto;
	width: 840px;
	height: 600px;
	margin: auto;
}

.chat {
	width: 800px;
	height: 400px;
	margin: auto;
}

.editarea {
	width: 800px;
	height: 200px;
	margin: auto;
}

ul {

}

li {
	list-style-type: none;
}

.avatar {
	width: 48px;
	height: 48px;
}
</style>
<link rel="stylesheet"
	href="resources/kindeditor/themes/default/default.css" />
<link rel="stylesheet"
	href="resources/kindeditor/plugins/code/prettify.css" />
<link rel="stylesheet" href="resources/bootstrap/css/bootstrap.css" />
<link rel="stylesheet"
	href="resources/bootstrap/css/bootstrap-theme.css" />
<script charset="utf-8" src="resources/jquery/jquery.min.js"></script>
<script charset="utf-8" src="resources/bootstrap/bootstrap.min.js"></script>
<script charset="utf-8" src="resources/kindeditor/kindeditor-all.js"></script>
<script charset="utf-8" src="resources/kindeditor/lang/zh-CN.js"></script>
<script charset="utf-8"
	src="resources/kindeditor/plugins/code/prettify.js"></script>

<script>
	var editor;
	KindEditor.ready(function(K) {
		var options = {
			cssPath : 'resources/kindeditor/plugins/code/prettify.css',
			filterMode : true,
			uploadJson : 'resources/kindeditor/jsp/upload_json.jsp',
			fileManagerJson : 'resources/kindeditor/jsp/file_manager_json.jsp',
			allowFileManager : true,
			afterUpload : function(url, data, name) { //上传文件后执行的回调函数，必须为3个参数
				if (name == "image" || name == "multiimage") { //单个和批量上传图片时
					var img = new Image();
					img.src = url;
					img.onload = function() { //图片必须加载完成才能获取尺寸
						if (img.width > 600)
							editor.html(editor.html().replace(
									'<img src="' + url + '"',
									'<img src="' + url
											+ '" width="200" height="200"'))
					}
				}
			}
		};
		editor = K.create('textarea[name="content"]', options);
		prettyPrint();
	});

	//自己的昵称
	var nickname = "kehu"+ Math.floor(Math.random()*10+1);
	//建立一条与服务器之间的连接
	var socket = new WebSocket(
			"ws://${pageContext.request.getServerName()}:${pageContext.request.getServerPort()}${pageContext.request.contextPath}/websocket");
	//在连接成功连接server后想服务器发送身份信息
	socket.onopen = function(ev) {
		var obj = JSON.stringify({
			nickname : nickname
		});
		socket.send(obj);
	}
	//接收服务器的消息
	socket.onmessage = function(ev) {
		var data = JSON.parse(ev.data);
		var message = JSON.parse(data.message)

		var box = $("#msgtmp").clone(); //复制一份模板，取名为box
		box.show(); //设置box状态为显示
		box.appendTo("#chatContent"); //把box追加到聊天面板中
		if (message.sender == "kefu") {
			box.find('img').attr("src", "resources/img/pika.png");
		} else {
			box.find('img').attr("src", "resources/img/duola.jpg");
		}
		box.find('[ff="nickname"]').html(message.sender); //在box中设置昵称
		box.find('[ff="msgdate"]').html(message.time); //在box中设置时间
		box.find('[ff="content"]').html(message.content); //在box中设置内容
		// 		box.addClass(msg.isSelf ? 'am-comment-flip' : ''); //右侧显示
		// 		box.addClass(msg.isSelf ? 'am-comment-warning' : 'am-comment-success');//颜色
		// 		box.css((msg.isSelf ? 'margin-left' : 'margin-right'), "20%");//外边距
		// 		$("#ChatBox div:eq(0)").scrollTop(999999); //滚动条移动至最底部

		// 		$("ul").append("<li>" + message + "</li>");
	}
	
	String.prototype.replaceAll = function(search, replacement) {
		var target = this;
		return target.replace(new RegExp(search, 'g'), replacement);
	};

	function msg() {
		editor.sync();
		var txt = $("#editor_id").val().replaceAll("\n", "").replaceAll("\r", "").replaceAll("\t", "");
		var obj = JSON.stringify({
			sender : nickname,
			receiver : "kefu",
			content : txt
		});
		// 发送消息
		socket.send(obj);
		// 		$("#editor_id").val("");
	}
</script>

</head>
<body>
	
	<div class="session">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">与客服聊天中。。。</h3>
			</div>
			<div class="panel-body">
				<div class="chat pre-scrollable">
					<ul id="chatContent">
						<li id="msgtmp" style="display: none"><a href=""> <img
								class="avatar" src="" alt="" />
						</a>
							<div class="main">
								<header class="am-comment-hd">
								<div class="am-comment-meta">
									<a ff="nickname" href="#link-to-user" class="am-comment-author"></a>
									<time ff="msgdate" datetime="" title=""></time>
								</div>
								</header>
								<div ff="content" class="am-comment-bd"></div>
							</div></li>
					</ul>
				</div>
			</div>
			<div class="panel-footer">
				<form class="editarea" method="post">
					<textarea id="editor_id" name="content"
						style="width: 100%; height: 100px;">&lt;strong&gt;HTML内容&lt;/strong&gt;</textarea>
					<input id="send" type="button" value="发送" onclick="msg()">
				</form>
			</div>
		</div>


	</div>
</body>
</html>