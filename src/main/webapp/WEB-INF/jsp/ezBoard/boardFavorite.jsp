<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
    	<%-- 2018-06-25 홍승비 - strLang 사용을 위해 스크립트 추가 --%>
    	<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
    	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var strPrimary = "${userInfo.primary}";
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
                    	
                    	/* 2018-07-16 홍승비 - 게시판 환경설정 >  즐겨찾기 체크박스 정렬 */
                    	if (getNodeText(listdom.getElementsByTagName("TABUSED")[i]) == "Y") {
	                        strHTML += "<td style='width:12%;text-align:center; padding-right:20px;'><div class='custom_checkbox'><input type='checkbox' BoardID='" + getNodeText(listdom.getElementsByTagName("BOARDID")[i]) + "' onclick='event_statuschange(this);' checked></div></td>";
                    	} else {
        	                strHTML += "<td style='width:12%;text-align:center; padding-right:20px;'> <div class='custom_checkbox'><input type='checkbox' BoardID='" + getNodeText(listdom.getElementsByTagName("BOARDID")[i]) + "' onclick='event_statuschange(this);'></div></td>";
                    	}
                    	
                    	/* 2019-03-29 홍승비 - 새게시물 다국어 메세지 수정 */
                    	if (getNodeText(listdom.getElementsByTagName("BOARDID")[i]) == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
							strHTML += "<td style='width:60%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'><spring:message code='ezBoard.t480'/></td>";
                    	} else {
							strHTML += "<td style='width:60%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>" + escapeHtml(getNodeText(listdom.getElementsByTagName("BOARDNAME")[i])) + "</td>";
                    	}
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
        	
        	//저장하지 않아도 탭 체크박스를 누르면 즉각적으로 반영하는 코드
        	var checkArr = new Array();
        	function event_statuschange(obj) {
	           /*  var tabUsed = "";
    	        if(obj.checked) {
      						tabUsed = "Y"; 
      					}
      					 else { 
      						tabUsed = "N";
      					}
        	 	$.ajax({
  					url : '/ezBoard/set_TabUse.do',
  					method : 'POST',
  					dataType : 'text',
  					data : {
      					pBoardList : obj.getAttribute("BoardID") ,
      					tabUsed : tabUsed
  					} ,
      				success : function(data, textStatus, jqXHR) {
  					},
  					error : function(jqXHR, textStatus, errorThrown) {
             	    	alert('Error : ' + jqXHR.status + ", " + textStatus);
  					}
  				});        */
        	}
        	function Priority_UP() {
            	if (!CrossYN()) {
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
            	else if (CrossYN()) {
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
            	obj.childNodes.item(0).style.backgroundColor = "#f1f8ff";
            	obj.childNodes.item(1).style.backgroundColor = "#f1f8ff";
            	obj.childNodes.item(2).style.backgroundColor = "#f1f8ff";
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
            	var tabBoardID = "";
            	var tabuseds = "";
            	var listArr = document.getElementById("favorite_list").getElementsByTagName("tr"); 
            	var checkedList = $("input:checkbox");
            	var checkedListY = $("input:checkbox:checked");
            	var checkedLength = checkedList.length;
            	//즐겨찾기 탭 '저장' 시, 반드시 하나 이상의 탭을 선택해야 한다.
            	if(checkedListY.length < 1){
            		alert('<spring:message code="ezBoard.t0015" />');
            		return;
            	}
            	else{
            		//즐겨찾기 게시판 순서조정용 데이터
	            	for (var i = 0; i < listArr.length; i++) {
	                	if (listArr[i].getAttribute("BoardID") != null || listArr[i].getAttribute("BoardID") != "") {
	                    	boardID += listArr[i].getAttribute("BoardID");
	                    	if (i != (listArr.length - 1))
	                        	boardID += ";";
	                	}
	            	}	            	
	            	//즐겨찾기 게시판 삭제용 데이터
	            	var delBoardID = "";
	            	for (var i = 0; i < delArr.length; i++) {
	                	delBoardID += delArr[i];
	                	if (i != delArr.length - 1)
	                    	delBoardID += ";";
	            	}
	            	$.ajax({
	 					url : '/ezBoard/saveListOrder.do',
	 					method : 'POST',
	 					dataType : 'text',
	 					data : {
		     				pBoardList : boardID ,
			 				pDelboardList : delBoardID,
	 					} ,
	     				success : function(data, textStatus, jqXHR) {
		 					alert('<spring:message code="ezEmail.t42" />');
	 					},
	 					error : function(jqXHR, textStatus, errorThrown) {
	            	    	alert('Error : ' + jqXHR.status + ", " + textStatus);
	 					}
	 				});
	            	//즐겨찾기 게시판 탭 표출용 데이터
	            	checkedList.each(function(index){
	            		tabBoardID += $(this).attr("boardid");
	            		if(this.checked == true ){
            				tabuseds += "Y";
            			}else{
            				tabuseds += "N";
            			}
	            		if(index !== checkedLength -1 ){
	            			tabBoardID +=  ";";	
	            			tabuseds += ";";
	            		}
	            	});
	            	
	            	$.ajax({
	  					url : '/ezBoard/set_TabUse2.do',
	  					method : 'POST',
	  					dataType : 'text',
	  					data : {
	      					pBoardList : tabBoardID ,
	      					tabUsed :  tabuseds
	  					} ,
	      				success : function(data, textStatus, jqXHR) {
	  					},
	  					error : function(jqXHR, textStatus, errorThrown) {
	             	    	alert('Error : ' + jqXHR.status + ", " + textStatus);
	  					}
	  				});       
            	}
        	}
        	
        	var delArr = new Array();
        	function favorite_Delete() {
            	if (_RowObject == null) {
            		alert('<spring:message code="ezBoard.t0015" />');
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
			function escapeHtml(text) {
				var map = {
					'&': '&amp;',
					'<': '&lt;',
					'>': '&gt;',
					'"': '&quot;',
					"'": '&#039;'
				};
				return text.replace(/[&<>"']/g, function(m) { return map[m]; });
			}
    	</script>
    	<style>
    		.mainlist tr th {border-top:0px}
    	</style>    	
	</head>
	<body style="margin-left: 10px; margin-right: 10px;">
		<br/>
    	<span class="txt">▒ 
        	<img src="/images/ImgIcon/prev.gif" style="height: 16px; vertical-align: middle; text-align: center;" />
        	<img src="/images/ImgIcon/next.gif" align="absmiddle" style="height: 16px; margin-top: 3px;" />
        	: <spring:message code="ezBoard.t00015" />
    	</span>
    	<br />    	
    	<br />
    	<div id="mainmenu">
        	<ul id="tb_Parent">
            	<li>
                	<span class="icon16 icon16_delete" onclick="favorite_Delete();"></span>
            	</li>
            	<li>
                	<span class="icon16 icon16_refresh" onclick="favorite_reload()"></span>
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
    	<div style="border: 1px solid #dbdbda; width: 435px; height: 394px;">
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
        	<div class="btnpositionJsp" style="width:422px; text-align:center;">
            	<a class="imgbtn" onclick="Save();">
                	<span><spring:message code="ezBoard.t98" /></span>
            	</a>
        	</div>
    	</div>
	</body>
</html>