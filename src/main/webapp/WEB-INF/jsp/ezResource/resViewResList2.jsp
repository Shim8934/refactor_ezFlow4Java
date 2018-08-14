<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t403" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('ezResource.e2', 'msg')}" type="text/css" />
		<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
		<style>
			#resourceDataTable tr td {
				border : 1px solid #ccc;				
			}
						
			#resourceDataTable tr td{
				padding-left : 7px;
			}
			
			#resourceDataTable tr th{
				font-weight: normal;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/Calendar_Action_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/CalendarView_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<style type="text/css">
			.warningbox01 { width:540px; margin:0 auto; border:1px solid #dedede; background:#f8f8fa;}
			.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 15px 25px;}
			.warnintxt01 { position:relative; margin-bottom:10px;margin-top:20px}
			.warningimg { position:absolute; top:0px; left:0px;}
			.warningdl { width:75%; padding:10px 10px 5px 114px; margin:0px; display:inline-block; text-align:left;}
			.warningdl dt { height:40px; padding-left:6px; margin-top:10px; margin-left:10px; text-align:left;}
			.warningdl dd { padding:0px 10px 0px 20px; margin:0px 0px 10px 0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left; word-break:break-all;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}

			/* tooltip 추가*/
			.calendar_layer{width:250px; table-layout:fixed; border:1px solid #4e4e46; border-collapse:separate; border-spacing:0; overflow:hidden;}
			.calendar_layer th{margin:0; padding:8px 10px; border:0; font-size:13px; color:#383838; white-space:normal; text-align:left;word-break:break-all;}
			.calendar_layer td{margin:0; padding:0;}
			.calendar_layer .text{padding:10px; border:1px solid #e5e5e5; border-bottom:0 none; overflow:hidden;}
			.calendar_layer .text .td_list{border:0 none; overflow:hidden;}
			.calendar_layer .text .td_list td{padding:3px 0px; color:#393939;}
			.calendar_layer .btn{background:#fff; border:1px solid #e5e5e5; border-top:1px solid #dedede; padding:10px 0px 9px 0px; margin:0 auto; text-align:center;}
			.calendar_layer .btn ul{list-style:none; margin:0 25px; padding:0px 3px; overflow:hidden; text-align:center;clear:both;list-style-type:none}
			.calendar_layer .btn ul li{float:left; height:27px; line-height:27px; background:url(images/calendar/btn_calendar_l.gif) no-repeat left top; padding:0px 3px 0px 8px;}
			.calendar_layer .btn ul li span{display:inline-block; background:url(images/calendar/btn_calendar_r.gif) no-repeat right top; padding:0px 8px 0px 3px; font-weight:normal; color:#555555;}
		</style>
		<script type="text/javascript">
			var pBrdid = "${brdID}";
	    	var pBrdnm = "<c:out value='${brdNm}' escapeXml='false'/>";
	    	var pAccessCode = "${accessCode}";
	    	var pCompanyID = "${companyID}";
	    	var pUserID = "${userID}";
	    	var pDeptID = "${deptID}";
	    	var pAdminFg = "${adminFg}";
		    var folder_Url = "/ezResource/scheduleGet.do";
		    var p_Type = "MAIN";
	    	var title_name = new Array();
	    	var pBrdCount = "${brdCount}";
	    	var pChildBrd = "${childBrd}";
		    var Mod = "";
		    var pUse_Editor = "${useEditor}";
		    var pStartday = "${startDay}";		    
		    select_memorialDays("${lang}");
		    
	    	document.onselectstart = function () { return false; };
	    	
	    	//baonk added
	    	var xmlhttp2 = createXMLHttpRequest();
		    function schedule_get_holiday() {
		        xmlhttp2 = createXMLHttpRequest();
		        xmlhttp2.open("POST", "/ezSchedule/scheduleGetHoliday.do?COMPANYID=VIEW", true);
		        xmlhttp2.onreadystatechange = event_schedule_get_holiday;
		        xmlhttp2.send();
		    }
	
		    function event_schedule_get_holiday() {
		        if (xmlhttp2 == null || xmlhttp2.readyState != 4)
		            return;
		        if (xmlhttp2.status >= 200 && xmlhttp2.status < 300) {
		            XmlNodeText = xmlhttp2.responseText;
		            XmlNode = loadXMLString(XmlNodeText);
		            for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
		                if (getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0]) == "1") {
		                    var issolar;
		                    var holiday;
		                    if (getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0]) == "1")
		                        issolar = "1";
		                    else
		                        issolar = "2";
		                    if (getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0]) == "1")
		                        holiday = true;
		                    else
		                        holiday = false;
		                    if (getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0]) == "1") {
		                        memorialDays.push(new memorialDay(getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0]), getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0]),
		                            getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0]).substring(0, 10).substring(5, 7),
		                            getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0]).substring(0, 10).substring(8, 10), issolar, holiday));
		                    }
		                    else {
		                        yearmemorialDays.push(new yearmemorialDay(getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0]), getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0]),
		                            getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0]).substring(0, 10).substring(0, 4),
		                            getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0]).substring(0, 10).substring(5, 7),
		                            getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0]).substring(0, 10).substring(8, 10), issolar, holiday));
		                    }
		                }
		            }
		            xmlhttp2 = null;		            
		        }
		    }
	    	//end
	
	    	window.onload = function () {
	    		schedule_get_holiday(); //baonk added
	    		
	    		if (pStartday == 1) {
		            DefaultView = 1;
	    		} else {
		            DefaultView = 0;
	    		}
	    		
	        	try {
	            	if (navigator.userAgent.indexOf('Firefox') != -1) {
	                	document.body.style.MozUserSelect = 'none';
	                	document.body.style.WebkitUserSelect = 'none';
	                	document.body.style.khtmlUserSelect = 'none';
	                	document.body.style.oUserSelect = 'none';
	                	document.body.style.UserSelect = 'none';
	            	}
	            	if (navigator.userAgent.indexOf("Chrome") > -1)
		                document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 110 + "px";
		            else
	    	            document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 130 + "px";

	        	    if (pBrdCount != 0) {
	            	    for (var i = 0; i < pBrdCount; i++) {
	                	    title_name[i] = pChildBrd.split(",")[i];
	                	}

	                	setweek_onload("WEEK");
	            	} else {
	            		/* 2018-04-26 홍승비 - 자원 관리자의 자원등록, 자원관리 표시 수정 */
	                	if(CheckAdmin()) {
	                		document.getElementById("mainmenu").onload = function(){};
	    	               	document.getElementById("noResListSpan").style.display = "none";
	    	               	//document.getElementById("tbar2").style.display = "none";
	                	} else {
	                		document.getElementById("mainmenu").style.display = "none";
	                	} 
	                	document.getElementById("tdDateCalendarViewer").innerHTML = document.getElementById("EmptyMsg").innerHTML;
	                	document.getElementById("weeklyline").style.display = "none";
	            	}
	        	}
	        	catch (e) {
	            	alert(strLang263);
	        	}
	    	}

	    	function setweek_onload(type) {
		        var date = new Date();
		        if (pBrdCount != 0) {
		            if (type == "WEEK") {
	    	            document.getElementById("TR_Line2").style.display = "";
	        	        weekonload(date.getFullYear(), parseInt(date.getMonth()) + 1, date.getDate());
		            }
		            else if (type == "TODAY") {
	    	            document.getElementById("TR_Line2").style.display = "";
	        	        todayonlaod(date.getFullYear(), parseInt(date.getMonth()) + 1, date.getDate());
	            	}
	        	} else {
	            	document.getElementById("TR_Line2").style.display = "none";
	            	document.getElementById("tdDateCalendarViewer").innerHTML = "<div style='padding-top:20px;'>" + strLang265 + "<div>";
	        	}
	    	}

		    function btnRefresh_onclick() {
		        if (Mod == "WEEK")
		            setweek_onload("WEEK")
	    	    else if (Mod == "TODAY")
	        	    setweek_onload("TODAY")
	    	}

	    	function pagenavi(datenavi) {
		        if (Mod == "WEEK")
		            nextWeek_onclick(datenavi)
	    	    else if (Mod == "TODAY")
	        	    nextToday_onclick(datenavi);
	    	}

	    	function btnView_Resource() {
		        var strUrl = "/ezResource/viewResList.do?brdID=" + pBrdid + "&accessCode=" + pAccessCode;
		        strUrl = strUrl + "&brdNm=" + encodeURIComponent(pBrdnm);
	    	    window.open(strUrl, 'right');
	    	}

	    	window.onresize = function () {
	        	if (navigator.userAgent.indexOf("Chrome") > -1)
		            document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 110 + "px";
		        else
	    	        document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 130 + "px";
	    	}

	    	function btnAdd_Click() {
		        if (CheckAdmin() == false) {
		            alert("<spring:message code="ezResource.t345" />");
	    	        return;
	        	}

	        	var pURL;
	        	pURL = "/ezResource/addClsItem.do?brdID=" + pBrdid
	        	var openLocation = pURL;
	        	openwindow(openLocation, "", 580, 450);
	    	}

		    function CheckAdmin() {
		        if (pAdminFg == "Y")
	    	        return true;
	        	else
		            return false;
		    }

	    	function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
	        	try {
	            	var heigth = window.screen.availHeight;
	            	var width = window.screen.availWidth;
	            	var left = 0;
	            	var top = 0;

		            if (window.screen.width > 800) {
		                var pleftpos;
	    	            var pheightpos;
	        	        pleftpos = parseInt(width) - 700;
	            	    pheightpos = parseInt(heigth) - 700;
	                	width = parseInt(width) - pleftpos;
	                	heigth = parseInt(heigth) - pheightpos;
	                	left = pleftpos / 2;
	                	top = pheightpos / 2;
	            	} else {
		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - 10;
	    	        }

	        	    window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

	        	} catch (e) {
		            alert("openwindow :: " + e.description);
		        }
	    	}

	    	function RefreshPageDoc() {
	        	window.parent.left.location.href = "/ezResource/leftResource.do?flag=SELECT_NO";
	        	window.parent.right.location.reload();
	    	}
	    	
	 		$(window).on("resize", function(){
				var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;	        	
     			$("#ResourceInfo").css("left", popupX);
     		});
	 		
	 		function SearchOptionHidden() {
	        	$.modal.close();
	        }
	    	
	    	function showRes(val01) {
	    		$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezResource/scheduleResourceData.do",
					data : { 
						resourceId   : val01						
					},
					success: function(result){
						if (result.primary == "1") {						
							$("#ownerNm").html(result.resBrd.ownerNm + " (" + result.resBrd.ownerPosition + ")");
							$("#ownerDept").html(result.resBrd.ownDeptNm);
							$("#brdNm").html(result.resBrd.brdNm);
						} else {
							$("#ownerNm").html(result.resBrd.ownerNm2 + " (" + result.resBrd.ownerPosition2 + ")");
							$("#ownerDept").html(result.resBrd.ownDeptNm2);
							$("#brdNm").html(result.resBrd.brdNm2);
						}
						
						$("#ownerCall").html(result.resBrd.ownerCall);
						$("#resLocation").html(result.resBrd.resLocation);						
						
						var approveFlag = result.resBrd.approveFlag;
						
						if (approveFlag == "1") {
							$("#approveFlag").html("<spring:message code='ezResource.t272'/>");
						} else {
							$("#approveFlag").html("<spring:message code='ezResource.t273'/>");
						}
						
						var resbrdExc = "";
						if (result.resBrd.brdExplain != null) {
							resbrdExc = result.resBrd.brdExplain.replace(/(?:\r\n|\r|\n)/g, '<br />');
						}
						
						$("#brdExplain").html(resbrdExc);
						
						/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
			        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
			        	
			        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
			        	
			        	$("#ResourceInfo").css("left", popupX);
			        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
						
						$("#ResourceInfo").modal();
					}, 
					error: function() {
						
					}
				});	    		
	        }
		</script>
	</head>
	<body class="mainbody" style="overflow:hidden; padding-right: 6px;">
		<!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
		<h1 style="text-overflow:ellipsis;overflow:hidden;white-space:nowrap;"><c:out value='${brdNm}'/><span id="TitleInfo"></span></h1>
		<div id="mainmenu" onload = "makePageSelPage()">
  			<ul>
    			<c:if test="${adminFg eq 'Y'}">
    				<li><span onClick="btnAdd_Click();"><spring:message code="ezResource.t363" /></span></li>	
    				<li><span onClick="btnView_Resource();"><spring:message code="ezResource.t17" /></span></li>
    				<!-- <li id="tbar2" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif"></li> -->
    			</c:if>
    			<span id = "noResListSpan">
    			<li id="ToDaybtn"><span onClick="setweek_onload('TODAY');"><spring:message code="ezResource.t251" /></span></li>
    			<li id="Weekbtn"><span onClick="setweek_onload('WEEK');"><spring:message code="ezResource.t253" /></span></li>
    			<!-- 2018-06-05 구해안 허가,비허가 오른쪽으로 ui 수정 -->
      			<li style="background:none;float:right;cursor:default">&nbsp;<img src="/images/calendar/icon_resource_ok.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t369" /></li>
				<li style="background:none;float:right;cursor:default"><img src="/images/calendar/icon_resource_no.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t370" /></li>
  				</span>
  			</ul>
		</div>
		
		<script type="text/javascript">
    		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
    	<table style="width:100%;margin-top:-37px;" id="mainlist" >
        	<tr>
            	<div id="tdCalViewCell"></div>
            	<div id="TD_CaseOfMonthView"></div>
        	</tr>
        	<tr id="TR_Line2" style="text-align:center;vertical-align:middle;height:30px;font-weight:bold;margin-top:10px;">
            	
        	</tr>
        	<tr>
            	<td style="vertical-align:top;">
                	<div id="mainlistlayout" style="width:100%;height:780px;margin-top:10px;overflow-y: auto;overflow-x:hidden;" >
                		<table style="width:100%;">
                    		<tr id="weeklyline">
                				<td colspan="2" style="text-align:center;font-weight: bold;font-size:14px;height:35px;background-color: #f0f6ff;">
                					<div style="border:1px solid #d1ddec;height:35px;line-height: 33px">
					                	<img src="/images/calendar/btn_calendar_mini_prev.gif" style="cursor:pointer;vertical-align:middle;" id=Img2 onClick="pagenavi('PREV');">
					                	&nbsp;<span id="divViewHeader" class="calResTitleSpan"></span>&nbsp;
					                	<img src="/images/calendar/btn_calendar_mini_next.gif" style="cursor:pointer;vertical-align:middle;" id=Img3 onClick="pagenavi('NEXT');">
				                	</div>
				            	</td>
				            </tr>
                    		<tr>
                      			<td colspan="2" id='weekviewer' class='tdViewContainer' style="vertical-align:top;"><!-- 'exchangcalendar에서 일,월,주보기 쿼리를 가지고 FolderUrl경로를 사용한다.  -->
                        			<div id="tooltip" style="position:absolute; visibility:hidden; z-index:1000;"></div> 
                        			<div id="tdDateCalendarViewer" style="padding-bottom:5px; height:100%; text-align:center;" ></div>
                        		</td>
                    		</tr>
                    		<tr id="noapproval" style="display:none;">
                        		<td colspan="2" style="font-weight:bold;padding-top:15px;padding-left:5px;vertical-align:bottom;" ><h2>▒&nbsp;<spring:message code="ezResource.t402" /></h2></td>
                    		</tr>
                    		<tr>
                      			<td colspan="2" id='tdCalViewCell2'  class='tdViewContainer' style="vertical-align:top;"><!-- 'exchangcalendar에서 일,월,주보기 쿼리를 가지고 FolderUrl경로를 사용한다.  ---->
                        			<div id="idCalendarViewer2" style='height:100%; text-align:center'> </div>
                        		</td>
                    		</tr>
                    		<tr style="display:none;" id="approval">
                        		<td colspan="2" style="font-weight:normal;vertical-align:top;text-align:right"><%-- <h2 style="font-weight:normal;">※&nbsp;<spring:message code="ezResource.t401" /></h2> --%></td>
                    		</tr>
                		</table>
                	</div>
            	</td>
          	</tr>
		</table>		
    	<div id="EmptyMsg" style="display:none;">
        	<div class="warningbox01" style="margin-top:155px;">
          		<div class="warningbox02">
  	        		<div class="warnintxt01" >
	        			<span class="warningimg"><img src="/images/notify/warning02_resorce.gif" width="64" height="64" style="margin: 18px 0px 18px 34px;"></span>
	        			<dl class="warningdl">
	        				<dt><img src="/images/notify/warning01.gif" width="183" height="27"></dt>
	        				<dd>
	        					<spring:message code="ezResource.t9900001" />
	        				</dd>
	        			</dl>
	        		</div>
	        	</div>
        	</div>
        </div>
        <!-- layer 팝업 -->
        <!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
        <div id="ResourceInfo" style="display: none">
        	<div class="popupJQLayer" style="padding-top:6px">
				<div class="title" id="brdNm" style="overflow:hidden; text-overflow:ellipsis; width:450px;"></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span></span></a></li>
		            </ul>
		        </div>
	        	<table id="resourceDataTable" style="width:478px; margin-top:10px;">
					<tr>
						<th width="22%" style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t153'/></th>
						<td><span id="ownerNm"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t151'/></th>
						<td><span id="ownerDept"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t155'/></th>
						<td><span id="ownerCall"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t148'/></th>
						<td style="word-break:break-all;" id="resLocation"><%-- ${resLocation} --%></td>
					</tr>							
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t149'/></th>
						<td id="approveFlag"></td>
					</tr>
					<tr>
						<th style="height:200px;background-color: #fafafa"><spring:message code='ezResource.t271'/></th>
						<td><div style="overflow: auto; height: 200px;word-break:break-all" id="brdExplain"></div></td>
					</tr>
	         	</table>
	         </div>	
        </div>
	</body>
</html>