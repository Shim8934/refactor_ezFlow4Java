<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>popupCommHome</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/community.css" type="text/css">
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var strlang = "<c:out value='${userInfo.lang }'/>";
			var xmlDomTreeView = createXmlDom();
			var treedate = "${retXML }";
			var code = "<c:out value='${code }'/>";
			var userLevel = "<c:out value='${userLevel }'/>";
			var chCommunityAdmin = "<c:out value='${fn:indexOf(userInfo.rollInfo, \'t=1\') }'/>";
			var codeName = "<c:out value='${codeName }'/>";
			var chCheckSysop = "<c:out value='${checkSysop }'/>";
			var newmemberConfirmType = "<c:out value='${newMemberConfirmType }'/>";
			var joinFlag = "<c:out value='${joinFlag }'/>";
// 			안쓰면 삭제
			var xmlhttp;
			var xmlhttp2;
			
			var strLang1 = "<spring:message code='ezCommunity.t78' />";
		    var strLang2 = "<spring:message code='ezCommunity.t1082' />"; 
		    var strLang3 = "<spring:message code='ezCommunity.t1103' />"; 
		    var strLang4 = "<spring:message code='ezCommunity.t2009' />"; 
		    var strLang5 = "<spring:message code='ezCommunity.t1102' />"; 
		    
		    $(function () {
		        xmlhttp = createXMLHttpRequest();

		        var xmlDom = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "CODE", code);

		        xmlhttp.open("POST", "/ezCommunity/commHome/commHomeInfo.do", true);

		        xmlhttp.onreadystatechange = event_get_commhomeinfo;
		        xmlhttp.send(xmlDom);

		        xmlhttp2 = createXMLHttpRequest();

		        var xmlDom = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "CODE", code);

		        xmlhttp2.open("POST", "/ezCommunity/commHome/commHomeBoardInfo.do", true);

		        xmlhttp2.onreadystatechange = event_get_homeboardinfo;
		        xmlhttp2.send(xmlDom);

		        var treedom = loadXMLString(treedate);

		        if (SelectNodes(treedom, "TREEVIEWDATA/NODE").length > 0) {
		            for (var i = 0; i < SelectNodes(treedom, "TREEVIEWDATA/NODE").length; i++) {
		                var h2 = document.createElement("H2");
		                var span = document.createElement("SPAN");
		                var img = document.createElement("IMG");
		                img.src = "/images/kr/community/type1/icon_board.gif";
		                img.style.width = "16px";
		                img.style.height = "16px";
		                span.appendChild(img);
		                span.innerHTML += SelectSingleNodeValue(SelectNodes(treedom, "TREEVIEWDATA/NODE")[i], "DATA2");
		                h2.appendChild(span);
		                //h2.appendChild(img);
		                var treeid = SelectSingleNodeValue(SelectNodes(treedom, "TREEVIEWDATA/NODE")[i], "DATA1");
		                h2.className = "off";
		                h2.id = treeid;
		                h2.setAttribute("TreeCtrl", "TreeCtrl" + i);
		                //h2.innerHTML += SelectSingleNodeValue(SelectNodes(treedom, "TREEVIEWDATA/NODE")[i], "DATA2");
		                h2.onclick = function () { TopBoard_onclick(this); };

		                var div = document.createElement("DIV");
		                div.className = "tree";
		                div.id = "TreeCtrl" + i + "obj";
		                div.style.display = "none";
		                div.style.overflow = "auto";
		                document.getElementById("treediv").appendChild(h2);
		                document.getElementById("treediv").appendChild(div);
		            }
		        }
		    });
		    
		    function event_get_commhomeinfo() {
		        if (xmlhttp == null || xmlhttp.readyState != 4) {
		            return;
		        }
		        if (xmlhttp.status >= 200 && xmlhttp.status < 300) {
		            var xmldom = loadXMLString(xmlhttp.responseText);
		            
		            var _img = document.createElement("img");
		            _img.id = "coplogo";
		            _img.style.width = "894px";
		            _img.style.height = "100px";

		            if (SelectSingleNodeValueNew(xmldom, "DATA/C_LOGO").indexOf("default_logo_type") > -1) {
		                _img.src = "/images/ezCommunity/logo/" + SelectSingleNodeValueNew(xmldom, "DATA/C_LOGO");
		                //document.getElementById("coplogo").src = "/images/default_logo.jpg";
		            } else {
		                _img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYLOGO&fileName=" +  SelectSingleNodeValueNew(xmldom, "DATA/C_LOGO");
		            }
		            
		            document.getElementById("homeimg").appendChild(_img);

		            if (strlang == "" || strlang == "1") {
		                document.getElementById("copname").innerHTML = SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBNAME");
		                document.title = SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBNAME");
		            } else {
		                document.getElementById("copname").innerHTML = SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBNAME2");
		                document.title = SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBNAME2");
		            }

		            document.getElementById("mastericon").onclick = function () { openInfo(SelectSingleNodeValueNew(xmldom, "DATA/MEMBER/USERID")); };
		            document.getElementById("mastername").innerHTML = SelectSingleNodeValueNew(xmldom, "DATA/MEMBER/USERNAME");
		            document.getElementById("master").innerHTML += "(" + SelectSingleNodeValueNew(xmldom, "DATA/MEMBER/DEPTNAME") + ")";
		            document.getElementById("regdate").innerHTML =  strLang1 + ": " + SelectSingleNodeValueNew(xmldom, "DATA/C_REGDATE").substring(0, 10);
		            document.getElementById("membercnt").innerHTML =  SelectSingleNodeValueNew(xmldom, "DATA/C_MEMBERCNT");
		            document.getElementById("itemcnt").innerHTML = SelectSingleNodeValueNew(xmldom, "DATA/ITEMCNT");

		            var userImage = SelectSingleNodeValueNew(xmldom, "DATA/MEMBER/USERIMAGE").trim();

		            var _img = document.createElement("img");
		            if (userImage != "") {
		                _img.src = "/admin/ezOrgan/getPersonalInfo.do?type=PERSONAL&fileName=" + userImage;
		            } else {
		                _img.src = "/images/OrganTree/porson_noimg.gif";
		            }
		            
		            _img.style.width = "51px";
		            _img.style.height = "54px";

		            document.getElementById("pic").appendChild(_img);
					var sConfirmType = "";
					
		            switch (SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBCONFIRMTYPE").trim()) {
		                case "2":
		                    sConfirmType = "<spring:message code='ezCommunity.t699' />";
		                break;
		            case "3":
		                sConfirmType = "<spring:message code='ezCommunity.t14' />";
		                break;
		        	}
		            
		        	switch (SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBGUBUN").trim()) {
			            case "1":
			                document.getElementById("cpublic").innerHTML = "<spring:message code='ezCommunity.t700' />" + "<spring:message code='ezCommunity.t701' />";
			                break;
			            case "2":
			                document.getElementById("cpublic").innerHTML = "<spring:message code='ezCommunity.t700' />" + "<spring:message code='ezCommunity.t702' />" + sConfirmType;
			                break;
			            case "3":
			                document.getElementById("cpublic").innerHTML = "<spring:message code='ezCommunity.t700' />" + "<spring:message code='ezCommunity.t703' />" + sConfirmType;
			                break;
		        	}
		        	
		        	document.getElementById("copdesc").innerHTML = SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBDESC");
		        }
		    }
		    
		    function openInfo(userid) {
		        var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=420,height=440";
		        feature = feature + GetOpenPosition(420, 440);
				window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", feature);
		    }
		    
		    var tempboard = "";
		    function TopBoard_onclick(val) {
		        if (tempmenuid != "") {
		            document.getElementById(tempmenuid).className = "off";
		        }
		        
		        tempmenuid = "";
		        
		        if (tempboard != "" && val.id != tempboard.id) {
		            tempboard.className = "off";
		            document.getElementById(tempboard.getAttribute("TreeCtrl") + "obj").style.display = "none";
		        }
		        
		        var obj = val.getAttribute("TreeCtrl");
		        var ID = val.id;
		        
		        if (val.className == "on") {
		            val.className = "off";
		            document.getElementById(obj + "obj").style.display = "none";
		        } else {
		            val.className = "on";
		            document.getElementById(obj + "obj").style.display = "";
		        }
		        
		        tempboard = val;
		        document.getElementById(obj + "obj").innerHTML = "";
		        SetTreeConfig();
		        var treeView = new TreeView();
		        treeView.SetID("TreeView" + obj);
		        treeView.SetRequestData("TreeCtrl_onNodeExpanded");
		        treeView.SetNodeClick("TreeCtrl_onNodeClick");
		        treeView.DataSource(GetSubBoard(ID, "1"));
		        treeView.DataBind(obj + "obj");
		    }
		    
		    function SetTreeConfig() {
		        xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);
		        xmlhttp.send();

		        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlhttp.responseXML);
		        }
		    }
		    
		    function GetSubBoard(pRootBoardID, pSubFlag) {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezCommunity/getSubBoards.do?rootBoardID=" + pRootBoardID + "&subFlag=" + pSubFlag + "&selectFlag=0&classID=" + code, false);
		        xmlhttp.send();

		        return xmlhttp.responseXML;
		    }
		    
		    function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
		        var xmlRtn = createXmlDom();
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1")

		        var treeView = new TreeView();
		        treeView.LoadFromID(pTreeID);
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
		    }
		    
		    function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
		        try {
		            var treeNode = new TreeNode();
		            treeNode.LoadFromID(pNodeID);

		            var SelectedBoardID = treeNode.GetNodeData("DATA1");
		            var SelectedBoardParentBoardID = treeNode.GetNodeData("DATA3");
		            var chkPhotoBrd = treeNode.GetNodeData("DATA6")
		            document.getElementById("copmaindesc").style.display = "none";
		            document.getElementById("rightfrm").style.display = "";
		            document.getElementById("mainboard").style.display = "none";
		            document.getElementById("makeguide").style.display = "none";
		            
		            document.getElementById("rightfrm").style.height = "659px";
		            if (chkPhotoBrd != "3") {
		                document.getElementById("rightfrm").src = "/ezCommunity/boardItemList.do?boardID=" + treeNode.GetNodeData("DATA1") + "&boardName=" + encodeURI(treeNode.GetNodeData("DATA2")) + "&code=" + code;
		            } else {
		                document.getElementById("rightfrm").src = "/ezCommunity/boardItemListPhoto.do?boardID=" + treeNode.GetNodeData("DATA1") + "&boardName=" + encodeURI(treeNode.GetNodeData("DATA2")) + "&code=" + code;
		            }
		            
		            if (CrossYN()) {
		            }
		            else {
		                window.event.cancelBubble = true;
		                window.event.returnValue = false;
		            }
		        }
		        catch (e) {
		            alert(e.description);
		        }
		    }
		    
		    var tempmenuid = "";
		    function go_menu(btn) {
		        if (chCommunityAdmin < 0 && (userLevel == "0" || userLevel == "9")) {
		            switch (btn.id) {
		                case "btn_QsPoll": document.getElementById("rightfrm").src = "/ezCommunity/pollMain.do?code=" + code + "&codeName=" + codeName + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_MemberInfo": alert(strLang5);
		                    break;
		                case "btn_MemberOut": alert(strLang5);
		                    break;
		                case "btn_home": document.getElementById("rightfrm").src = "/ezCommunity/commHome/commHome.do?code=" + code + "&codeName=" + codeName + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_guest": document.getElementById("rightfrm").src = "/ezCommunity/guestOne.do?code=" + code, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_MemberIn":
		                    if (joinFlag.toUpperCase() == "TRUE") {
		                        alert(strLang2);
		                        return;
		                    }
		                    
		                    var wWeight = "330";
		                    var wHeight = "170";
		                    var heigth = window.screen.availHeight;
		                    var width = window.screen.availWidth;
		                    var left = (width - wWeight) / 2;
		                    var top = (heigth - wHeight) / 2;
		                    
		                    if (newMemberConfirmType == "2") {
		                        window.open("/ezCommunity/join1.do?no=" + code, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		                    } else if (newMemberConfirmType == "3") {
		                        window.open("/ezCommunity/join2.do?no=" + code, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		                    }
		                    
		                    break;
		                case "btn_MemberJoinIng":
		                    alert(strLang5);
		                    break;
		                case "btn_Manager_home1": open_admin_home(code, "2");
		                    break;
		                case "btn_Manager_home2": open_admin_home(code, "10");
		                    break;
		                default: document.getElementById("rightfrm").src = "/ezCommunity/commHome/commHome.do?code=" + code + "&codeName=" + codeName + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		            }
		        } else {
		            switch (btn.id) {
		                case "btn_QsPoll": document.getElementById("rightfrm").src = "/ezCommunity/pollMain.do?code=" + code + "&codeName=" + codeName + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_MemberInfo": document.getElementById("rightfrm").src = "/ezCommunity/commViewMember.do?code=" + code + "&codeName=" + codeName, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_MemberOut":
		                    if (chCheckSysop.toUpperCase() == "TRUE") {
		                        alert(strLang3);
		                    } else {
		                        go_MemberOut(code);
		                    }
		                    
		                    break;
		                case "btn_Manager": open_admin(code);
		                    break;
		                case "btn_Manager_home1": open_admin_home(code,"2");
		                    break;
		                case "btn_Manager_home2": open_admin_home(code,"10");
		                    break;
		                case "btn_home": document.getElementById("rightfrm").src = "/ezCommunity/commHome/commHome.do?code=" + code + "&codeName=" + codeName + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_guest": document.getElementById("rightfrm").src = "/ezCommunity/guestOne.do?code=" + code, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_MemberIn":
		                    if (joinFlag.toUpperCase() == "TRUE") {
		                        alert(strLang2);
		                        return;
		                    }
		                    
		                    var wWeight = "330";
		                    var wHeight = "170";
		                    var heigth = window.screen.availHeight;
		                    var width = window.screen.availWidth;
		                    var left = (width - wWeight) / 2;
		                    var top = (heigth - wHeight) / 2;
		                    
		                    if (newMemberConfirmType == "2") {
		                        window.open("/ezCommunity/join1.do?no=" + code, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		                    } else if (newMemberConfirmType == "3") {
		                        window.open("/ezCommunity/join2.do?no=" + code, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		                    }
		                    
		                    break;
		                case "btn_MemberJoinIng":
		                    alert(strLang5);
		                    break;
		                default: document.getElementById("rightfrm").src = "/ezCommunity/commHome/commHome.do?code=" + code + "&codeName=" + codeName + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		            }
		        }
		    }
		    
		    function go_MemberOut(code) {
		        var xmlHttp = createXMLHttpRequest();
		        var xmlDoc = createXmlDom();

		        var objRoot;
		        createNodeInsert(xmlDoc, objRoot, "PARAMETER");

		        createNodeAndInsertText(xmlDoc, objRoot, "CODE", code);
		        xmlHttp.open("POST", "/ezCommunity/goAdminOk.do", false);
		        xmlHttp.send(xmlDoc);

		        resultXML = loadXMLString(xmlHttp.responseText);
		        
		        var master = "";
		        
		        master = SelectNodes(resultXML, "/COMMUNITY/MASTER/VALUE").item(0).textContent;
		        
		        master = master.toLowerCase();
		        userID = "<c:out value='${userinfo.id }'/>";
		        userID = userID.toLowerCase();

		        try {
		            if (userID == master) {
		                alert("Community <spring:message code='ezCommunity.t1103' />");
		            } else {
		                var wWeight = "425";
		                var wHeight = "385";
		                var heigth = window.screen.availHeight;
		                var width = window.screen.availWidth;
		                var left = (width - wWeight) / 2;
		                var top = (heigth - wHeight) / 2;

		                var Para = window.open("/ezCommunity/commOut.do?code=" + code, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		            }
		        } catch (e) { }
		    }
		    
		    function open_admin(code) {
		        var wWeight = "840";
		        var wHeight = "510";
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - wWeight) / 2;
		        var top = (heigth - wHeight) / 2;

		        var comm = window.open("/ezCommunity/admin/index.do?code=" + code + "&codeName=" + codeName, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		    }

		    function open_admin_home(code, num) {
		        if (chCheckSysop.toUpperCase() == "FALSE") {
		            alert(strLang4);
		            return;
		        }
		        var wWeight = "840";
		        var wHeight = "510";
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - wWeight) / 2;
		        var top = (heigth - wHeight) / 2;

		        var comm = window.open("/ezCommunity/admin/index.do?code=" + code + "&codeName=" + codeName + "&num=" + num, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		    }
		    
		    function event_get_homeboardinfo() {
		        if (xmlhttp2 == null || xmlhttp2.readyState != 4) {
		            return;
		        }
		        if (xmlhttp2.status >= 200 && xmlhttp2.status < 300) {
		            var xmldom = loadXMLString(xmlhttp2.responseText);

		            if (SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW").length > 0) {
		                document.getElementById("mainboard").style.display = "";
		                document.getElementById("makeguide").style.display = "none";
		                for (i = 0; i < SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW").length; i++) {
		                    var div = document.createElement("DIV");
		                    div.className = "boare_area";

		                    if (i + 1 != SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW").length && SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "SN") == SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i + 1], "SN")) {
		                        for (var k = 0; k < 2; k++) {
		                            var div2 = document.createElement("DIV");
		                            
		                            if (SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "SHOWPOSITION") == "1") {
		                                if (SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "GUBUN") != "3") {
		                                    div2.className = "f_left btype_list";
		                                } else {
		                                    div2.className = "f_left btype_photo";
		                                }
		                            } else {
		                                if (SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "GUBUN") != "3") {
		                                    div2.className = "f_right btype_list";
		                                } else {
		                                    div2.className = "f_right btype_photo";
		                                }
		                            }

		                            var p = document.createElement("P");
		                            p.className = "title";
		                            
		                            if (strlang == "" || strlang == "1") {
		                                p.innerHTML = SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "BOARDNAME");
		                            } else {
		                                p.innerHTML = SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "BOARDNAME2");
		                            }

		                            var span = document.createElement("SPAN");
		                            span.className = "more";
		                            span.setAttribute("boardid", SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "BOARDID"));
		                            span.setAttribute("boardname", SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "BOARDNAME"));
		                            span.setAttribute("gubun", SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "GUBUN"));
		                            span.onclick = function () { moreclick(this); };

		                            var img = document.createElement("IMG");
		                            img.src = "/images/kr/community/type1/btn_more.gif";
		                            img.style.width = "40px";
		                            img.style.height = "16px";

		                            span.appendChild(img);
		                            p.appendChild(span);

		                            var ul = document.createElement("UL");
	                                var isdata = SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i].textContent;

		                            if (isdata.trim() != "") {
		                                var imageCnt = 0;
		                                
		                                for (var j = 0; j < GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i]).length; j++) {
		                                    var li = document.createElement("LI");

		                                    var span2 = document.createElement("SPAN");
		                                    var span3 = document.createElement("SPAN");
		                                    
		                                    if (SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "GUBUN") != "3") {
		                                        span2.className = "txt";
		                                        span2.innerHTML = SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "TITLE");
		                                        span2.setAttribute("itemid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "ITEMID"));
		                                        span2.setAttribute("boardid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "BOARDID"));
		                                        span2.setAttribute("gubun", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "GUBUN"));
		                                        span2.setAttribute("code", code);
		                                        span2.style.cursor = "pointer";
		                                        span2.onclick = function () { ItemRead_onclick(this); };

		                                        span3.className = "date";
		                                        span3.innerHTML = SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "WRITEDATE").substring(0, 10);
		                                    } else {
		                                        if (imageCnt == 4) {
		                                            break;
		                                        }
		                                        
		                                        span2.className = "photo";
		                                        span2.setAttribute("itemid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "ITEMID"));
		                                        span2.setAttribute("boardid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "BOARDID"));
		                                        span2.setAttribute("gubun", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "GUBUN"));
		                                        span2.setAttribute("code", code);
		                                        span2.style.cursor = "pointer";
		                                        span2.onclick = function () { ItemRead_onclick(this); };

		                                        var img = document.createElement("IMG");
		                                        var imgUrl = SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "EXTENSIONATTRIBUTE5");
		                                        
		                                        img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&boardID=" + SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "BOARDID") + "&fileName=" + imgUrl.split('/')[imgUrl.split('/').length - 1];
		                                        img.style.width = "68px";
		                                        img.style.height = "68px";

		                                        span2.appendChild(img);
		                                        span3.className = "ptxt";
		                                        span3.innerHTML = SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "TITLE");
		                                        span3.setAttribute("itemid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "ITEMID"));
		                                        span3.setAttribute("boardid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "BOARDID"));
		                                        span3.setAttribute("gubun", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "GUBUN"));
		                                        span3.setAttribute("code", code);
		                                        span3.onclick = function () { ItemRead_onclick(this); };
		                                        imageCnt++;
		                                    }

		                                    li.appendChild(span2);
		                                    li.appendChild(span3);

		                                    ul.appendChild(li);
		                                    div2.appendChild(p);
		                                    div2.appendChild(ul);
		                                    div.appendChild(div2);
		                                    document.getElementById("mainboard").appendChild(div);
		                                }
		                            } else {
		                                div2.appendChild(p);
		                                div2.appendChild(ul);
		                                div.appendChild(div2);
		                                document.getElementById("mainboard").appendChild(div);
		                            }
		                            
		                            if (k == 0) {
		                                i++;
		                            }
		                        }
		                    } else {
		                        var div2 = document.createElement("DIV");
		                        
		                        if (SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "SHOWPOSITION") == "1") {
		                            if (SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "GUBUN") != "3") {
		                                div2.className = "f_left btype_list";
		                            } else {
		                                div2.className = "f_left btype_photo";
		                            }
		                        } else {
		                            if (SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "GUBUN") != "3") {
		                                div2.className = "f_right btype_list";
		                            } else {
		                                div2.className = "f_right btype_photo";
		                            }
		                        }

		                        var p = document.createElement("P");
		                        p.className = "title";
		                        
		                        if (strlang == "" || strlang == "1"){
		                            p.innerHTML = SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "BOARDNAME");
		                        } else {
		                            p.innerHTML = SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "BOARDNAME2");
		                        }
		                        
		                        var span = document.createElement("SPAN");
		                        span.className = "more";
		                        span.setAttribute("boardid", SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "BOARDID"));
		                        span.setAttribute("boardname", SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "BOARDNAME"));
		                        span.setAttribute("gubun", SelectSingleNodeValue(SelectNodes(xmldom, "ITEM/BOARDINFO/DATA/ROW")[i], "GUBUN"));
		                        span.onclick = function () { moreclick(this); };
		                        var img = document.createElement("IMG");
		                        img.src = "/images/kr/community/type1/btn_more.gif";
		                        img.style.width = "40px";
		                        img.style.height = "16px";

		                        span.appendChild(img);
		                        p.appendChild(span);

		                        var ul = document.createElement("UL");
		                        var isdata = SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i].textContent;

		                        if (isdata.trim() != "") {
		                            var imageCnt = 0;
		                            
		                            for (var j = 0; j < GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i]).length; j++) {
		                                var li = document.createElement("LI");

		                                var span2 = document.createElement("SPAN");
		                                var span3 = document.createElement("SPAN");
		                                
		                                if (SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "GUBUN") != "3") {
		                                    span2.className = "txt";
		                                    span2.innerHTML = SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "TITLE");
		                                    span2.setAttribute("itemid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "ITEMID"));
		                                    span2.setAttribute("boardid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "BOARDID"));
		                                    span2.setAttribute("gubun", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "GUBUN"));
		                                    span2.setAttribute("code", code);
		                                    span2.style.cursor = "pointer";
		                                    span2.onclick = function () { ItemRead_onclick(this); };

		                                    span3.className = "date";
		                                    span3.innerHTML = SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "WRITEDATE").substring(0, 10);
		                                } else {
		                                    if (imageCnt == 4) {
		                                        break;
		                                    }
		                                    
		                                    span2.className = "photo";
		                                    span2.setAttribute("itemid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "ITEMID"));
		                                    span2.setAttribute("boardid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "BOARDID"));
		                                    span2.setAttribute("gubun", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "GUBUN"));
		                                    span2.setAttribute("code", code);
		                                    span2.style.cursor = "pointer";
		                                    span2.onclick = function () { ItemRead_onclick(this); };

		                                    var img = document.createElement("IMG");
		                                    var imgUrl = SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "EXTENSIONATTRIBUTE5");

		                                    img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&boardID=" + SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "BOARDID") + "&fileName=" + imgUrl.split('/')[imgUrl.split('/').length - 1];
		                                    img.style.width = "68px";
		                                    img.style.height = "68px";

		                                    span2.appendChild(img);

		                                    span3.className = "ptxt";
		                                    span3.innerHTML = SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "TITLE");
		                                    span3.setAttribute("itemid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "ITEMID"));
		                                    span3.setAttribute("boardid", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "BOARDID"));
		                                    span3.setAttribute("gubun", SelectSingleNodeValue(GetChildNodes(SelectNodes(xmldom, "ITEM/BOARDITEM/DATA")[i])[j], "GUBUN"));
		                                    span3.setAttribute("code", code);
		                                    span3.onclick = function () { ItemRead_onclick(this); };
		                                    imageCnt++;
		                                }

		                                li.appendChild(span2);
		                                li.appendChild(span3);

		                                ul.appendChild(li);
		                                div2.appendChild(p);
		                                div2.appendChild(ul);
		                                div.appendChild(div2);
		                                document.getElementById("mainboard").appendChild(div);
		                            }
		                        } else {
		                            div2.appendChild(p);
		                            div2.appendChild(ul);
		                            div.appendChild(div2);
		                            document.getElementById("mainboard").appendChild(div);
		                        }
		                    }
		                }//for
		            } else {
		                document.getElementById("makeguide").style.display = "";
		            }
		        }
		    }
		    
		    function ItemRead_onclick(val) {
		        var pItemID = val.getAttribute("itemid");
		        var pItemBoardID = val.getAttribute("boardid");
		        var gubun = val.getAttribute("gubun");
		        var copno = val.getAttribute("code");

		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;

		        if (gubun == "3") {
	                window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + 1 + "&itemID=" + pItemID + "&boardID=" + pItemBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		        } else {
                	window.open("/ezCommunity/boardItemView.do?itemID=" + pItemID + "&boardID=" + pItemBoardID + "&code=" + copno + "&ShowAdjacent=" + 1, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		        }
		    }

		    function moreclick(val) {
		        var selectedBoardID = val.getAttribute("boardid");
		        var chkPhotoBrd = val.getAttribute("gubun");
		        var boardName = val.getAttribute("boardname");
		        document.getElementById("copmaindesc").style.display = "none";
		        document.getElementById("rightfrm").style.display = "";
		        document.getElementById("mainboard").style.display = "none";
		        document.getElementById("makeguide").style.display = "none";
		        document.getElementById("rightfrm").style.height = "659px";
		        if (chkPhotoBrd != "3") {
		            document.getElementById("rightfrm").src = "/ezCommunity/boardItemList.do?boardID=" + selectedBoardID + "&boardName=" + boardName + "&code=" + code;
		        } else {
		            document.getElementById("rightfrm").src = "/ezCommunity/boardItemListPhoto.do?boardID=" + selectedBoardID + "&boardName=" + boardName + "&code=" + code;
		        }
		        
		        if (CrossYN()) {
		        } else {
		            window.event.cancelBubble = true;
		            window.event.returnValue = false;
		        }
		    }
		    
		    function reload() {
		        window.location.reload();
		    }
		</script>
	</head>
	
	<body class="cmhomebg_<c:out value='${copType }'/>">
		<div id ="cmhome_<c:out value='${copType }'/>">
			<div class="cmhome_top" onclick="reload()" style="cursor:pointer;">
   	  			<div class="homeimg" id="homeimg" style="width:894px;height:100px;"></div>   	  
      			<h1 id="copname" class="homename"></h1>
			</div>
			<div class="cmhome_left">
        		<div class="info">
            		<div class="info_box">
            			<p class="pic" id="pic"></p>
                		<div class="master">
                    
	                    <c:choose>
	                    	<c:when test="${userInfo.lang != '3' }">
	                    		<span class="icon_gray"><span id="mastericon" style="padding-left:1px;"><spring:message code='ezCommunity.t9' /></span></span>
	                    	</c:when>
	                    	<c:otherwise>
	                    		<span class="icon_gray" style=""><span id="mastericon" style="padding-left:1px;font-size:7pt;"><spring:message code='ezCommunity.t9' /></span></span>		
	                    	</c:otherwise>
	                    </c:choose>
                    
		                    <p><strong id="mastername"></strong></p>
		                    <p id="master"></p>
		                </div>
		                
		                <c:if test="${checkSysop }">
		                	<div class="admin_menu"><span id="btn_Manager" onclick ="go_menu(this)"><spring:message code='ezCommunity.t565' /></span></div>
		                </c:if>
		                
		            </div>
		            
		            <ul class="info_count">
		        		<li class="icon_member"> <span class="count" id="membercnt"></span></li>
		         		<li class="icon_board"> <span class="count" id="itemcnt"></span></li>
		          	</ul>
		            <ul class="info_list">
			            <li id="regdate"></li>
			            <li id="cpublic"></li>
		            </ul>

					<c:choose>
						<c:when test="${userLevel == '0' && joinFlag && newMemberConfirmType == 3 }">
							<div id="btn_MemberJoinIng" class="btn_join" onclick ="go_menu(this)"><img src="/images/kr/community/type1/icon_rcheck.gif" width="20" height="17"><spring:message code='ezCommunity.t1080' /></div>
						</c:when>
						<c:when test="${userLevel == '0' || userLevel =='9' }">
							<div id="btn_MemberIn" class="btn_join" onclick ="go_menu(this)"><img src="/images/kr/community/type1/icon_rcheck.gif" width="20" height="17"><spring:message code='ezCommunity.t1080' /></div>
						</c:when>
					</c:choose>
				
        		</div>
       			<div id="left" class="leftmenu">
        			<div id="treediv">
        			</div>
         			<h3 id="btn_guest" onclick ="go_menu(this)"><img src="/images/kr/community/type1/icon_visitor.gif" width="16" height="16"><spring:message code='ezCommunity.t570' /></h3>
         			<h3 id="btn_QsPoll" onclick ="go_menu(this)"><img src="/images/kr/community/type1/icon_poll.gif" width="16" height="16"><spring:message code='ezCommunity.t598' /></h3>
         			<h3 id="btn_MemberInfo" onclick ="go_menu(this)"><img src="/images/kr/community/type1/icon_member.gif" width="16" height="16"><spring:message code='ezCommunity.t723' /></h3>
         			<c:if test="${joinFlag }">
         				<h3 id="btn_MemberOut" onclick ="go_menu(this)"><img src="/images/kr/community/type1/icon_x.gif" width="16" height="16"><spring:message code='ezCommunity.t1108' /></h3>
         			</c:if>
      			</div>
  			</div>
    		<div class="cmhome_right">
        		<div id="copmaindesc" class="introduce">
            		<span class="bgimg"></span>
            		<p id="copdesc"></p>
		        </div>
        		<div id="mainboard" style="height: 560px; overflow: auto; display: none;"></div>
        		<iframe id="rightfrm" style="width: 100%; height: 560px; border: 0; display: none" frameborder="0"></iframe>
        		<div class="makeguide" id="makeguide" style="display: none;">
            		<p><img src="<spring:message code='ezCommunity.i5' />"></p>
            		<p><a href="#" id="btn_Manager_home1" onclick ="go_menu(this)"><img src="<spring:message code='ezCommunity.i6' />" alt="<spring:message code='ezCommunity.t2010' />"></a></p>
            		<p><a href="#" id="btn_Manager_home2" onclick ="go_menu(this)"><img src="<spring:message code='ezCommunity.i7' />" alt="<spring:message code='ezCommunity.t2011' />"></a></p>
            		<p><img src="/images/kr/community/type1/makeguide_img04.gif"></p>
        		</div>
    		</div>
    	</div>
	</body>
</html>