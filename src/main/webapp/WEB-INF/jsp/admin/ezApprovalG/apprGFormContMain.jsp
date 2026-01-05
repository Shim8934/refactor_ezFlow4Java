<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<style type="text/css">
			#selDept {
				background : none;
				overflow-y : auto;
				overflow-x : auto;
				padding-right : 0px;
			}
			.popup h2.h2_dot {
				padding-top: 0px;
			}
			.tree_plus {margin-top: -3px !important;}
			.tree_minus {margin-top: 0px !important;}
		</style>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}"></script>

		<script type="text/javascript">
			var OrderCell = "";
			var gManageID, gFContID, gParant, Flag, RtnState, gParantName;
			var companyID;
			var gParantName2 = "";
			var gMultiDataNum = "";
			var returnFunction
			var approvalFlag = "<c:out value = '${approvalFlag}' />";
			var parentContName = "<c:out value='${parentName}'/>"
			
			if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
			    window.onblur = function () {
			        window.focus();
			    };
			}
			
			$(document).ready(function () {
				if (approvalFlag == 'S') {
					$(".approvalG").hide();
					$(".approvalS").show();
				} else {
					$(".approvalS").hide();
					$(".approvalG").show();
				}
				
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
			    
			    document.getElementById("ParantName").innerHTML = " <font color='gray'> " + parentContName + " </font> ";

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
			    
			    if (Para[3] != "ALL" && ((approvalFlag == "G" && Para[3] != "none") || approvalFlag == "S")) {
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
		    			RtnState = true;
		    			gFContID = SelectSingleNodeValueNew(loadXMLString(result), "PARAMETER/FContID");//objChildNode[0].childNodes[0].nodeValue;
			    	},
			    	error : function() {
			    		RtnState = false;
			    	}
			    });
			}
			
			function InsFContGroup() {
				if (approvalFlag == 'S') {
					if (document.getElementById("tbFormContName").value == "") {
				        RtnState = false;
				        return;
				    }
				} else {
					if (document.getElementById("tbFormContName").value == "" || document.getElementById("tbManage").value == "") {
				        RtnState = false;
				        return;
				    }
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
		    			RtnState = true;
		    			gFContID = SelectSingleNodeValueNew(loadXMLString(result), "PARAMETER/FContID");//objChildNode[0].childNodes[0].nodeValue;
			    	},
			    	error : function() {
			    		RtnState = false;
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
				        RtnState = true;
			    	},
			    	error : function() {
			    		RtnState = false;
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
			    	    RtnState = true;
			    	},
			    	error : function() {
			    		RtnState = false;
			    	}
			    });
			}
			
			function initTreeInfo() {
			    var sstart, send;
			    var compDeptid = "";

			    Tree_setconfig();
			    TreeViewinitialize("", "<c:out value = '${topID}' />/other", "extensionAttribute2;extensionAttribute3", "<c:out value = '${serverName}' />", null, null, true);
			}
			
			function Tree_setconfig() {
				var xmlDom = createXmlDom();
	            xmlDom = loadXMLFile("/xml/organtree_config.xml");
		    	var treeView = new TreeView();
	            treeView.SetConfig(xmlDom);
			}
			
			function rdGroup_onclick() {
			    document.getElementById("rdTotal").checked = false;
			    gManageID = "";
			    
			    if (approvalFlag == 'S') {
			    	document.getElementsByName("btnUseDept")[0].style.display = "";
		            document.getElementsByName("btnDelDept")[0].style.display = "";
			    } else {
				    document.getElementById("btnManage").style.display = "";
		            document.getElementById("btnUseDept").style.display = "";
		            document.getElementById("btnDelDept").style.display = "";
			    }
			}
			
			function rdTotal_onclick() {
				document.getElementById("rdGroup").checked = false;
			    gManageID = "ALL";
				
			    if (approvalFlag == 'S') {
			    	document.getElementsByName("btnUseDept")[0].style.display = "none";
		            document.getElementsByName("btnDelDept")[0].style.display = "none";
			    } else {
			    	document.getElementById("btnManage").style.display = "none";
		            document.getElementById("btnUseDept").style.display = "none";
		            document.getElementById("btnDelDept").style.display = "none";
			    }
			    $("#tbManage").val("");
			    $("#selDept option").remove();
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
				if (document.getElementById("tbFormContName").value != "" && document.getElementById("tbFormContName2").value != "") {
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
//	 				window.returnValue = RtnVal;
					returnFunction(RtnVal);
					window.close();					
				} else {
					alert("<spring:message code = 'ezApprovalG.pjg01' />");
				}

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
	    <div id="close">
            <ul>
                <li><span id="Span1" onclick="btncancel_onclick()"></span></li>
            </ul>
        </div>
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
					<div class='custom_radio'>
						<input type="radio" id="rdTotal" name="rdTotal" style="margin-bottom: 2px;" value="radiobutton" checked onclick="return rdTotal_onclick()">
						<label for="rdTotal"><spring:message code = 'ezApprovalG.t1659' /></label>
						<input type="radio" id="rdGroup" name="rdGroup" style="margin-bottom: 2px;" value="radiobutton" onclick="return rdGroup_onclick()">
						<label for="rdGroup"><spring:message code = 'ezApprovalG.t1660' /></label>
					</div>
				</td>
	        </tr>
	    </table>
	    <table style="margin-top: 10px; width:100%">
	        <tr>
	            <td valign="top" style="width:43%; max-width: 336px;">
	            	<div><h2 class="h2_dot"><span style="min-width: 45px;"><spring:message code = 'main.t8' /></span></h2></div>
	                <div id="TreeView" style="border: #ddd 1px solid;width: 100%; height: 404px; background-color: #ffffff;overflow:auto"></div>
	            </td>
	            <td class = 'approvalG' align="center" style="width:5%">
	            	<img id="btnManage" style="cursor:pointer; display:none" src="../../images/kr/cm/arr_right.gif" width="16" height="16" onclick="btnManage_onclick()"><br><br>
	            	<img id="btnUseDept" style="cursor:pointer; display:none" src="../../images/kr/cm/arr_right.gif" width="16" height="16" onclick="btnUseDept_onclick()"><br>
	                <img id="btnDelDept" style="cursor:pointer; display:none" src="../../images/kr/cm/arr_left.gif" width="16" height="16" onclick="btnDelDept_onclick()">
	            </td>
	            <td class = 'approvalS' style="width:5%; text-align:center">               
	               <img name="btnUseDept" style="cursor:pointer; display:none" src="../../images/kr/cm/arr_right.gif" width="16" height="16" onclick="btnUseDept_onclick()"><br>
	               <img name="btnDelDept" style="cursor:pointer; display:none" src="../../images/kr/cm/arr_left.gif" width="16" height="16" onclick="btnDelDept_onclick()">
	            </td>
	            <td valign="top" style="width:43%">
	            	<div class = 'approvalG'><h2 class="h2_dot"><span style="min-width: 45px;"><spring:message code = 'ezResource.t151' /></span></h2></div>
	                <input class = 'approvalG' type="text" id="tbManage" name="tbManage" style="Width: 100%" readonly>
	            	<h2 class="h2_dot"><span style="min-width: 45px;"><spring:message code = 'ezApprovalG.t798' /></span></h2>
	                <c:choose>
	                	<c:when test="${approvalFlag eq 'S'}">
			                <select id="selDept" name="selDept" size="2" style="border: #ddd 1px solid; height: 405px; width: 100%; z-index: 100">
			                </select>
	                	</c:when>
	                	<c:otherwise>
			                <select id="selDept" name="selDept" size="2" style="border: #ddd 1px solid; height: 352px; width: 100%; z-index: 100">
			                </select>
	                	</c:otherwise>
	                </c:choose>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span id="btnInsFcont" onclick="btnOK_onclick()"><spring:message code = 'ezApprovalG.t1760' /></span></a>
	    </div>
	</body>
</html>