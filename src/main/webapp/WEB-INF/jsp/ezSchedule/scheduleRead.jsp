<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>        
        <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<title>
			<spring:message code='ezSchedule.t298'/>
			<c:if test="${scheduleInfo.scheduleType == 1}"><spring:message code='ezSchedule.t321' /></c:if>
			<c:if test="${scheduleInfo.scheduleType == 2}"><spring:message code='ezSchedule.t322' /></c:if>
			<c:if test="${scheduleInfo.scheduleType == 3}"><spring:message code='ezSchedule.t323' /></c:if>
			<c:if test="${scheduleInfo.scheduleType == 7}"><spring:message code='ezSchedule.t324' /></c:if>
			<c:if test="${scheduleInfo.scheduleType == 8}"><spring:message code='ezSchedule.t322' /></c:if>
			<c:if test="${scheduleInfo.scheduleType == 9}">(</c:if>
			<c:if test="${scheduleInfo.scheduleType == 10}"><spring:message code='ezSchedule.lyj14'/>(</c:if>
			<c:if test="${primary == '1' && scheduleInfo.ownerName != 'undefined'}"><c:out value="${scheduleInfo.ownerName}" /></c:if>
	        <c:if test="${primary != '1' && scheduleInfo.ownerName2 != 'undefined'}"><c:out value="${scheduleInfo.ownerName2}" /></c:if> )
		</title>
		<style> 
			P { 
				MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm; line-height:20px 
			}
			/* 2018-07-23 김보미 - 테이블 중앙정렬 */
			.popuplist th { width:10%; text-align: center; }
			.popuplist td { width:40%; }
		</style>
		<script>
			var contentpath = "${scheduleInfo.contentPath}";
			var ownerid = "<c:out value='${scheduleInfo.ownerId}' />";
			var creatorid = "<c:out value='${scheduleInfo.creatorId}' />";
			var modifierid = "<c:out value='${scheduleInfo.modifierId}' />";
			var scheduletype = "<c:out value='${scheduleInfo.scheduleType}' />";
			var scheduleid = "<c:out value='${_scheduleid}' />";			
			var datetype = "<c:out value='${scheduleInfo.dateType}' />";			
			var commpanyid = "<c:out value='${scheduleInfo.companyid}' />";
			var userCompanyid = "<c:out value='${companyID}' />";
			var changekey = "";
			var pattern = "<c:out value='${_pattern}' />";
			var pageFrom = "<c:out value='${pageFrom}' />";			
			var s_DateForAttandant = "";			
			var e_DateForAttandant = "";
			var _otherid = "<c:out value='${otherid}' />";
	        var pUse_Editor = "CK";
	        var ResourceInfo = "<c:out value='${resourceCnt}' />";	        
	        var ResourceDel = "FALSE";
	        var isReceive = "<c:out value='${isReceive}' />";
	        var repetitionInfo = "<c:out value='${repetitionInfo}' />";
	        var startDate = "<c:out value='${scheduleInfo.startDate}' />";
	        var endDate = "<c:out value='${scheduleInfo.endDate}' />";
	        var scheduleFlag = "<c:out value='${scheduleInfo.scheduleFlag}' />";
	        var memberId = "<c:out value='${memberId}' />";
	        var isOnlyGoogle = "<c:out value='${isOnlyGoogle}' />";
	        var repetition = "<c:out value='${repetition}' />";
	        var lang = "<c:out value='${lang}' />";
	        var showtop = "<c:out value='${showtop}' />";

	        /* 2021-11-25 홍승비 - 일정완료 관련 데이터 추가 (반복일정 대응) */
	        var repeatCount = "<c:out value='${repeatCount}' />";
	        var repStartDate = "<c:out value='${repStartDate}' />";
	        
	        <%-- var parentid = "<%= _parentid %>"; --%>			
			<%-- var admin = "<%= _admin %>"; --%>
			<%-- var userid = "<%= userinfo.UserID %>"; --%>
			<%-- var groupname = "<%= groupname %>"; --%>
			<%-- var changekey = "<%= _changekey %>"; --%>
			<%-- var s_DateForAttandant = "<%= s_DateForAttandant %>"; --%>
			<%-- var e_DateForAttandant = "<%= e_DateForAttandant %>"; --%>
	        
	        window.onload = function () {	      
                if (document.getElementById('managespan') && (scheduletype != "1" && scheduletype != "6")) {
                    managespan.style.display = "none";
                    manageli.style.display = "none";
                }
                // 2018-11-26 김민성 - 작성자 회사가 아닌 겸직 회사의 참석자는 등록 안되도록 수정
                else if(userCompanyid != commpanyid) {
                	managespan.style.display = "none";
                	manageli.style.display = "none";
                }
                
                if (scheduleFlag != 'google') {
                $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : { 
						type   : "SCHEDULECONTENT", 
						itemID 	 : contentpath
					},
					success: function(result){
						var doc = document.getElementById('message').contentWindow.document;
						doc.open();
						doc.write(result);
						doc.close();
					}
				});
                } else {
                	var tempDiv = document.getElementById("syncDataTemp");
                	var doc = document.getElementById('message').contentWindow.document;
					doc.open();
					doc.write(tempDiv.innerHTML);
					doc.close();
					tempDiv.parentElement.removeChild(tempDiv);
					var styleNode = document.createElement('style');
					styleNode.type = "text/css";
					var styleText = lang == '3' ? document.createTextNode('p, div{font-size: 13px; font-family: Meiryo UI;}') : document.createTextNode('p, div{font-size: 13px; font-family: 맑은 고딕;}');
			        styleNode.appendChild(styleText);
					doc.head.appendChild(styleNode);
                }
	            
	            window.onresize();
	            
	            if (isReceive == 'Y') {
	            	if (repetitionInfo.length > 0) {
			            timeString = makeRepetitionScheduleString(startDate, endDate, repetitionInfo);
			            $('#LabelDate').text(timeString);
	            	}
	            }
	        }
	
	        /* 2021-09-12 홍승비 - 일정관리 보기창 본문 리사이즈 조정 */
	        window.onresize = function () {
	            // width 속성은 css의 calc로 처리함
				var addHeight = 0;
	        	var contentHeight = document.documentElement.clientHeight - 269; // 일정그룹명, 참석자 tr이 없는 기본 본문 높이
	        	if (document.getElementById("scheduleGroupInfoTR") != null) { // 일정그룹명 tr
	        		addHeight += 30
	        	}
	        	if (document.getElementById("LabelAttendant") != null) { // 참석자 tr
	        		addHeight += 30;
	        	}
	            
            	document.getElementById("message").style.height = (contentHeight - addHeight - 10) + "PX";
                document.getElementById("messagetd").style.height = (contentHeight - addHeight) + "PX";
	        }
	        
		    window.onbeforeunload = function () {
		        try {
		    		window.opener.openerCalendarMiniView("CalendarMini");	    		
		    		window.opener.openerCalendarMiniDataSource();
		            window.opener.getScheduleList(window.opener.nowDay, "P");
		        } catch (e) { }
		    }
				    
	        function show_personinfo(userid) {
	        	var deptID = "";
	        	
	            if (userid == "0")
	                userid = creatorid;
	            else if (userid == "1")
	                userid = modifierid;
	            
	        	$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleGetCumDeptID.do",
					data : { 						
						userID : userid,
						companyID : commpanyid
					},
					success: function(result){
						deptID = result;
					}
				});
	        	
	            // var feature = GetOpenPosition(420, 450);
	            if (userid.indexOf('@') > 0)
	                window.open("/ezCommon/showPersonInfo.do?email=" + userid+"&dept="+deptID, "", GetOpenWindowfeature(420, 450, 1));
	            else
	                window.open("/ezCommon/showPersonInfo.do?id=" + userid+"&dept="+deptID, "", GetOpenWindowfeature(420, 450, 1));
	        }
	
			/* function group_info() {
	            var feature = GetOpenPosition(430, 450);
	            window.open("/myoffice/ezSchedule/schedule_group_info.aspx?id=" + ownerid + "&scheduleid=" + scheduleid, "",
	                "height = 451px, width = 430px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + feature);
	        } */
				
	        function attach_SelectAll() {
				    var checks = document.getElementById('attachedfileDIV').getElementsByTagName("input");
				    for (var i = 0; i < checks.length; i++)
				        checks.item(i).checked = true;
			}
	        
			function attach_Download() {
			    checks = document.getElementById('attachedfileDIV');
// 			    downloadAll(checks);
			    AttachAllDownload(checks);
			}

			var suffix = 0;
			
			function downloadAll(checks) {
		        if (checks.getElementsByTagName("input").item(suffix)) {
		            if (checks.getElementsByTagName("input").item(suffix).checked) {
		                location.href = GetAttribute(checks.getElementsByTagName("a").item(suffix++), "href");
		                setTimeout(function () { downloadAll(checks) }, 1000);
		            }
		            else {
		                suffix++;
		                downloadAll(checks);
		            }
		        }
		        else
		            suffix = 0;
		    }

			/* 2020-01-30 홍승비 - 체크한 파일이 1개 이상인 경우, zip 파일로 다운받는 함수 */
	        function AttachAllDownload(checks) {
	            var checkedFiles = $("#attachedfileDIV").find("input:checkbox[name='fileSelect']:checked");
	            var checkedFilesLength = checkedFiles.length;
	            var filePath = ""; // 전체파일경로
	            var filePathTemp = "";
				var fileNames = ""; // 파일이름
				var fileNamesUID = ""; // 파일이름(UID 포함)
				
				if (checkedFilesLength == 1) { // 하나만 저장
					downloadAll(checks);
				}
				else if (checkedFilesLength > 1) { // 여러개는 zip으로 저장
					filePath = decodeURIComponent(GetAttribute(checkedFiles.get(0), "filepath"));
					filePath = filePath.substr(0, filePath.lastIndexOf("/"));
					
					for (var i = 0; i < checkedFilesLength; i++) {
						filePathTemp = decodeURIComponent(GetAttribute(checkedFiles.get(i), "filepath")); // 각 파일의 풀경로
						fileNames += MakeXMLString(checkedFiles.get(i).value) + ":"; // 각 파일의 이름을 :로 이어붙인 것
						fileNamesUID += MakeXMLString(filePathTemp.substr(filePathTemp.lastIndexOf("/"), filePathTemp.length)) + ":"; // 각 파일의 이름+UID를 :로 이어붙인 것
					}
					
					var $frm = $("<form></form>");
			    	$frm.attr('action', "/ezSchedule/downloadAttachAll.do");
			    	$frm.attr('method', 'post');
			    	$frm.appendTo('body');
			
			    	param1 = $('<input type="hidden" value="' + filePath + '" name="filePath" />');
			    	param2 = $("<input type='hidden' value='" + fileNames + "' name='fileNames' />");
			    	param3 = $("<input type='hidden' value='" + fileNamesUID + "' name='fileNamesUID' />");
			    	
			    	$frm.append(param1).append(param2).append(param3);
			    	$frm.submit();
				}
				else { // 체크된 파일 없음
					return;
				}
	        }
			
			function manage_attendant() {	
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 355) / 2;
	            var pLeft = (pwidth - 530) / 2;
	            window.open("/ezSchedule/scheduleManageAttendant.do?ownerid=" + ownerid + "&id=" + encodeURIComponent(scheduleid) + "&changekey=" + encodeURIComponent(changekey) + "&type=" + scheduletype + "&dtype=" + datetype + "&pattern=" + pattern + "&StartTime=" + s_DateForAttandant + "&EndTime=" + e_DateForAttandant, "",
	                "height = 355px, width = 530px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=0");
	        }
	        
	        var schedule_delete_confirm_cross_dialogArguments = new Array();
	        function repetiton_check() {	
	        	schedule_delete_confirm_cross_dialogArguments[0] = "";
	        	schedule_delete_confirm_cross_dialogArguments[1] = deleteSchedule_Complete;
	            GetOpenWindow("/ezSchedule/scheduleDeleteConfirm.do?resourceInfo="+ResourceInfo, "schedule_delete_confirm_Cross", 500, 170);
	        }
	        
	        function deleteSchedule_Complete(ret) {	        	
	        	var optionStr = ret[0];
	        	ResourceDel = ret[1];
	        	
				if (optionStr == "0") {
					once_delete_schedule();
				} else if (optionStr == "1") {
					delete_schedule();
				} 
		    }
	        
	        function check_schedule() {
	        	if ("${scheduleInfo.dateType}" == "3") {
	        		repetiton_check();	        	
	        	} else {
	        		if (confirm("<spring:message code='ezSchedule.t209' />")) {
	        			delete_schedule();
		        	} 
	        	}
	        }
	
	        function delete_schedule() {	        	
	            //if (!confirm("<spring:message code='ezSchedule.t209' />"))
	            //    return;
	
	            /* 2018-12-17 김민성 - 부모창에서 confirm창 뜨도록 변경 */
	            /* var ResourceDel = "FALSE";;
	            if (ResourceInfo != "0") {
	                confirm("<spring:message code='ezSchedule.t1300' />") ? ResourceDel = "TRUE" : ResourceDel = "FALSE";
	            }  */          
	            
	            $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleDelete.do",
					data : { 
						scheduleId : scheduleid,
						resDel : ResourceDel,
						dateType : datetype
					},
					success: function() {
						alert("<spring:message code='ezSchedule.t213' />");
						
						try {
		                	if (window.opener != null && window.opener.RefreshView != undefined) {
		                		window.opener.RefreshView();
		                	}
		                 } catch (e) { }
		                 
		                try { // 일정 포틀릿 새로고침
		                    if (parent.opener != null && parent.opener.refreshSchedulePortlet != undefined) {
		                    	parent.opener.refreshSchedulePortlet();
		                    }
	                    } catch (e) {console.log(e);}
	                    
	                    try { // 바로가기 테마 새로고침
		                    if (parent.opener != null && parent.opener.getScheduleList_Top != undefined) {
		                    	var selectedTd = parent.opener.document.querySelector('#theme2Body #CalendarMini_Top td.select div');
		                    	if (!selectedTd) {
		                    		selectedTd = parent.opener.document.querySelector('#theme2Body #CalendarMini_Top td.main_today div');
		                    	}
		                    	var selectedDate = selectedTd.getAttribute('dispdate');
		                    	parent.opener.getScheduleList_Top(selectedDate, 'P');
		                    	parent.opener.openerCalendarMiniView("CalendarMini_Top");	    		
		                    	parent.opener.openerCalendarMiniDataSource("Top");
		                    }
	                    } catch (e) {console.log(e);}
	                    
		                if (window.opener && window.opener.reload != undefined)
		                    window.opener.reload();
		                window.close();
					},
					error: function(err) {
						alert("<spring:message code='ezSchedule.t212' />");
					}
				});	
	        }
	        
	        function once_delete_schedule() {
	        	//if (!confirm("<spring:message code='ezSchedule.t209' />"))
	            //    return;
		            
	            $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleOnceDelete.do",
					data : { 
						scheduleId : scheduleid,
						selectDate : "${_date}",
						startDate : "${scheduleInfo.startDate}",
						repeatCount : repeatCount
					},
					success: function() {
						alert("<spring:message code='ezSchedule.t213' />");
						
		                try {
		                	if (parent.opener != null && parent.opener.RefreshView != undefined) {
		                		parent.opener.RefreshView();
		                	}
		                 } catch (e) { }
						
		                try { // 일정 포틀릿 새로고침
		                    if (parent.opener != null && parent.opener.refreshSchedulePortlet != undefined) {
		                    	parent.opener.refreshSchedulePortlet();
		                    }
	                    } catch (e) {console.log(e);}
	                    
	                    try { // 바로가기 테마 새로고침
		                    if (parent.opener != null && parent.opener.getScheduleList_Top != undefined) {
		                    	var selectedTd = parent.opener.document.querySelector('#theme2Body #CalendarMini_Top td.select div');
		                    	if (!selectedTd) {
		                    		selectedTd = parent.opener.document.querySelector('#theme2Body #CalendarMini_Top td.main_today div');
		                    	}
		                    	var selectedDate = selectedTd.getAttribute('dispdate');
		                    	parent.opener.getScheduleList_Top(selectedDate, 'P');
		                    	parent.opener.openerCalendarMiniView("CalendarMini_Top");	    		
		                    	parent.opener.openerCalendarMiniDataSource("Top");
		                    }
	                    } catch (e) {console.log(e);}
	                    
		                if (window.opener && window.opener.reload != undefined)
		                    window.opener.reload();
		                window.close();
					},
					error: function(err) {
						alert("<spring:message code='ezSchedule.t212' />");
					}
				});
	        }
				
	        function edit_schedule() {
	            var id = scheduleid;
	            var win = null;
	
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 760) / 2;
	            var pLeft = (pwidth - 790) / 2;
	            
	            /* 2021-11-25 홍승비 - 일정 수정 시 반복일정의 repeatCount와 repStartDate를 전달 */
	            if (CrossYN()) {
	                win = window.open("/ezSchedule/scheduleWrite.do?id=" + encodeURIComponent(id) + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + pattern + "&pageFrom=" + pageFrom + "&otherid=" + _otherid
	                		+ "&repeatCount=" + repeatCount + "&repStartDate=" + encodeURIComponent(repStartDate) + "&showtop=" + showtop, "", "height = 830px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            } else {
	            	win = window.open("/ezSchedule/scheduleWrite.do?id=" + encodeURIComponent(id) + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + pattern + "&pageFrom=" + pageFrom + "&otherid=" + _otherid
	            			+ "&repeatCount=" + repeatCount + "&repStartDate=" + encodeURIComponent(repStartDate), "", "height = 760px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            	/* if (pUse_Editor == "" || pUse_Editor == "CK") {
	                    win = window.open("/ezSchedule/scheduleWrite.do?id=" + encodeURIComponent(id) + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + pattern + "&pageFrom=" + pageFrom + "&otherid=" + _otherid, "",
	                                        "height = 760px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                }  else {
	                    win = window.open("schedule_write_IE.aspx?id=" + encodeURIComponent(id) + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + pattern + "&pageFrom=" + pageFrom + "&otherid=" + _otherid, "",
	                                        "height = 760px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                } */
	            }
	
	            win.opener = window.opener;
	            window.close();
	        }
	        
	        function Print_onClick() {	
	            var printCreator = "";
	            var printCreateDate = "";
	            var printAttendant = "";
	            var printIsPublic = "";
	            var printImportance = "";
	            var printRepetition = "";
	            var printDate = "";
	            var printLocation = "";
	            var printTitle = "";
	            var printAttach = "";
	            var printDocument = "";
	
	            printCreator = getNodeText(document.getElementById("LabelCreator"));
	            printCreateDate = getNodeText(document.getElementById("LabelCreateDate"));
	            printIsPublic = getNodeText(document.getElementById("LabelPublic"));
	            printImportance = getNodeText(document.getElementById("LabelImportance"));
	  			if (scheduletype == "1" || scheduletype == "6") {
	            	printAttendant = getNodeText(document.getElementById("LabelAttendant"));
	            }	            
	            printDate = getNodeText(document.getElementById("LabelDate"));
	            printLocation = getNodeText(document.getElementById("LabelLocation"));
	            printTitle = getNodeText(document.getElementById("LabelSubject"));
			
	            printDocument = document.getElementById("message").contentWindow.document.body.innerHTML;
	            printAttach = document.getElementById("attachedfileDIV").innerHTML;
	
	            var params = { 'type': 'READ', 'printCreator': printCreator, 'printCreateDate': printCreateDate, 'printAttendant': printAttendant, 'printIsPublic': printIsPublic, 'printImportance': printImportance, 'printRepetition': printRepetition, 'printDate': printDate, 'printLocation': printLocation, 'printTitle': printTitle, 'printAttach': printAttach, 'printDocument': printDocument };
	
	            post_to_url("/ezSchedule/scheduleContentsPrint.do", params, "post");
	        }
	
			function addRelatedCabinet() {
				//* moon 2018.07.26
				window.open("/ezCabinet/cabinetAddRelated.do?module=schedl", "addRelated", getOpenWindowfeature(480, 505));
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}
	        
	        function post_to_url(path, params, method) {
	            method = method || "post";
	
	            var pheight = window.screen.availHeight;
	            var conHeight = pheight * 0.8;
	            var pwidth = window.screen.availWidth;
	            var conWidth = pwidth * 0.8;
	            if (conWidth > 790) {
	                conWidth = 790;
	            }
	            if (conHeight > 670) {
	            	conHeight = 670;
	            }
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - 790) / 2;
	
	            var title = "Print";
	            var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no,width=" + conWidth + "px, height=" + conHeight + "px, top=" + pTop.toString() + ",left=" + pLeft.toString();
	            window.open("", title, status);
	
	            var form = document.createElement("form");
	            form.setAttribute("method", method);
	            form.setAttribute("target", title);
	            form.setAttribute("action", path);
	            for (var key in params) {
	                var hiddenField = document.createElement("input");
	                hiddenField.setAttribute("type", "hidden");
	                hiddenField.setAttribute("name", key);
	                hiddenField.setAttribute("value", params[key]);
	                form.appendChild(hiddenField);
	            }
	            document.body.appendChild(form);
	            form.submit();
	        }
	        
	        function makeRepetitionScheduleString(startDate, endDate, repetitionInfo) {
	        	var repeatinfo = '';
				var info = repetitionInfo.split("|");
				var repetitionType = info[2];
				if(repetitionType){
					repeatinfo = strLang33;
				}
				
				switch (repetitionType) {
					case "0":
						if (info[3] == '0') {
							repeatinfo += strLang45;
						} else if (info[3] == '1') {
							repeatinfo += strLang34;
						} else {
							repeatinfo += info[3] + strLang81;
						}
						break;
					case "1":
						if(info[3] == '1'){				
							repeatinfo += strLang35 + " ";
							if(info[4]){
								for (var i = 0; i< info[4].length; i++){
									var eachDayOfWeek = info[4].substr(i, 1);
									var dayOfWeekStringInfo = makeStringDayofWeekInfo(eachDayOfWeek);
									if (i>0) {
										repeatinfo += strLangGHA1;
									}
									repeatinfo += dayOfWeekStringInfo;
								}
							}
						}else{
							repeatinfo += info[3] + strLang82 + " ";
							if(info[4]){
								for (var i = 0; i< info[4].length; i++){
									var eachDayOfWeek = info[4].substr(i, 1);
									var dayOfWeekStringInfo = makeStringDayofWeekInfo(eachDayOfWeek);
									if (i>0) {
										repeatinfo += strLangGHA1;
									}
									repeatinfo += dayOfWeekStringInfo;
								}
							}
						}
						break;
				    case "2":
				    	if(info[3] == '1'){
				    		if(info[4] == '1') {
								repeatinfo += strLang36 + " ";
				    		}
				    		else {
				    			repeatinfo += info[4] + strLang83 + " ";
				    		}
							repeatinfo += info[5] + strLang80 + " ";
						}else{					
							if(info[4] == '1') {
								repeatinfo += strLang36 + " ";
							}
							else {
								repeatinfo += info[4] + strLang83 + " ";
							}
							for (var i = 0; i< info[5].length; i++){
								var weekNumberInfo = makeStringWeekNumber(info[5]);
								repeatinfo += weekNumberInfo; 
							}
							repeatinfo += " ";
							for (var i = 0; i < info[6].length; i++) {
								var idx = info[6].substr(i, 1);
								var dayOfWeekStringInfo = makeStringDayofWeekInfo2(idx);
								if (i>0) {
									repeatinfo += strLangGHA1;
								}
								repeatinfo += dayOfWeekStringInfo;
							}
						}
						break;
					case "3":
						if (info[3] == '1'){
							repeatinfo += strLang37 + " ";
							repeatinfo += info[4] + strLang122 + " ";
							repeatinfo += info[5] + strLang80;
						} else {	
							repeatinfo += strLang37 + " ";
							repeatinfo += info[4] + strLang122 + " ";
							for (var i = 0; i< info[5].length; i++){
								var weekNumberInfo = makeStringWeekNumber(info[5]);
								repeatinfo += weekNumberInfo;
							}
							repeatinfo += " ";
							for (var i = 0; i < info[6].length; i++) {
								var idx = info[6].substr(i, 1);
								var dayOfWeekStringInfo = makeStringDayofWeekInfo2(idx);
								if (i>0) {
									repeatinfo += strLangGHA1;
								}
								repeatinfo += dayOfWeekStringInfo;
							}
						}
					break;
				}	

				repeatinfo += " ";
				
				if (info[1] == "1") {					// 하루종일 일정
					repeatinfo += strLang39;
				} else {
					repeatinfo += strLang38 + startDate.substring(11,16) + " ~ " +endDate.substring(11,16);
				}
				
				repeatinfo += " ";
				
				if (info[0] == -1) {
				    repeatinfo += " " + strLang79 + " : " + startDate.substring(0,10) + " ~ " + strLang46;
				} else if (info[0] == 0){
					repeatinfo += " " + strLang79 + " : " + startDate.substring(0,10) + " ~ " + endDate.substring(0,10);
				} else {
					repeatinfo += " " + strLang79 + " : " + startDate.substring(0,10) + " ~ " + info[0] + strLang47;
				}
				
				return repeatinfo;
			}
	        
	        function makeStringDayofWeekInfo(dayOfWeek) {
				var dayOfWeekString;
				switch (dayOfWeek){
					case "0":
						dayOfWeekString = strLang48;
						break;
					case "1":
						dayOfWeekString = strLang49;
						break;
					case "2":
						dayOfWeekString = strLang50;
						break;
					case "3":
						dayOfWeekString = strLang51;
						break;
					case "4":
						dayOfWeekString = strLang52;
						break;
					case "5":
						dayOfWeekString = strLang53;
						break;
					case "6":
						dayOfWeekString = strLang54;
						break;
				}
				return dayOfWeekString;
			}
	        
	        function makeStringDayofWeekInfo2(dayOfWeek) {
				var dayOfWeekString;
				switch (dayOfWeek){
					case "0":
						dayOfWeekString = strLang60;
						break;
					case "1":
						dayOfWeekString = strLang61;
						break;
					case "2":
						dayOfWeekString = strLang62;
						break;
					case "3":
						dayOfWeekString = strLang63;
						break;
					case "4":
						dayOfWeekString = strLang64;
						break;
					case "5":
						dayOfWeekString = strLang65;
						break;
					case "6":
						dayOfWeekString = strLang66;
						break;
				}
				return dayOfWeekString;
			}
			
			function makeStringWeekNumber(number) {
				var weekNumber;
				switch (number){
					case "1":
						weekNumber = strLang55;
						break;
					case "2":
						weekNumber = strLang56;
						break;
					case "3":
						weekNumber = strLang57;
						break;
					case "4":
						weekNumber = strLang58;
						break;
					case "5":
						weekNumber = strLang59;
						break;
				}
				return weekNumber;
			}
			
			function accept_schedule(status) {
				var scheduleIdList = new Array();
				var creatorList = new Array();
				scheduleIdList[0] = "<c:out value='${_scheduleid}' />";
				
				var data = new Object();
			    data.creatorId = "<c:out value='${scheduleInfo.creatorId}' />";
			    data.creatorName = "<c:out value='${scheduleInfo.creatorName}'/>";
			    data.title = "<c:out value='${scheduleInfo.title}'/>";
			    data.dateType = "<c:out value='${scheduleInfo.dateType}' />";		
			    data.startDate = "<c:out value='${scheduleInfo.startDate}' />";
			    data.endDate = "<c:out value='${scheduleInfo.endDate}' />";
			    
			    creatorList.push(data);
			    
				var url = "/ezSchedule/scheduleAcceptAttendant.do";
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : url,
					data : {						
						status 	 : status,
						displayName : "<c:out value='${userInfo.displayName1}'/>",
						displayName2 : "<c:out value='${userInfo.displayName2}'/>",
						scheduleIdList : scheduleIdList,
						creatorList : JSON.stringify(creatorList)
					},
					success: function(result) {
						if (status == "1") {
							alert("<spring:message code='ezSchedule.t336' />");
						} else {
							alert("<spring:message code='ezSchedule.t337' />");
						}
					},
					error: function() {
						if (status == "1") {
							alert("<spring:message code='ezSchedule.t334' />");
						} else {
							alert("<spring:message code='ezSchedule.t335' />");
						}
					}			
				});
				window.close();
			}

			var writeboardselect_modal_dialogArguments = new Array();
			function NewItem_onclick() {
				writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
				var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
				try { OpenWin.focus(); } catch (e) { }
			}

			function NewItem_onclick_Complete(ret) {
				if (typeof (ret) != "undefined") {
					pBoardID = ret[0];
					if (pBoardID == "" || typeof (pBoardID) == "undefined") {
						return;
					}
					var pheight = window.screen.availHeight;
					var pwidth = window.screen.availWidth;
					var pTop = (pheight - 720) / 2;
					var pLeft = (pwidth - 765) / 2;

					if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4" || ret[2] == "7" || (ret[3] != "null" && ret[3] != null && ret[3] != "")) {
						alert(ezSchedule_kyj1);
					}
					else {
						window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&url=" + encodeURIComponent(contentpath) + "&scheduleId=" + scheduleid, '', GetOpenWindowJun(765, 870));
					}
				}
			}
		</script>
	</head>
	
	<body class="popup" scroll="no" style="height:98%">
	    <form method="post" style="height:98%">
	        <table id="normalScreen" style="height:100%; width:100%;" class="layout">
	            <tr>
	                <td style="height:20px">	                    
	                    <div id="menu">
	                        <ul>
	                        	<c:if test="${_editPosible == 'Y' && usage == 'Y'}">
	                                <li>
	                                	<span onclick="edit_schedule()"><spring:message code='ezSchedule.t302' /></span>
	                                </li>
	                                <li id ="manageli">
	                                	<span id=managespan onclick="manage_attendant()"><spring:message code='ezSchedule.t303' /></span>
	                                </li>
									<li id="btnBoard">
										<span id="span_btnBoard" onClick="return NewItem_onclick()"><spring:message code='ezApprovalG.t1514'/></span>
									</li>
	                                <li>
	                                	<span class="icon16 popup_icon16_delete" onclick="check_schedule()"></span>
	                                </li>
                                </c:if>
								<c:if test="${useCabinet == 'YES'}">
									<li><span onclick="addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
								</c:if>
								<c:if test="${attendantCheck == 'Y'}">
	                                <li>
	                                	<span onclick="accept_schedule('1')"><spring:message code='ezSchedule.t338' /></span>
	                                </li>
	                                <li>
	                                	<span onclick="accept_schedule('2')"><spring:message code='ezSchedule.t339' /></span>
	                                </li>
	                            </c:if>
								<li>
                            		<span class="icon16 popup_icon16_print" onclick="Print_onClick()"></span>
                            	</li>
	                        </ul>
	                    </div>
	                    <div id="close">
	                        <ul>
	                            <li>
	                            	<span onclick="window.close()"></span>
	                            </li>
	                        </ul>
	                    </div>
	                </td>
	            </tr>
	            <tr>
	                <td style="height:20px">
	                    <table style="width:100%" class="popuplist">	                         
	                        <c:if test="${scheduleInfo.scheduleType == '7'}">
	                        	<tr id ="scheduleGroupInfoTR">
		                            <th style="white-space:nowrap">
		                                <spring:message code='ezSchedule.jjh04' />
		                            </th>
		                            <td colspan="3" style="white-space:nowrap;">
		                            <!-- 2018-07-23 김보미 - 테이블 중앙정렬을 위한 너비값 제거 -->
<!-- 		                                <div style="cursor: pointer;width:280px"> -->
		                                <div style="cursor: pointer;">
		                                    <c:out value="${scheduleInfo.groupName}" />
		                                </div>
		                            </td>                            
		                        </tr>
	                        </c:if>
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.jjh05' />
	                            </th>
	                            <td style="white-space:nowrap;">
	                                <div>
	                                 <!-- 2018-07-23 김보미 - 테이블 중앙정렬을 위한 너비값 제거 -->
<!-- 	                                	<span  style="cursor: pointer;width:280px;" onclick="show_personinfo('0')" id="LabelCreator"> -->
	                                	<span  style="cursor: pointer;" onclick="show_personinfo('0')" id="LabelCreator">
											<c:choose>
												<c:when test="${scheduleInfo.scheduleType == '10' && scheduleInfo.creatorId != scheduleInfo.ownerId}">
													<c:out value="${primary == '1' ? scheduleInfo.creatorName : scheduleInfo.creatorName2}" /> (<c:out value="${primary == '1' ? scheduleInfo.ownerName : scheduleInfo.ownerName2}" />)
												</c:when>
												<c:otherwise>
													<c:out value="${primary == '1' ? scheduleInfo.creatorName : scheduleInfo.creatorName2}" />
												</c:otherwise>
											</c:choose>
	                                	</span>	                                    
	                                </div>
	                            </td>
	                             <!-- 2018-07-23 김보미 - 테이블 중앙정렬을 위한 너비값 제거 -->
<!-- 	                            <th style="white-space:nowrap; width:80px"> -->
	                            <th style="white-space:nowrap;">
	                                <spring:message code='ezSchedule.jjh06' />
	                            </th>
	                             <!-- 2018-07-23 김보미 - 테이블 중앙정렬을 위한 너비값 제거 -->
<!-- 	                            <td style="white-space:nowrap; width:100%"> -->
	                            <td style="white-space:nowrap;">
	                                <div id="LabelCreateDate">	                                    
	                                    <c:out value="${fn:substring(scheduleInfo.createDate,0,16)}" />
	                                </div>
	                            </td>
	                        </tr>	                        
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t309' />
	                            </th>
	                            <td>
	                                <div id="LabelPublic">
	                                    <c:if test="${scheduleInfo.isPublic == 'Y'}"><spring:message code='ezSchedule.t359' /></c:if>
	                                    <c:if test="${scheduleInfo.isPublic == 'N'}"><spring:message code='ezSchedule.t360' /></c:if>
	                                </div>
	                            </td>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.jjh07' />
	                            </th>
	                            <td>
	                                <div id="LabelImportance">
	                                    <c:if test="${scheduleInfo.importance == '1'}"><spring:message code='ezSchedule.t325' /></c:if>
	                                    <c:if test="${scheduleInfo.importance == '2'}"><spring:message code='ezSchedule.t326' /></c:if>
	                                    <c:if test="${scheduleInfo.importance == '3'}"><spring:message code='ezSchedule.t327' /></c:if>
	                                </div>
	                            </td>
	                        </tr>
	                        <c:if test="${scheduleInfo.scheduleType == '1' || scheduleInfo.scheduleType == '6'}"> 
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t311' />
	                            </th>
	                            <td colspan="3" width="100%" style="overflow-y: auto; height: 100%; width: 100%; vertical-align: middle; display: table-cell;">
	                                <div style="max-height:30px;" id="LabelAttendant">	                                
	                                	<c:forEach var="item" items="${attendantList}" varStatus="status">	                                		  		
	                                	 	<span title="<spring:message code='ezSchedule.t162'/>" style="cursor:pointer" onclick="show_personinfo('${item.attendantId}')">
	                                	 		<!-- 2018-08-08 김보미 -->
	                                	 		<!--<c:if test="${lang == '1'}"><c:out value="${item.attendantName}" /></c:if>
	                                	 		<c:if test="${lang != '1'}"><c:out value="${item.attendantName2}" /></c:if>-->
	                                	 		<c:if test="${primary == '1'}"><c:out value="${item.attendantName}" /></c:if>
	                                	 		<c:if test="${primary != '1'}"><c:out value="${item.attendantName2}" /></c:if>
                                    			<c:if test="${item.status == '1'}">(<spring:message code='ezSchedule.t251' />)</c:if>
	                                			<c:if test="${item.status == '2'}">(<spring:message code='ezSchedule.t168' />)</c:if>
	                                			<c:if test="${item.status == '3'}">(<spring:message code='ezSchedule.t169' />)</c:if>
	                                			<c:if test="${item.status != '1' && item.status != '2' && item.status != '3'}">(<spring:message code='ezSchedule.t166' />)</c:if>
	                                			<c:if test="${fn:length(attendantList) != status.count}">,</c:if>	                                				                                		
                                    		</span>
	                                	</c:forEach>                            
	                                </div>
	                            </td>
	                        </tr>
	                        </c:if>	                        
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t312' />
	                            </th>
	                            <td >
	                                <div id="LabelDate" style="word-break: break-all;overflow-y: auto;max-height: 30px;padding-top: 2px;">
	                                    <!-- <asp:Label ID="LabelDate" runat="server"></asp:Label> -->
	                                    <c:out value="${dateString}" />
	                                </div>
	                            </td>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t313' />
	                            </th>
	                            <td>
	                                <div style="word-break: break-all; overflow-y: auto; height: 20px; padding-top: 2px" id="LabelLocation">	                                    
	                                    <c:out value="${scheduleInfo.location }" />
	                                </div>
	                            </td>
	                        </tr>
	                        <tr>
	                            <th style="white-space:nowrap">
	                                <spring:message code='ezSchedule.t314' />
	                            </th>
	                            <td colspan="3">
	                                <div style="overflow-y: auto; height: 100%; width: 100%; vertical-align: middle; display: table-cell;" id="LabelSubject">	                                    
	                                    <c:out value="${scheduleInfo.title}" />
	                                </div>
	                            </td>
	                        </tr>
	                    </table>
	                </td>            
	            </tr>
	            <tr>
	                <td class="pad1" style="vertical-align: top; height: 100%" id="messagetd">
	                    <iframe id="message" style="border: #ddd 1px solid; padding-left: 5px; overflow: auto;width: calc(100% - 7px); padding-top: 6px; height: 350px !important; background-color: white"></iframe>	                    
	                </td>
	            </tr>
	            <tr>
	                <td height="20">
	                    <table class="file">
	                        <tr>
	                            <th>
	                                <spring:message code='ezSchedule.t316' />
	                            </th>
	                            <td class="pos1">
	                                <div id="attachedfileDIV" style="margin-top: 0px; overflow: auto; padding-top: 0px;height: 50px;" align="left">
	                                    <c:forEach var="item" items="${attachList}" varStatus="status">
	                                    	<div style="margin-top:3px;height:auto;">
	                                    		<c:set var="imagePath" value="/images/file.gif" />
	                                    		<input type="checkbox" name="fileSelect" filename="${item.fileEncodeName}" filepath="${item.filePath}" value="${item.fileName}">
	                                    		<c:if test="${item.fileType == 'jpg' || item.fileType == 'jpeg' || item.fileType == 'bmp' || item.fileType == 'gif' || item.fileType == 'png' || item.fileType == 'tif' || item.fileType == 'tiff'}">
	                                    			<c:set var="imagePath" value="/images/image.png" />
	                                    		</c:if>
	                                    		<c:if test="${item.fileType == 'doc' || item.fileType == 'docx'}">
	                                    			<c:set var="imagePath" value="/images/doc.png" />
	                                    		</c:if>
	                                    		<c:if test="${item.fileType == 'xls' || item.fileType == 'xlsx'}">
	                                    			<c:set var="imagePath" value="/images/xls.png" />
	                                    		</c:if>
	                                    		<c:if test="${item.fileType == 'ppt' || item.fileType == 'pptx' || item.fileType == 'pps' || item.fileType == 'ppsx'}">
	                                    			<c:set var="imagePath" value="/images/ppt.png" />
	                                    		</c:if>
	                                    		<c:if test="${item.fileType == 'txt'}">
	                                    			<c:set var="imagePath" value="/images/txt.png" />
	                                    		</c:if>
	                                    		<c:if test="${item.fileType == 'zip'}">
	                                    			<c:set var="imagePath" value="/images/zip.png" />
	                                    		</c:if>
	                                    		<c:if test="${item.fileType == 'pdf'}">
	                                    			<c:set var="imagePath" value="/images/pdf.png" />
	                                    		</c:if>
	                                    		<c:if test="${item.fileType == 'ecm'}">
	                                    			<c:set var="imagePath" value="/images/ecm.png" />
	                                    		</c:if>	                                    		
	                                    		<img src="${imagePath}" />&nbsp;<a href="/ezSchedule/downloadAttach.do?fileName=${item.fileEncodeName}&filePath=${item.filePath}" id="regData_${status.count}"><c:out value="${item.fileName}"/> (${item.fileTranSize})</a>	                                    		
	                                    	</div>
	                                    </c:forEach>
	                                </div>
	                            </td>
	                            <td class="pos2">	                                
	                                <a class="imgbtn imgbck">
	                                	<span style="width:57px;" onclick="attach_SelectAll()"><spring:message code='ezSchedule.t317' /></span>
	                                </a><br/>	                                
	                                <a class="imgbtn imgbck">
	                                	<span style="width:57px;" onclick="attach_Download()"><spring:message code='ezSchedule.t157' /></span>
	                                </a>
	                            </td>
	                        </tr>
	                    </table>
	                </td>
	            </tr>
	        </table>
	        <div id="printScreen" style="display: none">
	            <table class="popuplist" style="width:100%">
	                <tr>
	                    <th style="white-space:nowrap"><spring:message code='ezSchedule.t161' />
	                    </th>
	                    <td style="white-space:nowrap">
	                        <div id="printCreator"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t306' />
	                    </th>
	                    <td>
	                        <div id="printCreateDate"></div>
	                    </td>
	                </tr>	                
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t309' />
	                    </th>
	                    <td>
	                        <div id="printIsPublic"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap"><spring:message code='ezSchedule.t310' />
	                    </th>
	                    <td>
	                        <div id="printImportance"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap"><spring:message code='ezSchedule.t163' />
	                    </th>
	                    <td>
	                        <div id="printAttendant"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t318' />
	                    </th>    
	                    <td>
	                        <div id="printDate"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t273' />
	                    </th>
	                    <td>
	                        <div id="printLocation"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t272' />
	                    </th>
	                    <td>
	                        <div id="printTitle"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <th style="white-space:nowrap">
	                        <spring:message code='ezSchedule.t319' />
	                    </th>
	                    <td>
	                        <div id="printAttach"></div>
	                    </td>
	                </tr>	                
	                <tr>
	                    <td colspan="2">
	                        <div id="printDocument" style="padding-right: 5px; padding-left: 5px;padding-bottom: 5px; width: 100%; padding-top: 5px; text-align:left"></div>
	                    </td>
	                </tr>
	            </table>
	        </div>	
	        <c:if test="${scheduleInfo.scheduleFlag == 'google'}">
	        	 <div id="syncDataTemp">${scheduleBody}</div>
	        </c:if>
	        <script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
	        </script>	
	    </form>
	</body>
</html>