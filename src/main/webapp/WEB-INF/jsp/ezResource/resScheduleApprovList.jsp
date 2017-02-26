<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t241" /></title>
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="/css/olstyle_nonIE.css" type="text/css" />
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" />
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="<spring:message code='ezResource.e1'/>"></script>
		<script type="text/javascript" src="/js/ezResource/control/ListView_Approv.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript">
			var lang = "${userInfo.lang}";
			var userPrimary = "${userInfo.primary}";
			var pBrdid = "${resID}";
	    	var xmlhttp;
	    	var ss_companyID = "${userInfo.companyID}";
	    	var CurPage = "1";
	    	var totalPage = "";

	    	$(function () {
		        $("#Sdatepicker").datepicker({
	            	changeMonth: true,
	            	changeYear: true,
	            	autoSize: true,
	            	showOn: "both",
	            	buttonImage: "/images/ImgIcon/calendar-month.gif",
	            	buttonImageOnly: true
	        	});
	        	$("#Sdatepicker2").datepicker({
		            changeMonth: true,
	            	changeYear: true,
	            	autoSize: true,
	            	showOn: "both",
	            	buttonImage: "/images/ImgIcon/calendar-month.gif",
	            	buttonImageOnly: true
	        	});
	        	var startdate = "${startDate}";
	        	var enddate = "${endDate}";

	        	startdate = startdate.split("-");
	        	enddate = enddate.split("-");

		        var NowDate = new Date(startdate[0], parseInt(startdate[1]) - 1, startdate[2]);
		        var NowDate2 = new Date(enddate[0], parseInt(enddate[1]) - 1, enddate[2]);
	    	    $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Sdatepicker").datepicker('setDate', NowDate);
	        	$("#Sdatepicker2").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Sdatepicker2").datepicker('setDate', NowDate2);
	    	});
	    	
	    	if(lang == "1") {
	    		$(function () {
			        $.datepicker.regional['ko'] = {
		            	closeText: '닫기',
		            	prevText: '이전달',
		            	nextText: '다음달',
		            	currentText: '오늘',
		            	monthNames: ['1월', '2월', '3월', '4월', '5월', '6월',
		            	'7월', '8월', '9월', '10월', '11월', '12월'],
		            	monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월',
		            	'7월', '8월', '9월', '10월', '11월', '12월'],
		            	dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		            	dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		            	dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		            	weekHeader: 'Wk',
		            	dateFormat: 'yy-mm-dd',
		            	firstDay: 0,
		            	isRTL: false,
		            	duration: 200,
		            	showAnim: 'show',
		            	showMonthAfterYear: true
		        	};
		        	$.datepicker.setDefaults($.datepicker.regional['ko']);
		    	});
	    	} else {
	    		$(function () {
			        $.datepicker.regional['en'] = {
		            	dateFormat: 'yy-mm-dd',
		            	firstDay: 0,
		            	isRTL: false,
		            	duration: 200,
		            	showAnim: 'show',
		            	showMonthAfterYear: true
		        	};
		        	$.datepicker.setDefaults($.datepicker.regional['en']);
		    	});
	    	}
	    	
	    	window.onload = function () {
		        getCalendarList();
	    	}

	    	function getCalendarList(type) {
		        if (type == "search") {
	            	CurPage = "1";
		        }

	        	document.getElementById("listviewtype").selectedIndex
	        	var listviewtype = document.getElementById("listviewtype")[document.getElementById("listviewtype").selectedIndex].value;

	        	xmlhttp = createXMLHttpRequest();
	        	var xmlpara = createXmlDom();
	        	var objNode;
	        	createNodeInsert(xmlpara, objNode, "PARAMETER");
	        	
	        	if($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()>$("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val()){
	        		alert("<spring:message code="ezResource.t207"/>");
	        		return;
	        	}
	        	createNodeAndInsertText(xmlpara, objNode, "STARTDATETIME", $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
	        	createNodeAndInsertText(xmlpara, objNode, "ENDDATETIME", $("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val());
	        	createNodeAndInsertText(xmlpara, objNode, "APPROVEFLAG", listviewtype);
	        	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", document.getElementById("writername").value);
	        	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPT", document.getElementById("writerdept").value);
	        	createNodeAndInsertText(xmlpara, objNode, "APP", "1");
	        	xmlhttp.open("POST", "/ezResource/scheduleGet.do?cmd=get&resID=" + pBrdid + "&viewType=list&page=" + CurPage, true);
	        	xmlhttp.onreadystatechange = getCalendarList_after;
	        	xmlhttp.send(xmlpara);
	    	}

	    	function getCalendarList_after() {
		        if (xmlhttp == null || xmlhttp.readyState != 4)
	            	return;
	        	if (xmlhttp.status >= 200 && xmlhttp.status < 300) {
		            var listxml = xmlhttp.responseXML;
	            	var list = "<ROWS>";

	            	totalPage = Math.ceil(new Number(getNodeText(SelectNodes(listxml, "root/totalcount")[0]) / 20));
					
	            	if(totalPage == 0){
		                document.getElementById("ApprovList").innerHTML = "";
	                	var listheader = loadXMLString(document.getElementById("listviewheader").innerHTML.toUpperCase());
	                	var xmldom = xmlhttp.responseXML;
	                	var listview = new ListView();
	                	listview.SetID("ApprovListView");
	                	listview.SetSelectFlag(false);
	                	listview.SetMulSelectable(true);
	                	listview.SetRowOnDblClick("show_Resource");
	                	listview.DataSource(listheader);
	                	listview.DataBind("ApprovList");
	                	makePageSelPage();
	                	return;
	            	}

	            	if (CurPage > totalPage) {
		                CurPage--;
	                	getCalendarList();
	                	return;
	            	}
	            	makePageSelPage();

		            for (var i = 0; i < SelectNodes(listxml, "root/appointment").length; i++) {
		                list += "<ROW><CELL><VALUE>CHECK</VALUE>";
	                	list += "<DATA1>" + getNodeText(SelectNodes(listxml, "number")[i]) + "</DATA1>";
	                	list += "<DATA2>" + getNodeText(SelectNodes(listxml, "owner_id")[i]) + "</DATA2>";
	                	list += "<DATA3>" + getNodeText(SelectNodes(listxml, "dtstart")[i]).substring(0, 10) + "</DATA3>";
	                	list += "<DATA4>" + getNodeText(SelectNodes(listxml, "dtend")[i]).substring(0, 10) + "</DATA4>";
	                	list += "<DATA5>" + getNodeText(SelectNodes(listxml, "approveFlag")[i]).substring(0, 10) + "</DATA5>";
	                	list += "<DATA6>" + getNodeText(SelectNodes(listxml, "alldayevent")[i]).substring(0, 10) + "</DATA6>";
	                	list += "<DATA7>" + getNodeText(SelectNodes(listxml, "instancetype")[i]).substring(0, 10) + "</DATA7>";
	                	list += "<DATA8>" + getNodeText(SelectNodes(listxml, "pnumber")[i]).substring(0, 10) + "</DATA8>";
	                	list += "<DATA9>" + getNodeText(SelectNodes(listxml, "groupflag")[i]).substring(0, 10) + "</DATA9>";
	                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "approveFlag")[i]) + "</VALUE></CELL>";
	                	list += "</CELL><CELL><VALUE><![CDATA[" + getNodeText(SelectNodes(listxml, "subject")[i]) + "]]></VALUE></CELL>";
	                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "dtstart")[i]).substring(0, 16).replace("T", " ") + "</VALUE></CELL>";
	                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "dtend")[i]).substring(0, 16).replace("T", " ") + "</VALUE></CELL>";
	                	if (userPrimary == "1") {
		                    list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "dept_name")[i]) + "</VALUE></CELL>";
	                    	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "owner_nm")[i]) + "</VALUE></CELL>";
	                    	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "jobtitle")[i]) + "</VALUE></CELL>";
	                	} else {
	                    	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "dept_name2")[i]) + "</VALUE></CELL>";
	                    	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "owner_nm2")[i]) + "</VALUE></CELL>";
	                    	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "jobtitle2")[i]) + "</VALUE></CELL>";
	                	}
	                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "instancetype")[i]) + "</VALUE></CELL>";
	                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "writeDay")[i]).substring(0, 10) + "</VALUE></CELL></ROW>";
	            	}
	            	list += "</ROWS>";

		            list = loadXMLString(list);
		            var listheader = loadXMLString(document.getElementById("listviewheader").innerHTML.toUpperCase());
	            	SelectSingleNode(listheader, "LISTVIEWDATA").appendChild(list.documentElement)

		            document.getElementById("ApprovList").innerHTML = "";
	            	var xmldom = xmlhttp.responseXML;
	            	var listview = new ListView();
	            	listview.SetID("ApprovListView");
	            	listview.SetSelectFlag(false);
	            	listview.SetMulSelectable(true);
	            	listview.SetRowOnDblClick("show_Resource");
	            	listview.DataSource(listheader);
	            	listview.DataBind("ApprovList");

		            xmldom = null;
		        }
	    	}

	    	function ViewCalendar() {
		        if(CrossYN())
	            	window.location.href = "/ezResource/scheduleMain.do?resID=" + pBrdid;
	        	else
		            window.location.href = "/ezResource/scheduleMain.do?resID=" + pBrdid;
	    	}

	    	function show_Resource(obj) {
		        var szNum = document.getElementById(obj).getAttribute("DATA1");
	        	var szOwnerID = document.getElementById(obj).getAttribute("DATA2");
	        	var startDate = document.getElementById(obj).getAttribute("DATA3");
	        	var endDate = document.getElementById(obj).getAttribute("DATA4");
	        	var szType = "Master";
	        	if (CrossYN()) {
		            var feature = GetOpenPosition(820, 700);
	            	window.open("/ezResource/scheduleRead.do?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + startDate + "&endDate=" + endDate + "&brdName=" + encodeURIComponent("<c:out value='${brdNm}' />"), "", "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        	} else {
	            	var feature = GetOpenPosition(790, 700);
	            	window.open("/ezResource/scheduleRead.do?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + startDate + "&endDate=" + endDate + "&brdName=" + encodeURIComponent("<c:out value='${brdNm}' />"), "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        	}
	    	}

	    	function btn_Approv() {
		        var listview = new ListView();
	        	listview.LoadFromID("ApprovListView");
	        	var selrow = listview.GetSelectedRows();
	
	        	var issave = false;
	        	for (var i = 0; i < selrow.length; i++) {
	            	if (selrow[i].getAttribute("DATA5") == "0") {
		                var startdate = "";
		                var enddate = "";

	                	var AllDayCheck;
	                	var startDateVal = selrow[i].getAttribute("DATA3");
	                	var endDateVal = selrow[i].getAttribute("DATA4");
	                	var allDayFlag = selrow[i].getAttribute("DATA6");
	                	if (allDayFlag == "1") {
		                    startdate = startDateVal + " 00:00:01";
	                    	enddate = endDateVal + " 23:59:59";
	                    	AllDayCheck = true;
		                } else {
	                    	var startdate = getChildNodeText(GetChildNodes(selrow[i])[3]);
	                    	var enddate = getChildNodeText(GetChildNodes(selrow[i])[4]);

	                    	AllDayCheck = false;
	                	}

	                	var bUsingResource = isUsingResource(selrow[i].getAttribute("DATA2"), startdate, enddate, ss_companyID, selrow[i].getAttribute("DATA1"), "mod", AllDayCheck, "0");
	                	if (bUsingResource) {
	                    	if(CrossYN())
		                        alert(GetChildNodes(selrow[i])[2].textContent + " : " + strLang248 + "");
		                    else
	    	                    alert(GetChildNodes(selrow[i])[2].innerText + " : " + strLang248 + "");
	        	            continue;
	            	    }

	                	var xmlHTTP = createXMLHttpRequest();
	                	var xmlDOM = createXmlDom();
	                	var objNode;

		                createNodeInsert(xmlDOM, objNode, "DATA");
	                	createNodeAndInsertText(xmlDOM, objNode, "COMPANYID", ss_companyID);
	                	createNodeAndInsertText(xmlDOM, objNode, "RESID", selrow[i].getAttribute("DATA2"));
	                	createNodeAndInsertText(xmlDOM, objNode, "NUM", selrow[i].getAttribute("DATA1"));
	                	createNodeAndInsertText(xmlDOM, objNode, "APPROVE", "1");

		                xmlHTTP.open("POST", "/ezResource/updateApprovalFlag.do", false);
		                xmlHTTP.send(xmlDOM);

	                	var rtnValue = xmlHTTP.responseText;

	                	xmlHTTP = null;

	                	if (rtnValue == "True") {
		                    xmlHTTP = createXMLHttpRequest();
		                    xmlHTTP.open("POST", "/ezResource/sendMailToUser.do", false);
	    	                xmlHTTP.send(xmlDOM);
	        	            var ResponseXML = xmlHTTP.responseXML;
	            	        xmlHTTP = createXMLHttpRequest();
	                	    xmlHTTP.open("POST", "/ezEmail/remote/mailSendNoti.do", false);
	                    	xmlHTTP.send(ResponseXML);
	                    	xmlHTTP = null;
	                    	issave = true;
	                	} else {
	                    	issave = false;
	                    	alert("" + strLang178 + "");
	                    	return;
	                	}
	            	}
	        	}
	        	getCalendarList();
	        	if (issave)
		            alert("" + strLang33 + "");
	    	}

	    	function btn_ApprovCancel() {
		        var listview = new ListView();
	        	listview.LoadFromID("ApprovListView");
	        	var selrow = listview.GetSelectedRows();

	        	var issave = false;
	        	for (var i = 0; i < selrow.length; i++) {
		            if (selrow[i].getAttribute("DATA5") == "1") {
	                	var xmlHTTP = createXMLHttpRequest();
	                	var xmlDOM = createXmlDom();
	                	var objNode;
	
	                	createNodeInsert(xmlDOM, objNode, "DATA");
	                	createNodeAndInsertText(xmlDOM, objNode, "COMPANYID", ss_companyID);
	                	createNodeAndInsertText(xmlDOM, objNode, "RESID", selrow[i].getAttribute("DATA2"));
	                	createNodeAndInsertText(xmlDOM, objNode, "NUM", selrow[i].getAttribute("DATA1"));
	                	createNodeAndInsertText(xmlDOM, objNode, "APPROVE", "0");
	
	                	xmlHTTP.open("POST", "/ezResource/updateApprovalFlag.do", false);
	                	xmlHTTP.send(xmlDOM);

	                	var rtnValue = xmlHTTP.responseText;

	                	xmlHTTP = null;

	                	if (rtnValue == "True") {
		                    xmlHTTP = createXMLHttpRequest();
	                    	xmlHTTP.open("POST", "/ezResource/sendMailToUser.do", false);
	                    	xmlHTTP.send(xmlDOM);
	                    	var ResponseXML = xmlHTTP.responseXML;
	                    	xmlHTTP = createXMLHttpRequest();
	                    	xmlHTTP.open("POST", "/ezEmail/remote/mailSendNoti.do", false);
	                    	xmlHTTP.send(ResponseXML);
	                    	xmlHTTP = null;

	                    	issave = true;
	                	} else {
	                    	issave = false;;
	                    	alert("" + strLang178 + "");
	                    	return;
	                	}
	            	}
	        	}
	        	getCalendarList();
	        	if (issave)
		            alert("" + strLang33 + "");
	    	}

	    	var schedule_repetition_del_cross_dialogArguments = new Array();
	    	var selrow;
	    	function btn_Delete() {
	        
	        	var listview = new ListView();
	        	listview.LoadFromID("ApprovListView");
	        	selrow = listview.GetSelectedRows();

	        	var isRepetition = false;
	        	for (var i = 0; i < selrow.length; i++) {
		            var reFlagVal = selrow[i].getAttribute("DATA7");
	            	if (parseInt(reFlagVal) == 1 || parseInt(reFlagVal) == 3) {
		                isRepetition = true;
	                	break;
	            	}
	        	}
	        
	        	var szType;
	        	if (isRepetition) {
		            if (CrossYN()) {
	                	var rgParams = new Array();
	                	rgParams["CancelOpen"] = false;
	                	rgParams["InstanceType"] = "";
	                	schedule_repetition_del_cross_dialogArguments[0] = rgParams;
	                	schedule_repetition_del_cross_dialogArguments[1] = btn_Delete_Complete;

		                DivPopUpShow(390, 260, "/ezResource/scheduleRepetitionDel.do");
		            } else {
	                	var rgParams = new Array();
	                	rgParams["CancelOpen"] = false;
	                	rgParams["InstanceType"] = "";

	                	var feature = "dialogHeight:260px;dialogWidth:390px;status:no;help:no;center:yes;edge:sunken";
	                	feature = feature + GetShowModalPosition(390, 260);
	                	var hWin = window.showModalDialog("/ezResource/scheduleRepetitionDel.do", rgParams, feature);

	                	if (false != rgParams["CancelOpen"]) return (false);
	                	szType = rgParams["InstanceType"];
	            	}
	        	}
	        
	        	if ((!isRepetition && CrossYN()) || !CrossYN()) {
	            	var issdelete = false;
	            	for (var i = 0; i < selrow.length; i++) {
		                var reFlagVal = selrow[i].getAttribute("DATA7");

		                var xmlHttp = createXMLHttpRequest();
		                var xmlDoc = createXmlDom();
	    	            var objNode;

	        	        createNodeInsert(xmlDoc, objNode, "PARAMETER");

	            	    var num = selrow[i].getAttribute("DATA1");
	                	var ownerID = selrow[i].getAttribute("DATA2");
	                	var pnumVal = selrow[i].getAttribute("DATA8");
	                	var gFlagVal = selrow[i].getAttribute("DATA9");
	                	var startDateVal = selrow[i].getAttribute("DATA3");
	                	var endDateVal = selrow[i].getAttribute("DATA4");
	                	var writerIDVal = "";

		                if (parseInt(reFlagVal) == 1 || parseInt(reFlagVal) == 3) {
		                    if (parseInt(reFlagVal) == 1) {
	    	                    if (szType == "Instance") {
	        	                    pnumVal = num;
	            	                writerIDVal = ownerID;
	                	            num = "0";
	                    	        reFlagVal = "3";
	                        	}
	                    	} else if (parseInt(reFlagVal) == 3) {
	                        	if (szType == "Master") {
		                            num = pnumVal;
		                            ownerID = writerIDVal;
	    	                        reFlagVal = "1";
	        	                }
	            	        }
	                	}
	                	createNodeAndInsertText(xmlDoc, objNode, "NUM", num);
	                	createNodeAndInsertText(xmlDoc, objNode, "OWNERID", ownerID);
	                	createNodeAndInsertText(xmlDoc, objNode, "PNUM", pnumVal);
	                	createNodeAndInsertText(xmlDoc, objNode, "WRITERID", writerIDVal);
	                	createNodeAndInsertText(xmlDoc, objNode, "INSTYPE", reFlagVal);
	                	createNodeAndInsertText(xmlDoc, objNode, "GFLAG", gFlagVal);
	                	createNodeAndInsertText(xmlDoc, objNode, "STARTDATE", startDateVal);
	                	createNodeAndInsertText(xmlDoc, objNode, "ENDDATE", endDateVal);

		                xmlHttp.open("POST", "/ezResource/scheduleAddOk.do?cmd=del", false);
		                xmlHttp.send(xmlDoc);

	    	            var res = xmlHttp.responseText;

	        	        if (res.trim() == "OK") {
	            	        issdelete = true;
	                	} else {
	                    	issdelete = false;
	                    	alert("" + strLang149 + "");
	                    	return;
		                }
		            }
	    	        getCalendarList();
	        	    if (issdelete)
	            	    alert("" + strLang259 + "");
	        	}
	    	}

	    	function btn_Delete_Complete(retVal) {
		        if (false != retVal["CancelOpen"]) {
		            DivPopUpHidden();
	    	        return (false);
	        	}
	        	szType = retVal["InstanceType"];

	        	var issdelete = false;
	        	for (var i = 0; i < selrow.length; i++) {
		            var reFlagVal = selrow[i].getAttribute("DATA7");

		            var xmlHttp = createXMLHttpRequest();
	    	        var xmlDoc = createXmlDom();
	        	    var objNode;

	            	createNodeInsert(xmlDoc, objNode, "PARAMETER");

	            	var num = selrow[i].getAttribute("DATA1");
	            	var ownerID = selrow[i].getAttribute("DATA2");
	            	var pnumVal = selrow[i].getAttribute("DATA8");
	            	var gFlagVal = selrow[i].getAttribute("DATA9");
	            	var startDateVal = selrow[i].getAttribute("DATA3");
	            	var endDateVal = selrow[i].getAttribute("DATA4");
	            	var writerIDVal = "";

		            if (parseInt(reFlagVal) == 1 || parseInt(reFlagVal) == 3) {
	                
		                if (parseInt(reFlagVal) == 1) {
	    	                if (szType == "Instance") {
	        	                pnumVal = num;
	            	            writerIDVal = ownerID;
	                	        num = "0";
	                    	    reFlagVal = "3";
	                    	}
	                	} else if (parseInt(reFlagVal) == 3) {
	                    	if (szType == "Master") {
		                        num = pnumVal;
		                        ownerID = writerIDVal;
	    	                    reFlagVal = "1";
	        	            }
	            	    }
	            	}
	            	createNodeAndInsertText(xmlDoc, objNode, "NUM", num);
	            	createNodeAndInsertText(xmlDoc, objNode, "OWNERID", ownerID);
	            	createNodeAndInsertText(xmlDoc, objNode, "PNUM", pnumVal);
	            	createNodeAndInsertText(xmlDoc, objNode, "WRITERID", writerIDVal);
	            	createNodeAndInsertText(xmlDoc, objNode, "INSTYPE", reFlagVal);
	            	createNodeAndInsertText(xmlDoc, objNode, "GFLAG", gFlagVal);
	            	createNodeAndInsertText(xmlDoc, objNode, "STARTDATE", startDateVal);
	            	createNodeAndInsertText(xmlDoc, objNode, "ENDDATE", endDateVal);

	            	xmlHttp.open("POST", "/ezResource/scheduleAddOk.do?cmd=del", false);
	            	xmlHttp.send(xmlDoc);
	
	            	var res = xmlHttp.responseText;

	            	if (res.trim() == "OK") {
		                issdelete = true;
		            } else {
	                	issdelete = false;
	                	alert("" + strLang149 + "");
	                	return;
	            	}
	        	}
	        	getCalendarList();
	        	if (issdelete)
		            alert("" + strLang259 + "");

	        	DivPopUpHidden();
	    	}


	    	function btnRefresh_onclick() {
	        	getCalendarList();
	    	}

	    	function isUsingResource(pResID, pSTime, pETime, pCompanyID, pNum, pCmd, pAllDay, ApproveFlag) {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
	    	    var objNode;

	        	createNodeInsert(xmlDOM, objNode, "DATA");
	        	createNodeAndInsertText(xmlDOM, objNode, "RESID", pResID);
	        	createNodeAndInsertText(xmlDOM, objNode, "STIME", pSTime);
	        	createNodeAndInsertText(xmlDOM, objNode, "ETIME", pETime);
	        	createNodeAndInsertText(xmlDOM, objNode, "COMPANYID", pCompanyID);
	        	createNodeAndInsertText(xmlDOM, objNode, "NUM", pNum);
	        	createNodeAndInsertText(xmlDOM, objNode, "CMD", pCmd);
	        	createNodeAndInsertText(xmlDOM, objNode, "APPROVE", ApproveFlag);

		        xmlHTTP.open("POST", "/ezResource/timeDupCheck.do", false);
		        xmlHTTP.send(xmlDOM);

	    	    var rtnValue = xmlHTTP.responseText;

	        	xmlDOM = null;
	        	xmlHTTP = null;

	        	if (rtnValue == "False")
		            return false;
		        else
	    	        return true;
	    	}

	    	function getChildNodeText(node) {
	        	if (window.ActiveXObject)
		            return node.innerText;
		        else
	    	        return node.textContent;
	    	}

	    	var BlockSize = 10;
	    	function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
	    	}
	    	function makePageSelPage() {
		        var strtext;
	        	var PagingHTML = "";
	        	document.getElementById("tblPageRayer").innerHTML = "";
	        	strtext = "<div class='pagenavi'>";
	        	PagingHTML += strtext;
	        	var pageNum = CurPage;
	        	if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
		            PagingHTML += strtext;
	    	    } else {
	            	strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
	            	PagingHTML += strtext;
	        	}
	        	if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang1000 + "</span>";
	    	            PagingHTML += strtext;
	        	    } else {
	                	strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang1000 + "</span>";
	                	PagingHTML += strtext;
	            	}
	        	} else {
	            	strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang1000 + "</span>";
	            	PagingHTML += strtext;
	        	}
	        	var MaxNum;
	        	var i;
	        	var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
	        	if (totalPage >= (startNum + parseInt(BlockSize))) {
		            MaxNum = (startNum + parseInt(BlockSize)) - 1;
	    	    } else {
	            	MaxNum = totalPage;
	        	}
	        	for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
	    	            PagingHTML += strtext;
	        	    } else {
	                	strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                	PagingHTML += strtext;
	            	}
	        	}
	        	if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang1001 + "</span>";
	    	            strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
	        	        PagingHTML += strtext;
	            	} else {
	                	strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang1001 + "</span>";
	                	strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                	PagingHTML += strtext;
	            	}
	        	} else {
	            	strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang1001 + "</span>";
	            	strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	            	PagingHTML += strtext;
	        	}
	        	if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	            	strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
	            	PagingHTML += strtext;
	        	} else {
	            	strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
	            	PagingHTML += strtext;
	        	}
	        	PagingHTML += "</div>";
	        	td_Create1(PagingHTML);
	    	}
	    	function goToPageByNum(Value) {
		        CurPage = Value;
		        makePageSelPage();
	    	    movePage(CurPage);
	    	}
	    	function selbeforeBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	    	    goToPageByNum(pageNum);
	    	}
	    	function selbeforeBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum - 1) > 0)
	    	        goToPageByNum(parseInt(pageNum - 1));
	        	else
	            	return;
	    	}
	    	function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	    	    goToPageByNum(pageNum);
	    	}
	    	function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage)
	    	        goToPageByNum(parseInt(pageNum + 1));
	        	else
	            	return;
	    	}
	    	function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
	    	        getCalendarList();
	        	}
	    	}
	    	function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
		        if (newPage > 0) {
	    	        CurPage = newPage;
	        	    getCalendarList();
	        	}
	    	}
	    	function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
		        if (newPage <= parseInt(totalPage)) {
	    	        CurPage = newPage;
	        	    getCalendarList();
	        	}
	    	}
	    	function SortPage(strHeaderName) {
		        if (strHeaderName != "CHECK") {
	            	if (OrderCell == strHeaderName) {
		                if (OrderOption == "")
	                    	OrderOption = "DESC";
	                	else
		                    OrderOption = "";
	            	} else {
	                	OrderCell = strHeaderName;
	                	OrderOption = "";
	            	}
	            	getCalendarList();
	        	}
	    	}

		    var schedule_select_user_dialogArguments = new Array();
		    function seluser() {
	    	    if (CrossYN()) {
	        	    schedule_select_user_dialogArguments[1] = seluser_Complete;
	            	if (navigator.appName.indexOf("Microsoft") > -1) {
		                var OpenWin = window.open("/ezResource/scheduleSelectUser.do", "schedule_select_user", GetOpenWindowfeature(735, 580));
		                try { OpenWin.focus(); } catch (e) { }
	    	        } else {
	                	var OpenWin = window.open("/ezResource/scheduleSelectUser.do", "schedule_select_user", GetOpenWindowfeature(735, 555));
	                	try { OpenWin.focus(); } catch (e) { }
	            	}
		        } else {
	            	var rtnValue = "";
	            	var feature = GetShowModalPosition(735, 580);
	            	if (navigator.appName.indexOf("Microsoft") > -1)
		                rtnValue = window.showModalDialog("/ezResource/scheduleSelectUser.do", "",
	            	"dialogHeight:580px;dialogwidth:735px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
	            	else
		                rtnValue = window.showModalDialog("/ezResource/scheduleSelectUser.do", "",
	            	"dialogHeight:555px;dialogwidth:735px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);

		            if (typeof (rtnValue) != "undefined") {
		                userid = rtnValue.split(":")[0];
	    	            document.getElementById("writername").value = rtnValue.split(":")[1];
	        	        userdeptid = rtnValue.split(":")[2]
	            	}
	        	}
	    	}

	    	function seluser_Complete(retVal) {
		        if (typeof (retVal) != "undefined") {
		            userid = retVal.split(":")[0];
	    	        document.getElementById("writername").value = retVal.split(":")[1];
	        	    userdeptid = retVal.split(":")[2]
	        	}
	    	}

	    	var schedule_select_dept_dialogArguments = new Array();
	    	function seldept() {
		        if (CrossYN()) {
	            	schedule_select_dept_dialogArguments[1] = seldept_Complete;

	            	var OpenWin = window.open("/ezResource/scheduleSelectDept.do", "schedule_select_dept", GetOpenWindowfeature(280, 435));
	            	try { OpenWin.focus(); } catch (e) { }
	        	} else {
	            	var rtnValue = "";
	            	var feature = GetShowModalPosition(280, 435);
	            	rtnValue = window.showModalDialog("/ezResource/scheduleSelectDept.do", "",
	            	"dialogHeight:435px;dialogwidth:280px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);

		            if (typeof (rtnValue) != "undefined") {
		                if (rtnValue.split(":").length > 1) {
	    	                deptid = rtnValue.split(":")[0];
	        	            document.getElementById("writerdept").value = rtnValue.split(":")[1];
	            	    } else {
	                	    deptid = "";
	                    	document.getElementById("writerdept").value = "";
	                	}
		            }
		        }
	    	}

	    	function seldept_Complete(retVal) {
		        if (typeof (retVal) != "undefined") {
		            if (retVal.split(":").length > 1) {
	    	            deptid = retVal.split(":")[0];
	        	        document.getElementById("writerdept").value = retVal.split(":")[1];
	            	} else {
	                	deptid = "";
	                	document.getElementById("writerdept").value = "";
	            	}
	        	}
	    	}
		</script>
	</head>
	<body class="mainbody" style="overflow: auto;" id="BodyTop">
		<xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
    			<HEADERS>
        			<HEADER>
            			<NAME>CHECK</NAME>
            			<WIDTH>2%</WIDTH>
        			</HEADER>
        			<HEADER>
            			<NAME><spring:message code='ezResource.t191'/></NAME>
            			<WIDTH>4%</WIDTH>
        			</HEADER>   
        			<HEADER>
            			<NAME><spring:message code='ezResource.t224'/></NAME>
            			<WIDTH>51%</WIDTH>
        			</HEADER>
        			<HEADER>
            			<NAME><spring:message code='ezResource.t202'/></NAME>
            			<WIDTH>8%</WIDTH>
        			</HEADER>
        			<HEADER>
            			<NAME><spring:message code='ezResource.t212'/></NAME>
            			<WIDTH>8%</WIDTH>
        			</HEADER>
        			<HEADER>
            			<NAME><spring:message code='ezResource.t132'/></NAME>
            			<WIDTH>5%</WIDTH>
        			</HEADER>  
        			<HEADER>
            			<NAME><spring:message code='ezResource.t37'/></NAME>
            			<WIDTH>5%</WIDTH>
        			</HEADER>  
        			<HEADER>
            			<NAME><spring:message code='ezResource.t193'/></NAME>
            			<WIDTH>5%</WIDTH>
        			</HEADER>  
        			<HEADER>
            			<NAME><spring:message code='ezResource.t195'/></NAME>
            			<WIDTH>6%</WIDTH>
        			</HEADER>
        			<HEADER>
            			<NAME><spring:message code='ezResource.t2004'/></NAME>
            			<WIDTH>6%</WIDTH>
        			</HEADER> 					
    			</HEADERS>
			</LISTVIEWDATA>
		</xml>
    	<h1><c:out value='${brdNm}' /></h1>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="mainmenu">
  			<ul>
    			<li><span id="Span1" onClick="btn_Approv()"><spring:message code='ezResource.t191'/></span></li>
    			<li><span id="pn_img" onClick="btn_ApprovCancel()"><spring:message code='ezResource.t190'/></span></li>
    			<li><span onclick='btn_Delete();'><spring:message code='ezResource.t65'/></span></li>
    			<li><span onclick='ViewCalendar()'><spring:message code='ezResource.t255'/></span></li>
    			<li style="background:none">
        			<select id="listviewtype" onchange="getCalendarList('search')">
            			<option value=""><spring:message code='ezResource.t2000'/></option>
            			<option value="1"><spring:message code='ezResource.t2001'/></option>
            			<option value="0"><spring:message code='ezResource.t2002'/></option>
        			</select>
    			</li>
  			</ul>
		</div>
		<div class="portlet_tabpart03" style="background-color: #e9e9e9; margin-top: 4px;border:1px solid #d3d2d2">
    		<a class="imgbtn" style="vertical-align:middle"><span id="Span2" onclick="seluser()"><spring:message code='ezResource.t2003'/></span></a>
    		<input id="writername" type="text" style="width: 80px" />
    		<a class="imgbtn" style="vertical-align:middle"><span id="Span3" onclick="seldept()"><spring:message code='ezResource.t132'/></span></a>
    		<input id="writerdept" type="text" style="width: 80px" />
    		<input type="text" id="Sdatepicker" style="width: 80px; text-align: center"> ~  <input type="text" id="Sdatepicker2" style="width: 80px; text-align: center">
       		<a class="imgbtn" style="vertical-align:middle"><span id="btn_OK" onclick="getCalendarList('search')"><spring:message code='ezResource.t14'/></span></a>
		</div>
		<div id="ApprovList" style ="BORDER:0;WIDTH:100%; height:100%;margin-top:10px"></div>
		<div id="tblPageRayer" style="text-align:center"></div>
		<script type="text/javascript">
    		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>