<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title>left_attitude</title>
		<link rel="stylesheet" href="${util.addVer('/css/email_tree.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.e15', 'msg')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('/css/main.css')}" type="text/css"/>	
		<link rel="stylesheet" href="${util.addVer('/css/ezAttitude/clockTemp1.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezAttitude/timecheck.css')}" type="text/css" />	
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezAttitude/Calendar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<style>
			.time {
				float:left;
				width:100%;
				border-bottom:1px solid #cdd2d9;
			}
			
			.time .title {
				font-size: 12px;
				color:#000;
				font-weight:bold;
				text-align:center;
				height:25px;
				margin:0px;
				padding:0px;
				line-height:25px;
			}
			
			#atti_area span{
				width:35px;
				margin-left:7px;
				display:inline-block;
				padding: 5px 4px;
				font: 12px malgun gothic;
				padding-top: 7px;
 				border: 1px solid #ddd;
 				color: #666;
				border-radius:3px;
			}
			
			.btn_hover{
				cursor: pointer;
				color: rgb(4, 112, 227) !important;
				border-color: rgb(4, 112, 227) !important;
			}
			
			.btn_disabled{
				background-color: transparent !important;
				border: 1px solid #ddd !important;
				color: #aaa !important;
			}
			
			#inAttiClock, #outAttiClock {
				background: url("/images/clock.png") no-repeat 0 4px;
				background-size: 14px;
				height:20px;
				font-family: Malgun Gothic, Meiryo UI;
			}
			#mCSB_1_container {
				margin-right: 0px;
			}
			.mCSB_scrollTools {
				opacity: 0.3;
				width: 6px;
				margin-Top: 5px;
				margin-bottom: 5px;
			}
		</style>
		
		<script type="text/javascript">
		var userOffset = "${userOffset}";
		var uselang = "${uselang}";
		var closedDay = "${attitudeConfigVO.closedDay}";
		var checkClosedToday = false;
		var leaveEarlyFlag = false; // 조퇴가 등록되어있는지 체크
		var serverTime = "${serverTime}";
		var nowAttiTime = "";
		var beforeAlertDate = "";
		var afterAlertDate = "";
		var overTime = "";
		
		window.onload = function(){
			closedDay = closedDay.split(",");
			
			parseDate();
			//attiClock();
			setAttiBtnHover();
			getAttitudeList();
			getHolidayList();
		    select_memorialDays(uselang);
		    
		    document.getElementById('userAttitude').onclick();
		    
		    leftResize();
	        $(".attitudeListBox").mCustomScrollbar({
        		theme : "dark"
        	});
		}
		
		 function leadingZeros(n, digits) {
	        var zero = '';
	        n = n.toString();

	        if (n.length < digits) {
	            for (i = 0; i < digits - n.length; i++)
	                zero += '0';
	        }
	        return zero + n;
	    }
		
		function getAttitudeList() {
	    	$.ajax({
	    		type : "POST",
	    		dataType : "json",
	    		async : false,
	    		url : "/ezAttitude/getAttitudeList.do",
	    		data : {},
	    		success : function(result) {
	    			leaveEarlyFlag = false;
	    			for (var i = 0; i < result.length; i++) {
	    				if (result[i].typeId == "A01") {
		    				$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
							$("#inAttiBtn").removeClass("out").addClass("in");
							$("#inAttiBtn").html("<span class='sub_iconLNB workIcon'></span>" + "<span class='workT'>"+result[i].startDate.split(" ")[1].substring(0,5)+"</span>");
	    				} else if (result[i].typeId == "A02") {
	    					$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
							$("#inAttiBtn").removeClass("out").addClass("lateIn");							
							$("#inAttiBtn").html("<span class='sub_iconLNB workIcon'></span>" + "<span class='workT'>"+result[i].startDate.split(" ")[1].substring(0,5)+"</span>");
	    				} else if (result[i].typeId == "A03") {
	    					$("#outAttiBtn").attr("onclick", "").unbind("mouseenter");
							$("#outAttiBtn").removeClass("out").addClass("in");
							$("#outAttiBtn").html("<span class='sub_iconLNB workIcon'></span>" + "<span class='workT'>"+result[i].startDate.split(" ")[1].substring(0,5)+"</span>");
	    				}
	    			}
	    		}
	    	})
	    }
	    
		function getHolidayList() {
			$.ajax({
				type:"POST",
				dataType : "json",
				async : true,
				url : "/ezAttitude/getHolidayList.do",
				data : {
					isRest : "rest"
				},
				success : function(result) {
					for (var i = 0; i < result.holidayList.length; i++) {
						if (result.holidayList[i].isRepeat == 1) { //매년 반복되는 경우
							memorialDays.push(new memorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2, 
															  result.holidayList[i].holidayDate.substring(5,7), result.holidayList[i].holidayDate.substring(8,10),
															  result.holidayList[i].isSolar, result.holidayList[i].isRest == 1 ? true : false));
						} else if (result.holidayList[i].isRepeat == 0) { //해당 년에만 적용이 되는 경우
							yearmemorialDays.push(new yearmemorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2,
																	  result.holidayList[i].holidayDate.substring(0,4), result.holidayList[i].holidayDate.substring(5,7),
																	  result.holidayList[i].holidayDate.substring(8,10), result.holidayList[i].isSolar,
																	  result.holidayList[i].isRest == 1 ? true : false));
						}
					}
				}
			});
		}
		
		//휴일 체크
		function checkHoliday(obj) {
			var todayLunar = lunarCalc(nowAttiTime.getFullYear(), nowAttiTime.getMonth() + 1, nowAttiTime.getDate(), 1);
			var todayMemorialDayList = memorialDayCheck(nowAttiTime, todayLunar);
			var todayYearMemorialDayList = yearmemorialDayCheck(nowAttiTime, todayLunar);
			var addAttitude = true; // true 등록 가능
			
			if (closedDay[nowAttiTime.getDay()] == "1"){ //회사지정 휴일인지 체크
				addAttitude = false;				
			} else if (todayMemorialDayList.length != 0 || todayYearMemorialDayList.length != 0) { //기념일체크
				if (todayMemorialDayList.length != 0 ) {
					for (var i = 0; i < todayMemorialDayList.length; i++) {
						if (todayMemorialDayList[i].holiday ==  true) { //휴무일인 기념일일때
							addAttitude = false;
						}
					}
				} 
				if (todayYearMemorialDayList.length != 0) {
					for (var i = 0; i < todayYearMemorialDayList.length; i++) {
						if (todayYearMemorialDayList[i].holiday == true) { //휴무일인 기념일일때
							addAttitude = false;
						}
					}
				}
			}
			
			if(addAttitude) {
				checkAttitude(obj);
			} else {
				alert("<spring:message code='ezAttitude.t167'/>");
			}
		}
		
		//근태 중복 체크
	 	function checkAttitude(obj) {
			var returnValue = getIsAttitude(obj.getAttribute("type"));
			
			if (returnValue == 0) {
				addAttitude(obj);
			} else {
				alert("<spring:message code='ezAttitude.t169'/>");
				getAttitudeList();
    			try{parent.frames["right"].getAttitudeMainList();}catch(e){}
			}
	 	}
		
		//시간놓고 alert내용을 파라미터로 던져서 체크??
	    function addAttitude(obj) {
	    	var pTypeId = obj.getAttribute("type");
	    	var pDateType = obj.getAttribute("datetype");
	    	if (pTypeId == "A03") {
	    		var returnValue = getIsAttitude("A01");
	    		if (returnValue == 0) {
	    			alert("<spring:message code='ezAttitude.t168'/>");
		    		return;
	    		} else {
	    			getAttitudeList();
	    			try{parent.frames["right"].getAttitudeMainList();}catch(e){}
	    		}
	    	}
	    	
	    	beforeAlertDate = new Date();
	    	var dateAlert = nowAttiTime.getFullYear() + "<spring:message code='ezAttitude.t66'/> " + (nowAttiTime.getMonth() + 1) + "<spring:message code='ezAttitude.t67'/> " + (nowAttiTime.getDate()) + "<spring:message code='ezAttitude.t68'/> " + leadingZeros(nowAttiTime.getHours(), 2) + ":" + leadingZeros(nowAttiTime.getMinutes(), 2) + ":"+ leadingZeros(nowAttiTime.getSeconds(), 2);
	    	var saveFlag = confirm("<spring:message code='ezAttitude.t69'/> " + dateAlert + "<spring:message code='ezAttitude.t70'/>");
	    	if (!saveFlag) {
	    		afterAlertDate = new Date();
	    		overTime = (afterAlertDate.getTime() - beforeAlertDate.getTime());
	    		nowAttiTime.setMilliseconds(nowAttiTime.getMilliseconds() + overTime);
	    		return;
	    	} 
	    	$.ajax({
	    		type : "POST",
	    		async : true,
	    		url : "/ezAttitude/attitudeSave.do",
	    		data : {
	    			typeId : pTypeId,
	    			dateType : pDateType,
	    			mode : "new"
	    		},
	    		success : function(result) {
	    			getAttitudeList();
	    			try{parent.frames["right"].getAttitudeMainList();}catch(e){}
	    		},
	    		complete : function() {
	    			afterAlertDate = new Date();
		    		overTime = (afterAlertDate.getTime() - beforeAlertDate.getTime());
		    		nowAttiTime.setMilliseconds(nowAttiTime.getMilliseconds() + overTime);
	    		}
	    	})
	    }
	    
	    function getIsAttitude(typeId) {
			var isAttitudeReturn = "";
	    	$.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezAttitude/getIsAttitude.do",
	    		data : {
	    			typeId : typeId
	    		},
	    		success : function(result) {
	    			isAttitudeReturn = result;
	    		},
	    		complete : function() {
	    			
	    		}
	    	})
	    	return isAttitudeReturn;
	    }

	    function setAttiBtnHover() {
	    	$("#inAttiBtn, #outAttiBtn").hover(function(){
	    		$(this).addClass("btn_hover");
	    	}, function(){
	    		$(this).removeClass("btn_hover");
	    	})
	    }
	    
	    function functionFlag(flag) {
	    	var funcFlag = flag;
	    	
	    	switch(funcFlag) {
	    		case 1:
	    			window.open("/ezAttitude/attitudeUserMain.do", "right");
	    			break;
	    		case 2:
	    			window.open("/ezAttitude/attitudeDeptMain.do", "right");
	    			break;
	    		case 3: // 나의수정신청
	    			window.open("/ezAttitude/attModAppList.do", "right");
	    			break;
	    		case 4:	// 신청관리현황
	    			window.open("/ezAttitude/manageAttModAppList.do", "right");
	    			break;
	    		case 5:	// 근태정보관리
	    			window.open("/ezAttitude/attitudeManage.do", "right");
	    			break;
	    	}
	    }
	        	
    	function parseDate() {
    		var _strDate = "";
    		nowAttiTime = new Date(serverTime);
    		
    		if (nowAttiTime.toString() == 'Invalid Date') {
    		    var _parts = serverTime.split(' ');
    		
    		    var _dateParts = _parts[0];
    		    nowAttiTime = new Date(_dateParts);
    		
    		    if (_parts.length > 1) {
    		        var _timeParts = _parts[1].split(':');
    		        nowAttiTime.setHours(_timeParts[0]);
    		        nowAttiTime.setMinutes(_timeParts[1]);
    		        if (_timeParts.length > 2) {
    		        	nowAttiTime.setSeconds(_timeParts[2]);
    		        }
    		    }
    		}
    	}
    	
    	function attiClock() {
	        var h, m;
	        var s;
	        var time = " ";
	        
	        nowAttiTime.setSeconds(nowAttiTime.getSeconds() + 1);
	        time = leadingZeros(nowAttiTime.getHours(), 2) + ':' + leadingZeros(nowAttiTime.getMinutes(), 2) + ':' + leadingZeros(nowAttiTime.getSeconds(), 2);
	        document.getElementById("timeFlow").innerHTML = time;
	        gizmo = setTimeout("attiClock()", 1000);
	    }
    			
    	//카운트 refresh
    	function leftCount() {
	    	$.ajax({
				type : 'get',
			    url : '/ezAttitude/getTotalAttCount.do',
			    dataType : "text",
			    error: function(xhr, status, error){
			    	alert("<spring:message code='ezAttitude.t175'/>");
			    },
			    success : function(result){
			    	if (result == "0") {
			    		result = "";
			    	} else {
			    		result = "("+ result +")";
			    	}
			    	try {
						document.getElementsByClassName("attCount")[0].innerText = result;
						document.getElementsByClassName("attCount")[1].innerText = result;
					} catch (e) {	}
			    }
	    	})
	    }
    	
    	function leftResize(){
        	$(".attitudeListBox").height(window.innerHeight-105);
        }
        
        $( window ).resize(function() {
        	leftResize();
    	});
    	
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code='ezAttitude.t1'/>">
	    		<spring:message code='ezAttitude.t1'/>
	        </div>
	        <div class="btn_writeBox_work">
	        	<p class="btn_write02" id="outAttiBtn" type="A03" datetype="2" onclick="checkHoliday(this)"><span class="sub_iconLNB workIcon"></span><span class="workT"><spring:message code='ezAttitude.t65'/></span></p> 
	        	<p class="btn_write01" id="inAttiBtn" type="A01" datetype="2" onclick="checkHoliday(this)"><span class="sub_iconLNB workIcon"></span><span class="workT"><spring:message code='ezAttitude.t64'/></span></p>
	        </div>
	        <div class="attitudeListBox" style="overflow:hidden; padding-right: 0;">
		        <h2 class="on">
		        	<span>
		            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title"><spring:message code='ezAttitude.t1'/></span>
		            </span>
		        </h2>
		        <ul class="lnbUL">
		        	<div class="tree">
		            	<span>
		                	<span>
		                    	<span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_workTime_individual"></span><span class="h2_text" id="userAttitude" onclick="functionFlag(1)"><spring:message code='ezAttitude.t143'/></span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_workTime_department"></span><span class="h2_text" id="deptAttitude" onclick="functionFlag(2)"><spring:message code='ezAttitude.t144'/></span>
		                            </div>
		                    	</span>
		                    </span>        
		                </span>
		            </div>
		        </ul>
		        <h2 class="on">
		        	<span>
		            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title"><spring:message code='ezAttitude.t7'/></span>
		            </span>
		        </h2>
		        <ul class="lnbUL">
		        	<div class="tree">
		            	<span>
		                	<span>
		                		<span>
		                        	<div class="node_div">
		                        		<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_workTime_change"></span><span class="h2_text" onclick="functionFlag(3)"><spring:message code='ezAttitude.t166'/></span>
		                            </div>
		                    	</span>
		                    	<c:if test="${attitudeAdminCheck == true}">
			                    	<span>
			                        	<div class="node_div">
			                        		<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_workTime_change"></span><span class="h2_text" onclick="functionFlag(4)"><spring:message code='ezAttitude.t7'/>
			                        			<c:if test="${totalAtt != 0 }">
													<span class="attCount">(${totalAtt})</span>
												</c:if>
			                        		</span>
			                            </div>
			                    	</span>
			                    </c:if>
		                    </span>        
		                </span>
		            </div>
		        </ul>
		        <c:if test="${attitudeAdminCheck == true}">
		        <ul class="lnbUL">
		        	<div class="tree">
		            	<span>
		                	<span>
		                		<span>
		                        	<div class="node_div">
		                        		<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_workTimeset"></span><span class="h2_text" onclick="functionFlag(5)"><spring:message code='ezAttitude.t73'/></span>
		                            </div>
		                    	</span>
		                    </span>
		                </span>    	
					</div>
				</ul>
				</c:if>
			</div>
	    </div>
	<%-- <div class="left_pims" title="<spring:message code='ezAttitude.t1'/>"><span><spring:message code='ezAttitude.t1'/></span></div>
	<div id="left" style="border-top:1px solid #dedede">
		<div style="display: block;">
			<article class="time">
	            <div id="timeinput" style="margin-bottom:15px; border:0px; font-weight:bold; color: black; letter-spacing:4px; font-size:18px; text-align:center; line-height:25px;">
	            	<div id="timeFlow" style='width:175px; margin:20px 0 20px 23px; font-size:30px; font-family:Arial, Helvetica, sans-serif;'><p></p></div>
	            </div>
				<div id="atti_area" style="text-align:center; width:219px; margin-bottom: 12px">
					<div class="sub_time">
    					<dl class="timeCheckIn">
    						<dt>출근</dt>
    						<dd id="inAttiBtn" class="out" type="A01" datetype="2" onClick="checkHoliday(this)">입력</dd>
    					</dl>
    					<dl class="timeCheckOut">
    						<dt>퇴근</dt>
    						<dd id="outAttiBtn" class="out" type="A03" datetype="2" onclick="checkHoliday(this)">입력</dd>
    					</dl>
    				</div>
					<p id="inAttiClock" style="margin:3px 0px 0px 7px; font-size:15px; text-align: left; margin-left:47px; padding-left:22px;"><spring:message code='ezAttitude.t64'/> : <spring:message code='ezAttitude.t71'/></p>
					<p id="outAttiClock" style="margin:7px 0px 30px 8px;  font-size:15px; text-align: left; margin-left:47px; padding-left:22px;"><spring:message code='ezAttitude.t65'/> : <spring:message code='ezAttitude.t72'/></p>
					<span id="inAttiBtn" type="A01" datetype="2" onclick="checkHoliday(this)"><spring:message code='ezAttitude.t64'/></span>
					<span id="outAttiBtn" type="A03" datetype="2" onclick="checkHoliday(this)" style="margin-left:2px"><spring:message code='ezAttitude.t65'/></span>
				</div>
			</article>
		</div>
<!-- 	<div id="left" style="border-top:1px solid #dedede"> -->
		<h2><span id="userAttitude" onclick="functionFlag(1)" style="width:100%; display:inline-block"><spring:message code='ezAttitude.t143'/></span></h2>
		<ul></ul>
		<h2><span id="deptAttitude" onclick="functionFlag(2)" style="width:100%; display:inline-block"><spring:message code='ezAttitude.t144'/></span></h2>
		<ul></ul>
		<h2>
			<c:if test="${attitudeAdminCheck != true}">
				<span id="" onclick="functionFlag(3)" style="width:100%; display:inline-block">
				<spring:message code = 'ezAttitude.t7' />
			</span>
			</c:if>
			<c:if test="${attitudeAdminCheck == true}">
				<span id="" onclick="functionFlag(4)" style="width:100%; display:inline-block">
				<spring:message code = 'ezAttitude.t7' />
				<c:if test="${totalAtt != 0 }">
					<span class="attCount">(${totalAtt})</span>
				</c:if>
			</span>
			</c:if>
		</h2>
		<ul>
			<c:if test="${attitudeAdminCheck == true}">
				<li>
					<span id="" onclick="functionFlag(4)" style="width:100%;display:inline-block">
						&nbsp;<spring:message code='ezAttitude.t7'/>
						<c:if test="${totalAtt != 0 }">
							<span class="attCount">(${totalAtt})</span>
						</c:if>
					</span>
				</li>
			</c:if>
			<li><span id="" onclick="functionFlag(3)" style="width:100%;display:inline-block">&nbsp;<spring:message code='ezAttitude.t166'/></span></li>
		</ul>
		<c:if test="${attitudeAdminCheck == true}">
			<h3><span id="" onclick="functionFlag(5)" style="width:100%;display:inline-block"><spring:message code='ezAttitude.t73'/></span></h3>
		</c:if>
	</div> --%>
</body>
</html>