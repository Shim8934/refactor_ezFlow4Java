<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<link href="/css/theme01.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApproval/lang/ezApproval.js"></script>
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
	        var bestclick = false;
	        var strlang = "{userInfo.lang}";
	        var pUse_IE11Browser = "${useIE11Browser}";
	
	        window.onload = function () {
	            getCommu();
	
	            try { top.onresize() } catch (e) { }
	        }
	
	        function getCommu() {
	        	$.ajax({
					type : "POST",
					url : "/ezCommunity/getLeftCommunity.do",
					dataType : "json",
					success : function(result) {
						getCommunityList_after(result["list"]);
					}
				});
	            if (result == null || xmlhttp.readyState != 4) return;
	            else {
	                var commu = CheckCommu(xmlhttp.responseXML);
	                document.getElementById("commu_list").innerHTML = "";
	                switch (commu) {
	                    case 1:
	                        document.getElementById("community_title").innerText = "<spring:message code='main.t272' />";
	                        document.getElementById("content_commu").className = "content_community01";
	                        GetBoardList();
	                        break;
	
	                    case 2:
	                        document.getElementById("community_title").innerText = "<spring:message code='main.t00051' />";
	                        document.getElementById("content_commu").className = "content_community02";
	                        GetMyComm(xmlhttp.responseXML);
	                        break;
	                }
	            }
	        }
	        function GetMyComm(list) {
	            var listHTML = "<div class='content_list04'><dl class='topTitle'><dt><select id='myComm' onchange='getCommList()'>";
	            for (var i = 0; i < xmldom.getElementsByTagName("ROW").length; i++) {
	                if (strlang == "" || strlang == "1") {
	                    listHTML += "<option code='" + getNodeText(xmldom.getElementsByTagName("C_CLUBNO").item(i)) + "'>" + getNodeText(xmldom.getElementsByTagName("C_CLUBNAME").item(i)) + "</option>";
	                }
	                else {
	                    listHTML += "<option code='" + getNodeText(xmldom.getElementsByTagName("C_CLUBNO").item(i)) + "'>" + getNodeText(xmldom.getElementsByTagName("C_CLUBNAME2").item(i)) + "</option>";
	                }
	            }
	            listHTML += "</select></dt><dd><span onclick='goComm()'><spring:message code='main.t00043' /></span></dd></dl>";
	            listHTML += "</div>";
	
	            document.getElementById("commu_list").innerHTML = listHTML;
	            getCommList();
	        }
	        function goComm() {
	            for (var i = 0; i < document.getElementById("myComm").options.length; i++) {
	                if (document.getElementById("myComm").options[i].selected) {
	                    move_cop(document.getElementById("myComm").options[i]);
	                    return;
	                }
	            }
	        }
	        function getCommList() {
	            xmlhttp = null;
	            xmlhttp = createXMLHttpRequest();
	            xmlpara = createXmlDom();
	
	            var objRoot, objNode;
	            objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	
	            for (var i = 0; i < document.getElementById("myComm").options.length; i++) {
	                if (document.getElementById("myComm").options[i].selected) {
	                    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "C_CLUBNO", document.getElementById("myComm").options[i].getAttribute("code"));
	                    break;
	                }
	            }
	
	            //xmlhttp.open("POST", "/myoffice/ezcommunity/aspx/getmycoummunityboardlist.aspx", true);
	            xmlhttp.open("POST", "/ezCommunity/myCopNewBoardItem.do", true);
	            xmlhttp.onreadystatechange = getCommList_after;
	            xmlhttp.send(xmlpara);
	        }
	        function getCommList_after() {
	            if (xmlhttp == null || xmlhttp.readyState != 4) return;
	
	            var listHTML = "";
	            var listdom = xmlhttp.responseXML;
	            if (document.getElementById("myBoardList"))
	                document.getElementById("myBoardList").innerHTML = "";
	            else
	                listHTML = "<div id='myBoardList' class='layoutRight'>";
	            listHTML += "<dl class='layoutLeftDL'><dt><spring:message code='main.t00044' /> <span>(" + listdom.getElementsByTagName("ROW").length + ")</span></dt>";
	                for (var i = 0; i < listdom.getElementsByTagName("ROW").length; i++) {
	
	                    listHTML += "<dd onclick='ItemReadCommu_onclick(this)' itemid='" + getNodeText(listdom.getElementsByTagName("ITEMID").item(i)) + "' boardid='" + getNodeText(listdom.getElementsByTagName("BOARDID").item(i)) + "' ";
	                    listHTML += "gubun='" + getNodeText(listdom.getElementsByTagName("GUBUN").item(i)) + "' code='" + getNodeText(listdom.getElementsByTagName("C_CLUBNO").item(i)) + "'><strong>["
	                    if (strlang == "" || strlang == "1")
	                        listHTML += getNodeText(listdom.getElementsByTagName("BOARDNAME").item(i)) + "]</strong> "
	                    else
	                        listHTML += getNodeText(listdom.getElementsByTagName("BOARDNAME").item(i)) + "]</strong> "
	                    listHTML += getNodeText(listdom.getElementsByTagName("TITLE").item(i)) + "</dd>";
	                }
	                listHTML += "</dl>";
	                if (document.getElementById("myBoardList")) {
	                    document.getElementById("myBoardList").innerHTML = listHTML;
	                }
	                else {
	                    listHTML += "</div>";
	                    document.getElementById("commu_list").innerHTML += listHTML;
	                }
	
	        }
	        function ItemReadCommu_onclick(val) {
	            var pItemID = val.getAttribute("itemid");
	            var pItemBoardID = val.getAttribute("boardid");
	            var gubun = val.getAttribute("gubun");
	            var copno = val.getAttribute("code");
	
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 720) / 2;
	            var pLeft = (pwidth - 765) / 2;
	
	            if (gubun == "3") {
	                if (CrossYN())
	                    window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + 1 + "&itemID=" + pItemID + "&boardID=" + pItemBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	                else
	                    window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + 1 + "&itemID=" + pItemID + "&boardID=" + pItemBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	            }
	            else {
	                if (CrossYN() || pUse_IE11Browser == "CK")
	                    window.open("/ezCommunity/boardItemView.do?itemID=" + pItemID + "&boardID=" + pItemBoardID + "&code=" + copno + "&showAdjacent=" + 1, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=790,width=765,top=" + pTop + ",left=" + pLeft, "");
	                else
	                    window.open("/ezCommunity/boardItemView.do?itemID=" + pItemID + "&boardID=" + pItemBoardID + "&code=" + copno + "&showAdjacent=" + 1, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=790,width=765,top=" + pTop + ",left=" + pLeft, "");
	            }
	        }
	        function GetBoardList() {
	            xmlhttp = null;
	            xmlhttp = createXMLHttpRequest();
	
	            xmlhttp.open("POST", "/ezCommunity/getLeftBoardList.do", false);
	            xmlhttp.send();
	
	            if (xmlhttp == null || xmlhttp.readyState != 4) return;
	            else {
	                var xmlpara = createXmlDom();
	                xmlpara = xmlhttp.responseXML;
	                var no, title;
	                var listHTML = "<div class='content_list02'><div class='layout_margin3'><ul class='title'><li><strong><spring:message code='main.t00041' /></strong></li></ul><div class='layout_bg'><ul class='communityLiist01'>";
	                if (xmlpara.getElementsByTagName("NO").length != 0) {
	                    for (var i = 0; i < 5; i++) {
	                        no = getNodeText(xmlpara.getElementsByTagName("NO").item(i));
	                        title = getNodeText(xmlpara.getElementsByTagName("TITLE").item(i));
	                        listHTML += "<li onClick=\"btn_bbsView(" + no + ",'c_board')\" style='cursor:pointer'>" + title + "</li>";
	                    }
	                }
	                listHTML += "</ul></div></div></div>";
	
	                xmlpara = null;
	                xmlpara = createXmlDom();
	                var objRoot, objNode;
	                objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	                objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "MODE", "BEST");
	                xmlhttp = null;
	                xmlhttp = createXMLHttpRequest();
	
	                xmlhttp.open("POST", "/ezCommunity/getBestNewCommunity.do", false);
	                xmlhttp.send(xmlpara);
	
	                if (xmlhttp == null || xmlhttp.readyState != 4) return;
	                else {
	                    if (strlang == "" || strlang == "1") {
	                        var listdom = loadXMLString(xmlhttp.responseText);
	                        listHTML += "<div class='content_list02'><div class='layout_margin3'><ul class='title'><li onclick=\"change_tab('best')\" id='best' class='on'><spring:message code='main.t00036' /></li><li onclick=\"change_tab('new')\" id='new'><spring:message code='main.t00035' /></li></ul>";
	                        listHTML += "<div id='bestcomm' class='layout_bg'><dl class='communityLiist01'><dt><span class='img_community'>"
	                        if (SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL").indexOf("default_logo_type") > -1)
	                            listHTML += "<img src='/images/ezCommunity/logo/" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL") + "' width='56' height='40' alt='' /></span>";
	                        else
	                            listHTML += "<img src='/myoffice/Common/ezCommon_InterFace.aspx?TYPE=COMMUNITYLOGO&FILENAME=" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL") + "' width='56' height='40' alt='' /></span>";
	                        listHTML += "<span class='img_dotCommunity1'><img src='/images/kr/theme01/main/img_dotCommunity1.png' alt='' /></span>";
	                        listHTML += "<strong onclick='move_cop(this)' style='cursor:pointer' code='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBNO");
	                        listHTML += "' type='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBCONFIRMTYPE") + "'>" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBNAME");
	                        listHTML += " (" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_MEMBERCNT") + "<spring:message code='main.t20000'/>) </strong>";
	                        listHTML += "<br />" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBDESC") + "</dt>";
	                    }
	                    else {
	                        var listdom = loadXMLString(xmlhttp.responseText);
	                        listHTML += "<div class='content_list02'><div class='layout_margin3'><ul class='title'><li onclick=\"change_tab('best')\" id='best' class='on'><spring:message code='main.t00036' /></li><li onclick=\"change_tab('new')\" id='new'><spring:message code='main.t00035' /></li></ul>";
	                        listHTML += "<div id='bestcomm' class='layout_bg' style=''><dl class='communityLiist01'><dt><span class='img_community'>"
	                        if (SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL").indexOf("default_logo_type") > -1)
	                            listHTML += "<img src='/images/ezCommunity/logo/" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL") + "' width='56' height='40' alt='' /></span>";
	                        else
	                            listHTML += "<img src='/myoffice/Common/ezCommon_InterFace.aspx?TYPE=COMMUNITYLOGO&FILENAME=" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL") + "' width='56' height='40' alt='' /></span>";
	                        listHTML += "<span onclick='move_cop(this)' class='img_dotCommunity1'><img src='/images/kr/theme01/main/img_dotCommunity1.png' alt='' /></span>";
	                        listHTML += "<strong style='cursor:pointer' code='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBNO");
	                        listHTML += "' type='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBCONFIRMTYPE") + "' >" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBNAME2");
	                        listHTML += " (" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_MEMBERCNT") + "<spring:message code='main.t20000'/>) </strong>";
	                        listHTML += "<br />" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBDESC") + "</dt>";
	                    }
	                    for (var i = 1 ; i < SelectNodes(listdom, "DATA/ROW").length; i++) {
	                        listHTML += "<dd><img src='/images/kr/theme01/main/img_dotCommunity" + (i + 1) + ".png' alt='' />";
	                        listHTML += "<strong style='cursor:pointer' code='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[i], "C_CLUBNO") + "' type='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[i], "C_CLUBCONFIRMTYPE") + "' onclick='move_cop(this)'>";
	                        if (strlang == "" || strlang == "1")
	                            listHTML += SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[i], "C_CLUBNAME");
	                        else
	                            listHTML += SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[i], "C_CLUBNAME2");
	                        listHTML += " (" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[i], "C_MEMBERCNT") + "<spring:message code='main.t20000'/>) </strong></dd>";
	                    }
	
	                    listHTML += "</dl></div><div id='newcomm' class='layout_bg' style='display:none'></div></div></div>";
	                }
	                document.getElementById("commu_list").innerHTML = listHTML;
	            }
	        }
	        function move_cop(val) {
	            var xmlhttp = createXMLHttpRequest();
	            var xmldom = createXmlDom();
	            var objNode;
	
	            var clubgubun = 0;
	            var idx = val.getAttribute("code");
	
	            createNodeInsert(xmldom, objNode, "DATA");
	            createNodeAndInsertText(xmldom, objNode, "CID", idx);
	            createNodeAndInsertText(xmldom, objNode, "UID", "${userInfo.id}");
	
	            xmlhttp.open("POST", "/ezCommunity/getACL.do", false);
	            xmlhttp.send(xmldom);
	            if (xmlhttp.responseText == "ERR" | clubgubun == "1") {
	                var rtn = OpenInformationUI(strLang5 + "<BR>" + strLang6);
	                if (rtn) {
	                    xmlhttp = null;
	                    var xmlhttp = createXMLHttpRequest();
	                    var xmldom = createXmlDom();
	                    var objNode;
	
	                    createNodeInsert(xmldom, objNode, "DATA");
	                    createNodeAndInsertText(xmldom, objNode, "CODE", idx);
	                    xmlhttp.open("POST", "/ezCommunity/getIsJoin.do", false);
	                    xmlhttp.send(xmldom);
	
	                    if (xmlhttp.responseText == "FALSE") {
	                        var wWeight = "330";
	                        var wHeight = "207";
	                        var heigth = window.screen.availHeight;
	                        var width = window.screen.availWidth;
	                        var left = (width - wWeight) / 2;
	                        var top = (heigth - wHeight) / 2;
	                        var type = val.getAttribute("type");
	
	                        if (type == "2")
	                            window.open("/ezCommunity/join1.do?no=" + idx, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
	                        else if (type == "3")
	                            window.open("/ezCommunity/join2.do?no=" + idx, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
	                    }
	                    else {
	                        alert(strLang7);
	                    }
	
	                }
	            }
	            else {
	                //window.open("/myOffice/ezCommunity/main.aspx?communityCD=" + idx + "&UserLevel=1", "main");
	                GoFunc(val);
	            }
	        }
	
	        function GoFunc(obj) {
	
	            code = obj.getAttribute("code");
	            codeName = obj.innerText;
	            if (code == "0") {
	                window.frames.location.href = window.frames.location.href;
	            }
	            else {
	                var url = "/ezCommunity/checkCommHome.do?communityCD=" + code + "&userLevel=1";
	                var wWeight = "1300";
	                var wHeight = "900";
	
	                var heigth = window.screen.availHeight;
	                var width = window.screen.availWidth;
	
	                var left = (width - wWeight) / 2;
	                var top = (heigth - wHeight) / 2 - 30;
	
	                var ret = window.open(url, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
	            }
	        }
	
	        function CheckCommu(xmlpara) {
	            if (xmlpara.getElementsByTagName("ROW").length > 0) {
	                return 2
	            }
	            else return 1;
	        }
	
	        function btn_bbsView(sURL, ttt) {
	            var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 350;
	            pwidth = pwidth - 350;
	
	            window.open("/myoffice/ezCommunity/board/bbs_view_new.aspx?mode=content&no=" + sURL + "&bname=" + ttt, "<spring:message code='ezCommunity.t166'/>", "width=760,height=720,top=" + pheigth + ",left=" + pwidth);
	        }
	
	        function Copmore_btnClick() {
	            window.open("/ezCommunity/communityMain.do?funCode=5", "main", "");
	        }
	        function get_newCommunity() {
	            xmlhttp = null;
	            xmlhttp = createXMLHttpRequest();
	
	            var xmlDom = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlDom, objNode, "DATA");
	
	            createNodeAndInsertText(xmlDom, objNode, "MODE", "NEW");
	
	            xmlhttp.open("POST", "/ezCommunity/getBestNewCommunity.do", true);
	            xmlhttp.onreadystatechange = event_get_newCommunity;
	            xmlhttp.send(xmlDom);
	        }
	        function event_get_newCommunity(listdom) {
	            if (xmlhttp == null || xmlhttp.readyState != 4) return;
	            
	            var listHTML = "";
	            var listdom = loadXMLString(xmlhttp.responseText);
	            if (strlang == "" || strlang == "1") {
	                listHTML += "<dl class='communityLiist01'><dt><span class='img_community'>"
	                if (SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL").indexOf("default_logo_type") > -1)
	                    listHTML += "<img src='/images/ezCommunity/logo/" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL") + "' width='56' height='40' alt='' /></span>";
	                else
	                    listHTML += "<img src='/myoffice/Common/ezCommon_InterFace.aspx?TYPE=COMMUNITYLOGO&FILENAME=" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL") + "' width='56' height='40' alt='' /></span>";
	                listHTML += "<span class='img_dotCommunity1'><img src='/images/kr/community/icon_newCommunity04.png' alt='' /></span>";
	                listHTML += "<strong onclick='move_cop(this)' style='cursor:pointer' code='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBNO");
	                listHTML += "' type='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBCONFIRMTYPE") + "'>" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBNAME");
	                listHTML += " (" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_MEMBERCNT") + "<spring:message code='main.t20000'/>) </strong>";
	                listHTML += "<br />" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBDESC") + "</dt>";
	            }
	            else {
	                listHTML += "<dl class='communityLiist01'><dt><span class='img_community'>"
	                if (SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL").indexOf("default_logo_type") > -1)
	                    listHTML += "<img src='/images/ezCommunity/logo/" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL") + "' width='56' height='40' alt='' /></span>";
	                else
	                    listHTML += "<img src='/myoffice/Common/ezCommon_InterFace.aspx?TYPE=COMMUNITYLOGO&FILENAME=" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL") + "' width='56' height='40' alt='' /></span>";
	                listHTML += "<span onclick='move_cop(this)' class='img_dotCommunity1'><img src='/images/kr/community/icon_newCommunity04.png' alt='' /></span>";
	                listHTML += "<strong style='cursor:pointer' code='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBNO");
	                listHTML += "' type='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBCONFIRMTYPE") + "' >" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBNAME2");
	                listHTML += " (" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_MEMBERCNT") + "<spring:message code='main.t20000'/>) </strong>";
	                listHTML += "<br />" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[0], "C_CLUBDESC") + "</dt>";
	            }
	            for (var i = 1 ; i < SelectNodes(listdom, "DATA/ROW").length; i++) {
	                listHTML += "<dd><img src='/images/kr/theme01/main/img_dotCommunity" + (i + 1) + ".png' alt='' />";
	                listHTML += "<strong style='cursor:pointer' code='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[i], "C_CLUBNO") + "' type='" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[i], "C_CLUBCONFIRMTYPE") + "' onclick='move_cop(this)'>";
	                if (strlang == "" || strlang == "1")
	                    listHTML += SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[i], "C_CLUBNAME");
	                else
	                    listHTML += SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[i], "C_CLUBNAME2");
	                listHTML += " (" + SelectSingleNodeValue(SelectNodes(listdom, "DATA/ROW")[i], "C_MEMBERCNT") + "<spring:message code='main.t20000'/>) </strong></dd>";
	            }
	
	            listHTML += "</dl></div><div id='newcomm' class='layout_bg' style='display:none'></div>";
	            document.getElementById("newcomm").innerHTML = listHTML;
	        }
	
	        function change_tab(val) {
	            if (val == "best") {
	                document.getElementById("best").className = "on";
	                document.getElementById("new").className = "";
	                document.getElementById("bestcomm").style.display = "";
	                document.getElementById("newcomm").style.display = "none";
	            }
	            else if (val == "new") {
	                if (!bestclick) {
	                    get_newCommunity();
	                    bestclick = true;
	                }
	                document.getElementById("best").className = "";
	                document.getElementById("new").className = "on";
	                document.getElementById("bestcomm").style.display = "none";
	                document.getElementById("newcomm").style.display = "";
	            }
	        }
		</script>
	</head>
	<body>
		<div id="content_commu" class="content_community">
        	<dl class="content_title01">
            	<dt id="community_title"><spring:message code='main.t00051' /></dt>
            	<dd onclick="Copmore_btnClick()"><spring:message code='main.t1008' /></dd>
        	</dl>
        	<div class="content_list01" id="commu_list">
        	</div>
    	</div>
	</body>
</html>