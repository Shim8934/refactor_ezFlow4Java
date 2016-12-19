<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t1047' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="/css/email_tree.css">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
      		var selectedBoard = "";
      		var ItemIDList = "<c:out value = '${itemIDList}' />";
			var BoardID = "<c:out value = '${boardID}' />";
			var code = "<c:out value = '${code}' />";
			var xmlDom_treeview = createXmlDom();

			function Select() {
    			if (selectedBoard == "") {
        			alert("<spring:message code='ezCommunity.t994' />");
    				return;
				}
    			
   				if (selectedBoard == BoardID) {
	       			alert("<spring:message code='ezCommunity.t1048' />");
		    		return;
				}
   				
    			CopyItem(selectedBoard);
			}

			function cancel() {
		    	window.close();
			}

			function CopyItem(pDestBoardID) {
			    if (CheckIfCanWrite(pDestBoardID) == false) {
			        alert("<spring:message code='ezCommunity.t1049' />");
			    	return;
				}

				if (CheckIfAnonyBoard(pDestBoardID) == "1") {
					alert("<spring:message code='ezCommunity.t1050' />");
					return;
				}
	
	   			var destItemIDList = "";
	
			   	for (i = 0; i < ItemIDList.split(";").length - 1; i++) {
			    	destItemIDList += "{" + GetGUID().toUpperCase() + "};";
			   	}

			   	$.ajax({
			   		type : "POST",
			   		async : false,
			   		url : "/ezCommunity/copyItem.do",
			   		dataType : "JSON",
			   		data : {
			   			orgItemIDList : ItemIDList,
			   			orgBoardID : BoardID,
			   			destItemIDList : destItemIDList,
			   			destBoardID : pDestBoardID
			   		},
			   		success : function(result) {
			   			if (result["ret"].indexOf("OK") > -1) {
		 					alert("<spring:message code='ezCommunity.t1051' />");
		 				} else {
		 					alert("<spring:message code='ezCommunity.t1052' />" + result["ret"]);
		 				}
			   			
			   			try {
		 			        window.opener.refresh_onclick();
		 			    } catch (e) {
		 			    }
		 			    
		 			    window.close();
			   		}
			   	});
			}

			function CheckIfCanWrite(pBoardID) {
				var boardInfo;
				var access = "";
				
				$.ajax({
					type : "POST",
					async : false,
					url : "/ezCommunity/getACL.do",
					dataType : "JSON",
					data : { boardID	:	pBoardID, 
						   },
					success: function(result){
						boardInfo = result["boardInfo"];
						access = boardInfo["access_"];
					},
					error: function(e) {
						alert("error");
					}
				});
				
				console.log(access);
				if(access != "-1") {
					return true;
				} else {
					return false;
				}
			}

			function CheckIfAnonyBoard(pBoardID) {
				var retval = '0';
				
				$.ajax({
			   		type : "POST",
			   		async : false,
			   		url : "/ezCommunity/checkIfAnonyBoard.do",
			   		dataType : "JSON",
			   		data : {
			   			boardID : pBoardID,
			   		},
			   		success : function(result) {
			   			if (result["result"] == 'anonyboard') {
		 					retval = '1';
		 				}
			   		},
					error: function(e) {
						alert("error");
					}
			   	});
				
				return retval;
			}

			window.onload = function () {
			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);
			    xmlHTTP.send();
			
			    DisplayTopBoard();
			}

			function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
			    var xmlRtn = createXmlDom();
			    var TreeIdx = pNodeID;
			    var treeNode = new TreeNode();
			    treeNode.LoadFromID(TreeIdx);
			
			    xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1");
			
			    if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
			        if (CrossYN()) {
			            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
			        } else {
			            xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
			        }
			    }
			    
			    var treeView = new TreeView();
			    treeView.LoadFromID(pTreeID);
			    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
			}

			function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
			    var treeNode = new TreeNode();
			    treeNode.LoadFromID(pNodeID);
			    selectedBoard = treeNode.GetNodeData("DATA1");
			}
			
			function DisplayTopBoard() {
			    xmlhttp.open("POST", "/ezCommunity/getSubBoards.do?rootBoardID=TOP&subFlag=0&classID=" + code, false);
			    xmlhttp.send();
			
			    if (xmlhttp.responseText.indexOf("ERROR") == -1) {
			        MakeTopBoardView(xmlhttp.responseText);
			    }
			}
			
			function TopBoard_onclick(obj, ID, items) {
			    var rootBoardID = "{" + ID + "}";
			    var num = obj.split("TreeCtrl");
			    
			    if (document.getElementById(obj).style.display != "none") {
			        document.getElementById(obj).style.display = "none";
			        document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "off";
			    } else {
			        document.getElementById(obj).style.display = "";
			        document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "on";
			        SetTreeviewUnSelect(obj, items)
			    }
			
			
			    document.getElementById(obj).innerHTML = "";
			    SetTreeConfig();
			    var treeView = new TreeView();
			    treeView.SetID("TreeView" + obj);
			    treeView.SetRequestData("TreeCtrl_onNodeExpanded");
			    treeView.SetNodeClick("TreeCtrl_onNodeClick");
			    treeView.DataSource(GetSubBoard(rootBoardID, "1"));
			    treeView.DataBind(obj);
			}
			
			function SetTreeConfig() {
			    var xmlDom_treeview = createXMLHttpRequest();
			    xmlDom_treeview.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);
			    xmlDom_treeview.send();
			
			    if (xmlDom_treeview.readyState == 4 && xmlDom_treeview.status == 200) {
			        var treeView = new TreeView();
			        treeView.SetConfig(xmlDom_treeview.responseXML);
			    }
			}
			
			function SetTreeviewUnSelect(TreeviewID, items) {
			    for (var i = 0; i < items; i++) {
			        if (TreeviewID != "TreeCtrl" + i) {
			            document.getElementById("TreeCtrl" + i).style.display = "none";
			            document.getElementById("TopBoardsList").getElementsByTagName("h2").item(i).className = "off";
			        }
			    }
			}
			
			function GetSubBoard(pRootBoardID, pSubFlag) {
			    xmlhttp.open("POST", "/ezCommunity/getSubBoards.do?rootBoardID=" + pRootBoardID + "&subFlag=" + pSubFlag + "&selectFlag=0&classID=" + code, false);
			    xmlhttp.send();
			    return xmlhttp.responseXML;
			}
			
			function MakeTopBoardView(strXML) {
			    var xmldom = createXmlDom();
			    var strHTML = "";
			    xmldom = loadXMLString(strXML);
			    strHTML = "<table id='TopBoards' width=100% border=0>";
			    var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
			    var items = xmldomNodes.length;
			    
			    for (i = 0; i < xmldomNodes.length; i++) {
			        var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
			        tid = tid.substring(1, 37);
			        strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</h2></td></tr>";
			        strHTML += "<TR id='TreeArea' ><td><DIV id='TreeCtrl" + i.toString() + "' style='display:none;height:100%;width:300px;padding-top:5px;padding-bottom:3px'></DIV></td></tr>";
			    }
			    
			    strHTML += "</table>";
			
			    xmldomNodes = null;
			    xmldom = null;
			
			    document.getElementById("TopBoardsList").innerHTML = strHTML;
			}

		
		</script>
	
	</head>
	<body class = "popup" style = "overflow : hidden">
		<h1><spring:message code='ezCommunity.t359' /></h1>
		
	    <div class="box" style="width: 320px; height: 550px; overflow: auto; word-break: break-all" id="TopBoardsList"></div>
	    <div class="btnposition">
	        <a class="imgbtn" name="Submit" onclick="return Select()"><span><spring:message code='ezCommunity.t278' /></span></a>
	        <a class="imgbtn" name="Submit" onclick="javascript: window.close();"><span><spring:message code='ezCommunity.t21' /></span></a>
	    </div>
	</body>
</html>