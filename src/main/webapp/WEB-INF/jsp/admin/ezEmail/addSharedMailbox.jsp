<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.sharedMailbox09' /></title>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('main.lhm01', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script src="${util.addVer('/js/ezPersonal/controls/TreeView.js')}" type="text/javascript"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
	    <style>
			input[type=checkbox]{vertical-align: middle;}
	    	.mainlist thead tr {
	    		height: 0px;
	    	}
	    	
	    	.mainlist #MsgToList_THEAD #MsgToList_TH {
	    		height: 0px;
	    	}
	    	
	    	.mainlist tr td:first-child {
	    		padding-left:15px;
	    	}
	    	.box {
	    		border-right:0px;
	    	}
			/* 조직도 #SelectDeptNM(부서명[사원수]) 부분 */
	    	#spn_deptName {
	    		text-overflow: ellipsis;
	    		white-space: nowrap;
	    		overflow: hidden;
	    		display: inline-block;
	    	}
	    	#countInfo {
	    		overflow: hidden;
	    		display: inline-block;
	    	}
	    </style>
	    <script type="text/javascript">
	        var shareId = '<c:out value = "${shareId}"/>';
	        var companyId = '<c:out value = "${compId}"/>';
	        var pListType = "TXT";
	        var pListXML_Info = null;
	        var strLang1 = "<spring:message code='ezEmail.t10001' />";
	        var strLang2 = "<spring:message code='ezEmail.t10000' />";
	        var ReturnFunction;
	        var m_orgImg = {"normal": "/images/tab_org1.gif", "select": "/images/tab_org.gif"};
	        var m_tabDialogState = {"org": "select"};
	        var selSpan = "";
	        var selectDomain = "${companyMailDomain}";
	        var sharedMailbox_Mail = "${sharedMailboxMail}";
	        
	        window.onload = function () {
	            try {
	                ReturnFunction = parent.sharedMailboxDialogArguments[0];
	            } catch (e) {
	                try {
	                    ReturnFunction = opener.sharedMailboxDialogArguments[0];
	                } catch (e) {
	                    console.log(e);
	                }
	            }
	            
	            var xmlpara = createXmlDom();
                var xmlTree = createXmlDom();
                var xmlHTTP = createXMLHttpRequest();
                var objNode;
                createNodeInsert(xmlpara, objNode, "DATA");
                createNodeAndInsertText(xmlpara, objNode, "DEPTID", companyId);
                createNodeAndInsertText(xmlpara, objNode, "TOPID", companyId);
                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
                createNodeAndInsertText(xmlpara, objNode, "ADMINDIST", "true");
                createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
	            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            xmlHTTP.send(xmlpara);
	            recevieListview("MsgToList", "ListViewMsgTo");
	            ListTypeChangeIcon();
	
	            if (xmlHTTP != null && xmlHTTP.readyState == 4) {
	                if (xmlHTTP.status == 200) {
	                    var xmlTree = loadXMLString(xmlHTTP.responseText);
	                    var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
	                    var treeView = new TreeView();
	                    treeView.SetConfig(treeXML);
	                    treeView.SetID("FromTreeView");
	                    treeView.SetUseAgency(true);
	                    treeView.SetRequestData("RequestData");
	                    treeView.SetNodeClick("TreeViewNodeClick");
	                    treeView.DataSource(xmlTree);
	                    treeView.DataBind("TreeView");
	                }
	                else {
	                    alert("<spring:message code='ezEmail.t13' />" + xmlHTTP.status);
	                    xmlHTTP = null;
	                }
	            }
	            
	            orgTabButton_onClick();
	            
	            if (shareId != "") {
	            	$.ajax({
		    			url: "/admin/ezEmail/getSharedMailboxInfo.do",
		    			type: "POST",
		    			async: false,
		    			dataType: 'json',
		    			data: {'shareId' : shareId},
		    			success: function(result) {
		    				if (result.resultCode === "OK") {
		    					initSharedMailboxInfo(result.sharedMailboxInfo);
		    				} else if (result.resultCode === "NO_PERMISSION") {
		    					alert("<spring:message code='ezOrgan.t302' />");
		    				} else {
		    					alert("<spring:message code='ezEmail.sharedMailbox07' />");
		    				}
		    			},
		    			error: function(err) {
		    				alert("<spring:message code='ezEmail.sharedMailbox07' />");
		    			}
		    		});
	            }
	            
	            ChangeListView_onClick(getOrganListType());
	            
	            document.getElementById("TextName").focus();
	        }
	
	        function MakeXMLString(pStr) {
	            pStr = ReplaceText(pStr, "&", "&amp;");
	            pStr = ReplaceText(pStr, "<", "&lt;");
	            pStr = ReplaceText(pStr, ">", "&gt;");
	            return pStr;
	        }
	
	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            return (orgStr.replace(re, replaceStr));
	        }
	
	        function initSharedMailboxInfo(sharedMailboxInfo) {
        		document.getElementById("TextId").value = sharedMailboxInfo.shareId;
        		document.getElementById("TextName").value = sharedMailboxInfo.shareName;
        		var shareMail = sharedMailboxInfo.shareMail;
        		document.getElementById("mailDomain").innerHTML = shareMail.substring(shareMail.indexOf("@"));
	        	document.getElementById("TextId").disabled = true;
	        	document.getElementById("TextPassword").disabled = true;
            	document.getElementById("TextPassword2").disabled = true;
	        	
	        	var userList = sharedMailboxInfo.userList;
	        	var resultXml = "<LISTVIEWDATA><ROWS>";
	        	
	        	userList.forEach(function(vo, index) {
	        		var xmlStrId = MakeXMLString(vo.userId);
	        		var xmlStrname = MakeXMLString(vo.userName);
	        		resultXml += "<ROW>";
	        		resultXml += "<CELL>";
	        		resultXml += "<DATA1>" + xmlStrId + "</DATA1>";
	        		resultXml += "<DATA2>" + vo.deletePermission + "</DATA2>";
	        		resultXml += "<DATA3>" + vo.sendPermission + "</DATA3>";
	        		resultXml += "<DATA4>" + vo.managePermission + "</DATA4>";
	        		resultXml += "<DATA5>" + xmlStrname + "</DATA5>";
	        		resultXml += "<VALUE>" + xmlStrname + "(" + xmlStrId + ")" + "</VALUE>";
	        		resultXml += "</CELL>";
	        		resultXml += "<CELL></CELL>";
	        		resultXml += "</ROW>";
	        	})
	        	
	        	resultXml += "</ROWS></LISTVIEWDATA>";
	        	
	        	var listview = new ListView();
                listview.SetID("MsgToList");
                listview.SetSelectFlag(false);
                listview.SetMulSelectable(false);
	            listview.SetColgroup(['35%','']);
                listview.SetRowOnDblClick("DeleteReceiver");
                listview.DataSource(loadXMLString(resultXml));
                listview.RowDataBind();

                for (var i = 0; i < listview.GetRowCount() ; i++) {
                	var row = listview.GetDataRows()[i];
                	
//                 	row.style.whiteSpace = "nowrap";
                	row.childNodes[0].style.whiteSpace = "";
                	row.childNodes[0].style.overflow = "";
                	row.childNodes[0].style.textOverflow = "";
                    
                	var chk = document.createElement("input");
                	chk.setAttribute("type", "checkbox");
                	chk.setAttribute("id", "delete_" + row.getAttribute("DATA1"));
                	chk.setAttribute("name", "delete_" + row.getAttribute("DATA1"));
                	chk.style.marginLeft = "8px";
                	
                	if (row.getAttribute("DATA2") === "Y") {
                		chk.setAttribute("checked", true);
                	}
                	
                	var lbl = document.createElement("label");
                	lbl.setAttribute("for", "delete_" + row.getAttribute("DATA1"));
                	lbl.appendChild(document.createTextNode("<spring:message code='ezEmail.sharedMailbox16' />"));
                	lbl.style.cursor = "pointer";

                	row.childNodes[1].appendChild(chk);
                	row.childNodes[1].appendChild(lbl);
                	
                	chk = document.createElement("input");
                	chk.setAttribute("type", "checkbox");
                	chk.setAttribute("id", "send_" + row.getAttribute("DATA1"));
                	chk.setAttribute("name", "send_" + row.getAttribute("DATA1"));
                	chk.style.marginLeft = "8px";
                	
                	if (row.getAttribute("DATA3") === "Y") {
                		chk.setAttribute("checked", true);
                	}
                	
                	lbl = document.createElement("label");
                	lbl.setAttribute("for", "send_" + row.getAttribute("DATA1"));
                	lbl.appendChild(document.createTextNode("<spring:message code='ezEmail.sharedMailbox17' />"));
                	lbl.style.cursor = "pointer";

                	row.childNodes[1].appendChild(chk);
                	row.childNodes[1].appendChild(lbl);
                	
                	chk = document.createElement("input");
                	chk.setAttribute("type", "checkbox");
                	chk.setAttribute("id", "manage_" + row.getAttribute("DATA1"));
                	chk.setAttribute("name", "manage_" + row.getAttribute("DATA1"));
                	chk.style.marginLeft = "8px";
                	
                	if (row.getAttribute("DATA4") === "Y") {
                		chk.setAttribute("checked", true);
                	}
                	
                	lbl = document.createElement("label");
                	lbl.setAttribute("for", "manage_" + row.getAttribute("DATA1"));
                	lbl.appendChild(document.createTextNode("<spring:message code='ezEmail.sharedMailbox25' />"));
                	lbl.style.cursor = "pointer";

                	row.childNodes[1].appendChild(chk);
                	row.childNodes[1].appendChild(lbl);
                	row.childNodes[1].ondblclick = function() { event.cancelBubble = true; };
                }
	        }
	
	        function recevieListview(pID, pListView) {
	            var listview = new ListView();
	            listview.SetID(pID);
	            listview.SetSelectFlag(false);
	            listview.SetMulSelectable(true);
	            listview.SetRowOnDblClick("DeleteReceiver");
	            listview.SetColgroup(['35%','']);
	            listview.DataSource(loadXMLString("<LISTVIEWDATA></LISTVIEWDATA>"));
	            listview.DataBind(pListView);
	            listview.RowDataBind();
	        }
	
	        function RequestData(pNodeID, pTreeID) {
	            var TreeIdx = pNodeID;
	
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	
	            var deptID = treeNode.GetNodeData("CN");
	
	            GetDeptSubTreeInfo(deptID, TreeIdx);
	        }
	
	        function GetDeptSubTreeInfo(deptID, TreeIdx) {
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlRtn = createXmlDom();
	            var xmlpara = createXmlDom();
	
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
	            createNodeAndInsertText(xmlpara, objNode, "PROP", "mail;displayName");
	
	            xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
	            xmlHTTP.send(xmlpara);
	
	            xmlRtn = loadXMLString(xmlHTTP.responseText);
	
	            if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
	                if (CrossYN()) {
	                    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
	                }
	                else {
	                    xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
	                }
	            }
	
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	        }
	
	        function TreeViewNodeClick() {
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            nodeIdx = treeView.GetSelectNode();
        		document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:top;padding-right:3px;\" >" 
        		+ "<span id='spn_deptName' title='" + nodeIdx.GetNodeData("VALUE") + "'>" + nodeIdx.GetNodeData("VALUE") + "</span>"
        		+ "<span id='countInfo'></span>";
	            SelectDeptNM.setAttribute("countinfo", "")
	            displayUserList(nodeIdx.GetNodeData("CN"));
	        }
	
	        function displayUserList(DeptID) {
	        	listContentArry = new Array();
	        	
	        	$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	async : true,
		        	data : {deptID : DeptID, cell : "company;description;displayName;title;telephoneNumber", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;usertype", type : "user", adminOrgan : "y"},
		        	success : function(result){
		        		var resultXML = loadXMLString(result);
		        		var headerData = createXmlDom();
		        		
	                    // headerData = loadXMLString(result);
	
	                    if (CrossYN()) {
	                    	var xmlRtn = resultXML.documentElement;
	                        var xmlRtn2 = xmlRtn.getElementsByTagName("ROWS")[0];
	                        $(xmlRtn2.getElementsByTagName("ROW")).each(function(index){
				            	if($(this).find("DATA11").text() == "addJob"){
				            		var orgPosition = $(this).find("CELL").eq(3).find("VALUE").text();
				            		$(this).find("CELL").eq(0).find("DATA6").text("<spring:message code='ezOrgan.psb03'/>"+" "+orgPosition);
				            	}
				            });
	                        var Node = headerData.importNode(xmlRtn, true);
	                        headerData.appendChild(Node);
	                    }
	                    else {
	                        /* var xmlRtn = resultXML.documentElement.getElementsByTagName("ROWS")[0];
	                        headerData.documentElement.appendChild(xmlRtn); */
	                        var xmlRtn = resultXML.documentElement;
	                        headerData.appendChild(xmlRtn);
	                    }
	                    pListXML_Info = headerData;
	                    pSeach = false;
	                    DisplayUserImageList();
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t9' />" + error);
		        	}
		        });
	        	
	        	$.ajax({
					url : "/ezOrgan/getDeptMemberListCount.do",
					method : "POST",
					dataType : "json",
					data : {
						deptID : DeptID
					},
					success : function(result) {
						if (SelectDeptNM.getAttribute("countinfo") != "1" && !pSeach ) {
							var id = $("span[class=node_selected]").eq(0).closest("div").attr("id");
							var strIsLeaf = $("div#" + id + "").attr("isleaf");
							
							if (result.containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
			        			document.getElementById("countInfo").innerHTML += "-[<span class='txt_color'>" + result.totalCount + strLang1 + "</span>/<spring:message code='ezAddress.t362' /> <span class='txt_color'>" + result.totalCount2 + strLang1 + "</span>]";
							} else {
								document.getElementById("countInfo").innerHTML += "-[<span class='txt_color'>" + result.totalCount + strLang1 + "</span>]";
							}
							//2018-08-01 김보미 - 부서명 [사원수] 가 넘치는지 확인하는 함수
							deptNameLong(result.containLow, strIsLeaf);
										            	
			            	SelectDeptNM.setAttribute("countinfo","1")
			        	}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert(error);
					}
				});
	        	
	            listContentArry = new Array();
	            var xmlpara = createXmlDom();
	
	        }
	
	        function search_press() {
	            if (window.event.keyCode == "13") {
	                search_click();
	                event.cancelBubble = true;
	                event.returnValue = false;
	            }
	        }
	        
	        function search_click() {
	        	p_ListOrderObject = null;
	        	var searchKeyword = document.getElementById("keyword").value.trim();
	        	
	            if (searchKeyword == "") {
	                alert("<spring:message code='ezEmail.t10' />");
	                document.getElementById("keyword").value = searchKeyword;
	                document.getElementById("keyword").focus();
	                return;
	            }
				
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : true,
		        	data : {
		        		search : document.getElementById("search_type").value + "::" + encodeURIComponent(document.getElementById("keyword").value), 
		        		cell : "company;description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value, 
		        		prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;usertype", 
		        		type : "user"
		        	},
		        	success : function(result){	
		        		var headerData = createXmlDom();
	                    // headerData = loadXMLString(result);
						
	                    var xmlDom = loadXMLString(result);
	                    if (CrossYN()) {
	                    	var xmlRtn = xmlDom.documentElement;
	                        var xmlRtn2 = xmlRtn.getElementsByTagName("ROWS")[0];
	                        $(xmlRtn2.getElementsByTagName("ROW")).each(function(index){
				            	if($(this).find("DATA11").text() == "addJob"){
				            		var orgPosition = $(this).find("CELL").eq(3).find("VALUE").text();
				            		$(this).find("CELL").eq(0).find("DATA6").text("<spring:message code='ezOrgan.psb03'/>"+" "+orgPosition);
				            	}
				            });
	                        var Node = headerData.importNode(xmlRtn, true);
	                        headerData.appendChild(Node);
	                    }
	                    else {
	                        /* var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
	                        headerData.documentElement.appendChild(xmlRtn); */
	                    	var xmlRtn = xmlDom.documentElement;
	                        headerData.appendChild(xmlRtn);
	                    }
	                    pListXML_Info = headerData;
	                    pSeach = true;
	                    DisplayUserImageList();
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t9' />" + error);
		        	}
		        });
	            
	            var usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
	
		     	// 2021-04-09 김은실 - 검색 시 PressShiftKey = true 되는 현상(commit 6c23f8716 참조): 모든 search_click()에 적용. 
	            PressShiftKey = false;
	        }
	        
	        String.prototype.trim = function () {
	            return this.replace(/(^\s*)|(\s*$)/g, "");
	        }
	
	        function OK_Click() {
	        	var strName = document.getElementById("TextName").value.trim();
	        	var strId = document.getElementById("TextId").value.trim();
	        	
	            if (strName == "") {
	                alert("<spring:message code='ezEmail.sharedMailbox10' />");
	                document.getElementById("TextName").focus();
	                return;
	            }
	            
	            if (strId == "") {
	                alert("<spring:message code='ezEmail.sharedMailbox11' />");
	                document.getElementById("TextId").focus();
	                return;
	            }
	            
	            if (strName.indexOf("&") > -1 || strName.indexOf("<") > -1 || strName.indexOf(">") > -1 
		        		 || strName.indexOf("\"") > -1 || strName.indexOf("'") > -1) {
	           		alert("<spring:message code='ezEmail.sharedMailbox18' />: <spring:message code='ezEmail.kyj17' /> [ & < > \" ' ]");
	           		document.getElementById("TextName").focus();
		            return;
		        }
	            
	            var regex = /^[a-z0-9\_\-\.]+$/;
	            
	            if (!regex.test(strId)) {
	            	alert("<spring:message code='ezEmail.sharedMailbox12' />");
	            	document.getElementById("TextId").focus();
	            	return;
	            }
	            
	            if (shareId == "" && $("#selectDomain").val() == "") {
					alert("<spring:message code='ezEmail.multiDomain.ksa17' />");
					return;	
	            }
	            
	            if (shareId == "") {
		            if (document.getElementById("TextPassword").value == "") {
		            	alert("<spring:message code='ezOrgan.t229' />");
		                document.getElementById("TextPassword").focus();
		                return;
		            }

					var checkPw = checkPasswordPolicy({
						"pw" : document.getElementById('TextPassword').value,
						"chkCompanyId" : companyId
					});

		            if (!checkPw) {
						document.getElementById('TextPassword').focus();
						return;
					}
		            
		            if (document.getElementById('TextPassword').value !== document.getElementById('TextPassword2').value){
						alert("<spring:message code='ezOrgan.t230' />");
						document.getElementById('TextPassword2').focus();
						return;
					}
	            }
	            
	            var memberList = document.getElementById("ListViewMsgTo").children.item(0).children.item(1).children;
	            var memberListLength = memberList.length;
	            
	            var userList = [];
	            var userId, deletePermission, sendPermission, managePermission;
	            
	            for (var i = 0; i < memberListLength; i++) {
	            	userId = memberList.item(i).getAttribute("data1");
	            	
	            	if (document.getElementById("delete_" + userId).checked) {
	            		deletePermission = "Y";
	            	} else {
	            		deletePermission = "N";
	            	}
	            	
					if (document.getElementById("send_" + userId).checked) {
						sendPermission = "Y";
	            	} else {
	            		sendPermission = "N";
	            	}
	            	
					if (document.getElementById("manage_" + userId).checked) {
						managePermission = "Y";
	            	} else {
	            		managePermission = "N";
	            	}
					
					userList.push(userId + ":" + deletePermission + ":" + sendPermission + ":" + managePermission);
	            }
	            
	            if (shareId != "") {
	            	var sharedMailboxInfo = {
    	            	"shareId" : document.getElementById("TextId").value.trim(),
    	            	"shareName" : document.getElementById("TextName").value.trim(),
    	            	"compId" : companyId,
    	            	"userList" : userList
    	            };
	            	
	            	$.ajax({
			        	type : "POST",
			        	contentType: "application/json",
			        	dataType : "json",
			        	url : "/admin/ezEmail/modSharedMailbox.do",
			        	async : false,
			        	data : JSON.stringify(sharedMailboxInfo),
			        	success : function(result) {
			        		if (result.resultCode === "OK") {
			        			alert("<spring:message code='ezEmail.sharedMailbox14' />");
			        			
			        			if (ReturnFunction != null) {
				                    ReturnFunction(1);
				            	} else {
				                    window.returnValue = 1;
				            	}
				            	
				                window.close();
			        		} else if (result.resultCode === "NO_PERMISSION")  {
			        			alert("<spring:message code='ezOrgan.t302' />");
			        		} else {
			        			alert("<spring:message code='ezEmail.sharedMailbox07' />");
			        		}
			        	},
			        	error : function(error) {
			        		alert("<spring:message code='ezEmail.sharedMailbox07' />");
			        	}
			        });
	            } else {
	            	var sharedMailboxInfo = {
    	            	"shareId" : document.getElementById("TextId").value.trim(),
    	            	"shareName" : document.getElementById("TextName").value.trim(),
    	            	"password" : document.getElementById("TextPassword").value,
    	            	"compId" : companyId,
    	            	"userList" : userList,
    	            	"selectDomain" : selectDomain
    	            };
	            	
	            	$.ajax({
			        	type : "POST",
			        	contentType: "application/json",
			        	dataType : "json",
			        	url : "/admin/ezEmail/addSharedMailbox.do",
			        	async : false,
			        	data : JSON.stringify(sharedMailboxInfo),
			        	success : function(result) {
			        		if (result.resultCode === "OK") {
			        			alert("<spring:message code='ezEmail.sharedMailbox13' />");
			        			
			        			try {
				        			if (ReturnFunction != null) {
					                    ReturnFunction(1);
					            	} else {
					                    window.returnValue = 1;
					            	}
			        			} catch(e) {console.log(e);}
				            	
				                window.close();
			        		} else if (result.resultCode === "NO_PERMISSION")  {
			        			alert("<spring:message code='ezOrgan.t302' />");
			        		} else if (result.resultCode === "DUPLICATE") {
			        			alert("<spring:message code='ezEmail.sharedMailbox15' />");
			        		} else if (result.resultCode == "NO_LICENSE_KEY") {
 								alert("<spring:message code='ezOrgan.x0010' />");
 							} else if (result.resultCode == "INVALID_LICENSE_KEY") {
 								alert("<spring:message code='ezOrgan.x0011' />");
 							} else if (result.resultCode == "MAX_USER_REACHED") {
 								alert("<spring:message code='ezOrgan.x0012' />");
			        		} else if (result.resultCode == "ALIAS_EMAIL_DUPLICATE") { 	// 2021-12-16 이사라 : 에러코드 추가
			        			alert("<spring:message code='ezEmail.sharedMailbox15' />");
			        		} else if (result.resultCode == "EMAIL_DUPLICATE") { 		// 2021-12-16 이사라 : 에러코드 추가
			        			alert("<spring:message code='ezEmail.sharedMailbox15' />");
			        		} else {
			        			alert("<spring:message code='ezEmail.sharedMailbox07' />");
			        		}
			        	},
			        	error : function(error) {
			        		alert("<spring:message code='ezEmail.sharedMailbox07' />");
			        	}
			        });
	            }
	        }
	
	        var pSeach = false;
	        
	        function DisplayUserImageList() {
	            var xmlRtn = pListXML_Info;
	            document.getElementById("DeptUserImgList").innerHTML = "";
	            document.getElementById("txtlist_Layer").scrollTop = "0";
	            document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;
	            
	            while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
	                document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	            }
	            
	            while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
	                document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	            }
	            
	            var UserListHTML = "";

	            /*  if (SelectDeptNM.getAttribute("countinfo") != "1" && SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length && SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length != "") {
	                //SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	        		} else {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang1 + "</span>]";
	        		}
	                
	                SelectDeptNM.setAttribute("countinfo", "1")
	            } */
	            if (pListType == "IMG") {
	                document.getElementById("DeptUserImgList").style.display = "";
	                document.getElementById("txtlist_Layer").style.display = "none";
	                document.getElementById("txtlist_table").style.display = "none";
	                document.getElementById("Search_txtlist_table").style.display = "none";
	                
	                if (pSeach) {
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + "<spring:message code='ezEmail.t655' />" + "" + "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                    SelectDeptNM.setAttribute("countinfo", "1")
	                }
	            }
	            else {
	                document.getElementById("DeptUserImgList").style.display = "none";
	                document.getElementById("txtlist_Layer").style.display = "";
	                
	                if (!pSeach) {
	                    document.getElementById("txtlist_table").style.display = "";
	                    document.getElementById("Search_txtlist_table").style.display = "none";
	                }
	                else {
	                    document.getElementById("Search_txtlist_table").style.display = "";
	                    document.getElementById("txtlist_table").style.display = "none";
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + "<spring:message code='ezEmail.t655' />" + "" + "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                    SelectDeptNM.setAttribute("countinfo", "1")
	                }
	            }
	
	            for (var i = 0; i < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length; i++) {
	                if (pListType == "IMG") {
	                    var MainTable = document.createElement("TABLE");
	                    MainTable.setAttribute("class", pListType == "IMG" ? "organwrap" : "organwrap_list");
	                    MainTable.setAttribute("cellspacing", "0");
	                    MainTable.setAttribute("cellpadding", "0");
	                    
	                    if (pListType == "IMG") {
	                        MainTable.style.marginTop = "5px";
	                    }
	
	                    MainTable.style.marginLeft = "auto";
	                    MainTable.style.marginRight = "auto";
	                    var M_TR = document.createElement("TR");
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };
	                    M_TR.ondblclick = function () { event_listDBclick(this); };
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    }
	                    else {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                              SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
	                        }
	                    }
	
	                    var M_TR_TD = document.createElement("TD");
	                    M_TR_TD.setAttribute("class", "pictd");
	                    var M_TR_DIV = document.createElement("DIV");
	                    M_TR_DIV.setAttribute("class", "pic");
	                    
	                    if (M_TR.getAttribute("_DATA9") != "") {
	                        var M_TR_IMG = document.createElement("IMG");
	                        M_TR_IMG.setAttribute("SRC", "/admin/ezOrgan/getPersonalInfo.do?fileName=" + M_TR.getAttribute("_DATA9"));
	                        M_TR_IMG.setAttribute("width", "90px");
	                        M_TR_IMG.setAttribute("height", "90px");
	                        M_TR_DIV.appendChild(M_TR_IMG);
	                    }
	                    
	                    M_TR_TD.appendChild(M_TR_DIV);
	                    M_TR.appendChild(M_TR_TD);
	
	                    var M_TR_TD2 = document.createElement("TD");
	                    M_TR_TD2.style.width = "300px";
	
	                    var M_TR_TDS_Table = document.createElement("TABLE");
	                    M_TR_TDS_Table.setAttribute("class", "organinfo");
	                    M_TR_TD2.appendChild(M_TR_TDS_Table);
	
	                    var Sub_TR1 = document.createElement("TR");
	                    var Sub_TD1 = document.createElement("TD");
	                    Sub_TD1.style.textAlign = "left";
	                    Sub_TD1.setAttribute("class", "name");
	                    var pDisplayName = "";
	                    pDisplayName += M_TR.getAttribute("_DATA4") == "" ? "" : M_TR.getAttribute("_DATA4");
	                    pDisplayName += M_TR.getAttribute("_DATA6") == "" ? "" : "[" + M_TR.getAttribute("_DATA6") + "]";
	                    Sub_TD1.innerHTML = pDisplayName;
	                    Sub_TR1.appendChild(Sub_TD1);
	
	                    var Sub_TR2 = document.createElement("TR");
	                    var Sub_TD2 = document.createElement("TD");
	                    Sub_TD2.style.textAlign = "left";
	                    Sub_TD2.innerHTML = M_TR.getAttribute("_DATA5");
	                    Sub_TR2.appendChild(Sub_TD2);
	
	                    var Sub_TR3 = document.createElement("TR");
	                    var Sub_TD3 = document.createElement("TD");
	                    Sub_TD3.style.textAlign = "left";
	                    var Sub_TD3_Img = document.createElement("IMG");
	                    Sub_TD3_Img.setAttribute("class", "icon");
	                    Sub_TD3_Img.setAttribute("src", "/images/OrganTree/icon_hp.gif");
	                    Sub_TD3.appendChild(Sub_TD3_Img);
	                    Sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
	                    Sub_TR3.appendChild(Sub_TD3);
	
	                    var Sub_TR4 = document.createElement("TR");
	                    var Sub_TD4 = document.createElement("TD");
	                    Sub_TD4.style.textAlign = "left";
	                    var Sub_TD4_Img = document.createElement("IMG");
	                    Sub_TD4_Img.setAttribute("class", "icon");
	                    Sub_TD4_Img.setAttribute("src", "/images/OrganTree/icon_mail.gif");
	                    Sub_TD4.appendChild(Sub_TD4_Img);
	                    Sub_TD4.innerHTML += M_TR.getAttribute("_DATA3")
	                    Sub_TR4.appendChild(Sub_TD4);
	
	                    M_TR_TDS_Table.appendChild(Sub_TR1);
	                    M_TR_TDS_Table.appendChild(Sub_TR2);
	                    M_TR_TDS_Table.appendChild(Sub_TR3);
	                    M_TR_TDS_Table.appendChild(Sub_TR4);
	
	                    M_TR.appendChild(M_TR_TD2);
	                    MainTable.appendChild(M_TR);
	                    document.getElementById("DeptUserImgList").appendChild(MainTable);
	                }
	                else {
	                    var M_TR = document.createElement("TR");
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };
	                    M_TR.ondblclick = function () { event_listDBclick(this); };
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    }
	                    else {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                              SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
	                        }
	                    }
	
	                    if (pSeach) {
	                        var M_TR_TD1 = document.createElement("TD");
	                        M_TR_TD1.style.overflow = "hidden";
	                        M_TR_TD1.style.textOverflow = "ellipsis";
	                        M_TR_TD1.style.whiteSpace = "nowrap";
	                        M_TR_TD1.style.width = "110px";
	                        M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA5");
	
	                        var M_TR_TD2 = document.createElement("TD");
	                        M_TR_TD2.style.overflow = "hidden";
	                        M_TR_TD2.style.textOverflow = "ellipsis";
	                        M_TR_TD2.style.whiteSpace = "nowrap";
	                        M_TR_TD2.style.width = "90px";
	                        M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");
	
	                        var M_TR_TD3 = document.createElement("TD");
	                        M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	                        M_TR_TD3.style.width = "80px";
	
	                        var M_TR_TD4 = document.createElement("TD");
	                        M_TR_TD4.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
	
	                        M_TR.appendChild(M_TR_TD1);
	                        M_TR.appendChild(M_TR_TD2);
	                        M_TR.appendChild(M_TR_TD3);
	                        M_TR.appendChild(M_TR_TD4);
	                        document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                    }
	                    else {
	                        var M_TR_TD1 = document.createElement("TD");
	                        M_TR_TD1.style.overflow = "hidden";
	                        M_TR_TD1.style.textOverflow = "ellipsis";
	                        M_TR_TD1.style.whiteSpace = "nowrap";
	                        M_TR_TD1.style.width = "150px";
	                        M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
	
	                        var M_TR_TD2 = document.createElement("TD");
	                        M_TR_TD2.style.width = "80px";
	                        M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	
	                        var M_TR_TD3 = document.createElement("TD");
	                        M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
	
	                        M_TR.appendChild(M_TR_TD1);
	                        M_TR.appendChild(M_TR_TD2);
	                        M_TR.appendChild(M_TR_TD3);
	                        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                    }
	                }
	
	            }
	        }
	
	        var m_strColorSelect = "#edf4fd";
	        var m_strColorOver = "#f4f5f5";
	        var m_strColorDefault = "#ffffff";
	        var p_ListOrderObject = null;
	        
	        function event_listMover(obj) {
	            for (var i = 0; i < listContentArry.length; i++) {
	                if (document.getElementById(listContentArry[i]) == obj) {
	                    return;
	                }
	            }
	            if (p_ListOrderObject != obj) {
	                for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	                    obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
	                }
	            }
	        }
	        
	        function event_listMout(obj) {
	
	            for (var i = 0; i < listContentArry.length; i++) {
	                if (document.getElementById(listContentArry[i]) == obj) {
	                    return;
	                }
	            }
	            if (p_ListOrderObject != obj) {
	                for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	                    obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                }
	            }
	        }
	        
	        var PressShiftKey = false;
	        var PressCtrlKey = false;
	        
	        function event_listOnkeyUp(event) {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (!event) event = window.event;
	            }
	            
	            switch (event.keyCode) {
	                case 16: PressShiftKey = false; break;
	                case 17: PressCtrlKey = false; break;
	                case 46: deleteWork(false); break;
	            }
	        }
	
	        function event_listOnkeyDown(event) {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (!event) event = window.event;
	            }
	            
	            switch (event.keyCode) {
	                case 16: PressShiftKey = true; break;
	                case 17: PressCtrlKey = true; break;
	            }
	        }
	
	        var listContentArry = new Array();
	        var listSubContentArry = new Array();
	        var listEventCheckbox = false;
	        var listSubEventCheckbox = false;
	        
	        function event_listclick(obj) {
	            if (!listEventCheckbox) {
	                if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                        
	                        if (p_ListOrderObject != null) {
		                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                        }
	                        }	
	                    }
	                    
	                    listContentArry = new Array();
	                }
	                
	                if (PressShiftKey) {
	                    var SelectedPreObj = null;
	                    
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                        if (Cnt == 0) {
	                            SelectedPreObj = p_ListOrderObject;
	                        }
	
	                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                        }
	                    }
	                    
	                    listContentArry = new Array();
	                    
	                    if (p_ListOrderObject == null) {
	                        return;
	                    }
	
	                    var PrelistContent;
	                    
	                    if (SelectedPreObj == null) {
	                        PrelistContent = p_ListOrderObject.getAttribute("id");
	                    } else {
	                        PrelistContent = SelectedPreObj.getAttribute("id");
	                    }
	
	                    p_ListOrderObject = obj;
	
	                    var CurlistContent = obj.getAttribute("id");
	                    var PrePoint = parseInt(PrelistContent.replace("MailUserlist_", ""));
	                    var CurPoint = parseInt(CurlistContent.replace("MailUserlist_", ""));
	                    if (PrePoint < CurPoint) {
	
	                        for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
	                            p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
	                            
	                            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                            }
	                            
	                            listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                        }
	
	                    } else if (PrePoint > CurPoint) {
	                        for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
	                            p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
	                            
	                            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                            }
	                            
	                            listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                        }
	                    } else {
	                        return;
	                    }
	                }
	                else {
	                    p_ListOrderObject = obj;
	                    var insertFlag = true;
	                    
	                    for (var i = 0; i < listContentArry.length; i++) {
	                        if (listContentArry[i] == p_ListOrderObject.getAttribute("id")) {
	                            insertFlag = false;
	                            
	                            if (PressCtrlKey) {
	                                listContentArry.splice(i, 1);
	                                
	                                for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                                    p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                                }
	                                
	                                if (listContentArry.length == 0) {
	                                    p_ListOrderObject = "";
	                                }
	                            }
	                        }
	                    }
	                    
	                    if (insertFlag) {
	                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                        }
	
	                        listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                    }
	                }
	            }
	            else {
	                listEventCheckbox = false;
	            }
	        }
	
	        function event_listDBclick(obj) {
	            InsertReceiver("MsgToList");
	        }
	
	        function ListTypeChangeIcon() {
	            if (pListType == "IMG") {
	                document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_onimglist.gif");
	                document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_list.gif");
	            }
	            else {
	                document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_imglist.gif");
	                document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_onlist.gif");
	            }
	        }
	
	        function ChangeListView_onClick(Div) {
	            pListType = Div;
	            ListTypeChangeIcon();
	            DisplayUserImageList();
	            setOrganListType(pListType);
	        }
	
	        function keyword_Clear() {
	            document.getElementsByName('keyword').value = "";
	        }
	
	        function InsertReceiver(pListView) {
	            var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strSIP = "";
	            var pAddFlag = false;
	
	            var listid = "MsgToList";
	            var getlistview = new ListView();
	            getlistview.LoadFromID(listid);
	
	            var arrRows = getlistview.GetSelectedRows();
	            var length = arrRows.length;
				
                if (listContentArry != "") {
                    for (var i = 0; i < listContentArry.length; i++) {
                        var strId = document.getElementById(listContentArry[i]).getAttribute("_data2");
                        var strName = document.getElementById(listContentArry[i]).getAttribute("_data4");
                        var bFlag = getlistview.ExistRow("data1", strId);

                        if (bFlag) {
                            pAddFlag = true;
                        } else {
                        	var xmlStringName = MakeXMLString(strName);
                        	var printval = xmlStringName + "(" + strId + ")";
                            pparsingXML2 = "";
                            pparsingXML = "";
                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1><DATA2>Y</DATA2><DATA3>Y</DATA3><DATA5>" + xmlStringName + "</DATA5>";
                            pparsingXML = pparsingXML + "<VALUE>" + printval + "</VALUE></CELL><CELL></CELL></ROW>";
                            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
                            Resultxml = loadXMLString(pparsingXML2);

                            var listview = new ListView();
                            listview.LoadFromID(listid);

                            var MaxID = 0;
                            var InitTr = listview.GetDataRows();
                            var MaxCntNum = 0;

                            for (var j = 0  ; j < InitTr.length  ; j++) {
                                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                                if (MaxID < curnum) {
                                    MaxID = curnum;
                                    MaxCntNum = j;
                                }
                            }

                            var objTr = listview.AddRow(InitTr.length);
                            
                            if (MaxCntNum != 0) {
                                MaxCntNum = MaxCntNum + 1;
                            }
                            
                            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + (MaxID + 1));
                            listview.AddDataRow(objTr, Resultxml);
                            
                            objTr.childNodes[0].style.whiteSpace = "";
                            objTr.childNodes[0].style.overflow = "";
                            objTr.childNodes[0].style.textOverflow = "";
                            
                        	var chk = document.createElement("input");
                        	chk.setAttribute("type", "checkbox");
                        	chk.setAttribute("id", "delete_" + objTr.getAttribute("DATA1"));
                        	chk.setAttribute("name", "delete_" + objTr.getAttribute("DATA1"));
                        	chk.setAttribute("checked", true);
                        	chk.style.marginLeft = "8px";
                        	
                        	var lbl = document.createElement("label");
                        	lbl.setAttribute("for", "delete_" + objTr.getAttribute("DATA1"));
                        	lbl.appendChild(document.createTextNode("<spring:message code='ezEmail.sharedMailbox16' />"));
                        	lbl.style.cursor = "pointer";

                        	objTr.childNodes[1].appendChild(chk);
                        	objTr.childNodes[1].appendChild(lbl);
                        	
                        	chk = document.createElement("input");
                        	chk.setAttribute("type", "checkbox");
                        	chk.setAttribute("id", "send_" + objTr.getAttribute("DATA1"));
                        	chk.setAttribute("name", "send_" + objTr.getAttribute("DATA1"));
                        	chk.setAttribute("checked", true);
                        	chk.style.marginLeft = "8px";
                        	
                        	lbl = document.createElement("label");
                        	lbl.setAttribute("for", "send_" + objTr.getAttribute("DATA1"));
                        	lbl.appendChild(document.createTextNode("<spring:message code='ezEmail.sharedMailbox17' />"));
                        	lbl.style.cursor = "pointer";

                        	objTr.childNodes[1].appendChild(chk);
                        	objTr.childNodes[1].appendChild(lbl);
                        	
                        	chk = document.createElement("input");
                        	chk.setAttribute("type", "checkbox");
                        	chk.setAttribute("id", "manage_" + objTr.getAttribute("DATA1"));
                        	chk.setAttribute("name", "manage_" + objTr.getAttribute("DATA1"));
                        	chk.style.marginLeft = "8px";
                        	
                        	lbl = document.createElement("label");
                        	lbl.setAttribute("for", "manage_" + objTr.getAttribute("DATA1"));
                        	lbl.appendChild(document.createTextNode("<spring:message code='ezEmail.sharedMailbox25' />"));
                        	lbl.style.cursor = "pointer";

                        	objTr.childNodes[1].appendChild(chk);
                        	objTr.childNodes[1].appendChild(lbl);
                        	objTr.childNodes[1].ondblclick = function() { event.cancelBubble = true; };
                        }
                    }
                }
	        }
	
	        function CheckMailReceiver(selRow, option) {
	            var rtnValue = false;
	            var email;
	            
	            if (option == "1") {
	                email = selRow.cells[0].DATA3;
	            } else if (option == "2") {
	                email = selRow.cells[0].DATA2;
	            } else if (option == "3") {
	                email = selRow;
	            }
	
	            var _listview = new ListView();
	            _listview.LoadFromID("MsgToList");
	            var arrRows = _listview.GetDataRows();
	            
	            for (count2 = 0; count2 < arrRows.length; count2++) {
	                if (email == arrRows[count2].getAttribute("data1")) {
	                    rtnValue = true;
	                }
	            }
	            
	            return rtnValue
	        }
	
	        function DeleteReceiver(pListView) {
	            var listid = "MsgToList";
	            var selList = new ListView();
	            selList.LoadFromID(listid);
	
	            var arrRows = selList.GetSelectedRows();
	            var strName = "";
	
	            for (var i = 0; i < arrRows.length; i++) {
	                selList.DeleteRow(arrRows[i].id);
	            }
	        }
			
	        function orgTabButton_onClick() {
	        	methodForTabAction(1);
		        selTab = "orglistView";
		        selSpan = "orgSpan";
		        m_tabDialogState["org"] = "select";
		        ImageUpdate();
		        TreeViewTD.style.display = "block";
		        m_selectedTree = orglistView;
		    }
	        
	        function event_listdragend(evt) {
                evt.stopPropagation();
                evt.preventDefault();
                
                if (dropelement != "") {
                    InsertReceiver(document.getElementById(dropelement));
                }
            }
            
            function event_listdragstart(obj) {
                dropelement = "";
                var islist = false;
                
                if (m_selectedTree == orglistView) {
                    for (var i = 0; i < listContentArry.length; i++) {
                        if (listContentArry[i] == obj.getAttribute("id")) {
                            islist = true;
                            break;
                        }
                    }
                    
                    if (!islist) {
                        event_listclick(obj);
                    }
                }
            }
            
	        function ImageUpdate() {
	            return (navigator.userAgent.indexOf('Firefox') != -1) ?
	                (function () {
	                    orgTabButton.setAttribute('src', m_orgImg[m_tabDialogState["org"]]);
	                }).call(this)
	                : (CrossYN()) ?
	                (function () {
	                    orgTabButton.setAttribute('src', m_orgImg[m_tabDialogState["org"]]);
	                }).call(this)
	                :
	                (function () {
	                    orgTabButton.src = m_orgImg[m_tabDialogState["org"]];
	                }).call(this)
	            ;
	        }
	        
	        function infoview_click() {
	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert("<spring:message code='ezEmail.t579' />");
	                return;
	            }
	            
	            var id = p_ListOrderObject.getAttribute("_DATA2");
	            //var dept = p_ListOrderObject.getAttribute("_DATA13");
	            var dept = p_ListOrderObject.getAttribute("_DATA10");
	            var rtn
	            var width = 420, height = 450;
	            var leftPosition, topPosition;
	            leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
	            topPosition = (window.screen.height / 2) - ((height / 2) + 50);
	
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	        
	        function onDragEnter(evt, obj) {
                evt.stopPropagation();
                evt.preventDefault();
                evt.dataTransfer.dropEffect = "copy";
                evt.dataTransfer.effectAllowed = "copy";
                dropelement = obj.id;
            }
	        
            function onDrop(evt, element) {
                evt.stopPropagation();
                evt.preventDefault();
                InsertReceiver(element);
            }
            
	        function setOrganListType(pListType) {
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/setListType.do",
	        		async : false,
	        		data : {
	        			listType : pListType
	        		},
	        		success : function(result) {
	        			
	        		}
	        	})
	        }
	        
	        function getOrganListType() {
	        	var organListType = "TXT";
	        	
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/getListType.do",
	        		async : false,
	        		success : function(result) {
	        			organListType = result;
	        		}
	        	})
	        	
	        	return organListType;
	        }
	        
	        function methodForTabAction(target) {
            	var tab1 = document.getElementById("orgTabButton").children[0];
            	
            	if (target == 1) {
            		tab1.className = "tabon";
            	}
	        }
	        
		    //2018-08-01 김보미 - 부서명 [사원수] 길이가 길면 조정하는 함수
	        function deptNameLong(containLow, strIsLeaf) {
	        	var deptNameWidth = "";
	        	var sum = $("#spn_deptName").width() + $("#countInfo").width();
	        	
	          	if (containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
	          		if (sum > 366) {
	          			deptNameWidth = 367 - $("#countInfo").width();
	          		}
	          	} else {
	          		if (sum > 364) {
	          			deptNameWidth = 365 - $("#countInfo").width();
	          		}
	          	}
	        	
	        	$("#spn_deptName").css("width", deptNameWidth);
	        }
		    
	        /* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
	        function tabover(tabObj) {
	        	tabObj.setAttribute("class", "tabon");
	        }
	        
	        function tabout(tabObj) {
	        	if (tabObj.id != selSpan) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	        
	        function popupClose() {
// 	        	if (shareId != "") {
// 	        		if (confirm("<spring:message code='ezEmail.lhm16' />")) {
// 		        		return OK_Click();
// 		        	}
// 	        	}
	        	
	        	window.close();
	        }
	        
	        $(document).on("change", "#selectDomain", function() {
				var mailDomain = "@" + $(this).val();
	        	$("#mailDomain").text(mailDomain);
	        	
	        	selectDomain = $(this).val();
	        });
    	</script>
	</head>
	<body class="popup" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);" style="overflow:hidden">
		<div id="menu">
			<ul>
				<li><span onclick="return OK_Click()"><spring:message code='ezEmail.t48' /></span></li>
			</ul>
		</div>
		<div id="close">
			<ul>
				<li><span onclick="popupClose()"></span></li>
			</ul>
		</div>
		
		<table class="content">
			<tr>
				<th><spring:message code='ezEmail.sharedMailbox18' /></th>
				<td style="width:60%"><input id="TextName" name="TextName" type="text" maxlength="24" class="txtClass" tabindex="1" style="width:100%"></td>
				<th><spring:message code='ezEmail.lhm64' /></th>
				<td style="width:40%"><input id="TextPassword" name="TextPassword" type="password" maxlength="24" class="txtClass" tabindex="3" style="width:100%"></td>
			</tr>
			<tr>
				<th><spring:message code='ezEmail.sharedMailbox19' /></th>
				<td style="width:60%">
					<input id="TextId" name="TextId" type="text" maxlength="20" class="txtClass" tabindex="2" style="ime-mode: disabled; width:40%;">
					<span id="mailDomain" style="font-weight: bold;display:none;">@${mailDomain}</span>
					<c:if test="${empty shareId}">
						<span style="font-weight: bold; ">@</span>
						<select id="selectDomain" style="width: 220px; ">
							<c:forEach var="item" items="${domainList}">
								<option value="<c:out value='${item}'/>" ${item eq companyMailDomain ? 'selected' : ''}><c:out value='${item}'/></option>
							</c:forEach>
						</select>
					</c:if>
				</td>
				<th><spring:message code='ezEmail.lhm61' /></th>
				<td style="width:40%"><input id="TextPassword2" name="TextPassword2" type="password" maxlength="24" class="txtClass" tabindex="4" style="width:100%"></td>
			</tr>
			<c:if test="${!empty shareId}">
				<tr>
					<th><spring:message code='main.t78' /></th>
					<td style="width:100%" colspan="3">
						${sharedMailboxMail}
					</td>
				</tr>
			</c:if>
		</table>
		
	    <table style="width:100%;margin-top:10px">
	        <tr>
	            <td style="vertical-align: top;">
	            	<div class="portlet_tabpart01" style="margin:0px;">
	            		<div class="portlet_tabpart01_top" id="tab1" style="margin-bottom:3px;">
	            			<p id="orgTabButton">
	            				<span id="orgSpan" onclick="orgTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t591' /></span>
	            			</p>
	            		</div>
            		</div>
	                <table id="TreeViewTD">
	                    <tr>
	                        <td>
	                            <div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
	                                <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2;">
	                                    <table style="margin-top: 3px; width: 100%;">
	                                        <tr>
	                                            <td>
	                                                <div style="margin-left: 5px;">
	                                                    <select id="search_type">
	                                                        <option selected value="displayname" usedefault="1"><spring:message code='ezEmail.t31' /></option>
	                                                        <option value="description" usedefault="1"><spring:message code='ezEmail.t26' /></option>
	                                                        <option value="title" usedefault="1"><spring:message code='ezEmail.t28' /></option>
	                                                        <option value="extensionAttribute10" usedefault="1"><spring:message code='ezEmail.t281' /></option>
	                                                        <option value="telephonenumber" usedefault="1"><spring:message code='ezEmail.t99000045' /></option>
	                                                        <option value="mobile" usedefault="0"><spring:message code='ezEmail.t99000046' /></option>
	                                                        <option value="HomePhone" usedefault="0"><spring:message code='ezEmail.t29' /></option>
	                                                        <option value="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezEmail.t99000047' /></option>
	                                                        <option value="mail" usedefault="0"><spring:message code='ezEmail.t99000048' /></option>
	                                                        <option value="streetAddress" usedefault="0" style="display:none"><spring:message code='ezEmail.t99000049' /></option>
	                                                    </select>
	                                                    <input id="keyword" value="" onkeypress="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;height:22px">
	                                                    <a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezEmail.t37' /></span></a>
	                                                </div>
	                                            </td>
	                                            <td>
	                                                <div style="float: right; margin-right: 5px; position: relative;">
	                                                    <a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezEmail.t597' /></span></a>
	                                                </div>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </div>
	                            </div>
	                            <table style="margin-top: 3px;">
	                                <tr>
	                                    <td class="box" style="border-right:0px">
	                                        <div style="width: 220px; height: 445px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
	                                    </td>
	                                    <td></td>
	                                    <td class="listview" style="width: 432px" id="orglistView">
	                                        <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
	                                            <tr>
	                                                <th style="white-space:normal">
														<span id="SelectDeptNM" style="font-weight: normal; width: 386px; height: 18px; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
	                                                    <span style="float:right; position: relative;">
	                                                        <span onclick="ChangeListView_onClick('TXT');">
	                                                            <img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                                        <span onclick="ChangeListView_onClick('IMG');">
	                                                            <img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                                    </span>
	                                                </th>
	                                            </tr>
	                                        </table>
	                                        <div style="vertical-align: top; height: 410px; overflow: auto; width: 446px;" id="txtlist_Layer">
	                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 150px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t31' /></td>
	                                                    <td style="width: 130px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t28' /></td>
	                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezEmail.t99000045' /></td>
	                                                </tr>
	                                            </table>
	                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 110px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t26' /></td>
	                                                    <td style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t31' /></td>
	                                                    <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t28' /></td>
	                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezEmail.t99000045' /></td>
	                                                </tr>
	                                            </table>
	                                        </div>
	                                        <div style="vertical-align: top; text-align: center; height: 410px; overflow: auto; display: none; width: 446px;" id="DeptUserImgList"></div>
	                                        <div id="tblPageRayer2"  style="text-align:center;"></div>
	                                	</td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	            <td style="vertical-align: top;">
	                <table id="listType1">
	                    <tr id="ListMsgTo">
	                        <td style="width: 30px; text-align: center;">
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0"
	                                style="cursor: pointer;" onclick="InsertReceiver(ListViewMsgTo)"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0"
	                                style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgTo)">
	                        </td>
	                        <td style="vertical-align: top;">
	                            <h2 id="ToTitle" class="receiver_tltype01" style="margin-top:1px;">
	                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezEmail.sharedMailbox06' /></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="ListViewMsgTo" ondragover ="onDragEnter(event, this)" ondrop ="onDrop(event, this)" style="width: 360px; Height: 502px; overflow-x: auto; overflow-y: auto;" ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
