<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>与客户聊天中</title>
<style>
body {
	background: url(resources/img/18.jpg) round;
}

.bg {
	position: relative;
	width: 100%;
	height: 100%;
	top: 0;
	bottom: 0;
}

.up {
	width: 1000px;
	height: 100%;
	margin: 0 auto;
}

.users {
	width: 30%;
	height: 100%;
	margin-top: 100px;
	width: 30%;
	float: left;
}

#sessions {
	height: 100%;
}

.session {
	width: 68%;
	height: 100%;
	margin-left: 20px;
	margin-top: 100px;
	float: left;
}

.chat {
	width: 100%;
	height: 362px;
	margin: auto;
}

.editarea {
	width: 100%;
	height: 30%;
	margin: auto;
}

li {
	list-style-type: none;
}

.avatar {
	width: 48px;
	height: 48px;
}

.self {
	text-align: right;
}

.am-comment-bd img:hover {
	cursor: zoom-in;
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
<script charset="utf-8" src="resources/bootstrap/js/bootstrap.min.js"></script>
<script charset="utf-8" src="resources/js/zoom.js"></script>
<script charset="utf-8" src="resources/kindeditor/kindeditor-all.js"></script>
<script charset="utf-8" src="resources/kindeditor/lang/zh-CN.js"></script>
<script charset="utf-8"
	src="resources/kindeditor/plugins/code/prettify.js"></script>

<script>
	$(function() {
		$(".am-comment-bd img").on(
				"click",
				function() {
					console.log("ss")
					$(".bigimg").attr("src", $(event.srcElement).attr("src"))
							.attr("style",
									"width:" + $(event.srcElement).width * 2);
				})

	})

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
							// 							editor.html(editor.html().replace(
							// 									'<img src="' + url + '"',
							// 									'<img src="' + url + '" width="200"'))
							editor.html(editor.html().replace(
									'<img src="' + url + '"',
									'<img src="' + url + '" width="200"'))
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
			$("#sessions").html("");
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
					li.find('a').on(
							'click',
							function() {

								$("#sessions .session").hide();
								session.show();
								editor = createKE();
								session.find(".panel-title").html(
										"与"
												+ session.attr("id").split(
														"session")[1] + "聊天中")
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
			box.addClass(message.isSelf ? 'self' : ''); //右侧显示
			// 						box.appendTo("#userlist"); //把box追加到聊天面板中
			box.appendTo("#chatContent" + obj); //把box追加到聊天面板中
			var chatNode = $("#chatContent" + obj);

		}

	}
	String.prototype.replaceAll = function(search, replacement) {
		var target = this;
		return target.replace(new RegExp(search, 'g'), replacement);
	};

	function msg(node) {

		var fnode = node.parentNode.parentNode.parentNode.parentNode;
		editor.sync();
		var textarea = $(node).siblings("textarea");
		var txt = textarea.val().replaceAll("\n", "").replaceAll("\r", "")
				.replaceAll("\t", "");

		var receiverid = fnode.id.split("session")[1].trim();
		if (txt.length == 0) {
			return;
		}
		var obj = JSON.stringify({
			sender : nickname,
			receiver : receiverid,
			content : txt
		});
		// 发送消息
		socket.send(obj);
		editor.html("");
	}
</script>
</head>
<body>
	<div class="bg">
		<div class="up">

			<div class="users">
				<div class="panel panel-primary">
					<div class="panel-heading">
						<h3 class="panel-title">客户列表</h3>
					</div>
					<div class="panel-body" style="height: 626px">
						<!-- 			用户li模板 -->
						<li id="user" style="display: none"><a href="">00</a></li>

						<ul id="userlist">

						</ul>
					</div>
					<div class="panel-footer"></div>
				</div>

			</div>

			<!-- 			会话模板 -->
			<div id="session" class="session" style="display: none">
				<div class="panel panel-primary">
					<div class="panel-heading">
						<h3 class="panel-title">与聊天中</h3>
					</div>
					<div class="panel-body">
						<div class="chat pre-scrollable" style="max-height: 362px">
							<ul id="chatContent">
								<li style="display: none"><a href=""> <img
										class="avatar" src="" alt="" />
								</a>
									<div class="main">
										<header class="am-comment-hd">
										<div class="am-comment-meta">
											<a ff="nickname" href="#link-to-user"
												class="am-comment-author">某人</a>
											<time ff="msgdate" datetime="" title="">时间</time>
										</div>
										</header>
										<div ff="content" class="am-comment-bd">内容</div>
									</div></li>
							</ul>
						</div>
					</div>
					<div class="panel-footer">
						<form class="editarea" method="post">
							<textarea name="content" style="width: 100%; height: 112px;">&lt;strong&gt;HTML内容&lt;/strong&gt;</textarea>
							<input type="button" value="发送" onclick="msg(this)">
						</form>
					</div>
				</div>
			</div>
			<div id="sessions"></div>

		</div>
	</div>
</body>
</html>