<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value='${title}' /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<style type="text/css">
		.tree_plus {margin-top: -3px !important;}
		.tree_minus {margin-top: 0px !important;}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var labelcolor = "gray";
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc = createXmlDom();
		    var gState, gDeptID;
		    var P_companyID;
		    var DeptID;
		    var RetValue;
		    var ReturnFunction;
		    var pOrgContType;
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    
		    $(document).ready(function(){
		    	try {
		            RetValue = parent.minscontmain_cross_dialogArguments[0];
		            ReturnFunction = parent.minscontmain_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.minscontmain_cross_dialogArguments[0];
		                ReturnFunction = opener.minscontmain_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        gState = RetValue[0];
		        gDeptID = RetValue[1];
		        P_companyID = RetValue[2];
		        DeptID = RetValue[3];
		        
		        if (gState == "U") {
		            pOrgContType = RetValue[2];
		            P_companyID = RetValue[4];
		            DeptID = RetValue[5];
		        }

		        Tree_setconfig();
		        
		        TreeViewinitialize("", P_companyID, "extensionAttribute2;extensionAttribute3", "<c:out value='${serverName}'/>", null, P_companyID, true);
		        getDocType();
		        
		        if (gState == "U") {
		            initVal(RetValue);
		        }
		    });
		    
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
		        xmlHTTP.send();
		        
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
		    }
		    
		    function getDocType() {
		        $.ajax({
		        	type : "POST",
		        	dataType : "html",
		        	url : "/admin/ezApprovalG/apprGMLgetDoctype.do",
		        	async : false,
		        	data : {comID : P_companyID},
		        	success : function(result){
						xmlRtn = loadXMLString(result);
						
						for (var Cnt = 0; Cnt < xmlRtn.getElementsByTagName("VALUE").length ; Cnt++) {
				            Add_ContType(xmlRtn.getElementsByTagName("VALUE")[Cnt].childNodes[0].nodeValue, xmlRtn.getElementsByTagName("DATA1")[Cnt].childNodes[0].nodeValue);
				        }        		 
		        	}
		        });
		    }
		    
		    function Add_ContType(Name, ID) {
		        var oOption = document.createElement("OPTION");
		        oOption.text = Name;
		        oOption.value = ID;
		        var sOption = document.getElementById("selContName");

		        sOption.add(oOption, null);
		        oOption = null;
		    }
		    
		    function initVal(Para) {
		        document.getElementById("tbContID").value = Para[1];
		        document.getElementById("selContName").value = Para[2];
		        gDeptID = Para[3];

		        var xmlRtn = createXmlDom();
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezApprovalG/apprGMgetContGroup.do",
		        	async : false,
		        	data : {contID : Para[1], comID : P_companyID},
		        	success : function(result){
						xmlRtn = loadXMLString(result);						
						var objNode = xmlRtn.documentElement.childNodes;
						
				        if (SelectSingleNodeValueNew(xmlRtn, "PARAMETER/ID0") != "FALSE") {
				            for (var Cnt = 0; Cnt < objNode.length / 2 ; Cnt++) {
				                if (SelectSingleNodeValueNew(xmlRtn, "PARAMETER/NAME" + Cnt) == "") {
				                    break;
				                }
				                Add_Group(SelectSingleNodeValueNew(xmlRtn, "PARAMETER/NAME" + Cnt), SelectSingleNodeValueNew(xmlRtn, "PARAMETER/ID" + Cnt));
				            }
				        }    		 
		        	},
		        	error : function() {
		        		xmlRtn = loadXMLString("<PARAMETER><ID0>FALSE</ID0><NAME0></NAME0></PARAMETER>");
		        	}
		        });		        
		    }
		    
		    function Add_Group(Name, ID) {
		        var oOption = document.createElement("OPTION");
		        oOption.text = Name;
		        oOption.value = ID;
		        document.all.selUseDept.add(oOption);
		    }
		    
		    function btnAppdept_onclick() {
		        var selDeptID, selDeptName;
		        var oOption = document.createElement("OPTION");
		        var selnode = TreeView.selectedIndex;
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);
		        if (nodeIdx.NodeID != null) {
		            selDeptName = treeNode.GetNodeData("VALUE");
		            selDeptID = treeNode.GetNodeData("CN");

		            oOption.text = selDeptName;
		            oOption.value = selDeptID;

		            if (document.all.selUseDept.length > 0) {
		                for (var i = 0 ; i < document.all.selUseDept.length ; i++) {
		                    if (selUseDept.item(i).value == oOption.value) {
		                        alert("<spring:message code='ezApprovalG.t1644'/>");
		                        return;
		                    }
		                }
		            }
		            document.all.selUseDept.add(oOption);
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1645'/>");
		        }
		    }
		    
		    function btnDeldept_onclick() {
		        var index;
		        index = selUseDept.selectedIndex;
		        
		        if (index != -1) {
		            selUseDept.remove(index);
		        } else {
		            alert("<spring:message code='ezApprovalG.t1646'/>");
		        }
		    }
		    
		    function btnOk_onclick() {
		    	if (confirm("<spring:message code='ezQuestion.t12'/>")) {
			        var rtnVal, itmeCnt;
	
			        if (gState == "I") {
	                    rtnVal = insCont();
			        } else {
	                    rtnVal = UpdateCont();
			        }
	
			        if (typeof (rtnVal) != "undefined") {
			            if (rtnVal) {
			                ReturnFunction();
			                window.returnValue = "TRUE";
			                window.close();
			            } else {
			                window.returnValue = "FALSE";
			                window.close();
			            }
			        } else {
			            window.returnValue = "FALSE";
			            window.close();
			        }
		    	}
		    }
		    
		    function insCont() {
		        var xmlpara = createXmlDom();
		        var xmlRtn = createXmlDom();
		        var ParaName, ParaValue;

		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "CONTTYPE", document.getElementById("selContName").value);
		        createNodeAndInsertText(xmlpara, objNode, "CONTOWNDEPID", gDeptID);
		        
	            var Count = selUseDept.length;
	            
	            for (var i = 0; i < Count; i++) {
	                ParaName = "Dept" + i;
	                ParaValue = selUseDept.item(i);
	                
	                if (ParaValue.value == DeptID) {
	                	alert("<spring:message code='ezSchedule.t25'/>");
	                	return false;
	                } else {
		                createNodeAndInsertText(xmlpara, objNode, ParaName, ParaValue.value);
	                }
	            }

		        createNodeAndInsertText(xmlpara, objNode, "COMID", P_companyID);

		        xmlhttp.open("POST", "/admin/ezApprovalG/apprGMinsCont.do", false);
		        xmlhttp.send(xmlpara);

		        if (xmlhttp != null && xmlhttp.readyState == 4) {
					if (xmlhttp.status == 200 && xmlhttp.responseText == "TRUE") {
						return true;
					} else {
						if (xmlhttp.responseText == "DUPLICATE") {
							alert("<spring:message code='ezApprovalG.t1598'/>");
						}
			            return false;
					}
				}
		    }
		    
		    function UpdateCont() {
		        var xmlpara = createXmlDom();
		        var ParaName, ParaValue;

		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "CONTID", document.getElementById("tbContID").value);
		        createNodeAndInsertText(xmlpara, objNode, "CONTTYPE", document.getElementById("selContName").value);
		        createNodeAndInsertText(xmlpara, objNode, "CONTOWNDEPID", gDeptID);
		        
		        if (typeof(pOrgContType) != "undefined" && pOrgContType != document.getElementById("selContName").value) {
			        createNodeAndInsertText(xmlpara, objNode, "MODFLAG", "Y");
		        } else {
			        createNodeAndInsertText(xmlpara, objNode, "MODFLAG", "N");
		        }

	            var Count = selUseDept.length;
	            
	            for (var i = 0; i < Count; i++) {
	                ParaName = "Dept" + i;
	                ParaValue = selUseDept.item(i);
	                
	                if (ParaValue.value == DeptID) {
	                	alert("<spring:message code='ezSchedule.t25'/>");
	                	return false;
	                } else {
		                createNodeAndInsertText(xmlpara, objNode, ParaName, ParaValue.value);
	                }
	            }

		        createNodeAndInsertText(xmlpara, objNode, "comID", P_companyID);

		        xmlhttp.open("POST", "/admin/ezApprovalG/apprGMupdateCont.do", false);
		        xmlhttp.send(xmlpara);
		        
		        if (xmlhttp != null && xmlhttp.readyState == 4) {
					if (xmlhttp.status == 200 && xmlhttp.responseText == "TRUE") {
						return true;
					} else {
						if (xmlhttp.responseText == "DUPLICATE") {
							alert("<spring:message code='ezApprovalG.t1598'/>");
						}
			            return false;
					}
				}
		    }
		    
		    function btncancel_onclick() {
		        window.returnValue = "FALSE";
		        window.close();
		    }
			    
		    function TreeViewNodeClick(pNodeID) { }
		    
		    window.oncontextmenu = function () {
		        return false;
		    }
		</script>
	</head>
	<body class="popup">
		<h1><c:out value='${title}' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="return btncancel_onclick()"></span></li>
            </ul>
        </div>
		<table class="content">
  			<tr>
   				<th><spring:message code='ezApprovalG.t1549'/></th>
				<td>
					<select name="selContName" id="selContName" style="WIDTH:150px"></select>
					<input type="hidden" name="tbContID" id="tbContID" />
				</td>
			</tr>
		</table>			
		<table style="margin-top:10px">
			<tr>
				<td>
					<h2><spring:message code='main.t8'/></h2>
				</td>
				<td></td>
				<td>
					<h2><spring:message code='ezApprovalG.t1648'/></h2>
				</td>
			</tr>
			<tr>
				<td style="vertical-align:top;">
					<div id="TreeView" style="padding-top:5px;BORDER:#ddd 1px solid; overflow:auto; WIDTH:275px; HEIGHT:230px; BACKGROUND-COLOR:#ffffff"></div>
				</td>
				<td style="width:70px;text-align:center;white-space:nowrap;">
					<img src="/images/arr_right.gif" id="btnAppdept" name="Image191" onClick="return btnAppdept_onclick()" style="padding-top: 5px; cursor: pointer;"><br/>					
	                <img src="/images/arr_left.gif" id="btnDeldept" name="Image201" onClick="return btnDeldept_onclick()" style="padding-top: 5px; cursor: pointer;"><br/>
				</td>
				<td style="vertical-align:top;">
					<select id="selUseDept" name="selUseDept" style="WIDTH: 245px; HEIGHT: 235px; background: none;" size="2"></select>
				</td>
			</tr>
		</table>
		<div class="btnpositionNew">
		    <a class="imgbtn"><span onClick="return btnOk_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
		</div>
	</body>
</html>
