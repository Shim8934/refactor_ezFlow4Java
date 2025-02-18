<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t4000'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			.mainlist tr th {
				border-top:0px;
			}
			<%-- 2018-10-23 홍승비 - 공지순서 테이블 내부 마우스 드래그, 셀렉트 방지 추가 --%>
			table {
				-ms-user-select: none; 
				-moz-user-select: -moz-none;
				-khtml-user-select: none;
				-webkit-user-select: none;
				user-select: none;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list_admin.js')}"></script>
		<script>
		    var xmlhttp = createXMLHttpRequest();
		    var pBoardid = "<c:out value='${boardID}'/>";
		    var board_alertArguments = new Array();
		    board_alertArguments[1] = DivPopUpHidden;
		    window.onload = function () {
		        xmlhttp = null;
		        xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/getNotiitemList.do", true);
		        xmlhttp.onreadystatechange = getBoardList_after;
		        xmlhttp.send(pBoardid);
		    };
		
		    function getBoardList_after() {
		        if (xmlhttp == null || xmlhttp.readyState != 4) return;
		
		        var listview = new ListView();
		        listview.SetID("NotiistView");
		        listview.SetMulSelectable(true);
		        listview.DataSource(xmlhttp.responseXML);
		        listview.DataBind("NotiList");
		    }
		
		    function movenoti(type) {
		        var listview = new ListView();
		        listview.LoadFromID("NotiistView");
		        
		        var cnt = listview.GetRowCount();
		
		        var select = listview.GetSelectedIndexes();
		        var length = listview.GetSelectedIndexes().split(",").length;
		        var selRow = listview.GetSelectedRows();
		
		        if (select.length <= 0){
		        	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t497' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t497'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(300, 205, pUrl);
// 		            alert("<spring:message code='ezBoard.t497'/>");
		        } else {
		            if (type == 1) {
		                for (var count1 = 0; count1 < length; count1++) {
		                    if (listview.GetSelectedIndexes().split(",")[count1] == "0"){
		                    	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t125' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t125'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
		    					DivPopUpShow(300, 205, pUrl);
// 		    					alert("<spring:message code='ezBoard.t125'/>");
		                    } else {
		                        var item1 = selRow[count1];
		                        var item2 = selRow[count1].previousSibling;
		                        var parent = item1.parentNode;
		                        var itemtmp = item1.cloneNode(1);
		                        item2 = parent.replaceChild(itemtmp, item2);
		                        parent.replaceChild(item2, item1);
		                        parent.replaceChild(item1, itemtmp);
		                    }
		                }
		            }
		            else {
		                for (var count1 = 0; count1 < length; length--) {
		                    if (listview.GetSelectedIndexes().split(",")[length - 1] == cnt - 1) {
		                    	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t125' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t125'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
		    					DivPopUpShow(300, 205, pUrl);
// 		    					alert("<spring:message code='ezBoard.t125'/>");
		                    } else {
			                    var item1 = selRow[length - 1];
			                    var item2 = selRow[length - 1].nextSibling;
			                    var parent = item1.parentNode;
			                    var itemtmp = item1.cloneNode(1);
			                    item2 = parent.replaceChild(itemtmp, item2);
			                    parent.replaceChild(item2, item1);
			                    parent.replaceChild(item1, itemtmp);
		                	}
		            }
		            }
		        }
		    }
		
		    function save_order() {
		        listview = new ListView();
		
		        listview.LoadFromID("NotiistView");
		
		        var cnt = listview.GetRowCount();
		        var list = listview.GetDataRows();
		
		        if (cnt == 0) {
					window.close();
		            return;
		        }
		
		        var itemid = "";
		        for (var i = 0; i < cnt; i++) {
		            itemid += list[i].getAttribute("DATA1") + ";";
		        }
		
		        xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/saveNotiOrder.do", false);
		        xmlhttp.send(itemid);
		
		        if (xmlhttp.responseText == "OK") {
		        	board_alertArguments[1] = window.close;
		        	window.parent.parent.opener.window.location.reload();
		        	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t79' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t79'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(300, 205, pUrl);
// 		            alert("<spring:message code='ezBoard.t79'/>");
		         } else {
		        	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t80' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t80'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(300, 205, pUrl);
// 					alert("<spring:message code='ezBoard.t80'/>");
		         }
		            
		    }
		</script>
	</head>
	<body class="popup">
	<h1><spring:message code='ezBoard.t4000'/></h1>
	<div id="close">
        <ul>
            <li><span onclick="window.close()"></span></li>
        </ul>
    </div>
    <table style="border:1px solid #ddd">
        <tr>
            <td style="border-right:1px solid #ddd">
                <div class="listview" style="border:0px">
                    <div id="NotiList" style="BORDER: 0; HEIGHT: 340px; WIDTH: 300px; overflow:auto;"></div>
                </div>
            </td>
            <td>
                <div style="padding:0px 5px">
                    <a class="imgbtn imgbck"><span onclick="movenoti(1)">△</span></a>
                    <br />
                    <a class="imgbtn imgbck"><span onclick="movenoti(2)">▽</span></a>
                </div>
            </td>
        </tr>
    </table>
	<div class="btnposition btnpositionNew">
	    <a class="imgbtn" onClick="save_order()" name="Submit"><span><spring:message code='ezBoard.t14'/></span></a>
	</div>
	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
    </div>
	</body>
</html>