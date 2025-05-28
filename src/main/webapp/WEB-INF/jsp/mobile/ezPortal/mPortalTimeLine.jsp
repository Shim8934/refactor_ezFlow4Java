<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.css')}" />		
    	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mobile/mobile.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/mobile/mobile.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mBoard.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mEMail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript">
			function setTime(date) {
				var result = "";
				var nowDate = getDatePickerTime(false);
				
				if (nowDate == date.substring(0, 10)) {
					result = date.substring(11, 16);
				} else {
					result = date.substring(5, 10);
				}
				
				return result;
			}
			
			function getDatePickerTime(type) {
				var returnDate = "";
				var pOffsetHour = 0
				var pOffsetMinute = 0
				var tempDate = new Date();
				
				tempDate.setUTCHours(Number(tempDate.getUTCHours()) + Number(pOffsetHour), Number(tempDate.getUTCMinutes()) + Number(pOffsetMinute), tempDate.getUTCSeconds());
				
				var rYear = tempDate.getFullYear();
				var rMonth = addzero(tempDate.getMonth() + 1);
				var rDate = addzero(tempDate.getDate());
				var rHour = addzero(tempDate.getHours());
				var rMin = addzero(tempDate.getMinutes());
				var rSec = addzero(tempDate.getSeconds());
				
				if (type) {
					returnDate = rYear + "-" + rMonth + "-" + rDate + " " + rHour + ":" + rMin + ":" + rSec;
				} else {
					returnDate = rYear + "-" + rMonth + "-" + rDate;
				}
				
				return returnDate;
			}
			
			function addzero(arg) {
				if (arg < 10) {
					arg = "0" + arg;
				}
				
				return arg;
			}
			
			function getTimeLineList(flag) {
				$.ajax({
					type : "POST",
					url : "/mobile/ezApprovalG/getTimeLineList.do",
					dataType : "json",
					data : {
						pTempFlag : flag
					},
					beforeSend: function() {
						$.mobile.loading('show');
					},
		            complete: function() { 
		            	$.mobile.loading('hide');
		            },
					success : function(data) {
						if (data.timeLineList.length > 0) {
							var list = "";
							
							$.each(data.timeLineList, function(key, value) {
								list += "<li><a href=\"#\">";
								
								if (value.module == "결재") {
									list += "    <img style=\"padding-left: 5px;padding-top: 5px;\" height=65 src=\"/images/mobile/approval.png\">";
								} else if (value.module == "게시판") {
									list += "    <img style=\"padding-left: 5px;padding-top: 5px;\" height=65 src=\"/images/mobile/board.png\">";
								} else if (value.module == "일정관리") {
									list += "    <img style=\"padding-left: 5px;padding-top: 5px;\" height=65 src=\"/images/mobile/schedule.png\">";
								} else if (value.module == "메일") {
									list += "    <img style=\"padding-left: 5px;padding-top: 5px;\" height=65 src=\"/images/mobile/mail.png\">";
								}
								
								list += "<h2>" + value.title + "</h2>";
								
								if (value.module == "일정관리") {
									list += "<p>" + value.writerName + "  " + value.startDate.substring(11,  16) + " " + "</p></a>";
								} else {
									list += "<p>" + value.writerName + "  " + setTime(value.startDate) + " " + "</p></a>";
								}
								
								list += "</li>";
							});
							
							$("#listView").append(list);
							$("#listView").listview("refresh");
						}
					},
					error : function(xhr, status, error) {
						
					}
				});
			}
			
			$(document).on("pagecreate",function() {
				getTimeLineList(0);
			});
		
			$(document).on("pagecreate", "#main", function() {
				$(document).on("scrollstop",function() {
// console.log($(window).scrollTop() + " == " + $(document).height() + " - " + $(window).height());
					if ($(window).scrollTop() >= $(document).height() - $(window).height()) {
						getTimeLineList(1);
					}
				});
			});
		</script>
		<style>
			.ui-li-divider {
				background-color: transparent;
				color: rgb(31, 63, 105);
				border-color: rgb(220, 220, 220);
			}
			.ui-grid-a .ui-block-a input {
				height:40px;
			}
			.ui-grid-a .ui-block-b .ui-icon-search {
				height:40px;
				width:100%;
				-webkit-border-radius: .3125em;
    			border-radius: .3125em;
			}
			.ui-listview .ui-li-has-thumb > p:first-child, .ui-listview .ui-li-has-thumb > .ui-btn > p:first-child, .ui-listview .ui-li-has-thumb .ui-li-thumb .ui-li-has-thumb{
	            position : absolute;
	            left:10px;
	            top:0px;
	            max-height:5em;
	            max-width:5em;
	         }
		</style>
	</head>
	<body class="loginbody">
		<section id="main" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezPortal/mPortalTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">
				<form id="mainForm" name="mainForm" method="post">							
					<div>						
						<ul data-role="listview" data-theme="a" data-divider-theme="a" data-inset="false" id="listView">
							<li data-role="list-divider" style="background-color: white"><img style="padding-left: 10px;" height="35px" src="/images/mobile/timeLine.png">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TimeLine</li>
						</ul>
					</div>
				</form>
     		</div>
     		<!-- body end -->
     		     		     		
     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezPortal/mPortalFooter.jsp" />
     		<!-- footer import -->     		     		
     	</section>	
	</body>	
</html>