<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title><spring:message code = "ezBoard.versionManage.msg2" /></title>

    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
    <style>
        .header {
            width : 95%;
            margin : auto;
            margin-bottom : 5px;
        }

        .contentTable {
            width : 95%;
            margin : auto;
            text-align : center !important;
            margin-bottom : 15px;
        }
        
        .contentTable th {
        	text-align : center !important;
        }
        
    </style>

    <script>
        window.onload = () => {
            createDBLinkedList();
        }

        function viewSelectVersion(node) {
            var pheight = window.screen.availHeight;
            var pwidth = window.screen.availWidth;
            var pTop = (pheight - 720) / 2;
            var pLeft = (pwidth - 790) / 2;
            var idx = node.getAttribute("idx");
            var leftAddr = document.getElementById("history_" + idx + "_leftAddr").innerText;
            var rightAddr = document.getElementById("history_" + idx + "_rightAddr").innerText;
            var selectedAddr = node.getAttribute("href") + ";" + node.getAttribute("boardID") + ";" + node.getAttribute("itemID") + ";" + node.getAttribute("version");
            var url = "/ezBoard/boardItemView.do?showAdjacent=&itemID=" + encodeURIComponent(node.getAttribute("itemID")) + "&boardID=" + encodeURIComponent(node.getAttribute("boardID")) + "&location=GENERAL&historyCheck=true&leftAddr=" + encodeURI(leftAddr) + "&rightAddr=" + encodeURI(rightAddr);

            url += "&selectedAddr=" + encodeURI(selectedAddr);
            url += "&selectedViewFlag=my";
            url += "&historyModify=true";
            url += "&version=" + node.getAttribute("version");

            if (idx == 0) {
                url += "&newestVersionFlag=true";
            }

            window.open(url, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=790,top=" + pTop + ",left=" + pLeft, "");
            window.close();
        }

        function createDBLinkedList() {
            var node;
            var cnt = 0;

            while ((node = document.getElementById("history_" + cnt)) != null) {
                var leftNode = document.getElementById("history_" + (cnt - 1));
                var rightNode = document.getElementById("history_" + (cnt + 1));

                /*
                    right : 이전버전
                    left : 이후버전

                    | 최신버전 | 지금버전 | 이전버전 | ... |형태
                */

                var leftAddr = document.getElementById("history_" + cnt + "_leftAddr");
                var rightAddr = document.getElementById("history_" + cnt + "_rightAddr");

                if (leftNode != null) {
                    leftAddr.innerText = leftNode.getAttribute("href") + ";" + leftNode.getAttribute("boardID") + ";" + leftNode.getAttribute("itemID") + ";" + leftNode.getAttribute("version");
                }

                if (rightNode != null) {
                    rightAddr.innerText = rightNode.getAttribute("href") + ";" + rightNode.getAttribute("boardID") + ";" + rightNode.getAttribute("itemID") + ";" + rightNode.getAttribute("version");
                }

                cnt++;
            }
        }

        function closePopup() {

        }
    </script>

</head>
<body class = "popup" style = "margin : 5px 5px 0 5px;">
    <div><h1 class = "headTitle"><spring:message code = "ezBoard.versionManage.msg2" /></h1></div>
    <div id="close">
        <ul>
            <li><span onclick = "parent.DivPopUpHidden()"></span></li>
        </ul>
    </div>

    <div>
        <table class = "popuplist header" style>
            <tr>
                <th style = "width : 10%;"><spring:message code = "ezBoard.versionManage.tableHead1" /></th>
                <td style = "width : 15%;">${ itemInfo.writerName }</td>
                <th style = "width : 10%;"><spring:message code = "ezBoard.versionManage.tableHead2" /></th>
                <td style = "width : 25%;">${ itemInfo.writeDate }</td>
                <th style = "width : 15%;"><spring:message code = "ezBoard.versionManage.tableHead3" /></th>
                <td>${ endDate }</td>
            </tr>
            <tr>
                <th><spring:message code = "ezBoard.versionManage.tableHead4" /></th>
                <td colspan = "5">${ itemInfo.title }</td>
            </tr>
        </table>
    </div>

    <div id = "history" class = "popuplist">
        <h1><spring:message code = "ezBoard.versionManage.msg4" /></h1>
        <c:choose>
            <c:when test = "${ history.size() eq 0 }">
                <table class = "contentTable">
                    <tr>
                        <td><spring:message code = "ezBoard.versionManage.msg3" /></td>
                    </tr>
                </table>
            </c:when>
            <c:otherwise>
                <table class = "contentTable">
                    <tr>
                        <th><spring:message code = "ezBoard.versionManage.hth01" /></th>
                        <th><spring:message code = "ezBoard.updateJIH03" /></th>
                        <th><spring:message code = "ezBoard.updateJIH02" /></th>
                    </tr>

                    <c:forEach var = 'h' items = "${ history }" varStatus = 'loop'>
                    <tr id = "history_${ loop.index }" idx = "${ loop.index }" onclick = "viewSelectVersion(this)" itemID = "${ h.itemID }" boardID = "${ h.boardID }" version = "${ h.version }" href = "${ h.contentLocation }" style = "cursor : pointer;">
                        <td>${ h.version }</td>
                        <td>${ h.modifyUserID }</td>
                        <td>${ h.modifiedDate }</td>
                    </tr>
                    <tr style = "display : none;">
                        <td>
                            <addrLink_left id = 'history_${ loop.index }_leftAddr'></addrLink_left>
                            <addrLink_right id = 'history_${ loop.index }_rightAddr'></addrLink_right>
                        </td>
                    </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
