<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<style>
			.h2_dot {
				background: url(/images/kr/left/left_dot02.gif) no-repeat 0px 70%;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>	    
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	    <script type="text/javascript">
			var startdate = "<c:out value='${startDate}' />";
			var enddate = "<c:out value='${endDate}' />";
			var filter = "<c:out value='${filter}' />";
			var keyword = "<c:out value='${keyword}' />";
			var offSetMin = "<c:out value='${offSetMin}' />";
			var usedate = false;
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        if (startdate != "") {
		        	document.getElementById("usedate").checked = true;
		            //document.getElementById('keyword').value = keyword;
			        $("#Sdatepicker").datepicker('enable');
			        $("#Edatepicker").datepicker('enable');
			        usedate = true;
				//////////////////
		        } else {
		        	document.getElementById("usedate").checked = false;
			        $("#Sdatepicker").datepicker('disable');
			        $("#Edatepicker").datepicker('disable');
			        usedate = false;
		        }
				//////////////////
				
				/* 2018-07-20 홍승비 - 일정검색 > 검색결과 좌측네모 IE에서 높이조절 */
		        if (navigator.userAgent.toLowerCase().indexOf('chrome') == -1) {
					document.getElementsByClassName("h2_dot")[0].style.background = "url(/images/kr/left/left_dot02.gif) no-repeat 0px 67%";
		        }
		    }
			
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        var SDate;
		        var EDate;
		        
		        if (startdate != "") {	
		            SDate = new Date(startdate);
		            EDate = new Date(enddate);
		        } else {
		            SDate = utcDate(offSetMin);
		            EDate = utcDate(offSetMin);		            
		        }
		        
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', EDate);
		    });
		    
		    var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		        	closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
		            monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
		
		    function search() {
		        /* 특수문자 유효성검사 */
		    	//if (specialChk(document.getElementById("keyword").value)) {
		    	//	alert("<spring:message code='ezResource.special' />");
		    	//	return;
		    	//}
		    	
                // 2024-06-27 전인하 - 일정관리 > 검색 > 전체검색, 지역검색 추가
                // 로직 변경에 따른 미사용 변수 삭제 (searchColumn, searchData)
		        var sdate = "";
		        var edate = "";
		        var keyword = "";

		        var all = document.getElementById("all").value.trim();
		        var title = document.getElementById("title").value.trim();
		        var location = document.getElementById("location").value.trim();
		        
		        if (document.getElementById("usedate").checked == false && all == "" && title == "" && location == "")  {
		            alert("<spring:message code='ezSchedule.t346'/>");
                    return;
		        }
		        
		        var filter = "search";		        
		        var useDate = document.getElementById("usedate").checked;
		        if (document.getElementById("usedate").checked) {
		            sdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		            edate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        } 

		        if (sdate > edate) {
		        	alert("<spring:message code='ezResource.dateChk' />");
		        	return;
		        }		        
		        window.location.href = "/ezSchedule/scheduleSearch.do?sdate=" + sdate + "&edate=" + edate + "&filter=" + encodeURIComponent(filter) + "&pAll=" + encodeURIComponent(all) + "&pTitle=" + encodeURIComponent(title) + "&pLocation=" + encodeURIComponent(location);
		        
		    }
		
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
			
		    function open_schedule(scheduleid, repeatcount, date, scheduletype, datetype, recurring, parentid) {
		        date = date.substring(0, 10);
		
		        if (scheduletype == "<spring:message code='ezSchedule.t281'/>") {
		            scheduletype = "1";
		        }
		
		        else if (scheduletype == "<spring:message code='ezSchedule.t12'/>") {
		            scheduletype = "2";
		        }
		
		        else if (scheduletype == "<spring:message code='ezSchedule.t11'/>") {
		            scheduletype = "3";
		        }
		
		        if(datetype == "4") {
		        	if (CrossYN()) {
		    			var OpenWin = window.open("/ezAttitude/attitudeItemView.do?attitudeId=" + scheduleid + "&typeId=" + parentid, "", GetOpenWindowfeature(672, 640));
		    			
		    			try { OpenWin.focus(); } catch (e) { }
		    		} else {
		    			window.showModalDialog("/ezAttitude/attitudeItemView.do?attitudeId=" + scheduleid + "&typeId=" + parentid, "", 
		    			    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
		    		}
		        } else {
			        var feature = GetOpenPosition(770, 660);
			        if (recurring == "1") {
			            window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&repeatcount=Y" + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&recurring=" + recurring + "&pageFrom=search&pattern=0", "",
								    "height = 670px, width = 770px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
			        }
			        else {
			            window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&repeatcount=" + repeatcount + "&type=" + scheduletype + "&date=" + date + "&datetype=" + datetype + "&recurring=" + recurring + "&pattern=0", "",
						            "height = 670px, width = 770px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
			        }		        	
		        }
		    }
		    
		    function open_google_schedule(scheduleid, repeatcount, startdate, enddate, scheduletype, datetype) {
		    	var feature = GetOpenPosition(770, 650);
		    	window.open("/ezSchedule/googleScheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&repeatcount=" + repeatcount + "&type=" + scheduletype + "&startdate=" + startdate + "&enddate=" + enddate + "&datetype=" + datetype, "",
			            "height = 670px, width = 770px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
			
		    function RefreshView() {
                var all = document.getElementById("all").value.trim();
                var title = document.getElementById("title").value.trim();
                var location = document.getElementById("location").value.trim();
		        window.location.href = "/ezSchedule/scheduleSearch.do?sdate=" + sdate + "&edate=" + edate + "&filter=" + encodeURIComponent(filter) + "&pAll=" + all + "&pTitle=" + title + "&pLocation=" + location;
		    }
			
		    function onmouseOver(elem) {
		        elem.style.color = "blue";
		        elem.style.backgroundColor = "#f1f8ff";
		    }
		
		    function onmouseOut(elem) {
		        elem.style.color = "";
		        elem.style.backgroundColor = "#FFFFFF";
		    }
			
		    function search_keypress(evt) {
		        var evtKeyCode = (window.event) ? event.keyCode : evt.which;
		
		        if (evtKeyCode == "13") {
		            search();
		        }
		    }
			//////////////////
			function DateSearch_Click() {
		        if(usedate){
		        	usedate = false;
		            $("#Sdatepicker").datepicker('disable');
		            $("#Edatepicker").datepicker('disable');
		        } else {
		        	usedate = true;
		            $("#Sdatepicker").datepicker('enable');
		            $("#Edatepicker").datepicker('enable');
		        }
		    }
			//////////////////
			
			// 2024-06-27 전인하 - 일정 > 일정검색 > 전체검색, 지역검색 추가
            // 전체검색 / 상세검색 토글버튼
			function detailSearch() {
			    $('.detailSearch').toggleClass('on');
                $('#detailSearchBtn').toggleClass('on');
                
                if ($('.detailSearch').hasClass('on')) {
                    $('.detailSearch').show();
                } else {
                    $('.detailSearch').hide();
                }
                
                if ($('#detailSearchBtn').hasClass('on')) {
                    $('#all').val('');
                    $('#all').prop('disabled', true);
                } else {
                    $('#all').prop('disabled', false);
                    $('#title').val('');
                    $('#location').val('');
                    if ($('#usedate').is(':checked')) {
                        $('#usedate').trigger('click');
                    }
                }
			}
		</script>
	</head>
	<body class="mainbody"> 
		<form method="post"> 
			<h1><spring:message code='ezSchedule.t347'/></h1> 
		  	<table style="width:100%" class="content">  
		    	<tr> 
		      		<th><spring:message code='ezSchedule.t267'/><spring:message code='ezSchedule.t24'/></th> 
		      		<td style="width:100%">
		      			<div style="vertical-align: middle;height: 83%;width: 100%;">
		      			    <%-- 2024-06-27 전인하 - 일정관리 > 검색 > 전체검색, 지역검색 추가
			      			<select name="search_field" style="WIDTH: 70px;height:22px"> 
			      			    <option value="all" <c:if test="${filter eq 'all' }">selected</c:if>><spring:message code='ezSchedule.t267'/></option> 
			          			<option value="title" <c:if test="${filter eq 'title' }">selected</c:if>><spring:message code='ezSchedule.t272'/></option> 
			          			<option value="location" <c:if test="${filter eq 'location' }">selected</c:if>><spring:message code='ezSchedule.t273'/></option> 
			        		</select> 
			        		--%>
			        		<input type="text" id="all" size="30" maxlength="20" value="<c:out value='${keyword}'/>" onkeypress="return search_keypress(event)" style="height:22px;vertical-align: top" /> 
			        		<a class="imgbtn imgbck" style="height: 22px;" id="detailSearchBtn"><span onClick="detailSearch()"><spring:message code='ezEmail.pyy02'/></span></a>
		        		</div>
		        	</td> 
		    	</tr> 
		    	<%-- 2024-06-27 전인하 - 일정관리 > 검색 > 전체검색, 지역검색 추가 --%>
		    	<tr class="detailSearch" style="display: none;"> 
                    <th><spring:message code='ezSchedule.t272'/><spring:message code='ezSchedule.t24'/></th> 
                    <td style="width:100%">
                        <div style="vertical-align: middle;height: 83%;width: 100%;">
                            <input type="text" id="title" size="30" maxlength="20" value="<c:out value='${keyword}'/>" onkeypress="return search_keypress(event)" style="height:22px;vertical-align: top" />
                        </div>
                    </td> 
                </tr> 
                <tr class="detailSearch" style="display: none;"> 
                    <th><spring:message code='ezSchedule.t273'/><spring:message code='ezSchedule.t24'/></th> 
                    <td style="width:100%">
                        <div style="vertical-align: middle;height: 83%;width: 100%;">
                            <input type="text" id="location" size="30" maxlength="20" value="<c:out value='${keyword}'/>" onkeypress="return search_keypress(event)" style="height:22px;vertical-align: top" />
                        </div>
                    </td> 
                </tr> 
		    	<tr class="detailSearch" style="display: none;"> 
		      		<th><spring:message code='ezSchedule.t349'/></th>
		      		<td>
		      			<input type="checkbox" value="1" id="usedate" onclick="DateSearch_Click();" style="margin-top: 1px;" /><label for="usedate"><spring:message code='ezSchedule.t350'/></label>
		            	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"/> ~
		      			<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"/>
		          		<span>&nbsp;(<spring:message code='ezSchedule.t351'/></span> 
		          		<!-- <tr style="DISPLAY:none"> 
		            		<td colspan="2">
		                    	<span id="T_st">
		                      		<input id='_T1' class='datepicker_time' readonly type="text" style="PADDING-RIGHT:3px;PADDING-LEFT:3px;PADDING-BOTTOM:0px;WIDTH:73px;PADDING-TOP:2px" />
					          		<img id='img_StartTime' style=" cursor: pointer;" popupLocation='bottomright'  forcemarginleft='-40'  forceMarginTop='-10' src="/images/i_time.gif" width="19" height="15" align="absmiddle" hspace="2" />
					          	</span>
		        				<input id='_T2' class='datepicker_time' readonly type="text" style="PADDING-RIGHT:3px;PADDING-LEFT:3px;PADDING-BOTTOM:0px;WIDTH:73px;PADDING-TOP:2px" />
					          	<img id='img_EndTime' style=" cursor: pointer;" popupLocation='bottomright'  forcemarginleft='-40'  forceMarginTop='-10' src="/images/i_time.gif" width="19" height="15" align="absmiddle" hspace="2" />
					        </td> 
			          	</tr> -->
			  		</td>
			  	</tr>
		  	</table> 
		 	<br/>
		 	<div style="text-align: center;">
		 	    <a class="imgbtn imgbck" style="height: 30px; line-height: 30px; "><span style="vertical-align: middle;" onClick="search()"><spring:message code='ezSchedule.t24'/></span></a>
		 	</div>
		 	<h2 class="h2_dot">
		 		<spring:message code='ezSchedule.t295'/>&nbsp;<span class="point">${fn:length(scheduleList)}</span>&nbsp;<span id="resultCount"></span><spring:message code='ezSchedule.t296'/>
		    </h2>		
		  	<table class="mainlist" style="table-layout:fixed;width:100%">
		    	<tr> 
		      		<th colspan=2 style="width:30px; text-align:center; padding:0 2px"><img src="/images/ImgIcon/view-importance.gif"></th>      
		      		<c:choose>
		      			<c:when test="${lang == 1 }">
				      		<th style="width:50px">
		      			</c:when>
		      			<c:otherwise>
				      		<th style="width:70px">
		      			</c:otherwise>
		      		</c:choose>
		      		<spring:message code='ezSchedule.t270'/></th> 
		      		<th style="width:80px"><spring:message code='ezSchedule.t271'/></th> 
		      		<th style="width:80px"><spring:message code='ezSchedule.t161'/></th> 
		      		<th style="width:60%"><spring:message code='ezSchedule.t272'/></th>
		      		<th style="width:140px"><spring:message code='ezSchedule.t273'/></th> 
		      		<th style="width:140px"><spring:message code='ezSchedule.t274'/></th> 
		      		<th style="width:140px"><spring:message code='ezSchedule.t275'/></th> 
		    	</tr>
		    	<c:forEach var="item" items="${scheduleList}">
		    	<c:if test="${item.scheduleType == '9'}">
		    	<tr style="cursor:pointer;padding:0" onClick="open_google_schedule('${item.scheduleId}','${item.repeatCount}','${item.startDate}','${item.endDate}','${item.scheduleType}','${item.dateType}')" bgcolor=#ffffff>
		    	</c:if>
		    	<c:if test="${item.scheduleType != '9'}">
		    	<tr style="cursor:pointer;padding:0" onClick="open_schedule('${item.scheduleId}','${item.repeatCount}','${item.startDate}','${item.scheduleType}','${item.dateType}','','${item.parentId}')" bgcolor=#ffffff>
		    	</c:if>
		    		<td colspan=2 style="padding:0 2px;width:30px;text-align:center;">
		    			<c:if test="${item.importance == '1'}"><img src='/images/calendar/i_l.png' width='13' height='13'/></c:if>
		    			<c:if test="${item.importance == '2'}">&nbsp;</c:if>
		    			<c:if test="${item.importance == '3'}"><img src='/images/calendar/i_h.png' width='13' height='13'/></c:if>
		    		</td>
		    		<td style="width:50px">
		    			<c:if test="${item.scheduleType == '1'}"><spring:message code='ezSchedule.t281'/></c:if>
		    			<c:if test="${item.scheduleType == '2'}"><spring:message code='ezSchedule.t12'/></c:if>
		    			<c:if test="${item.scheduleType == '3'}"><spring:message code='ezSchedule.t11'/></c:if>
		    			<c:if test="${item.scheduleType == '4'}"><spring:message code='ezSchedule.t282'/></c:if>
		    			<!-- 2018.02.06 김기하 #11433  -->
		    			<c:if test="${item.scheduleType == '6'}"><spring:message code='ezSchedule.t281'/></c:if>
		    			<c:if test="${item.scheduleType == '7'}"><spring:message code='ezSchedule.t282'/></c:if>
		    			<c:if test="${item.scheduleType == '8'}"><spring:message code='ezSchedule.t12'/></c:if>
		    			<c:if test="${item.scheduleType == '9'}"><spring:message code='ezSchedule.google12'/></c:if>
						<c:if test="${item.scheduleType == '10'}"><spring:message code='ezSchedule.lyj09'/></c:if>
		    		</td>
		    		<c:if test="${primary == '1'}">
		    			<td style="width:80px">${item.ownerName}</td> 
		              	<td style="width:80px">${item.creatorName}</td>
		    		</c:if>
		    		<c:if test="${primary != '1'}">
		    			<td style="width:80px">${item.ownerName2}</td> 
		            	<td style="width:80px">${item.creatorName2}</td>
		    		</c:if>
		    		<td style="width:60%"><c:out value="${item.title}"/></td> 
	          		<td style="width:140px"><c:out value="${item.location}"/></td>		         
	            	<td style="width:140px">	            		
	            		<c:if test="${item.dateType == '2'}">${fn:substring(item.startDate,0,10)} (<spring:message code='ezSchedule.t280'/></c:if>
	            		<c:if test="${item.dateType != '2'}">${fn:substring(item.startDate,0,16)}</c:if>	            		
	            	</td> 
	            	<td style="width:140px">
	            		<c:if test="${item.dateType == '2'}">${fn:substring(item.endDate,0,10)} (<spring:message code='ezSchedule.t280'/></c:if>
	            		<c:if test="${item.dateType != '2'}">${fn:substring(item.endDate,0,16)}</c:if>	
	            	</td>
		    	</tr>
		    	</c:forEach>		    	
		    	<c:if test="${fn:length(scheduleList) == 0 && keyword != null && startDate != null}">
		    	<tr> 
		        	<td colspan="9" style="text-align:center"><spring:message code='ezSchedule.t297'/></td> 
		      	</tr>
		      	</c:if>
		  	</table>		
		</form> 
	</body>
</html>

