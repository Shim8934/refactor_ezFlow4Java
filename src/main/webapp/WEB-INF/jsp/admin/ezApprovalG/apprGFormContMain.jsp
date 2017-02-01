<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value = '${title }' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>

		<script type="text/javascript">
			var OrderCell = "";
			var xmlhttp = createXMLHttpRequest();
			var xmldoc = createXmlDom();
			var gManageID, gFContID, gParant, Flag, RtnState, gParantName;
			var companyID;
			var gParantName2 = "";
			var gMultiDataNum = "";
			var returnFunction
			
			if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
			    window.onblur = function () {
			        window.focus();
			    };
			}
			
			$(document).ready(function () {
			    var RtnVal = new Array();
			    var Para = opener.formContMain_dialogArguments[0];
			    returnFunction = opener.formContMain_dialogArguments[1];
			    Flag = Para[0];
			    gParant = Para[1];
			    gParantName = Para[2];
			    companyID = Para[3];
			    gParantName2 = Para[4];
			    
			    if (Flag == "I") {
			        gMultiDataNum = Para[5];
			    } else if (Flag == "U") { 
			        gMultiDataNum = Para[9];
			        InitValue(Para);
			    }
			    
			    if (gMultiDataNum == "") {
			        document.getElementById("ParantName").innerHTML = " <font color='gray'> " + gParantName + " </font> ";
			    } else {
			        document.getElementById("ParantName").innerHTML = " <font color='gray'> " + gParantName2 + " </font> ";
			    }

			    initTreeInfo();
   
			    RtnVal[0] = "FALSE";
			    returnFunction(RtnVal);
			});
			
			function InitValue(Para) {
			    var Cnt;
			    var contID = new Array();
			    var name = new Array();
			    gParantName = Para[2];
			    gParantName2 = Para[8];
			
			    document.getElementById("tbFormContID").value = Para[1];
			    document.getElementById("tbFormContName").value = gParantName;
			    document.getElementById("tbFormContName2").value = gParantName2;
			    document.getElementById("tbDescript").value = Para[5];
			    gParant = Para[4];
			    gManageID = Para[3];
			    companyID = Para[7];
			    
			    if (Para[3] != "ALL") {
			    	document.getElementById("rdGroup").checked = true;
			        rdGroup_onclick();
			        document.getElementById("tbManage").value = Para[6];
			        gManageID = Para[3];
			        
			        $.ajax({
			        	type : "POST",
			        	url : "/admin/ezApprovalG/getGroupDept.do",
			        	async : false,
			        	data : {fContID : document.getElementById("tbFormContID").value, companyID : companyID},
			        	success : function(result) {
			        		var xmlRtn = loadXMLString(result);
					        var objNode = xmlRtn.documentElement.childNodes;
					        
			        		for (Cnt = 0; Cnt < objNode.length/2; Cnt++) {
					            var nodevalue = SelectSingleNodeValueNew(xmlRtn, "PARAMETER/ID" + Cnt);
								
					            if (nodevalue != null && nodevalue != "" && nodevalue && "undefine") {
					                contID[Cnt] = SelectSingleNodeValueNew(xmlRtn, "PARAMETER/ID" + Cnt);
					                name[Cnt] = SelectSingleNodeValueNew(xmlRtn, "PARAMETER/NAME" + Cnt);
					                Add_Item(name[Cnt], contID[Cnt]);
					            }
					        }
			        	}
			        });
			    }
			}
			
			function Add_Item(Name, ID) {
			    var oOption = document.createElement("OPTION");
			    oOption.text = Name;
			    oOption.value = ID;
			    
			    if (CrossYN()) {
			        document.getElementById("selDept").add(oOption, null);
			    } else {
			        document.getElementById("selDept").add(oOption);
			    }
			}
			
			function InsFContTotal() {
			    if (document.getElementById("tbFormContName").value == "") {
			        RtnState = false;
			        return;
			    }
			    
			    $.ajax({
			    	type : "POST",
			    	url : "/admin/ezApprovalG/setFormContIns.do",
			    	async : false,
			    	data : {fContName : document.getElementById("tbFormContName").value, //양식함 이름 (Primary)
			    			fContName2 : document.getElementById("tbFormContName2").value, //양식함 이름(다국어)
			    			fContDescript : document.getElementById("tbDescript").value, //양식함 설명
			    			fContParent : gParant, //상위양식함ID
			    			fContDept : "ALL", //전체사용자
			    			deptList : "", //선택된부서
			    			companyID : companyID},
			    	success : function(result) {
			    		if (result.indexOf("false") > -1) {
			    			RtnState = false;
			    		} else {
			    			RtnState = true;
			    			gFContID = SelectSingleNodeValueNew(loadXMLString(result), "PARAMETER/FContID");//objChildNode[0].childNodes[0].nodeValue;
			    		}
			    	}
			    });
			}
			
			function InsFContGroup() {
			    if (document.getElementById("tbFormContName").value == "" || document.getElementById("tbManage").value == "") {
			        RtnState = false;
			        return;
			    }
			    
			    var Count = document.getElementById("selDept").length;
			    var selDept = "";
			    for (var i = 0; i < Count; i++) {
			        ParaValue = document.getElementById("selDept").item(i).value;
			        selDept += ParaValue + ";";
			    }
				
			    $.ajax({
			    	type : "POST",
			    	url : "/admin/ezApprovalG/setFormContIns.do",
			    	async : false,
			    	data : {fContName : document.getElementById("tbFormContName").value, //양식함 이름 (Primary)
			    			fContName2 : document.getElementById("tbFormContName2").value, //양식함 이름(다국어)
			    			fContDescript : document.getElementById("tbDescript").value, //양식함 설명
			    			fContParent : gParant, //상위양식함ID
			    			fContDept : gManageID, //관리부서 ID
			    			deptList : selDept, //선택된부서
			    			companyID : companyID},
			    	success : function(result) {
			    		if (result.indexOf("false") > -1) {
			    			RtnState = false;
			    		} else {
			    			RtnState = true;
			    			gFContID = SelectSingleNodeValueNew(loadXMLString(result), "PARAMETER/FContID");//objChildNode[0].childNodes[0].nodeValue;
			    		}
			    	}			    	
			    });
			}
			
			function UpFcontTotal() {
			    $.ajax({
			    	type : "POST",
			    	url : "/admin/ezApprovalG/setFormContMod.do",
			    	async : false,
			    	data : {fContName : document.getElementById("tbFormContName").value, //양식함 이름 (Primary)
			    			fContName2 : document.getElementById("tbFormContName2").value, //양식함 이름(다국어)
			    			fContDescript : document.getElementById("tbDescript").value, //양식함 설명
			    			fContParent : gParant, //상위양식함ID
			    			fContDept : "ALL", //관리부서 ID
			    			fContID : document.getElementById("tbFormContID").value, //양식함 ID
			    			companyID : companyID},
			    	success : function(result) {
			    		if (result.indexOf("FALSE") > -1) {
					        RtnState = false;
					    } else {
					        RtnState = true;
					    }
			    	}
			    });
			}
			
			function UpFContGroup() {
			    var Count = document.getElementById("selDept").length;
			    var selDept = "";
			    for (var i = 0; i < Count; i++) {
			        ParaValue = document.getElementById("selDept").item(i).value;
			        selDept += ParaValue + ";";
			    }
			    
				$.ajax({
			    	type : "POST",
			    	url : "/admin/ezApprovalG/setFormContMod.do",
			    	async : false,
			    	data : {fContName : document.getElementById("tbFormContName").value, //양식함 이름 (Primary)
			    			fContName2 : document.getElementById("tbFormContName2").value, //양식함 이름(다국어)
			    			fContDescript : document.getElementById("tbDescript").value, //양식함 설명
			    			fContParent : gParant, //상위양식함ID
			    			fContDept : gManageID, //관리부서 ID
			    			fContID : document.getElementById("tbFormContID").value, //양식함 ID
			    			deptList : selDept, //선택된부서
			    			companyID : companyID},
			    	success : function(result) {
			    		if (result.indexOf("FALSE") > -1) {
			    			RtnState = false;
					    } else {
					    	RtnState = true;
					    }
			    	}
			    });
			}
			
			function initTreeInfo() {
			    var sstart, send;
			    var compDeptid = "";

			    Tree_setconfig();
			    TreeViewinitialize("", "<c:out value = '${topID}' />", "extensionAttribute2;extensionAttribute3", "<c:out value = '${serverName}' />");
			}
			
			function Tree_setconfig() {
			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
			    xmlHTTP.send();
			    
			    if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
			        var treeView = new TreeView();
			        treeView.SetConfig(xmlHTTP.responseXML);
			    }
			}
			
			function rdGroup_onclick() {
			    document.getElementById("rdTotal").checked = false;
			    gManageID = "";
			    
			    document.getElementById("btnManage").style.display = "";
	            document.getElementById("btnUseDept").style.display = "";
	            document.getElementById("btnDelDept").style.display = "";
			}
			
			function rdTotal_onclick() {
			    document.getElementById("rdGroup").checked = false;
			    gManageID = "ALL";
			
			    document.getElementById("btnManage").style.display = "none";
	            document.getElementById("btnUseDept").style.display = "none";
	            document.getElementById("btnDelDept").style.display = "none";
			}
			
			function btnManage_onclick() {
			    var treeView = new TreeView();
			    treeView.LoadFromID("FromTreeView");
			    var nodeIdx = treeView.GetSelectNode();
			
			    var treeNode = new TreeNode();
			    treeNode.LoadFromID(nodeIdx.NodeID);
			
			    if (nodeIdx != "") {
			        selDeptName = treeNode.GetNodeData("VALUE");
			        selDeptID = treeNode.GetNodeData("CN");
			        document.getElementById("tbManage").value = selDeptName;
			        gManageID = selDeptID;
			    } else {
			        alert("<spring:message code = 'ezApprovalG.t1763' />");
				}
			}
			
			function btnUseDept_onclick() {
			var selDeptID, selDeptName;
			var oOption = document.createElement("OPTION");
			
			var treeView = new TreeView();
			treeView.LoadFromID("FromTreeView");
			var nodeIdx = treeView.GetSelectNode();
			
			var treeNode = new TreeNode();
			treeNode.LoadFromID(nodeIdx.NodeID);
			
			if (nodeIdx != "") {
			    selDeptName = treeNode.GetNodeData("VALUE");
			    selDeptID = treeNode.GetNodeData("CN");
			
			    oOption.text = selDeptName;
			    oOption.value = selDeptID;
			
			    if (document.getElementById("selDept").length > 0) {
			        for (var i = 0 ; i < document.getElementById("selDept").length ; i++) {
			            if (document.getElementById("selDept").item(i).value == oOption.value) {
			                alert("<spring:message code = 'ezApprovalG.t1644' />");
			            	return;
			        	}
			    	}
				}
			    
				if (CrossYN()) {
				    document.getElementById("selDept").add(oOption, null);
				} else {
				    document.getElementById("selDept").add(oOption);
				}
			} else {
				alert("<spring:message code = 'ezApprovalG.t1645' />");
				}
			}
			
			function btnDelDept_onclick() {
				var index;
				index = document.getElementById("selDept").selectedIndex;
			
				if (index != -1) {
					document.getElementById("selDept").remove(index);
				} else {
					alert("<spring:message code = 'ezApprovalG.t1646' />");
				}
			}
			
			function btnOK_onclick() {
				var RtnVal = new Array();
				if (Flag == "I") {
					if (document.getElementById("rdTotal").checked) {
			    		InsFContTotal();
					} else {
			    		InsFContGroup();
					}
					
					if (RtnState) {
			    		if (document.getElementById("rdTotal").checked) {
			        		gManageID = "ALL";
			    		}
			
					    RtnVal[0] = "TRUE";
					    RtnVal[1] = gFContID;
					    RtnVal[2] = document.getElementById("tbFormContName").value;
					    RtnVal[3] = gManageID;
					    RtnVal[4] = gParant;
					    RtnVal[5] = document.getElementById("tbDescript").value;
					    RtnVal[6] = document.getElementById("tbManage").value;
			
					    if (document.getElementById("tbFormContName2").value == "") {
					        RtnVal[7] = document.getElementById("tbFormContName").value;
					    } else {
					        RtnVal[7] = document.getElementById("tbFormContName2").value;
					    }
					} else {
			    		RtnVal[0] = "FALSE";
					}
				} else {
					if (document.getElementById("rdTotal").checked) {
			    		UpFcontTotal();
					} else {
			    		UpFContGroup();
					}
					
					if (RtnState) {
					    RtnVal[0] = "TRUE";
					    RtnVal[1] = document.getElementById("tbFormContName").value;
					    RtnVal[2] = document.getElementById("tbDescript").value;
					    RtnVal[3] = gManageID;
					    RtnVal[4] = document.getElementById("tbManage").value;
					    RtnVal[5] = document.getElementById("tbFormContName2").value;
					} else {
			    		RtnVal[0] = "FALSE";
					}
				}
				
// 				window.returnValue = RtnVal;
				returnFunction(RtnVal);
				window.close();
			}
			
			function btncancel_onclick() {
				var RtnVal = new Array();
				
				RtnVal[0] = "FALSE";
// 				window.returnValue = RtnVal;
				returnFunction(RtnVal);
				window.close();
			}
			
			function TreeViewNodeClick() {
			}
			
			function TreeViewNodeDbClick(){
			}
		</script>
	</head>
	<body oncontextmenu="return false" class="popup">
	    <xml id="data" style="display:none">
			<TREEVIEWDATA>
				<NODE>
					<TEXT></TEXT>
					<NODES></NODES>
				</NODE>
			</TREEVIEWDATA>
		</xml>
	    <h1><c:out value = '${title }' /></h1>
	    <table class="content">
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t1656' /></th>
	            <td id="ParantName">&nbsp;</td>
	        </tr>
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t1657' /></th>
	            <td style="padding: 0;">
	                <table width="100%">
	                    <tr class="primary">
	                        <th><c:out value = '${primary }' /></th>
	                        <td>
	                            <input type="text" id="tbFormContName" name="tbFormContName" maxlength="25" style="WIDTH: 100%">
	                            <input type="hidden" id="tbFormContID" name="tbFormContID">
	                        </td>
	                    </tr>
	                    <tr class="secondary">
	                        <th><c:out value = '${secondary }' /></th>
	                        <td>
	                            <input type="text" id="tbFormContName2" name="tbFormContName2" maxlength="25" style="WIDTH: 100%"></td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t1658' /></th>
	            <td>
	                <input type="text" id="tbDescript" name="tbDescript" style="WIDTH: 100%" maxlength="50">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t798' /></th>
	            <td>
	                <input type="radio" id="rdTotal" name="rdTotal" value="radiobutton" checked onclick="return rdTotal_onclick()">
	                <spring:message code = 'ezApprovalG.t1659' />
	                <input type="radio" id="rdGroup" name="rdGroup" value="radiobutton" onclick="return rdGroup_onclick()">
	                <spring:message code = 'ezApprovalG.t1660' /></td>
	        </tr>
	    </table>
	    <table style="margin-top: 10px; width:100%">
	        <tr>
	            <td valign="top" style="width:45%">
	                <div id="TreeView" style="BORDER: #b6b6b6 1px solid;WIDTH: 100%; HEIGHT: 288px; BACKGROUND-COLOR: #ffffff;overflow:auto"></div>
	            </td>
	            <td align="center" style="width:10%">
	               <a class="imgbtn" id="btnManage" style="display:none"><span onclick="btnManage_onclick()"><spring:message code = 'ezApprovalG.t1661' /></span></a>
	               <a class="imgbtn" id="btnUseDept" style="display:none"><span onclick="btnUseDept_onclick()"><spring:message code = 'ezApprovalG.t1662' /></span></a>
	               <a class="imgbtn" id="btnDelDept" style="display:none"><span onclick="btnDelDept_onclick()"><spring:message code = 'ezApprovalG.t1650' /></span></a>
	            </td>
	            <td valign="top" style="width:45%">
	                <input type="text" id="tbManage" name="tbManage" style="Width: 100%" readonly>
	                <select id="selDept" name="selDept" size="2" style="BORDER: #b6b6b6 1px solid; HEIGHT: 270px; WIDTH: 100%; Z-INDEX: 100">
	                </select>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span id="btnInsFcont" onclick="btnOK_onclick()"><spring:message code = 'ezApprovalG.t1760' /></span></a>
	        <a class="imgbtn"><span id="Span1" onclick="btncancel_onclick()"><spring:message code = 'ezApprovalG.t1761' /></span></a>
	    </div>
	</body>
</html>