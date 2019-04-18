<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>연차취소신청</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezSchedule.e3', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_write_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/TabMenu.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/lang/ezSchedule.js')}"></script>
		
		<script type="text/javascript">
			var formHtml = '${formInfo.formHtml}';
			var typeId = "<c:out value='${attitudeInfo.typeId}'/>";
			var typeName = "<c:out value='${attitudeInfo.typeName}'/>";
			var writerName = "<c:out value='${attitudeInfo.writerName}'/>";
			var region = "<c:out value='${attitudeInfo.region}'/>";
			var mobile = "<c:out value='${attitudeInfo.mobile}'/>";
			var bizSub = "<c:out value='${attitudeInfo.bizSub}'/>";
			var attitudeId = "<c:out value='${attitudeInfo.attitudeId}'/>";
			var dateType = "<c:out value='${attitudeInfo.dateType}'/>";
			var startDate = "<c:out value='${attitudeInfo.startDate}'/>";
			var endDate = "<c:out value='${attitudeInfo.endDate}'/>";
			var font = "<c:out value='${font}'/>"
			
			window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    }
			
			window.onload = function () {
				setHtml();
			}
			
			window.onresize = function () {   	
                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 200 + "PX";
		    }
			
			function Editor_Complete() {
				message.SetEditorContent("");
		    }
			
			function setHtml() {
				$("#attiInfoView").append(formHtml);
				
				$("#attiInfoView tr td *").remove();
				
				//유형명
            	typeName = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&amp;", "&"), "&#39;", "'"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"'), "&amp;", "&");
				
				$("#typeName").text(" " + typeName);
				$("#writerName").text(" " + writerName);
				$("#region").html(" " + region);
				$("#mobile").html(" " + mobile);
				$("#bizsub").html(" " + bizSub);
				
				var showTime = "";
				switch (dateType) {
					case "1":
						showTime = startDate.substring(0, 10);
						break;
					case "2":
						showTime = startDate.substring(0, 16);
						break;
					case "3":
						showTime = startDate.substring(0, 16) + " ~ " + endDate.substring(11, 16);
						break;
					case "4":
						showTime = startDate.substring(0, 10) + " ~ " + endDate.substring(0, 10);
						break;
					case "5":
						showTime = startDate.substring(0, 16) + " ~ " + endDate.substring(0, 16);
						break;
				}
				
				$("#attiTime").text(" " + showTime);
			}
			
			//삭제
			function saveCancelAnnual() {
				var obj = new Object();
				obj.attitudeId = attitudeId;
		    	obj.content = message.GetEditorContent();
				$.ajax({
					type : "POST",
					async : true,
					url : "/ezAttitude/saveCancelAnnual.do",
					dataType : "text",
					data : obj,
					success : function(resultStatus) {
	            		if (resultStatus == "success") {
	            			try {
								window.opener.getUserAnnualList();
								window.opener.parent.frames["left"].getAttitudeList();
	            			} catch (e) { }
							window.close();
	            		} else {
	            			alert("<spring:message code='ezAttitude.t175' />");
	            		}
					},
					error: function(xhr, status, error){
				    	alert("<spring:message code='ezAttitude.t175' />");
				    }
				})
			}
			
			//메일로발송
			function sendMailAttitude() {
				var pheight = window.screen.availHeight;
				var conHeight = pheight * 0.8;
				var pwidth = window.screen.availwidth;
				var pTop = (pheight - conHeight) / 2;
				var pLeft = (pwidth - 890) / 2;
				var szUrl = "/ezEmail/mailWrite.do?attitudeId=" + attitudeId + "&cmd=attitude";
				window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height=" + conHeight + "px, width=890px, status=no, toolbar=no, menubar=no, location=no, resizable=1");
				window.close();
			}
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<form method="post">
	        <div id="main_body">
	            <table id="normalScreen" class="layout">
	                <tr>
	                    <td style="height: 20px">
	                        <div id="menu">
	                        	<ul id="menuTable">	
	                                <li class="sel"><h1 style="padding:0px; margin-top:-5px;">연차취소신청</h1></li>
	                            </ul>
	                        </div>
	                        <div id="close">
	                            <ul>
	                                <li><span onclick="window.close()"></span></li>
	                            </ul>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="height: 20px">
	                        <table id="attiInfoView" class="content" style="margin-top:5px">
	                               <tr id="HolderWrite">
	                                   <th><spring:message code='ezAttitude.t134'/></th>
	                                   <td id="typeName" colspan="2">
	                                   </td>
	                               </tr>
	                        </table>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="vertical-align:top;height:100%;" id="EdtorSize">
		                    <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding:0; height:100%; width:100%; overflow:auto; margin-top:-1px"></iframe>
	                    </td>
	                </tr>
	            </table>
	            <div class="btnpositionNew" id="menuTable">
	            	<c:if test="${userId == attitudeInfo.writerId}">
						<a class="imgbtn"><span onclick="saveCancelAnnual();">취소신청</span></a>
					</c:if>
	            </div>
	        </div>
	        <script type="text/javascript">
		        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 200 + "PX";
		    </script>
	    </form>
	</body>
</html>