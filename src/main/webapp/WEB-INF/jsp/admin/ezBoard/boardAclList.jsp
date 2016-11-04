<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t609" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <link rel="stylesheet" href='/css/email_tree.css' type="text/css" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
		<script type="text/javascript" language="javascript">
			var xmlhttp = createXMLHttpRequest();
		    var selectedBoard = "";
		    var ItemIDList = "";
		    var BoardID = " ";
		    var BoardGroupID = "";	
		    var pBoardID = "<c:out value='${boardID}'/>";
		    var pParentBoardID = "<c:out value='${parentBoardID}'/>";	
		    var SelectedBoardID = "";
		    var selectedBoardGroupID = "";
		    var SelectedBoardName = "";	
		    var SelectedTopBoardID = "";
		    var SelectedTopBoardName = "";	
		    var ret = new Array();	
		    var SS_ServerName = "<c:out value='${serverName}'/>";
		    var xmlDom_treeview = createXmlDom();
		    
		    $(document).ready(function(){
		    	var xmlDom_treeview = createXMLHttpRequest();
		        xmlDom_treeview.open("GET", "/xml/organtree_config2.xml", false);
		        xmlDom_treeview.send();

		        if (xmlDom_treeview.readyState == 4 && xmlDom_treeview.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlDom_treeview.responseXML);
		        }
		        
		        DisplayTopBoard();
		        MakeListView();
		    });
		    
		    function DisplayTopBoard(){
				$.ajax({
					data : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getSubBoards.do",
					data : { rootBoardID : 'top', subFlag : '0'},
					success : function(result){
						MakeTopBoardView(result);
					}
				});				
			}
		    
		    function MakeTopBoardView(strXML) {
		        var xmldom = createXmlDom();
		        var strHTML = "";
		        xmldom = loadXMLString(strXML);
		        strHTML = "<table id='TopBoards' width=100% border=0>"
		        var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
		        var items = xmldomNodes.length;
		        for (i = 0; i < xmldomNodes.length; i++) {
		            var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
		            tid = tid.substring(1, 37);
		            strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</h2></td></tr>";
		            strHTML += "<TR id='TreeArea' ><td style='background-color:rgb(229, 229, 229)'><DIV id='TreeCtrl" + i.toString() + "' style='display:none;height:100%;width:300px;overflow-x:hidden;padding-top:10px;padding-bottom:10px'></DIV></td></tr>";
		        }
		        strHTML += "</table>";

		        xmldomNodes = null;
		        xmldom = null;

		        document.getElementById("TopBoardsList").innerHTML = strHTML;
		    }
		    
		    function MakeListView() {
		        var listview = new ListView();
		        listview.SetID("CopyBoardListViewTable");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnDblClick("DeleteReceiver");
		        
		        if(CrossYN()){
		            listview.DataSource(document.getElementById("listviewheader"));
		        }else{
		            listview.DataSource(loadXMLString(document.getElementById("listviewheader").xml.trim()));
		        }
		        listview.DataBind("CopyBoardListView");
		    }
		    
		    function TopBoard_onclick(obj, ID, items) {
		        SelectedBoardID = "";
		        SelectedTopBoardID = "{" + ID + "}";
		        selectedBoardGroupID = "top";
		        SelectedTopBoardName = document.getElementById("{" + ID + "}").innerHTML;
		        var rootBoardID = "{" + ID + "}";
		        var num = obj.split("TreeCtrl");

		        if (document.getElementById(obj).style.display != "none") {
		            document.getElementById(obj).style.display = "none";
		            document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "off";
		        }else {
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
		    
		    function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
		        var xmlRtn = createXmlDom();
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);

		        xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1")

		        if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
		            if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
		            }
		            else {
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
		        SelectedBoardID = treeNode.GetNodeData("DATA1");
		        SelectedBoardName = treeNode.GetNodeData("DATA2");
		        selectedBoardGroupID = treeNode.GetNodeData("DATA3");
		        SelectedTopBoardID = "";
		        SelectedTopBoardName = "";
		    }
		    
		    function GetSubBoard(pRootBoardID, pSubFlag) {
	        	var ret;

	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getSubBoards.do",	        			
					data : { rootBoardID : pRootBoardID, subFlag : pSubFlag, selectFlag : "0"},
					success: function(result){
						ret = loadXMLString(result);				
					}
				});
	        	
	        	return ret;
	        }
		    
		    function SetTreeConfig() {
		        var xmlDom_treeview = createXMLHttpRequest();
		        xmlDom_treeview.open("GET", "/xml/organtree_config2.xml", false);
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
		    
		    function InsertReceiver() {
		        if (SelectedBoardID == "" && pParentBoardID != "top") {
		            alert("<spring:message code='ezBoard.t607' />");
		            return;
		        }
		        if (SelectedBoardID == "" || SelectedBoardID == null) {
		            SelectedBoardID = SelectedTopBoardID;
		            SelectedBoardName = SelectedTopBoardName;
		        }
		        var listview = new ListView();
		        listview.LoadFromID("CopyBoardListViewTable");
		        var arrRows = listview.GetSelectedRows();
		        if (arrRows.length > 0) {
		            var bFlag = listview.ExistRow("DATA1", SelectedBoardID);
		            if (bFlag) {
		                alert("<spring:message code='ezBoard.t20' />");
		                return;
		            }
		        }

		        var MaxID = 0;
		        var InitTr = listview.GetDataRows();

		        for (var j = 0  ; j < InitTr.length  ; j++) {
		            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		            if (MaxID < curnum)
		                MaxID = curnum;
		        }
		        var objTr = listview.NewAddRow(0, "CopyBoardListViewTable" + "_TR_" + eval(MaxID + 1));
		        Resultxml = "<LISTVIEWDATA><ROWS><ROW>";
		        Resultxml += "<CELL><DATA1>" + SelectedBoardID + "</DATA1><DATA2>" + selectedBoardGroupID + "</DATA2><DATA3>N</DATA3><VALUE><![CDATA[" + SelectedBoardName + "]]></VALUE></CELL>";
		        Resultxml += "</ROW></ROWS></LISTVIEWDATA>";

		        listview.AddDataRow(objTr, loadXMLString(Resultxml));
		        listview.SetSelectedIndex(MaxID + 1);
		    }

		    function DeleteReceiver() {
		        var listview = new ListView();
		        listview.LoadFromID("CopyBoardListViewTable");
		        listview.DeleteRow(listview.GetSelectedRows()[0].id);
		    }

		    function Save_onclick() {
		        var listview = new ListView();
		        listview.LoadFromID("CopyBoardListViewTable");
		        var rowData = listview.GetDataRows();
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();

		        var objRoot, objRow,objNode;
		        objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
		        objRow = createNodeAndAppandNode(xmlpara, objRoot, objRow, "ROW");
		        objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "DEFAULTBOARDID", pBoardID);
		        
		        for (var i = 0; i < rowData.length; i++) {
		            objRow = createNodeAndAppandNode(xmlpara, objRoot, objRow, "ROW");
		            objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "BOARDID", rowData[i].getAttribute("DATA1"));
		            objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "PARENTBOARDID", rowData[i].getAttribute("DATA2"));
		            objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "UNDERGROUP", rowData[i].getAttribute("DATA3"));
		        }

		        xmlhttp.open("POST","/admin/ezBoard/copyBoardAcl.do",false)
		        xmlhttp.send(xmlpara)

		        if (xmlhttp.status == 200 && xmlhttp.responseText == "OK") {
		            alert("<spring:message code='ezBoard.t79' />")
		            window.close();
		        }
		    }

		    function Cancel_onclick() {
		        window.close();
		    }
	    </script>	    
	</head>
	<body class="popup">
		<xml id="listviewheader" style ="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		        	<HEADER>
		        		<TYPE>NONE</TYPE>
		        		<NAME><spring:message code="ezBoard.t608" /></NAME>
		        		<WIDTH>20</WIDTH>
		        		<SORTABLE>TRUE</SORTABLE>
		        		<RESIZIBLE>TRUE</RESIZIBLE>
		        		<MINSIZE>10</MINSIZE>
		        		<MAXSIZE>100</MAXSIZE>
		        		<NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
		<h1><spring:message code="ezBoard.t609" /></h1>
		<table style="width:100%;">
		    <tr>
		        <td rowspan="1" valign="top">
		        	<div class="box" style="width:320px;height:550px;overflow:auto;word-break:break-all" id="TopBoardsList"></div>
		        </td>
		        <td style="width:30px; text-align:center; padding:10px;">
		            <img style="cursor:pointer; border:0px; width:16px; height:16px;" src="/images/arr_right.gif" onclick="InsertReceiver()" />
		            <img style="cursor:pointer; border:0px; width:16px; height:16px;" src="/images/arr_left.gif" onclick="DeleteReceiver()" />
		        </td>
		        <td style="vertical-align:top; width:100%; height:100%;">
		            <div class="listview">
		                <div id="CopyBoardListView" style="border: 0px;  overflow: auto; background-color: rgb(255, 255, 255); height:550px;"></div>
		            </div>
		        </td>
		    </tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn"><span onclick="Save_onclick()"><spring:message code="ezBoard.t604" /></span></a>
		    <a class="imgbtn"><span onclick="Cancel_onclick()"><spring:message code="ezBoard.t15" /></span></a>
		</div>
	</body>        
</html>