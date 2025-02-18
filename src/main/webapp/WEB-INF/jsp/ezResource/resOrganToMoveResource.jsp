<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t117" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link type="text/css" rel="stylesheet" href="${util.addVer('main.lhm01', 'msg')}" />
		<link type="text/css" rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" />
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/admin/gwAdmin.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/organtreeview.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" id="clientEventHandlersJS" >
			var Selected_Level;		
			var Selected_Ref;		
			var p_TargetID;			
			var p_TargetUpID;		
			var p_TargetNM;			
			var p_TargetExplain;	
			var pOrgUpperBrdID;
			var pOrgBrdID;

			var xmlhttp = createXMLHttpRequest();
			var xmldoc = createXmlDom();
			var pUserID ="${userInfo.id}";
			var pDeptID ="${userInfo.deptID}";
			var pCompanyID;
			var ReturnFunction;
			var m_dialogArguments;
			var pOwnerID;

			window.onload = function () { 
				try {
			        m_dialogArguments = opener.organ_cross_dialogArguments[0];
			        ReturnFunction = opener.organ_cross_dialogArguments[1];
			    }
			    catch (e) {
			        m_dialogArguments = dialogArguments;
			    }

			    pCompanyID = m_dialogArguments[1];
			    pOrgUpperBrdID = m_dialogArguments[2];
			    pOrgBrdID = m_dialogArguments[3];
			    pOwnerID = m_dialogArguments[4];

			    var TreeView = new organtreeview('TreeView', 'TreeView');
			    TreeView.attachEvent('requestdata', TreeView_onNodeExpanded);
			    TreeView.attachEvent('nodeselect', TreeView_onNodeClick);
			    TreeView.attachEvent('nodedblclick', TreeView_onNodeDblClick);

			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/xml/ezResource/organtree_config2.xml", false);
			    xmlHTTP.send();
				
				if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
				    TreeView.server("${serverName}");
				    TreeView.config(xmlHTTP.responseXML);
				    TreeView.update();

				    initTreeInfo("ADMIN", pUserID, pDeptID, pCompanyID);
				}
			}

			function TreeCtrl_onNodeDblClick() {
				TreeCtrl_onNodeClick();
			}

			function TreeView_onNodeClick() {	
				var nodeIdx = TreeView.selectedIndex();
			
				Selected_Level  = TreeView.getvalue(nodeIdx, "DATA3");
				Selected_Ref    = TreeView.getvalue(nodeIdx, "DATA14");	
				p_TargetID      = TreeView.getvalue(nodeIdx, "DATA1");
				p_TargetUpID    = TreeView.getvalue(nodeIdx, "DATA6");
				p_TargetNM      = TreeView.getvalue(nodeIdx, "DATA2");
				p_TargetExplain = TreeView.getvalue(nodeIdx, "DATA9");
			}
			
			function TreeView_onNodeDblClick() {
			    TreeView.toggle(TreeView.selectedIndex());
			}

			function TreeView_onNodeExpanded(event){ 	
			    var nodeIdx = event.nodeIdx; 
				
				var brd_level = TreeView.getvalue(nodeIdx, "DATA3");
				var m_param1 = TreeView.getvalue(nodeIdx, "DATA1");
				
				getFirstDepthNode(parseInt(brd_level) + 1,m_param1, nodeIdx)
			}
			
			function bt_Ok_onclick() {
				if (pOrgUpperBrdID == p_TargetID) {
					alert("<spring:message code="ezResource.t118" />");
				} else if (p_TargetID == 1 || p_TargetID == 0) {
					alert("<spring:message code="ezResource.gha01" />");
				} else {
					checkHavePermission();
				}
			}
			
			function checkHavePermission() {
				$.ajax({
		    		type : "GET",
		    		async : false,
		    		data : {
		    			selectedResourceGroupId : p_TargetID,
		    			ownerID : pOwnerID
		    		},
		    		url : "/ezResource/isResourceGroupManager.do",
		    		success: function(text){
		    			if (text == "0") {
							alert("<spring:message code="ezResource.gha02" />");
						} else if (text == "2") {
							alert("<spring:message code="ezResource.kmsr06" />");
						} else {
							moveResourceToOtherResourceGroup();
						}
		    		},
		    		error: function(err){
		    		}
		    	});
			}
			
			function moveResourceToOtherResourceGroup() {
				if (confirm("<spring:message code='ezResource.gha05' />") == true) {
			        $.ajax({
			    		type : "POST",
			    		async : false,
			    		data : {
			    			originResourceGroupId : pOrgBrdID,
			    			selectedResourceGroupId : p_TargetID,
			    		},
			    		url : "/ezResource/moveResourceToOtherResourceGroup.do",
			    		success: function(text){
			    			/* var selectedLabel = $('#res'+pOrgBrdID,parent.parent.opener.parent.frames["left"].document);
			    			var targetLabel = $('#res'+p_TargetID,parent.parent.opener.parent.frames["left"].document);
			    			if (targetLabel.lastElementChild.style.display == "inline-block") {
				    			selectedLabel.insertAfter(targetLabel);
			    			}; */
			    			
			    			/* 2023-09-08 홍승비 - 자원이동 시 부모창을 이동하는 경우, 저장 완료 이후 동작하지 않는 오류 수정 */
			    			try {
								if (typeof(window.opener.RefreshPageDoc) != "undefined") {
									window.opener.RefreshPageDoc();
								} else {
									if (window.opener.parent.left.location.href.indexOf("/ezResource/leftResource.do") > -1) {
										window.opener.parent.left.location.href = "/ezResource/leftResource.do?flag=SELECT_NO";
									}
									window.opener.location.reload(false);
								}
				    		} catch (e) {
								console.log(e);
							}
			    		},
			    		error: function(err){
			    		}
			    	});
			        window.close();	
				}
			}

			function bt_Close_onclick() {
				window.close();	
			}

			function initTreeInfo(pFlag, p_UserID, p_DeptID, pSelCompanyID) {
			    //try {	
			        var xmlhttp = createXMLHttpRequest();
			        var xmlpara = createXmlDom();
			        var xmlRtn = createXmlDom();

			        var objNode;
			        createNodeInsert(xmlpara, objNode, "BRDLIST");
			        createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", "");
			        createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pSelCompanyID);
			        createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", "0");
			        createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "Y");
			        createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "1");
					
					xmlhttp.open("POST","/ezResource/callManagerDepthNodeForMoveResource.do",false);
					xmlhttp.send(xmlpara);
					
					var XMLstring = xmlhttp.responseText;
					
					xmlRtn.async = false;
					xmlRtn = loadXMLString(XMLstring);

					TreeView.source(xmlRtn);
					TreeView.update();
			    //} catch(e) {  }
			}

			function getFirstDepthNode(p_Depth, p_brd_id, nodeIdx) {
			    var xmlhttp = createXMLHttpRequest();
			    var xmlDOM = createXmlDom();
			    var xmlpara = createXmlDom();

			    var objNode;
			    createNodeInsert(xmlpara, objNode, "BRDLIST");
			    createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", p_brd_id);
			    createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pCompanyID);
			    createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", "0");
			    createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "N");
			    createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "1");

				xmlhttp.open("POST","/ezResource/callManagerDepthNodeForMoveResource.do",false);
				xmlhttp.send(xmlpara);

				if (xmlhttp.responseText == "") return;
				
				var XMLstring = xmlhttp.responseText;
				xmlRtn = loadXMLString(XMLstring);
				
				if (XMLstring == "") return;
						
				if (SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0) {
				    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
				}
					
				TreeView.putchildxml(nodeIdx,  xmlRtn);
			}
		</script>
		<style type="text/css">
			.node_normal, .node_selected {line-height:34px;}
		</style>
	</head>
	<body class="popup">
		<h1><spring:message code="ezResource.t119" /></h1>
		<div id="close">
            <ul>
                <li><span onclick="bt_Close_onclick()"></span></li>
            </ul>
        </div>
		<div id="TreeView" valign="top" style="height:330px;width:100%;overflow-x:auto;overflow-y:auto;BORDER:#ddd 1px solid; BACKGROUND-COLOR:#ffffff; vertical-align:top"></div>
		<div class="btnpositionNew">
      		<a class="imgbtn"><span onclick="bt_Ok_onclick()" ><spring:message code="ezResource.t15" /></span></a>
		</div>
	</body>
</html>