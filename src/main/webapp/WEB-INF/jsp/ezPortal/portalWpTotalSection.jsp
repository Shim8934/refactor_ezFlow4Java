<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="refresh" content="${refreshSecond}">
		
		<section class="body_bg2">
			<article  class="personal">
				<p>
					<span class="info_set">
						<span id="ModInfo" onClick="btnSumming_click(this)"></span>
					</span>
				 	<strong id="personName" style="position:absolute; width:240px; overflow:hidden; white-space:nowrap; text-overflow:ellipsis;">${displayName} ${mailAddress } </strong>
				 </p>
				<div class="info">
    				<p class="pic"><c:if test='${userPhoto == ""}'><img src="/images/no_image.jpg" /></c:if><c:if test='${userPhoto != ""}'>${userPhoto}</c:if></p>
    				<dl class="info_txt">
    					<c:choose>
	   						<c:when test="${fn:length(companyList) gt 1 }">
	    						<dt>
									<select id="selectCompany" style="margin-left:-3px;margin-bottom:2px; width: 195px; font-size: 9pt;" onchange="changeCompany();">
										<c:forEach items="${companyList }" var="company">
											<option value="${company.deptID }" <c:if test="${userInfo.deptID eq company.deptID }">selected="selected"</c:if> companyID="${company.companyID }">
												${company.companyName } (${company.deptName }) (${company.apprCount })
											</option>
										</c:forEach>
									</select>
								</dt>
	   						</c:when>
							<c:otherwise>
		        				<dt>${companyNm}<br></dt>
	        				</c:otherwise>
    					</c:choose>
			 			<dd>${department} ${title}</dd>
						<dd class="gray" title="${loginIP}"><spring:message code="main.t00016" />  ${lastLogin}</dd>
    				</dl>
    				<div class="bottom"></div>
    			</div>
    			<div class="personal_content" style="${useCircular == 'YES' ? '' : 'display:none'}">
					<a id="NewMail" onClick="btnSumming_click(this)">
						<ul>
							<li class="count">
								<div>
									<span id="mailnum">0</span>
								</div>
							</li>
                    		<c:choose>
                    			<c:when test="${userInfo.lang != '3'}">
                    				<li class="title"><spring:message code="main.t00017" /></li>
                    			</c:when>
                    			<c:otherwise>
                    				<li class="title1"><spring:message code="main.t00017" /></li>
                    			</c:otherwise>
                    		</c:choose>
						</ul>
					</a>
					
					<a id="AprSign" onClick="btnSumming_click(this)">
						<ul>							
							<li class="count">
								<div>
									<span id="aprnum">0</span>
								</div>
							</li>
                   			<c:choose>
	                   			<c:when test="${userInfo.lang != '3'}">
	                   				<li class="title"><spring:message code="main.t00018" /></li>
	                   			</c:when>
	                   			<c:otherwise>
	                   				<li class="title1"><spring:message code="main.t00018" /></li>
	                   			</c:otherwise>
                    		</c:choose>
						</ul>
					</a>
					<a id="Schedule" onClick="btnSumming_click(this)">
						<ul>
							<li class="count">
								<div>
									<span id="schedulenum">0</span>
								</div>
							</li>
                    		<c:choose>
                    			<c:when test="${userInfo.lang != '3'}">
                    				<li class="title"><spring:message code="main.t00019" /></li>
                    			</c:when>
                    			<c:otherwise>
                    				<li class="title1"><spring:message code="main.t00019" /></li>
                    			</c:otherwise>
                    		</c:choose>
						</ul>
					</a>
					<a id="Poll" onClick="btnSumming_click(this)">
						<ul>
							<li class="count">
								<div>
									<span><c:if test="${pollNum > 99}">99+</c:if><c:if test="${pollNum <= 99}">${pollNum}</c:if></span>
								</div>
							</li>
                    		<c:choose>
                    			<c:when test="${userInfo.lang != '3'}">
                    				<li class="title"><spring:message code="main.t00020" /></li>
                    			</c:when>
                    			<c:otherwise>
                    				<li class="title1"><spring:message code="main.t00020" /></li>
                    			</c:otherwise>
                    		</c:choose>
						</ul>						
					</a>
					<c:if test="${useCircular == 'YES'}">
					<a id="Circular" onClick="btnSumming_click(this)">
						<ul class="last">
							<li class="count">
								<div>
									<span id="circularCnt">0</span>
								</div>
							</li>
                    		<c:choose>
                    			<c:when test="${userInfo.lang != '3'}">
                    				<li class="title"><spring:message code="ezCircular.t1" /></li>
                    			</c:when>
                    			<c:otherwise>
                    				<li class="title1"><spring:message code="ezCircular.t1" /></li>
                    			</c:otherwise>
                    		</c:choose>                  		
						</ul>
					</a>			
					</c:if>			
				</div>
			</article>
      		<div class="blue_bar"></div>
         	<div class="schedule">
	  			<article class="list"> 
   			 		<div class="maintab01">
             			<p id="Psch" class="left_on" onclick="scheduleChangeTab(this)"><spring:message code="main.t00021" /></p>
             			<p id="Allsch" class="right" onclick="scheduleChangeTab(this)"><spring:message code="main.t00022" /></p>
             		</div>
          			<div class="scrollbox-play-light" style="position:relative; width:260px;height:126px;  "> 
						<div class="scrollbox" id="best-scrbox" style="width:260px; height:126px;overflow:hidden;"> 
    						<div class="content"> 
  								<div id="ScheduleList"></div>
					    	</div>					    
						    <div class="scrollbar-v"> 
	    						<img src="/images/<spring:message code='main.t00025' />/main/scrollbar_arrow_up_w.gif" class="button-up"> 
	    						<img src="/images/<spring:message code='main.t00025' />/main/scrollbar_ball_w.gif" class="thumb-v"> 
	    						<img src="/images/<spring:message code='main.t00025' />/main/scrollbar_arrow_down_w.gif" class="button-down"> 
	    					</div> 
						</div> 
					</div> 
   	   			</article>
	       		<!-- calender -->
	        	<article class="calender">
		            <div id="CalendarMini"></div>
				</article>
	      		<!-- /calender -->   
			</div>
   			<div class="blue_bar"></div>
			<div class="bannerlink_area">
    			<article class="writebanner">
        			<%-- <p><span id="mailwrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner01.gif" width="58" height="85"></span><span id="schedulewrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner02.gif" width="56" height="85"></span><span id="approvalwrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner03.gif" width="56" height="85"></span></p> --%>
        			<c:choose>
						<c:when test="${host == 'gw.freet.co.kr'}">
							<p><span id="mailwrite" onclick="btnWrite_onclick(this)" style="margin-left:0px"><img src="/images/<spring:message code='main.t00025' />/main/writebanner01.gif" width="62" height="85"></span><span id="schedulewrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner02.gif" width="62" height="85"></span><span id="approvalwrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner03.gif" width="62" height="85"></span></p>
						</c:when>
						<c:otherwise>
							<p><span id="mailwrite" onclick="btnWrite_onclick(this)" style="margin-left:0px"><img src="/images/<spring:message code='main.t00025' />/main/writebanner01.gif" width="62" height="85"></span><span id="schedulewrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner02.gif" width="62" height="85"></span><span id="approvalwrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner03.gif" width="62" height="85"></span></p>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${host == 'gw.freet.co.kr'}">
							<p><span id="addresswrite" onclick="btnWrite_onclick(this)" style="margin-left:0px"><img src="/images/<spring:message code='main.t00025' />/main/writebanner04.gif" width="62" height="85"></span><span id="resourcewrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner05.gif" width="62" height="85"></span><span id="boardwrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner06.gif" width="62" height="85"></span></p>
						</c:when>
						<c:otherwise>
							<p><span id="addresswrite" onclick="btnWrite_onclick(this)" style="margin-left:0px"><img src="/images/<spring:message code='main.t00025' />/main/writebanner04.gif" width="62" height="85"></span><span id="resourcewrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner05.gif" width="62" height="85"></span><span id="boardwrite" onclick="btnWrite_onclick(this)"><img src="/images/<spring:message code='main.t00025' />/main/writebanner06.gif" width="62" height="85"></span></p>
						</c:otherwise>
					</c:choose>
        			<%--<span id="mailwrite" onclick="btnWrite_onclick(this)"><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner01.gif" width="58" height="85"></span><span id="approvalwrite" onclick="btnWrite_onclick(this)"><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner02.gif" width="56" height="85"></span><span id="schedulewrite" onclick="btnWrite_onclick(this)"><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner03.gif" width="56" height="85"></span><span><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner04.gif" width="58" height="85"></span><span><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner05.gif" width="56" height="85"></span><span><img src="/images/<%=RM.GetString("t00025")%>/main/writebanner06.gif" width="56" height="85"></span>--%>
    			</article>
    		</div>
    		<div class="blue_bar"></div>
    		<article class="time" style="margin-right:0px">
	   			<c:choose>
	       			<c:when test="${isUseAttMenuItem == 'N'}">
				             <p class="title"><spring:message code='main.t00023' /></p>
				             <div id="clock_id" style="width: 120px; height: 120px; background: url(/images/WebPartSliderCI/analogu.png) no-repeat ; "></div>    
				             <div id="timeinput" style=" margin-left:10px ;width:104px; height:25px; border:0px; font-weight:bold; color: black; letter-spacing:4px; font-size:18px; font-family:Arial, Helvetica, sans-serif; text-align:center; line-height:25px;"></div>             
	       			</c:when>
	       			<c:otherwise>
						<div id="timeinput" style="font-weight:bold; color: black; text-align:center; width:122px;">
							<p id="todayTime" class="title" style="margin-left:0px"></p>
			            	<div id="timeFlow" style='margin:13px 0 15px 0; font-size:28px; letter-spacing:1px; font-family:Arial, Helvetica, sans-serif;'><p></p></div>
			            </div>
		    			<div id="atti_area" style="font-family:Arial, Helvetica, sans-serif; text-align:center; width:122px">
<%-- 		    				<p id="inAttiClock" style="margin-top:2px;margin-left:11px;font-size:12px;text-align: left; padding-left:20px"><spring:message code='ezAttitude.t64'/> : <spring:message code='ezAttitude.t71'/></p> --%>
<%-- 							<p id="outAttiClock" style="margin-top:5px;margin-left:11px;margin-bottom:16px;font-size:12px;text-align: left; padding-left:20px"><spring:message code='ezAttitude.t65'/> : <spring:message code='ezAttitude.t72'/></p> --%>
<%-- 							<span style="margin-left:13px" id="inAttiBtn" type="A01" datetype="2" onclick="checkHoliday(this)"><spring:message code='ezAttitude.t64'/></span> --%>
<%-- 							<span id="outAttiBtn" type="A03" datetype="2" onclick="checkHoliday(this)" style="margin-left:5px"><spring:message code='ezAttitude.t65'/></span> --%>
							<div class="main_time">
		    					<dl class="timeCheckIn">
		    						<dt>출근</dt>
		    						<dd id="inAttiBtn" class="out" type="A01" datetype="2" onClick="checkHoliday(this)">입력</dd>
		    					</dl>
		    					<dl class="timeCheckOut">
		    						<dt>퇴근</dt>
		    						<dd id="outAttiBtn" class="out" type="A03" datetype="2" onclick="checkHoliday(this)">입력</dd>
		    					</dl>
		    				</div>
		    			</div>
	       			</c:otherwise>
	       		</c:choose>  
   			</article>
		</section>
			
		<link rel="stylesheet" href="${util.addVer('main.e6', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/orbit-1.2.3.css')}" type="text/css" />
		<style>
			select {
				-webkit-appearance: none; border:1px solid #d5e0ef;min-height:20px;margin:0;padding: .1em .1em; background: url(/images/next.gif) no-repeat 97% 50%; padding-right:18px;background-color: white;
			}
			
			select::-ms-expand {
			    display: none;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezAttitude/Calendar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/jindo.all.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/selectbox.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/scrollbox.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.orbit-1.2.3.min.js')}"></script>
		<c:choose>
			<c:when test="${checkBrowser == true}">
				<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/CalendarMini_IEEIP.js')}"></script>
			</c:when>
			<c:otherwise>
				<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/CalendarMini_EIP.js')}"></script>
			</c:otherwise>
		</c:choose>
		<script type="text/javascript" src="${util.addVer('/js/jquery/raphael-min.js')}"></script>
		<script type="text/javascript">
			var UserOffset = "${userOffset}";
		    var pMode = "P";
		    var date = "";
		    var strLang1_total = "<spring:message code='main.t00025' />";
		    var strLang2_total = "<spring:message code='main.t00026' />";
		    var pUse_Editor = "${useEditor}";
			var isCircularUsed = "${isCircularUsed}";
			var month = "${curMon}";
	    	var totalCnt = 0;
	    	var totalPage = 0;
	    	var curPage = 0;
	    	var EndCnt = 6;
	    	var timer;
	    	/*근태관리 추가*/
		 	var serverTime = "${serverTime}";
		 	var nowAttiTime = "";
		 	var beforeAlertDate = "";
			var afterAlertDate = "";
			var overTime = "";
			var isUseAttMenuItem = "${isUseAttMenuItem}";
	    	
	    	document.onselectstart = function () { return false; };
		    
			$(document).ready(function(){
				$('#featured').orbit();
				
				window_onload_total();

				if (isCircularUsed != 'Y') {
					$(".personal_content a ul").css({'width': 100/$(".personal_content a ul").length + '%'});
					$(".personal_content a ul:last").attr("class","last");
					$(".personal_content").show();
				}
			});

			var timeDiff;
			
		    function window_onload_total() {
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			        document.body.style.MozUserSelect = 'none';
			        document.body.style.WebkitUserSelect = 'none';
			        document.body.style.khtmlUserSelect = 'none';
			        document.body.style.oUserSelect = 'none';
			        document.body.style.UserSelect = 'none';
			    }
			    
			    if (month < 10 && String(month).length == 1)
		            month = "0" + month;
		        
        	    document.getElementById("curMon").innerHTML = month;

	        	try { top.onresize() } catch (e) { }
	        	
	        	getbirthUserList();
			    /* CalendarMiniView("CalendarMini"); */
				
			    if ("${use_attitude}" == "YES") {
			    	parseDate();
			    	attiClock();
					setAttiBtnHover();
					getAttitudeList();
					getHolidayList();
			    }

			    /* CalendarMiniDataSource(); */
			    schedule_get_holiday();

		        try { top.onresize() } catch (e) { }

		        var scrollbox = {};
		        scrollbox.content1 = new Scrollbox();
		        scrollbox.best = new Scrollbox();
		        scrollbox.player = new Scrollbox();

		        var pulldown = {};
		        pulldown.choose = new Pulldown();
		        document.onselectstart = function () { return false; };

		        scrollbox.content1.touch("content1-scrbox", {
		            overflowY: "auto" // auto, scroll
		        });
		        scrollbox.best.touch("best-scrbox", {
		            overflowY: "scroll" // auto, scroll
		        });
		        scrollbox.player.touch("player-scrbox", {
		            overflowY: "scroll" // auto, scroll
		        });

		        try { top.onresize() } catch (e) { }
		        
		        //ajax로 각 모듈 counting 및 list 호출
		        //getnewmailcount();
		        getUnreadCountAll();
		        getnewapprovalcount();		        
		        getScheduleList(nowDay, pMode);
		        getNewCircularCount();
		        
		        if (isCircularUsed != 'Y') {
					$(".personal_content a ul").css({'width': 100/$(".personal_content a ul").length + '%'});
					$(".personal_content a ul:last").attr("class","last");
					$(".personal_content").show();
				}
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
			
			var selDate = "";
			
			function getScheduleList(date, mode) {
			    selDate = date;			    

			    $.ajax({
		    		type : "GET",
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
			   if (date == nowDay) {
		        	var xmldom = createXmlDom();
			        xmldom = loadXMLString(text);
			        
			        var count = 0;
			        var mType;
			        //2018-07-04 포탈에서 read.do 호출시 출처를 알기위한 변수추가
		            var pageFrom = 'Portal';
			        if (mode == "P") {
			        	//2018.02.05 김기하 #11421
			        	mType = "16";
			        } else {
			        	mType = "2345789";
			        }			        

			        for (var i = 0; i < xmldom.getElementsByTagName("ROW").length; i++) {
		        		var SCHEDULETYPE = getNodeText(xmldom.getElementsByTagName("SCHEDULETYPE").item(i));
		        		
		        		if (mType.indexOf(SCHEDULETYPE) > -1) {		        		
				            var SCHEDULEID = getNodeText(xmldom.getElementsByTagName("SCHEDULEID").item(i));			            
				            var DATETYPE = getNodeText(xmldom.getElementsByTagName("DATETYPE").item(i));
				            var REPEATCOUNT = getNodeText(xmldom.getElementsByTagName("REPEATCOUNT").item(i));
				            var STARTDATE = getNodeText(xmldom.getElementsByTagName("STARTDATE").item(i));
				            var ENDDATE = getNodeText(xmldom.getElementsByTagName("ENDDATE").item(i));
				            var TITLE = getNodeText(xmldom.getElementsByTagName("TITLE").item(i));
				            var startdate = new Date(STARTDATE.split(' ')[0].split('-')[0], STARTDATE.split(' ')[0].split('-')[1], STARTDATE.split(' ')[0].split('-')[2]);
				            var enddate = new Date(ENDDATE.split(' ')[0].split('-')[0], ENDDATE.split(' ')[0].split('-')[1], ENDDATE.split(' ')[0].split('-')[2]);
				            var selDateType = new Date(selDate.substring(0, 4), selDate.substring(5, 7), selDate.substring(8, 10));			            
			                
			                listHTML += "<li style='text-overflow: ellipsis; overflow: hidden; width: 240px; white-space: pre;'>";
			                listHTML += "<span style='CURSOR:pointer;'  onClick=\"open_schedule('" + SCHEDULEID + "','" + SCHEDULETYPE + "','" + DATETYPE + "','" + REPEATCOUNT + "','" + STARTDATE + "','" + pageFrom + "')\" title='" + MakeXMLString(TITLE) + "'>";
			                listHTML += "&nbsp;"
			                if(SCHEDULETYPE == 1) {
			                	listHTML += "";
			                } else if (SCHEDULETYPE == 2) {
			                	listHTML += "(<spring:message code='ezSchedule.t12' />)&nbsp;";
			                } else if (SCHEDULETYPE == 3) {
			                	listHTML += "(<spring:message code='ezSchedule.t11' />)&nbsp;";
			                } else if (SCHEDULETYPE == 7) {
			                	listHTML += "(<spring:message code='ezSchedule.t282' />)&nbsp;";
			                } else {
			                	listHTML += "";
			                }
			                /* listHTML += TITLE.replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/\"/g,"&quot;").replace(/\'/g,"&#39;").replace(/\n/g,"<br />")+ "</span></li>"; */
			                listHTML += MakeXMLString(TITLE)+"</span></li>"
			                count++;
			        	}
			        }
			        
			        listHTML += "</ul>";
			        
		        	var cnt = xmldom.getElementsByTagName("ROW").length;

		        	if (cnt > 99) {
		        		cnt = "99+";	
		        	}
		        	
		        	document.getElementById("schedulenum").innerHTML = cnt;
		        	
		        	if (cnt == "0") {
	                	$("#schedulenum").attr("class", "iconCount_none");
	                } else {
	                	$("#schedulenum").attr("class", "iconCount");
	                }
		        }

			}
			
			//회람판 신규 갯수 가져오기 2018-03-05 강민수92
	        function getNewCircularCount() {
	        	$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezCircular/getListCount.do",
					data : {
						listType : 'newCircular'
					},
					success: function(result){
						var cirCnt = result.count;
						
						if (cirCnt > 99) {
							cirCnt = "99+";		
						}						
						$("#circularCnt").html(cirCnt);

						if (cirCnt == "0") {
		                	$("#circularCnt").attr("class", "iconCount_none");
		                } else {
		                	$("#circularCnt").attr("class", "iconCount");
		                }
					}
				});
	        }
			
	        function getUnreadCountAll() {
	        	var mailboxList = [];
	        	
	        	var requestData = {
        			"mailboxList" : mailboxList
	        	}
	        	
	        	$.ajax({
                    url: "/ezEmail/getUnreadCountAll.do",
                    type: "POST",
                    contentType: "application/json",
                    dataType: "json",
                    data : JSON.stringify(requestData),
                    success : function(result) {
                    	try {
	                    	if (result.resultCode === "OK") {
	                    		var totalUnreadCountInAllAccounts = result.totalUnreadCountInAllAccounts;
	                    		
	                    		console.error("totalUnreadCountInAllAccounts=" + totalUnreadCountInAllAccounts);
	                    		
	    			        	if (totalUnreadCountInAllAccounts.length > 2) {
	    			        	    totalUnreadCountInAllAccounts = "99+";
	    			        	}			        	
	    			        	
	    		                document.getElementById("mailnum").textContent = totalUnreadCountInAllAccounts;
	                    	} else {
	                    		console.error(result.resultCode);
	                    	}
                    	} catch (e) {
                    		console.error(e);
                    	}
                    },
                    error : function(error) {
                        console.error(error);
                    }
                });
	        }
	        
			var xmlHttp_getnewmailcount_total = null;
			
			function getnewmailcount() {
				var xmlpara = createXmlDom();
                var objNode;
                createNodeInsert(xmlpara, objNode, "DATA");
                createNodeAndInsertText(xmlpara, objNode, "URL", "INBOX");
				
			    xmlHttp_getnewmailcount_total = createXMLHttpRequest();
			    xmlHttp_getnewmailcount_total.open("POST", "/ezEmail/getFolderUnreadCount.do", true);
			    xmlHttp_getnewmailcount_total.onreadystatechange = event_newmailcount;
			    xmlHttp_getnewmailcount_total.send(xmlpara);
			}

			function event_newmailcount() {
			    if (xmlHttp_getnewmailcount_total != null && xmlHttp_getnewmailcount_total.readyState == 4) {
			        if (xmlHttp_getnewmailcount_total.status > 199 && xmlHttp_getnewmailcount_total.status < 300) {
			        	var unreadcount = getNodeText(SelectNodes(xmlHttp_getnewmailcount_total.responseXML, "FOLDERUNREADCOUNT")[0]);
			        	
			        	if (unreadcount.length > 2) {
			        		unreadcount = "99+";
			        	}			        	
			        	
		                if(CrossYN()) {
		                    document.getElementById("mailnum").textContent = unreadcount;
		                }
		                else {
		                    document.getElementById("mailnum").innerText = unreadcount;
		                }

		                if (unreadcount == "0") {
		                	$("#mailnum").attr("class", "iconCount_none");
		                } else {
		                	$("#mailnum").attr("class", "iconCount");
		                }
			        }
			        xmlHttp_getnewmailcount_total = null;
			    }
			}

			function event_newmailcount_end() {
				if (xmlHttp != null && xmlHttp.readyState == 4) {
					if (xmlHttp.status > 199 && xmlHttp.status < 300) {
						document.getElementById("mailnum").innerText = xmlHttp.responseXML.getElementsByTagName("d:unreadcount").item(0).text;
					}
					xmlHttp = null;
				}
			}

			var xmlHttp_getnewapprovalcount_total = null;
			
			function getnewapprovalcount()  {
			    xmlHttp_getnewapprovalcount_total = createXMLHttpRequest();//new ActiveXObject("Microsoft.XMLHTTP");
				xmlHttp_getnewapprovalcount_total.open("Post", "/ezApprovalG/getWebPartCount.do", true);
				xmlHttp_getnewapprovalcount_total.onreadystatechange = event_newapprovalcount;
			    xmlHttp_getnewapprovalcount_total.send("<DATA><FLAG>1</FLAG></DATA>");
			}
			
			function event_newapprovalcount() {
			    if (xmlHttp_getnewapprovalcount_total != null && xmlHttp_getnewapprovalcount_total.readyState == 4) {
			    	if ((xmlHttp_getnewapprovalcount_total.status < 200) && (xmlHttp_getnewapprovalcount_total.status > 300)) {
			            xmlHttp_getnewapprovalcount_total = null;
						return;
					} else  {
						try {
		                    if(CrossYN()) {
		                    	var aprnumCnt = xmlHttp_getnewapprovalcount_total.responseXML.firstChild.textContent;
		                    	
		                    	if (aprnumCnt.length > 2) {		                    		
		                    		aprnumCnt = "99+";
		                    	}
		                        document.getElementById("aprnum").textContent = aprnumCnt;
		                    } else {
		                    	var aprnumCnt = xmlHttp_getnewapprovalcount_total.responseXML.firstChild.text;
		                    	
		                    	if (aprnumCnt.length > 2) {
		                    		aprnumCnt = "99+";
		                    	}
		                        document.getElementById("aprnum").innerText = aprnumCnt;		                        
		                    }

		                    if (aprnumCnt == "0") {
			                	$("#aprnum").attr("class", "iconCount_none");
			                } else {
			                	$("#aprnum").attr("class", "iconCount");
			                }
		                    
		                    xmlHttp_getnewapprovalcount_total = null;
						} catch(e) {
						    xmlHttp_getnewapprovalcount_total = null;
							return;
						}
					}
				}
			}
			
			// 표준모듈 (2007.03.23) 수정 : 전자메모보고 처리할 메모 갯수 		
			var xmlHttp_getMemocount_total = null;
			
			function getMemocount() {		
			    xmlHttp_getMemocount_total = createXMLHttpRequest();// new ActiveXObject("Microsoft.XMLHTTP");
			    xmlHttp_getMemocount_total.open("Post", "/myoffice/ezMemo/WebPartFolder/getWebPartCount.aspx", true);
			    xmlHttp_getMemocount_total.onreadystatechange = event_getMemocount;
			    xmlHttp_getMemocount_total.send("<DATA><FLAG>1</FLAG></DATA>");
			}
			
			function event_getMemocount() {
			    if (xmlHttp_getMemocount_total != null && xmlHttp_getMemocount_total.readyState == 4) {
			    	if ((xmlHttp_getMemocount_total.status < 200) && (xmlHttp_getMemocount_total.status > 300)) {
			            xmlHttp_getMemocount_total = null;
						return;
					} else {
						try {
						    document.getElementById("Memonum").innerText = xmlHttp_getMemocount_total.responseXML.text;
							xmlHttp_getMemocount_total = null;
						} catch(e) {
						    xmlHttp_getMemocount_total = null;
							return;
						}
					}
				}
			}
					
			function btnSumming_click(objThis) {
				var ifr = window.parent.parent.frames['topFrame'];
				var ifrw = (ifr.contentWindow) ? ifr.contentWindow : ifr
				
				if (objThis.id == "AprSign") {
					if ("${userApprovalG}" == ("YES")) {
						ifrw.topMenuToggle('ApprG');
					} else {
						ifrw.topMenuToggle('Appr');
					}
				} else if (objThis.id == "ModInfo") {
					window.open("/ezPortal/environmentMain.do?funCode=1", "main");
				} else if (objThis.id == "Workspace") {
					/* 2025-03-13 홍승비 - 협업 모듈에 고정된 하드코딩 문자열 제거 (ezWorkspace) */
					window.open("${workspaceContextRootUrl}/Account/SSO", "main");
				} else {
					ifrw.topMenuToggle(objThis.id);
				}
			}

		    function btnWrite_onclick(objThis) {
		        switch (objThis.id) {
		            case "mailwrite":
		                new_mail_onclick();
		                break;

		            case "approvalwrite":
		                openForm();
		                break;

		            case "schedulewrite":
	                    var wWeight = "790";
	                    var wHeight = "830";

	                    var heigth = window.screen.availHeight;
	                    var width = window.screen.availWidth;

	                    var left = (width - wWeight) / 2;
	                    var top = (heigth - wHeight) / 2;
	                    
	                    window.open("/ezSchedule/scheduleWrite.do?defaultid=0", "",
	                    "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
	                    
		                break;

		            case "addresswrite":
		                var wWeight = "600";
		                var wHeight = "500";

		                var heigth = window.screen.availHeight;
		                var width = window.screen.availWidth;

		                var left = (width - wWeight) / 2;
		                var top = (heigth - wHeight) / 2;
		                window.open("/ezAddress/addressWrite.do?ownerid=" + encodeURIComponent("${userInfo.id}") + "&folderid=&foldertype=", "",
		                "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                break;

		            case "resourcewrite":
		                if (CrossYN()) {
		                    var url = "/ezResource/scheduleAddSelect.do";

		                    schedule_add_select_cross_dialogArguments[0] = "";
		                    schedule_add_select_cross_dialogArguments[1] = btnWrite_onclick_Complete;
		                    var Schedule_Add_Select_Cross = GetOpenWindow(url, "Schedule_Add_Select_Cross", 552, 435);
		                    try { Schedule_Add_Select_Cross.focus(); } catch (e) {
		                    }
		                } else {
		                    var url = "/ezResource/scheduleAddSelect.do";
		                    var feature = "status:no;dialogWidth:552px;dialogHeight:430px;help:no;scroll:no;edge:sunken";
		                    feature = feature + GetShowModalPosition(552, 422);
		                    var ret = window.showModalDialog(url, "", feature);

		                    if (ret != undefined && ret[0][0] != undefined) {
		                        url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=" + ret[0][0];
		                        feature = "status:no;dialogWidth:770px;dialogHeight:700px;help:no;scroll:no;edge:sunken";
		                        feature = feature + GetShowModalPosition(700, 700);
		                        window.showModalDialog(url, ret, feature);
		                    }
		                }
		                break;

		            case "boardwrite":
		                var wWeight = "355";
		                var wHeight = "600";

		                var heigth = window.screen.availHeight;
		                var width = window.screen.availWidth;

		                var left = (width - wWeight) / 2;
		                var top = (heigth - wHeight) / 2;
		                window.open("/ezBoard/writeBoardSelect.do", "",
		                    "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		                break;
		        }
		    }
		    
		    function btnWrite_onclick_Complete(ret) {
		        if (ret != "close" && ret != undefined && ret[0][0] != undefined) {
		            url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=" + ret[0][0];

		            var Schedule_Add_ck = window.open(url, "Schedule_Add_Cross", GetOpenWindowfeature(820, 700));
		            
		            try { Schedule_Add_ck.focus(); } catch (e) {}
		        }
		    }
		    
		    var schedule_add_select_cross_dialogArguments = new Array();
		    
		    function new_mail_onclick() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var conWidth = pwidth * 0.8;
		        
		        if (conWidth > 890)
		            conWidth = 890;
		        
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;

                window.open("/ezEmail/mailWrite.do?cmd=NEW", "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		    }

		    var formURL = "";
		    var formDocType = "";
		    var getformcont_cross_dialogArguments = new Array();
		    var url = "";
		    
		    function openForm() {
		        var parameter = new Array();
		        parameter[0] = "${userInfo.deptID}";
		        parameter[1] = "A01000";

		        if ("${userApprovalG}" == ("YES")) {
		            url = "/ezApprovalG/getFormCont.do";
		        } else {
		            url = "/ezApproval/getFormCont.do";
		        }
		        
		        if (CrossYN()) {
		            getformcont_cross_dialogArguments[0] = parameter;
		            getformcont_cross_dialogArguments[1] = openForm_Complete;
		            var getFormCont_Cross = window.open(url, "/ezApproval/getFormCont.do", GetOpenWindowfeature(713, 570));
		            
		            try { getFormCont_Cross.focus(); } catch (e) {}
		        } else {
		            var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
		            var ret = window.showModalDialog(url, parameter, feature);
		            formURL = ret[0];
		            formDocType = ret[1];
		            
		            if (formURL != "cancel") {
		                openDraftUI(formURL, formDocType);
		            }
		        }
		    }

		    function openForm_Complete(ret) {
		        formURL = ret[0];
		        formDocType = ret[1];

		        if (formURL != "cancel") {
		            openDraftUI();
		        }
		    }

		    function openDraftUI() {
		        var pArgument = new Array();
		        var gb = "";
		        
		        if ("${userApprovalG}" == ("YES"))
		            gb = "G";
		        
	        	pArgument[0] = "${userInfo.id}";
	            pArgument[1] = formURL;
	            pArgument[2] = "DRAFT";
	            pArgument[3] = formDocType;
	            pArgument[4] = "0"
	            pArgument[5] = ""
	            pArgument[6] = ""
	            pArgument[7] = "";

	            var openLocation = "";
	            if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	                if (!isIE()) {
	                    alert("<spring:message code='main.t3000' />");
	                    return;
	                } else {
	                   var openLocation = "/ezApprovalG/draftuiHWP.do";
	                }
	            } else {
	                var openLocation = "/ezApprovalG/draftui.do";
	            }
	            
                openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
                openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1" + "&aprState=" + escape(pArgument[6]);
                openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
                
	            openwindow(openLocation, "", 890, 620);
	        }

		    function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
		        try {
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;

		            var left = 0;
		            var top = 0;

		            if (window.screen.width > 800) {
		                var pleftpos;

		                pleftpos = parseInt(width) - 967;
		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - pleftpos;

		                left = pleftpos / 2;
		            } else {

		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - 10;
		            }
		            window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

		        } catch (e) {}
		    }

		    function scheduleChangeTab(obj) {
		        switch (obj.id) {
		            case "Psch":
		                pMode = "P";
		                document.getElementById("Psch").className = "left_on";
		                document.getElementById("Allsch").className = "right";
		                break;
		            case "Allsch":
		                pMode = "ALL";
		                document.getElementById("Psch").className = "left";
		                document.getElementById("Allsch").className = "right_on";
		              
		                break;
		        }
		        
		        if(selDate != "")
		            getScheduleList(selDate, pMode);
		        else
		            getScheduleList(nowDay, pMode);
		    }
		    
		    function draw_clock() {
		        document.getElementById("clock_id").innerHTML = "";
		        canvas = Raphael("clock_id", 120, 120);
		        hour_hand = canvas.path("M60 60L60 30");
		        hour_hand.attr({ stroke: "#444444", "stroke-width": 3 });
		        minute_hand = canvas.path("M60 60L60 23");
		        minute_hand.attr({ stroke: "#444444", "stroke-width": 2 });
		        second_hand = canvas.path("M60 77L60 18");
		        second_hand.attr({ stroke: "#a0282a", "stroke-width": 1 });
		        var pin = canvas.circle(60, 60, 3);
		        pin.attr("fill", "#000000");
		        update_clock()
		        setInterval("update_clock()", 1000);
		    }
		   
		    function update_clock() {
		        var hours = getWorldTime(parseInt(UserOffset.split(':')[0]),parseInt(UserOffset.split(':')[1])).split(":")[0];
		        var minutes = getWorldTime(parseInt(UserOffset.split(':')[0]),parseInt(UserOffset.split(':')[1])).split(":")[1];
		        var seconds = getWorldTime(parseInt(UserOffset.split(':')[0]),parseInt(UserOffset.split(':')[1])).split(":")[2];
		        hour_hand.rotate(30 * hours + (minutes / 2.5), 60, 60);
		        minute_hand.rotate(6 * minutes, 60, 60);
		        second_hand.rotate(6 * seconds, 60, 60);
		    }
		    function stopClock() {
		        clearTimeout(gizmo);
		    }

		    function yourClock() {
		        var nd = new Date();
		        var h, m;
		        var s;
		        var time = " ";		        
		        time = getWorldTime(parseInt(UserOffset.split(':')[0]),parseInt(UserOffset.split(':')[1]));
		        document.getElementById("timeinput").innerHTML = time;
		        gizmo = setTimeout("yourClock()", 1000);
		    }

		    function getWorldTime(tzOffsetHour, tzOffsetMinute) { // 24시간제
		        var now = new Date();
		        var tz = now.getTime() + (now.getTimezoneOffset() * 60000) + (tzOffsetHour * 3600000) + (tzOffsetMinute * 60000);
		        now.setTime(tz);
		        var s =
		          leadingZeros(now.getHours(), 2) + ':' +
		          leadingZeros(now.getMinutes(), 2) + ':' +
		          leadingZeros(now.getSeconds(), 2);
		        return s;
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
			
		    function MonthMiniDbClick() {
		    }
		    
		    function reload() {
		        if (CrossYN()) {
		            if (document.getElementById("Psch").className == "left_on") {
		                document.getElementById("Psch").onclick();
		            } else {
		                document.getElementById("Allsch").onclick();
		            }
		        } else {
		            if (document.getElementById("Psch").className == "left_on") {
		                document.getElementById("Psch").click();
		            } else {
		                document.getElementById("Allsch").click();
		            }
		        }
		    }
			
		    /** 배현상 근태관리메서드 추가 */
		    function getAttitudeList() {
		    	$.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/ezAttitude/getAttitudeList.do",
		    		data : {},
		    		success : function(result) {
		    			for (var i = 0; i < result.length; i++) {
		    				if (result[i].typeId == "A01") {
 		    					$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
								$("#inAttiBtn").removeClass("out").addClass("in");
								$("#inAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
		    				} else if (result[i].typeId == "A02") {
		    					$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
								$("#inAttiBtn").removeClass("out").addClass("lateIn");
								$("#inAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
		    				} else if (result[i].typeId == "A03") {
//	 	    					$("#outAttiBtn").attr("onclick", "").unbind("mouseenter"); //퇴근은 여러번 찍을 수 있다.
								$("#outAttiBtn").removeClass("out").addClass("in");
								$("#outAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
		    				}
		    			}
		    		}
		    	})
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
		    		}
		    	}
		    	
		    	beforeAlertDate = new Date();
		    	var dateAlert = nowAttiTime.getFullYear() + "<spring:message code='ezAttitude.t66'/> " + (nowAttiTime.getMonth() + 1) + "<spring:message code='ezAttitude.t67'/> " + (nowAttiTime.getDate()) + "<spring:message code='ezAttitude.t68'/> " + leadingZeros(nowAttiTime.getHours(), 2) + ":" + leadingZeros(nowAttiTime.getMinutes(), 2) + ":"+ leadingZeros(nowAttiTime.getSeconds(), 2);

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
		    		},
		    		complete : function() {
		    			afterAlertDate = new Date();
			    		overTime = (afterAlertDate.getTime() - beforeAlertDate.getTime());
			    		nowAttiTime.setMilliseconds(nowAttiTime.getMilliseconds() + overTime);
		    		}
		    	})
		    }
		    
		    function getHolidayList() {
				$.ajax({
					type:"GET",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getHolidayList.do",
					data : {
						//isRest : "rest"
					},
					success : function(result) {
						for (var i = 0; i < result.holidayList.length; i++) {
							var isSolar = "";
							var holidayFlag = "";
							var repetition = "";
							
							if (result.holidayList[i].isSolar == "1") {
								isSolar = "1";
							} else {
								isSolar = "2";
							}
							
							if (result.holidayList[i].holidayDate == null) {
								result.holidayList[i].holidayDate = '';
							}
							
							if (result.holidayList[i].holidayRepeat == null) {
								repetition = '';
							} else {
								repetition = result.holidayList[i].holidayRepeat;
							}
							
							if (result.holidayList[i].holidayFlag == 'Y') {
								holidayFlag = "Y";			                    
			                } else {
			                    holidayFlag = "D";
			                }
							
							if (result.holidayList[i].isRepeat == 1) { //매년 반복되는 경우
								memorialDays.push(new memorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2, 
																  result.holidayList[i].holidayDate.substring(5,7), result.holidayList[i].holidayDate.substring(8,10),
																  isSolar, result.holidayList[i].isRest == 1 ? true : false, holidayFlag, repetition));
							} else if (result.holidayList[i].isRepeat == 0) { //해당 년에만 적용이 되는 경우
								yearmemorialDays.push(new yearmemorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2,
																		  result.holidayList[i].holidayDate.substring(0,4), result.holidayList[i].holidayDate.substring(5,7),
																		  result.holidayList[i].holidayDate.substring(8,10), isSolar,
																		  result.holidayList[i].isRest == 1 ? true : false, holidayFlag, repetition));
							}
						}
						closedDay = result.attitudeConfigVO.closedDay.split(",");
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
				
				if (returnValue == 0) { //해당근태가 없거나, 퇴근일 경우는 근태등록되게
					addAttitude(obj);
				} else {
					if (obj.getAttribute("type") === "A08" || obj.getAttribute("type") === "A03") { //퇴근,조퇴일때 조퇴,퇴근이 있는 경우 경고창
						alert("<spring:message code='ezAttitude.t169'/>");					
					}
					getAttitudeList();
	    			try{parent.frames["right"].getAttitudeMainList();}catch(e){}
				}
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
	    		
	    		$("#todayTime").html(nowAttiTime.getFullYear() + "<spring:message code='ezAttitude.t66'/> " + leadingZeros((nowAttiTime.getMonth() + 1), 2) + "<spring:message code='ezAttitude.t67'/> " + leadingZeros(nowAttiTime.getDate(), 2) + "<spring:message code='ezAttitude.t68'/>");
	    		var clientTime = new Date();
	    		timeDiff = nowAttiTime.getTime() - clientTime.getTime();
	    	}
		    
		    function attiClock() {
		        var h, m;
		        var s;
		        var time = " ";
		        var nowClientTime = new Date();
		        var nowServerTime = new Date(nowClientTime.getTime() + timeDiff);
		        
		        time = leadingZeros(nowServerTime.getHours(), 2) + ':' + leadingZeros(nowServerTime.getMinutes(), 2) + ':' + leadingZeros(nowServerTime.getSeconds(), 2);
		        document.getElementById("timeFlow").innerHTML = time;
		        if (time == "00:00:00") {
		        	//$("#todayTime").html(nowAttiTime.getFullYear() + "<spring:message code='ezAttitude.t66'/> " + leadingZeros((nowAttiTime.getMonth() + 1), 2) + "<spring:message code='ezAttitude.t67'/> " + leadingZeros(nowAttiTime.getDate(), 2) + "<spring:message code='ezAttitude.t68'/>");
		        }
		        gizmo = setTimeout("attiClock()", 500);
		        
		    }
		    
		    function goEnv() {
		    	window.open("/ezPortal/environmentMain.do?topMenuID=F3633607-8E8B-42A1-B777-6E2969072E58", "main", "");
		    }
	    	
	    	function getbirthUserList() {
	    		window.clearTimeout(timer);

	        	$.ajax({
    	        	type : "POST",
    	        	dataType : "text",
    	        	url : "/ezPersonal/mainBirthUserList.do",
    	        	data : {
    	        		mon   : month, 
    	        	},
    	        	success : function(xml){		        		
    	        		getbirthUserList_after(loadXMLString(xml));
    	        	},
    	        	error : function(error){
    	        		console.log(error);	
    	        	}
	    	    });
	    	}
	    	
	    	var userPrimary = "${userInfo.primary}";
	    	
	    	function getbirthUserList_after(xml) {
		        if (xml == null) return;

		        if (document.getElementById("userlist").innerHTML != "") document.getElementById("userlist").innerHTML = "";

	    	    if (SelectSingleNodeNew(xml, "DATA/ROW") != null) {
	        	    totalCnt = GetChildNodes(SelectSingleNodeNew(xml, "DATA")).length;
	            	totalPage = Math.ceil(totalCnt / EndCnt);

	            	document.getElementById("birthcont").style.display = "";
	            	document.getElementById("nodata_NewBirth").style.display = "none";
	            	
	            	for (var i = 0; i < totalCnt; i++) {
		                var cn = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "CN");
	                    
		                var birthType = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "BIRTHTYPE");
	    	            var birthDate = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "BIRTH");
	        	        var userName = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "DISPLAYNAME");
	        	        var userName = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "DISPLAYNAME");
	        	        var userPic = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "EXTENSIONATTRIBUTE2");
	        	        
	            	    if (userPrimary != "1")
	                	    userName = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "DISPLAYNAME2");

	                	/* var userTitle = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "TITLE");	                	
	                	
	                	if (userPrimary != "1")
		                    userTitle = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "TITLE2"); */
	                	
	                	var userDesc = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "DESCRIPTION");
	                	
	                	if (userPrimary != "1")
	                		userDesc = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "DESCRIPTION2");
	                	
	                	/* <li>
	                   	<dl class="birthListDL">
	                       	<dt class="birthPic"><img src="/images/kr/main/birth01.png"></dt>
	                        <dd class="birthName">[08.07] 김영미</dd>
	                        <dd class="birthTeam">오픈솔루션팀</dd>
	                    </dl>
	                </li> */
		                var _li = document.createElement("li");
		                _li.style.display = "none";
	    	            _li.style.cursor = "pointer";
	        	        _li.onclick = new Function("OpenUserInfo('" + cn + "');");
	        	        
	        	        if (userPic == "") {
	                    	_li.innerHTML = "<dl class='birthListDL'><dt class='birthPic'><img src='/images/kr/main/birth_none.png' width='32' height='32'></dt><dd class='birthName'>[" + birthDate + "] " + userName + "</dd><dd class='birthTeam'>" + userDesc + "</dd>";
	        	        } else {
	        	        	_li.innerHTML = "<dl class='birthListDL'><dt class='birthPic'><img src='/admin/ezOrgan/getPersonalInfo.do?fileName="+ userPic +"' width='32' height='32'></dt><dd class='birthName'>[" + birthDate + "] " + userName + "</dd><dd class='birthTeam'>" + userDesc + "</dd>";
	        	        }
	            	    
	                	document.getElementById("userlist").appendChild(_li);

	                	if (i >= (curPage * 6) && i < (curPage + 1) * 6) {
		                    document.getElementById('userlist').getElementsByTagName('li')[i].style.display = 'block';
	                	} else {
	                    	document.getElementById('userlist').getElementsByTagName('li')[i].style.display = 'none';
	                	}
		            }
		            curPage++;
		            
	    	        if (curPage >= totalPage) {
	        	        curPage = 0;
	            	}
	    	        
	            	if (totalCnt > EndCnt) {
		                timer = window.setInterval("intervalList()", 5000);
		            }
	    	    } else {
	            	document.getElementById("birthcont").style.display = "none";
	            	document.getElementById("nodata_NewBirth").style.display = "";
	        	}
		    }

		    function intervalList() {
	    	    for (var i = 0; i < totalCnt; i++) {
	        	    if (i >= (curPage * 6) && i < (curPage + 1) * 6) {
	            	    document.getElementById('userlist').getElementsByTagName('li')[i].style.display = 'block';
	            	} else {
	                	document.getElementById('userlist').getElementsByTagName('li')[i].style.display = 'none';
	            	}
	        	}
	    	    
	        	curPage++;
	        	
	        	if (curPage >= totalPage) {
		            curPage = 0;
		        }
	    	}

	    	function moveBirth(page) {
		        switch (page) {
		            case "PREV":
	    	            if (month != 1)
	        	            month = month - 1;
	            	    else
	                	    month = 12;
	                	break;
	            	case "NEXT":
		                if (month != 12)
		                    month = Number(month) + 1;
	    	            else
	        	            month = 1;
	            	    break;
	        	}
		        
	        	if (month < 10 && String(month).length == 1)
		            month = "0" + month;

	        	if(CrossYN())
		            document.getElementById("curMon").textContent = month;
	        	else
		            document.getElementById("curMon").innerText = month;
	        	
	        	curPage = 0;
	        	getbirthUserList();
	    	}
	    	
	    	function OpenUserInfo(pUserID) {
		        var heigth = window.screen.availHeight;
	        	var width = window.screen.availWidth;
	        	var left = (width - 500) / 2;
	        	var top = (heigth - 400) / 2;
	        	
	        	window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
	    	}
		    
		    function changeCompany(){
		    	var TcompanyID = $("#selectCompany option:selected").attr("companyID");
		    	var TdeptID = $("#selectCompany option:selected").val();
		    	window.parent.parent.changeCompany(TcompanyID,TdeptID);
		    }
		    
		    function schedule_get_holiday() {
		        $.ajax({
		    		type : "GET",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezSchedule/scheduleGetHoliday.do",
		    		data : {
		    			COMPANYID  : "VIEW"		    			
		    		},
		    		success: function(text){
		    			XmlNodeText = text;
			            XmlNode = loadXMLString(XmlNodeText);
			            
			            for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
			                if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].textContent == "1") {
			                    var issolar;
			                    var holiday;
			                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].textContent == "1")
			                        issolar = "1";
			                    else
			                        issolar = "2";
			                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].textContent == "1")			                    	
			                        holiday = true;			                    
			                    else
			                        holiday = false;
			                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].textContent == "1") {
			                        memorialDays.push(new memorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday));
			                    }
			                    else {                   	
			                        yearmemorialDays.push(new yearmemorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(0, 4),
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday));
			                    }
			                }
			            }			            
			            CalendarMiniView("CalendarMini");
			            CalendarMiniDataSource(XmlNode);
		    		}
		    	});
		    } 
		</script>
	</head>
	<body style="background-color: white">	
		<article class="rolling_info">
        	<div class="rolling" id="featured">
            	<c:choose>
	            	<c:when test="${not empty sliderList}">
	            		<c:forEach items="${sliderList}" var="slider">
		            		<c:choose>
		            			<c:when test="${fn:substring(slider.url, 0, 4) eq 'http' }">
		            				<img src="${slider.imagePath}" style="width:280px;height:515px;cursor:pointer;" onclick="window.open('${slider.url }')" />
		            			</c:when>
		            			<c:otherwise> 
									<img src="${slider.imagePath}" style="width:280px;height:515px;cursor:pointer;" onclick="window.open('http://${slider.url }')" />
								</c:otherwise>
							</c:choose>
						</c:forEach>
	            	</c:when>
	            	<c:otherwise>
		            	<img src="/images/kr/main/rolling01.png" width="280" height="515" />
		            	<img src="/images/kr/main/rolling02.png" width="280" height="515" />
	            	</c:otherwise>
	            </c:choose>
            </div>
            <dl class="info">
            	<dt class="infoImg"><c:if test='${userPhoto == ""}'><img src="/images/kr/main/info_pic_none.png"  width="36px" height="36px" /></c:if><c:if test='${userPhoto != ""}'>${userPhoto}</c:if></dt>
                <dd class="infoName">${displayName} ${title}</dd>
                <dd class="infoTeam">${department}</dd>
                <%-- <dd class="infoTeam"><spring:message code="main.t00016" /> ${lastLogin }</dd> --%>
                <dd class="infoSet" onclick='goEnv();'><img src="/images/kr/main/info_set.png"></dd>
            </dl>
        </article>
        <c:if test="${use_attitude == 'YES'}">
			<article class="time_check">
	           	<div id="timeinput" class="presentTime">
	               	<p class="timeTit" id="todayTime"><spring:message code="main.t00023" /></p>
					<div id="timeFlow" class="timeText"></div>
			    </div>
	            <div id="atti_area" class="main_time">
	            	<dl class="timeCheckIn">
	                	<dd id="inAttiBtn" class="out" type="A01" datetype="2" onClick="checkHoliday(this)"><spring:message code="ezPortal.pjg04" /></dd>
	                </dl>
	                <dl class="timeCheckOut">
	                   	<dd id="outAttiBtn" class="out" type="A03" datetype="2" onClick="checkHoliday(this)"><spring:message code="ezPortal.pjg05" /></dd>
	                </dl>
		    	</div>
			</article>
        </c:if>
        <!-- //time_check -->
        <!-- countingIcon -->
        <article class="countingIcon">
          	<div class="countingIcon01">
				<dl id="NewMail" onClick="btnSumming_click(this)">
                	<dt class="iconImg"><img src="/images/kr/main/countingIcon01.png"></dt>
                    <dd class="iconText"><spring:message code="main.t00017" /></dd>
                    <dd class="iconCount_none" id="mailnum">0</dd>
                </dl>
                <dl id="AprSign" onClick="btnSumming_click(this)">
                    <dt class="iconImg"><img src="/images/kr/main/countingIcon03.png"></dt>
                    <%-- <dd class="iconText"><spring:message code="main.t00018" /></dd> --%>
                    <dd class="iconText"><spring:message code="ezPortal.pgj03" /></dd>
                    <dd class="iconCount_none" id="aprnum">0</dd>
                </dl>
                <dl id="Schedule" onClick="btnSumming_click(this)">
                    <dt class="iconImg"><img src="/images/kr/main/countingIcon02.png"></dt>
                    <dd class="iconText"><spring:message code="main.t00019" /></dd>
                    <dd class="iconCount_none" id="schedulenum">0</dd>
                </dl>
			</div>
            <div class="countingIcon02" ${hasWorkspace == true ? "style='width:258px'" : "" }>
            	<dl id="Poll" onClick="btnSumming_click(this)">
                    <dt class="iconImg"><img src="/images/kr/main/countingIcon05.png"></dt>
                    <dd class="iconText"><spring:message code="main.t00020" /></dd>                        
                    <dd class="${pollNum == 0 ? 'iconCount_none' : 'iconCount' }"><c:if test="${fn:length(pollNum) > 2}">99+</c:if><c:if test="${fn:length(pollNum) <= 2}">${pollNum}</c:if></dd>
                </dl>
            	<c:if test="${isCircularUsed == 'Y'}">
                <dl id="Circular" onClick="btnSumming_click(this)"> 
                    <dt class="iconImg"><img src="/images/kr/main/countingIcon04.png"></dt>
                    <dd class="iconText"><spring:message code="ezCircular.t1" /></dd>
                    <dd class="iconCount_none" id="circularCnt">0</dd>
                </dl>
                </c:if>    
                <!-- 협업 추가 --> 
            	<c:if test="${hasWorkspace == true}">
                <dl id="Workspace" onClick="btnSumming_click(this)"> 
                    <dt class="iconImg"><img src="/images/kr/main/countingIcon04.png"></dt>
                    <dd class="iconText">협업</dd>
                    <dd class="iconCount_none" id="workspaceCnt">0</dd>
                </dl>
                </c:if>                                  
            </div>    
        </article>
        <article class="birthday">
			<div class="birthTit">
               	<p class="birthText"><span id="curMon"></span><spring:message code='main.t1002' /></p>
           	    <span class="birthRighttbtn" onclick="moveBirth('NEXT')"><img src="/images/kr/main/birthday_next.png"></span>
                <span class="birthLeftbtn" onclick="moveBirth('PREV')"><img src="/images/kr/main/birthday_pre.png"></span>
            </div>
            <div id="birthcont">
            	<ul class="birthList" id="userlist"></ul>
            </div>
            <div id="nodata_NewBirth" style="display:none;">
            	<dl class="nodata">
	            	<dt style="padding-top:33px"><img src="/images/kr/main/nodata.png"></dt>
	            	<dd>"<spring:message code="main.t00026" />"</dd>
            	</dl>
            </div>
		</article>
		
		<article class="bestEmployee">
        	<p class="emPic"><img src="${filePath}"></p>
            <dl class="emDL">
            	<dt class="emTit"><spring:message code='main.t68' /></dt>
            	<c:if test="${displayNameBirth != ''}">
	                <dd class="emName">"${displayNameBirth}
		                <c:choose>
							<c:when test = "${!empty displayNameBirth && empty titleBirth}">"</c:when>
							<c:when test = "${!empty titleBirth && displayNameBirth != ''}">${titleBirth}"</c:when>
						    <c:otherwise></c:otherwise>
						</c:choose>
	                </dd>                
	                <dd class="emTeam">${description}</dd>
                </c:if>
                <c:if test="${displayNameBirth == ''}">
                	<dl class="nodata" style="margin-top:8px">
		            	<dd>"<spring:message code="main.t00026" />"</dd>
	            	</dl>
                </c:if>
            </dl>
        </article>
	</body>
	<!-- 협업 연동 script -->
	<c:if test="${hasWorkspace == true }">
	    <script type="text/javascript" src="${workspaceContextRootUrl}/Scripts/moment.min.js"></script>
	    <script type="text/javascript" src="${workspaceContextRootUrl}/Scripts/Groupwareapi.js"></script>
	    <script type="text/javascript">
		    var g_UserID = "${userInfo.id}"; // GW 사용자 Id, 가온누리 Java버전엔 이미 선언되어 있음
		    var WorkspaceUrl = "${workspaceHostUrl}"; // 협업이 그룹웨어와 별도의 Url로 서비스 되는 경우에만 설정
		    var g_bGroupwareUIType = false;  // 그룹웨어 UI 타입 => true: UIUX, false: Normal(예전 GW 화면)
		    var feedListCount = 10;
		    var g_bRayful = false;
		    var g_bVisible = true; // 문서탭 선택 시 원문에 포함된 첨부파일 포함 여부 (false: 포함)
		    var g_bEzWorkspaceJava = true; // 협업 자바버전 변경을 위한 변수
		    
		    //협업 카운트
		    if (typeof (GetWorkspaceUserActLogCount) === "function") {
		        GetWorkspaceUserActLogCount("workspaceCnt", 1);
		    }
		    
		    var checkBrowser = function () {
		    	var agent = navigator.userAgent.toLowerCase();
		    	
		    	if(agent.indexOf('msie') !== -1) {
		    		return false;
		    	} else {
		    		return true;
		    	}
		    };
		    
		    if(!checkBrowser()) {
		    	console.log('in the bind Function.');
				$("#workspaceCnt").bind("DOMSubtreeModified", function() {
			    	var workspaceCnt = document.getElementById("workspaceCnt").innerHTML * 1;
			    	if(workspaceCnt > 0) {
		 		    	document.getElementById("workspaceCnt").classList.remove('iconCount_none');
				    	document.getElementById("workspaceCnt").classList.add('iconCount');
				    }
			    });		    	
		    } else {
		    	console.log('in the MutationObserver.');
			    var target = document.getElementById('workspaceCnt');
			    
				var observer = new MutationObserver(function(mutations) {
					mutations.forEach(function(mutation) {
	  			    var workspaceCnt = mutation.target.innerHTML * 1;
			    	if(workspaceCnt > 0) {
		 		    	document.getElementById("workspaceCnt").classList.remove('iconCount_none');
				    	document.getElementById("workspaceCnt").classList.add('iconCount');
			    	}
			    	observer.disconnect();
				  });    
				});
				
				var config = { attributes: true, childList: true, characterData: true };
				observer.observe(target, config);		    	
		    }

		</script>		
	</c:if>	
</html>
