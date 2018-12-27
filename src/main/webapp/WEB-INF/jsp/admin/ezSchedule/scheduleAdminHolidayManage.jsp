<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t4003' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezSchedule.e3', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript">		    
		    var userlang = "<c:out value='${primary}'/>";
		    var companylist = "<c:out value='${companyList}'/>"; //(ex. S907001,가온아이A;S907000,가온아이B;)
		    var lang = "<c:out value='${lang}'/>";
		    var holidayType = "<c:out value='${holidayType}'/>";
		    
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
			
		    window.onload = function () {
		        schedule_get_holiday();
		    }
	
		    function schedule_get_holiday() {
		    	_RowObject = null;
		    	var COMPANYID = "";
		    	if (holidayType == "a") {
		    		COMPANYID = document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value;
		    	} else {
		    		COMPANYID = "1";
		    	}
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : true,
		    		url : "/ezSchedule/scheduleGetHolidayJson.do",
		    		data : {
		    			COMPANYID  : COMPANYID,		    			
		    			holidayType : holidayType
		    		},
		    		success: function(result) {
		    			MakeSliderList(result);
		    		}	    		
		        });
		    }
	
		    function MakeSliderList(result) {
		        var _html = "";
		        
		        try {		            		            
		            var countValue = 0;
		            _html = "<table class='mainlist' style='width:100%;'>";
		            var HolidaySize = result.length;
		            if (HolidaySize > 0) {
		                if (CrossYN()) {
		                    for (var i = 0; i < HolidaySize; i++) {
		                        var _Value;
		                        var holidayID = result[i].holidayID;
		                        var holidayName = result[i].holidayName;
		                        var holidayName2 = result[i].holidayName2;
		                        var holidayDate = result[i].holidayDate;
		                        var isSolar = result[i].isSolar;
		                        var isRepeat = result[i].isRepeat;
		                        var isRest = result[i].isRest;
		                        var isUse = result[i].isUse;
		                        var useCompany = result[i].useCompany;
		                        _html += "<tr style='cursor:pointer' id = '" + holidayID
		                              + "'holidayname = '" + MakeXMLString(holidayName)
		                              + "'holidayname2 = '" + MakeXMLString(holidayName2)
		                              + "'date = '" + holidayDate.substring(0,10)
		                              + "'issolar = '" + isSolar
		                              + "'isrepeat = '" + isRepeat
		                              + "'isrest = '" + isRest
		                              + "'company = '" + useCompany
		                              + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>";
		                           
								
		                        if (isUse == "1") {
		                            _html += "<td style='width:5%;padding-left:5px;'><input  type='checkbox' checked = true onclick='event_statuschange(this);'></td>";
		                        } else {
		                            _html += "<td style='width:5%;padding-left:5px;'><input type='checkbox' onclick='event_statuschange(this);'></td>";
		                        }
	
		                        if (userlang == "1") {
		                            _html += "<td style='width:30%;color:gray;'>" + MakeXMLString(holidayName) + "</td>";
		                        } else {
		                            _html += "<td style='width:30%;color:gray;'>" + MakeXMLString(holidayName2) + "</td>";
		                        }
	
		                        if (isSolar == "1") {
		                            _html += "<td style='width:15%;color:gray;' class='onlyUseKo'>" + "<spring:message code='ezSchedule.t4000' />" + "</td>";
		                        } else {
		                            _html += "<td style='width:15%;color:gray;' class='onlyUseKo'>" + "<spring:message code='ezSchedule.t101' />" + "</td>";
		                        }
								
	                        	_html += "<td style='width:15%;color:gray;'>" + holidayDate.substring(0, 10) + "</td>";
	
		                        if (isRepeat == "1") {
		                            _html += "<td style='width:10%;color:gray;'>Y</td>";
		                        } else {
		                            _html += "<td style='width:10%;color:gray;'>N</td>";
		                        } 
	
		                        if (isRest == "1") {
		                            _html += "<td style='width:10%;color:gray;'>Y</td>";
		                        } else {
		                            _html += "<td style='width:10%;color:gray;'>N</td>";
		                        }
								if (holidayType == 'a') {
			                        if (useCompany == "1") {
			                            _html += "<td style='width:15%;color:gray;'>" + "<spring:message code='ezSchedule.t2001' />" + "</td>";
			                        } else {
			                            var companyname = "";                           
			                            var tempcompanylist = companylist.split(";");
			                            for (var j = 0; j < tempcompanylist.length - 1; j++) {
			                                if (useCompany == tempcompanylist[j].split(",")[0]) { // [0]아이디
			                                    companyname = tempcompanylist[j].split(",")[1]; // [1]이름
			                                }
			                            }
			                            _html += "<td style='width:15%;color:gray;'>" + companyname + "</td>";
			                        }
								}
	
		                        _html += "</tr>";
		                        _html += "</html>";
		                        document.getElementById("contentlist").innerHTML = _html;
		                    }
		                } else {
		                    for (var i = 0; i < HolidaySize; i++) {
		                        var _Value;
		                        var holidayID = result[i].holidayID;
		                        var holidayName = result[i].holidayName;
		                        var holidayName2 = result[i].holidayName2;
		                        var holidayDate = result[i].holidayDate;
		                        var isSolar = result[i].isSolar;
		                        var isRepeat = result[i].isRepeat;
		                        var isRest = result[i].isRest;
		                        var isUse = result[i].isUse;
		                        var useCompany = result[i].useCompany;
		                        _html += "<tr style='cursor:pointer' id = '" + holidayID
		                              + "'holidayname = '" + MakeXMLString(holidayName)
		                              + "'holidayname2 = '" + MakeXMLString(holidayName2)
		                              + "'date = '" + holidayDate.substring(0,10)
		                              + "'issolar = '" + isSolar
		                              + "'isrepeat = '" + isRepeat
		                              + "'isrest = '" + isRest
		                              + "'company = '" + useCompany
		                              + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>";
	
		                        if (isUse == "1") {
		                            _html += "<td style='width:5%;padding-left:5px;'><input  type='checkbox' checked = true onclick='event_statuschange(this);'></td>";
		                        } else {
		                            _html += "<td style='width:5%;padding-left:5px;'><input type='checkbox' onclick='event_statuschange(this);'></td>";
		                        }
	
		                        if (userlang == "1") {
		                            _html += "<td style='width:30%;color:gray;'>" + MakeXMLString(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].text) + "</td>";
		                        } else {
		                            _html += "<td style='width:30%;color:gray;'>" + MakeXMLString(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].text) + "</td>";
		                        }
	
		                        if (isSolar == "1") {
		                            _html += "<td style='width:15%;color:gray;' class='onlyUseKo'>" + "<spring:message code='ezSchedule.t4000' />" + "</td>";
		                        	
		                        } else {
		                            _html += "<td style='width:15%;color:gray;' class='onlyUseKo'>" + "<spring:message code='ezSchedule.t101' />" + "</td>";
		                        }
								
		                        _html += "<td style='width:15%;color:gray;'>" + holidayDate.substring(0, 10) + "</td>";
	
		                        if (isRepeat == "1") {
		                            _html += "<td style='width:10%;color:gray;'>Y</td>";
		                        } else {
		                            _html += "<td style='width:10%;color:gray;'>N</td>";
		                        }
	
		                        if (isRest == "1") {
		                            _html += "<td style='width:10%;color:gray;'>Y</td>";
		                        } else {
		                            _html += "<td style='width:10%;color:gray;'>N</td>";
		                        }
		                        
		                        if (holidayType == 'a') {
			                        if (useCompany == "1") {
			                            _html += "<td style='width:15%;color:gray;'>" + "<spring:message code='ezSchedule.t2001' />" + "</td>";
			                        } else {
			                            var companyname = "";
			                            var tempcompanylist = companylist.split(";");
			                            for (var j = 0; j < tempcompanylist.length - 1; j++) {
			                                if (useCompany == tempcompanylist[j].split(",")[1])
			                                    companyname = tempcompanylist[j].split(",")[0];
			                            }
			                            _html += "<td style='width:15%;color:gray;'>" + companyname + "</td>";
			                        }
		                        }
		                        
		                        _html += "</tr>";
		                        _html += "</html>";
		                        document.getElementById("contentlist").innerHTML = _html;
		                    }	                    
		                }
		            } else {
		                document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'> " + strLang263 + "</td></tr></table>";
		            }	
		        } catch (e) {
		        	alert(e.message);
		            document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'>" + strLang263 + "</td></tr></table>";
		        }
		      	//음력 양력 숨기기
		        if (lang != "1")
	            	$(".onlyUseKo").css("display", "none");
		    }
	
		    function event_Mover(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(1).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(2).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(3).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(4).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(5).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(6).style.backgroundColor = "#EDEDED";
		        }
		    }
		    function event_Mout(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(1).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(2).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(3).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(4).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(5).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(6).style.backgroundColor = "#FFFFFF";
		        }
		    }
		    var _RowObject = null;
		    function event_click(obj) {
		        if (_RowObject != null) {
		            _RowObject.childNodes.item(0).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(1).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(2).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(3).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(4).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(5).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(6).style.backgroundColor = "#ffffff";
		        }
	
		        _RowObject = obj;
		        obj.childNodes.item(0).style.backgroundColor = "#f1f8ff";
		        obj.childNodes.item(1).style.backgroundColor = "#f1f8ff";
		        obj.childNodes.item(2).style.backgroundColor = "#f1f8ff";
		        obj.childNodes.item(3).style.backgroundColor = "#f1f8ff";
		        obj.childNodes.item(4).style.backgroundColor = "#f1f8ff";
		        obj.childNodes.item(5).style.backgroundColor = "#f1f8ff";
		        obj.childNodes.item(6).style.backgroundColor = "#f1f8ff";
		    }
	
	
		    function add_holiday() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 280) / 2;
		        var pLeft = (pwidth - 450) / 2;
		        
		        if (holidayType == 'a') {
			        window.open("/admin/ezSchedule/scheduleAdminPopupHoliday.do?holidayType="+holidayType+"&company="+document.getElementById('ListCompany')[document.getElementById('ListCompany').selectedIndex].value,"", "height = 290px, width = 460px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no");
		        } else {
		            window.open("/admin/ezSchedule/scheduleAdminPopupHoliday.do?holidayType="+holidayType,"", "height = 290px, width = 460px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no"); 	
		        }
		    }
	
		    function event_dbclick() {
		        if (_RowObject == null) {
		            alert("<spring:message code='ezSchedule.t4001' />");
		            return;
		        }
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 280) / 2;
		        var pLeft = (pwidth - 450) / 2;
	
		        var id = _RowObject.id;
		        var holidayname = _RowObject.getAttribute("holidayname");
		        var holidayname2 = _RowObject.getAttribute("holidayname2");
		        var holidaydate = _RowObject.getAttribute("date");
		        var issolar = _RowObject.getAttribute("issolar");
		        var isrepeat = _RowObject.getAttribute("isrepeat");
		        var isrest = _RowObject.getAttribute("isrest");
		        var company = _RowObject.getAttribute("company");
	
		        window.open("/admin/ezSchedule/scheduleAdminPopupHoliday.do?id=" + id + "&name=" + encodeURIComponent(holidayname) + "&name2=" + encodeURIComponent(holidayname2) + "&date=" + holidaydate + "&isSolar=" + issolar + "&isRepeat=" + isrepeat + "&isRest=" + isrest + "&company=" + company + "&holidayType="+holidayType
		            , "", "height = 290px, width = 460px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no");
		    }
	
		    function del_holiday() {
		        if (_RowObject == null) {
		        	alert("<spring:message code='ezSchedule.t4001' />");
		            return;
		        }
		        // 2018-07-24 천성준 - 삭제 시, 한번더 체크할수 있게
		        var holidayName = _RowObject.getAttribute("holidayname");
		        if (confirm(holidayName + " <spring:message code='ezBoard.t117' />")) {
			        $.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/admin/ezSchedule/scheduleDelHoliday.do",
			    		data : {
			    			holidayID  : _RowObject.id		    			
			    		},
			    		success: function() {
			    			alert("<spring:message code='ezSchedule.t4002' />");
				            schedule_get_holiday();
			    		},
			    		error: function(err) {
			    			alert(strLang86);
			    		}
			        });
		        }
		    }
	
		    function event_statuschange(obj) {
		        var isuse = obj.checked;
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezSchedule/scheduleChangeHolidayUse.do",
		    		data : {
		    			holidayID  : obj.parentElement.parentElement.id,
		    			isUse : (isuse ? "1" : "0")
		    		},		    		
		    		error: function(err) {
		    			alert(strLang86);
		    		}
		        });
		    }
		    
		    function getMonthString(cnt) {					
		        var rtnString = "";
		        switch (cnt) {				
		    		case 1:
		    			rtnString = strLang67;
		    			break;
		    		case 2:
		    			rtnString = strLang68;
		    			break;
		    		case 3:
		    			rtnString = strLang69;
		    			break;
		    		case 4:
		    			rtnString = strLang70;
		    			break;
		    		case 5:
		    			rtnString = strLang71;
		    			break;
		    		case 6:
		    			rtnString = strLang72;
		    			break;	
		    		case 7:
		    		    rtnString = strLang73;
		    		    break;	
		    		case 8:
		    		    rtnString = strLang74;
		    		    break;	
		    		case 9:
		    		    rtnString = strLang75;
		    		    break;	
		    		case 10:
		    		    rtnString = strLang76;
		    		    break;	
		    		case 11:
		    		    rtnString = strLang77;
		    		    break;	
		    		case 12:
		    		    rtnString = strLang78;
		    		    break;	
		    	}
		    	return rtnString;
		    }
		    
		    function getFullDaystring(cnt) {
		        var rtnString = "";
		        switch (cnt) {
		    		case 0:
		    			rtnString = strLang60;
		    			break;
		    		case 1:
		    			rtnString = strLang61;
		    			break;
		    		case 2:
		    			rtnString = strLang62;
		    			break;
		    		case 3:
		    			rtnString = strLang63;
		    			break;
		    		case 4:
		    			rtnString = strLang64;
		    			break;
		    		case 5:
		    			rtnString = strLang65;
		    			break;
		    		case 6:
		    			rtnString = strLang66;
		    			break;	
		    	}
		    	return rtnString;
		    }
		    
		    function getOdinalString(cnt) {			
		        var rtnString = "";
		        switch (cnt) {					
		    		case 1:
		    			rtnString = strLang55;
		    			break;
		    		case 2:
		    			rtnString = strLang56;
		    			break;
		    		case 3:
		    			rtnString = strLang57;
		    			break;
		    		case 4:
		    			rtnString = strLang58;
		    			break;
		    		case 5:
		    			rtnString = strLang59;
		    			break;					
		    	}
		    	return rtnString;
		    }
		</script>
	</head>
	<body class="mainbody"> 
		<%-- <h1><spring:message code='ezSchedule.t4003' /></h1> --%>
		<form id="Form1" method="post">
		<br>
			<div id="mainmenu">
				<c:if test="${holidayType eq 'a'}">
		       		<span><b><spring:message code='ezResource.t28' /> : </b></span>
		            <select id="ListCompany" onchange="schedule_get_holiday()">
		            	<c:forEach var="item" items="${list}">
            				<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
           				</c:forEach>
		            </select>
				</c:if>
			    <ul style="margin-top: 15px;">
			        <li class="important"><span onClick="add_holiday()"><spring:message code='ezSchedule.t4004' /></span></li>
			        <li><span onClick="event_dbclick()"><spring:message code='ezSchedule.t4005' /></span></li>
			        <li><span class="icon16 icon16_delete" onClick="del_holiday()"></span></li>			        
			    </ul>
			</div>
			<table style="width: 750px; height: 500px;" border="0">
		        <tr>
		            <td>
		                <div style="border: 1px solid #dbdbda; border-top:0px; width: 750px; height: 500px;">
		                    <table class="mainlist" style="width: 100%;">
		                        <tr>
		                            <th style="width: 5%;"><span><spring:message code='ezSchedule.t403' /></span></th>
		                            <th style="width: 30%;"><span><spring:message code='ezSchedule.t9990003' /></span></th>
		                            <th style="width: 15%;" class="onlyUseKo"><span><spring:message code='ezSchedule.t4000' />/<spring:message code='ezSchedule.t101' /></span></th>
		                            <th style="width: 15%;"><span><spring:message code='ezSchedule.t4008' /></span></th>
		                            <th style="width: 10%;"><span><spring:message code='ezSchedule.t4007' /></span></th>
		                            <th style="width: 10%;"><span><spring:message code='ezSchedule.t4009' /></span></th>
		                            <c:if test="${holidayType eq 'a'}">
			                            <th style="width: 15%;"><span><spring:message code='ezSchedule.t2000' /></span></th>
		                            </c:if>
		                        </tr>
		                    </table>
		                    <div id="contentlist" name="contentlist" style="height: 468px; overflow-y: auto;">
		                        <table class="mainlist" style="width: 100%;">
		                            <tr>
		                                <td style="text-align: center;">
		                                    <img src="/images/email/progress_img.gif" />
		                                </td>
		                            </tr>
		                        </table>
		                    </div>
		                </div>
		            </td>
		        </tr>
		    </table>
			<script type="text/javascript">
			    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
		</form>
	</body>
</html>

