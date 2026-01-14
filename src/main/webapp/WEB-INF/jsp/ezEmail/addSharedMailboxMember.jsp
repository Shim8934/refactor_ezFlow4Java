<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.sharedMailboxPYY03' /></title>
	    <link rel="stylesheet" href="${util.addVer('ezEmail.e1', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('main.lhm01', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
   	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/ListView_list.js')}"></script>
        <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
        <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <style>
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
	    	.countColor {
	    		color:#017BEC;
	    	}
            .checkDept {
                height: 16px !important;
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
	        var m_tabDialogState = {"org": "select",  "contact": "normal", "dl": "normal", 
	        		"orgJobMst1": "normal", "orgJobMst2": "normal" };
	        var selSpan = "";
	        var selectDomain = "${companyMailDomain}";
	        var sharedMailbox_Mail = "${sharedMailboxMail}";
	        var mailboxId = "${mailboxId}";
	        var userInfo = new Array();
	        var sharer = "${sharer}";
	        var useShowAllCompanies = "${useShowAllCompanies}";
	        var useOrgListCheckBox = JSON.parse("${useOrgListCheckBox}");
	        var m_selectedTree = null;
	    	var receiverListId = "MsgToList";
	    	var emailAttrArr = {
	    		"OrganListView":"_data3",
	    		"AddressListView":"data3"
	         };
	    	var page = 1;
	        var CurPage = "1";
	        var pagecount;
	        var receiverCount = 0;
	        var selectedDept = "";
	        var useShowAllCompanies = "${useShowAllCompanies}";
            var EventCheck = false;

	        window.onunload = function () {
		        if(ReturnFunction != null)
			        ReturnFunction(EventCheck);
			};
			var ReturnFunction;
	        window.onload = function () {
	            try {
	                ReturnFunction = opener.sharedMailboxDialogArguments[1];
	            } catch (e) {
	            }
	            orgTabButton_onClick(1);

	            if (useOrgListCheckBox) { // table header에 체크박스 td 추가
	            	// ####### 조직도
	            	var addTD = document.createElement("TD");
					addTD.style.cssText = "width: 15px; color:#333;background-color: #f8f8fa; padding:5px; ";
					addTD.innerHTML = "<input type='checkbox' class='checkAll'>";  
					
					$("#txtlist_table tr:first-child").prepend(addTD.cloneNode(true));
					$("#Search_txtlist_table tr:first-child").prepend(addTD.cloneNode(true));
					
	            }
            	$.ajax({
	    			url: "/ezEmail/getShareMailBoxMember.do",
	    			type: "POST",
	    			async: false,
	    			dataType: 'json',
	    			data: {'mailboxId' : mailboxId ,"compId" : companyId, "sharer" : sharer},
	    			success: function(result) {
	    				if (result.resultCode === "OK") {
	    					userInfo = result;
	    					initSharedMailboxMemberInfo(userInfo);
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
	            
	            ChangeListView_onClick(getOrganListType());
	            
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
	
	        function initSharedMailboxMemberInfo(sharedMailboxInfo) {
	        	
	        	var userList = sharedMailboxInfo.result;
	        	var resultXml = "<LISTVIEWDATA><ROWS>";
	        	var xmlStrId = "";
	        	for(var i=0; i <userList.length ; i++ ){
	        		var vo = userList[i];
	        		xmlStrId = MakeXMLString(vo.CN);
	        		var xmlStrname = MakeXMLString(vo.USER_NAME);
	        		var dept = MakeXMLString(vo.DEPT);
	        		var company = MakeXMLString(vo.COMPANY);
	        		resultXml += "<ROW>";
	        		resultXml += "<CELL>";
	        		resultXml += "<DATA1>" + xmlStrId + "</DATA1>";
	        		//voc 176234 회사명 삭제
	        		resultXml += "<VALUE>" + xmlStrname + "(" + dept + ")" + "</VALUE>";
	        		resultXml += "<TITLE>" + xmlStrId + "</TITLE>";
	        		resultXml += "</CELL>";
	        		resultXml += "</ROW>";
	        	}
	        	
	        	resultXml += "</ROWS></LISTVIEWDATA>";
				
	        	
	        	var listview = new ListView();
				
                listview.SetID("MsgToList");
                listview.SetSelectFlag(false);
                listview.SetMulSelectable(false);
                // voc 176553 더블클릭으로 제거하면 deleteReceiver가 두번 호출되서 함수 부여하는 부분 하나 주석
                // listview.SetRowOnDblClick("DeleteReceiver");
                listview.DataSource(loadXMLString(resultXml));
                listview.RowDataBind();

                for (var i = 0; i < listview.GetRowCount() ; i++) {
                	var row = listview.GetDataRows()[i];
                	row.childNodes[0].style.whiteSpace = "";
                	row.childNodes[0].style.overflow = "";
                	row.childNodes[0].style.textOverflow = "";
                }
	        }
	
	        function recevieListview(pID, pListView) {
	            var listview = new ListView();
	            listview.SetID(pID);
	            listview.SetSelectFlag(false);
	            listview.SetMulSelectable(true);
	            listview.SetRowOnDblClick("DeleteReceiver");
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
	            treeView.SetUseCheckBox(useOrgListCheckBox);
	            var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
	            treeView.SetConfig(treeXML);
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	        }
	
	        function TreeViewNodeClick() {
	        	CurPage = "1";
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            nodeIdx = treeView.GetSelectNode();
        		document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:top;padding-right:3px;\" >" 
        		+ "<span id='spn_deptName' title='" + nodeIdx.GetNodeData("VALUE") + "'>" + nodeIdx.GetNodeData("VALUE") + "</span>"
        		+ "<span id='countInfo'></span>";
	            SelectDeptNM.setAttribute("countinfo", "")
	            displayUserList(nodeIdx.GetNodeData("CN"));
	            selectedDept = nodeIdx.GetNodeData("CN");
	        }
	
	        function displayUserList(DeptID) {
	        	listContentArry = new Array();
	        	if (DeptID == undefined && selectedDept != ""){
	        		DeptID = selectedDept;
	        	}
	        	$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	async : true,
		        	data : {deptID : DeptID, cell : "company;description;displayName;title;telephoneNumber" 
		        		, prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;usertype"
		        		, page: CurPage,  type : "user"},
		        	success : function(result){
		        		var resultXML = loadXMLString(result);
		        		var headerData = createXmlDom();
		        		
	                    // headerData = loadXMLString(result);
	
// 	                    if (CrossYN()) {
// 	                    	var xmlRtn = resultXML.documentElement;
// 	                        var xmlRtn2 = xmlRtn.getElementsByTagName("ROWS")[0];
// 	                        $(xmlRtn2.getElementsByTagName("ROW")).each(function(index){
// 				            	if($(this).find("DATA11").text() == "addJob"){
// 				            		var orgPosition = $(this).find("CELL").eq(3).find("VALUE").text();
// 				            		$(this).find("CELL").eq(0).find("DATA6").text("<spring:message code='ezOrgan.psb03'/>"+" "+orgPosition);
// 				            	}
// 				            });
// 	                        var Node = headerData.importNode(xmlRtn, true);
// 	                        headerData.appendChild(Node);
// 	                    }
// 	                    else {
// 	                        /* var xmlRtn = resultXML.documentElement.getElementsByTagName("ROWS")[0];
// 	                        headerData.documentElement.appendChild(xmlRtn); */
// 	                        var xmlRtn = resultXML.documentElement;
// 	                        headerData.appendChild(xmlRtn);
// 	                    }
	                    pListXML_Info = loadXMLString(result);
	                    pSeach = false;
	                    DisplayUserImageList();
	                    makePageSelPage2();
		                changeCheckBox();
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
			        			document.getElementById("countInfo").innerHTML += "-[<span class='countColor'>" + result.totalCount + strLang1 + "</span>/<spring:message code='ezAddress.t362' /> <span class='countColor'>" + result.totalCount2 + strLang1 + "</span>]";
							} else {
								document.getElementById("countInfo").innerHTML += "-[<span class='countColor'>" + result.totalCount + strLang1 + "</span>]";
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
		        		search : document.getElementById("search_type").value + "::" + document.getElementById("keyword").value, 
                        <c:if test="${useShowAllCompanies eq 'YES'}">
                        company : "",
                        </c:if>
		        		page : CurPage,
		        		cell : "description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value, 
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
	
	        }
	        
	        String.prototype.trim = function () {
	            return this.replace(/(^\s*)|(\s*$)/g, "");
	        }
	
	        function OK_Click() {
	            var memberList = document.getElementById("ListViewMsgTo").children.item(0).children.item(1).children;
	            var memberListLength = memberList.length;
	            
	            var userList = [];
	            var userId, deletePermission, sendPermission, managePermission;
	            
	            for (var i = 0; i < memberListLength; i++) {
	            	userId = memberList.item(i).getAttribute("data1");
					userList.push(userId);
	            }
	            
            	var sharedMailboxInfo = {
   	            	"mailboxId" : mailboxId,
   	            	"userList" 	: userList,
   	            	"sharer"	: sharer
   	            };
            	
            	$.ajax({
		        	type : "POST",
		        	contentType: "application/json",
		        	dataType : "json",
		        	url : "/ezEmail/setShareMailBoxMember.do",
		        	async : false,
		        	data : JSON.stringify(sharedMailboxInfo),
		        	success : function(result) {
		        		if (result.resultCode === "OK") {
		        			alert("<spring:message code='ezEmail.sharedMailboxPYY01' />");
		        			// voc 176277 저장 후 닫기시 새로고침되도록
		        			EventCheck = true;
		        			//voc 176242 저장하면 창 닫히도록 수정
		        			window.close();
		        		} else {
		        			alert("<spring:message code='ezEmail.sharedMailboxPYY02' />");
		        		}
		        	},
		        	error : function(error) {
		        		alert("<spring:message code='ezEmail.sharedMailboxPYY02' />");
		        	}
		        });
	        }
	
	        var pSeach = false;
	        
	        function DisplayUserImageList() {
	            var xmlRtn = pListXML_Info;
	            document.getElementById("DeptUserImgList").innerHTML = "";
	            document.getElementById("txtlist_Layer").scrollTop = "0";
	            document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;
	            totalPage2 = Math.ceil(new Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) / 50));
	            
	            while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
	                document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	            }
	            
	            while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
	                document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	            }
	            
	            var UserListHTML = "";

	            if (pListType == "IMG") {
	                document.getElementById("DeptUserImgList").style.display = "";
	                document.getElementById("txtlist_Layer").style.display = "none";
	                document.getElementById("txtlist_table").style.display = "none";
	                document.getElementById("Search_txtlist_table").style.display = "none";
	                
	                if (pSeach) {
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + "<spring:message code='ezEmail.t655' />" + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
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
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + "<spring:message code='ezEmail.t655' />" + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
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
	                        
	                        if (useOrgListCheckBox) {
			                    var M_TR_TD_Chk = document.createElement("TD");
			                    M_TR_TD_Chk.style.padding = "5px";
			                    M_TR_TD_Chk.innerHTML = "<input type='checkbox' class='checkUser'/>";
			                    M_TR.appendChild(M_TR_TD_Chk);
		                    }
	                        
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
	                        
	                        if (useOrgListCheckBox) {
			                    var M_TR_TD_Chk = document.createElement("TD");
			                    M_TR_TD_Chk.style.padding = "5px";
			                    M_TR_TD_Chk.innerHTML = "<input type='checkbox' class='checkUser'/>";
			                    M_TR.appendChild(M_TR_TD_Chk);
		                    }

	                        M_TR.appendChild(M_TR_TD1);
	                        M_TR.appendChild(M_TR_TD2);
	                        M_TR.appendChild(M_TR_TD3);
	                        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                    }
	                    
	                    changeCheckBox();
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

            //voc 176272 검색했을때 겸직으로 두번 들어간 경우 alert가 두번떠서 플래그로 표시
	        var firstAlert = true;

	        function InsertReceiver(pListView) {
	            var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strSIP = "";
	            var pAddFlag = false;
	            // voc 176554
	            var existStr = "";
	
	            var listid = "MsgToList";
	            var getlistview = new ListView();
	            getlistview.LoadFromID(listid);
	
	            var arrRows = getlistview.GetSelectedRows();
	            var length = arrRows.length;
				
                if (listContentArry == ""){
                    // voc 176553
                    alert("<spring:message code='ezEmail.yja006'/>");
                } else if (listContentArry != "") {
                    for (var i = 0; i < listContentArry.length; i++) {
                    	var strId = document.getElementById(listContentArry[i]).getAttribute("_data2");
                        var strName = document.getElementById(listContentArry[i]).getAttribute("_data4");
                        var deptName = document.getElementById(listContentArry[i]).getAttribute("_data14");
                        var companyName = document.getElementById(listContentArry[i]).getAttribute("_data18");
                        if (companyName == null) {
                            // voc 176234 의도는 부서영문명이 아니라 회사명
                        	companyName = document.getElementById(listContentArry[i]).getAttribute("_data16");
                        }
                        
                        var bFlag = getlistview.ExistRow("data1", strId);

                        if (bFlag) {
                            pAddFlag = true;
                            existStr += existStr == "" ? strName : ", " + strName;
                        } else {
                            if(strId == sharer){
                                if(firstAlert){
                                    alert("<spring:message code='ezEmail.pyy25' />");
                                    firstAlert = false;
                                }
                                continue;
                            }
                        	var xmlStringName = MakeXMLString(strName);
                        	var printval = xmlStringName + "(" + strId + ")";
                            pparsingXML2 = "";
                            pparsingXML = "";
                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
                            pparsingXML = pparsingXML + "<DATA4>ORGAN</DATA4>";
                            //voc 176263 부서명 특수문자 있는 경우 리스트 표시되지 않음 수정
                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + "(" + MakeXMLString(deptName) + ")" +  "</VALUE></CELL></ROW>";
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
                            
                            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
                            listview.AddDataRow(objTr, Resultxml);
                            SetAttribute(objTr, "title", strId);
                            
                            objTr.childNodes[0].style.whiteSpace = "";
                            objTr.childNodes[0].style.overflow = "";
                            objTr.childNodes[0].style.textOverflow = "";
                            
                            var currentContent = document.getElementById(listContentArry[i]);
                            InsertReceiver_CheckBox("MsgToList", currentContent);
                            
                        }
                    }
                }
                if(pAddFlag){
                    alert("<spring:message code='ezEmail.yja007'/>" + existStr);
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

	             if (arrRows == ""){
                    alert("<spring:message code='ezEmail.yja006'/>");
                } else {
                    for (var i = 0; i < arrRows.length; i++) {
                        selList.DeleteRow(arrRows[i].id);
                        DeleteReceiver_CheckBox(listid, arrRows[i]);
                    }
                }
	        }
			
	        function orgTabButton_onClick(init) {

	            var topIdData = useShowAllCompanies == "YES" ? "Top/organ" : "Top";

	            document.getElementById("IDListView").style.display = "none";
	        	methodForTabAction(1);
	        	var xmlpara = createXmlDom();
                var xmlTree = createXmlDom();
                var xmlHTTP = createXMLHttpRequest();
                var objNode;
                clearOrgTab("org");
                createNodeInsert(xmlpara, objNode, "DATA");
                createNodeAndInsertText(xmlpara, objNode, "DEPTID", companyId);
                createNodeAndInsertText(xmlpara, objNode, "TOPID", topIdData);
                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
                createNodeAndInsertText(xmlpara, objNode, "ADMINDIST", "false");
                createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
	            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            xmlHTTP.send(xmlpara);
	            if (init == 1){
	            	recevieListview("MsgToList", "ListViewMsgTo");
	            }
	            
	            ListTypeChangeIcon();
	
	            if (xmlHTTP != null && xmlHTTP.readyState == 4) {
	                if (xmlHTTP.status == 200) {
	                    var xmlTree = loadXMLString(xmlHTTP.responseText);
	                    var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
	                    var treeView = new TreeView();
	                    treeView.SetConfig(treeXML);
	                    treeView.SetID("FromTreeView");
	                    treeView.SetUseAgency(true);
	                    treeView.SetUseCheckBox(useOrgListCheckBox);
	                    treeView.SetRequestData("RequestData");
	                    treeView.SetNodeClick("TreeViewNodeClick");
	                    treeView.DataSource(xmlTree);
	                    treeView.DataBind("TreeView");
	                }
	                else {
	                    alert("<spring:message code='ezEmail.t13' />" + xmlHTTP.statusText);
	                    xmlHTTP = null;
	                }
	            }
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
            	var tabIds = ["orgTabButton", "orgJobMasterTabButton1", "orgJobMasterTabButton2"]
            	var targetTab = tabIds[target-1];
            	
            	$.each(tabIds, function(i,d) {
        			var setVal = targetTab == d ? "tabon" : "";
        			document.getElementById(d).children[0].className = setVal;
        		});
            	if (target == 1) {
            		tab1.className = "tabon";
            	}
            	issearch = false;
//             	var treeView = new TreeView();
// 	            treeView.LoadFromID("FromTreeView");
// 	            var nodeIdx = treeView.GetSelectNode();
            	document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px; \" >"
	            	+ "<span id='spn_deptName' title=''></span>"
	            	+ "<span id='countInfo'></span>";
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
	        	// returnFunction으로 들어가있어서 굳이 호출 안해도됨
	        	// window.opener.addSharedMailboxComplete();
	        	window.close();
	        }
	        
	        $(document).on("change", "#selectDomain", function() {
				var mailDomain = "@" + $(this).val();
	        	$("#mailDomain").text(mailDomain);
	        	
	        	selectDomain = $(this).val();
	        });
	        
	        function orgJobMasterTabButton_onClick(tabType) { // 조직도(직위, 직책)
	        	var tabNum = tabType == 1 ? 2 : 3; // 1=직위, 2=직책
	        	methodForTabAction(tabNum);
	        	$.each(m_tabDialogState, function(i,d) {
        			var setVal = ("orgJobMst"+tabType) == i ? "select" : "normal";
        			m_tabDialogState[i] = setVal;
        		});
	            ImageUpdate();
	            document.getElementById("IDListView").style.display = "none";
// 	            document.getElementById("ManualView").style.display = "none";
	            document.getElementById("TreeViewPane").style.display = "";
// 	            document.getElementById("subtitle").innerText = "<spring:message code='ezAddress.t351' />";

	            m_selectedTree = TreeView;
	            gubunpage = "orgJobMstListView" + tabType;
	            selSpan = "orgJobMstSpan" + tabType;

		        $(".txtlist_DeptTD").css("display", "table-cell");
	            
	            clearOrgTab("orgJobMst");
		        orgJobMasterListSet(tabType);
	        }
	        
	        function orgJobMasterListSet(type) {
	        	try {
	        		var pType = type == 1 ? "POS" : "TIT";
	        		
	                var xmlpara = createXmlDom();
	                var xmlTree = createXmlDom();
	                var xmlHTTP = createXMLHttpRequest();
	                var objNode;
	                var topID = useShowAllCompanies == "YES" ? "Top/organ" : "Top";
	                
	                createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "COMID", "");
	                createNodeAndInsertText(xmlpara, objNode, "TOPID", topID);
	                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
	                createNodeAndInsertText(xmlpara, objNode, "TYPE", pType);
	                
	                xmlHTTP.open("POST", "/ezOrgan/getCompanyJobTreeInfo.do", false);
	                xmlHTTP.send(xmlpara);
	                xmlTree = loadXMLString(xmlHTTP.responseText);
	                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");

	                var treeView = new TreeView();
	                treeView.SetConfig(treeXML);
	                treeView.SetID("FromTreeView");
	                treeView.SetUseAgency(true);
	                treeView.SetUseCheckBox(useOrgListCheckBox);
	                treeView.SetRequestData("orgJobMstCompanyClick"); 
	                treeView.SetNodeClick("orgJobMstClick");
	                treeView.DataSource(xmlTree);
	                treeView.DataBind("TreeView");
	                
	                changeCheckBox();
	        	}
	            catch (ErrMsg) {
	                alert("TreeViewinitialize : " + ErrMsg.description);
	            }
	        }
	        
	        function orgJobMstClick(i) {
	        	CurPage = "1";
	        	var thisNode = document.getElementById(i);
	        	var thisNode_jobChk = thisNode.getAttribute("isjob");
	        	listContentArry = new Array();
	        
	        	if (thisNode_jobChk != null && thisNode_jobChk) {
	        		orgJobMstUserList();
	        	} else { // company
		        	document.getElementById("SelectDeptNM").innerHTML = "";
	                pListXML_Info = "";
	                DisplayUserImageList();
	        	}
	        }
	        
	        function orgJobMstUserList() {
	        	var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            treeView.SetUseCheckBox(useOrgListCheckBox);
	            var treeViewSelectNode = treeView.GetSelectNode();
	            
        		var jobId = treeViewSelectNode.GetNodeData("cn");
        		var comId = treeViewSelectNode.GetNodeData("comid");
        		var jobType = treeViewSelectNode.GetNodeData("jobtype");
        		var jobName = treeViewSelectNode.GetNodeData("value");
        		
				$.ajax({
					type : "POST",
					url : "/ezOrgan/getJobMasterMemberList.do",
					dataType : "text",
					data : {
						type : jobType,
						jobID : jobId,
						pageNum : CurPage,
						cell : "company;description;displayName;title;telephoneNumber", 
						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;userType",
						searchType : "",
						searchValue : "",
						comID : comId
					}, success : function(result) {
						pListXML_Info = loadXMLString(result);
		        		var totalCnt = pListXML_Info.getElementsByTagName("TOTALCOUNT")[0].textContent;
		        		
						document.getElementById("SelectDeptNM").innerHTML 
							= "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px; \" >"
			            	+ "<span id='spn_deptName' title='" + jobName + "'>" + jobName + "</span>"
			            	+ "<span id='countInfo'>&nbsp;<span class='countColor'> " + totalCnt + "</span></span>";
						
		                pSeach = false;
		                DisplayUserImageList();
		                makePageSelPage2();
					}, error : function (error) {
						alert("error : " + error);
					}
				});
	        }
	        function makePageSelPage2() {
	            var strtext2;
	            var PagingHTML2 = "";
	            document.getElementById("tblPageRayer2").innerHTML = "";
	            strtext2 = "<div class='pagenavi'>";
	            PagingHTML2 += strtext2;
	            var pageNum2 = CurPage;
	            if (totalPage2 > 1 && pageNum2 != 1) {
	                strtext2 = "<span class='btnimg first' onclick= 'return goToPageByNum2(1)'></span>";
	                PagingHTML2 += strtext2;
	            }
	            else {
	                strtext2 = "<span class='btnimg first disabled'></span>";
	                PagingHTML2 += strtext2;
	            }
	            if (totalPage2 > BlockSize2) {
	                if (pageNum2 > BlockSize2) {
	                    strtext2 = "<span class='btnimg prev' onclick= 'return selbeforeBlock2()'></span>";
	                    PagingHTML2 += strtext2;
	                }
	                else {
	                    strtext2 = "<span class='btnimg prev disabled'></span>";
	                    PagingHTML2 += strtext2;
	                }
	            }
	            else {
	                strtext2 = "<span class='btnimg prev disabled'></span>";
	                PagingHTML2 += strtext2;
	            }
	            var MaxNum2;
	            var i;
	            var startNum2 = (parseInt((pageNum2 - 1) / BlockSize2) * BlockSize2) + 1;
	            if (totalPage2 >= (startNum2 + BlockSize2)) {
	                MaxNum2 = (startNum2 + BlockSize2) - 1;
	            }
	            else {
	                MaxNum2 = totalPage2;
	            }
	            for (i = startNum2; i <= MaxNum2; i++) {
	                if (i == pageNum2) {
	                    strtext2 = "<span class='on'>" + i + "</span>";
	                    PagingHTML2 += strtext2;
	                }
	                else {
	                    strtext2 = "<span onclick='goToPageByNum2(" + i + ")'>" + i + "</span>";
	                    PagingHTML2 += strtext2;
	                }
	            }
	            if (MaxNum2 == 0) {
                	PagingHTML2 += "<span class=\"on\">" + 1 + "</span>";
                }
	            if (totalPage2 > BlockSize2) {
	                if (totalPage2 >= parseInt(((parseInt((pageNum2 - 1) / BlockSize2) + 1) * BlockSize2) + 1)) {
	                    strtext2 = "";
	                    strtext2 = strtext2 + "<span class='btnimg next' onclick='return selafterBlock2()'></span>";
	                    PagingHTML2 += strtext2;
	                }
	                else {
	                    strtext2 = "";
	                    strtext2 = strtext2 + "<span class='btnimg next disabled'></span>";
	                    PagingHTML2 += strtext2;
	                }
	            }
	            else {
	                strtext2 = "";
	                strtext2 = strtext2 + "<span class='btnimg next disabled'></span>";
	                PagingHTML2 += strtext2;
	            }
	            if (totalPage2 > 1 && totalPage2 != 1 && (totalPage2 != pageNum2)) {
	                strtext2 = "<span class='btnimg last' onclick='return goToPageByNum2(" + totalPage2 + ")'></span>";
	                PagingHTML2 += strtext2;
	            }
	            else {
	                strtext2 = "<span class='btnimg last disabled'></span>";
	                PagingHTML2 += strtext2;
	            }
	            PagingHTML2 += "</div>";
	            td_Create2(PagingHTML2);
	        }
	        function orgJobMstCompanyClick(pNodeID, pTreeID) {
				var TreeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            var deptID = treeNode.GetNodeData("CN");
	            GetCompanySubTreeInfo(deptID, TreeIdx);
	        }
	        
	        function GetCompanySubTreeInfo(comID, TreeIdx) {
	        	var jobMstType = gubunpage == "orgJobMstListView1" ? "POS" : "TIT";
	        	
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlRtn = createXmlDom();
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "COMID", comID);
	            createNodeAndInsertText(xmlpara, objNode, "TYPE", jobMstType);
	            xmlHTTP.open("POST", "/ezOrgan/getJobMasterTreeInfo.do", false);
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
	            treeView.SetUseCheckBox(useOrgListCheckBox);
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	            
	            changeCheckBox();
	        }
	        
	        function clearOrgTab(type) { // org or orgJobMst
	        	document.getElementById('TreeView').innerHTML = "";
	        	document.getElementById("SelectDeptNM").innerHTML = "";
                
                var searchSelectObj = document.getElementById('search_type');
                searchSelectObj.setAttribute("data-type", type);
				
                document.getElementById("keyword").value = "";
                issearch = false;
                pSeach = false;
                
                var hide_orgJobMstSearchOpt = [
                	{"name":"title", "usedefault":"1", "msg":"<spring:message code='ezAddress.t359'/>"},
                    {"name":"description", "usedefault":"1", "msg":"<spring:message code='ezAddress.t54'/>"},
                ];
                                           
                $.each(hide_orgJobMstSearchOpt, function(i,e) {
                	var searchOpt = $("#search_type option[value='"+e.name+"']");
               		if (type == "org" && searchOpt.length < 1) {
                   		var tempOpt = "<option value="+e.name+" usedefault="+e.usedefault+">"+e.msg+"</option>";
                   		$(tempOpt).insertAfter("#search_type option[value='displayname']");
                   	} else if (type == "orgJobMst") {
                   		searchOpt.remove();
                   	}
                });
	        }
	        var BlockSize2 = 5;
	        function td_Create2(strtext) {
	            document.getElementById("tblPageRayer2").innerHTML = strtext;
	        }

	        function goToPageByNum2(Value) {
	        	p_ListOrderObject = "";		    	
		    	listContentArry = new Array();
		    	
	            CurPage = Value;
	            movePage2(CurPage);
	        }
	        function selbeforeBlock2() {
	            var pageNum = parseInt(CurPage);
	            pageNum = ((parseInt(pageNum / BlockSize2) - 1) * BlockSize2) + 1;
	            goToPageByNum2(pageNum);
	        }
	        function selbeforeBlock_one2() {
	            var pageNum = parseInt(CurPage);
	            if (parseInt(pageNum - 1) > 0)
	                goToPageByNum2(parseInt(pageNum - 1));
	            else
	                return;
	        }
	        function selafterBlock2() {
	            var pageNum = parseInt(CurPage);
	            pageNum = ((parseInt((pageNum - 1) / BlockSize2) + 1) * BlockSize2) + 1;
	            goToPageByNum2(pageNum);
	        }
	        function selafterBlock_one2() {
	            var pageNum = parseInt(CurPage);
	            if (parseInt(pageNum + 1) <= totalPage2)
	                goToPageByNum2(parseInt(pageNum + 1));
	            else
	                return;
	        }
	        function movePage2(newPage2) {
	            if (parseInt(newPage2) > 0 && parseInt(newPage2) <= parseInt(totalPage2)) {
	                CurPage = newPage2;
	                if (issearch) {
	                	search_click("re_search");
	                } else {
	                	if (document.getElementsByClassName("tabon")[0].getAttribute("id") == "orgSpan"){
	                    	displayUserList();
	                	} else {
                        	orgJobMstUserList();
	                	}
	                }
	            }
	        }
	        function prevPage_onclick2() {
	            newPage2 = parseInt(CurPage) - 1;
	            if (newPage2 > 0) {
	                CurPage = newPage2;
	                displayUserList();
	            }
	        }
	        function nextPage_onclick2() {
	            newPage2 = parseInt(CurPage) + 1;
	            if (newPage2 <= parseInt(totalPage)) {
	                CurPage = newPage2;
	                displayUserList();
	            }
	        }
	        function TrimText(orgStr) {
		        var copyStr = "";
		        var strIndex;
		        for (strIndex = 0; strIndex < orgStr.length; strIndex++) {
		            if (orgStr.charAt(strIndex) == ' ') {
		                continue;
		            }
		            else {
		                copyStr = orgStr.substr(strIndex);
		                break;
		            }
		        }
		        for (strIndex = copyStr.length - 1; strIndex >= 0; strIndex--) {
		            if (copyStr.charAt(strIndex) == ' ') {
		                continue;
		            }
		            else {
		                copyStr = copyStr.substr(0, strIndex + 1);
		                break;
		            }
		        }
		
		        return copyStr;
		    }
 	
 	// 전체 선택
 	$(document).on("click", ".checkAll", function(obj) {
 		event.stopImmediatePropagation();
 		
 		var Is_checked = this.checked;
 		var selectTreeId = m_selectedTree.id;
 		
 		var selectTR = $("#orglistView tr[data2!='mailgroup'][data3!=''] input:not('.checkAll')"); // 그룹메일, 빈메일 제외
 		$.each(selectTR, function (i, e) {
 			var thisParent = $(this).parents("tr")[0];
 			var thisParentEmail = getObjEmail(thisParent, "checkUser");
 			if (thisParentEmail == null){
 	 			thisParentEmail = thisParent.getAttribute("_data2");
 	 		}
 			var IsInsert = isInsert(thisParentEmail);
 			
 			if ((Is_checked && !IsInsert) || (!Is_checked && IsInsert)) {
 				$(this).click();
 			}
 		});

 		firstAlert = true;
 	});
 	
 	$(document).on("click", ".checkUser, .checkDept", function() {
 		event.stopImmediatePropagation();
 		
        if (this.className == "checkDept") {
            var clickTabName = document.getElementsByClassName("tabon")[0].getAttribute("id");
            switch(clickTabName) {
                case "orgSpan" :
                    alert("<spring:message code='ezEmail.pyy24' />");
                    break;
                case "orgJobMstSpan1":
                    alert("<spring:message code='ezEmail.pyy26' />");
                    break;
                case "orgJobMstSpan2":
                    alert("<spring:message code='ezEmail.pyy27' />");
                    break;
            }

            $(this).prop("checked", false);
            return;
        }
 		
 		var Is_checked = this.checked;
 		var thisClassName = this.className;
 
 		var thisParentTag = thisClassName == "checkUser" ? "tr" : "div";
 		var thisParent = $(this).parents(thisParentTag)[0];
 		var thisParentEmail = getObjEmail(thisParent, thisClassName);
 		if (thisParentEmail == null){
 			thisParentEmail = thisParent.getAttribute("_data2");
 		}
 		
 		var insertFunction = function() { thisClassName == "checkUser" ? InsertReceiver() : dept_select(thisParent) };
 		
 		if (Is_checked) {
 			insertFunction();
 			
 			if (!isInsert(thisParentEmail)) { $(this).prop("checked", false); }
 		} else {
 			if (isInsert(thisParentEmail)) { 
 				receiverList_Delete(thisParentEmail, thisClassName);
 			}
 		}
 	});
 	
 	function isInsert(emailStr) {
 		var getlistview = new ListView();
        getlistview.LoadFromID(receiverListId);
             
 		return getlistview.ExistRow("data1", emailStr);
 	}
 
 	function getObjEmail(obj, type) {
     	var selectTreeId = m_selectedTree.id;
 		var emailAttr = type == "checkUser" ? emailAttrArr[selectTreeId] : "mail";
 		var emailStr = obj.getAttribute(emailAttr);
 		
 		var Is_addressGroupMail = (selectTreeId == "AddressListView" && obj.getAttribute("data2") == "mailgroup");
 		if (Is_addressGroupMail) { // 그룹 주소
 			var addressID = obj.getAttribute("data1");
 			var addressFolderType = obj.getAttribute("data4");
 			
 			emailStr = addressID + "|!|" + addressFolderType;
 		} 
 		
 		return emailStr;
 	}
 	
 	function receiverList_Delete(objEmail, type) {
 		$("#ListViewMsgTo tr[data1='"+objEmail+"']").click();
 		
 		DeleteReceiver(ListViewMsgTo);
 	}
 	
 	function dept_select(obj) {
            CurPage = "1";
        	var organTree = new TreeView();
            organTree.LoadFromID("FromTreeView");
            var nodeIdx = organTree.GetSelectNode();
            var checkBoxNodeIdx = "";
            if (typeof obj != "undefined") {
            	var selNodeID = obj.id;
                var selNode = new TreeNode();
                if (selNode.LoadFromID(selNodeID)) {
                	checkBoxNodeIdx = selNode;
                	nodeIdx = checkBoxNodeIdx;
                }
            }
            
            if (nodeIdx != -1) {
            	var strId = nodeIdx.GetNodeData("cn");
            	selectedDept = strId;
                var strName = nodeIdx.NodeName;
                var strEmail = nodeIdx.GetNodeData("mail");
            	
                var listid = receiverListId;
                var getlistview = new ListView();
                 getlistview.LoadFromID(listid);
                var bFlag = getlistview.ExistRow("data1", strId);
 
                if (!bFlag) {
//                 	if (!increaseReceiverCount()) {
//                      	return;
//                      }
                	pparsingXML2 = "";
                     pparsingXML = "";
                     pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
                     pparsingXML = pparsingXML + "<ROW><CELL><DATA1><![CDATA[" + strName + "]]></DATA1>";
                     pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
                     pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strId + "]]></DATA3>";
                     pparsingXML = pparsingXML + "<DATA4>" + strEmail + "</DATA4>";
                     pparsingXML = pparsingXML + "<DATA5>email</DATA5>";
                     pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + " <" + strEmail + ">" + "]]></VALUE></CELL></ROW>";
                     pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
                     Resultxml = loadXMLString(pparsingXML2);
 
                    var MaxID = 0;
                    var InitTr = getlistview.GetDataRows();
                    var MaxCntNum = 0;
 
                    for (var j = 0; j < InitTr.length; j++) {
                        var curnum = Number(getlistview.GetSelectedRowID(j).substring(getlistview.GetSelectedRowID(j).lastIndexOf('_') + 1), getlistview.GetSelectedRowID(j).length);
                        if (MaxID < curnum) {
                            MaxID = curnum;
                            MaxCntNum = j;
                        }
                    }
 
                    var objTr = getlistview.AddRow(InitTr.length);
                    if (MaxCntNum != 0) {
                        MaxCntNum = MaxCntNum + 1;
                    }
 
                    SetAttribute(objTr, "id", getlistview.GetSelectedRowID(MaxCntNum).substring(0, getlistview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
                    getlistview.AddDataRow(objTr, Resultxml);
                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
 
                    for (var y = 0; y < _tdlength; y++) {
                        document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
                        document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
                    }
                    
                    var currentContent = document.getElementById(nodeIdx.NodeID);
                     InsertReceiver_CheckBox(listid, currentContent);
                } // bflag if END
            }
        }
 	function increaseReceiverCount() {
		if (mailMaxReceiverCount < receiverCount + 1) {
			alert(strLangGroupMemberCount01 + mailMaxReceiverCount + strLangGroupMemberCount02);
            return false;
		}
		
		receiverCount += 1;
    	return true;
    }
 	function InsertReceiver_CheckBox(listid, ele) {
     	if (!useOrgListCheckBox) {return; }
     	var n_email = ele.getAttribute("_data2");
		$("#orglistView tr[_data2='"+n_email+"'] input").prop("checked", true);		    		
 	}
 	
 	function DeleteReceiver_CheckBox(listid, ele) {
     	if (!useOrgListCheckBox) {return; }
     	
       	var n_email = ele.getAttribute("data1");
		$("#orglistView tr[_data2='"+n_email+"'] input").prop("checked", false);	
 	}
 	
 	// 수신자설정,탭 변경 시
     function changeCheckBox() {
     	if (!useOrgListCheckBox) {return; }
     	
     	var selectTreeId = m_selectedTree.id;
     	var receiverList = $("#" + receiverListId + " tbody tr");
     	
     	$("#" + selectTreeId + " input[type='checkbox']").prop("checked", false);
    	$("#FromTreeView input[type='checkbox']").prop("checked", false);	
    	
     	$.each(receiverList, function (i,e) {
     		var n_email = e.getAttribute("data1");
              	$("#orglistView tr[_data2='"+n_email+"'] input").prop("checked", true);
     		
     		if (selectTreeId == "OrganListView") {
 		    	$("#FromTreeView div[mail='"+n_email+"'] > input").prop("checked", true);		    		
 	    	}
     	});
     }
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
	    <table style="width:100%;margin-top:10px">
	        <tr>
	            <td style="vertical-align: top;">
	            	<div class="portlet_tabpart01" style="margin:0px;">
	            		<div class="portlet_tabpart01_top" id="tab1" style="margin-bottom:3px;">
	            			<p id="orgTabButton">
	            				<span id="orgSpan" onclick="orgTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t591' /></span>
	            			</p>
	            			<p id="orgJobMasterTabButton1">
	            				<span id="orgJobMstSpan1" onclick="orgJobMasterTabButton_onClick(1)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezOrgan.ksaOrganList01' /></span>
	            			</p>
	            			<p id="orgJobMasterTabButton2">
	            				<span id="orgJobMstSpan2" onclick="orgJobMasterTabButton_onClick(2)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezOrgan.ksaOrganList02' /></span>
	            			</p>
	            		</div>
            		</div>
	                <table id="TreeViewTD">
	                    <tr>
	                        <td>
	                            <div id="TreeViewPane" class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
	                                <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2;">
	                                    <table style="margin-top: 3px; width: 100%;">
	                                        <tr>
	                                            <td>
	                                                <div style="margin-left: 5px;">
	                                                    <select id="search_type" data-type="org" style="height:22px">
	                                                        <option selected value="displayname" usedefault="1"><spring:message code='ezEmail.t31' /></option>
	                                                        <option value="description" usedefault="1"><spring:message code='ezEmail.t26' /></option>
	                                                        <option value="title" usedefault="1"><spring:message code='ezEmail.t28' /></option>
	                                                        <option value="extensionAttribute10" usedefault="1"><spring:message code='ezEmail.t281' /></option>
	                                                        <option value="telephonenumber" usedefault="1"><spring:message code='ezEmail.t99000045' /></option>
	                                                        <option value="mobile" usedefault="0"><spring:message code='ezEmail.t99000046' /></option>
	                                                        <option value="HomePhone" usedefault="0"><spring:message code='ezEmail.t29' /></option>
	                                                        <option value="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezEmail.t99000047' /></option>
	                                                        <option value="mail" usedefault="0"><spring:message code='ezEmail.t99000048' /></option>
	                                                        <option value="streetAddress" usedefault="0"><spring:message code='ezEmail.t99000049' /></option>
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
	                                        <div style="vertical-align: top; height: 371px; overflow: auto; width: 446px;" id="txtlist_Layer">
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
	                            <div id="IDListView" style="OVERFLOW: hidden;">
		                        <table>
		                            <tr>
		                                <td>
		                                    <div class="box" style="OVERFLOW-Y: auto; OVERFLOW-X: auto; WIDTH: 220px; HEIGHT: 502px; BACKGROUND-COLOR: #FFFFFF;padding-top:5px;border-right:0px" id="AddressTreeView"></div>
		                                </td>	                                
		                                <td>
		                                    <div style="vertical-align: middle; border: 1px solid #ddd; border-bottom: 0px; height: 20px; padding-top: 3px; padding-left: 5px;padding-bottom:2px">
		                                    	<img src="/images/ImgIcon/fldr.gif" align="absmiddle" hspace="2" style="cursor: pointer"/><span id="addressFolderName"></span>&nbsp;&nbsp;<span id="addressFolderCnt" style="color: #017BEC;"></span>
		                            		</div>
		                                    <div id="AddressListView" style="BORDER: #ddd 1px solid; OVERFLOW: auto; WIDTH: 446px; HEIGHT: 436px; BACKGROUND-COLOR: white; border-bottom:0px;border-top:0px" class="listview"></div>
		                                    <div id="tblPageRayer"  style="border:#ddd 1px solid;border-top:0px;width:auto !important"></div>
		                                </td>
		                            </tr>
		                        </table>
		                    </div>
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
	                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezEmail.sharedMailboxPYY06' /></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="ListViewMsgTo" ondragover ="onDragEnter(event, this)" ondrop ="onDrop(event, this)" style="width: 250px; Height: 502px; overflow-x: auto; overflow-y: auto;" ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
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
