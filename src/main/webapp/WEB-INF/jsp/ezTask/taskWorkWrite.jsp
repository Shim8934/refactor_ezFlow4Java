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
			/* 필요하면 주석제거하고 하나씩 빼쓰자
	        var taskstatus = "${taskInfoVO.taskStatus }";
	        var completerate = "${taskInfoVO.completeRate }";
	        var startdate = "${taskInfoVO.startDate }";
	        var enddate = "${taskInfoVO.endDate }";
	        var importance = "${taskInfoVO.importance }";
	        var tasktype = "${taskInfoVO.taskType }";
	        var creatorid = "${taskInfoVO.creatorID }";
	        var hasattach = "${taskInfoVO.hasAttach }";
	        var hasshare = "${taskInfoVO.hasShare}";
	        var contentPath = "${taskInfoVO.contentPath }"; */
	        var personContentpath = "${taskInfoVO.personContentPath }";
			/* 필요하면 주석제거하고 하나씩 빼쓰자
	        var sharelist = "";
	        var g_person = null;
	        var g_share = null;
	        var shareid = "_shareid";
	        var sharename = "_sharename";
	        var sharename2 = "_sharename2";
	        var sharedept = "_sharedept";
	        var sharedept2 = "_sharedept2";
	        var sharemail = "_sharemail";
	        var isreadpage = false;
	        var FormProcSpelling = "FormProcSpelling";
	        var personid = "${taskInfoVO.personID }"; */
	        
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
	            }
	        }
		</script>
	</head>
	<body class="popup">
		<div id="main_body">
			<table id="normalScreen" class="layout">
				<tr>
					<td height="20" id="menuTable">
						<div id="menu">
							<ul>
								<li><span onClick="save_taskWork()"><spring:message code='ezTask.t96' /></span></li>
								<li><span onClick="window.print()"><spring:message code='ezTask.t153' /></span></li>
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
					<td id="EdtorSize" style="height:100%;">
						<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 97%; width: 99.7%; overflow: auto;"></iframe>
					</td>
				</tr>
				<tr>
					<td>
						<br/>
						<iframe id="dadiframe" name="dadiframe" style="width: 100%; border: 0px" src="/ezTask/dragAndDrop.do"></iframe>   
					</td>
	            </tr>
			</table>
		</div>
		<script>
			document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 250 + "PX";
		</script>
	</body>
</html>