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

.avatar {
	width: 48px;
	height: 48px;
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
	socket.onopen = function(ev) {
		var obj = JSON.stringify({
			nickname : nickname
		});
		socket.send(obj);
	}
	//接收服务器的消息
	socket.onmessage = function(ev) {
		var data = JSON.parse(ev.data);
		var obj = data.users;

		if (obj != null) {
			$(".users ul").html("");
			for (var i = 0; i < obj.length; i++) {
				if (obj[i] == "客服") {

				} else {
					var li = $("#user").clone(); //复制一份模板，取名为box
					li.show(); //设置box状态为显示
					li.appendTo("#userlist"); //把box追加到聊天面板中
					li.attr("id", obj[i]); //在box中设置昵称
					li.find('a').attr("href", "#session" + obj[i]); //在box中设置昵称
					li.find('a').on('click', function() {
						$('#session' + obj[i]).toggleClass('hidden');
					})
					li.find('a').html(obj[i]); //在box中设置昵称

					var session = $("#session").clone(); //复制一份模板，取名为box
					session.appendTo(".up"); //把box追加到聊天面板中
					session.attr("id", "session" + obj[i]); //在box中设置昵称

				}

			}

		} else {

			var message = JSON.parse(data.message);
			var box = $("#msgtmp").clone(); //复制一份模板，取名为box
			box.show(); //设置box状态为显示
			box.appendTo("#chatContent"); //把box追加到聊天面板中
			if (message.sender == "客服") {
				box.find('img').prop("src", "resources/img/pika.png");
			} else {
				box.find('img').prop("src", "resources/img/duola.jpg");
			}
			box.find('[ff="nickname"]').html(message.sender); //在box中设置昵称
			box.find('[ff="msgdate"]').html(message.time); //在box中设置时间
			box.find('[ff="content"]').html(message.content); //在box中设置内容
			//	 		box.addClass(msg.isSelf ? 'am-comment-flip' : ''); //右侧显示
			//	 		box.addClass(msg.isSelf ? 'am-comment-warning' : 'am-comment-success');//颜色
			//	 		box.css((msg.isSelf ? 'margin-left' : 'margin-right'), "20%");//外边距
			//	 		$("#ChatBox div:eq(0)").scrollTop(999999); //滚动条移动至最底部
			// 			$(".session ul").append("<li>" + msg + "</li>");
		}

	}

	function msg() {
		editor.sync();
		var txt = $("#editor_id").val();
		var obj = JSON.stringify({
			sender : nickname,
			receiver : "风清扬",
			content : txt
		});
		// 发送消息
		socket.send(obj);
		$("#editor_id").val("");
	}
</script>
</head>
<body>
	<div class="bg">
		<div class="up">
			<div class="users">
				<ul id="userlist">
					<li id="user" style="display: none"><a href="">00</a></li>
				</ul>
			</div>
			<div id="session" class="session" style="display: none">
				<div class="chat">
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