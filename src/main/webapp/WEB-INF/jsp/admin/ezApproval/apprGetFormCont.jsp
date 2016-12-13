<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <title><spring:message code='ezApproval.t113'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/getFormCont_Cross.js"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var pDeptID;
	        var Rtnval = new Array();
	        var DocFileType = "${docFileType}";
	        var SERVER_NAME = "${serverName}";
	        var TreeIdx;
	        var ListIdx;
	        var ReturnFunction;
	        
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	
	        window.onload = function () {
	            Get_Favoritelist();
	            DocFileType = DocFileType.toLowerCase();
	            Tree_setconfig();
	            var pFormKind;
	
	            document.getElementById('divlvtForm').hotTrackColor = "#F7FAE0";
	            document.getElementById('divlvtForm').selectColor = "#ECF3BA";
	            pDeptID = "${userInfo.deptID}";
	                          
	            try {
	                dialogArguments = parent.getFormCont_dialogArguments[0];
	                ReturnFunction = parent.getFormCont_dialogArguments[1];
	            } catch (e) {
	                try {
	                    dialogArguments = opener.getFormCont_dialogArguments[0];
	                    ReturnFunction = opener.getFormCont_dialogArguments[1];
	                } catch (e) {                    
	                }
	            }
	
	            pFormKind = dialogArguments[1];
	
	            if (pFormKind == "A01004") {
	                document.getElementById('FromList').innerHTML = "";
	                var select = document.getElementById('FromList');
	                select.options[select.options.length] = new Option(strLangDocType4, 'A01004');
	                document.getElementById('FromList').value = "A01004";
	                document.getElementById('Localload').style.display = "none";
	                document.getElementById("1tab1").style.display = "none";
	                document.getElementById("1tab2").onclick();
	                document.getElementById("addfav").style.display = "none";
	            }
	            else if (pFormKind == "999") {
	                document.getElementById('Localload').style.display = "none";
	            }
	            else {
	                try {
	                    var cnt = document.getElementById('FromList').length;
	                    for (var i = 0; i < cnt; i++) {
	                        if (document.getElementById('FromList').options[i].value == "A01004")
	                            document.getElementById('FromList').options[i] = null;
	                    }
	                } catch (ErrMsg) {
	                }
	            }
	
	            if (CrossYN() || pNoneActiveX == "YES") {
	                document.getElementById('Localload').style.display = "none";
	            }
	            else {
	                if ("${useEditor}" != "")
	                    document.getElementById('Localload').style.display = "none";
	
	                Rtnval[0] = "cancel";
	                Rtnval[1] = "cancel";
	                window.returnValue = Rtnval;
	            }
	            InitFormCont();
	        }
	
	        function Tree_setconfig() {
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
	            xmlHTTP.send();
	
	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                var treeView = new TreeView();
	                treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
	            }
	        }
	
	        function select_onchange() {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            ID = treeNode.GetNodeData("DATA1");
	
	            if (pSelectTab == "favoritelist") {
	                Get_Favoritelist();
	            }
	            else {
	                if (TreeIdx != "") {
	                    var ID = treeNode.GetNodeData("DATA1");
	                    var KIND = document.getElementById('FromList').value;
	
	                    GetFormInfo(ID, KIND);
	                }
	            }
	        }
	
	        function TreeViewRequestData(pNodeID, pTreeID) {
	            TreeIdx = pNodeID;
	
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	
	
	            ID = treeNode.GetNodeData("DATA1");
	            DeptID = treeNode.GetNodeData("DATA2");
	            KIND = document.getElementById('FromList').value;
	
	
	            if (TreeIdx != "") {
	                GetFormContInfo(ID, DeptID, "REQUEST")
	            }
	            GetFormInfo(ID, KIND);
	        }
	        function TreeViewNodeClick(pNodeID) {
	            TreeIdx = pNodeID;
	
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	
	            ID = treeNode.GetNodeData("DATA1");
	            DeptID = treeNode.GetNodeData("DATA2");
	            KIND = document.getElementById('FromList').value;            
	            GetFormInfo(ID, KIND);
	        }
	        function TreeViewNodeClick(pNodeID, pNodeNM) {
	            TreeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            ID = treeNode.GetNodeData("DATA1");
	            DeptID = treeNode.GetNodeData("DATA2");
	            KIND = document.getElementById('FromList').value;
	            GetFormInfo(ID, KIND);
	        }
	
	        function lvtForm_Row_click(type) {
	            var listview = new ListView();
	
	            if (type.indexOf("FavForm") > 0)
	                listview.LoadFromID("lvtFavForm");
	            else
	                listview.LoadFromID("lvtForm");
	            var oArrRows = listview.GetSelectedRows();
	            var tr = oArrRows[0];
	
	            if (tr) {
	                if (type.indexOf("FavForm") > 0)
	                    document.getElementById('descrip2').innerHTML = GetAttribute(tr, "DATA2");
	                else
	                    document.getElementById('descrip').innerHTML = GetAttribute(tr, "DATA2");
	            }
	        }
	
	        function lvtForm_Row_Dbclick() {
	            btnOK_onclick();
	        }
	
	        function btnOK_onclick() {
	            var URL;
	            var listview = new ListView();
	            
	            if (pSelectTab == "favoritelist")
	                listview.LoadFromID("lvtFavForm");
	            else
	                listview.LoadFromID("lvtForm");
	
	            var oArrRows = listview.GetSelectedRows();
	            var tr = oArrRows[0];
	            if (tr) {
	                URL = GetAttribute(tr, "DATA4");
	                if ((DocFileType == "") || (URL.substr(URL.length - 3, URL.length).toLowerCase() == DocFileType)) {
	                    Rtnval[0] = GetAttribute(tr, "DATA4");
	                    Rtnval[1] = GetAttribute(tr, "DATA3");
	                    Rtnval[2] = GetAttribute(tr, "DATA1");
	                    Rtnval[3] = getNodeText(tr.childNodes[0]);
	                    Rtnval[4] = GetAttribute(tr, "DATA7");
	
	                    if (CrossYN() || pNoneActiveX == "YES") {
	                        try{
	                            if (navigator.userAgent.indexOf('Firefox') != -1)
	                                window.close();
	                            ReturnFunction(Rtnval);
	                        }
	                        catch (e) {
	                            window.returnValue = Rtnval;
	                        }
	                    }
	                    else {
	                        window.returnValue = Rtnval;
	                    }
	                    window.close();
	                }
	                else {
	                    if (DocFileType == "doc") {
	                        var pAlertContent = "<spring:message code='ezApproval.t595'/><br>MHT, HWP <spring:message code='ezApproval.t596'/>";
	                }
	                else if (DocFileType == "hwp") {
	                    var pAlertContent = "<spring:message code='ezApproval.t597'/><br>MHT, <spring:message code='ezApproval.t598'/>";
	                }
	                else {
	                    var pAlertContent = "MHT <spring:message code='ezApproval.t599'/><br>HWP, <spring:message code='ezApproval.t598'/>";
	                }
	            OpenAlertUI(pAlertContent);
	        }
	    }
	    else {
	        var pAlertContent = "<spring:message code='ezApproval.t600'/>";
	            OpenAlertUI(pAlertContent);
	        }
	
	    }
	
	        function btncancel_onclick() {
	            if (CrossYN() || pNoneActiveX == "YES")
	            {
	                try{
	                    ReturnFunction(Rtnval);
	                    window.close();
	                }
	                catch (e) {
	                    window.returnValue = Rtnval;
	                    window.close();
	                }
	            }
	            else
	            {
	                window.returnValue = Rtnval;
	                window.close();
	            }
	        }
	
	    function Localload_onclick() {
	        Rtnval[0] = "PC";
	        Rtnval[1] = "PC";
	        window.returnValue = Rtnval;
	        window.close();
	
	    }
	
	    var Tab1_SelectID = "";
	    var Tab1_flag = true;
	    function Tab1_MouserOver(obj) {
	        obj.className = "tabover";
	    }
	    function Tab1_MouserOut(obj) {
	        if (Tab1_SelectID != obj.id)
	            obj.className = "";
	    }
	    function Tab1_MouseClick(obj) {
	        obj.className = "tabon";
	        if (obj.id != Tab1_SelectID) {
	            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                document.getElementById(Tab1_SelectID).className = "";
	
	            obj.className = "tabon";
	            Tab1_SelectID = obj.id;
	            ChangeTab(obj);
	        }
	    }
	    function Tab1_NewTabIni(pTabNodeID) {
	        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
	                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
	                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
	                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
	                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;
	
	                    if (Tab1_flag) {
	                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
	                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
	                        Tab1_flag = false;
	                    }
	
	                }
	            }
	        }
	    }
	    var pSelectTab = "favoritelist";
	    var tempFromList;
	    var tempFromList2;
	    function ChangeTab(obj) {
	        pSelectTab = GetAttribute(obj, "divname");
	        switch (pSelectTab) {
	            case "favoritelist":
	                tempFromList = document.getElementById("FromList").selectedIndex;
	                document.getElementById("FromList").selectedIndex = tempFromList2;
	                document.getElementById("favoritetable").style.display = "";
	                document.getElementById("formtable").style.display = "none";
	                document.getElementById("delfav").style.display = "";
	                document.getElementById("addfav").style.display = "none";
	                break;
	            case "formlist":
	                tempFromList2 = document.getElementById("FromList").selectedIndex;
	                document.getElementById("FromList").selectedIndex = tempFromList;
	                document.getElementById("favoritetable").style.display = "none";
	                document.getElementById("formtable").style.display = "";
	                document.getElementById("delfav").style.display = "none";
	                document.getElementById("addfav").style.display = "";
	                break;
	        }
	    }
	
	    function savefavoriteforminfo() {
	        var listview = new ListView();
	        listview.LoadFromID("lvtForm");
	        var oArrRows = listview.GetSelectedRows();
	        var tr = oArrRows[0];
	
	        var xmlpara = createXmlDom();
	        var xmlHTTP = createXMLHttpRequest();
	        var objNode;
	
	        createNodeInsert(xmlpara, objNode, "PARAMETER");
	        createNodeAndInsertText(xmlpara, objNode, "FORMID", GetAttribute(tr, "data1"));
	        createNodeAndInsertText(xmlpara, objNode, "FORMNAME", GetAttribute(tr, "data5"));
	        createNodeAndInsertText(xmlpara, objNode, "FORMNAME2", GetAttribute(tr, "data6"));
	        createNodeAndInsertText(xmlpara, objNode, "FORMDESCRIPTION", GetAttribute(tr, "data2"));
	        createNodeAndInsertText(xmlpara, objNode, "FORMDOCTYPE", GetAttribute(tr, "data3"));
	        createNodeAndInsertText(xmlpara, objNode, "FORMFILELOCATION", GetAttribute(tr, "data4"));
	
	        xmlHTTP.open("Post", "/myoffice/ezApproval/formContainer/aspx/svaefavoriteform.aspx", false);
	        xmlHTTP.send(xmlpara);
	
	        if (xmlHTTP.responseText == "OK") {
	            tempFromList2 = "0";
	            OpenAlertUI("<spring:message code='ezApproval.t390'/>");
	            Get_Favoritelist();            
	        }
	        else if (xmlHTTP.responseText == "0")
	        {
	            tempFromList2 = "0";
	            OpenAlertUI("<spring:message code='ezApproval.t667'/>");
	            Get_Favoritelist();            
	        }
	        else
	            OpenAlertUI("<spring:message code='ezApproval.t278'/>");
	    }
	
	    var xmlhttp2 = createXMLHttpRequest();
	    function Get_Favoritelist(type) {
	        xmlhttp2 = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	        var objNode;
	
	        createNodeInsert(xmlpara, objNode, "PARAMETER");
	
	        if (type == "1") {
	            createNodeAndInsertText(xmlpara, objNode, "KIND", document.getElementById('FromList').value);
	            createNodeAndInsertText(xmlpara, objNode, "SEARCHTYPE", document.getElementById('searchoption').selectedIndex);
	            createNodeAndInsertText(xmlpara, objNode, "SEARCHNAME", document.getElementById('forminfo').value);
	        }
	        else {
	            createNodeAndInsertText(xmlpara, objNode, "KIND", document.getElementById('FromList').value);
	            createNodeAndInsertText(xmlpara, objNode, "SEARCHTYPE", "");
	            createNodeAndInsertText(xmlpara, objNode, "SEARCHNAME", "");
	        }
	
	        xmlhttp2.open("Post", "/myoffice/ezApproval/formContainer/aspx/getfavoriteform.aspx", true);
	        xmlhttp2.onreadystatechange = event_Get_Favoritelist;
	        xmlhttp2.send(xmlpara);
	    }
	
	    function event_Get_Favoritelist() {
	        if (xmlhttp2 == null || xmlhttp2.readyState != 4) {
	            return;
	        }
	        document.getElementById("divlvtFavForm").innerHTML = "";
	        var listview = new ListView();
	        listview.SetID("lvtFavForm");
	        listview.SetMulSelectable(false);
	        listview.SetRowOnClick("lvtForm_Row_click");
	        listview.SetRowOnDblClick("lvtForm_Row_Dbclick");
	        listview.DataSource(loadXMLString(xmlhttp2.responseText));
	        listview.DataBind("divlvtFavForm");
	
	        var oArrRows = listview.GetSelectedRows();
	        var tr = oArrRows[0];
	
	        if (tr) {
	            listview.SetSelectFlag(true);
	            document.getElementById('descrip2').innerHTML = GetAttribute(tr, "DATA2");
	        }
	    }
	
	    function delfavoriteforminfo() {
	        var listview = new ListView();
	        listview.LoadFromID("lvtFavForm");
	        var selrow = listview.GetSelectedRows()[0];
	
	        if (!selrow) {
	            OpenAlertUI("<spring:message code='ezApproval.t599'/>");
	            return;
	        }
	
	        var xmlpara = createXmlDom();
	        var xmlHTTP = createXMLHttpRequest();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETER");
	        createNodeAndInsertText(xmlpara, objNode, "FORMID", GetAttribute(selrow, "data1"));
	
	        xmlHTTP.open("Post", "/myoffice/ezApproval/formContainer/aspx/delfavoriteform.aspx", false);
	        xmlHTTP.send(xmlpara);
	
	        if (xmlHTTP.responseText != "OK")
	            OpenAlertUI("<spring:message code='ezApproval.t652'/>");
	        else {
	            OpenAlertUI(strLang598);
	            Get_Favoritelist();
	        }
	    }
	
	    function searchform() {
	        var treeNode = new TreeNode();
	        treeNode.LoadFromID(TreeIdx);
	        ID = treeNode.GetNodeData("DATA1");
	
	        if (TreeIdx != "") {
	            if (document.getElementById('forminfo').value == "") {
	                OpenAlertUI(strLang554);
	                return;
	            }
	
	            if (pSelectTab == "favoritelist") {
	                Get_Favoritelist('1');
	            }
	            else {
	                var ID = "ALL";
	                var KIND = document.getElementById('FromList').value;
	                var searchtype = document.getElementById('searchoption').selectedIndex;
	                var searchname = document.getElementById('forminfo').value;
	
	                GetFormInfo(ID, KIND, searchtype, searchname);
	            }
	        }
	    }
	
	    function reset() {
	        document.getElementById('forminfo').value = "";
	        if (pSelectTab == "favoritelist") {
	            Get_Favoritelist();
	        }
	        else {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            ID = treeNode.GetNodeData("DATA1");
	
	            var ID = treeNode.GetNodeData("DATA1");
	            var KIND = document.getElementById('FromList').value;
	            
	            GetFormInfo(ID, KIND, "", "");            
	        }
	    }
	
	    function search_press(evt) {
	        if (window.event) {
	            if (window.event.keyCode == 13) {
	                searchform();
	            }
	        }
	        else {
	            if (evt.which == 13)
	                searchform();
	        }
	
	    }
	    </script>
	</head>
	<body class="popup">
	    <xml id='FORMLIST' style="display: none">
	  <LISTVIEWDATA>
	    <HEADERS>
	      <HEADER>
	        <NAME><spring:message code='ezApproval.t601'/></NAME>
	        <WIDTH>215</WIDTH>
	      </HEADER>
	    </HEADERS>
	  </LISTVIEWDATA>
	</xml>
	    <xml id='FORMCONTAINER' style="display: none">
	  <TREEVIEWDATA>
	    <NODE>
	      <EXPANDED>TRUE</EXPANDED>
	      <ISLEAF>FALSE</ISLEAF>
	      <VALUE><spring:message code='ezApproval.t602'/></VALUE>
	    </NODE>
	  </TREEVIEWDATA>
	</xml>
	    <h1><spring:message code='ezApproval.t113'/></h1>
	
	    <table class="content" style="width: 684px;">
	        <tr>
	            <th><spring:message code='ezApproval.t603'/></th>
	            <td>
	                <select name="select" onchange="return select_onchange()" id="FromList" style="width: 100px;">
	                    <option value="A01000" selected><spring:message code='ezApproval.t604'/></option>
	                    ${docType}
	                </select>
	            </td>
	            <td style="white-space:nowrap">
	                <select id="searchoption">
	                    <option value ="1"><spring:message code='ezApproval.t433'/></option>
	                    <option value ="2"><spring:message code='ezApproval.t507'/></option>
	                </select>
	                <input id="forminfo" onkeypress="search_press(event)" type="text" />
	                <a class="imgbtn" onclick="searchform()"><span><spring:message code='ezApproval.t236'/></span></a>
	                <a class="imgbtn" onclick="reset()"><span><spring:message code='ezApproval.t397'/></span></a>
	            </td>
	        </tr>
	    </table>
	      <div class="portlet_tabpart01" style="margin-top:3px;width:684px">
	        <div class="portlet_tabpart01_top" id="tab1">
	            <p><span id="1tab1" divname="favoritelist"><spring:message code='ezApproval.t1100'/></span></p>
	            <p><span id="1tab2" divname="formlist"><spring:message code='ezApproval.t601'/></span></p>
	            <div style="float:right">
	                <a id="addfav" class="imgbtn" onclick="savefavoriteforminfo()" style="display:none"><span><spring:message code='ezApproval.t00001'/></span></a>
	                <a id="delfav" class="imgbtn" onclick="delfavoriteforminfo()"><span><spring:message code='ezApproval.t00002'/></span></a>
	            </div>
	        </div>
	    </div>
	    <table id="favoritetable" style="margin-top: 5px; width: 684px;">
	        <tr>
	           <td style="padding-right: 1px; vertical-align: top;">
	                <div class="border_gray">
	                    <div id="divlvtFavForm" style="border: 0; WIDTH: 100%; HEIGHT: 356px; overflow-x: auto; overflow-y: auto; padding: 0px"></div>
	                </div>
	            </td>
	        </tr>
	         <tr>
	             <td style="vertical-align: top; padding-top:3px;">
	                 <table class="content">
	                     <tr>
	                         <th><spring:message code='ezApproval.t605'/></th>
	                         <td id="descrip2" style="width: 100%">&nbsp;</td>
	                     </tr>
	                 </table>
	             </td>
	         </tr>
	    </table>
	    <table id="formtable" style="margin-top: 5px; width: 684px;display:none">
	        <tr>
	            <td rowspan="2" style="vertical-align: top;">
	                <div id="divFromTreeView" style="height: 390px; width: 280px; overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff;"></div>
	            </td>
	            <td style="padding-left: 5px; padding-right: 1px; vertical-align: top;">
	                <div class="border_gray">
	                    <div id="divlvtForm" style="border: 0; WIDTH: 100%; HEIGHT: 356px; overflow-x: auto; overflow-y: auto; padding: 0px"></div>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding-left: 5px; vertical-align: top; padding-top: 3px;">
	                <table class="content">
	                    <tr>
	                        <th><spring:message code='ezApproval.t605'/></th>
	                        <td id="descrip" style="width: 320px">&nbsp;</td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a id="Localload" class="imgbtn" onclick="return Localload_onclick()"><span><spring:message code='ezApproval.t606'/></span></a>
	        <a id="btnOK" class="imgbtn" onclick="return btnOK_onclick()"><span><spring:message code='ezApproval.t84'/></span></a>
	        <a id="btncancel" class="imgbtn" onclick="return btncancel_onclick()"><span><spring:message code='ezApproval.t85'/></span></a>
	    </div>
	    <script type="text/javascript">
	        Tab1_NewTabIni("tab1");
		</script>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>