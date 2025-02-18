<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezTask.lhj06'/></title>
		<title><spring:message code='ezTask.lhj06' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezTask.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/task_write_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/AttachItem_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/AttachMain_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var userid = "<c:out value='${userInfo.id }'/>";
	        var username = "<c:out value='${userInfo.displayName }'/>";
	        var username2 = "<c:out value='${userInfo.displayName1 }'/>";
	        var deptname = "<c:out value='${userInfo.deptName }'/>";
	        var deptname2 = "<c:out value='${userInfo.deptName1 }'/>";
	        var taskid = "<c:out value='${taskInfoVO.taskID }'/>";
	        var hasattach = "<c:out value='${taskInfoVO.personAttach }'/>";
	        var personContentpath = "${taskInfoVO.personContentPath }";
	        var AttachLimit = 1024;
	        var defaultFont = "<spring:message code='main.t246' />";
	        var defaultFontAndSize = "style='font-size:13px;font-family:" + defaultFont + "'";
	        
	        window.onload = function () {
	        	if (hasattach == "Y") {
		            setAttachFileInfo("${taskWorkAttachList}");
		        } 	        	
	        }
	        
	        window.onresize = function () {
	            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 240 + "PX";
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
				} else {
					message.SetEditorContent("");
				}
			}
			
			function close_onclick() {
/* 			    if (!confirm("" + strLang8 + "")) {
					parent.DivPopUpHidden();
					window.close();
			    } else {
			    	save_taskWork();
			    } */
				parent.DivPopUpHidden();
				window.close();
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
						<div class="new_popup_title_txt" id="taskChangeMode">
							<c:if test="${taskInfoVO.taskType != 4 && taskInfoVO.taskType != 1}"><spring:message code='ezTask.jjh02' /></c:if>
							<c:if test="${taskInfoVO.taskType == 4 || taskInfoVO.taskType == 1}"><spring:message code='ezTask.t1511' /></c:if>
						</div>
						<div id="menu" style="float: right; padding-right: 42px;">
							<ul>
								<%-- <li><span onClick="beforeprint()"><spring:message code='ezTask.t153' /></span></li> --%>
							</ul>
						</div>						
						<div id="close">
							<ul>
								<li><span onClick="close_onclick()"></span></li>
							</ul>
						</div>
						<script type="text/javascript">
							selToggleList(document.getElementById("menu"), "ul", "li", "0");
						</script>
					</td>
				</tr>
				<tr>
					<td id="EdtorSize" style="height:100%;">
						<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 100%; width: 99.7%; overflow: auto;"></iframe>
					</td>
				</tr>
				<tr>
					<td>
						<br/>
						<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezTask/dragAndDrop.do"></iframe>
					</td>
	            </tr>
			</table>
			<div class="btnposition btnpositionNew">
			    <a class="imgbtn" onClick="save_taskWork()" ><span><spring:message code='ezTask.t96'/></span></a>
			</div>
		</div>
		<div id="printScreen" style="display: none">
			<table class="content">
				<tr>
					<td colspan="2" class="popup_title_txt"><img src="/images/popup_title_icon.gif" class="popup_title_img"><spring:message code='ezTask.lhj06' /></td>
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
			document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 260 + "PX";
		</script>
	</body>
</html>