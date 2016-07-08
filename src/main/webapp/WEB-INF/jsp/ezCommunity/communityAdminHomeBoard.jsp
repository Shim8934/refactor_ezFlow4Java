<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<c:if test="${sysopCheck != '1' }">
			<spring:message code = 'ezCommunity.t447' />
			<%
				if (true) {
					return;
				}
			 %>
		</c:if>
		
		<script type="text/javascript">
			var code = "<c:out value = '${code}' />";
			var xmldom = "";
		    var xmldom2 = "";
		    var xmldom3 = "";

		    window.onload = function () {
		        var xmldom = loadXMLString('${returnVal}');
		        var DocList = new ListView();
		        DocList.SetID("lvboardForm");
		        DocList.SetTitleIdx(0);
		        DocList.SetMulSelectable(true);
		        DocList.SetUrgentFlag(true);
		        DocList.DataSource(xmldom);
		        DocList.DataBind("CopBoardList");
		        DocList = null;

		        var xmldom2 = loadXMLString("${returnVal2}");
		        var DocList = new ListView();
		        DocList.SetID("lvboardForm2");
		        DocList.SetTitleIdx(0);
		        DocList.SetMulSelectable(true);
		        DocList.SetUrgentFlag(true);
		        DocList.DataSource(xmldom2);
		        DocList.DataBind("LeftBoardList");
		        DocList = null;

		        var xmldom3 = loadXMLString("${returnVal3}");
		        var DocList = new ListView();
		        DocList.SetID("lvboardForm3");
		        DocList.SetTitleIdx(0);
		        DocList.SetMulSelectable(true);
		        DocList.SetUrgentFlag(true);
		        DocList.DataSource(xmldom3);
		        DocList.DataBind("RightBoardList");
		        DocList = null;
		    }

		    function leftmoveboard(val) {
		        switch (val) {
		            case 1:
		                boardlistup("lvboardForm2");
		                break;
		            case 2:
		                boardlistdown("lvboardForm2");
		                break;
		            case 3:
		                adddeletelist("lvboardForm", "lvboardForm2");
		                break;
		            case 4:
		                adddeletelist("lvboardForm2", "lvboardForm");
		                break;
		        }
		    }

		    function rightmoveboard(val) {
		        switch (val) {
		            case 1:
		                boardlistup("lvboardForm3");
		                break;
		            case 2:
		                boardlistdown("lvboardForm3");
		                break;
		            case 3:
		                adddeletelist("lvboardForm3", "lvboardForm");
		                break;
		            case 4:
		                adddeletelist("lvboardForm", "lvboardForm3");
		                break;
		        }
		    }

		    function adddeletelist(dellist, addlist) {
		        listview = new ListView();
		        listview2 = new ListView();

		        listview.LoadFromID(dellist);
		        listview2.LoadFromID(addlist);

		        var select = listview.GetSelectedIndexes();
		        var length = listview.GetSelectedIndexes().split(",").length;
		        var selRow = listview.GetSelectedRows();

		        if (listview2.GetDataRows().length > 0 && listview2.GetDataRows()[0].id.indexOf("noItems") > -1)
		            listview2.DeleteRow(listview2.GetDataRows()[0].id);

		        if (select.length <= 0)
		            alert("<spring:message code = 'ezCommunity.t2017' />");
		        else {
		            for (var count1 = 0; count1 < length; count1++) {
		                var length2 = listview2.GetRowCount();
		                var boardid = selRow[count1].getAttribute("DATA1");
		                var boardname = selRow[count1].cells[0].innerText;
		                listdelete(listview, selRow[count1]);
		                if (!listview2.ExistRow("DATA1", boardid)) {
		                    var strXML = listAdd(boardid, boardname);
		                    objTr = listview2.AddRow(length2);
		                    SetAttribute(objTr, "id", addlist + "_TR_" + length2);
		                    xmlRtn = loadXMLString(strXML);
		                    listview2.AddDataRow(objTr, xmlRtn);
		                }
		                else {
		                    alert("<spring:message code = 'ezCommunity.t902' />");
		                }
		            }
		        }
		    }

		    function listdelete(list, selrow) {
		        selrow.parentElement.removeChild(selrow);
		        for (var i = 0; i < list.GetRowCount(); i++) {
		            list.GetDataRows()[i].id = list.GetID() + "_TR_" + i;
		            list.GetDataRows()[i].onclick = new Function("tr_select(\"" + list.GetDataRows()[i].id + "\", \"" + list.GetID() + "\");");
		        }
		        if (list.GetRowCount() == 0) {
		            switch (list.GetID()) {
		                case "lvboardForm":
		                    document.getElementById("CopBoardList").innerHTML = "";
		                    var xmldom = loadXMLString('${listHeader}');
		                    var DocList = new ListView();
		                    DocList.SetID("lvboardForm");
		                    DocList.SetTitleIdx(0);
		                    DocList.SetMulSelectable(true);
		                    DocList.SetUrgentFlag(true);
		                    DocList.DataSource(xmldom);
		                    DocList.DataBind("CopBoardList");
		                    DocList = null;
		                    break;
		                case "lvboardForm2":
		                    document.getElementById("LeftBoardList").innerHTML = "";
		                    var xmldom2 = loadXMLString("${listHeader2}");
		                    var DocList = new ListView();
		                    DocList.SetID("lvboardForm2");
		                    DocList.SetTitleIdx(0);
		                    DocList.SetMulSelectable(true);
		                    DocList.SetUrgentFlag(true);
		                    DocList.DataSource(xmldom2);
		                    DocList.DataBind("LeftBoardList");
		                    DocList = null;
		                    break;
		                case "lvboardForm3":
		                    document.getElementById("RightBoardList").innerHTML = "";
		                    var xmldom3 = loadXMLString("${listHeader3}");
		                    var DocList = new ListView();
		                    DocList.SetID("lvboardForm3");
		                    DocList.SetTitleIdx(0);
		                    DocList.SetMulSelectable(true);
		                    DocList.SetUrgentFlag(true);
		                    DocList.DataSource(xmldom3);
		                    DocList.DataBind("RightBoardList");
		                    DocList = null;
		                    break;
		            }
		        }
		    }

		    function listAdd(boardid, boardname) {
		        pparsingXML = "<LISTVIEWDATA><HEADERS>";
		        pparsingXML = pparsingXML + "<HEADER><NAME></NAME><WIDTH>70</WIDTH></HEADER>";
		        pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";

		        pparsingXML = pparsingXML + "<VALUE>" + boardname + "</VALUE>";
		        pparsingXML = pparsingXML + "<DATA1>" + boardid + "</DATA1>";
		        pparsingXML = pparsingXML + "</CELL></ROW>";

		        pparsingXML = pparsingXML + "</ROWS></LISTVIEWDATA>";

		        return pparsingXML;
		    }

		    function boardlistup(list) {
		        listview = new ListView();
		        listview.LoadFromID(list);

		        var cnt = listview.GetRowCount();

		        var select = listview.GetSelectedIndexes();
		        var length = listview.GetSelectedIndexes().split(",").length;
		        var selRow = listview.GetSelectedRows();

		        if (select.length <= 0)
		            alert("<spring:message code = 'ezCommunity.t2017' />");
		        else {
		            for (var count1 = 0; count1 < length; count1++) {
		                if (listview.GetSelectedIndexes().split(",")[count1] == "0")
		                    alert("\"" + listview.GetSelectedRows()[count1].cells[0].innerText + "\"" + " <spring:message code = 'ezCommunity.t342' />");
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
		    }

		    function boardlistdown(list) {
		        listview = new ListView();
		        listview.LoadFromID(list);

		        var cnt = listview.GetRowCount();

		        var select = listview.GetSelectedIndexes();
		        var length = listview.GetSelectedIndexes().split(",").length;
		        var selRow = listview.GetSelectedRows();

		        if (select.length <= 0)
		            alert("<spring:message code = 'ezCommunity.t2017' />");
		        else {
		            for (var count1 = 0; count1 < length; length--) {
		                if (listview.GetSelectedIndexes().split(",")[length - 1] == cnt-1)
		                    alert("\"" + listview.GetSelectedRows()[length - 1].cells[0].innerText + "\"" + " <spring:message code = 'ezCommunity.t342' />");
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

		    function save_onclick() {
		        listview = new ListView();
		        listview2 = new ListView();

		        listview.LoadFromID("lvboardForm2");
		        listview2.LoadFromID("lvboardForm3");

		        var leftcnt = listview.GetRowCount();
		        var leftlist = listview.GetDataRows();

		        var rightcnt = listview2.GetRowCount();
		        var rightlist = listview2.GetDataRows();

		        var leftboardid = "";
		        var rightboardid = "";
		        for (var i = 0; i < leftcnt; i++) {
		            leftboardid += leftlist[i].getAttribute("DATA1") + ";";
		        }

		        for (var i = 0; i < rightcnt; i++) {
		            rightboardid += rightlist[i].getAttribute("DATA1") + ";";
		        }

		        xmlhttp = createXMLHttpRequest();

		        var xmlDom = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "CODE", code);
		        createNodeAndInsertText(xmlDom, objNode, "LEFT", leftboardid);
		        createNodeAndInsertText(xmlDom, objNode, "RIGHT", rightboardid);

		        xmlhttp.open("POST", "/ezCommunity/saveHomeBoard.do", false);
		        xmlhttp.send(xmlDom);

		        if (xmlhttp.responseText == "OK") {
		            alert("<spring:message code = 'ezCommunity.t153' />");
		            window.parent.parent.opener.window.location.reload();
		        }
		        else
		            alert("<spring:message code = 'ezCommunity.t283' />");
		    }
		    function cancel_click() {
		        window.location.href = "/ezCommunity/adminHomeBoard.do?code=" + code;
		    }
		</script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code = 'ezCommunity.t2014' /></h1>
	    <table style="height:390px">
	        <tr>
	            <td style="width:170px;vertical-align:top;border:1px solid gray;">
	                <div id="LeftBoardList" style="margin-top:-1px;overflow:auto;height:390px;"></div>
	            </td>
	            <td style="text-align:center">
	                <a class="imgbtn"><span onclick="leftmoveboard(1)" style="font-family:'Gulim', 'arial', 'verdana'" >△</span></a>
	                <a class="imgbtn"><span onclick="leftmoveboard(2)" style="font-family:'Gulim', 'arial', 'verdana'">▽</span></a>
	                <a class="imgbtn"><span onclick="leftmoveboard(3)" style="font-family:'Gulim', 'arial', 'verdana'">◁</span></a>
	                <a class="imgbtn"><span onclick="leftmoveboard(4)" style="font-family:'Gulim', 'arial', 'verdana'">▷</span></a>
	            </td>
	            <td style="width:170px;vertical-align:top;border:1px solid gray;">
	                <div id="CopBoardList" style="margin-top:-1px;overflow:auto;height:390px;"></div>
	            </td>
	            <td style="text-align:center">
	                <a class="imgbtn"><span onclick="rightmoveboard(1)" style="font-family:'Gulim', 'arial', 'verdana'">△</span></a>
	                <a class="imgbtn"><span onclick="rightmoveboard(2)" style="font-family:'Gulim', 'arial', 'verdana'">▽</span></a>
	                <a class="imgbtn"><span onclick="rightmoveboard(4)" style="font-family:'Gulim', 'arial', 'verdana'">▷</span></a>
	                <a class="imgbtn"><span onclick="rightmoveboard(3)" style="font-family:'Gulim', 'arial', 'verdana'">◁</span></a>
	            </td>
	            <td style="width:170px;vertical-align:top;border:1px solid gray;">
	                <div id="RightBoardList" style="margin-top:-1px;overflow:auto;height:390px;"></div>
	            </td>
	        </tr>
	    </table>
	    
	    <br />
	    <div style="text-align:center">
		    <a class="imgbtn"><span onclick="save_onclick()" ><spring:message code = 'ezCommunity.t20' /></span></a>
		    <a class="imgbtn"><span onclick="cancel_click()" ><spring:message code = 'ezCommunity.t109' /></span></a>
		    <a class="imgbtn"><span onclick="parent.parent.window.close()" ><spring:message code = 'ezCommunity.t21' /></span></a>
	    </div>
	</body>
</html>