<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t4003' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">		    
		    var userlang = "<c:out value='${primary}'/>";
		    var companylist = "${companyList}";
		    
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
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezSchedule/scheduleGetHoliday.do",
		    		data : {
		    			COMPANYID  : document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value		    			
		    		},
		    		success: function(text) {
		    			MakeSliderList(text);
		    		}	    		
		        });
		    }
	
		    function MakeSliderList(text) {
		        var _html = "";
		        
		        try {		            		            
		            var XmlNodeText = text;
		            var XmlNode = loadXMLString(XmlNodeText);
		            var countValue = 0;
		            _html = "<table class='mainlist' style='width:100%;'>";
		            
		            if (SelectNodes(XmlNode, "DATA/ROW").length > 0) {
		                if (CrossYN()) {
		                    for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
		                        var _Value;
		                        _html += "<tr id = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYID")[0].textContent
		                              + "'holidayname = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent
		                              + "'holidayname2 = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent
		                              + "'date = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0,10)
		                              + "'issolar = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].textContent
		                              + "'isrepeat = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].textContent
		                              + "'isrest = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].textContent
		                              + "'company = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "USECOMPANY")[0].textContent
		                              + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>";
	
		                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].textContent == "1")
		                            _html += "<td style='width:5%;padding-left:5px;'><input  type='checkbox' checked = true onclick='event_statuschange(this);'></td>";
		                        else
		                            _html += "<td style='width:5%;padding-left:5px;'><input type='checkbox' onclick='event_statuschange(this);'></td>";
	
		                        if (userlang == "1")
		                            _html += "<td style='width:30%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent + "</td>";
		                        else
		                            _html += "<td style='width:30%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent + "</td>";
	
		                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].textContent == "1")
		                            _html += "<td style='width:15%;color:gray;'>" + "<spring:message code='ezSchedule.t4000' />" + "</td>";
		                        else
		                            _html += "<td style='width:15%;color:gray;'>" + "<spring:message code='ezSchedule.t101' />" + "</td>";
	
		                        _html += "<td style='width:15%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10) + "</td>";
	
		                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].textContent == "1")
		                            _html += "<td style='width:10%;color:gray;'>Y</td>";
		                        else
		                            _html += "<td style='width:10%;color:gray;'>N</td>";
	
		                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].textContent == "1")
		                            _html += "<td style='width:10%;color:gray;'>Y</td>";
		                        else
		                            _html += "<td style='width:10%;color:gray;'>N</td>";
	
		                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "USECOMPANY")[0].textContent == "1")
		                            _html += "<td style='width:15%;color:gray;'>" + "<spring:message code='ezSchedule.t2001' />" + "</td>";
		                        else {
		                            var companyname = "";                           
		                            var tempcompanylist = companylist.split(";");
		                            for (var j = 0; j < tempcompanylist.length - 1; j++) {
		                                if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "USECOMPANY")[0].textContent == tempcompanylist[j].split(",")[0])
		                                    companyname = tempcompanylist[j].split(",")[1];
		                            }
		                            _html += "<td style='width:15%;color:gray;'>" + companyname + "</td>";
		                        }
	
		                        _html += "</tr>";
		                        _html += "</html>";
		                        document.getElementById("contentlist").innerHTML = _html;
		                    }
		                } else {
		                    for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
		                        var _Value;
		                        _html += "<tr id = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYID")[0].text
		                              + "'holidayname = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].text
		                              + "'holidayname2 = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].text
		                              + "'date = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].text.substring(0, 10)
		                              + "'issolar = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].text
		                              + "'isrepeat = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].text
		                              + "'isrest = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].text
		                              + "'company = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "USECOMPANY")[0].text
		                              + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>";
	
		                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].text == "1")
		                            _html += "<td style='width:5%;padding-left:5px;'><input  type='checkbox' checked = true onclick='event_statuschange(this);'></td>";
		                        else
		                            _html += "<td style='width:5%;padding-left:5px;'><input type='checkbox' onclick='event_statuschange(this);'></td>";
	
		                        if (userlang == "1")
		                            _html += "<td style='width:30%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].text + "</td>";
		                        else
		                            _html += "<td style='width:30%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].text + "</td>";
	
		                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].text == "1")
		                            _html += "<td style='width:15%;color:gray;'>" + "<spring:message code='ezSchedule.t4000' />" + "</td>";
		                        else
		                            _html += "<td style='width:15%;color:gray;'>" + "<spring:message code='ezSchedule.t101' />" + "</td>";
	
		                        _html += "<td style='width:15%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].text.substring(0, 10) + "</td>";
	
		                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].text == "1")
		                            _html += "<td style='width:10%;color:gray;'>Y</td>";
		                        else
		                            _html += "<td style='width:10%;color:gray;'>N</td>";
	
		                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].text == "1")
		                            _html += "<td style='width:10%;color:gray;'>Y</td>";
		                        else
		                            _html += "<td style='width:10%;color:gray;'>N</td>";
		                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "USECOMPANY")[0].text == "1")
		                            _html += "<td style='width:15%;color:gray;'>" + "<spring:message code='ezSchedule.t2001' />" + "</td>";
		                        else {
		                            var companyname = "";
		                            var tempcompanylist = companylist.split(";");
		                            for (var j = 0; j < tempcompanylist.length - 1; j++) {
		                                if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "USECOMPANY")[0].text == tempcompanylist[j].split(",")[1])
		                                    companyname = tempcompanylist[j].split(",")[0];
		                            }
		                            _html += "<td style='width:15%;color:gray;'>" + companyname + "</td>";
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
		            document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'>" + strLang263 + "</td></tr></table>";
		        }
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
		        obj.childNodes.item(0).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(1).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(2).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(3).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(4).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(5).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(6).style.backgroundColor = "#DBE1E7";
		    }
	
	
		    function add_holiday() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 280) / 2;
		        var pLeft = (pwidth - 450) / 2;
		        window.open("/admin/ezSchedule/scheduleAdminPopupHoliday.do?company="+document.getElementById('ListCompany')[document.getElementById('ListCompany').selectedIndex].value,"", "height = 280px, width = 450px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no");
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
	
		        window.open("/admin/ezSchedule/scheduleAdminPopupHoliday.do?id=" + id + "&name=" + encodeURIComponent(holidayname) + "&name2=" + encodeURIComponent(holidayname2) + "&date=" + holidaydate + "&isSolar=" + issolar + "&isRepeat=" + isrepeat + "&isRest=" + isrest + "&company=" + company
		            , "", "height = 280px, width = 450px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no");
		    }
	
		    function del_holiday() {
		        if (_RowObject == null) {
		        	alert("<spring:message code='ezSchedule.t4001' />");
		            return;
		        }
		        
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
		</script>
	</head>
	<body class="mainbody"> 
		<h1><spring:message code='ezSchedule.t4003' /></h1>
		<form id="Form1" method="post">
			<div id="mainmenu">
				<ul>
			        <li style="background:none;padding-top:4px;height:24px">
			            <select id="ListCompany" onchange="schedule_get_holiday()">${companySel}</select>
			        </li>
			    </ul>
			    <ul style="margin-left:3px">
			        <li><span onClick="add_holiday()"><spring:message code='ezSchedule.t4004' /></span></li>
			        <li><span onClick="event_dbclick()"><spring:message code='ezSchedule.t4005' /></span></li>
			        <li><span onClick="del_holiday()"><spring:message code='ezSchedule.t4006' /></span></li>			        
			    </ul>
			</div>
			<br />
			<table style="width: 750px; height: 385px;" border="0">
		        <tr>
		            <td>
		                <div style="border: 1px solid #dbdbda; border-top:0px; width: 750px; height: 385px;">
		                    <table class="mainlist" style="width: 100%;">
		                        <tr>
		                            <th style="width: 5%;"><span><spring:message code='ezSchedule.t403' /></span></th>
		                            <th style="width: 30%;"><span><spring:message code='ezSchedule.t9990003' /></span></th>
		                            <th style="width: 15%;"><span><spring:message code='ezSchedule.t4000' />/<spring:message code='ezSchedule.t101' /></span></th>
		                            <th style="width: 15%;"><span><spring:message code='ezSchedule.t4008' /></span></th>
		                            <th style="width: 10%;"><span><spring:message code='ezSchedule.t4007' /></span></th>
		                            <th style="width: 10%;"><span><spring:message code='ezSchedule.t4009' /></span></th>
		                            <th style="width: 15%;"><span><spring:message code='ezSchedule.t2000' /></span></th>
		                        </tr>
		                    </table>
		                    <div id="contentlist" name="contentlist" style="height: 365px; overflow-y: auto;">
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

