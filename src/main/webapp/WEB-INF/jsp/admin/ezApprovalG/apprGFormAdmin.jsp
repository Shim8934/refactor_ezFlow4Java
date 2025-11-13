<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t607' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<style>
			.mainlist_free tr th {
				border-top:0px;
			}
			.tree_plus {margin-top: -3px !important;}
			.tree_minus {margin-top: 0px !important;}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewFolder.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/FormCont.js')}"></script>
		<script type="text/javascript">
			var OrderCell = "";
			var companyID = "";
			var Rtnval = new Array();
		    var pDeptID;
		    var TreeIdx;
		    var ListIdx;
		    var g_multiDataNum = "<c:out value = '${multiData}' />";
		    var nodeIdx;
		    var approvalFlag = "<c:out value = '${approvalFlag}' />";
		    var pEditor = "<c:out value = '${useEditor}' />";
		    var ua = navigator.userAgent;
		    var isIE = false;
		    var useHWP = "<c:out value = '${useHWP}' />";
		    var useWebHWP = "<c:out value = '${useWebHWP}' />";

            if (/msie 10/i.test(ua)) {
                isIE = true;	
            } else if (/msie/i.test(ua)) {
        		isIE = true;
        	} else if (/trident/i.test(ua)) {
        		isIE = true;
        	}
		    
		    if(new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function() {
		          window.focus();
		        };
		    }
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
		    };
			
		    $(document).ready(function(){
				if (!(/msie/i.test(ua)) && !(/rv:11.0/i.test(ua)) && pEditor == "FORM") {
					$('#btnInsForm1').hide();
					$('#btnInsForm2').hide();
					$('#btnUpForm').hide();
					$('#btnFormListView').hide();
				}
				
				if (useHWP == "YES") {
					if(useWebHWP == "NO" && isIE) {		// 한글 기안기 -> ie에서만 사용가능
						$('#btnInsForm2').show();
					}
					if(useWebHWP == "YES") {			// 웹 한글 기안기 -> 모든 브라우저 사용가능
						$('#btnInsForm3').show();
					}
				}
		    	
				companyID = document.getElementById("ListCompany").value;
				Tree_setconfig();
				InitFormCont();
		    });
		    
		    function refreshFormList() {
	            InitFormCont();
	        }
		    
		    function selectCompanyID() {
		        if (companyID != document.getElementById("ListCompany").value) {
		            companyID = document.getElementById("ListCompany").value
	
		            Tree_setconfig();
		            InitFormCont();
		        }
		    }
	
		    function Tree_setconfig() {
		    	var treeView = new TreeView();
		    	treeView.SetConfig(loadXMLFile("/xml/organtree_config2.xml"));
		    }
	
		    function select_onchange() {
			    var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);	
			    ID = treeNode.GetNodeData("DATA1");
			
			    if (TreeIdx != "") {
				    var ID = treeNode.GetNodeData("DATA1");
				    var KIND = document.getElementById('FromList').value;
				
				    GetFormInfo(ID, KIND, "", "");
			    }
		    }
	
		    function TreeViewRequestData(pNodeID, pTreeID) {
		        TreeIdx = pNodeID;
		    
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);	
			
			    ID = treeNode.GetNodeData("DATA1");
			    DeptID = treeNode.GetNodeData("DATA2");
			    KIND = document.getElementById('FromList').value;	
			
			    if (TreeIdx != "") {	
				    GetFormContInfo(ID, DeptID, "REQUEST");
			    }
			    
			    GetFormInfo(ID, KIND, "", "");	
		    }
	
		    function TreeViewNodeClick(pNodeID, pNodeNM) {
			    TreeIdx = pNodeID;
		    
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
			
			    ID =  treeNode.GetNodeData("DATA1");	
			    DeptID =  treeNode.GetNodeData("DATA2");
			    KIND = document.getElementById('FromList').value;	
			    
			    GetFormInfo(ID, KIND, "", "");
		    }
	
		    var formContMain_dialogArguments = new Array();
		    function btnInsFcont_onclick() {
		        var para = new Array();
	
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
	
		        nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx != null) {
		            para[0] = "I";
		            para[1] = nodeIdx.GetNodeData("DATA1");
		            para[2] = nodeIdx.GetNodeData("DATA2");
		            para[3] = companyID;
		            para[4] = nodeIdx.GetNodeData("DATA7");
		            para[5] = g_multiDataNum;
		            para[6] = nodeIdx.GetNodeData("DATA4");
		        } else {
		            return;
		        }
				
		        var url = "/admin/ezApprovalG/formContMain.do?tCheck=fContIns&companyID=" + encodeURI(companyID) + "&parentID=" + encodeURIComponent(para[6]) + "&contID=" + encodeURIComponent(para[1]);
		        formContMain_dialogArguments[0] = para;
		        formContMain_dialogArguments[1] = btnInsFcont_onclick_complete;
		        
		        GetOpenWindow(url, "FormContMain", 800, 700, "no");
		        
		        try { formContMain.focus(); } catch (e) {
		        }
		    }
		    
		    function btnInsFcont_onclick_complete(retVal) {
		    	if (retVal[0] == "TRUE") {
		            if (nodeIdx != null) {
		                var tmpDisplayFormName = "";
		                if (g_multiDataNum == "1") {
		                    tmpDisplayFormName = retVal[2];
		                } else {
		                    tmpDisplayFormName = retVal[7];
		                }
		         
		                Tree_setconfig();
		                InitFormCont();
		            }
		        }
		    }
	
		    function btnUpFcont_onclick() {
		        UpdateFCont();
		    }
	
		    var formContMain_dialogArguments = new Array();
		    function UpdateFCont() {
		        var para = new Array();
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
	
		        nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx != null) {
		            para[0] = "U";
		            para[1] = nodeIdx.GetNodeData("DATA1");
		            para[2] = nodeIdx.GetNodeData("DATA2");
		            para[3] = nodeIdx.GetNodeData("DATA3");
		            para[4] = nodeIdx.GetNodeData("DATA4");
		            para[5] = nodeIdx.GetNodeData("DATA5");
		            para[6] = nodeIdx.GetNodeData("DATA6");
		            para[7] = companyID;
		            para[8] = nodeIdx.GetNodeData("DATA7");
		            para[9] = g_multiDataNum;
	
		            
		            var url = "/admin/ezApprovalG/formContMain.do?tCheck=fContMod&companyID=" + encodeURI(companyID) + "&parentID=" + encodeURIComponent(para[4]);
		            formContMain_dialogArguments[0] = para;
			        formContMain_dialogArguments[1] = UpdateFCont_complete;
			        
			        GetOpenWindow(url, "FormContMain", 800, 700, "no");
			        
			        try { formContMain.focus(); } catch (e) {
			        }
		        }
		    }
		    
		    function UpdateFCont_complete(retVal) {
		    	if (retVal[0] == "TRUE") {
	                var tmpDisplayFormName = "";
	                if (g_multiDataNum == "1") {
	                    tmpDisplayFormName = retVal[1].replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("</", "&lt;/");
	                } else {
	                    tmpDisplayFormName = retVal[5].replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("</", "&lt;/");
	                }

	                nodeIdx.SetNodeName(tmpDisplayFormName);
	                nodeIdx.SetNodeData("VALUE", tmpDisplayFormName);
	                nodeIdx.SetNodeData("DATA2", retVal[1]);
	                nodeIdx.SetNodeData("DATA3", retVal[3]);
	                nodeIdx.SetNodeData("DATA5", retVal[2]);
	                nodeIdx.SetNodeData("DATA6", retVal[4]);
	                nodeIdx.SetNodeData("DATA7", retVal[5]);
	            }
		    }

		    function btnDelFcont_onclick() {
		    	if (confirm("<spring:message code = 'ezApprovalG.t999933' />")) {
			        DelFCont();
		    	}
		    }
	
		    function DelFCont() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");

		        nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx != null) {
		            var ID = nodeIdx.GetNodeData("DATA1");

		            if (!CheckSubFormCont(ID, nodeIdx)) {
		                var listview = new ListView();
		                listview.LoadFromID("lvtForm");
	
		                var Rows = listview.GetDataRows();

		                if (Rows[0].id.indexOf('TR_noItems') > 0) {
		                    var tempRet = "";

		                	$.ajax({
		                    	type : "POST",
		                    	url : "/admin/ezApprovalG/delFormCont.do",
		                    	async : false,
		                    	data : {id : ID, companyID : companyID},
		                    	success : function(result) {
		                    		tempRet = result;
		                    		
		                    		Tree_setconfig();
			                        InitFormCont();
		                    	},
		                    	error : function() {
		                    		OpenAlertUI("<spring:message code = 'ezApprovalG.t1615' />");
		                    	}
		                    });
		                	
		                } else {
		                	OpenAlertUI("<spring:message code = 'ezApprovalG.t1613' />");
		                }
		            } else {
		            	OpenAlertUI("<spring:message code = 'ezApprovalG.t1614' />");
		            }
		        }
		    }
	
		    function CheckSubFormCont(ID, pNodeIdx) {
		        var xmlRtn = createXmlDom();
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezApprovalG/getFormContInfo.do",
		        	async : false,
		        	dataType : "json",
		        	data : {id : ID, companyID : companyID},
		        	success : function(result) {
		        		xmlRtn = loadXMLString(result["resultXML"]);
		        	}
		        });
		        
		        if (SelectNodes(xmlRtn, "NODES/NODE").length > 0) {
		            return true;
		        }
		        
		        return false;
		    }
		    
		    function btnInsForm_onclick(type) {
		    	var para = new Array();
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
	
		        var nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx != null) {
		            if (nodeIdx.GetNodeData("DATA1") != "ROOT") {
		                var url = "";
						var HWP = "&type=HWP";
						var parameter = "?tCheck=fIns&contID=" + encodeURIComponent(nodeIdx.GetNodeData("DATA1")) + "&companyID=" + encodeURIComponent(companyID);
						
						if (type == "HWP" || type == "WebHWP") {
							url = "/admin/ezApprovalG/formMainOther.do";
							parameter = parameter + "&type=" + type;
						} else {
							//일반일때 ck
							if (approvalFlag =='S') {
								if (pEditor == "CK" || pEditor == "DEXT" || pEditor == "NAMO" || pEditor == "TAGFREE" || pEditor == "KUKUDOCS") {
									url = "/admin/ezApprovalG/formMainOther.do";
								} else {
									url = "/admin/ezApprovalG/formMain.do";
								}
							} else {
								if (pEditor == "CK" || pEditor == "DEXT" || pEditor == "NAMO" || pEditor == "TAGFREE" || pEditor == "KUKUDOCS") {
									url = "/admin/ezApprovalG/formMainOther.do";
								} else {
									url = "/admin/ezApprovalG/formMain.do";
								}
							}
						}
						
						var retVal = GetOpenWindow(url + parameter, "FormMain", 1115, 960, "no");
						Tree_setconfig();
		            } else {
		            	alert("<spring:message code = 'ezApproval.t722' />");
		            }
		        }
		    }
		    
		    function UpdateForm() {
		        var para = new Array();
	
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
	
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
	
		        nodeIdx = treeView.GetSelectNode();

		        if (nodeIdx > 0) {
		            para[0] = "U";
		            para[1] = nodeIdx.GetNodeData("DATA1");
		        }
		        
		        var selRow = listview.GetSelectedRows();
		        
		        if (selRow!= "") {
		            para[2] = GetAttribute(selRow[0], "DATA1");
		            para[3] = GetAttribute(selRow[0], "DATA5");
		            para[4] = GetAttribute(selRow[0], "DATA2");
		            para[5] = GetAttribute(selRow[0], "DATA3");
		            para[6] = companyID;
		            para[7] = GetAttribute(selRow[0], "DATA4");
		            para[8] = GetAttribute(selRow[0], "DATA6");
	
		            var url = "";
		            var HWP = "&type=HWP";
		            var parameter = "?tCheck=fUpdate&contID=" + encodeURIComponent(GetAttribute(selRow[0], "DATA8")) + "&formID=" + encodeURIComponent(GetAttribute(selRow[0], "DATA1")) + "&companyID=" + encodeURIComponent(companyID);
		            
		            if ((GetAttribute(selRow[0], "DATA4") != null ? GetAttribute(selRow[0], "DATA4").toLowerCase().indexOf(".hwp") : -1) > 0) {
		            	if(useWebHWP == "NO") {
			                if (isIE) {
								url = "/admin/ezApprovalG/formMainOther.do";
			                } else {
		                		var pAlertContent = "한글양식은 IE에서만 수정할 수 있습니다.";
		                        alert(pAlertContent);
								return;
			                }
		            	} else {
		            		HWP = "&type=WebHWP";
		            		url = "/admin/ezApprovalG/formMainOther.do";
		            	}
		                parameter = parameter + HWP;
		            }
		            else {
		            	parameter += "&reformflag=" + encodeURIComponent(GetAttribute(selRow[0], "REFORMFLAG"));
		            	
		            	if (approvalFlag =='S') {
							if (pEditor == "CK" || pEditor == "DEXT" || pEditor == "NAMO" || pEditor == "TAGFREE" || pEditor == "KUKUDOCS") {
								url = "/admin/ezApprovalG/formMainOther.do";
							} else {
								url = "/admin/ezApprovalG/formMain.do";
							}
						} else {
							if (pEditor == "CK" || pEditor == "DEXT" || pEditor == "NAMO" || pEditor == "TAGFREE" || pEditor == "KUKUDOCS") {

								url = "/admin/ezApprovalG/formMainOther.do";
							} else {
								url = "/admin/ezApprovalG/formMain.do";
							}
						}
		            }
		            
		            GetOpenWindow(url + parameter, "FormMain", 1115, 960, "no");

		            Tree_setconfig();
		        } else {
		        	OpenAlertUI("<spring:message code = 'ezApprovalG.t1532' />");
		        }
		    }
	
		    function DelForm() {	
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
	
		        var selRow = listview.GetSelectedRows();
		        if (selRow != "") {
		            if (confirm("<spring:message code = 'ezApprovalG.t999933' />") == true) {
		                var tempRet = "";
		                
		                $.ajax({
		                	type : "POST",
		                	url : "/admin/ezApprovalG/delForm.do",
		                	async : false,
		                	data : {formID : GetAttribute(selRow[0], "DATA1"), companyID : companyID, officeFlag : GetAttribute(selRow[0],"DATA-OFFICEFLAG")},
		                	success : function (result) {
		                		tempRet = result;
		                		
		                		listview.DeleteRow(GetAttribute(selRow[0], "id"));
			                    descrip.innerText = "";
		                	},
		                	error : function() {
		                		OpenAlertUI("<spring:message code = 'ezApprovalG.t173' />");
		                	}
		                });
		                
		                if (listview.GetRowCount() <= 0) {
		                	var objTr = document.createElement("TR");
		                	var objTd = document.createElement("TD");
		                	var oText = document.createTextNode(strLang944);
							var colCount = document.getElementById("lvtForm").getElementsByTagName("th").length;

		                	objTd.align = "center";
							objTd.setAttribute("colSpan", colCount);
		                	objTd.appendChild(oText);
		                	
		                	objTr.setAttribute("id", "lvtForm_TR_noItems");
		                	objTr.appendChild(objTd);
		                	
		                	document.getElementById("lvtForm").getElementsByTagName("tbody")[0].appendChild(objTr);
		                }
		            } else {
		                return;
		            }
		        } else {
		        	OpenAlertUI("<spring:message code = 'ezApprovalG.t1532' />");
		        }
		    }    
	
		    function lvtForm_Row_click() {
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        var oArrRows = listview.GetSelectedRows();
		        var tr = oArrRows[0];
	
		        if (tr) {
		            document.getElementById('descrip').innerHTML = GetAttribute(tr, "DATA2");
		            if ((GetAttribute(tr, "DATA4") != null ? GetAttribute(tr, "DATA4").toLowerCase().indexOf(".hwp") : -1) > 0) {
		               $("#btnFormListView").hide();
		            } else {
		            	//2019.12.30 김정언 - 미리보기 없애기
		            	$("#btnFormListView").hide();
		            }
		        }
		    }
	
		    function lvtForm_Row_Dbclick() {
		        if (!(/msie/i.test(ua)) && !(/rv:11.0/i.test(ua)) && pEditor == "FORM") {
		        	return;
		        } else {
		        	UpdateForm();
		        }
		    }
	
		    function MoveUp_onclick() {
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        listview.RowMoveUp();
		    }
	
		    function MoveDown_onclick() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);
	
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        listview.RowMoveDown();
		    }
	
		    function FormOrder_Save() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        nodeIdx = treeView.GetSelectNode();
	
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
	
		        var iRowCount = listview.GetRowCount();
		        var strFormList = "";
	
		        if (iRowCount != 0) {
		            for (var i = 0; i < iRowCount; i++) {
		                strFormList += GetAttribute(listview.GetDataRows()[i], "DATA1") + ";";
		            }
		        }
		        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezApprovalG/setFormOrder.do",
		        	async : false,
		        	data : {formContID : nodeIdx.GetNodeData("DATA1"), boardIDList : strFormList, companyID : companyID},
		        	success : function(result) {
		        		if (result == "OK") {
		        			OpenAlertUI("<spring:message code = 'ezApprovalG.t1581' />");
				        }
		        	},
		        	error : function() {
		        		OpenAlertUI("<spring:message code = 'ezApprovalG.t391' />");
		        	}
		        });
		    }
		    
		    function btnFormListView_onclick() {
		    	var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        var oArrRows = listview.GetSelectedRows();
		        var tr = oArrRows[0];
				
		        if(encodeURI(GetAttribute(tr, "DATA4"))==""){
				alert("<spring:message code = 'ezPortal.t60' />");
				return;
				}else{
		        var url = "/admin/ezApprovalG/formPreview.do?href=" + encodeURI(GetAttribute(tr, "DATA4"));
		        var retVal = GetOpenWindow(url, "Form_Preview", 1050, 1000, "no");
				}
		    }
		    
		    function searchform() {
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");

		        if (TreeIdx != "") {
		            if (document.getElementById('forminfo').value.trim() == "") {
		                alert("<spring:message code = 'ezApprovalG.t1160' />");
						return;
		        	}

			        var ID = treeNode.GetNodeData("DATA1");
			        var KIND = document.getElementById('FromList').value;
			        var searchtype = document.getElementById('searchoption').selectedIndex;
			        var searchname = document.getElementById('forminfo').value;
			        GetFormInfo("ALL", KIND, searchtype, searchname);
		    	}
		    }
		    
		    function reset() {
		        document.getElementById('forminfo').value = "";
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        var ID = treeNode.GetNodeData("DATA1");
		        var KIND = document.getElementById('FromList').value;
		        
		        GetFormInfo(ID, KIND, "", "");
		    }

		    function search_press(evt) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		                searchform();
		            }
		        }
		        else {
		            if (evt.which == 13)
		                searchform();
		        }
		    }


		    var formContMain_dialogArguments = new Array();
		    function MoveForm() {
		        var para = new Array();
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");

		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
				
				var lvtForm = document.getElementById("lvtForm");
				if (lvtForm) {
					var lastId = lvtForm.getAttribute("lastselectedrowid");
					var target = document.getElementById(lastId);
					if (target) {
						lvtFormFormBoxId = target.getAttribute("data8");
					}
				}

		        var nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx != null) {
					if (lvtFormFormBoxId){
						para[0] = lvtFormFormBoxId;
					} else {
		            	para[0] = nodeIdx.GetNodeData("DATA1");
					}
		            
		        }
		        var selRow = listview.GetSelectedRows();
		        if (selRow != "") {
		            para[1] = GetAttribute(selRow[0], "DATA1");
		            para[2] = companyID;
		            var url = "/admin/ezApprovalG/formSelect.do";

		            
					if(CrossYN()){
						formContMain_dialogArguments[0] = para;
						formContMain_dialogArguments[1] = moveForm_onclick_Complete;
		
			            var moveForm_Cross = window.open(url, "SelectTaskCategory", GetOpenWindowfeature(460, 590));
			            try { SelectTaskCategory_Cross.focus(); } catch (e) { }
					} else {
			            var retVal = window.showModalDialog(url, para, "dialogWidth:460px;dialogHeight:580px;status:no;help:no;scroll:no;edge:sunken");
			            if (retVal[0] == "OK") {
			                Tree_setconfig();
			                InitFormCont();
			            }
					}
		        } else {
		        	OpenAlertUI("<spring:message code = 'ezApprovalG.t1532' />");
		        }
		    }
		    
		    function  moveForm_onclick_Complete(retVal) {
		        if (retVal[0] == "OK") {
	                Tree_setconfig();
	                InitFormCont();
	            }
			}


			var fContMain_dialogArguments = new Array();
			function btnMoveFcont_onclick() {
				var para = new Array();
				var treeView = new TreeView();
				treeView.LoadFromID("FromTreeView");
				
				var nodeIdx = treeView.GetSelectNode();
				if (nodeIdx != null) {
					if (nodeIdx.GetNodeData("DATA1") != "ROOT") {
						para[0] = nodeIdx.GetNodeData("DATA1"); //CONT ID
						para[1] = nodeIdx.GetNodeData("DATA4"); //상위 CONT ID
						para[2] = companyID;
						para[3] = nodeIdx.GetNodeData("DATA6");// 전체, 그룹 사용 정보
						var url = "/admin/ezApprovalG/moveFcontSelect.do";
	
	
						if(CrossYN()){
							fContMain_dialogArguments[0] = para;
							fContMain_dialogArguments[1] = btnMoveFcont_onclick_Complete;
	
							var moveForm_Cross = window.open(url, "SelectTaskCategory", GetOpenWindowfeature(460, 590));
							try { SelectTaskCategory_Cross.focus(); } catch (e) { }
						} else {
							var retVal = window.showModalDialog(url, para, "dialogWidth:460px;dialogHeight:580px;status:no;help:no;scroll:no;edge:sunken");
							if (retVal[0] == "OK") {
								Tree_setconfig();
								InitFormCont();
							}
						}
					} else {
						OpenAlertUI("<spring:message code = 'ezApprovalG.KMHF04' />");
					}
				}else{
					OpenAlertUI("<spring:message code ='ezApprovalG.KMHF06' />");
				}
			}

			function  btnMoveFcont_onclick_Complete(retVal) {
				if (retVal[0] == "OK") {
					Tree_setconfig();
					InitFormCont();
				}
			}

			var fContMainSN_dialogArguments = new Array();
			function btnMoveSNFcont_onclick() {
				var para = new Array();
				var treeView = new TreeView();
				treeView.LoadFromID("FromTreeView");

				var nodeIdx = treeView.GetSelectNode();

				if (nodeIdx != null) {
					para[0] = nodeIdx.GetNodeData("DATA1"); //CONT ID
					para[1] = companyID;
					var url = "/admin/ezApprovalG/moveSNFcontSelect.do?contID=" + para[0] + "&companyID=" + para[1];


					if (CrossYN()) {
						fContMainSN_dialogArguments[0] = para;
						fContMainSN_dialogArguments[1] = btnMoveSNFcont_onclick_Complete;

						var moveForm_Cross = window.open(url, "SelectTaskCategory", GetOpenWindowfeature(460, 590));
						try {
							SelectTaskCategory_Cross.focus();
						} catch (e) {
						}
					} else {
						var retVal = window.showModalDialog(url, para, "dialogWidth:460px;dialogHeight:580px;status:no;help:no;scroll:no;edge:sunken");
						if (retVal[0] == "OK") {
							Tree_setconfig();
							InitFormCont();
						}
					}
				}else{
					OpenAlertUI("<spring:message code ='ezApprovalG.KMHF06' />");
				}
			}

			function  btnMoveSNFcont_onclick_Complete(retVal) {
				if (retVal[0] == "OK") { 
					Tree_setconfig(); 
					InitFormCont(); 
				} 
			} 
		</script>
	
	</head>
	<body class="mainbody">
		<xml id='FORMLIST' style="display: none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code ='ezApprovalG.t1537' /></NAME>
						<WIDTH>215</WIDTH>
				    </HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<xml id='FORMCONTAINER' style="display: none">
			<TREEVIEWDATA>
				<NODE>
					<EXPANDED>TRUE</EXPANDED>
					<ISLEAF>FALSE</ISLEAF>
					<VALUE><spring:message code ='ezApprovalG.t1539' /></VALUE>
					<DATA1>ROOT</DATA1> 
					<DATA2><spring:message code ='ezApprovalG.t1539' /></DATA2> 
					<DATA4><spring:message code ='ezApprovalG.t1539' /></DATA4> 
				</NODE>
			</TREEVIEWDATA>
		</xml>
		
		<h1>
		<c:choose>
			<c:when test="${approvalFlag == 'S' }">
				<spring:message code = 'ezApprovalG.t1463' />
			</c:when>
			<c:otherwise>
				<spring:message code = 'ezApprovalG.t1612' />
			</c:otherwise>
		</c:choose>
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select class="companySelect" id="ListCompany" onChange="selectCompanyID()">
	        	<c:forEach var="item" items="${list}">
	           		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	           	</c:forEach>
		    </select>
		</h1>
		
		<div id="mainmenu">
		    <ul>
		        <li class="important" id="btnInsFcont"><span onclick="return btnInsFcont_onclick()"><spring:message code = 'ezApprovalG.t1623' /></span></li>
		        <li id="btnUpFcont"><span onclick="return btnUpFcont_onclick()"><spring:message code = 'ezApprovalG.t1627' /></span></li>
		        <li id="btnDelFcont"><span onclick="return btnDelFcont_onclick()"><spring:message code = 'ezApprovalG.t1628' /></span></li>
				<li id="btnMoveFcont"><span onclick="return btnMoveFcont_onclick()"><spring:message code = 'ezApprovalG.KMHF05' /></span></li>
				<li id="btnMoveSNFcont"><span onclick="return btnMoveSNFcont_onclick()"><spring:message code = 'ezApprovalG.KMHF07' /></span></li>
		        <!-- <li style="background: none;"><img src="/images/i_bar.gif" style="vertical-align: middle"></li> -->
		        <li class="important" id="btnInsForm1"><span onclick="return btnInsForm_onclick('MHT')"><spring:message code = 'ezApprovalG.t1667' /></span></li>
            	<li class="important" id="btnInsForm2" style = 'display:none;'><span onclick="return btnInsForm_onclick('HWP')">HWP <spring:message code = 'ezApprovalG.t1667' /></span></li>
            	<li class="important" id="btnInsForm3" style = 'display:none;'><span onclick="return btnInsForm_onclick('WebHWP')">HWP <spring:message code = 'ezApprovalG.t1667' /></span></li>
		        <li id="btnUpForm"><span onclick="return UpdateForm()"><spring:message code = 'ezApprovalG.t1668' /></span></li>
		        <li id="btnDelForm"><span onclick="return DelForm()"><spring:message code = 'ezApprovalG.t1619' /></span></li>
				<li id="btnModeForm"><span onclick="return MoveForm()"><spring:message code = 'ezApprovalG.t25000' /></span></li>
		        <!-- <li style="background: none;"><img src="/images/i_bar.gif" style="vertical-align: middle"></li> -->                     
		        <li id="btnFormListView" style="display: none;"><span onclick="return btnFormListView_onclick()"><spring:message code = 'ezApprovalG.t1252' /></span></li>
			</ul>
		</div>
		<table class="content" style="width:1000px;height:33px">
			<tr>
		    	<th style="border:0px"><spring:message code = 'ezApprovalG.t1540' /></th>
		    	<td style="border:0px;background-color: #f8f8fa;">
		    		<select name="select" style="WIDTH:200px;" onchange="return select_onchange()" id="FromList">${docType}</select>
		      	</td>
				<td style="white-space: nowrap;border:0px;background-color: #f8f8fa;">
					<select id="searchoption" style="height:22px;">
						<option value="1"><spring:message code = 'ezApprovalG.t442' /></option>
						<option value="2"><spring:message code = 'ezApprovalG.t598' /></option>
					</select>
					<input id="forminfo" onkeypress="search_press(event)" type="text" style="height:25px; vertical-align: baseline;" />
					<a class="imgbtn imgbck" onclick="searchform()" style="margin-top: 3px;"><span><spring:message code = 'ezApprovalG.t111' /></span></a>
					<a class="imgbtn imgbck" onclick="reset()" style="margin-top: 3px;"><span><spring:message code = 'ezApprovalG.t1301' /></span></a>
				</td>
		  	</tr>
		</table>
		
		<table style="margin-top:5px;width:1005px;height:500px">
			<tr>
		    	<td rowspan="3" style="width:400px; vertical-align:top">
					<div id="divFromTreeView" style="vertical-align:top; padding-top:5px; height:500px; width:100%; overflow-x:auto;overflow-y:auto;BORDER:#ddd 1px solid; BACKGROUND-COLOR:#ffffff" ></div>
				</td>
		    	<td style="width:600px; padding-left:5px; padding-right:5px;vertical-align:top">
			    	<div class="listview">
			        	<div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 470px;overflow-x:auto;overflow-y:auto; padding:0px"  ></div>
			    	</div>
				</td>    
		  	</tr>
		    <tr>
		    	<td style="padding-left:5px; padding-right:5px; padding-top:5px; vertical-align:top">
		        	<table class="content">
			            <tr>
		            		<th><spring:message code = 'ezApprovalG.t1543' /></th>
		              		<td id="descrip">&nbsp;</td>
		            	</tr>
		        	</table>
		    	</td>
		  	</tr>   
		    <tr>
		    	<td>
		    		<div class="btnpositionJsp">
			        	<a class="imgbtn"><span onclick="return MoveUp_onclick()"><spring:message code = 'ezApprovalG.t403' /></span></a>
			        	<a class="imgbtn"><span onclick="return MoveDown_onclick()"><spring:message code = 'ezApprovalG.t404' /></span></a>
			        	<a class="imgbtn"><span onclick="return FormOrder_Save()"><spring:message code = 'ezApprovalG.t59' /></span></a>
			        </div>	
		    	</td>
		  	</tr>  
		</table>
		<script>
	    	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	</body>
</html>
