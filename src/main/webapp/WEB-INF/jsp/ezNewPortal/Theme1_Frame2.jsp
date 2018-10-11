<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>PortalPage</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/orbit-1.2.3.css')}" type="text/css" />
<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">

<script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/showModalDialog.js')}" ></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.orbit-1.2.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/raphael-min.js')}"></script>
<script type="text/javascript">

	var portletOrder = JSON.parse('${portletOrder}');
	var xmlHttp_getnewmailcount_total = null;
	var pollCount = "<c:out value='${pollCount}'/>";
	var circularCount = "<c:out value='${circularCount}'/>";
	var scheduleCount = "<c:out value='${scheduleCount}' />";
	var approvalCount = "<c:out value='${approvalCount}'/>";
	var unreadMailCount = "<c:out value='${unreadMailCount}'/>";
	var photoBoardPage = 1;
	var photoCount = 4;
	
	$(function() {
		$('#featured').orbit();
		
		var portletCount = portletOrder.length;
		
		for (var i = 0; i < portletCount; i++) {
			var strHTML = "";
			strHTML += "<div class='box_shadow' id='";
			strHTML += portletOrder[i].portletId + "Portlet'>";
			strHTML += "</div>";
			
			$(".portlet_area").append(strHTML);
		}
		
		for (var i = 0; i < portletCount; i++) {
			var portletId = portletOrder[i].portletId;
			var portletUrl = portletOrder[i].portletUrl;
			
			(function (portletId, portletUrl) {
				$.ajax({
					type : "POST",
					dataType : "html",
					data : {"portletId" : portletId},
					url : portletUrl,
					success : function(result) {
						$("#" + portletId + "Portlet").append(result);
						eventSetting(portletId);
					}
				});
			}(portletId, portletUrl));
		}
		
		//ajax로 count 불러오기
		getCountSetting();
		
		$("#personalEnv").on("click", viewPersonalEnv);
	});
	
	function eventSetting(portletId) {

		if (portletId == 4) {
			$("#votePlus").on("click", viewQstList);
			$(".voteBtn").on("click", votePoll);
		} else if (portletId == 9) {
			$(".nextBtn").on("click", photoBoardMoveNextPage);
			$(".preBtn").on("click", photoBoardMovePrevPage);
			$("#photoBoardPlus").on("click", viewPhotoBoardList);
		}
	}
	
	function viewPersonalEnv() {
	    window.open("/ezPortal/environmentMain.do?topMenuID=F3633607-8E8B-42A1-B777-6E2969072E58", "main", "");
	}
	
	function photoBoardMoveNextPage() {
		photoBoardPage = photoBoardPage + 1;
		var boardId = $(".photo_board").find(".portletText").attr("data1");
		var portletId = $(".photo_board").parent().parent().attr("id");
		portletId = portletId.substring(0, portletId.indexOf("P"));
		
		$.ajax({
			type : "POST",
			url : "/ezNewPortal/getPhotoItemList.do",
			data : {"boardId" : boardId, "page" : photoBoardPage, "photoCount" : photoCount, "portletId" : portletId},
			success : function(result) {
				if (result.length > 0) {
					var resultCount = result.length;
					var strHTML = "";
					
					for (var i = 0; i < resultCount; i++) {
						strHTML += "<li>";
						strHTML += "<img src='" + result[i].filePath + "', data1='" + result[i].boardID + "' data2='" + result[i].itemID + "' onclick='photoItemRead(this)'>";
						strHTML += "</li>";
						
					}
					
					$("#photoul").html(strHTML);
				} else {
					photoBoardPage = photoBoardPage - 1;
				}
			}
		})
	}

	function photoBoardMovePrevPage() {
		if (photoBoardPage !== 1) {
			photoBoardPage = photoBoardPage - 1;
			var boardId = $(".photo_board").find(".portletText").attr("data1");
			var portletId = $(".photo_board").parent().parent().attr("id");
			portletId = portletId.substring(0, portletId.indexOf("P"));
			
			$.ajax({
				type : "POST",
				dataType : "json",
				url : "/ezNewPortal/getPhotoItemList.do",
				data : {"boardId" : boardId, "page" : photoBoardPage, "photoCount" : photoCount, "portletId" : portletId},
				success : function(result) {
					var resultCount = result.length;
					var strHTML = "";
					
					for (var i = 0; i < resultCount; i++) {
						strHTML += "<li>";
						strHTML += "<img src='" + result[i].filePath + "', data1='" + result[i].boardID + "' data2='" + result[i].itemID + "' onclick='photoItemRead(this)'>";
						strHTML += "</li>";
						
					}
					
					$("#photoul").html(strHTML);
				}
			})
		}
	}

	function viewPhotoBoardList() {
		var boardId = $(".photo_board").find(".portletText").attr("data1");
	    window.open("/ezBoard/boardMainRedirect.do?boardID=" + boardId, "main", "");
	}

	function photoItemRead(elem) {
		var ShowAdjacent = "";
		var pheight = window.screen.availHeight;
		var pwidth = window.screen.availWidth;
		var pTop = (pheight - 789) / 2;
		var pLeft = (pwidth - 765) / 2;
		
		if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
			var height = 789;
		} else {
			var height = 785;
		}
		
		window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + elem.getAttribute("data2") + "&boardID=" + elem.getAttribute("data1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
	}
	
	function viewQstList() {
		window.open("/ezBoard/boardMain.do?func=3","main");		    	
	}

	function votePoll() {
		var qstId = $(".voteBtn").attr("id");
		qstId = qstId.substring(1);
		
		$.ajax({
			type : "POST",
			dataType : "text",
			async : true,
			url : "/ezPoll/checkPoll.do",
			data : {
				qstId : qstId
			},
			success: function(data) {		    			
				var result = JSON.parse(data).result;					
				
				if (result == "Normal") {
					window.open("/ezBoard/boardMain.do?func=3&qstId=" + qstId, "main");
				}
				else {
					alert("투표를 수정하고 있습니다.기다려주세요.");
					window.location.reload();
				}
	        },
	        error: function(error) {
	        	alert(error);
	        }
		});
	    
	}
	
	function getCountSetting() {
		if (pollCount > 99) {
			pollCount = "99+";
			$("#pollCount").addClass("iconCount");
		} else if (pollCount == 0) {
			$("#pollCount").addClass("iconCount_none");
		} else {
			$("#pollCount").addClass("iconCount");
		}
		
		if (circularCount > 99) {
			circularCount = "99+";
			$("#circularCount").addClass("iconCount");
		} else if (circularCount == 0) {
			$("#circularCount").addClass("iconCount_none");
		} else {
			$("#circularCount").addClass("iconCount");
		}
		
		if (scheduleCount > 99) {
			scheduleCount = "99+";
			$("#scheduleCount").addClass("iconCount");
		} else if (scheduleCount == 0) {
			$("#scheduleCount").addClass("iconCount_none");
		} else {
			$("#scheduleCount").addClass("iconCount");
		}
		
		if (approvalCount > 99) {
			approvalCount = "99+";
			$("#approvalCount").addClass("iconCount");
		} else if (approvalCount == 0) {
			$("#approvalCount").addClass("iconCount_none");
		} else {
			$("#approvalCount").addClass("iconCount");
		}
		
		if (unreadMailCount > 99) {
			unreadMailCount = "99+";
			$("#unreadMailCount").addClass("iconCount");
		} else if (unreadMailCount == 0) {
			$("#unreadMailCount").addClass("iconCount_none");
		} else {
			$("#unreadMailCount").addClass("iconCount");
		}
		
		$("#pollCount").text(pollCount);
		$("#circularCount").text(circularCount);
		$("#scheduleCount").text(scheduleCount);
		$("#approvalCount").text(approvalCount);
		$("#unreadMailCount").text(unreadMailCount);
	}
	
	</script>
	<style type="text/css">
		.notEmptySlider {
			width : 280px;
			height : 515px;
			cursor : pointer;
		}
		
		#myImg {
			width : 36px;
			height : 36px;
		}
	</style>
</head>

	<body class="mainbg">
		<div id="center">
			<section class="section_left" style="height:1130px; float:right;">
				<article class="rolling_info">
					<div class="rolling" id="featured">
            		<c:choose>
	            		<c:when test="${not empty sliderList}">
	            			<c:forEach items="${sliderList}" var="slider">
		            			<c:choose>
		            				<c:when test="${fn:substring(slider.url, 0, 4) eq 'http' }">
		            					<img src="${slider.imagePath}" class="notEmptySlider" onclick="window.open('${slider.url }')" />
		            				</c:when>
		           		 			<c:otherwise> 
										<img src="${slider.imagePath}" class="notEmptySlider" onclick="window.open('http://${slider.url }')" />
									</c:otherwise>
								</c:choose>
							</c:forEach>
	            		</c:when>
	            		<c:otherwise>
		            		<img src="/images/ezNewPortal/rolling01.png" width="280" height="515" />
		            		<img src="/images/ezNewPortal/rolling01.png" width="280" height="515" />
	            		</c:otherwise>
	            	</c:choose>
           	 		</div>
           	 		<dl class="info">
            			<dt class="infoImg"><c:if test='${userPhoto == ""}'><img src="/images/ezNewPortal/info_pic_none.png"  width="36px" height="36px" /></c:if><c:if test='${userPhoto != ""}'><img id="myImg" src="/ezCommon/downloadAttach.do?filePath=${userPhoto }"></c:if></dt>
               			<dd class="infoName">${userName} ${userTitle}</dd>
                		<dd class="infoTeam">${deptName}</dd>
                		<%-- <dd class="infoTeam"><spring:message code="main.t00016" /> ${lastLogin }</dd> --%>
                		<dd class="infoSet" id="personalEnv"><img src="/images/kr/main/info_set.png"></dd>
                		<dd class="infoSet" style="color:white;right : 30px;">포틀릿/프레임 설정</dd><!-- 임시용 -->
           			</dl>
				</article>
				<article class="time_check">
					<div id="timeinput" class="presentTime">
	               		<p class="timeTit" id="todayTime">현재시간</p>
						<div id="timeFlow" class="timeText">12:38:37</div>
			    	</div>
			    	<div id="atti_area" class="main_time">
	            	<dl class="timeCheckIn">
	                	<dd id="inAttiBtn" class="out" type="A01" datetype="2" onclick="checkHoliday(this)">출근</dd>
	                </dl>
	                <dl class="timeCheckOut">
	                   	<dd id="outAttiBtn" class="out" type="A03" datetype="2" onclick="checkHoliday(this)">퇴근</dd>
	                </dl>
		    	</div>
				</article>
				
				<article class="countingIcon">
					<div class="countingIcon01">
						<dl id="NewMail" onclick="btnSumming_click(this)">
                			<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon01.png"></dt>
                    		<dd class="iconText">새메일</dd>
                    		<dd id="unreadMailCount">0</dd>
                		</dl>
                		<dl id="AprSign" onclick="btnSumming_click(this)">
                    		<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon03.png"></dt>
                    
                    		<dd class="iconText">결재문서</dd>
                    		<dd id="approvalCount">0</dd>
                		</dl>
                		<dl id="Schedule" onclick="btnSumming_click(this)">
                  		  	<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon02.png"></dt>
                    		<dd class="iconText">오늘일정</dd>
                		    <dd id="scheduleCount">0</dd>
               			</dl>
					</div>
					<div class="countingIcon02">
            			<dl id="Poll" onclick="btnSumming_click(this)">
                    		<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon05.png"></dt>
                    		<dd class="iconText">전자설문</dd>                        
                    		<dd id="pollCount">0</dd>
                		</dl>
            	
                		<dl id="Circular" onclick="btnSumming_click(this)"> 
                    		<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon04.png"></dt>
                    		<dd class="iconText">회람판</dd>
                    		<dd id="circularCount">0</dd>
                		</dl>
                	</div>
				</article>
				<article class="birthday">
					<div class="birthTit">
               			<p class="birthText"><span id="curMon">10</span>월 생일자</p>
           	    		<span class="birthRighttbtn" onclick="moveBirth('NEXT')"><img src="/images/ezNewPortal/birthday_next.png"></span>
                		<span class="birthLeftbtn" onclick="moveBirth('PREV')"><img src="/images/ezNewPortal/birthday_pre.png"></span>
            		</div>
            		<div id="birthcont" style="display: none;">
            			<ul class="birthList" id="userlist"></ul>
            		</div>
            		<div id="nodata_NewBirth" style="">
            			<dl class="nodata">
	            			<dt style="padding-top:33px"><img src="/images/ezNewPortal/nodata.png"></dt>
	            			<dd>"데이터가 없습니다"</dd>
            			</dl>
            		</div>
				</article>
				<article class="bestEmployee">
					<p class="emPic"><img src="/images/ezNewPortal/bestEmployee_pic_none.png"></p>
					<dl class="emDL">
            			<dt class="emTit">이달의 우수사원</dt>
                			<dl class="nodata" style="margin-top:8px">
		            			<dd>"데이터가 없습니다"</dd>
	            			</dl>
            		</dl>
				</article>
			</section>
		</div>
		<aside id="quickSide">
			<p class="linkBtn_open"></p>
			<div class="aside_quick">퀵메뉴</div>
			<div class="aside_link">퀵링크</div>
		</aside>
		<section class="section_main">
			<div class="portlet_area">
			</div>
		</section>
	</body>
</html>