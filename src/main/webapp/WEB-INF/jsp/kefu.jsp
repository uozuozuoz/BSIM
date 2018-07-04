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

#userlist {
	padding: 0;
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

.user {
	height: 60px;
	border: 1px solid pink;
}

.nav-link {
	position: relative;
	padding: 0 14px;
	line-height: 34px;
	font-size: 10px;
	font-weight: bold;
	color: #555;
	text-decoration: none;
}

.nav-link:hover {
	color: #333;
	text-decoration: underline;
}

.nav-counter {
	position: absolute;
	top: -1px;
	right: 1px;
	min-width: 8px;
	height: 20px;
	line-height: 20px;
	margin-top: -11px;
	padding: 0 6px;
	font-weight: normal;
	color: white;
	text-align: center;
	text-shadow: 0 1px rgba(0, 0, 0, 0.2);
	background: #e23442;
	border: 1px solid #911f28;
	border-radius: 11px;
	background-image: -webkit-linear-gradient(top, #e8616c, #dd202f);
	background-image: -moz-linear-gradient(top, #e8616c, #dd202f);
	background-image: -o-linear-gradient(top, #e8616c, #dd202f);
	background-image: linear-gradient(to bottom, #e8616c, #dd202f);
	-webkit-box-shadow: inset 0 0 1px 1px rgba(255, 255, 255, 0.1), 0 1px
		rgba(0, 0, 0, 0.12);
	box-shadow: inset 0 0 1px 1px rgba(255, 255, 255, 0.1), 0 1px
		rgba(0, 0, 0, 0.12);
}

.nav-counter-green {
	background: #75a940;
	border: 1px solid #42582b;
	background-image: -webkit-linear-gradient(top, #8ec15b, #689739);
	background-image: -moz-linear-gradient(top, #8ec15b, #689739);
	background-image: -o-linear-gradient(top, #8ec15b, #689739);
	background-image: linear-gradient(to bottom, #8ec15b, #689739);
}

.nav-counter-blue {
	background: #3b8de2;
	border: 1px solid #215a96;
	background-image: -webkit-linear-gradient(top, #67a7e9, #2580df);
	background-image: -moz-linear-gradient(top, #67a7e9, #2580df);
	background-image: -o-linear-gradient(top, #67a7e9, #2580df);
	background-image: linear-gradient(to bottom, #67a7e9, #2580df);
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
	var msgCount = 0;
	// 	浏览器窗口焦点的判断
	var isWindowFocus = true;
	function focusin() {
		isWindowFocus = true;
		var nowSession = $(':visible #sessions .session :visible').parent(".session");
		$("a[href='#"+nowSession.attr("id")+"'] .nav-counter").hide();
		$("#" + nowSession.attr("id") + " .msgCount").val(0);
		
	}
	function focusout() {
		isWindowFocus = false;

	}
	// 	浏览器窗口焦点的切换

	window.onfocus = focusin;
	window.onblur = focusout;

	var flashTitleRun = false;
	var flashStep = 0;
	var normalTitle = "与客户聊天中。。。";
	function flashTitle() {
		if (isWindowFocus) {
			document.title = normalTitle;
			flashTitleRun = false;
			return;
		} else {
			flashTitleRun = true;
			flashStep++;
			if (flashStep == 3) {
				flashStep = 1;
			}
			if (flashStep == 1) {
				document.title = "【有新消息。。。】";
			}
			if (flashStep == 2) {
				document.title = "【。。。有新消息 】";
			}

			setTimeout("flashTitle()", 500);
		}
	}

	function doFlashTitle() {
		if (!flashTitleRun) {
			flashTitle();
		}
	}
	


	var editor;
	function createKE() {
		var ed;
		var options = {
			cssPath : 'resources/kindeditor/plugins/code/prettify.css',
			filterMode : true,
			items : [ 'emoticons', 'image' ],
			uploadJson : 'resources/kindeditor/jsp/upload_json.jsp',
			fileManagerJson : 'resources/kindeditor/jsp/file_manager_json.jsp',
			allowFileManager : true,
			afterUpload : function(url, data, name) { //上传文件后执行的回调函数，必须为3个参数
				if (name == "image" || name == "multiimage") { //单个和批量上传图片时
					var img = new Image();
					img.src = url;
					img.onload = function() { //图片必须加载完成才能获取尺寸
						if (img.width > 200)
							editor.html(editor.html().replace(
									'<img src="' + url + '"',
									'<img src="' + url + '" width="200"'));
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
					li.find('a').html(obj[i] + '<div class="nav-counter nav-counter-blue" style="display:none"></div>');

					let session = $("#session").clone();

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
														"session")[1] + "聊天中");
								$("a[href='#"+session.attr("id")+"'] .nav-counter").hide();
								$("#" + session.attr("id") + " .msgCount").val(0);
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

				if (isWindowFocus) {
					msgCount = 0;
					$("#session" + obj + " .msgCount").val(0);
					$("a[href='#session" + obj + "'] .nav-counter").hide();
				} else {
					$("a[href='#session" + obj + "'] .nav-counter").show();
					msgCount = $("#session" + obj + " .msgCount").val();
					msgCount++;
					$("#session" + obj + " .msgCount").val(msgCount);

				}

				$("a[href='#session" + obj + "'] .nav-counter").html(msgCount);
				msgCount = 0;
				doFlashTitle();
			}

			box.find('[ff="nickname"]').html(message.sender); //在box中设置昵称
			box.find('[ff="msgdate"]').html(message.time); //在box中设置时间
			box.find('[ff="content"]').html(message.content); //在box中设置内容
			box.addClass(message.isSelf ? 'self' : ''); //右侧显示
			// 						box.appendTo("#userlist"); //把box追加到聊天面板中
			box.appendTo("#chatContent" + obj); //把box追加到聊天面板中
			box[0].scrollIntoView();
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
				.replaceAll("\t", "").replaceAll("\u200B", "");

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
	
	
	function reset() {

		editor.html("");
	}
	
	document.onkeydown=function(){
		if(event.keyCode==13){
			var nowSession = $(':visible #sessions .session :visible').parent(".session");
			nowSession.find("input[value='发送']").click();
		}
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
					<div class="panel-body" style="height: 560px">
						<!-- 			用户li模板 -->
						<li id="user" class="user" style="display: none"><a href=""
							class="nav-link"></a></li>

						<ul id="userlist">

						</ul>
					</div>
					<div class="panel-footer"></div>
				</div>

			</div>

			<!-- 			会话模板 -->
			<div id="session" class="session" style="display: none">
				<input class="msgCount" style="display: none" value>
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
							<input type="button" value="清空" onclick="reset()">
						</form>
					</div>
				</div>
			</div>
			<div id="sessions"></div>

		</div>
	</div>
</body>
</html>