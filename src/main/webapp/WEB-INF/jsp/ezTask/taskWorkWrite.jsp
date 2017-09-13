<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html">
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezTask.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezTask/task_write_Cross.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachItem_CK.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachMain_CK.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			var userid = "${userInfo.id }";
	        var username = "${userInfo.displayName }";
	        var username2 = "${userInfo.displayName1 }";
	        var deptname = "${userInfo.deptName }";
	        var deptname2 = "${userInfo.deptName1 }";
	        var taskid = "${taskInfoVO.taskID }";
	        var hasattach = "${taskInfoVO.personAttach }";
	        var personContentpath = "${taskInfoVO.personContentPath }";
	        var AttachLimit = 1024;
	        
	        window.onload = function () {
	        	if (hasattach == "Y") {
		            setAttachFileInfo("${taskWorkAttachList}");
		        }
	        }
	        
	        window.onresize = function () {
	            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 230 + "PX";
	         }
	        
			function Editor_Complete() {
	            if (taskid != "" && personContentpath != "") {
	                $.ajax({
		                type : "POST",
		                dataType : "text",
		                async : false,
		                url : "/ezCommon/mhtToHTMLContent.do",
		                data : {
		                      type : "TASKCONTENT2",
		                      itemID : personContentpath
		                },
		                success: function(result){
		                	message.SetEditorContent(result);
		                }
	                });
	                
					try {
	                    var objTags = document.getElementById('message').getElementsByTagName("a");
	
	                    for (var i = 0 ; i < objTags.length ; i++) {
	                        if (objTags.item(i).href.indexOf("javascript:") == -1)
	                            objTags.item(i).target = "_blink";
	                    }
	                }
	                catch (e) { }
				}
			}
			
			function close_onclick() {
			    if (!confirm("" + strLang8 + "")) {
					parent.DivPopUpHidden();
					window.close();
			    } else {
			    	save_taskWork();
			    }
			}
			
			function beforeprint() {
				$(".popup").css('background-image', 'none');
				
				document.getElementById("main_body").style.display = "none";
				document.getElementById("printScreen").style.display = "";
				
				var filehtml = "";
				var nodes;
				nodes = dadiframe.filelist.childNodes;
				for (i = 1; i < nodes.length; i++) {
				    filehtml = filehtml + "<span><input type='checkbox'><img src='/images/email/mail_006.gif'> " + getNodeText(nodes[i].childNodes[1]) + "&nbsp;&nbsp;<br></span>";
				}
				document.getElementById("printAttach").innerHTML = filehtml;
				document.getElementById("printDocument").innerHTML = message.GetEditorContent();
				
				window.print();
				
				$(".popup").css("background-image", "url('/images/kr/cm/popup_bg.gif')");
				
				document.getElementById("main_body").style.display = "";
				document.getElementById("printScreen").style.display = "none";
			}
		</script>
	</head>
	<body class="popup" style="overflow: hidden;">
		<div id="main_body">
			<table id="normalScreen" class="layout">
				<tr>
					<td height="20" id="menuTable">
						<div id="menu">
							<ul>
								<li><span onClick="save_taskWork()"><spring:message code='ezTask.t96' /></span></li>
								<li><span onClick="beforeprint()"><spring:message code='ezTask.t153' /></span></li>
							</ul>
						</div>
						
						<div id="close">
							<ul>
								<li><span onClick="close_onclick()"><spring:message code='ezTask.t9' /></span></li>
							</ul>
						</div>
					</td>
				</tr>
				<tr>
					<td class="popup_title_txt" style="padding:0px;"><img src="/images/popup_title_icon.gif" class="popup_title_img">
						<spring:message code='ezTask.lhj06' />
					</td>
				</tr>
				<tr>
					<td id="EdtorSize" style="height:100%;">
						<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 97%; width: 99.7%; overflow: auto;"></iframe>
					</td>
				</tr>
				<tr>
					<td>
						<br/>
						<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezTask/dragAndDrop.do"></iframe>
					</td>
	            </tr>
			</table>
		</div>
		<div id="printScreen" style="display: none">
			<table class="content">
				<tr>
					<td class="popup_title_txt"><img src="/images/popup_title_icon.gif" class="popup_title_img"><spring:message code='ezTask.lhj06' /></td>
				</tr>
				<tr style="width:100%;">
					<td colspan="2"><div id="printDocument" style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; width: 100%; padding-top: 5px"></div></td>
				</tr>
				<tr>
					<th><spring:message code='ezTask.t160' /></th>
					<td><div id="printAttach"></div></td>
				</tr>
			</table>
		</div>
		<script>
			document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 230 + "PX";
		</script>
	</body>
</html>