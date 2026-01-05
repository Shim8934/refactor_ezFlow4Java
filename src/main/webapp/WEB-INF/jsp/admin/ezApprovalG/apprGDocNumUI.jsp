<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t75'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<style>
			.mainlist tr th { border-top:0px }
		</style>
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TaskCodeManage_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}" ></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}" ></script>
	    
	    <script type="text/javascript">
	        var Rtnval = new Array();
	        var companyID = "";
	        var OrderCell = "";
	        var listview = new ListView();
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        var ReturnFunction;
	        window.onload = function () {
	            companyID = opener.companyID;
	            
	            var xmlDom = createXmlDom();
	            xmlDom = loadXMLFile("/xml/organtree_config2.xml");
		    	var treeView = new TreeView();
	            treeView.SetID("FormTreeView");
	            treeView.SetConfig(xmlDom);
	            
	            getGroupTree(1, 1, 0, true);
	            InitListView();
	            getGroupItem("");
				setTooltipIfOverflow("lvtDocForm_TH_2");
				setTooltipIfOverflow("lvtDocForm_TH_3");
	            if (CrossYN()) {
	                try {
	                    ReturnFunction = parent.itemcode_dialogArgument[1];
	                } catch (e) {
	                    try {
	                        ReturnFunction = opener.itemcode_dialogArgument[1];
	                    } catch (e) {
	                    }
	                }
	            } else {
	                Rtnval[0] = "cancel"
	                window.returnValue = Rtnval;
	            }
	        }

			function setTooltipIfOverflow(id) {
				var th = document.getElementById(id);
				if (th) {
					if (th.scrollWidth > th.clientWidth) {
						th.setAttribute("title", th.innerText.trim());
					}
				}
			}

			function Tree_setconfig() {
		    	var xmlDom = createXmlDom();
	            xmlDom = loadXMLFile("/xml/organtree_config2.xml");
		    	var treeView = new TreeView();
	            treeView.SetConfig(xmlDom);
			}
	
		    function InitListView() {
		        var xmlTree = createXmlDom();
		        xmlTree = loadXMLString(ITEM.innerHTML.toUpperCase());
		        
		        listview.SetID("lvtDocForm");
		        listview.SetMulSelectable(false);
		        listview.SetTableWidth = 570 - 14;
		        listview.DataSource(xmlTree);
		        listview.DataBind("lvtForm");
		    }
	
		    function TreeView_onRequestData(pNodeID, pTreeID) {
		        var treeview = new TreeView();
		        treeview.LoadFromID("FromTreeView");
		        node_select(pNodeID, "", pTreeID, TreeView_onNodeSelect);
		        nodeIdx = treeview.GetSelectNode();
		       
		        var pLevel = nodeIdx.GetNodeData("DATA1");
		        var pGroupID = nodeIdx.GetNodeData("DATA2");
		        
		        getGroupTree(nodeIdx, parseInt(pLevel) + 1, pGroupID, false);
		    }
		    
		    function RequestData(pNodeID, pTreeID) {
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        var deptID = treeNode.GetNodeData("CN");

		        GetDeptSubTreeInfo(deptID, TreeIdx);
		    }
	
		    function TreeView_onNodeSelect() {
		        var treeview = new TreeView();
		        treeview.LoadFromID("FromTreeView");
		        var nodedata = treeview.GetSelectNode();
		        var pLevel = nodedata.GetNodeData("DATA1");
		        var pGroupID = nodedata.GetNodeData("DATA2");
		        
		        getGroupItem(pGroupID);
		    }
	
		    function lvtForm_onclick() {
		    }
		    
		    function lvtForm_onSel_Changed() {
		    }
	
	        function lvtForm_onSel_DBclick() {
	            btn_OK();
	        }
	
	        function btn_OK() {
	            var listview = new ListView();
	            listview.LoadFromID("lvtDocForm");
	            var oArrRows = listview.GetSelectedRows();
	            
	            
	            if (oArrRows.length > 0) {
	                var selRow = oArrRows[0];
	                Rtnval[0] = getNodeText(selRow.cells[0]);
	                Rtnval[1] = getNodeText(selRow.cells[1]);
	                Rtnval[2] = GetAttribute(selRow, "DATA2");
	                Rtnval[3] = GetAttribute(selRow, "DATA13");
	                Rtnval[4] = GetAttribute(selRow, "DATA14");
// 	                Rtnval[5] = GetAttribute(selRow, "DATA1");
	                Rtnval[6] = GetAttribute(selRow, "DATA1");
	                
	                if (CrossYN())
	                {
	                    ReturnFunction(Rtnval);
	                    window.close();
	                }
	                else {
	                    window.returnValue = Rtnval;
	                    window.close();
	                }
	            }
	            else {
	                var pAlertContent = "<spring:message code='ezApproval.t76'/>";
	                OpenAlertUI(pAlertContent);
	            }
	        }
	
	        function btn_Cancle() {
	            if (CrossYN())
	            {
	                Rtnval[0] = "cancel"
	                ReturnFunction(Rtnval);
	                window.close();
	            }
	            else
	            {
	                Rtnval[0] = "cancel"
	                window.returnValue = Rtnval;
	                window.close();
	            }
	        }
	    </script>
	</head>
	<body class="popup">
	    <xml id='GROUP' style="display: none">
		  <TREEVIEWDATA>
		    <NODE>
		      <EXPANDED>TRUE</EXPANDED>
		      <ISLEAF>FALSE</ISLEAF>
		      <VALUE><spring:message code='ezApprovalG.t114' /></VALUE>
		      <DATA1>0</DATA1>
		      <DATA2></DATA2>
		      <DATA3>0</DATA3>
		    </NODE>
		  </TREEVIEWDATA>
		</xml>
	    <xml id='ITEM' style="display: none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezApproval.t78' /></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApproval.t79' /></NAME>
		        <WIDTH>250</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApproval.t80' /></NAME>
		        <WIDTH>80</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApproval.t81' /></NAME>
		        <WIDTH>80</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApproval.t82' /></NAME>
		        <WIDTH>80</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
	    <h1><spring:message code='ezApproval.t83' /></h1>
	    <div id="close">
            <ul>
                <li><span onclick="return btn_Cancle()"></span></li>
            </ul>
        </div>
	    <table>
	        <tr>
	            <td>
	                <div id="TreeView" style="height: 215px; width: 200px; overflow-x: auto; overflow-y: auto; BORDER: #ddd 1px solid; BACKGROUND-COLOR: #ffffff; vertical-align: top"></div>
	            </td>
	            <td style="padding-left: 5px">
	                <div class="listview">
	                    <div id="lvtForm" style="border: 0; HEIGHT: 215px; WIDTH: 565px; overflow-x: auto; overflow-y: auto;"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnpositionNew">
	        <a class="imgbtn" onclick="return btn_OK()"><span><spring:message code='ezApprovalG.t1760' /></span></a>
	    </div>
	</body>
</html>