<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<c:choose>
			<c:when test="${checkBrowser == true}">
				<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/CalendarMini_IEEIP.js')}"></script>
			</c:when>
			<c:otherwise>
				<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/CalendarMini_EIP.js')}"></script>
			</c:otherwise>
		</c:choose>
		<script type="text/javascript">
			var pMode = "P";
			var strLang2_total = "<spring:message code='main.t00026' />";
			var openerCalendarMiniView, openerCalendarMiniDataSource;
	    	
			window.onload = function () {
	    		openerCalendarMiniView = CalendarMiniView;
	    		openerCalendarMiniDataSource = CalendarMiniDataSource;
	    		
	    		CalendarMiniView("CalendarMini");	    		
	    		CalendarMiniDataSource();
	    		
	    		var newDate = new Date();
	    		var nDate = (newDate.getDate().length > 1 ? '0'+newDate.getDate() : newDate.getDate());
	    		
		        var str4 = strLang4.split(";");
		        var nDay = newDate.getDay();
		        
		        $("#tText").html(str4[nDay]);
		        $("#tDay").html(nDate);
	    		
	    		getScheduleList(nowDay, "P");
	    		
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            	document.body.style.MozUserSelect = 'none';
	            	document.body.style.WebkitUserSelect = 'none';
	            	document.body.style.khtmlUserSelect = 'none';
	            	document.body.style.oUserSelect = 'none';
	            	document.body.style.UserSelect = 'none';
	        	}
	    	}
	    	
	    	function getScheduleList(date, mode) {
			    selDate = date;			    

			    $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezSchedule/scheduleNewWebPartList.do",
		    		data : {
		    			selectDate  : date		    			
		    		},
		    		success: function(text){
		    			getScheduleList_after(text, mode, date);
		    		}
			    });
			}

			function getScheduleList_after(text, mode, date) {
			    try {
			    	if($('.nodata')){
				    	$('.nodata').remove();
			    	}
			        var xmldom = createXmlDom();
			        xmldom = loadXMLString(text);
			        
			        var count = 0;			        
			        //2018-07-04 포탈에서 read.do 호출시 출처를 알기위한 변수추가
		            var pageFrom = 'Portal';

			        var newDate = new Date();
			        var sDate = date.split("-");
			        newDate.setFullYear(sDate[0], sDate[1]-1, sDate[2]);
			        
			        var str4 = strLang4.split(";");
			        var nDay = newDate.getDay();

			        $("#dayT").html(str4[nDay]);
			        $("#dayN").html(sDate[2]);
			        
			        listHTML = "";

			        for (var i = 0; i < xmldom.getElementsByTagName("ROW").length; i++) {
		        		var SCHEDULETYPE = getNodeText(xmldom.getElementsByTagName("SCHEDULETYPE").item(i));
			            var SCHEDULEID = getNodeText(xmldom.getElementsByTagName("SCHEDULEID").item(i));			            
			            var DATETYPE = getNodeText(xmldom.getElementsByTagName("DATETYPE").item(i));
			            var REPEATCOUNT = getNodeText(xmldom.getElementsByTagName("REPEATCOUNT").item(i));
			            var STARTDATE = getNodeText(xmldom.getElementsByTagName("STARTDATE").item(i));
			            var ENDDATE = getNodeText(xmldom.getElementsByTagName("ENDDATE").item(i));
			            var TITLE = getNodeText(xmldom.getElementsByTagName("TITLE").item(i));
			            /* var startdate = new Date(STARTDATE.split(' ')[0].split('-')[0], STARTDATE.split(' ')[0].split('-')[1], STARTDATE.split(' ')[0].split('-')[2]);
			            var enddate = new Date(ENDDATE.split(' ')[0].split('-')[0], ENDDATE.split(' ')[0].split('-')[1], ENDDATE.split(' ')[0].split('-')[2]); */
			            var startTime = STARTDATE.split(' ')[1].substring(0,5);
			            var endTime = ENDDATE.split(' ')[1].substring(0,5);
			            var selDateType = new Date(selDate.substring(0, 4), selDate.substring(5, 7), selDate.substring(8, 10));			            
			            
		                listHTML += "<li class='scheduleLi' onClick=\"open_schedule('" + SCHEDULEID + "','" + SCHEDULETYPE + "','" + DATETYPE + "','" + REPEATCOUNT + "','" + STARTDATE + "','" + pageFrom + "')\">";
		                listHTML += "<p class='scheduleTime'>";
		                
		                if(SCHEDULETYPE == 1) {
		                	listHTML += "<span class='Tindividual'><spring:message code='ezSchedule.t221' /></span>";
		                } else if (SCHEDULETYPE == 2) {
		                	listHTML += "<span class='Tdept'><spring:message code='ezSchedule.t222' /></span>";
		                } else if (SCHEDULETYPE == 3) {
		                	listHTML += "<span class='Tcompany'><spring:message code='ezSchedule.t223' /></span>";
		                } else if (SCHEDULETYPE == 7) {
		                	listHTML += "<span class='Tgroup'><spring:message code='main.t00022' /></span>";
		                } else {
		                	listHTML += "";
		                }
		                
		                listHTML += "<span class='timeText'>" + startTime + " ~ " + endTime + "</span></p>";
		                listHTML += "<p class='scheduleText'>";
		                listHTML += MakeXMLString(TITLE)+"</p></li>";
		                count++;
			        }

		        	//$('#ScheduleList').css("width", "80%");
		        	
		        	var cnt = 4 - count;
		        	
		        	while(cnt--) {
		        		listHTML += "<li class='scheduleLi_nodata'>";
		        		listHTML += "<p class='sNodataText'>"+ strLang277 + "</p>";
		        		listHTML += "<p class='sNodataPlus' onclick='scheduleWrite()'><img src='/images/kr/main/schedule_plus.png'></p></li>";
		        	}
		        	
		            document.getElementById("ScheduleList").innerHTML = listHTML;

			    } catch (e) {}
			}
			
			function scheduleWrite() {
				var wWeight = "790";
                var wHeight = "830";

                var heigth = window.screen.availHeight;
                var width = window.screen.availWidth;

                var left = (width - wWeight) / 2;
                var top = (heigth - wHeight) / 2;
                
                window.open("/ezSchedule/scheduleWrite.do?defaultid=0", "",
                "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
			}
			
			function open_schedule(scheduleid, scheduletype, datetype, repeatcount, date, pageFrom) {
			    date = date.substr(0, 10);

			    var wWeight = "760";
			    var wHeight = "670";
			    var heigth = window.screen.availHeight;
			    var width = window.screen.availWidth;
			    var left = (width - wWeight) / 2;
			    var top = (heigth - wHeight) / 2;

			    //PNO-3
			    if (CrossYN())
			        window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0 &pageFrom="+pageFrom, "",
		                "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
			    else
			        window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0 &pageFrom="+pageFrom, "",
		                "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
			    //PNO-3 END
			}
			
			function goSchedule() {
				window.open("/ezSchedule/scheduleIndex.do?funCode=2", "main", "");
			}
		</script>
	</head>
	<body>
    	<div class="layDIV02">
            <dl class="portlet_title">
                <dt class="portletText"><spring:message code='main.t203' /></dt>
                <dd class="portletPlus" onclick="goSchedule();"><img src="/images/kr/main/portlet_Plus.png"></dd>
            </dl>
            <div class="CalendarArea">
                <div id="CalendarMini" class="calender"></div>
                <dl class="todayDate">
                    <dt class="Dgray"><spring:message code='main.t0606' /></dt>
                    <dd class="dayText" id="tText"></dd>
                    <dd class="dayNum" id="tDay"></dd>
                </dl>
            </div>
            <div class="schedule_list">
            	<ul class="scheduleUL" id="ScheduleList"></ul>
                <dl class="scheduleDate">
                    <dt class="dayT" id="dayT"></dt>
                    <dd class="dayN" id="dayN"></dd>
                </dl>
            </div>
        </div>
		
		<!-- 2018-08-21 장진혁 포틀릿 변경으로 주석처리 -->
		<%-- <section  class="body_bg1">
			<article class="portletbox graphbox">
				<div class="title_nb"><span class="tl_nb"></span><span class="tr_nb"></span><span class="title_txt"><spring:message code='main.t00002' /></span></div>
				<div class="graphcont">
    				<!-- 그래프영역 -->
    				<!-- UI Object -->        				
       				<c:choose>
       					<c:when test="${not empty list}">
       						<div class="v_graph">
        						<span class="r_arrow"> ^</span>
	        					<span class="l_arrow"> ^</span>
    	    					<span class="maxtxt">${dMaxCount } max</span>
	        					<ul>
				                	<c:forEach var="item" items="${list}">
			                			<li>
											<span class="g_term">${item.displayName}</span>
				                    		<span class="g_bar1" style="height:${item.draftCount}%"></span>
				                    		<span class="g_bar2" style="height:${item.susinCount}%"></span>
										</li> 
				               		</c:forEach>
	        					</ul>
	        				</div>	
       					</c:when>
       					<c:otherwise>
       						<div class="nodata_portlet">
       							<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>
       							<p><spring:message code='main.t00026' /></p>
       						</div>
       					</c:otherwise>
       				</c:choose>
				</div>
				<!-- //UI Object -->    			
				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>
		</section> --%>
	</body>
</html>