<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>        
		<title><spring:message code='ezSchedule.t123'/></title>
		<script>
			var g_currentDate;
		    var g_orgUserID = "<c:out value='${userInfo.id}'/>";
			var uselang = "<c:out value='${userInfo.lang}'/>"
			var groupId = "<c:out value='${groupId}'/>";
			var groupName = "<c:out value='${groupName}'/>";
			var Para = {"id": new Array(), "name": new Array(), "deptname": new Array()};
			var s_date = "";
			var e_date = "";
	
		    function add_DATEs(dateformat, dates) {
		        var int_millisecond = 1;
		        var int_second = 1000 * int_millisecond;
		        var int_minute = 60 * int_second;
		        var int_hour = 60 * int_minute;
		        var int_day = 24 * int_hour;
		        var YY_form = Number(dateformat.substring(0, 4));
		        var MM_form = Number(dateformat.substring(5, 7)) - 1;
		        var DD_form = Number(dateformat.substring(8, 10));
	
		        var date = new Date(YY_form, MM_form, DD_form);
		        var date_milliseconds = date.valueOf();
		        var add_milliseconds = dates * int_day;
		        var ret_date = new Date(date_milliseconds + add_milliseconds);
		        var year = ret_date.getFullYear();
		        var month = ret_date.getMonth() + 1;
		        var day = ret_date.getDate();
		        if (month < 10) {
		            month = "0" + month;
		        }
		        if (day < 10) {
		            day = "0" + day;
		        }	
		        return ("" + year + "-" + month + "-" + day);
		    }
	
		    function getToday() {
		        var date = new Date();
		        var year = date.getFullYear();
		        var month = date.getMonth() + 1;
		        var day = date.getDate();
		        if (month < 10) {
		            month = "0" + month;
		        }
		        if (day < 10) {
		            day = "0" + day;
		        }
	
		        return ("" + year + "-" + month + "-" + day);
		    }
		    
		    function decodeHtml(str) {
                let txt = document.createElement("textarea");
                txt.innerHTML = str;
                return txt.value;
            }
			
		    function window_onload() {
		    	$.ajax({
					type: "GET",
					dataType: "xml",
					async: false,
					data: {
						groupID: groupId
					},
					url: "/ezSchedule/getGatherDetail.do",
					success: function (text) {
						var totalLen = SelectNodes(text, "MEMBERID").length;

						for (var i = 0; i < totalLen; i++) {
							Para["id"][i] = SelectNodes(text, "MEMBERID").item(i).textContent;
							if (uselang == "1") {
								Para["name"][i] = SelectNodes(text, "INFO").item(i).textContent;
								Para["deptname"][i] = SelectNodes(text, "DESCRIPTION").item(i).textContent;
							} else {
								Para["name"][i] = SelectNodes(text, "INFO").item(i).textContent;
								Para["deptname"][i] = SelectNodes(text, "DESCRIPTION2").item(i).textContent;
							}
						}
					}
				});
				
				document.getElementById("groupName").innerText = groupName
	
		        if (typeof (Para) != "undefined" && Para != null) {
					s_date = getToday();
					var curDateArr = s_date.split("-");

					if (curDateArr.length > 0) {
						s_date = curDateArr[0] + "-" + DateChange(curDateArr[1]) + "-" + DateChange(curDateArr[2]);
					}
					
					e_date = getToday();
					curDateArr = e_date.split("-");

					if (curDateArr.length > 0) {
						e_date = curDateArr[0] + "-" + DateChange(curDateArr[1]) + "-" + DateChange(curDateArr[2]);
					}
		            g_currentDate = s_date;
					
		            if (Para["id"].length > 0) {
		                for (var i = 0 ; i < Para["id"].length; i++) {
		                    var entryID = Para["id"][i];
		                    var entryName = Para["name"][i];
	
		                    CreateEmptyInputLine();
	
		                    var objTrNode = GetChildNodes(GetChildNodes(entryList)[0])[GetChildNodes(GetChildNodes(entryList)[0]).length - 2];
		                    var listNode = GetChildNodes(GetChildNodes(GetChildNodes(GetChildNodes(objTrNode)[1])[0])[0])[0];
	
		                    GetChildNodes(objTrNode)[0].innerHTML = entryName;
		                    GetChildNodes(objTrNode)[0].id = entryID;
	
		                    DisplayScheduleList(listNode, entryID);
		                }
		            }
		        } else {
		            var sysDate = new Date();
	
		            s_date = sysDate.getFullYear() + "-"
		                        + (parseInt(sysDate.getMonth()) + 1) + "-"
		                        + sysDate.getDate();
	
		            e_date = sysDate.getFullYear() + "-"
		                        + (parseInt(sysDate.getMonth()) + 1) + "-"
		                        + sysDate.getDate();
	
		            g_currentDate = s_date;
		        }
	
		        DisplayCurrentDate();
	
		        GetChildNodes(entryList)[0].removeChild(GetChildNodes(entryList)[0].lastChild);
		    }
	
		    function getDateFormate(s_date) {
		        if (parseInt(s_date.split('-')[1]) < 10) {
		            s_date = s_date.split('-')[0] + "-0" + s_date.split('-')[1] + "-" + s_date.split('-')[2];
		        }
	
		        if (parseInt(s_date.split('-')[2]) < 10) {
		            s_date = s_date.split('-')[0] + "-" + s_date.split('-')[1] + "-0" + s_date.split('-')[2];
		        }
		        return s_date;
		    }
	
		    function dateMove_onClick(interval) {
		        tmpCurrDate = add_DATEs(g_currentDate, parseInt(interval));
	
		        g_currentDate = tmpCurrDate;
		        updateScheduleOfSelectedUsers();
		    }
	
		    function changeScheduleList() {
		        g_currentDate = returnStartDateOfIdDatepicker();
	
		        updateScheduleOfSelectedUsers();
		    }
	
		    function updateScheduleOfSelectedUsers() {
		        var i;
	
		        DisplayCurrentDate();
	
		        for (i = 0 ; i < GetChildNodes(GetChildNodes(entryList)[0]).length ; i++) {
		            var trNode = GetChildNodes(GetChildNodes(entryList)[0])[i];
	
		            if (GetChildNodes(trNode)[0].id != "") {
		                var listNode = GetChildNodes(GetChildNodes(GetChildNodes(GetChildNodes(trNode)[1])[0])[0])[0];
		                var userID = GetChildNodes(trNode)[0].id;
	
		                listNode.title = "";
	
		                for (j = 0 ; j < GetChildNodes(listNode).length ; j++) {
		                    GetChildNodes(listNode)[j].style.backgroundColor = "";
		                    GetChildNodes(listNode)[j].style.paddingTop = "2";
		                }	
		                DisplayScheduleList(listNode, userID)
		            }
		        }
		    }	
	
		    function DisplayCurrentDate() {
		        var curDateArr = g_currentDate.split("-");
	
		        if (s_date == e_date) {
		            currDate.innerHTML = "<b>" + curDateArr[0] + "<spring:message code='ezSchedule.t125' />" + curDateArr[1] + "<spring:message code='ezSchedule.t126' />" + curDateArr[2] + "<spring:message code='ezSchedule.t127' />" + "</b>";
		        }
		        else {
		            currDate.innerHTML = "<b>" + curDateArr[0] + "<spring:message code='ezSchedule.t125' />" + curDateArr[1] + "<spring:message code='ezSchedule.t126' />" + curDateArr[2] + "<spring:message code='ezSchedule.t127' />" + "</b> ( " + s_date + " ~ " + e_date + " )";
		        }
		    }	
	
		    function DisplayScheduleList( objTrNode, ownerID ) {
				$.ajax({
					url : '/ezSchedule/scheduleAttendantList.do',
					method : 'GET',
					dataType : "text",
					async : false,
					data : {
						STARTDATE : g_currentDate,
						ENDDATE : g_currentDate,
						IDLIST : ownerID,
						APP : "1" ,
						MODE : "A"
					} ,
   					success : function(text) {
   						resultXML = loadXMLString(text);

   						if(typeof(resultXML) != "undefined" && getXmlString(resultXML) != "" )	{   							
   							var	objNodes0	= SelectNodes(resultXML, 'DATA/BUJAEINFO');

   							if( objNodes0.length > 0 )
   							{   								
   							    var strBujaeInfo = getNodeText(objNodes0.item(0));
   								var arrBujae = strBujaeInfo.split(":");
   								
   								if( arrBujae.length > 4 )
   								{
   									if( g_currentDate >= arrBujae[3].substr(0,10) && g_currentDate <= arrBujae[4].substr(0,10))
   									{							
   									    var s_hour = arrBujae[3].substring(11, 13);
   								        var s_minute = arrBujae[3].substring(14, 16);
   								        var e_hour = arrBujae[4].substring(11, 13);
   								        var e_minute = arrBujae[4].substring(14, 16);
   					    			    
   								        var cnt = ((parseInt(e_hour)*60) + parseInt(e_minute) - (parseInt(s_hour)*60) - parseInt(s_minute))/30;
   									    var s_cnt = parseInt(s_hour)*2;
   					    				
   									    if( parseInt(s_minute) == 30 )
   									    {
   										    s_cnt++;
   										    cnt++;
   									    }			    				
   									    var start = 0; bujaeend = GetChildNodes(objTrNode).length;
   					    				
   									    if(g_currentDate == arrBujae[3].substr(0,10) && g_currentDate < arrBujae[4].substr(0,10))
   									    {
   									        start = s_cnt;				   
   									    }	
   									    else if(g_currentDate > arrBujae[3].substr(0,10) && g_currentDate < arrBujae[4].substr(0,10))
   									    {
   									        start = 0;
   									        bujaeend =  GetChildNodes(objTrNode).length;
   									    }			
   									    else if(g_currentDate > arrBujae[3].substr(0,10) && g_currentDate <= arrBujae[4].substr(0,10))
   									    {
   									        bujaeend = (parseInt(s_hour)*2 + cnt) ;				   
   									    } 
   									    else if(g_currentDate == arrBujae[3].substr(0,10) && g_currentDate == arrBujae[4].substr(0,10))
   									    {
   									        start = s_cnt;
   									        bujaeend =  (parseInt(s_hour)*2 + cnt) ;	
   									    }
   					    				
   									    for(var j= start; j < bujaeend; j++)
   									    {
   									        GetChildNodes(objTrNode)[j].style.backgroundColor="#97bbd8";
   									    }
   								    
   								        if(bujaeend == oGetChildNodes(objTrNode).length)
   								        {
   										    return;
   										}
   									}
   								}
   							}		
   					        var objNodes1   = resultXML.getElementsByTagName("STARTDATE")
   							var	objNodes2	= resultXML.getElementsByTagName("ENDDATE");
   							var	objNodes3	= resultXML.getElementsByTagName("DATETYPE");
   							var	objNodes4	= resultXML.getElementsByTagName("TITLE");					
   							var	objNodes6	= resultXML.getElementsByTagName("ISPUBLIC");					
   							var titleStr = "";
   							var i;
   						
   							for( i = 0 ; i < objNodes1.length ; i++ ) {
   								if( getNodeText(objNodes6[i]) == "N" )
   								{		
   									continue;
   								}
   								var s_hour = getNodeText(objNodes1[i]).substring(11, 13);
   								var s_minute = getNodeText(objNodes1[i]).substring(14, 16);
   								var e_hour = getNodeText(objNodes2[i]).substring(11, 13);
   								var e_minute = getNodeText(objNodes2[i]).substring(14, 16);						
   								var allday = getNodeText(objNodes3[i]);
   								
   								if( allday == "2" )
   								{
   									for( var n = 0 ; n < GetChildNodes(objTrNode).length ; n++ )
   									{
   										GetChildNodes(objTrNode)[n].style.backgroundColor="rgba(61,143,234,0.8)";
   									}
   									
   									titleStr += "[<spring:message code='ezSchedule.t128' />] ";
   								}
   								else
   								{
   									var cnt = ((parseInt(e_hour)*60) + parseInt(e_minute) - (parseInt(s_hour)*60) - parseInt(s_minute))/30;
   									var s_cnt = parseInt(s_hour)*2;
   									
   									if( parseInt(s_minute) == 30 )
   									{
   										s_cnt++;
   										cnt++;
   									}							
   									
   									var start = 0; var end = GetChildNodes(objTrNode).length;
   									
   									var curDate = g_currentDate.split('-')[0] + Right(g_currentDate.split('-')[1], 2, "0") + Right(g_currentDate.split('-')[2], 2, "0")
   									var sNodeDate = getNodeText(objNodes1[i]).substr(0,10).replace("-","").replace("-","");
   									var eNodeDate = getNodeText(objNodes2[i]).substr(0,10).replace("-","").replace("-","");
   													
   									if(curDate == sNodeDate && curDate < eNodeDate)
   									{			
   									    start = s_cnt;					    	   
   									}	
   									else  if(curDate > sNodeDate && curDate < eNodeDate)
   									{
   									    start = 0;
   									    end =  GetChildNodes(objTrNode).length;				 
   									}				
   									else if(curDate > sNodeDate && curDate <= eNodeDate)
   									{
   									    end = (parseInt(s_hour)*2 + cnt);							 
   									}  
   									else  if(curDate == sNodeDate && curDate == eNodeDate)
   									{
   									    start = s_cnt;				    
   									    end =  (parseInt(s_hour)*2 + cnt);							  
   									}
   									else
   									    continue;		
   									
   									for(var j= start; j < end; j++)
   									{
   									    GetChildNodes(objTrNode)[j].style.backgroundColor="rgba(61,143,234,0.8)";
   									}
   									
   									titleStr += "[" + ChangeTime(s_hour, s_minute) + "~" + ChangeTime(e_hour, e_minute) + "] ";
   								}
   								
   								titleStr += getNodeText(objNodes4[i]);
   								
   								if( i < objNodes1.length - 1 )
   								{
   									titleStr += "\n";
   								}
   							}					
   							objTrNode.title = titleStr;					
   						}
					}					
				});				
			}
	
		    function Right(str, n, appendStr) {
		        if (n <= 0)
		            return "";
		        else if (n > String(str).length) {
		            var iLen = String(str).length;
		            return appendStr + String(str).substring(iLen, iLen - n);
		        }
		        else {
		            return str;
		        }
		    }
	
		    function ChangeTime(h, n) {
		        var reVal = "";
	
		        h = parseInt(h);
	
		        if (h == 0) {
		            reVal = "<spring:message code='ezSchedule.t129' />" + n;
		        }
		        else if (h == 12) {
		            reVal = "<spring:message code='ezSchedule.t130' />" + String(h) + ":" + n;
		        }
		        else if (h < 12) {
		            reVal = "<spring:message code='ezSchedule.t131' />" + String(h) + ":" + n;
		        }
		        else if (h > 12) {
		            h -= 12;
		            reVal = "<spring:message code='ezSchedule.t130' />" + String(h) + ":" + n;
		        }
	
		        return reVal;
		    }
	
		    function DateChange(pDate) {
		        if (parseInt(pDate, 10) < 10)
		            tmpSDate = "0" + String(parseInt(pDate, 10));
		        else
		            tmpSDate = pDate;
	
		        return tmpSDate;
		    }
	
		    function CreateEmptyInputLine() {
		        var oCloneNode = GetChildNodes(GetChildNodes(entryList)[0])[GetChildNodes(GetChildNodes(entryList)[0]).length - 1].cloneNode(true)
	
		        GetChildNodes(entryList)[0].appendChild(oCloneNode);
		    }
	
		    function GetChildNodes(node) {
		        var elements = new Array();
		            objNode = node.firstChild;
	
		            var idx = 0;
		            while (objNode) {
		                if (objNode.nodeType == 1) {
		                    elements[idx++] = objNode;
		                }
		                objNode = objNode.nextSibling;
		            }
		        return elements;
		    }



			document.addEventListener("DOMContentLoaded",function(){
				// 테이블 뒤 라인 생성용 테이블
				var bgTable = document.querySelector(".entryList_bg");

				var addTr = document.createElement("tr");
				for(var i = 0; i < 49; i++){
					var addTh = document.createElement("th");
					addTr.appendChild(addTh);
				}
				bgTable.appendChild(addTr);

				var addTr2 = document.createElement("tr");
				for(var j = 0; j < 49; j++){
					var addTd = document.createElement("td");
					addTr2.appendChild(addTd);
				}
				bgTable.appendChild(addTr2);


				// 일정표 max-height 계산식
				var windowHeight = $(window).height();
				var groupInfoHeight = $(".schedule_group_info").outerHeight(true) || 0;
				var h1Height = $("h1").outerHeight(true) || 0;
				var dateHeight = $(".schedule_list_date").outerHeight(true) || 0;
				var tableHeight = windowHeight - (groupInfoHeight + h1Height + dateHeight + 30);

				document.querySelector(".entry_wrap").style.maxHeight = tableHeight + "px";
			})

			window.addEventListener("resize",function(){
				// 일정표 리사이징시 높이 계산 - 첫 로딩때 계산과 동일
				var windowHeight = $(window).height();
				var groupInfoHeight = $(".schedule_group_info").outerHeight(true) || 0;
				var h1Height = $("h1").outerHeight(true) || 0;
				var dateHeight = $(".schedule_list_date").outerHeight(true) || 0;
				var tableHeight = windowHeight - (groupInfoHeight + h1Height + dateHeight + 40);

				document.querySelector(".entry_wrap").style.maxHeight = tableHeight + "px";
			})
		</script>
	</head>
	
	<body class="mainbody" onload="javascript:window_onload()">
		<h1><spring:message code='ezSchedule.ljeGs001' /></h1>
		<div class="schedule_list_date">
			<span class="date_arr date_prev" onClick="dateMove_onClick( '-1' )"></span>
			<span id="currDate"></span>
			<span class="date_arr date_next" onclick="dateMove_onClick( '1' )"></span>
		</div>
		<div class="schedule_group_info">
			<h2 id="groupName"></h2><span class="info_txt"><spring:message code='ezSchedule.ksy01'/></span>
		</div>
		<table class="nobox" style="width:100%;">
	    	<tr>
	       		<td>
	       			<div class="entry_wrap">
	         			<table>
	           				<tr>
	             				<td>
	             					<div class="entryDiv">
										<table class="entryList_bg"></table>	<!-- 테이블 배경 라인 -->
	                 					<table id="entryList" class="entryList">
											<tr>
												<th></th>
												<c:forEach var="num" begin="0" end="23" step="1">
													<th>
														<c:if test="${num eq 0}"><span>AM</span></c:if>
														<c:if test="${num eq 12}"><span>PM</span></c:if>
														${num}
													</th>
												</c:forEach>
											</tr>
	                   						<tr>
	                     						<td class="entry_name" id="" deptid=""></td>
	                     						<td class="entry_schedule" colspan="24">
	                        						<table style="border:0px; padding:0px; border-collapse:collapse; border-spacing:0px; width:100%;"  >
	                         							<tr>
															<c:forEach var="num" begin="0" end="48" step="1">
																<td style="height:16px;"></td>
															</c:forEach>
	                        							 </tr>
	                     							</table>
	                     						</td>
	                   						</tr>
	                 					</table>
	             					</div>
	             				</td>
	           				</tr>
	         			</table>
	       			</div>
	       		</td>
	     	</tr>
		</table>	
	</body>
</html>