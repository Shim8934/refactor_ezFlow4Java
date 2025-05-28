<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML>
<html>
<head>
    <title><spring:message code='ezApprovalG.t1236'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list_SearchOuterOrgan.js')}"></script>
    <script type="text/javascript">
        var reParam = new Array();
        reParam["ret"] = "NO";
        var g_SelRow = null;
        var g_SelColor = "#ECF3BA";
        var g_UnSelColor = "#FFFFFF";
        var g_HotTrackColor = "#f4f5f5";
        var p_strKeyword = "<c:out value='${keyword}'/>";
        var RetValue;
        var ReturnFunction;
        var OrderOption = "";
        var OrderCell = "";
        var HiddenLayerPopUp;
        var aMsg1 = "전자문서를 수신 하지 않는 기관 입니다.";
        window.onload = function () {
            document.getElementById("SearchWord").innerHTML = "(" + "<spring:message code='ezApprovalG.t111'/>" + ":" + p_strKeyword + ")";
            GetSearchList();

            try {
                reParam["ret"] = "NO";
                RetValue = parent.searchorganglist_dialogArguments[0];
                ReturnFunction = parent.searchorganglist_dialogArguments[1];
            } catch (e) {
                try {
                    RetValue = opener.searchorganglist_dialogArguments[0];
                    ReturnFunction = opener.searchorganglist_dialogArguments[1];
                } catch (e) {
                    RetValue = window.dialogArguments;
                }
            }
            
            var timer = setInterval(function() {
    			if($('#OuterOrganSearchResult_TH').length > 0) {
		            $('#OuterOrganSearchResult_TH_0').prop('width', '35%');
		            $('#OuterOrganSearchResult_TH_1').prop('width', '65%');
    				clearInterval(timer);
    			}
    		}, 100);
        }
        var xmlhttpSearch = null;
        function GetSearchList() {

            ShowProgressBar();

            var xmlpara = createXmlDom();
            xmlhttpSearch = createXMLHttpRequest();
            var objNode;
            createNodeInsert(xmlpara, objNode, "DATA");
            createNodeAndInsertText(xmlpara, objNode, "SEARCH", p_strKeyword);
            xmlhttpSearch.open("Post", "/ezApprovalG/searchOrganGListData.do", true);
            xmlhttpSearch.onreadystatechange = event_SearchList;
            xmlhttpSearch.send(xmlpara);
        }
        
        function event_SearchList() {
            if (xmlhttpSearch != null && xmlhttpSearch.readyState == 4) {
                if (xmlhttpSearch.status == 200) {
                    var listNode = SelectSingleNodeNew(loadXMLString(xmlhttpSearch.responseText), "LISTVIEWDATA");

                    var xmlDoc = createXmlDom();
                    xmlDoc.appendChild(listNode);

                    var DocList = new ListView();
                    DocList.SetID("OuterOrganSearchResult");
                    DocList.SetMulSelectable(true);
                    DocList.SetSelectFlag(false);
                    DocList.SetRowOnClick("lvDocList_SelChange");
                    DocList.DataSource(xmlDoc);
                    DocList.DataBind("lvOuterOrganList");
                    DocList = null;

                    HiddenProgressBar();
                }
                xmlhttpSearch = null;
            }
        }
        function SelectOrgan(pThis) {
            if (g_SelRow != null) {
                g_SelRow.style.backgroundColor = g_UnSelColor;
            }

            pThis.style.backgroundColor = g_SelColor;
            g_SelRow = pThis;
        }
        function btnConfirm_onClick() {
            try {
                var SelList = new ListView();
                SelList.LoadFromID("OuterOrganSearchResult");
                var SelectedRows = SelList.GetSelectedRows();
                var SelRowCnt = SelectedRows.length;

                if (SelectedRows.length == 0) {
                    alert("<spring:message code='ezApprovalG.t1237'/>");
                    return;
                }

                if (SelRowCnt == 1) {

                    var tr = SelectedRows[0];

                    reParam["ret"] = "OK";
                    
                    reParam["ouCode"] = GetAttribute(tr, "DATA1");
                    reParam["pouCode"] = GetAttribute(tr, "DATA5");
                    reParam["topOuCode"] = GetAttribute(tr, "DATA4");
                    reParam["chiefTitle"] = GetAttribute(tr, "DATA6");
                    reParam["Title"] = GetAttribute(tr, "DATA6");
                    reParam["FullDepth"] = GetAttribute(tr, "DATA6");

                    if (window.ActiveXObject)
                        reParam["ou"] = GetAttribute(tr, "DATA2");
                    else
                        reParam["ou"] = GetAttribute(tr, "DATA2");

                } else {
                    reParam["ret"] = "MULTISELECT";
                    reParam["ouCode"] = new Array();
                    reParam["pouCode"] = new Array();
                    reParam["topOuCode"] = new Array();
                    reParam["chiefTitle"] = new Array();
                    reParam["Title"] = new Array();
                    reParam["FullDepth"] = new Array();
                    reParam["ou"] = new Array();

                    for (var i = 0; i < SelRowCnt; i++) {

                        var tr = SelectedRows[i];

                        reParam["ouCode"][i] = GetAttribute(tr, "DATA1");
                        reParam["pouCode"][i] = GetAttribute(tr, "DATA5");
                        reParam["topOuCode"][i] = GetAttribute(tr, "DATA4");
                        reParam["chiefTitle"][i] = GetAttribute(tr, "DATA6");
                        reParam["Title"][i] = GetAttribute(tr, "DATA6");
                        reParam["FullDepth"][i] = GetAttribute(tr, "DATA6");

                        if (window.ActiveXObject)
                            reParam["ou"][i] = GetAttribute(tr, "DATA2");
                        else
                            reParam["ou"][i] = GetAttribute(tr, "DATA2");
                    }
                }

                if (ReturnFunction != null) {
                    ReturnFunction(reParam);
                } else {
                    window.returnValue = reParam;
                    window.close();
                }

            } catch (e) {
                alert(e.description);
            }
        }
        function btnCalcel_onClick() {
            reParam["ret"] = "NO";
            if (ReturnFunction != null) {
                ReturnFunction(reParam);
            }
            else {
                window.returnValue = reParam;
                window.close();
            }
        }
        function ShowProgressBar() {

            try {
                var ReturnValue = new Array();
                var heigth = document.documentElement.clientHeight;
                if (heigth == 0)
                    heigth = document.body.clientHeight;

                var width = document.documentElement.clientWidth;
                if (width == 0)
                    width = document.body.clientWidth;

                var left = 0;
                var top = 0;
                var pleftpos;

                pleftpos = parseInt(width) - 32;
                heigth = parseInt(heigth) - 32;
                width = parseInt(width) - pleftpos;

                if (heigth < (32 + 50))
                    ReturnValue[0] = (heigth / 2);
                else
                    ReturnValue[0] = (heigth / 2) - 50;
                ReturnValue[1] = pleftpos / 2;

                document.getElementById("iFramePanel").style.top = ReturnValue[0] + "px";
                document.getElementById("iFramePanel").style.left = ReturnValue[1] + "px";
                document.getElementById("iFramePanel").style.height = 32 + "px";
                document.getElementById("iFrameLayer").style.width = 32 + "px";
                document.getElementById("iFrameLayer").style.height = 32 + "px";
                document.getElementById("mailPanel").style.display = "";
                document.getElementById("iFramePanel").style.display = "";

            } catch (e) {

            }
        }
        function HiddenProgressBar() {
            try {
                document.getElementById("mailPanel").style.display = "none";
                document.getElementById("iFramePanel").style.display = "none";
            } catch (e) { }
        }
        function lvDocList_SelChange() {
            var SelList = new ListView();
            SelList.LoadFromID("OuterOrganSearchResult");
            var oArrRows = SelList.GetSelectedRows();
            var tr = oArrRows[0];
            var DATA7 = GetAttribute(tr, "DATA7");
            if (DATA7 == "GRAY") {
                tr.setAttribute("selected", "false");
                tr.style.backgroundColor = m_strColorDefault;
                alert(aMsg1);
                return;
            } else {
                return;
            }
        }

        //2020-04-23 : 외부수신처 검색 후 선택한 수신처로 조직도 이동
        function btnsearchDept_onClick(){
            var SelList = new ListView();
            SelList.LoadFromID("OuterOrganSearchResult");
            var oArrRows = SelList.GetSelectedRows();
            var tr = oArrRows[0];
            
            if(tr){
            	ShowProgressBar();
            	
                var xmlpara = createXmlDom();
                xmlhttpSearch = createXMLHttpRequest();
                var objNode;
                createNodeInsert(xmlpara, objNode, "DATA");
                createNodeAndInsertText(xmlpara, objNode, "PARENTCODE", GetAttribute(tr, "DATA5"));
                createNodeAndInsertText(xmlpara, objNode, "SELCODE", GetAttribute(tr, "DATA1"));
                xmlhttpSearch.open("Post", "/ezApprovalG/searchOrganGListDataTreeView.do", true);
                xmlhttpSearch.onreadystatechange = event_SearchDeptTreeViewMove;
                xmlhttpSearch.send(xmlpara);                   
            }
        }
        
        function event_SearchDeptTreeViewMove() {
            if (xmlhttpSearch != null && xmlhttpSearch.readyState == 4) {
                if (xmlhttpSearch.status == 200) {
                    reParam["ret"] = "SEARCH";
                    reParam["search"] = xmlhttpSearch.responseText;
                    
                    xmlhttpSearch = null;
                    
                    if (ReturnFunction != null) {
                        ReturnFunction(reParam);
                    } else {
                        window.returnValue = reParam;
                        window.close();
                    }
                }
            }
        }        
    </script>
</head>
<body class="popup" style="overflow: hidden;">
    <h1><spring:message code='ezApprovalG.t1236'/>- <span id="SearchWord"></span></h1>
    <div id="close">
        <ul>
            <li><span onclick="return btnCalcel_onClick()"></span></li>
        </ul>
    </div>
    <span>▒ <spring:message code='ezApprovalG.bhs02'/></span>
    <div style="width: 100%; overflow: AUTO; height: 474px; margin-top:5px;" id="divList">
        <div id="lvOuterOrganList" style="height: 100%;"></div>
    </div>
    <div class="btnpositionNew">
        <a class="imgbtn" onclick="return btnsearchDept_onClick()"><span><spring:message code='ezApprovalG.t900001'/></span></a>
        <a class="imgbtn" onclick="return btnConfirm_onClick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
    </div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; display: none;" id="mailPanel">&nbsp;</div>
    <div style="z-index: 2000; position: absolute; display: none; -webkit-border-top-left-radius: 5px; -webkit-border-top-right-radius: 5px; -webkit-border-bottom-left-radius: 5px; -webkit-border-bottom-right-radius: 5px; -moz-border-radius-topleft: 5px; -moz-border-radius-topright: 5px; -moz-border-radius-bottomleft: 5px; -moz-border-radius-bottomright: 5px; background: #ffffff; padding: 2px 2px; border: 1px solid #ffffff;" id="iFramePanel">
        <img src="/images/ProgressBar.gif" style="border: none;" id="iFrameLayer" />
    </div>
</body>
</html>
