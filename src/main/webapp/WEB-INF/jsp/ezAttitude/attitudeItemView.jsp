<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>근태 상세조회</title>
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
				
				$("#typeName").text(" " + typeName);
				$("#writerName").text(" " + writerName);
				$("#region").text(" " + region);
				$("#mobile").text(" " + mobile);
				$("#bizsub").text(" " + bizSub);
				
				var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write('${attitudeInfo.content}');
				doc.close();
				
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
				var delFlag = confirm("근태를 삭제하시겠습니까?");
				if (delFlag) {
					$.ajax({
						type : "POST",
						async : true,
						url : "/ezAttitude/attitudeDeleteItem.do",
						data : {
							attitudeId : attitudeId
						},
						success : function(result) {
							alert("근태를 삭제하였습니다.");
							window.opener.getAttitudeMainList();
							window.opener.parent.frames["left"].getAttitudeList();
							window.close();
						}
					})
				}
			}
			
			function modifyAttitude() {
				var openWin = null;
				if (CrossYN()) {
                    openWin = window.open("/ezAttitude/attitudeNewItem.do?attitudeId=" + attitudeId + "&mode=mod", "attitudeNewItem", GetOpenWindowfeature(810, 790));
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	openWin = window.showModalDialog("/ezAttitude/attitudeNewItem.do?attitudeId=" + attitudeId + "&mode=mod", "",
                        "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 520));
                	 try { OpenWin.focus(); } catch (e) { }
	            }
				openWin.opener = window.opener;
				window.close();
			}
			
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
	                            	<li><span onclick="sendMailAttitude()">메일로 발송</span></li>
	                                <li><span onclick="modifyAttitude()">수정</span></li>
	                            	<li><span onclick="deleteAttitude()">삭제</span></li>
	                            </ul>
	                        </div>
	                        <div id="close">
	                            <ul>
	                                <li><span onclick="window.close()"><spring:message code='ezSchedule.t16'/></span></li>
	                            </ul>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="height: 20px">
	                        <table id="attiInfoView" class="content">
	                               <tr id="HolderWrite">
	                                   <th>구분</th>
	                                   <td id="typeName" colspan="2">
	                                   </td>
	                               </tr>
	                        </table>
	                    </td>
	                </tr>
	                <tr>
		                <td class="pad1" style="vertical-align: top; height: 100%" id="messagetd">
		                    <iframe id="message" style="border: #ddd 1px solid; padding-left: 5px; overflow: auto;width: 99.1%; padding-top: 6px; height: 600px; background-color: white"></iframe>	                    
		                </td>
	            	</tr>
	            </table>
	        </div>
	    </form>
<!-- 		<div id="menu"> -->
<!-- 			<ul> -->
<!-- 				<li><span onClick="sendMailAttitude()">메일로 발송</span></li> -->
<!-- 			</ul> -->
<!-- 			<ul> -->
<!-- 				<li><span onClick="modifyAttitude()">수정</span></li> -->
<!-- 			</ul> -->
<!-- 			<ul> -->
<!-- 				<li><span onClick="deleteAttitude()">삭제</span></li> -->
<!-- 			</ul> -->
<!-- 		</div> -->
<!-- 		<div id="close"> -->
<!-- 			<ul> -->
<!-- 				<li><span onClick="window.close()">닫기</span></li> -->
<!-- 			</ul> -->
<!-- 		</div> -->
<!-- 		<div id="contentDiv"> -->
<!-- 			<table id="attiInfoView" class="content"> -->
<!-- 				<tbody> -->
<!-- 					<tr> -->
<!-- 		    			<th>구분</th>  -->
<!-- 		    			<td id="typeName"></td>  -->
<!-- 		  			</tr> -->
<!-- 	  			</tbody> -->
<!-- 			</table> -->
<!-- 			<table class="content" style="width:100%; margin-top: 10px;"> -->
<!-- 				<tr> -->
<!-- 				  	<td style="height: 300px; margin:0px; padding:0px;"> -->
<!-- 	  					<textarea name="content" class="textarea" style="width:100%; height:300px; box-sizing:border-box;-moz-box-sizing:border-box; resize:none; border:none;" readonly></textarea> -->
<!-- 	  				</td> -->
<!-- 	  			</tr>   -->
<!-- 			</table> -->
<!-- 		</div> -->
	</body>
</html>