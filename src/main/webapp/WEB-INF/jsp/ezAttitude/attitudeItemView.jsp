<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t158'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		
		<script type="text/javascript" src="/js/ezSchedule/schedule_write_Cross.js"></script>
		<script type="text/javascript" src="/js/ezSchedule/Calendar/TabMenu.js"></script>
	    <script type="text/javascript" src="/js/ezSchedule/lang/ezSchedule.js"></script>
		
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
				setHtml();
			}
			
			function setHtml() {
				$("#attiInfoView").append(formHtml);
				
				$("#attiInfoView tr td *").remove();
				
				//유형명
            	typeName = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&amp;", "&"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"'), "&amp;", "&");
				
				$("#typeName").text(" " + typeName);
				$("#writerName").text(" " + writerName);
				$("#region").html(" " + region);
				$("#mobile").html(" " + mobile);
				$("#bizsub").html(" " + bizSub);
				
				var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write('${attitudeInfo.content}');
				doc.close();
				
				$("#message").css("height", document.documentElement.clientHeight - $("#normalScreen tr:eq(1)").css("height").substring(0, $("#normalScreen tr:eq(1)").css("height").length - 2) - 75 + "PX");
				//region == "" ? $("#message").css("height","405px") : $("#message").css("height", "380px"); 
				
				var fontFamily = font.split("|")[0];
				var fontSize = font.split("|")[1];
				$("#message").contents().find("p").each(function(){
					$(this).css({"font-size":fontSize, "font-family":fontFamily});	
				});
				
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
			function deleteAttitude() {
				var delFlag = confirm("<spring:message code='ezAttitude.t160'/>");
				if (delFlag) {
					$.ajax({
						type : "POST",
						async : true,
						url : "/ezAttitude/attitudeDeleteItem.do",
						dataType : "text",
						data : {
							attitudeId : attitudeId
						},
						success : function(resultStatus) {
		            		if (resultStatus == "success") {
		            			try {
									window.opener.getAttitudeMainList();
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
			}
			
			//수정
			function modifyAttitude() {
				var openWin = null;
				if (CrossYN()) {
                    openWin = window.open("/ezAttitude/attitudeNewItem.do?attitudeId=" + attitudeId + "&mode=mod", "attitudeNewItem", GetOpenWindowfeature(672, 640));
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	openWin = window.showModalDialog("/ezAttitude/attitudeNewItem.do?attitudeId=" + attitudeId + "&mode=mod", "",
                        "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
                	 try { OpenWin.focus(); } catch (e) { }
	            }
				openWin.opener = window.opener;
				window.close();
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
	                                <li class="sel"><h1 style="padding:0px; margin-top:-5px;"><spring:message code='ezAttitude.t159'/></h1></li>
	                            </ul>
	                            <ul style="float:right;margin-right:50px">
	                            	<c:if test="${userId == attitudeInfo.writerId}">
		                                <li id="menuTable" style="background: none; border: none;">	
											<span onclick="sendMailAttitude()"><spring:message code='ezAttitude.t162'/></span>
		                                	<span onclick="modifyAttitude()"><spring:message code='ezAttitude.t163'/></span>
		                            		<span onclick="deleteAttitude()"><spring:message code='ezAttitude.t164'/></span>
										</li>
									</c:if>          
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
		                <td class="pad1" style="vertical-align: top; height: 100%" id="messagetd">
		                    <iframe id="message" style="border: #ddd 1px solid; padding-left: 5px; overflow: auto;width: 99.1%; padding-top: 6px; height: 387px; background-color: white"></iframe>	                    
		                </td>
	            	</tr>
	            </table>
	        </div>
	    </form>
	</body>
</html>