<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>left_community</title>
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
	    <link rel="stylesheet" href="/css/ezSchedule/Calendar_cross.css" type="text/css" />
		<script type="text/javascript" src="/js/Holiday.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/address_tree_Cross.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/ezAddress/Controls/treeview.htc.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezSchedule/Calendar/CalendarMini_Cross.js?version=1.5"></script>
	    <script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>

	    <script type="text/javascript">
	        var _funCode = "<c:out value='${funCode}'/>";
	        var _subCode = "<c:out value='${subCode}'/>";
	        var defaultView = "<c:out value='${defaultView}'/>";
	        var pStartday = "<c:out value='${startDay}'/>";
	        var xmlDom_treeview = createXmlDom();
	        var xmlhttp = createXMLHttpRequest();
	        var ch_selected = false;
			var totalCnt = 0;
			var xmlhttp;
			var xmlhttp2;

	   	    var xmlhttp2 = createXMLHttpRequest();
		    function schedule_get_holiday() {
		        xmlhttp2 = createXMLHttpRequest();
		        var xmlDom = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "COMPANYID", "VIEW");
	
		        xmlhttp2.open("POST", "/ezSchedule/scheduleGetHoliday.do", true);
		        xmlhttp2.onreadystatechange = event_schedule_get_holiday;
		        xmlhttp2.send(xmlDom);
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
		            xmlhttp2 = null;
		            CalendarMiniDataSource();
		        }
		    }
	

	        document.onselectstart = function () { return false; };
	        window.onload = function () {
	            CalendarMiniView("CalendarMini");
	            schedule_get_holiday();
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            if (pStartday == 1)
	                DefaultView = 1
	            else
	                DefaultView = 0

//	            CalendarMiniView("CalendarMini");

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
	        var xmlHttpAddressTree;
	        function get_Address_FullTree() {
	            xmlHttpAddressTree = createXMLHttpRequest();
	            xmlHttpAddressTree.open("POST", "/myoffice/ezAddress/remote/address_get_fulltree.aspx", true);
	            xmlHttpAddressTree.onreadystatechange = get_Address_FullTree_Complete;
	            xmlHttpAddressTree.send();
	        }
	        function get_Address_FullTree_Complete() {
	            if (xmlHttpAddressTree != null && xmlHttpAddressTree.readyState == 4) {
	                if (xmlHttpAddressTree.status >= 200 && xmlHttpAddressTree.status < 300) {
	                    var IDNodes = xmlHttpAddressTree.responseXML.getElementsByTagName("FOLDERID");
	                    var ChangeKeyNodes = xmlHttpAddressTree.responseXML.getElementsByTagName("CHANGEKEY");
	                    var OwnerNodes = xmlHttpAddressTree.responseXML.getElementsByTagName("OWNERID");
	                    var TypeNodes = xmlHttpAddressTree.responseXML.getElementsByTagName("FOLDERTYPE");
	                    var NameNodes = xmlHttpAddressTree.responseXML.getElementsByTagName("FOLDERNAME");
	                    var ChildNodes = xmlHttpAddressTree.responseXML.getElementsByTagName("CHILDCOUNT");
	                    xmlHTTP = null;

	                    var childXML = "<tree><nodes>";

	                    for (var i = 0; i < NameNodes.length; i++) {
	                        var strFolderName = NameNodes[i].firstChild.nodeValue;

	                        childXML += "<node imgidx='1' caption=\"";

	                        if (strFolderName == "1") {
	                            childXML += ('<spring:message code='ezSchedule.t1014'/>' + "\" ");
	                        }
	                        else if (strFolderName == "2") {
	                            childXML += ('<spring:message code='ezSchedule.t1015'/>' + "\" ");
	                        }
	                        else {
	                            childXML += ('<spring:message code='ezSchedule.t1016'/>' + "\" ");
	                        }

	                        childXML += ("OWNERID=\"" + MakeRightField(OwnerNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("TYPE=\"" + MakeRightField(TypeNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("FOLDERID=\"" + MakeRightField(IDNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("CHANGEKEY=\"" + MakeRightField(ChangeKeyNodes[i].firstChild.nodeValue) + "\" ");

	                        if (ChildNodes[i].firstChild.nodeValue != "0")
	                            childXML += "hassub='1' ";

	                        childXML += "/>";
	                    }

	                    childXML += "</nodes></tree>";
	                    LoadTreeComplete(childXML);
	                }
	            }

	        }
	        function LoadTreeComplete(childXML) {
	            AddressTreeView.source(childXML);
	            AddressTreeView.update();
	            //AddressTreeView.toggle(1);//로딩이슈

	            if (AddressTreeView.selectedIndex() == -1) {
	                AddressTreeView.select(1);
	            }
	        }
		    var AddressTreeView = null;
		    function LoadAddressTree() {
		        if (AddressTreeView == null) {
		            AddressTreeView = new TreeView('AddressTreeView', 'AddressTreeView');

		            AddressTreeView.attachEvent('requestdata', requestdata);
		            AddressTreeView.attachEvent('nodeselect', selectnode);
		            AddressTreeView.attachEvent('nodedblclick', function () { AddressTreeView.toggle(AddressTreeView.selectedIndex()) });
		        }

		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/myoffice/common/organtree_config2.xml", false);
		        xmlHTTP.send();

		        var treeconfig;
		        if (navigator.userAgent.indexOf('MSIE') == -1) {
		            treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
		        }
		        else {
		            treeconfig = new ActiveXObject("Microsoft.XMLDOM");
		            treeconfig.async = false;
		            treeconfig.loadXML(xmlHTTP.responseText);
		        }

		        AddressTreeView.config(treeconfig);
		        get_Address_FullTree();
		    }
		
		    function requestdata(event) {
		        if (!event) {
		            event = window.event;
		        }

		        var nodeIdx = event.nodeIdx;

		        if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
		            nodeIdx = arguments[0].nodeIdx;
		        }

		        var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "FOLDERID"), AddressTreeView.getvalue(nodeIdx, "OWNERID"), AddressTreeView.getvalue(nodeIdx, "TYPE"))
		        AddressTreeView.putchildxml(nodeIdx, childxml);
		    }
		
		    function selectnode() {
		        var nodeIdx = AddressTreeView.selectedIndex();
		        var url = "/myoffice/ezAddress/address_list_Cross.aspx?folderid=" + encodeURIComponent(AddressTreeView.getvalue(nodeIdx, "FOLDERID")) + "&ownerid=" + escape(AddressTreeView.getvalue(nodeIdx, "OWNERID")) + "&type=" + escape(AddressTreeView.getvalue(nodeIdx, "TYPE"));

		        window.open(url, "right");
		    }

		    function address_foldermanage() {
		        var ret;
		        ret = showModalDialog("/myoffice/ezAddress/address_foldermanage_Cross.aspx", null, "dialogHeight:380px; dialogWidth:320px; status:no; help:no; scroll:no; edge:sunken");
		        if (ret == 1) LoadAddressTree();
		    }
		
		    function Function_Flag(v_data, subfolder) {
		        skinChange(v_data);

		        v_data = parseInt(v_data);
		        _funCode = v_data;

		        switch (v_data) {
		            case 2:		// Schedule
		                window.open("/myoffice/ezSchedule/schedule_main_Cross.aspx", "right");
		                break;

		            case 3:		// Task
		                window.open("/myoffice/ezTask/task_main_Cross.aspx", "right")
		                break;

		            case 4:		// Adress
		                LoadAddressTree();
		                break;

		            case 5:		// Adress
		                window.open("/myoffice/ezSchedule/schedule_manage_group.aspx", "right")
		                break;

		            case 6:		// Search calendar
		                window.open("/myoffice/ezSchedule/schedule_search_Cross.aspx", "right")
		                break;

		            case 7:		// Search Task
		                window.open("/myoffice/ezTask/task_search_Cross.aspx", "right");
		                break;

		            case 8:		// Search Contacts
		                //LoadAddressTree();
		                window.open("/myoffice/ezAddress/address_search_Cross.aspx", "right");
		                break;

		            case 10:	// Search public calendar
		                window.open("/myoffice/ezSchedule/schedule_public_search_Cross.aspx", "right");
		                break;
		            case 11:		// Search public calendar
		                window.open("/MyOffice/ezSchedule/PIMS_config_Cross.aspx", "right");
		                break;
		        }
		    }

		    function Open_Schedule(idx) {
		        try {
		            if (idx == 3)
		                window.top.frames("top").document.Script.change_menu(2, "<a href='/myoffice/main/index_myoffice.asp?funcode=1' target='main' class='n'><spring:message code='ezSchedule.t1013'/></a> > " +
					    "<a href='/myoffice/ezSchedule/schedule_Public_search_Cross.aspx' target='right' class='n'><spring:message code='ezSchedule.t1021'/></a>");
		            else if (idx == 2)
		                window.top.frames("top").document.Script.change_menu(2, "<a href='/myoffice/main/index_myoffice.asp?funcode=1' target='main' class='n'><spring:message code='ezSchedule.t1013'/></a> > " +
					    "<a href='/myoffice/ezSchedule/schedule_search_Cross.aspx' target='right' class='n'><spring:message code='ezSchedule.t1018'/></a>");
		            elseg
		            window.top.frames("top").document.Script.change_menu(2, "<a href='/myoffice/main/index_myoffice.asp?funcode=1' target='main' class='n'><spring:message code='ezSchedule.t1013'/></a> > " +
	                "<a href='/myoffice/main/index_myoffice.asp?funcode=2' target='main' class='n'><spring:message code='ezSchedule.t1010'/></a>");
		        } catch (e) { }
		    }

	        function Open_Task(idx) {
	            try {
	                if (idx != 2)
	                    window.top.frames("top").document.Script.change_menu(2, "<a href='/myoffice/main/index_myoffice.asp?funcode=1' target='main' class='n'><spring:message code='ezSchedule.t1013'/></a> > " +
	                    "<a href='/myoffice/main/index_myoffice.asp?funcode=3' target='main' class='n'><spring:message code='ezSchedule.t1011'/></a>");
	                else
	                    window.top.frames("top").document.Script.change_menu(2, "<a href='/myoffice/main/index_myoffice.asp?funcode=1' target='main' class='n'><spring:message code='ezSchedule.t1013'/></a> > " +
	                    "<a href='/myoffice/ezTask/task_search.asp' target='right' class='n'><spring:message code='ezSchedule.t1019'/></a>");
	            } catch (e) { }
	        }

	        function Open_Address(idx) {
	            try {
	                if (idx != 2)
	                    window.top.frames("top").document.Script.change_menu(2, "<a href='/myoffice/main/index_myoffice.asp?funcode=1' target='main' class='n'><spring:message code='ezSchedule.t1013'/></a> > " +
	                    "<a href='/myoffice/main/index_myoffice.asp?funcode=4' target='main' class='n'><spring:message code='ezSchedule.t1017'/></a> > <a href='/myoffice/main/index_myoffice.aspx?funcode=4' target='main' class='n'><spring:message code='ezSchedule.t1022'/></a>");
	                else
	                    window.top.frames("top").document.Script.change_menu(2, "<a href='/myoffice/main/index_myoffice.asp?funcode=1' target='main' class='n'><spring:message code='ezSchedule.t1013'/></a> > " +
	                    "<a href='/myoffice/main/index_myoffice.asp?funcode=4' target='main' class='n'><spring:message code='ezSchedule.t1017'/></a> > <a href='/myoffice/ezAddress/address_search_Cross.aspx' target='right' class='n'><spring:message code='ezSchedule.t1020'/></a>");
	            } catch (e) { }
	        }

	        function newSchedule_onclick() {
	            var feature = GetOpenPosition(560, 540);
	            window.open("/myoffice/ezSchedule/Schedule_Add.aspx?cmd=add&from=schedule2", "", "width=560, height=540, status = no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
	        }
		
	        function newTask_onclick() {
	            var feature = GetOpenPosition(560, 540);
	            window.open("/myoffice/ezTask/task_write.aspx", "", "width=560, height=540, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        }
		
	        function OpenGroupManage() {
	            var feature = GetOpenPosition(430, 350);
	            window.open("/myoffice/ezSchedule/schedule_manage_group_Cross.aspx", "",
	                "height = 350px, width = 430px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + feature);
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
		
	        function Function_SchList() {
	            window.open("/myoffice/ezSchedule/schedule_main_Cross.aspx?idtype=M&CODEKEY=" + schlist.value, "right");
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
		    <h2><span id='Task' onClick="Function_Flag(3)" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1011'/></span></h2>
		    <ul>
			    <li><span id='Task_Main' onClick="Function_Flag(3)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1011'/></span></li>
			    <li><span id='Task_Search' onClick="Function_Flag(7)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1019'/></span></li>
		    </ul>
		   <%-- <h2 ><span id='Address_Main' onClick="Function_Flag('4')" style="width:100%;display:inline-block;" ><spring:message code='ezSchedule.t1017'/></span></h2>
		    <ul>
			    <div class="tree" style="MARGIN-LEFT:5px;WIDTH:179px;HEIGHT:auto;background-color:White;white-space:nowrap;overflow-x:auto;overflow-y:auto;margin-left:20px;background-color:#e6e6e6;" id="AddressTreeView"></div>
			    <li><span id='Address_Search' onClick="Function_Flag('8')" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1020'/></span></li>
	            <li evt="0"><span onClick="address_foldermanage()" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1023'/></span></li>
		    </ul>--%>
	        <h3><span  onClick="Function_Flag('11')" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1012'/></span></h3>
		</div>
		
	    <script type="text/javascript">
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    
	</body>
</html>