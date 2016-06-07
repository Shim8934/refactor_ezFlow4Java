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
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var UpperBoardID = "${upperBoardID}";
	        var BoardID = "${boardID}";
	        var ParentBoardID = "${parentBoardID}";
	        var BoardGroupID = "${boardGroupID}";
	        var code = "${code}";
	        var iMenuNum = 4;
	        var xmlhttp = createXMLHttpRequest();
	        var xmldom = createXmlDom();
		
			window.onload = function () {
				GetSubBoards();
	        }
	
	        function Save() {
	            var listview = new ListView();
	            listview.LoadFromID("BoardListView");
	            var iRowCount = listview.GetRowCount();
	            var strBoardList = "";
	
	            if (iRowCount != 0) {
	                for (i = 0; i < iRowCount; i++) {
	                    strBoardList += listview.GetDataRows()[i].childNodes[0].getAttribute("DATA1") + ";";
	                }
	            }
	
	            var strXML = "";
	            strXML += "<NODES>";
	            strXML += "<NODE>";
	            strXML += "<BOARDIDLIST>" + strBoardList + "</BOARDIDLIST>";
	            strXML += "</NODE>";
	            strXML += "</NODES>";
	
	            xmldom = createXmlDom();
	            xmldom.async = false;
	            xmldom.preserveWhiteSpace = true;
	            xmldom = loadXMLString(strXML);
	
	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezCommunity/saveBoardOrder.do", false);
	            xmlhttp.send(xmldom);
	
	            if (xmlhttp.responseText.indexOf("OK") > -1) {
	                alert("<spring:message code = 'ezCommunity.t282' />");
			    	parent.window.frames.left.location.reload();
			    	parent.window.frames.right.location.href = "/ezCommunity/adminBasic.do?code=${code}";
		        } else {
		            alert("<spring:message code = 'ezCommunity.t283' />");
				}
		    }

		    function cancel() {
		        var ret = confirm("<spring:message code = 'ezCommunity.t360' />");
			    if (ret == true) window.close();
			}
		
			function GetSubBoards() {
			    xmlhttp.open("POST", "/ezCommunity/adminGetSubBoards.do?upperBoardID=" + UpperBoardID + "&code=" + code, false);
			    xmlhttp.send();
		
			    xmldom = loadXMLString(getXmlString(xmlhttp.responseXML));
		
			    DisplayBoardList();
			}
		
			function DisplayBoardList() {
			    var listview = new ListView();
			    listview.SetID("BoardListView");
			    listview.SetMulSelectable(false);
			    listview.DataSource(document.getElementById("listviewheader"));
			    listview.DataBind("BoardList");
			    var xmldomNode = SelectNodes(xmldom, "NODES/NODE");
			    
			    if (xmldomNode.length > 0) {
			        listview.DeleteRow(listview.GetDataRows()[0].id);
			    }
			    
			    for (i = 0; i < xmldomNode.length; i++) {
			        var listTR = listview.AddRow(listview.GetRowCount());
			        var listTD = document.createElement("TD");
			        var listTDText = document.createTextNode(SelectSingleNodeValue(xmldomNode[i], "DATA2"));
			        listTD.setAttribute("DATA1", SelectSingleNodeValue(xmldomNode[i], "DATA1"));
			        listTD.appendChild(listTDText);
			        listTR.appendChild(listTD);
			    }
			    
			    xmldomNode = null;
			    xmldom = null;
			}
		
			function MoveUp_onclick() {
			    var listview = new ListView();
			    listview.LoadFromID("BoardListView");
			    var selnode = listview.GetDataRows();
			    
			    if (selnode != null) {
			        if (selnode.length > 0) {
			            listview.RowMoveUp();
			        }
			    }
			}
		
			function MoveDown_onclick() {
			    var listview = new ListView();
			    listview.LoadFromID("BoardListView");
			    var selnode = listview.GetDataRows();
			    
			    if (selnode != null) {
			        if (selnode.length > 0) {
			            listview.RowMoveDown();
			        }
			    }
			}
		
			function OpenRightMenu(pIndex) {
		
			    if (BoardID == "" && pIndex == 6) {
			        alert("<spring:message code = 'ezCommunity.t289' />");
				    return;
				}
		
		        curMenuIndex = pIndex;
		
		        if (BoardID == "" && pIndex != 9 && pIndex != 7 && pIndex != 6) {
		            alert("<spring:message code = 'ezCommunity.t289' />");
				    return;
				}
		
		        if (BoardID == ParentBoardID && pIndex != 1 && pIndex != 2 && pIndex != 3 && pIndex != 4 && pIndex != 9 && pIndex != 7 && pIndex != 6) {
		            alert("<spring:message code = 'ezCommunity.t290' />");
				    return;
				}
		
		        switch (pIndex) {
		            case 1:
		                window.location.href = "/ezCommunity/boardProperty.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
		                break;
		            case 2:
		                window.location.href = "/ezCommunity/boardCreate.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
		                break;
		            case 3:
		                window.location.href = "/ezCommunity/boardACL.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
		                break;
		            case 4:
		                window.location.href = "/ezCommunity/boardOrder.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
		                break;
		            case 5:
		                if (BoardID == BoardGroupID) {
		                    alert("<spring:message code = 'ezCommunity.t377' />");
				        } else {
				            window.location.href = "/ezCommunity/boardMove.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
				        }
		                break;
		            case 6:
		                window.location.href = "/ezCommunity/boardDelete.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
		                break;
		            case 7:
		                window.location.href = "/ezCommunity/searchBoardItem.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
		                break;
		            case 9:
		                window.location.href = "/ezCommunity/boardGroupCreate.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
		                break;
		
		            default:
		                break;
		        }
		    }
		        function searchBoard_onclick() {
		            var feature = "DialogHeight:470px;DialogWidth:340px;status:no;help:no;edge:sunken";
		            feature = feature + GetShowModalPosition(340, 470);
		            var ret = window.showModalDialog("/ezCommunity/searchBoard.do", "", feature);
		            
		        if (typeof (ret) == "undefined") {
		        } else {
		            var spans = TopBoardsList.all.tags("span");
		            
		            for (var i = 0; i < spans.length; i++) {
		                if (spans.item(i).id == ret[1]) {
		                    loadTreeViewByPath(spans.item(i), ret[0], ret[1], ret[2], ret[3]);
		                }
		            }
		        }
		    }
		
		    function loadTreeViewByPath(pObjSpan, pBoardID, pBoardGroupID, pBoardName, pParentBoardID) {
		        var divs = TopBoardsList.all.tags("DIV");
		        
		        for (var i = 0; i < divs.length; i++) {
		            if (divs.item(i).parentElement.parentElement.id == "TreeArea") {
		                divs.item(i).parentElement.parentElement.style.display = "none";
		            }
		        }
		
		        pObjSpan.parentElement.parentElement.nextSibling.style.display = "";
		        var TreeCtrl = pObjSpan.parentElement.parentElement.nextSibling.firstChild.firstChild;
		
		        TreeCtrl.server = SS_ServerName;
		        TreeCtrl.config = xmlDom_treeview;
		        TreeCtrl.source = GetBoardTreeByPath(pBoardID, pBoardGroupID);
		        TreeCtrl.update();
		
		        SelectedBoardID = pBoardID;
		        SelectedBoardName = pBoardName;
		        SelectedBoardParentBoardID = pParentBoardID;
		        SelectedBoardGroupID = pBoardGroupID;
		
		        window.location.href = "/ezCommunity/boardProperty.do?boardID=" + SelectedBoardID;
		    }
		</script>
	</head>
	<body class="mainbody">
		<xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<TYPE>NONE</TYPE>
						<NAME><spring:message code = 'ezCommunity.t361' /></NAME>
						<WIDTH>70</WIDTH>
						<SORTABLE>TRUE</SORTABLE>
						<RESIZIBLE>FALSE</RESIZIBLE>
						<MINSIZE>10</MINSIZE>
						<MAXSIZE>200</MAXSIZE>
						<NOWRAP>TRUE</NOWRAP>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
	    <h1><spring:message code = 'ezCommunity.t362' /></h1>
	    <div id="mainmenu">
	        <ul>
	            <li><span onclick="OpenRightMenu(1)"><spring:message code = 'ezCommunity.t291' /></span></li>
	            <li><span onclick="OpenRightMenu(9)"><spring:message code = 'ezCommunity.t297' /></span></li>
	            <li><span onclick="OpenRightMenu(2)"><spring:message code = 'ezCommunity.t324' /></span></li>
	            <li><span onclick="OpenRightMenu(4)"><spring:message code = 'ezCommunity.t294' /></span></li>
	            <li><span onclick="OpenRightMenu(5)"><spring:message code = 'ezCommunity.t295' /></span></li>
	            <li><span onclick="OpenRightMenu(6)"><spring:message code = 'ezCommunity.t208' /></span></li>
	            <li><span onclick="OpenRightMenu(7)"><spring:message code = 'ezCommunity.t296' /></span></li>
	            <li style="display: none"><span onclick="OpenRightMenu(3)"><spring:message code = 'ezCommunity.t293' /></span></li>
	        </ul>
	    </div>
	    
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	    	
	    <table>
	        <tr>
	            <th><spring:message code = 'ezCommunity.t306' /></th>
	            <th colspan="2" align="left"><b class="point">${boardName}</b></th>
	        </tr>
	        <tr>
	            <th><spring:message code = 'ezCommunity.t361' /></th>
	            <td>
	                <div class="listview">
	                    <div id="BoardList" style="BORDER: 0; HEIGHT: 250px; WIDTH: 440px"></div>
	                </div>
	            </td>
	            <th style="width: 30px" align="center">
	                <img src="/images/arr_up.gif" vspace="2" style="cursor: pointer; width: 16px; height: 16px;" onclick="MoveUp_onclick()"><br>
	                <img src="/images/arr_down.gif" vspace="2" style="cursor: pointer; width: 16px; height: 16px;" onclick="MoveDown_onclick()">
	            </th>
	        </tr>
	    </table>
		
	    <div class="btnposition">
	        <a class="imgbtn" onclick="Save()"><span><spring:message code = 'ezCommunity.t108' /></span></a>
	        <a class="imgbtn" onclick="window.location.reload(false)"><span><spring:message code = 'ezCommunity.t109' /></span></a>
	    </div>
			
	</body>
</html>