<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t159'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
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
			var font = "<c:out value='${font}'/>";
			var authFlag = "<c:out value='${authFlag}'/>";
			var uselang = "<c:out value='${userInfo.lang}'/>";
			
			window.onload = function () {
				setHtml();
			}
			
			function setHtml() {
				$("#attiInfoView").append(formHtml);
				
				$("#attiInfoView tr td *").remove();
				
				//유형명
            	typeName = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&amp;", "&"), "&#39;", "'"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"'), "&amp;", "&");
            	
				if (uselang != "1") {		
					$("#writerName").siblings("th").text("<spring:message code='ezAttitude.t93'/>");
					$("#attiTime").siblings("th").text("<spring:message code='ezAttitude.t149'/>");
					$("#mobile").siblings("th").text("<spring:message code='ezOrgan.t285'/>");
					$("#bizsub").siblings("th").text("<spring:message code='ezAttitude.t311'/>");
				}
            	
				$("#typeName").text(" " + typeName);
				$("#writerName").text(" " + writerName);
				$("#region").html(" " + region);
				$("#mobile").html(" " + mobile);
				$("#bizsub").html(" " + bizSub);
				
				var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write('${attitudeInfo.content}');
				doc.close();
				
				$("#message").css("height", document.documentElement.clientHeight - $("#normalScreen tr:eq(1)").css("height").substring(0, $("#normalScreen tr:eq(1)").css("height").length - 2) - 125 + "PX");
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
			
			function deleteAttitude() {
				var delFlag = confirm("<spring:message code='ezAttitude.t160'/>");
				if (delFlag) {
					$.ajax({
						type : "POST",
						async : true,
						url : "/ezAttitude/adminAttiDelItem.do",
						dataType : "text",
						data : {
							attitudeId : attitudeId,
							mode : "admin"
						},
						success : function(resultStatus) {
							if (resultStatus == "success") {
								try {
									window.opener.getList();
								} catch (e) {
									window.opener.getAttitudeCheckList();
								}
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
			
			function modifyAttitude() {
// 				var openWin = null;

// 				if (CrossYN()) {
//                     openWin = window.open("/ezAttitude/attAdminModItem.do?attitudeId=" + attitudeId + "&mode=mod", "attitudeNewItem", GetOpenWindowfeature(672, 640));
                    
//                     try { openWin.focus(); } catch (e) { }
// 	            } else {
//                 	openWin = window.showModalDialog("/ezAttitude/attAdminModItem.do?attitudeId=" + attitudeId + "&mode=mod", "",
//                         "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
//                 	 try { openWin.focus(); } catch (e) { }
// 	            }
				window.location.href = "/ezAttitude/attAdminModItem.do?attitudeId=" + attitudeId + "&mode=mod";
// 				window.close();
			}
			
			function sendMailAttitude() {
				var pheight = window.screen.availHeight;
				var conHeight = pheight * 0.8;
				var pwidth = window.screen.availwidth;
				var pTop = (pheight - conHeight) / 2;
				var pLeft = (pwidth - 1200) / 2;
				var szUrl = "/ezEmail/mailWrite.do?attitudeId=" + attitudeId + "&cmd=attitude";
				window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height=" + conHeight + "px, width=1200px, status=no, toolbar=no, menubar=no, location=no, resizable=1");
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
	                                   <th><div style="width:15%"><spring:message code='ezAttitude.t134'/></div></th>
	                                   <td id="typeName" colspan="2">
	                                   </td>
	                               </tr>
	                        </table>
	                    </td>
	                </tr>
	                <tr>
		                <td class="pad1" style="vertical-align: top; height: 100%" id="messagetd">
		                    <iframe id="message" style="border: #ddd 1px solid; padding-left: 5px; overflow: auto;width: 99.1%; padding-top: 6px; height: 337px; background-color: white"></iframe>	                    
		                </td>
	            	</tr>
	            </table>
	            <ul style="float:right;margin-right:50px">
	                            	<c:if test="${authFlag == 'M' }">
		                                <li id="menuTable" style="background: none; border: none;">	
		                                	<span onclick="modifyAttitude()"><spring:message code='ezAttitude.t163'/></span>
		                            		<span onclick="deleteAttitude()"><spring:message code='ezAttitude.t164'/></span>
										</li>
									</c:if>          
								</ul>
	            <div class="btnpositionNew" id="menuTable">
	            	<c:if test="${authFlag == 'M' }">
                       	<a class="imgbtn"><span onclick="modifyAttitude()"><spring:message code='ezAttitude.t163'/></span></a>
                   		<a class="imgbtn"><span onclick="deleteAttitude()"><spring:message code='ezAttitude.t164'/></span></a>
					</c:if>
				</div>
	        </div>
	    </form>
	</body>
</html>