<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>left_community</title>
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
	    <link rel="stylesheet" href="/css/ezSchedule/Calendar_cross.css" type="text/css" />
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/Holiday.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/address_tree_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/Controls/treeview.htc.js"></script>
	    <script type="text/javascript" src="/js/ezSchedule/Calendar/CalendarMini_Cross.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>

	    <script type="text/javascript">
	        var _funCode = "<c:out value='${funCode}'/>";
	        var _subCode = "<c:out value='${subCode}'/>";
	        var defaultView = "<c:out value='${defaultView}'/>";
	        var pStartday = "<c:out value='${startDay}'/>";
	        var xmlDom_treeview = createXmlDom();	        
	        var ch_selected = false;
			var totalCnt = 0;						
				   	    
		    function schedule_get_holiday() {
		        $.ajax({
		    		type : "POST",
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
			            CalendarMiniDataSource();
		    		}
		    	});
		    }
	
	        document.onselectstart = function () { return false; };
	        window.onload = function () {
	            if (pStartday == 1)
	                DefaultView = 1
	            else
	                DefaultView = 0
	            CalendarMiniView("CalendarMini");

	            schedule_get_holiday();

	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }

	            if ("WEB" == _subCode) {
	                if ("3" == _funCode) {
	                    WebPartToggle(level1El.item(1));
	                }
	            }
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                if ("1" == _funCode) {
	                    document.getElementById('SancList').parentElement.onclick();
	                    document.getElementById('SancList').onclick();
	                }
	                if ("2" == _funCode) {
	                    document.getElementById('Schedule_Main').parentElement.onclick();
	                    document.getElementById('Schedule_Main').onclick();
	                }
	                else if ("6" == _funCode) {
	                    document.getElementById('Schedule_Search').parentElement.onclick();
	                    document.getElementById('Schedule_Search').onclick();
	                }
	                else if ("10" == _funCode) {
	                    document.getElementById('Schedule_Public_Search').parentElement.onclick();
	                    document.getElementById('Schedule_Public_Search').onclick();
	                }
	                else if ("3" == _funCode) {
	                    document.getElementById('Task').parentElement.onclick();
	                    document.getElementById('Task').onclick();
	                }
	                else if ("7" == _funCode) {
	                    document.getElementById('Task').parentElement.onclick();
	                    document.getElementById('Task').onclick();
	                    document.getElementById('Task_Search').parentElement.onclick();
	                    document.getElementById('Task_Search').onclick();
	                }
	                else if ("4" == _funCode) {
	                    document.getElementById('Address_Main').parentElement.onclick();
	                    document.getElementById('Address_Main').onclick();
	                }
	                else if ("8" == _funCode) {
	                    document.getElementById('Address_Main').parentElement.onclick();
	                    document.getElementById('Address_Main').onclick();
	                    document.getElementById('Address_Search').parentElement.onclick();
	                    document.getElementById('Address_Search').onclick();
	                }
	            }
	            else {
	                if ("1" == _funCode) {
	                    document.getElementById('SancList').click();
	                }
	                if ("2" == _funCode) {
	                    document.getElementById('Schedule_Main').click();
	                }
	                else if ("6" == _funCode) {
	                    document.getElementById('Schedule_Search').click();
	                }
	                else if ("10" == _funCode) {
	                    document.getElementById('Schedule_Public_Search').click();
	                }
	                else if ("3" == _funCode) {
	                    document.getElementById('Task').click();
	                }
	                else if ("7" == _funCode) {
	                    document.getElementById('Task').click();
	                    document.getElementById('Task_Search').click();
	                }
	                else if ("4" == _funCode) {
	                    document.getElementById('Address_Main').click();
	                }
	                else if ("8" == _funCode) {
	                    document.getElementById('Address_Main').click();
	                    document.getElementById('Address_Search').click();
	                }
	            }
	        }
	        function skinChange(v_data) {
	            if (v_data == "2") {
	                document.getElementById("pims1").style.display = "block";
	                document.getElementById("pims2").style.display = "none";
	                document.getElementById("pims3").style.display = "none";
	            }
	            else if (v_data == "4") {
	                document.getElementById("pims1").style.display = "none";
	                document.getElementById("pims2").style.display = "block";
	                document.getElementById("pims3").style.display = "none";
	            }
	            else if (v_data == "3") {
	                document.getElementById("pims1").style.display = "none";
	                document.getElementById("pims2").style.display = "block";
	                document.getElementById("pims3").style.display = "none";
	            }
	            else {
	                document.getElementById("pims1").style.display = "none";
	                document.getElementById("pims2").style.display = "none";
	                document.getElementById("pims3").style.display = "block";
	            }
	        }
	        
		    function Function_Flag(v_data, subfolder) {
		        skinChange(v_data);

		        v_data = parseInt(v_data);
		        _funCode = v_data;

		        switch (v_data) {
		            case 2:		// Schedule
		                window.open("/ezSchedule/scheduleMain.do?funCode=2", "right");
		                break;

		            case 3:		// Task
		                window.open("/ezSchedule/scheduleMain.do?funCode=3", "right");
		                break;

		            case 5:		// schedule group management 
		                window.open("/ezSchedule/scheduleManageGroup.do", "right")
		                break;

		            case 6:		// schedule search
		                window.open("/ezSchedule/scheduleSearch.do", "right")
		                break;

		            case 7:		// Search Task
		                window.open("/myoffice/ezTask/task_search_Cross.aspx", "right");
		                break;

		            case 10:	// Search public search
		                window.open("/ezSchedule/schedulePublicSearch.do", "right");
		                break;
		            case 11:		// Search public calendar
		                window.open("/ezSchedule/scheduleConfigMain.do", "right");
		                break;
		        }
		    }		   
		
	        function WebPartToggle(obj) {
	            if (obj.listNum && currentListNum != obj.listNum + 1) {
	                level1El.item(currentListNum - 1).className = null;
	                level2El.item(currentListNum - 1).className = "off";
	            }

	            if (level2El.item(obj.listNum).className == "on") {
	                level1El.item(obj.listNum).className = null;
	                level2El.item(obj.listNum).className = "off";
	            }
	            else {
	                level1El.item(obj.listNum).className = "on";
	                level2El.item(obj.listNum).className = "on";
	            }

	            currentListNum = obj.listNum + 1;

	            setMenu(level2El.item(obj.listNum));
	        }		       

	        function MonthMiniDbClick(obj) {
	            if (_funCode == 2)
	                parent.frames["right"].WriteDateSchedule_left(obj)
	        }
           
		</script>
	
	</head>

	<body class="leftbody">	    
        <div class="left_pims" title="PIMS"></div>
        <div id="CalendarMini" style=" margin:10px;"></div>
	        
	    <div id="left">
	        <div class="left_pims1" title="<spring:message code='ezSchedule.t1010'/>" id='pims1'></div>
		    <div class="left_pims2" title="<spring:message code='ezSchedule.t1017'/>" id='pims2' style="display:none"></div>
		    <div class="left_pims3" title="<spring:message code='ezSchedule.t1011'/>" id='pims3' style="display:none"></div>
			<div class="gray_line"></div>	
		    <h2><span id='Schedule' onClick="Function_Flag(2)" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1010'/></span></h2>		    
		    <ul>
			    <li evt="0"><span id='Schedule_Main' onClick="Function_Flag(2)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1010'/></span></li>
	            <li evt="0"><span id='Schedule_Group' onClick="Function_Flag(5)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t252'/></span></li>
			    <li evt="0"><span id='Schedule_Search' onClick="Function_Flag(6)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1018'/></span></li>
			    <li evt="0"><span id='Schedule_Public_Search' onClick="Function_Flag(10)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1021'/></span></li>
		    </ul> 
		    <%-- <h2><span id='Task' onClick="Function_Flag(3)" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1011'/></span></h2>
		    <ul>
			    <li><span id='Task_Main' onClick="Function_Flag(3)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1011'/></span></li>
			    <li><span id='Task_Search' onClick="Function_Flag(7)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1019'/></span></li>
		    </ul> --%>
	        <h3><span  onClick="Function_Flag('11')" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1012'/></span></h3>
		</div>		
	    <script type="text/javascript">
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    
	</body>
</html>