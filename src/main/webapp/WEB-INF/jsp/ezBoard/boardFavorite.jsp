<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css" />
    	<link rel="stylesheet" href="/css/Tab.css" type="text/css" />
    	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
    	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
        	var xmlhttp = null;
        	document.onselectstart = function () { return false; };
        	window.onload = window_onload();
        
        	function window_onload() {
 				xmlhttp = createXMLHttpRequest();
        		xmlhttp.open("POST", "/ezBoard/get_favoriteList.do?mode=ALL", true);
            	xmlhttp.onreadystatechange = get_listComplete_after;
            	xmlhttp.send();
        	}
        	function favorite_reload() {
            	xmlhttp = null;
            	_RowObject = null;
            	delArr = new Array();
            	checkArr = new Array();
            	document.getElementById("contentlist").innerHTML = "<table id='favorite_list' class='mainlist' style='width:100%;'><tr><td style='text-align:center;'><img src='/images/email/progress_img.gif' /></td></tr></table>";
            	xmlhttp = createXMLHttpRequest();
            	xmlhttp.open("POST", "/ezBoard/get_favoriteList.do?mode=ALL", true);
            	xmlhttp.onreadystatechange = get_listComplete_after;
            	xmlhttp.send();
        	}
        	function get_listComplete_after() {
            	if (xmlhttp.readyState != 4) return;
            	var listdom = xmlhttp.responseXML;         
            	var parentXmlhttp = null;
            	parentXmlhttp = createXMLHttpRequest();
            	xmlpara = createXmlDom();
            	var objRoot, objNode;
            	createNodeInsert(xmlpara, objNode, "DATA");        
            	if (listdom.getElementsByTagName("ROW").length > 0) {
                	var strHTML = "<table id='favorite_list'  class='mainlist' style='width:100%;'>";
                	var parentBoardName = getNodeText(listdom.getElementsByTagName("TOPBOARDLIST")[0]).split(';');
                	for (var i = 0; i < listdom.getElementsByTagName("ROW").length; i++) {
                    	strHTML += "<tr BoardID='" + getNodeText(listdom.getElementsByTagName("BOARDID")[i]) + "' BoardOrder='" + i + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);'>";
                    	if (getNodeText(listdom.getElementsByTagName("TABUSED")[i]) == "Y")
	                        strHTML += "<td style='width:12%;text-align:center;'><input type='checkbox' BoardID='" + getNodeText(listdom.getElementsByTagName("BOARDID")[i]) + "' onclick='event_statuschange(this);' checked></td>";
    	                else
        	                strHTML += "<td style='width:12%;text-align:center;'><input type='checkbox' BoardID='" + getNodeText(listdom.getElementsByTagName("BOARDID")[i]) + "' onclick='event_statuschange(this);'></td>";
            		        strHTML += "<td style='width:60%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>" + getNodeText(listdom.getElementsByTagName("BOARDNAME")[i]) + "</td>";
                    	strHTML += "<td style='width:28%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>" + parentBoardName[i] + "</td>";
                    	strHTML += "</tr>";
                	}
                	strHTML += "</table>";
                	document.getElementById("contentlist").innerHTML = strHTML;
            	}
            	else {
                	document.getElementById("contentlist").innerHTML = "<table id='favorite_list'  class='mainlist' style='width:100%;'><tr><td align='center'>" + strLang53 + "</td></tr></table>";
            	}	
        	}
        	var checkArr = new Array();
        	function event_statuschange(obj) {
	            var tabUsed = "";
    	        if(obj.checked) {
      						tabUsed = "Y"; 
      					}
      					 else { 
      						tabUsed = "N";
      					}
        	 	$.ajax({
  					url : '/ezBoard/set_TabUse.do',
  					method : 'POST',
  					dataType : 'json',
  					data : {
      					pBoardList : obj.getAttribute("BoardID") ,
      					tabUsed : tabUsed
  					} ,
      				success : function(data, textStatus, jqXHR) {
  					},
  					error : function(jqXHR, textStatus, errorThrown) {
             	    	alert('Error : ' + jqXHR.status + ", " + textStatus);
  					}
  				});       
        	}
        	function Priority_UP() {
            	if (navigator.userAgent.indexOf("MSIE") != -1) {
                	if (_RowObject == null) {
                		alert('<spring:message code="ezBoard.t0015" />');
                    	return;
                	}
                	var ChangeRow = null;
                	for (var i = 0; i < _RowObject.parentNode.childNodes.length; i++) {
	                    if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
    	                    if (i == 0) {
        	                    return;
            	            }
                	        ChangeRow = i - 1;
                    	    swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));
	                        break;
    	                }
        	        }
            	}
            	else if (navigator.userAgent.indexOf("MSIE") == -1) {
                	if (_RowObject == null) {
                		alert('<spring:message code="ezBoard.t0015" />');
                        	return;
                    	}
                    	var ChangeRow = null;
                    	for (var i = 0; i < _RowObject.parentNode.children.length; i++) {
                        	if (_RowObject.parentNode.children.item(i) == _RowObject) {
	                            if (i == 0) {
    	                            return;
        	                    }
            	                ChangeRow = i - 1;
                	            swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));
                    	        break;
                        	}
                    	}
                	}
            	ReOrder();
        	}
        	function Priority_DOWN() {
            	if (_RowObject == null) {
            		alert('<spring:message code="ezBoard.t0015" />');
                	return;
            	}
            	var ChangeRow = null;
            	for (var i = 0; i < _RowObject.parentNode.childNodes.length - 1; i++) {
	                if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
    	                if (i == _RowObject.parentNode.childNodes.length - 1) {
        	                return;
            	        }
                	    ChangeRow = i + 1;
                    	swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));
                    	break;
                	}
            	}
            	ReOrder();
        	}
        	function event_Mover(obj) {
	            if (obj != _RowObject) {
    	            obj.childNodes.item(0).style.backgroundColor = "#EDEDED";
        	        obj.childNodes.item(1).style.backgroundColor = "#EDEDED";
            	    obj.childNodes.item(2).style.backgroundColor = "#EDEDED";
            	}	
        	}
        	function event_Mout(obj) {
            	if (obj != _RowObject) {
                	obj.childNodes.item(0).style.backgroundColor = "#FFFFFF";
                	obj.childNodes.item(1).style.backgroundColor = "#FFFFFF";
                	obj.childNodes.item(2).style.backgroundColor = "#FFFFFF";
            	}
        	}
        	var _RowObject = null;
        	function event_click(obj) {
            	if (_RowObject != null) {
                	_RowObject.childNodes.item(0).style.backgroundColor = "#ffffff";
                	_RowObject.childNodes.item(1).style.backgroundColor = "#ffffff";
                	_RowObject.childNodes.item(2).style.backgroundColor = "#ffffff";
            	}
            	_RowObject = obj;
            	obj.childNodes.item(0).style.backgroundColor = "#DBE1E7";
            	obj.childNodes.item(1).style.backgroundColor = "#DBE1E7";
            	obj.childNodes.item(2).style.backgroundColor = "#DBE1E7";
        	}
        	function swapNodes(item1, item2) {
            	var itemtmp = item1.cloneNode(1);
            	var parent = item1.parentNode;
            	item2 = parent.replaceChild(itemtmp, item2);
            	item1.setAttribute("_priority", item2.getAttribute("_priority"));
            	item2.setAttribute("_priority", itemtmp.getAttribute("_priority"));
            	parent.replaceChild(item2, item1);
            	parent.replaceChild(item1, itemtmp);
            	itemtmp = null;
        	}
        	function Save() {
            	var boardID = "";
            	var listArr = document.getElementById("favorite_list").getElementsByTagName("tr");
            	for (var i = 0; i < listArr.length; i++) {
                	if (listArr[i].getAttribute("BoardID") != null || listArr[i].getAttribute("BoardID") != "") {
                    	boardID += listArr[i].getAttribute("BoardID");
                    	if (i != (listArr.length - 1))
                        	boardID += ";";
                	}
            	}
            	var delBoardID = "";
            	for (var i = 0; i < delArr.length; i++) {
                	delBoardID += delArr[i];
                	if (i != delArr.length - 1)
                    	delBoardID += ";";
            	}
            	$.ajax({
 					url : '/ezBoard/saveListOrder.do',
 					method : 'POST',
 					dataType : 'json',
 					data : {
	     				pBoardList : boardID ,
		 				pDelboardList : delBoardID,
 					} ,
     				success : function(data, textStatus, jqXHR) {
	 					alert('<spring:message code="ezBoard.t0014" />');
 					},
 					error : function(jqXHR, textStatus, errorThrown) {
            	    	alert('Error : ' + jqXHR.status + ", " + textStatus);
 					}
 				});       
        	}
        	var delArr = new Array();
        	function favorite_Delete() {
            	if (_RowObject == null) {
            		alert('<spring:message code="ezBoard.t5005" />');
                	return;
            	}
            	if (_RowObject.getAttribute("BoardID") == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
            		alert('<spring:message code="ezBoard.t999068" />');
                	return;
            	}
            	var listview = document.getElementById("favorite_list");
            	var listview_TR = listview.getElementsByTagName("TR");
            	delArr.push(_RowObject.getAttribute("BoardID"));
            	listview.deleteRow(_RowObject.getAttribute("BoardOrder"));
            	for (var i = 0; i < listview_TR.length; i++) {
                	listview_TR[i].setAttribute("BoardOrder", i);
            	}
	            _RowObject = null;
    	    }
        	function ReOrder() {
            	var listview = document.getElementById("favorite_list");
            	var listview_TR = listview.getElementsByTagName("TR");
            	for (var i = 0; i < listview_TR.length; i++) {
                	listview_TR[i].setAttribute("BoardOrder", i);
            	}
        	}
    	</script>
	</head>
	<body style="margin-left: 10px; margin-right: 10px;">
    	<h2 class="h2_dot"><spring:message code="ezBoard.t00010" /></h2>
    	<span class="txt" style="margin-left: 13px;">* <spring:message code="ezBoard.t00014" /></span><br />
    	<span class="txt" style="margin-left: 13px;">* 
        	<img src="/images/ImgIcon/prev.gif" style="height: 16px; margin-top: -3px; vertical-align: middle; text-align: center;" />
        	<img src="/images/ImgIcon/next.gif" align="absmiddle" style="height: 16px; margin-top: -3px;" />
        	: <spring:message code="ezBoard.t00015" />
    	</span>
    	<br />
    	<br />
    	<br />
    	<div id="mainmenu">
        	<ul id="tb_Parent">
            	<li>
                	<span onclick="favorite_Delete();">
                    	<img src="/images/ImgIcon/delete.gif" style="margin-top: -2px;" /><spring:message code="ezBoard.t89" /></span>
            	</li>
            	<li>
                	<span onclick="favorite_reload()">
                    	<img src="/images/ImgIcon/recur.gif" style="margin-top: -2px;" /><spring:message code="ezBoard.t205" /></span>
            	</li>
            	<li>
                	<span onclick="Priority_UP()">
                    	<img src="/images/ImgIcon/prev.gif" style="margin-top: -2px;" /></span>
            	</li>
            	<li>
                	<span onclick="Priority_DOWN()">
                    	<img src="/images/ImgIcon/next.gif" style="margin-top: -2px;" /></span>
            	</li>
        	</ul>
    	</div>
    	<div style="border: 1px solid #dbdbda; width: 435px; height: 385px;">
        	<table class="mainlist" style="width: 100%;">
            	<tr>
                	<th style="width: 12%;"><span><spring:message code="ezBoard.t00016" /></span></th>
                	<th style="width: 60%;"><span><spring:message code="ezBoard.t00017" /></span></th>
                	<th style="width: 28%;"><span><spring:message code="ezBoard.t00018" /></span></th>
            	</tr>
        	</table>
        	<div id="contentlist" name="contentlist" style="height: 353px; overflow-y: auto;">
            	<table id='favorite_list' class="mainlist" style="width: 100%;">
                	<tr>
                    	<td style="text-align: center;">
                        	<img src="/images/email/progress_img.gif" />
                    	</td>
                	</tr>
            	</table>
        	</div>
        	<br />
        	<div style="width:435px; text-align:center;">
            	<a class="imgbtn" onclick="Save();">
                	<span><spring:message code="ezBoard.t98" /></span>
            	</a>
        	</div>
    	</div>
	</body>
</html>