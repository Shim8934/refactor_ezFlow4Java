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
			var modAppl = "<c:out value='${attitudeInfo.modAppl}'/>";
			var annualApprStatus = "<c:out value='${attitudeInfo.annualApprStatus}'/>";
			var docApprStatus = "<c:out value='${attitudeInfo.docApprStatus}'/>";
			var font = "<c:out value='${font}'/>"
			var uselang = "<c:out value='${userInfo.lang}'/>";
			
			window.onload = function () {
				setHtml();
			}
			
			function setHtml() {
				var tempHtml = "";
				
				tempHtml += "<tr>";
				tempHtml += "<th><spring:message code='ezAttitude.t274' /></th>";
				if(annualApprStatus == "-1") {
					tempHtml += "<td colspan='2'><spring:message code='ezAttitude.t267' /></td>";
				} else if(annualApprStatus == "0") {
					if(docApprStatus == '005') {
						tempHtml += "<td colspan='2'><spring:message code='ezAttitude.t268' /></td>";
    				} else if(docApprStatus == '011') {
						tempHtml += "<td colspan='2'><spring:message code='ezAttitude.t269' /></td>";
    				} else if(docApprStatus == '0') {
                        tempHtml += "<td colspan='2'><spring:message code='ezAttitude.t34' /></td>";
                    } else {
						tempHtml += "<td colspan='2'><spring:message code='ezAttitude.t270' /></td>";
    				}
				} else if(annualApprStatus == "1") {
					tempHtml += "<td colspan='2'><spring:message code='ezAttitude.t271' /></td>";
				}
				tempHtml += "</tr>";
				
				if (modAppl != "0") {
					tempHtml += "<tr>";
					tempHtml += "<th><spring:message code='ezAttitude.t272' /></th>";
					if(modAppl == "1" || modAppl == "2") {
						tempHtml += "<td colspan='2'><spring:message code='ezAttitude.t209' /></td>";
					} else if(modAppl == "3") {
						tempHtml += "<td colspan='2'><spring:message code='ezAttitude.t210' /></td>";
					} else if(modAppl == "4") {
						tempHtml += "<td colspan='2'><spring:message code='ezAttitude.t211' /></td>";
					}
					tempHtml += "</tr>";
				}
				
				$("#attiInfoView").append(formHtml);
				
				$("#attiInfoView tr td *").remove();
				
				if(typeId == 'A11' || typeId == 'A12' || typeId == 'A13') {
					$("#attiInfoView").append(tempHtml);
					//$("#attiInfoView tr").eq(3).css("display", "none");
					$("#attiInfoView tr").eq(4).css("display", "none");
				} else {					
					$("#bizsub").html(" " + bizSub);
				}
				
				//유형명
            	typeName = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&amp;", "&"), "&#39;", "'"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"'), "&amp;", "&");
				
				// 2023-08-07 황인경 - 근태관리 > 근태상세보기 > 다국어 처리
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
						//2020-03-13 김정언 : 반반차
						if(typeId === 'A21') showTime = startDate.substring(0, 16) + " ~ " + endDate.substring(0, 16);
						else showTime = startDate.substring(0, 10) + " ~ " + endDate.substring(0, 10);
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
				var pLeft = (pwidth - 1200) / 2;
				var szUrl = "/ezEmail/mailWrite.do?attitudeId=" + attitudeId + "&cmd=attitude";
				window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height=" + conHeight + "px, width=1200px, status=no, toolbar=no, menubar=no, location=no, resizable=1");
				window.close();
			}
			
			/**
			* [개인연차현황] 연차취소신청
			*/
			function attitudeCancelAnnual() {
				var openWin = null;
				if (CrossYN()) {
					openWin = window.open("/ezAttitude/attitudeCancelAnnual.do?attitudeId=" + attitudeId + "&typeId=" + typeId, "", GetOpenWindowfeature(672, 640));
					
					try { openWin.focus(); } catch (e) { }
				} else {
					openWin = window.showModalDialog("/ezAttitude/attitudeCancelAnnual.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", 
					    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
					try { openWin.focus(); } catch (e) { }
				}
				openWin.opener = window.opener;
				window.close();
			}
			
			//취소신청삭제
			function deleteCancelAnnual() {
				
				var obj = new Object();
		    	obj.attitudeId = attitudeId; 
		    	
				var delFlag = confirm("<spring:message code='ezAttitude.t160'/>");
				if (delFlag) {
					$.ajax({
						type : "POST",
						async : true,
						url : "/ezAttitude/deleteCancelAnnual.do",
						dataType : "text",
						data : obj,
						error: function(xhr, status, error){
					    	alert("<spring:message code='ezAttitude.t83'/>");
					    },
					    success : function(json){
					    	if (json == "error") {
					    		alert("<spring:message code='ezAttitude.t175'/>");
					    	}
				            try {
				            	window.opener.getUserAnnualList();
								window.opener.parent.frames["left"].getAttitudeList();
								//신청갯수
						    	window.opener.parent.frames["left"].leftAnnualCount();
				            } catch (e) { 
				            }
				            window.close();
					    }
					})
				}
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
	                                   <th><spring:message code='ezAttitude.t134'/></th>
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
	            <div class="btnpositionNew" id="menuTable">
	            	<c:if test="${userId == attitudeInfo.writerId}">
	            		<c:choose>
	            			<c:when test="${attitudeInfo.typeId == 'A11' || attitudeInfo.typeId == 'A12' || attitudeInfo.typeId == 'A13' || attitudeInfo.typeId == 'A21'}">
	            				<c:if test="${attitudeInfo.annualApprStatus == '1'}">
		            				<c:if test="${attitudeInfo.modAppl == '0'}">
		            					<a class="imgbtn"><span onclick="attitudeCancelAnnual()"><spring:message code='ezAttitude.t272' /></span></a>
		            				</c:if>
		            				<c:if test="${attitudeInfo.modAppl == '1' || attitudeInfo.modAppl == '2'}">
	                       				<a class="imgbtn"><span onclick="deleteCancelAnnual()"><spring:message code='ezAttitude.t279' /></span></a>
	                       			</c:if>
		            				<c:if test="${attitudeInfo.modAppl == '4'}">
	                       				<a class="imgbtn"><span onclick="attitudeCancelAnnual()"><spring:message code='ezAttitude.t92' /></span></a>
	                       			</c:if>
                       			</c:if>
                       		</c:when>
                       		<c:otherwise>
								<a class="imgbtn"><span onclick="sendMailAttitude()"><spring:message code='ezAttitude.t136'/></span></a>
                       			<a class="imgbtn"><span onclick="modifyAttitude()"><spring:message code='ezAttitude.t163'/></span></a>
                       			<a class="imgbtn"><span onclick="deleteAttitude()"><spring:message code='ezAttitude.t164'/></span></a>
                       		</c:otherwise>
                        </c:choose>
					</c:if>
	            </div>
	        </div>
	    </form>
	</body>
</html>