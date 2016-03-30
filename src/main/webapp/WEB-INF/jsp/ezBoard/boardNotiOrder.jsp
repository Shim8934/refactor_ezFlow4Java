<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezBoard.t4000'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>
		<script>
		    var xmlhttp = createXMLHttpRequest();
		    var pBoardid = "${boardID}";
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
		
		        if (select.length <= 0)
		            alert("<spring:message code='ezBoard.t497'/>");
		        else {
		            if (type == 1) {
		                for (var count1 = 0; count1 < length; count1++) {
		                    if (listview.GetSelectedIndexes().split(",")[count1] == "0")
		                        alert("\"" + listview.GetSelectedRows()[count1].cells[0].innerText + "\"" + " <spring:message code='ezBoard.t125'/>");
		                    else {
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
		                    if (listview.GetSelectedIndexes().split(",")[length - 1] == cnt - 1)
		                        alert("\"" + listview.GetSelectedRows()[length - 1].cells[0].innerText + "\"" + " <spring:message code='ezBoard.t125'/>");
		                else {
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
		
		        if (cnt == 0)
		            return;
		
		        var itemid = "";
		        for (var i = 0; i < cnt; i++) {
		            itemid += list[i].getAttribute("DATA1") + ";";
		        }
		
		        xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/saveNotiOrder.do", false);
		        xmlhttp.send(itemid);
		
		        if (xmlhttp.responseText == "OK") {
		            alert("<spring:message code='ezBoard.t79'/>");
		            window.parent.parent.opener.window.location.reload();
		            window.close();
		         }
		         else
		            alert("<spring:message code='ezBoard.t80'/>");
		    }
		</script>
	</head>
	<body class="popup">
	<h1><spring:message code='ezBoard.t4000'/></h1>
	    <table>
	        <tr>
	            <td>
	                <div class="listview">
	                    <div id="NotiList" style="BORDER: 0; HEIGHT: 340px; WIDTH: 250px; overflow:auto;"></div>
	                </div>
	            </td>
	            <td>
	                <div style="padding-left:8px">
	                    <a class="imgbtn"><span onclick="movenoti(1)" style="font-family: 'Gulim', 'arial', 'verdana'">△</span></a>
	                    <br />
	                    <a class="imgbtn"><span onclick="movenoti(2)" style="font-family: 'Gulim', 'arial', 'verdana'">▽</span></a>
	                </div>
	            </td>
	        </tr>
	    </table>
	<div class="btnposition">
	    <a class="imgbtn" onClick="save_order()" name="Submit"><span><spring:message code='ezBoard.t14'/></span></a>
	    <a class="imgbtn" onClick="window.close()" name="Submit"><span><spring:message code='ezBoard.t15'/></span></a>
	</div>
	</body>
</html>