<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t403" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
		<link href="${util.addVer('/css/Calendar_cross.css')}" rel="stylesheet" type="text/css" />
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
			
			.table_layout th {
				color:#2f2f2f;height: 32px;background:#e4e8ec;border: 1px solid #c8ccd0;padding:0;margin:0;
				
			}
			.mainmenuTab {
				margin : 0px 15px 11px 15px;
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
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<style type="text/css">
			.warningbox{margin:240px auto 0px auto; padding:40px 20px 0px 20px; width:625px; height:184px; border:1px solid #d6d6d6; box-sizing:border-box;}
			.warningbox .warningimg{margin:0px; padding:0px 0px 0px 40px; float:left;}
			.warningbox .warningDL{margin:0px; padding:0px 0px 0px 30px; float:left; overflow:hidden;}
			.warningbox .warningDL dt{margin:0px; padding:12px 0px 5px 0px; font-size:24px; font-weight:bold; color:#3d8fea; letter-spacing:-1px; text-align: left;}
			.warningbox .warningDL dd{margin:0px; padding:0px; font-size:20px; color:#333; letter-spacing:-1px;}
			.warningbox .warningDL dd span{ font-size:20px; font-weight:bold;}
			
			.warningbox01 { width:540px; margin:0 auto; border:1px solid #dedede; background:#f8f8fa;}
			.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 15px 25px;}
			.warnintxt01 { position:relative; margin-bottom:10px;margin-top:20px}
			/* .warningimg { position:absolute; top:0px; left:0px;} */
			.warningdl { width:75%; padding:10px 10px 5px 114px; margin:0px; display:inline-block; text-align:left;}
			.warningdl dt { height:40px; padding-left:6px; margin-top:10px; margin-left:10px; text-align:left;}
			.warningdl dd { padding:0px 10px 0px 20px; margin:0px 0px 10px 0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left; word-break:break-all;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
			.today { background-color:#f0f6ff;}

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
			var pBrdid = "<c:out value='${brdID}'/>";
	    	var pBrdnm = "<c:out value='${brdNm}'/>";
	    	var pAccessCode = "<c:out value='${accessCode}'/>";
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
		    var lunarUseFlag = "${lunarUseFlag}";
		    var lunarUse = "${lunarUse}";
		    /* select_memorialDays("${lang}"); */
		    var dayView = "";
		    var userLang = "${lang}"; // 달력 날짜의 휴일 다국어 처리 위한 용도. (Calendar_Action_cross - tableListControl_Week 참고.)
		    
	    	 /* 2019-01-11 김민성 - 접근 권한 없는 경우 메시지 출력 수정 */
		    if(pAdminFg == "") {
		    	var msg = "<spring:message code='ezResource.t58' />";
		        window.location.href = "/ezResource/nonResList.do?msg=" + encodeURIComponent(msg);
		    }
	    	 
	    	document.onselectstart = function () { return false; };
	    	
	    	//baonk added
	    	var xmlhttp2 = createXMLHttpRequest();
		    function schedule_get_holiday() {
		        xmlhttp2 = createXMLHttpRequest();
		        xmlhttp2.open("GET", "/ezSchedule/scheduleGetHoliday.do?COMPANYID=VIEW", true);
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
		                if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].textContent == "1") {
		                    var issolar;
		                    var holiday;
		                    var holidayFlag;
		                    
		                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].textContent == "1") {
		                        issolar = "1";
		                    } else {
		                        issolar = "2";
		                    }
		                    
		                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].textContent == "1") {
		                        holiday = true;			                    
		                    } else {
		                        holiday = false;
		                    }
		                    
		                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYFLAG")[0].textContent == "Y") {
		                        holidayFlag = "Y";			                    
		                    } else {
		                        holidayFlag = "D";
		                    }
		                    
		                    var repetition = GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYREPEAT")[0].textContent;	                    
		                    
		                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].textContent == "1") {
		                        memorialDays.push(new memorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
		                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
		                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday, holidayFlag, repetition));
		                    } else {                   	
		                        yearmemorialDays.push(new yearmemorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
		                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(0, 4),
		                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
		                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday, holidayFlag, repetition));
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
		                document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 150 + "px";
		            else
	    	            document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 170 + "px";

	        	    if (pBrdCount != 0) {
	            	    for (var i = 0; i < pBrdCount; i++) {
	                	    title_name[i] = pChildBrd.split("|")[i];
	                	}

	            	    if (Mod != null && Mod != ""){
	                		setweek_onload(Mod);
	    		        } else {
		                	setweek_onload("WEEK");
	    		        }
	            	} else {
	            		/* 2018-04-26 홍승비 - 자원 관리자의 자원등록, 자원관리 표시 수정 */
	                	if(CheckAdmin()) {
	                		document.getElementById("mainmenu").onload = function(){};
	    	               	document.getElementById("noResListSpan").style.display = "none";
	    	               	//document.getElementById("tbar2").style.display = "none";
	                	} else {
	                		document.getElementById("noResListSpan").style.display = "none";
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
	    	
	        /* 2018-08-11 장진혁 - 레이어팝업 생성된 상태에서 backspace 누를시 왼쪽프레임 부분 딤 처리 없애기 */
	        window.onunload = function () {
	        	if (parent.frames["left"]) {
	        		if (parent.frames["left"].document.getElementById("blockLeft")) {
	        			$(parent.frames["left"].document.body).css("overflow", "");
	        	    	$(parent.frames["left"].document.getElementById("blockLeft")).remove();
	        		}
	        	} else if (parent.frames["attitude_menu"]) {
	        		if (parent.frames["attitude_menu"].document.getElementById("blockLeft")) {
	        	    	$(parent.frames["attitude_menu"].document.getElementById("blockLeft")).remove();
	        		}
	        	}
	        	      
	        	if (parent.parent.frames["left"]) {
	        		if (parent.parent.frames["board_menu"]) {  		  
	        			$(parent.parent.frames["board_menu"].document.body).css("overflow", "");
	        			$(parent.parent.frames["board_menu"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["board_main"].document.getElementById("blockTop")).remove();
	        		} else if (parent.parent.frames["left"].document.getElementById("blockLeft")) {  		  
	        			$(parent.parent.frames["left"].document.body).css("overflow", "");
	        			$(parent.parent.frames["left"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["right"].document.getElementById("blockTop")).remove();
	        		}
	        	}
	        }

	    	function setweek_onload(type) {
		        var date = new Date();
		        if (weekStartDate != null && weekStartDate != ""){
		        	date = new Date(weekStartDate);
		        }
		        if (pBrdCount != 0) {
		            if (type == "WEEK") {
	    	            document.getElementById("TR_Line2").style.display = "";
	        	        weekonload(date.getFullYear(), parseInt(date.getMonth()) + 1, date.getDate());
	        	        $("#Weekbtn").attr("class","on");
	        	        $("#ToDaybtn").attr("class","off");
	        	        
	        	        $("#divViewHeader").css("color","");
	        	        $('body').css('overflowY', 'hidden');
		            }
		            else if (type == "TODAY") {
	    	            document.getElementById("TR_Line2").style.display = "";
	        	        todayonlaod(date.getFullYear(), parseInt(date.getMonth()) + 1, date.getDate());
	        	        $("#Weekbtn").attr("class","off");
	        	        $("#ToDaybtn").attr("class","on");
	        	        $('body').css('overflowY', 'auto');
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
                parent.document.querySelector("iframe[name=right]").src = strUrl;
	    	}

	    	window.onresize = function () {
	    		if(Mod == "WEEK") {
		        	if (navigator.userAgent.indexOf("Chrome") > -1)
			            document.getElementById("res_Div").style.height = document.documentElement.clientHeight - 185 + "px";
			        else
		    	        document.getElementById("res_Div").style.height = document.documentElement.clientHeight - 190 + "px";
		        	scroll();
	    		}
	    		//else if(Mod == "TODAY") {
	    			if (navigator.userAgent.indexOf("Chrome") > -1)
		                document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 150 + "px";
		            else
	    	            document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 170 + "px";
	    		//}
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
	    		event.stopPropagation();
	    		
	    		$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezResource/scheduleResourceData.do",
					data : { 
						resourceId   : val01						
					},
					success: function(result){
						// 2018-10-30 김민성 - 자원 정보 레이어 팝업 관리자 리스트, 관리자 정보 조회, 등록일 정보 추가
						var ownerID = result.resBrd.ownerID;
						var subOwner = result.ownerList;
						var strOwnerList = "";
						
						for(var i=0; i<subOwner.length; i++) {
							strOwnerList += "<span onclick=\"OpenUserInfo('" + subOwner[i].cn + "','" + subOwner[i].department + "')\">"+subOwner[i].displayName+"</span>";
							if(i != subOwner.length-1) {
								strOwnerList += ", ";
							}
						}
						
						/* var ownerID = result.resBrd.ownerID.split(";");
						if (result.primary == "1") {						
							$("#ownerNm").html(result.resBrd.ownerNm + " (" + result.resBrd.ownDeptNm + ")");
							$("#ownerNm").attr("ownerID", ownerID);
							$("#ownerNm").attr("onclick", ownerID);
							$("#submanager").html(result.resBrd.ownDeptNm);
							$("#brdNm").html(result.resBrd.brdNm);
						} else {
							$("#ownerNm").html(result.resBrd.ownerNm2 + " (" + result.resBrd.ownDeptNm2 + ")");
							$("#ownerNm").attr("ownerID", ownerID);
							$("#submanager").html(result.resBrd.ownDeptNm2);
							$("#brdNm").html(result.resBrd.brdNm2);
						} */
						$("#brdNm").html(MakeXMLString(result.resBrd.brdNm));
						$("#ownerCall").html(MakeXMLString(result.resBrd.ownerCall));
						$("#resLocation").html(MakeXMLString(result.resBrd.resLocation));					
						
						$("#ownerInfo").html(strOwnerList);
						
						var approveFlag = result.resBrd.approveFlag;
						
						if (approveFlag == "1") {
							$("#approveFlag").html("<spring:message code='ezResource.t272'/>");
						} else if (approveFlag == "0") {
							$("#approveFlag").html("<spring:message code='ezResource.t273'/>");
						} else {
							$("#approveFlag").html("<spring:message code='ezSchedule.t404'/>");
						}
						
						var returnFlag = result.resBrd.returnFlag;
						
						if (returnFlag == "0") {
							$("#returnFlag").html("<spring:message code='ezResource.kmsr12'/>");
						} else {
							$("#returnFlag").html("<spring:message code='ezResource.kmsr13'/>");
						}

						// 반복예약허용 Flag
						var repeatFlag = result.resBrd.repeatFlag;

						if (repeatFlag == "1") {
							$("#repeatFlag").html("<spring:message code="ezResource.lyj02"/>");
						} else {
							$("#repeatFlag").html("<spring:message code="ezResource.lyj03"/>");
						}
						
						$("#resDate").html(result.resBrd.makeDate);
						
						var resbrdExc = "";
						if (result.resBrd.brdExplain != null) {
							resbrdExc = MakeXMLString(result.resBrd.brdExplain);
						}
						
						$("#brdExplain").html(resbrdExc);
						
						if(result.attachList1 != null) {
							document.getElementById("preview1").src = "/ezResource/getResourceThumbnailInfo.do?brdID=" + val01 + "&fileName=" + encodeURIComponent(result.attachList1);
							document.getElementById("preview1").width = 200;
							document.getElementById("preview1").height = 200;
						}
						else {
							document.getElementById("preview1").src = "/images/default_pic.jpg";
							document.getElementById("preview1").width = 120;
							document.getElementById("preview1").height = 120;
						}
						
						if(result.attachList2 != null) {
							document.getElementById("preview2").src = "/ezResource/getResourceThumbnailInfo.do?brdID=" + val01 + "&fileName=" + encodeURIComponent(result.attachList2);
							document.getElementById("preview2").width = 200;
							document.getElementById("preview2").height = 200;
						}
						else {
							document.getElementById("preview2").src = "/images/default_pic.jpg";
							document.getElementById("preview2").width = 120;
							document.getElementById("preview2").height = 120;
						}
						
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
	    	
	    	// 2018-10-19 김민성 - 작성자 이름 클릭 시 사원정보보기 팝업
			function OpenUserInfo(userID, deptID) {
	        	var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 450);
	            window.open("/ezCommon/showPersonInfo.do?id=" + userID + "&dept=" + deptID, "", feature);
	        }
	    	
			function btnOccupancy_list() {
				parent.frames["left"].document.body.style.overflow = "hidden";
	    		var url = "/ezResource/resourceOccupancy.do";
	    		DivPopUpShow(800, 540, url);
	    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%'></div>").appendTo(parent.frames["left"].document.body);
			}
			function resClose_onclick() {
				DivPopUpHidden();
				$(parent.frames["left"].document.getElementById("blockLeft")).remove();
			}
		</script>
	</head>
	<body class="mainbody" style="overflow-y:hidden; ovverflow-x: scroll; min-width: 600px; padding-right: 6px; min-width: 950px;">
		<!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
		<h1 style="text-overflow:ellipsis;overflow:hidden;white-space:nowrap;"><c:out value='${brdNm}'/><span id="TitleInfo"></span></h1>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none; overflow-y: hidden;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="mainmenu" onload = "makePageSelPage()">
            <ul class="on">
            	<c:if test="${adminFg eq 'Y'}">
            		<li class="important"><span onClick="btnAdd_Click();"><spring:message code="ezResource.t363" /></span></li>	
    				<li><span onClick="btnView_Resource();"><spring:message code="ezResource.t17" /></span></li>
              	</c:if>
              	<c:if test="${adminCKFlag eq 'Y'}">
    				<li id="occupancylist"><span onClick="btnOccupancy_list();"><spring:message code='ezResource.kwc03'/></span></li>
              	</c:if>
              	<!-- <span id = "noResListSpan"> -->
              		<%-- <li style="background:none;float:right;cursor:default;border:0px;color:#393939">&nbsp;<img src="/images/calendar/icon_resource_ok.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t369" /></li>
					<li style="background:none;float:right;cursor:default;border:0px;color:#393939"><img src="/images/calendar/icon_resource_no.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t370" /></li> --%>
				<!-- </span> -->
            </ul>
		</div>
		<div class="calendar_pagenav" id="weeklyline" style='left: max(50%, 300px);'>
	        <ul class="contentlayout">
	            <li class="contentlayout_left" id="preM"><span class="icon16 calendarleft" onclick="pagenavi('PREV');"></span></li>
	            <li class="contentlayout_right" id="preN"><span class="icon16 calendarright" onclick="pagenavi('NEXT');"></span></li>
	            <li class="contentlayout_none"><span class="spanText" id="divViewHeader"></span>
	            </li>
	        </ul>
	    </div>

	    <div class="mainmenuTab" id="noResListSpan">
	    	<ul class="mainmenuTabUL_left">  <li><span class="sub_iconLNB tree_resource_ok"></span><spring:message code='ezResource.t191'/></li><li><span class="sub_iconLNB tree_resource_no"></span><spring:message code='ezResource.kmsr21'/></li> <li><span class="sub_iconLNB tree_resource_refuse"></span><spring:message code='ezResource.kmsr22'/></li> </ul>
	        <ul class="mainmenuTabUL">
	            <li id="ToDaybtn" class="off"><span onClick="setweek_onload('TODAY');"><spring:message code='ezSchedule.t140'/></span></li><li id="Weekbtn" class="on"><span onClick="setweek_onload('WEEK');"><spring:message code='ezSchedule.t141'/></span></li>
	        </ul>
	    </div>
		<%-- <div id="mainmenu" onload = "makePageSelPage()">
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
				<li style="background:none;float:right;cursor:default"><img src="/images/calendar/icon_resource_no.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t370" /></li>
      			<li style="background:none;float:right;cursor:default"><img src="/images/calendar/icon_resource_ok.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t369" /></li>
  				</span>
  			</ul>
		</div> --%>
		
		<script type="text/javascript">
    		//selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
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
                	<div id="mainlistlayout" style="width:100%;height:780px;margin-top:10px;" >
                		<table style="width:100%;">
                    		<tr>
                      			<td colspan="2" id='weekviewer' class='tdViewContainer' style="vertical-align:top;"><!-- 'exchangcalendar에서 일,월,주보기 쿼리를 가지고 FolderUrl경로를 사용한다.  -->
                        			<div id="tooltip" style="position:absolute; visibility:hidden; z-index:1000;"></div> 
                        			<div id="tdDateCalendarViewer" style="padding-bottom:5px; height:100%; text-align:center;" ></div>
                        		</td>
                    		</tr>
                    		<tr id="noapproval" style="display:none;">
                        		<td colspan="2" style="padding-top:15px;padding-left:5px;vertical-align:bottom;" ><h2 style="font-weight: normal;font-size:12px">▒&nbsp;<spring:message code="ezResource.t402" /></h2></td>
                    		</tr>
                    		<tr>
                      			<td colspan="2" id='tdCalViewCell2'  class='tdViewContainer' style="vertical-align:top;"><!-- 'exchangcalendar에서 일,월,주보기 쿼리를 가지고 FolderUrl경로를 사용한다.  ---->
                        			<div id="idCalendarViewer2" style='height:100%; text-align:center; margin-bottom:10px;'> </div>
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
    	<div class="warningbox">
	        <p class="warningimg"><img src="/images/notify/warning_resorce.png" width="105" height="89"></p>
	        <dl class="warningDL">
	        	<dt><spring:message code="ezResource.t9900001" /></dt>
	        	<dd><spring:message code="ezResource.t99000022" /></dd>
	        </dl>
	    </div>
        	<%-- <div class="warningbox01" style="margin-top:155px;">
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
        	</div> --%>
        </div>
        <!-- layer 팝업 -->
        <!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
        <div id="ResourceInfo" style="display: none; max-width: 700px">
        	<div class="popupJQLayer" style="padding-top:6px">
				<div class="title" id="brdNm" style="overflow:hidden; text-overflow:ellipsis; width:650px; white-space:nowrap; margin-bottom:2px;"></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span></span></a></li>
		            </ul>
		        </div>
	        	<table id="resourceDataTable" style="width:680px; /* margin-top:10px; */">
					<tr>
						<th width="22%" style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t153'/></th>
						<td colspan="2"><span id="ownerNm"><span id="ownerInfo" style="cursor:pointer"></span></span></td>
					</tr>
					<%-- <tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.rkms01'/></th>
						<td><span id="submanager"></span></td>
					</tr> --%>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t155'/></th>
						<td colspan="2"><span id="ownerCall"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t148'/></th>
						<td colspan="2" style="word-break:break-all;" id="resLocation"><%-- ${resLocation} --%></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code="ezResource.lyj01"/></th>
						<td colspan="2" id="repeatFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t149'/></th>
						<td colspan="2" id="approveFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.kmsr11'/></th>
						<td colspan="2" id="returnFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezBoard.t5007'/></th>
						<td colspan="2"><span id="resDate"></span></td>
					</tr>
					<tr>
						<th style="height:200px;background-color: #fafafa"><spring:message code="ezPortal.t202"/></th>
						<td style="width:39%; border-right: 0"><img id="preview1" name="preview" src="/images/default_pic.jpg" width="120" height="120" alt="" border="0" style="margin-left: auto; margin-right: auto; display: block; border-right: 0px;"></td>
						<td style="border-left: 0"><img id="preview2" name="preview" src="/images/default_pic.jpg" width="120" height="120" alt="" border="0" style="margin-left: auto; margin-right: auto; display: block;"></td>
					</tr>
					<tr>
						<th style="height:200px;background-color: #fafafa"><spring:message code='ezResource.t271'/></th>
						<td colspan="2"><div style="overflow-y: auto; height: 200px; word-break:break-all; white-space:pre-wrap;" id="brdExplain"></div></td>
					</tr>
	         	</table>
	         </div>	
        </div>
	</body>
</html>
