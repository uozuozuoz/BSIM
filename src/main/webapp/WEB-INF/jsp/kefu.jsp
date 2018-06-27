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
	function createKE() {
		var ed;
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
		var kep = $('.session :visible').find('textarea[name="content"]');
		ed = KindEditor.create(kep, options);
		prettyPrint();
		return ed;
	}

	//自己的昵称
	var nickname = "kefu";
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
			// 			$("#sessions").html("");
			for (var i = 0; i < obj.length; i++) {
				if (obj[i] == nickname) {

				} else {
					let li = $("#user").clone();
					li.show();
					li.appendTo("#userlist");
					li.attr("id", obj[i]);
					li.find('a').attr("href", "#session" + obj[i]);
					li.find('a').html(obj[i]);

					let session = $("#session").clone(true);
					session.appendTo("#sessions");
					session.attr("id", "session" + obj[i]);
					session.find("ul").attr("id", "chatContent" + obj[i]);
					li.find('a').on('click', function() {

						$("#sessions .session").hide();
						session.show();
						editor = createKE();
					})
				}

			}

		} else {

			var message = JSON.parse(data.message);
			var box = $("#chatContent li").clone(); //复制一份模板，取名为box
			box.show(); //设置box状态为显示
			var obj;

			if (message.sender == nickname) {
				obj = message.receiver;
				box.find('img').prop("src", "resources/img/pika.png");
			} else {
				obj = message.sender;
				box.find('img').prop("src", "resources/img/duola.jpg");
			}

			box.find('[ff="nickname"]').html(message.sender); //在box中设置昵称
			box.find('[ff="msgdate"]').html(message.time); //在box中设置时间
			box.find('[ff="content"]').html(message.content); //在box中设置内容
// 						box.appendTo("#userlist"); //把box追加到聊天面板中
			box.appendTo("#chatContent" + obj); //把box追加到聊天面板中
			console.log("#chatContent"+obj);
			var chatNode = $("#chatContent"+obj);

		}

	}

	function msg(node) {

		var fnode = node.parentNode.parentNode;
console.log(editor)
		editor.sync();
		var textarea = $(node).siblings("textarea");
		var txt = textarea.val();
		var receiverid = fnode.id.split("session")[1].trim();
		var obj = JSON.stringify({
			sender : nickname,
			receiver : receiverid,
			content : txt
		});
		// 发送消息
		socket.send(obj);

	}
</script>
</head>
<body>
	<div class="bg">
		<div class="up">
			<div class="users">
				<!-- 			用户li模板 -->
				<li id="user" style="display: none"><a href="">00</a></li>

				<ul id="userlist">

				</ul>
			</div>
			<!-- 			会话模板 -->
			<div id="session" class="session" style="display: none">
				<div class="chat">
					<ul id="chatContent">
						<li  style="display: none"><a href=""> <img
								class="avatar" src="" alt="" />
						</a>
							<div class="main">
								<header class="am-comment-hd">
								<div class="am-comment-meta">
									<a ff="nickname" href="#link-to-user" class="am-comment-author">某人</a>
									<time ff="msgdate" datetime="" title="">时间</time>
								</div>
								</header>
								<div ff="content" class="am-comment-bd">内容</div>
							</div></li>
					</ul>
				</div>

				<form class="editarea" method="post">
					<textarea name="content" style="width: 100%; height: 100px;">&lt;strong&gt;HTML内容&lt;/strong&gt;</textarea>
					<input type="button" value="发送" onclick="msg(this)">
				</form>
			</div>
			<div id="sessions"></div>

		</div>
	</div>

</body>
</html>