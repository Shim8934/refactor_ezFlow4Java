<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
	    <link rel="stylesheet" href="/css/tab_over.css" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript">
	        var userLang = "${userInfo.lang}";
	        var xmlhttp = createXMLHttpRequest();
	        window.onload = function () {
	            GetMyBoardItem();
	        };
	        function GetMyBoardItem() {
	            xmlhttp.open("POST", "/ezBoard/get_favoriteList.do?mode=USE", true);
	            xmlhttp.onreadystatechange = GetMyBoardItem_evnet;
	            xmlhttp.send();
	        }
	        var overCnt = 0;
	        var widthCheck = false;
	        function GetMyBoardItem_evnet() {
	            if (xmlhttp == null || xmlhttp.readyState != 4) return;
	            try {
	                var xmlnode = SelectNodes(xmlhttp.responseXML, "ROOT/DATA/ROW");
	                if (xmlnode.length != 0) {
	                    for (var i = 0; i < xmlnode.length; i++) {
	                        var BoardName = getNodeText(SelectSingleNode(xmlnode[i], "BOARDNAME"));
	                        var BoardName2 = getNodeText(SelectSingleNode(xmlnode[i], "BOARDNAME2"));
	                        var BoardId = getNodeText(SelectSingleNode(xmlnode[i], "BOARDID"));
	                        var BoardType = getNodeText(SelectSingleNode(xmlnode[i], "GUBUN"));
	                        var _p = document.createElement("P");
	                        _p.id = "FBoard_sub" + i;
	
	                        var _span = document.createElement("SPAN");
	                        _span.id = "1tab" + i;
	                        _span.setAttribute("divname", "FBoard_div" + i);
	                        _span.setAttribute("DATA1", BoardId);
	                        if (userLang == "1")
	                            _span.setAttribute("DATA2", BoardName);
	                        else
	                            _span.setAttribute("DATA2", BoardName2);
	                        _span.setAttribute("DATA5", BoardType);
	                        if (userLang == "1")
	                            _span.innerHTML = BoardName;
	                        else
	                            _span.innerHTML = BoardName2;
	
	                        _p.appendChild(_span);
	                        document.getElementById("tab1").appendChild(_p);
	
	
	                        if (tabAllWidth() >= document.getElementById("tab1").offsetWidth - 55 || widthCheck) {
	                            widthCheck = true;
	                            overCnt = overCnt + 1;
	                            document.getElementById("tab1").removeChild(_p);
	                            if (document.getElementById("tabpartMore") == null) {
	                                var _p2 = document.createElement("P");
	                                _p2.className = "tabpartMore";
	                                _p2.id = "tabpartMore";
	                                //_p2.onclick = function () { Tab1_MouseClick_more(document.getElementById("overSpan"), false) }
	
	
	                                var _span2 = document.createElement("SPAN");
	                                _span2.id = "overSpan";
	                                if (document.getElementById("tabpart01UL") != null)
	                                    _span2.textContent = document.getElementById("tabpart01UL").getElementsByTagName("li").length;
	                                else
	                                    _span2.textContent = overCnt;
	
	                                var _ul = document.createElement("UL");
	                                _ul.className = "tabpart01UL";
	                                _ul.id = "tabpart01UL";
	                                _ul.style.display = "none";
	
	                                var _li = document.createElement("LI");
	                                _li.setAttribute("DATA1", BoardId);
	                                _li.setAttribute("DATA5", BoardType);
	                                _li.textContent = BoardName;
	                                _li.onclick = function () { Tab1_MouseClick2(this); };
	                                _li.style.cursor = "pointer";
	                                _ul.appendChild(_li);
	                                
	                                _p2.appendChild(_span2);
	                                _p2.appendChild(_ul);
	                                _p2.style.cursor = "pointer";
	
	                                document.getElementById("tab1").appendChild(_p2);
	                            }
	                            else {
	                                var _li = document.createElement("LI");
	                                _li.textContent = BoardName;
	                                _li.setAttribute("DATA1", BoardId);
	                                _li.setAttribute("DATA5", BoardType);
	                                _li.style.cursor = "pointer";
	                                _li.onclick = function () { Tab1_MouseClick2(this); };
	
	
	                                document.getElementById("tabpart01UL").appendChild(_li);
	
	                                if (document.getElementById("tabpart01UL") != null)
	                                    document.getElementById("overSpan").textContent = document.getElementById("tabpart01UL").getElementsByTagName("li").length;
	                                else
	                                    document.getElementById("overSpan").textContent = overCnt;
	
	                                insertOption = "LAST";
	                            }
	                            //Tab1_MouseClick_more(document.getElementById("overSpan"), false);
	                        }
	                       
	                    }
	                    if (xmlnode.length > 0)
	                        Tab1_NewTabIni("tab1");
	
	                    document.getElementById("1tab0").setAttribute("class", "tabon");
	                    Tab1_SelectID = "1tab0";
	                    ChangeTab(document.getElementById("1tab0"));
	                }
	                else {
	                    var _p = document.createElement("P");
	                    _p.id = "FBoard_sub0";
	
	                    var _span = document.createElement("SPAN");
	                    _span.id = "1tab0";
	                    _span.setAttribute("divname", "FBoard_div0");
	                    _span.setAttribute("DATA1", "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}");
	                    if (userLang == "1")
	                        _span.setAttribute("DATA2", "<spring:message code='ezBoard.t480'/>");
	                    else
	                        _span.setAttribute("DATA2", "New BoardItem");
	                    _span.setAttribute("DATA5", "0");
	                    _span.innerHTML = "<spring:message code='ezBoard.t480'/>";
	
	                    _p.appendChild(_span);
	                    document.getElementById("tab1").appendChild(_p);
	                    if (xmlnode.length > 0)
	                        Tab1_NewTabIni("tab1");
	
	                    document.getElementById("1tab0").setAttribute("class", "tabon");
	                    Tab1_SelectID = "1tab0";
	                    ChangeTab(document.getElementById("1tab0"));
	                }
	
	            } catch (e) { }
	        }
	
	        function Tab1_MouseClick_more(obj, displayFlag) {
	            if (obj.className != "tabon") {
	
	                obj.className = "tabon";
	                if (obj.id != Tab1_SelectID) {
	                    if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                        document.getElementById(Tab1_SelectID).className = "";
	
	                    obj.className = "tabon";
	                    Tab1_SelectID = obj.id;
	                    selValue = obj.textContent;
	                    CurPage = 1;
	                }
	                if (!displayFlag)
	                    document.getElementById("tabpart01UL").style.display = "";
	                else {
	                    if (document.getElementById("tabpart01UL").style.display == "")
	                        document.getElementById("tabpart01UL").style.display = "none";
	                    else
	                        document.getElementById("tabpart01UL").style.display = "";
	                }
	            }
	            else {
	                if (document.getElementById("tabpart01UL").style.display == "")
	                    document.getElementById("tabpart01UL").style.display = "none";
	                else
	                    document.getElementById("tabpart01UL").style.display = "";
	            }
	        }
	        function tabAllWidth() {
	            var allWidth = 0;
	            for (var i = 0; i < document.getElementById("tab1").getElementsByTagName("P").length; i++) {
	                allWidth += document.getElementById("tab1").getElementsByTagName("P")[i].offsetWidth;
	            }
	            return allWidth;
	        }
	
	        function ChangeTab(obj) {
	            var SelectedBoardID = obj.getAttribute("DATA1");
	            var chkPhotoBrd = obj.getAttribute("DATA5");
	            
	            if (chkPhotoBrd == 3)
	                document.getElementById("FBoard_ifrm").src = "/ezBoard/boardItemListPhoto.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardType=" + chkPhotoBrd + "&adminType=y&buttonHidden=N";
	            else if (chkPhotoBrd == 4)
	                document.getElementById("FBoard_ifrm").src = "/ezBoard/boardItemListThumbnail.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardType=" + chkPhotoBrd + "&adminType=y&buttonHidden=N";
	            else {
	                if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
	                    document.getElementById("FBoard_ifrm").src = "/ezBoard/boardItemList_new.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardType=N" + "&adminType=y&buttonHidden=N";
	                }
	                else
	                    document.getElementById("FBoard_ifrm").src = "/ezBoard/boardItemList.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardType=" + chkPhotoBrd + "&adminType=y&buttonHidden=N";
	            }
	        }
	
	        var Tab1_SelectID = "";
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }
	        function Tab1_MouserOut(obj) {
	            if (Tab1_SelectID != obj.id)
	                obj.className = "";
	        }
	        function Tab1_MouseClick(obj) {
	            if(document.getElementById("tabpart01UL") != null)
	                document.getElementById("tabpart01UL").style.display = "none";
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                    document.getElementById(Tab1_SelectID).className = "";
	
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
	            }
	        }
	        function Tab1_MouseClick2(obj) {
	            ChangeTab(obj);
	        }
	
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
	                        
	                        if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id != "overSpan")
	                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };
	                        else
	                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick_more(this, true); };
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	
	                    }
	                }
	            }
	        }
	    </script>
	</head>
	<body class="mainbody" style="height: 89%;">
	    <h1><spring:message code='ezBoard.t10031'/><span id='mailBoxInfo'></span></h1>
	    <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
	        </div>
	    </div>
	    <iframe id="FBoard_ifrm" style="width: 100%; height: 100%;" frameborder="0"></iframe>
	</body>
</html>