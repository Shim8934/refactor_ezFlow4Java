<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<title>mail_search</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
<script type="text/javascript" src="/js/ezEmail/js_cross/search_mail.js"></script>
<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
<script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
<script type="text/javascript" src="/js/ezEmail/js_cross/date_component.js"></script>
<script  type="text/javascript" src="/js/ezEmail/Controls_cross/datepicker.htc.js"></script>
<script  type="text/javascript" src="/js/ezEmail/Controls_cross/composeappt.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<script type="text/javascript">
    var pUse_Editor = "${useEditor}";
	var g_servername = "${serverName}";	
	var g_expath = "exchange";
	var g_userID = "${userId}";
	var importanceColor = "#ff0000";
	var g_userLang = "${userLang}";
	var g_timezone = "${userTimeSet}";
	var g_addHour = "${addHour}";
    var checkval = "f";
    var m_strColorSelect = "#DBE1E7";
    var m_strColorOver = "#f4f5f5";
    var m_strColorDefault = "#ffffff";
    var pNoneActiveX = "YES";
    document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
    };
    $(function () {
        $("#Sdatepicker").datepicker({
            changeMonth: true,
            changeYear: true,
            autoSize: true,
            showOn: "both",
            buttonImage: "/images/ImgIcon/calendar-month.gif",
            buttonImageOnly: true
        });
        $("#Edatepicker").datepicker({
            changeMonth: true,
            changeYear: true,
            autoSize: true,
            showOn: "both",
            buttonImage: "/images/ImgIcon/calendar-month.gif",
            buttonImageOnly: true
        });
        var NowDate = new Date();
        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
        $("#Sdatepicker").datepicker('setDate', NowDate);
        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
        $("#Edatepicker").datepicker('setDate', NowDate);
    });
    
    $(function () {
        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
            closeText: "<spring:message code='main.t3' />",
            prevText: "<spring:message code='main.t0604' />",
            nextText: "<spring:message code='main.t0605' />",
            currentText: "<spring:message code='main.t0606' />",
            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
                       "<spring:message code='main.t0627' />"],
            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
		                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
		                       "<spring:message code='main.t0627' />"],
            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
	                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
	                       "<spring:message code='main.t0627' />"],
            weekHeader: "Wk",
            dateFormat: "yy-mm-dd",
            firstDay: 0,
            isRTL: false,
            duration: 200,
            showAnim: "show",
            showMonthAfterYear: true
        };
        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
    });
    
    window.onload =  function()
    {
        if (navigator.userAgent.indexOf('Firefox') != -1) {
            document.body.style.MozUserSelect = 'none';
            document.body.style.WebkitUserSelect = 'none';
            document.body.style.khtmlUserSelect = 'none';
            document.body.style.oUserSelect = 'none';
            document.body.style.UserSelect = 'none';
        }
        $("#Sdatepicker").datepicker('disable');
        $("#Edatepicker").datepicker('disable');
    }
    function search_keypress(evt)
	{	
        var curevent = (typeof event == 'undefined' ? evt : event)
        if (curevent.keyCode == "13") {
            start_search();
        }
	}
	function document_onselectstart()
	{
		event.cancelBubble = true;
		event.returnValue = false;
	}
	function check_change(checkbox) {
	    if (checkval == "f") {
	        var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
	        for (var i = 0; i < Rows.length; i++) {
	            if (!Rows.item(i).childNodes.item(0).childNodes.item(0).disabled) {
	                Rows.item(i).childNodes.item(0).childNodes.item(0).checked = true;
	                for (var RowCnt = 0; RowCnt < Rows.item(i).childNodes.length; RowCnt++) {
	                    Rows.item(i).childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                }
	                listContentArry[listContentArry.length] = Rows.item(i).getAttribute("id");
	            }
	        }
	        checkval = "t";
	    }
	    else if (checkval == "t") {
	        var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
	        for (var i = 0; i < Rows.length; i++) {
	            Rows.item(i).childNodes.item(0).childNodes.item(0).checked = false;
	            for (var RowCnt = 0; RowCnt < Rows.item(i).childNodes.length; RowCnt++) {
	                Rows.item(i).childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	            }
	        }
	        listContentArry = new Array();
	        checkval = "f";

	    }
	}

	function new_mail_onclick() 
	{
	    var pheight = window.screen.availHeight;
	    var conHeight = pheight * 0.8;
	    var pwidth = window.screen.availWidth;
	    var conWidth = pwidth * 0.8;
	    if (conWidth > 890)
	        conWidth = 890;
	    var pTop = (pheight - conHeight) / 2;
	    var pLeft = (pwidth - 890) / 2;
	    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
	    window.open("/ezEmail/mailWrite.do?cmd=NEW", "", feature);
	}
	function reply_mail_onclick() 
	{
	    var selcheck;
	    var count = 0;
	    
	    if (GetChildNodes(resultTD).length == 0) {
	    	alert('<spring:message code="ezEmail.t622" />');
	        return;
	    }
	    
		var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
		for (var i = 0; i < Rows.length; i++) {
		    if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
		        count++;
		        selcheck = Rows.item(i);
		    }
		}
		if (count == 0) 
		{
			alert('<spring:message code="ezEmail.t622" />');
			return;
		}			
		else if (count > 1) 
		{
			alert('<spring:message code="ezEmail.t623" />');
			return;
		}
	    var pheight = window.screen.availHeight;
	    var conHeight = pheight * 0.8;
	    var pwidth = window.screen.availWidth;
	    var conWidth = pwidth * 0.8;
	    if (conWidth > 890)
	        conWidth = 890;
	    var pTop = (pheight - conHeight) / 2;
	    var pLeft = (pwidth - 890) / 2;
	    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
	    window.open("/ezEmail/mailWrite.do?URL=" + encodeURIComponent(selcheck.getAttribute("itemID")) + "&cmd=REPLY", "", feature);
	}

	function all_reply_mail_onclick() 
	{
	    var selcheck;
	    var count = 0;
	    
	    if (GetChildNodes(resultTD).length == 0) {
	    	alert('<spring:message code="ezEmail.t625" />');
	        return;
	    }
	    
	    var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
	    for (var i = 0; i < Rows.length; i++) {
	        if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
	            count++;
	            selcheck = Rows.item(i);
	        }
	    }
		if (count == 0) 
		{
			alert('<spring:message code="ezEmail.t625" />');
			return;
		}	
		else if (count > 1) 
		{
			alert('<spring:message code="ezEmail.t626" />');
			return;
		}
	
	    var pheight = window.screen.availHeight;
	    var conHeight = pheight * 0.8;
	    var pwidth = window.screen.availWidth;
	    var conWidth = pwidth * 0.8;
	    if (conWidth > 890)
	        conWidth = 890;
	    var pTop = (pheight - conHeight) / 2;
	    var pLeft = (pwidth - 890) / 2;
	    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
	    window.open("/ezEmail/mailWrite.do?URL=" + encodeURIComponent(selcheck.getAttribute("itemID")) + "&cmd=REPLYALL", "", feature);
	}

	function transmission_mail_onclick() 
	{
	    var selcheck;
	    var count = 0;
	    
	    if (GetChildNodes(resultTD).length == 0) {
	    	alert('<spring:message code="ezEmail.t628" />');
	        return;
	    }
	    
	    var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
	    for (var i = 0; i < Rows.length; i++) {
	        if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
	            count++;
	            selcheck = Rows.item(i);
	        }
	    }
		if (count == 0) 
		{
			alert('<spring:message code="ezEmail.t628" />');
			return;
		}	
		else if (count > 1) 
		{
			alert('<spring:message code="ezEmail.t629" />');
			return;
		}
	    var pheight = window.screen.availHeight;
	    var conHeight = pheight * 0.8;
	    var pwidth = window.screen.availWidth;
	    var conWidth = pwidth * 0.8;
	    if (conWidth > 890)
	        conWidth = 890;
	    var pTop = (pheight - conHeight) / 2;
	    var pLeft = (pwidth - 890) / 2;
	    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
	    window.open("/ezEmail/mailWrite.do?URL=" + encodeURIComponent(selcheck.getAttribute("itemID")) + "&cmd=FORWARD", "", feature);	
	}
    var mail_movecopy_cross_dialogArguments = new Array();
    var selcheck;
	function move_mail_onclick() 
	{
	    selcheck = new Array();
	    var count = 0;
	    
	    if (GetChildNodes(resultTD).length == 0) {
	    	alert('<spring:message code="ezEmail.t631" />');
	        return;
	    }
	    
	    if (resultTD.childNodes.item(0).childNodes.length > 0) {
	        var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
	        for (var i = 0; i < Rows.length; i++) {
	            if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
	                selcheck[count] = Rows.item(i);
	                count++;
	            }
	        }
	        if (count == 0) {
	            alert('<spring:message code="ezEmail.t631" />');
	            return;
	        }
	        if (CrossYN()) {
	            mail_movecopy_cross_dialogArguments[1] = move_mail_onclick_Complete;
	            mail_movecopy_cross_dialogArguments[2] = "CLOSE";
	            var OpenWin = window.open("/ezEmail/mailMoveCopy.do", "mail_movecopy_cross", GetOpenWindowfeature(320, 375));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        else {
	            var feature = "dialogHeight:375px; dialogWidth:320px; status:no; help:no; edge:sunken";
	            feature = feature + GetShowModalPosition(320, 375);
	            var moveUrl = window.showModalDialog("mail_movecopy_cross.aspx", null, feature);

	            if (typeof (moveUrl) == "undefined")
	                return;

	            if (moveUrl["cmd"] == "MOVE") {
	                copyItemList(moveUrl["cmd"], moveUrl["url"], selcheck);
	                var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
	                for (var i = 0; i < Rows.length; i++) {
	                    if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
	                        Rows.item(i).childNodes.item(0).childNodes.item(0).checked = false;
	                        Rows.item(i).childNodes.item(0).childNodes.item(0).disabled = true;
	                        Rows.item(i).onclick = function () { return false; };
	                        Rows.item(i).onmouseover = function () { return false; }
	                        Rows.item(i).onmouseout = function () { return false; }
	                        for (var RowCnt = 0; RowCnt < Rows.item(i).childNodes.length; RowCnt++) {
	                            Rows.item(i).childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                            Rows.item(i).childNodes.item(RowCnt).disabled = true;
	                        }
	                    }
	                }
	            }
	            else if (moveUrl["cmd"] == "COPY") {
	                copyItemList(moveUrl["cmd"], moveUrl["url"], selcheck);
	            }

	            listContentArry = new Array();
	        }
	    }
	}
    function move_mail_onclick_Complete(moveUrl)
    {
        if (typeof (moveUrl) == "undefined")
            return;

        if (moveUrl["cmd"] == "MOVE") {
            copyItemList(moveUrl["cmd"], moveUrl["url"], selcheck);
            var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
            for (var i = 0; i < Rows.length; i++) {
                if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
                    Rows.item(i).childNodes.item(0).childNodes.item(0).checked = false;
                    Rows.item(i).childNodes.item(0).childNodes.item(0).disabled = true;
                    Rows.item(i).onclick = function () { return false; };
                    Rows.item(i).onmouseover = function () { return false; }
                    Rows.item(i).onmouseout = function () { return false; }
                    for (var RowCnt = 0; RowCnt < Rows.item(i).childNodes.length; RowCnt++) {
                        Rows.item(i).childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
                        Rows.item(i).childNodes.item(RowCnt).disabled = true;
                    }
                }
            }
        }
        else if (moveUrl["cmd"] == "COPY") {
            copyItemList(moveUrl["cmd"], moveUrl["url"], selcheck);
        }

        listContentArry = new Array();
    }
	function copyItemList(cmd, copyFolderID, selectedURL)
	{
	    var itemIDsarr = new Array();
        for (i = 0; i < selectedURL.length; i++)
        {
            if (typeof (selectedURL[i].getAttribute("itemID")) != "undefined")
            {
                itemIDsarr[i] = selectedURL[i].getAttribute("itemID");
            }
        }
	    var itemIDs = itemIDsarr.join(',');
	    try 
	    {
            g_copyItemHttp = createXMLHttpRequest();
            var xmlDOM = createXmlDom();
            var objNode;
            createNodeInsert(xmlDOM, objNode, "DATA");
            createNodeAndInsertText(xmlDOM, objNode, "CMD",cmd );
            createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID", itemIDs);
            createNodeAndInsertText(xmlDOM, objNode, "FOLDERID",copyFolderID );
            g_copyItemHttp.open("POST", "/ezEmail/mailMoveCopyMessageS.do", true);
            g_copyItemHttp.onreadystatechange = event_copyItemList;
            event_copyItemList.cmd = cmd;
            g_copyItemHttp.send(xmlDOM);
        }
        catch (e) {
            g_copyItemHttp = null;
            if (cmd == "COPY")
                alert(strLang52);
            else if (cmd == "MOVE")
                alert(strLang5);
            else if (cmd == "BDELETE")
                alert(strLang6);
        }
	}
	function event_copyItemList() {
	    if (g_copyItemHttp != null && g_copyItemHttp.readyState == 4) {
	        if (g_copyItemHttp.status < 200 || g_copyItemHttp.status > 300) {
	            g_copyItemHttp = null;

	            if (event_copyItemList.cmd == "COPY") {
	                alert(strLang52);
	            }
	            else if (event_copyItemList.cmd == "MOVE") {
	                alert(strLang5);
	            }
	            else if (event_copyItemList.cmd == "BDELETE") {
	                alert(strLang6);
	            }
	        }
	        else {
				if (g_copyItemHttp.responseText.indexOf("NO COPY processing failed.") > -1) {
	        		alert(strLang241);
				}
				else {
		            if (event_copyItemList.cmd == "COPY") {
		                alert(strLang53);
		                start_search();
		            }
		            else {
		                alert(strLang53.replace(strLang251, strLang252));
		                start_search();
		            }
				}
				g_copyItemHttp = null;
	        }
	    }
	}

	function delete_mail()
	{
	    var selcheck = new Array();
	    var count = 0;
	    
	    if (GetChildNodes(resultTD).length == 0) {
	    	alert('<spring:message code="ezEmail.t637" />');
	        return;
	    }
	    
	    var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
	    for (var i = 0; i < Rows.length; i++) {
	        if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
	            selcheck[count] = Rows.item(i);
	            count++;
	        }
	    }
		
		if (count == 0)
		{
			alert('<spring:message code="ezEmail.t637" />');
			return;
		}

		var strItemID = "";

        for(i=0; i < count; i++)
        {
            strItemID += selcheck[i].getAttribute("itemid") + ",";
	    }
		var xmlHTTP = createXMLHttpRequest();
        var xmlDOM = createXmlDom();
        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID",strItemID );
		xmlHTTP.open("POST", "/ezEmail/mailDeleteS.do?cmd=BDELETE", false);
		xmlHTTP.send(xmlDOM);
		
		if (xmlHTTP.status < 200 || xmlHTTP.status > 300)
		    alert('<spring:message code="ezEmail.t638" />');
		else {
		    alert('<spring:message code="ezEmail.t604" />');
		    listContentArry = new Array();
		    start_search();
		}
	}

	function mail_export()
	{
		var selcheck = new Array();
		var count = 0;
	
		var mailcount = document.getElementById("maillist").childNodes[0].childNodes.length;
        		
		for (var i = 0; i < mailcount; i++) {
		    if (document.getElementById("checklol" + i + "").checked == true) {
		        selcheck[count] = document.getElementById("checklol" + i + "");
		        count++;
		    }
		}

		if (count == 0) 
		{
			alert('<spring:message code="ezEmail.t640" />');
			return;
		}	

		var param = {"href":new Array(), "parent":new Object(), "date":new Array(), "subject":new Array()};

		for(i=0; i <count; i++)
		{
		    param["href"][i] = ReplaceText(selcheck[i].parentElement.parentElement.getAttribute("targetURL"), "%25", "%");
		    if (CrossYN() || (pNoneActiveX == "YES")) {
		        href[i] = ReplaceText(selcheck[i].parentElement.parentElement.getAttribute("targetURL"), "%25", "%");
		        subject[i] = selcheck[i].parentElement.parentElement.childNodes[6].textContent;
		    }
		    else {
		        param["subject"][i] = selcheck[i].parentElement.parentElement.childNodes[6].innerText;
		        param["date"][i] = selcheck[i].parentElement.parentElement.childNodes[7].innerText;
		    }
		}
		if (CrossYN() || (pNoneActiveX=="YES")) {
		    PCMultiDownload();
		    return;
		}
		else {
		    param["parent"] = window;
		    var feature = "dialogWidth:480px; dialogHeight:240px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
		    feature = feature + GetShowModalPosition(480, 240);
		    window.showModalDialog("/myoffice/ezEmail/htm/mail_export.aspx", param, feature);
		}
	}

    var suffix = 0;
    var href = new Array();
    var subject = new Array();
    function PCMultiDownload() {
        if (suffix < href.length)
            setTimeout(function () { PC_Eml_FileDownload(href[suffix], subject[suffix]); }, 1000);
        else {
            suffix = 0;
            return;
        }
    }
    
    function PC_Eml_FileDownload(href, subject) {
        if (href != null) {
            subject = subject + ".eml";
            var fullpath = "/ezEmail/mailExport.do?url=" + encodeURIComponent(href) + "&filename=" + encodeURIComponent(subject);
            location.href = fullpath;
            suffix++;
            PCMultiDownload();
        }
        else {
            suffix = 0;
            return;
        }
    }

	function window_onbeforeprint()
	{
		normalblock.style.display = "none";
	}

	function window_onafterprint()
	{
		normalblock.style.display = "block";
	}
    function HiddenContextMenu() {
        document.getElementById("mailPanel").style.display = "none";
        document.getElementById("ContextMenuDiv").style.display = "none";
    }
    function ContextMenuHidden() {
        if (document.getElementById("ContextMenuDiv").style.display == "")
            HiddenContextMenu();
    }

    var usepostDate = false;
    function DateSearch_Click() {
        if(usepostDate){
            usepostDate = false;
            $("#Sdatepicker").datepicker('disable');
            $("#Edatepicker").datepicker('disable');
        }
        else {
            usepostDate = true;
            $("#Sdatepicker").datepicker('enable');
            $("#Edatepicker").datepicker('enable');
        }
    }

    var p_ListOrderObject;
    var p_ListOrderOption;
    var FirstClick = false;
    function event_HeaderClick(obj) {
        if (p_ListOrderObject != null) {
            FirstClick = false;
            if (p_ListOrderObject.childNodes.length > 1 && p_ListOrderObject.childNodes[1].nodeName == "IMG")
                p_ListOrderObject.childNodes.item(1).outerHTML = "";
        }
        else
            FirstClick = true;
        p_ListOrderObject = obj;
        p_ListOrderOption = p_ListOrderObject.getAttribute("orderoption");
        if (p_ListOrderOption == "DESC")
            p_ListOrderOption = "ASC";
        else if (p_ListOrderOption == "ASC")
            p_ListOrderOption = "DESC";
        else
            p_ListOrderOption = "DESC";

        p_ListOrderObject.setAttribute("orderoption", p_ListOrderOption);

        if (p_ListOrderObject.childNodes.length > 1 && p_ListOrderObject.childNodes[1].nodeName == "IMG") {
            if (p_ListOrderOption == "DESC")
                p_ListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortdown.gif");
            else
                p_ListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortup.gif");
        }
        else {
            var _HeaderSpanimg = document.createElement("IMG");
            if (p_ListOrderOption == "DESC")
                _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
            else
                _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");

            _HeaderSpanimg.setAttribute("align", "absmiddle");
            obj.appendChild(_HeaderSpanimg);
        }
        if (!FirstClick)
            start_search();
    }
</script>
</HEAD>

<body style="overflow:auto" id="theBody" class="mainbody"> 

<span id="normalblock"> 
<h1><spring:message code="ezEmail.t641" /></h1>
  <div id="mainmenu">
<ul>
  <li><span onclick="new_mail_onclick()"><spring:message code="ezEmail.t510" /></span></li>
  <li><span onClick="reply_mail_onclick()"><spring:message code="ezEmail.t511" /></span></li>
  <li><span onClick="all_reply_mail_onclick()"><spring:message code="ezEmail.t512" /></span></li>
  <li><span onClick="transmission_mail_onclick()"><spring:message code="ezEmail.t513" /></span></li>
  <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
  <li><span onClick="move_mail_onclick()"><spring:message code="ezEmail.t482" /></span></li>
  <li><span onClick="delete_mail()"><spring:message code="ezEmail.t156" /></span></li>
</ul>
</div>  
  <table class="content"> 
  <tr> 
    <th nowrap><spring:message code="ezEmail.t642" /></th> 
    <td width="100%">
      <select id="select2">
      <option value="ALL"><spring:message code="ezEmail.t643" /></option>      
      <c:forEach var="folderName" items="${topLevelFolderNames}" varStatus="status">
      <option value="${folderName}">
      	<c:choose>
    	<c:when test="${folderName eq 'INBOX'}">
    	<spring:message code="ezEmail.t99000025" />
      	</c:when>
      	<c:otherwise>
      	${folderName}
      	</c:otherwise>
      	</c:choose>      	
      </option>
      </c:forEach>
      </select>
      <select name="select" class="text" id="select"> 
        <option selected value="<spring:message code="ezEmail.t98" />"><spring:message code="ezEmail.t98" /></option> 
        <option value="<spring:message code="ezEmail.t649" />"><spring:message code="ezEmail.t649" /></option> 
        <option value="<spring:message code="ezEmail.t161" />"><spring:message code="ezEmail.t161" /></option> 
        <option value="<spring:message code="ezEmail.t650" />"><spring:message code="ezEmail.t651" /></option> 
      </select> 
      <input name="keyword" id = "keyword"  onkeyup="return search_keypress(event)"> 
      <a class="imgbtn"><span onClick="start_search()"><spring:message code="ezEmail.t37" /></span></a></td> 
  </tr> 
  <tr>
      <th><spring:message code="ezEmail.t653" /></th>
      <td><input type="checkbox" value="1" id="usepostdate" style="display:none;"> <a class="imgbtn"><span onclick="DateSearch_Click();"><spring:message code="ezEmail.t654" /></span></a>
          <input type="text" id="Sdatepicker" style="width:80px;text-align:center;"> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center;">
      </td>
  </tr>
</table> 
<br>
<h2 class="h2_dot"><spring:message code="ezEmail.t655" /><span id="resultCount"></span></h2>
    
<span id="printblock"> 
<table class="mainlist" style="width:100%;table-layout:fixed;">
	<tr> 
        <th style="width: 26px; padding: 0px; color: black;padding-left:3px;" align="center" nowrap title><input type="checkbox" onClick="check_change(this)" id="Checkbox1"></th>
        <th style="width: 26px; padding: 0px; color: black;padding-left:3px;cursor:pointer" align="center" nowrap title onclick="event_HeaderClick(this)" porp="importance" orderoption="ASC" ><img src="/images/ImgIcon/view-importance.gif" border="0"></th>
        <th style="width: 26px; padding: 0px; color: black;cursor:pointer" align="center" nowrap title onclick="event_HeaderClick(this)" porp="view" orderoption="ASC"><img src="/images/ImgIcon/view-document.gif" border="0"></th>
        <th style="width: 26px; padding: 0px; color: black;cursor:pointer" align="center" nowrap title onclick="event_HeaderClick(this)" porp="flag" orderoption="ASC"><img src="/images/ImgIcon/icon-flag.gif" border="0"></th>
        <th style="width: 26px; padding: 0px; color: black;cursor:pointer" align="center" nowrap title onclick="event_HeaderClick(this)" porp="attach" orderoption="ASC"><img src="/images/newAttach.gif" border="0"></th>
		<th style="width:80px;cursor:pointer" align="left" valign="center" id="tofromname" onclick="event_HeaderClick(this)" porp="from" orderoption="ASC"><spring:message code="ezEmail.t656" /></th> 
		<th style="width:100%;cursor:pointer" align="left" onclick="event_HeaderClick(this)" porp="subject" orderoption="ASC"><spring:message code="ezEmail.t556" /></th> 
		<th style="width:200px;cursor:pointer" align="left" id="tofromdate" onclick="event_HeaderClick(this)" porp="recevdate" orderoption="ASC"><spring:message code="ezEmail.t657" /></th> 
		<th style="width:120px;" align="left"><spring:message code="ezEmail.t658" /></th> 
		<th style="width:50px;cursor:pointer" align="left" onclick="event_HeaderClick(this)" porp="size" orderoption="ASC"><spring:message code="ezEmail.t617" /></th> 
	</tr> 
</table>
<div id='resultTD'> </div>
</span> 
<div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" onclick="ContextMenuHidden();" ></div>
<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
</div>
<div style="border:1px solid gray;width:450px;position:absolute;background-color:#ffffff;z-index:8000;text-align:center;display:none;" id="progressviewerRayer">
    <iframe src="/blank.htm" style="width:450px;height:170px;border:none" id="progressviewer"></iframe>
</div>
<script type="text/javascript">
    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
</script>
</body>
</HTML>

