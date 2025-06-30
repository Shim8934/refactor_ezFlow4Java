<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezNotification.hth67"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <style>
	    	.box {
	    		border-right:0px;
	    	}
	    	.mainlist tr td:first-child {
	    		padding-left:15px;	    		
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
	    	#notiTargetTable_THEAD #notiTargetTable_TH{
	    		height:0px;
	    	}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var topid = "<c:out value='${topID}'/>";
		    var cn = "<c:out value='${userID}'/>";
		    var deptid = "<c:out value='${userInfo.deptID}'/>";
		    var g_szAuthor = "";
		    var g_senderinfo = "<c:out value='${userInfo.companyName1}'/>" + ", " + "<c:out value='${userInfo.deptName1}'/>" + ", " + "<c:out value='${userInfo.title1}'/>";
		    var g_szUserID = "<c:out value='${userInfo.email}'/>";
		    var name = "";
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		    var pListType = "TXT";
		    var pListXML_Info = null;
		    var xmlHTTP = createXMLHttpRequest();
		    var xmlHTTP2 = createXMLHttpRequest();
		    var ReturnFunction;
		    var RetValue;
		    var isfirst = true;
		    var preObj = "";
			var deptTreeTopId = "${deptTreeTopId}";
			var selCompany = "${selCompany}";
			var m_selectedTree = "";
			var primary = "<c:out value='${primary}'/>";
			var selUserCompanyId = "";
			
		    $(document).ready(function(){
		    	try {
	                RetValue = parent.emergency_noti_dialogArguments[0];
	                ReturnFunction = parent.emergency_noti_dialogArguments[1];
	            } catch (e) {
	            	try {
						RetValue = opener.emergency_noti_dialogArguments[0];
						ReturnFunction = opener.emergency_noti_dialogArguments[1];
					} catch (e) {
					}
	            }
	            
	        	try {
	            	var ua = navigator.userAgent;
	            	
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                var input = document.getElementsByTagName("input");
		                
		                for (var i = 0; i < input.length; i++) {
		                    if (input[i].getAttribute("type") == "text") {
		                        KeEventControl(input[i]);
		                    }
		                }
		            }
		        } catch (e) { }
		        
		        var strQuery = "<DATA><DEPTID></DEPTID><TOPID>" +deptTreeTopId + "</TOPID><PROP>mail;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
	
		        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		        xmlHTTP.onreadystatechange = event_GetDeptTreeInfo;
		        xmlHTTP.send(strQuery);

		        ListTypeChangeIcon();
		        recevieListview("notiTargetTable", "notiTargetListDiv");
		        
		        addSelectedRecipient(RetValue);
		        ChangeListView_onClick(getOrganListType());
				
		    });
		    
		    function addSelectedRecipient(notiRecipientArray) {
		    	var pparsingXML = "";
		        var pparsingXML2 = "";
		        var listid = "notiTargetTable";
                var getlistview = new ListView();
                for (var i = 0; i < notiRecipientArray.length; i++) {
                	pparsingXML = "";
                	pparsingXML2 = "";
                	getlistview.LoadFromID(listid);
 	                pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
                	pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + notiRecipientArray[i].cn + "</DATA1>";
     				pparsingXML = pparsingXML + "<DATA2></DATA2>";
     				pparsingXML = pparsingXML + "<DATA3></DATA3>";
                    pparsingXML = pparsingXML + "<DATA4>" + notiRecipientArray[i].userType + "</DATA4>";
                    pparsingXML = pparsingXML + "<DATA5>" + notiRecipientArray[i].subDeptYn + "</DATA5>";
                    pparsingXML = pparsingXML + "<DATA6>" + notiRecipientArray[i].companyId + "</DATA6>";
                    
                    pparsingXML = pparsingXML + "<VALUE>" + notiRecipientArray[i].name + "</VALUE>";
    				pparsingXML = pparsingXML + "</CELL></ROW>";
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
                }
		    }
		    
		    function event_GetDeptTreeInfo() {
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

		                xmlHTTP = null;
		                isfirst = false;
		            } else {
		                alert("<spring:message code='ezOrgan.t13' />" + xmlHTTP.status);
		                xmlHTTP = null;
		            }
		        }
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
		        //createNodeAndInsertText(xmlpara, objNode, "DISPLAY_TRASH_DEPT", "");

		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(xmlpara);

		        xmlRtn = loadXMLString(xmlHTTP.responseText);

		        if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
		            if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
		            } else {
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
        		document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" 
        		+ "<span id='spn_deptName' title='" + nodeIdx.GetNodeData("VALUE") + "'>" + nodeIdx.GetNodeData("VALUE") + "</span>"
        		+ "<span id='countInfo'></span>";
		        SelectDeptNM.setAttribute("countinfo", "")
					
		        displayUserList(nodeIdx.GetNodeData("CN"));
		        
		        m_selectedTree = "dept";
		    }
		    
		    function displayUserList(DeptID) {
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : DeptID, cell : "company;description;displayName;title;telephoneNumber;extensionattribute10;", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;usertype;department;extensionattribute7;extensionattribute8;role1;role2;companyid", type : "user"},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		var headerData = createXmlDom();
		                headerData = result;

		                if (CrossYN()) {
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    var Node = headerData.importNode(xmlRtn, true);
		                    headerData.documentElement.appendChild(Node);
		                } else {
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    headerData.documentElement.appendChild(xmlRtn);
		                }
		                pListXML_Info = headerData;
		                pSeach = false;
		                DisplayUserImageList();

		                if ("<c:out value='${use_ocs}'/>" == "YES") {
	                        check_presence();
	                    }
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t9' />" + error);
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
			        			document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='txt_color'>" + result.totalCount + "</span> / <span class='txt_color'>" + parseInt(result.totalCount + result.totalCount2) + "</span>";
							} else {
								document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='txt_color'>" + result.totalCount + "</span>";
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
		    }
		    
		    var m_strColorSelect = "#f1f8ff";
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
	        
	        var listContentArry = new Array();
	        var listSubContentArry = new Array();
	        var listSubEventCheckbox = false;
	        function event_listclick(obj) {
	        	if(preObj != obj) {
	                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                    p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                    
	                    if(p_ListOrderObject != null){
		                    for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                        p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                    }
	                    }
	                }
	                listContentArry = new Array();
	                p_ListOrderObject = obj;
	                
                    for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
                        p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
                    }
                    listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	        	}
                preObj = obj;
                
                m_selectedTree = "user";
	        }
	        
	        function event_listdblclick(obj) {
	        	InsertReceiver();
	        }
	        
	        function InsertReceiver() {
	        	var pparsingXML = "";
		        var pparsingXML2 = "";
		        var strSIP = "";
	        	
	        	if (m_selectedTree == "dept") {
	        		var organTree = new TreeView();
	                organTree.LoadFromID("FromTreeView");
	                var nodeIdx = organTree.GetSelectNode();
	                var strId = nodeIdx.GetNodeData("CN");
	                var strName = nodeIdx.NodeName;
	                
	                var listid = "notiTargetTable";
	                var getlistview = new ListView();
	                getlistview.LoadFromID(listid);
	                var bFlag = getlistview.ExistRow("data1", strId);
	                if (bFlag) {
						alert("<spring:message code='ezBoard.t20' />");
						return;
					} else {
						pparsingXML2 = "";
	                    pparsingXML = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
						pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(nodeIdx.GetNodeData("DISPLAYNAME")) + "</DATA2>";
						pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(nodeIdx.GetNodeData("DISPLAYNAME2")) + "</DATA3>";
	                    pparsingXML = pparsingXML + "<DATA4>DEPT</DATA4>";
	                    pparsingXML = pparsingXML + "<DATA5>N</DATA5>";
	                    pparsingXML = pparsingXML + "<DATA6></DATA6>";
	                    
						if (primary == "1") { // 부서이름 다국어 처리
							pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' /> " + MakeXMLString(nodeIdx.GetNodeData("DISPLAYNAME")) + " <spring:message code='ezNotification.hth69' />" + "</VALUE>";
						} else {
							pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' /> " + MakeXMLString(nodeIdx.GetNodeData("DISPLAYNAME2")) + " <spring:message code='ezNotification.hth69' />" + "</VALUE>";
						}
						pparsingXML = pparsingXML + "</CELL></ROW>";
						
	                    //pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' /> " + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
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
					}
	                
	                
	        	} else if (m_selectedTree == "user") {
	        		for (var i = 0; i < listContentArry.length; i++) {
                        var strId = document.getElementById(listContentArry[i]).getAttribute("_data2"); // cn
                        var strName = document.getElementById(listContentArry[i]).getAttribute("_data17"); // 이름(기본어) / 기존값 data4
                        var strName2 = document.getElementById(listContentArry[i]).getAttribute("_data18"); // 이름(다국어)
                        var strDeptNM = document.getElementById(listContentArry[i]).getAttribute("_data19"); // 부서명 (기본어)
	                    var strDeptNM2 = document.getElementById(listContentArry[i]).getAttribute("_data20"); // 부서명 (다국어)
	                    var strDeptID = document.getElementById(listContentArry[i]).getAttribute("_data11"); 
                        var strJobName = document.getElementById(listContentArry[i]).getAttribute("_data21");
                        var strJobName2 = document.getElementById(listContentArry[i]).getAttribute("_data22");
                        var strRoleName = document.getElementById(listContentArry[i]).getAttribute("_data14");
                        var strRoleName2 = document.getElementById(listContentArry[i]).getAttribute("_data15");
                        var companyId = document.getElementById(listContentArry[i]).getAttribute("_data16");
                        var listid = "notiTargetTable";
                        var getlistview = new ListView();
                        getlistview.LoadFromID(listid);
                        var bFlag = getlistview.ExistRow("data1", strId);
						
                        if (bFlag) {
							alert("<spring:message code='ezBoard.t20' />");
							return;
						}
                        else {
                            pparsingXML2 = "";
                            pparsingXML = "";
                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
							pparsingXML = pparsingXML + "<DATA2></DATA2>";
							pparsingXML = pparsingXML + "<DATA3></DATA3>";
                            pparsingXML = pparsingXML + "<DATA4>PERSON</DATA4>";
                            pparsingXML = pparsingXML + "<DATA5>N</DATA5>";
                            pparsingXML = pparsingXML + "<DATA6>" + companyId + "</DATA6>";
                            
		                    var deptJobRoleContent = "";
							if (primary == "1") {
								deptJobRoleContent += strDeptNM.trim();
								deptJobRoleContent += strJobName.trim() == "" ? "" : " " + strJobName.trim();
								deptJobRoleContent += strRoleName.trim() == "" ? "" : " " + strRoleName.trim();
								pparsingXML = pparsingXML + "<VALUE><![CDATA["+ strName + "(" + deptJobRoleContent + ")" + "]]></VALUE>";
							} else {
								deptJobRoleContent += strDeptNM2.trim();
								deptJobRoleContent += strJobName2.trim() == "" ? "" : " " + strJobName2.trim();
								deptJobRoleContent += strRoleName2.trim() == "" ? "" : " " + strRoleName2.trim();
								pparsingXML = pparsingXML + "<VALUE><![CDATA["+ strName2 + "(" + deptJobRoleContent + ")" + "]]></VALUE>";
							}
							pparsingXML = pparsingXML + "</CELL></ROW>";
							
                         //   pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
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
                        } 
                    }
	        	}
	        }
	        
	        function DeleteReceiver() {
	            var listid = "notiTargetTable";
	            var selList = new ListView();
	            selList.LoadFromID(listid);

	            var arrRows = selList.GetSelectedRows();
	            var strName = "";

	            for (var i = 0; i < arrRows.length; i++) {
	                selList.DeleteRow(arrRows[i].id);
	            }
	        }
		    
		    pSeach = false;
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
		        /* if (SelectDeptNM.getAttribute("countinfo") != "1") {
		            //SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang24 + "</span>]";
		            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang24 + "</span>]";
	        		} else {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang24 + "</span>]";
	        		}
		            
		            SelectDeptNM.setAttribute("countinfo", "1")
		        } */
		        
		        if (pListType == "IMG") {
		            document.getElementById("DeptUserImgList").style.display = "";
		            document.getElementById("txtlist_Layer").style.display = "none";
		            document.getElementById("txtlist_table").style.display = "none";
		            document.getElementById("Search_txtlist_table").style.display = "none";
		            
		            if (pSeach) {
		                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" + "<span id='spn_deptName'>" + "<spring:message code='ezOrgan.t101' />" + "</span>" + "<span id='countInfo' class='txt_color'>&nbsp;&nbsp;<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "</span></span>";
		                SelectDeptNM.setAttribute("countinfo", "1");
		            }
		        } else {
	                document.getElementById("DeptUserImgList").style.display = "none";
	                document.getElementById("txtlist_Layer").style.display = "";
	                
	                if (!pSeach) {
	                    document.getElementById("txtlist_table").style.display = "";
	                    document.getElementById("Search_txtlist_table").style.display = "none";
	                } else {
	                    document.getElementById("Search_txtlist_table").style.display = "";
	                    document.getElementById("txtlist_table").style.display = "none";
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" + "<span id='spn_deptName'>" + "<spring:message code='ezOrgan.t101' />" + "</span>" + "<span id='countInfo' class='txt_color'>&nbsp;&nbsp;<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "</span></span>";
	                    SelectDeptNM.setAttribute("countinfo", "1")
	                }
	            }
		        
				var dataCnt = SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length;
	            
	            if (dataCnt == 0) {
	            	var M_TR = document.createElement("TR");
	            	var M_TR_TD = document.createElement("TD");
	            	M_TR_TD.textContent ='<spring:message code="main.t00026" />';
	            	M_TR_TD.style.textAlign = "center";
					if (pListType == "IMG") {
						var MainTable = document.createElement("TABLE");
	                    MainTable.setAttribute("cellspacing", "0");
	                    MainTable.setAttribute("cellpadding", "0");
	                    MainTable.style.border = "0 none";
	                    MainTable.style.marginLeft = "auto";
	                    MainTable.style.marginRight = "auto";
	                    MainTable.style.width = "100%";
	                    M_TR_TD.style.border = "0px";
	                    M_TR_TD.style.borderBottom = "1px solid #eaeaea";
	                    M_TR.appendChild(M_TR_TD);
	                    MainTable.appendChild(M_TR);
	                    document.getElementById("DeptUserImgList").appendChild(MainTable);
	            	} else if (pSeach) {
		            	M_TR_TD.setAttribute('colspan', '4');
						M_TR.appendChild(M_TR_TD);
						document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	            	} else {
		            	M_TR_TD.setAttribute('colspan', '3');
						M_TR.appendChild(M_TR_TD);
						document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	            	}
					
	            	return;
	            }

	            for (var i = 0; i < dataCnt; i++) {
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
	                    M_TR.ondblclick = function () { event_listdblclick(this); };
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    } else {
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
	                    
	                    if( !pSeach && $(M_TR).attr("_DATA25" ) == "addJob"){
		            		pDisplayName += "<spring:message code='ezOrgan.psb03'/> ";
		            	} else if( pSeach && $(M_TR).attr("_DATA25") == "addJob" ){
		            		pDisplayName += "<spring:message code='ezOrgan.psb03'/> ";
		            	}
	                    
	                    if ("<c:out value='${use_ocs}'/>" == "YES") {
	                        pDisplayName += "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>";
	                    }
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
	                } else {
	                    var M_TR = document.createElement("TR");
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
 	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };
	                    M_TR.ondblclick = function () { event_listdblclick(this); };
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    } else {
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
	                        if ("<c:out value='${use_ocs}'/>" == "YES") {
	                            M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        } else {
	                            M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");
	                        }
	                        var M_TR_TD3 = document.createElement("TD");
	                        
	                        var jobName = "";
	                        if($(M_TR).attr("_DATA25") == "addJob"){
			            		jobName += "<spring:message code='ezOrgan.psb03'/> ";
			            	}	      
	                        
	                        jobName += M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	                        M_TR_TD3.innerHTML = jobName;
	                        M_TR_TD3.style.width = "80px";

	                        var M_TR_TD4 = document.createElement("TD");
	                        M_TR_TD4.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");

	                        M_TR.appendChild(M_TR_TD1);
	                        M_TR.appendChild(M_TR_TD2);
	                        M_TR.appendChild(M_TR_TD3);
	                        M_TR.appendChild(M_TR_TD4);
	                        document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                    } else {
	                        var M_TR_TD1 = document.createElement("TD");
	                        M_TR_TD1.style.overflow = "hidden";
	                        M_TR_TD1.style.textOverflow = "ellipsis";
	                        M_TR_TD1.style.whiteSpace = "nowrap";
	                        M_TR_TD1.style.width = "150px";
	                        
	                        if ("<c:out value='${use_ocs}'/>" == "YES") {
	                            M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        } else {
	                            M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
	                        }
	                        var M_TR_TD2 = document.createElement("TD");
	                        M_TR_TD2.style.width = "80px";
	                        var jobName = "";
	                        if($(M_TR).attr("_DATA25") == "addJob"){
			            		jobName += "<spring:message code='ezOrgan.psb03'/> ";
			            	}	      
	                        
	                        jobName += M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	                        M_TR_TD2.innerHTML = jobName;

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
		    
		    function ListTypeChangeIcon() {
		        if (pListType == "IMG") {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_onimglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_list.gif");
		        } else {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_imglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_onlist.gif");
		        }
		    }
		    
		    function closeWindow() {
		        window.close();
		    }
		    
		    function getDeptId(userId) {
		        return getEntryInfo(userId, "department");
		    }
		    
		    function getEntryInfo(userId, propStr) {
		    	var ReceiveDocument = "";

		        try {
		        	var result = "";
		        	$.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/admin/ezOrgan/getEntryInfo.do",
		        		data : {
		        			cn 	  : userId,
		        			prop  : propStr
		        		},
		        		success: function(xml){
		        			result = xml;
		        		}        			
		        	});
		        	
		            ReceiveDocument = SelectSingleNodeValueNew(loadXMLString(result), "DATA/" + propStr.toUpperCase());
		        } catch (e) {
		        } 
		        
		        return ReceiveDocument;
		    }
		    
		    function OK_Click() {
	            var notiTargetListView = new ListView();
	            notiTargetListView.LoadFromID("notiTargetTable");
	            var selectedRows = notiTargetListView.GetDataRows();
	            if (selectedRows.length == 0) {
	            	alert("수신자를 선택하세요");
	            	return;
	            }
	            var notiParamArray = [];
				for (var i = 0; i < selectedRows.length; i++) {
		            var paramObj = {};
					var cn = selectedRows[i].getAttribute("DATA1");
					var receiptName = selectedRows[i].querySelector('td').textContent;
					var userType = selectedRows[i].getAttribute("DATA4");
					var subDeptYn = selectedRows[i].getAttribute("DATA5");
					var companyId = selectedRows[i].getAttribute("DATA6");
					paramObj.recipientId = cn;
					paramObj.userType = userType;
					paramObj.receiptName = receiptName;
					paramObj.subDeptYn = subDeptYn;
					paramObj.companyId = companyId;
					notiParamArray.push(paramObj);
				}           
	            try {
	            	if (ReturnFunction != null) {
	            		//opener.emergency_noti_dialogArguments[0] = notiParamArray; 
	            		ReturnFunction(notiParamArray);
	            	}
	            	
 			    	window.close();
 			    } catch (e) {
 			    	console.log(e);
 			    	return;
 			    }
	        }
		    
		    var rgParams = new Array();
		    var checkname2_cross_dialogArguments = new Array();
		    function deptsearch_click() {
		        if (document.all("deptkeyword").value == "") {
		        	alert("<spring:message code='ezOrgan.t56' />");
		            document.all("deptkeyword").focus();
		            return;
		        }
		        var xmlDOM = createXmlDom();
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : false,
		        	data : {
						search: "displayname::" + encodeURIComponent(document.all("deptkeyword").value),
						cell: "extensionAttribute3;displayname;extensionAttribute9;",
						prop: "cn",
						type: 'group',
						company: selCompany,
						adminOrgan: "y"
					},
		        	success : function(xml){	
		        		result=loadXMLString(xml);
		        		xmlDOM = result;
		                adCount = xmlDOM.getElementsByTagName("ROW").length;
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t11' />" + error);
		        		xmlDOM = null;
		        	}
		        });
		        
		        if (adCount == 0) {
		        	alert("<spring:message code='ezOrgan.t61' />");
		            return;
		        } else if (adCount == 1) {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();

		            if (CrossYN()) {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>" + selCompany + "/organ</TOPID><PROP>mail;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		            } else {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>" + selCompany + "/organ</TOPID><PROP>mail;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		            }
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        } else {
		            rgParams["addrBook"] = xmlDOM;
		            rgParams["deptid"] = "";
		            
		            if (CrossYN()){
		                checkname2_cross_dialogArguments[0] = rgParams;
		                checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;		                
		                var OpenWin = window.open("/admin/ezOrgan/checkName2.do", "checkName2_Cross", GetOpenWindowfeature(598, 340));
		                try { OpenWin.focus(); } catch (e) { }
		            }else{
		                var feature = "dialogHeight:320px; dialogWidth:600px; status:no;scroll:no; help:no; edge:sunken";
		                feature = feature + GetShowModalPosition(600, 320);
		                window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, feature);

		                if (rgParams["deptid"] != "") {
		                    bSearch = true;
		                    g_xmlHTTP = createXMLHttpRequest();
		                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + selCompany + "/organ</TOPID><PROP>mail;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		                    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		                    g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		                    g_xmlHTTP.send(strQuery);
		                }
		            }
		        }
		    }
		    function deptsearch_click_Complete() {
		        if (rgParams["deptid"] != "") {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();
		            var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + selCompany + "/organ</TOPID><PROP>mail;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		    }
		    var bSearch = true;
		    function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.status == 200) {
		                if (!bSearch) {
		                    try {
		                        if (CrossYN()) {
		                            opener.opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
		                        } else {
		                            window.dialogArguments["window"].opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
		                        }
		                    } catch (e) { }
		                }

		                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
		                document.getElementById('TreeView').innerHTML = "";

		                var treeView = new TreeView();
		                treeView.SetConfig(treeXML);
		                treeView.SetID("FromTreeView");
		                treeView.SetUseAgency(true);
		                treeView.SetRequestData("RequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
		                treeView.DataBind("TreeView");
		            } else {
		                alert("<spring:message code='ezOrgan.t9' />" + g_xmlHTTP.status);
		                g_xmlHTTP = null;
		            }
		        }
		    }
		    
		    function search_click(){
				if (keyword.value == ""){
					alert("<spring:message code='ezOrgan.t56' />");
					keyword.focus();
					return;
				}			   
			    				
				$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",		        	
		        	data : {
						search: document.getElementById("search_type").value + "::" + encodeURIComponent(document.getElementById("keyword").value),
						cell: "company;description;displayname;title;telephonenumber;" + document.getElementById("search_type").value,
						prop: "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;usertype;department;extensionattribute7;extensionattribute8;role1;role2;companyid",
						type: "user",
						company: selCompany,
						adminOrgan: "y"
					},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		var usedefault;		                
		                var headerData = createXmlDom();
// 		                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
		                headerData = result;
		                
		                if (CrossYN()) {
		                	usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    var Node = headerData.importNode(xmlRtn, true);
		                    headerData.documentElement.appendChild(Node);
		                } else {
		                	usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    headerData.documentElement.appendChild(xmlRtn);
		                }
		                pListXML_Info = headerData;
		                pSeach = true;
		                DisplayUserImageList();

		                if ("<c:out value='${use_ocs}'/>" == "YES") {
		                    check_presence();
		                }
		                
					},
					error : function(error){
						alert("<spring:message code='ezOrgan.t9' />");
					}
		        });				
				// [2006. 02. 10. 이민수] 검색을 완료하면 TextBox를 초기화하도록 변경
				//keyword.value = "";
			}
		    
		    function deptsearch_press() {
	            if (window.event.keyCode == "13") {
	                deptsearch_click();
	                event.cancelBubble = true;
	                event.returnValue = false;
	            }
	        }
		    
		    function search_press(){
				if (window.event.keyCode == "13"){
					search_click();
				}
			}
		    
		    String.prototype.trim = function () {
		        return this.replace(/(^\s*)|(\s*$)/g, "");
		    }
		    function keyword_Clear() {
		        document.getElementById("keyword").value = "";
		    }
		    
		    function ChangeListView_onClick(Div) {
		        pListType = Div;
		        ListTypeChangeIcon();
		        DisplayUserImageList();
		        setOrganListType(pListType);
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
	        
		    //2018-08-01 김보미 - 부서명 [사원수] 길이가 길면 조정하는 함수
	        function deptNameLong(containLow, strIsLeaf) {
	        	var deptNameWidth = "";
	        	var sum = $("#spn_deptName").width() + $("#countInfo").width();
	        	
	          	if (containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
	          		if (sum > 359) {
	          			deptNameWidth = 360 - $("#countInfo").width();
	          		}
	          	} else {
	          		if (sum > 357) {
	          			deptNameWidth = 358 - $("#countInfo").width();
	          		}
	          	}
	        	
	        	$("#spn_deptName").css("width", deptNameWidth);
	        }
		    
	        var jobTitle, jobTitle2, jobTitleID, jobRole, jobRole2, jobRoleID;
		    function getTitleOption(companyID) {
		    var typeAry = ['001', '002'];
		    var xmldom, rtnVal, flag, i;
		    typeAry.forEach(function(type) {
		    	$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/jobTitleListView.do",
					data : {
						type : type,
						companyID : companyID
					},
					async : false,
					success : function(result){
						xmldom = loadXMLString(result);
					},
					error : function(){
					}
				});
		    	
		    	var oRows = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
		    	if (type == '001') {
					if (oRows.length > 0) {
				    	flag = true;
				    	rtnVal = "<select id='titleSelector' style='width:100%;height:25px;' onchange='jobChange(this)'>";
				    	for (i = 0; i < oRows.length; i++) {
				    		if (SelectSingleNodeValue(GetChildNodes(oRows[i])[3],"VALUE") != "N") {
					    		if (flag) {
	// 					    		jobID = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE");
	// 					    		jobTitle = SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE");
	// 					    		jobTitle2 = SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE");
						    		jobTitleID = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"DATA1");
						    		jobTitle = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE");
						    		jobTitle2 = SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE");
						    		flag = false;
						    		console.log("jobTitle = ",jobTitleID, jobTitle, jobTitle2);
					    		}
					    		
	// 				    		rtnVal += "<option id='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE")) 
	// 						    		+ "' nmval='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE")) 
	// 						    		+ "' nmval2='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE")) + "'>";
					    		rtnVal += "<option id='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"DATA1")) 
							    		+ "' nmval='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE")) 
							    		+ "' nmval2='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE")) + "'>";
						    		
					    		if ("${userInfo.primary}" == "1") {
						    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE"));
					    		} else {
						    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE"));
					    		}
					    		
					    		rtnVal += "</option>";
				    		}
				    	}
				    	rtnVal += "</select>";
				    } else {
				    	rtnVal = "<select id='titleSelector' style='width:100%;height:25px;'></select>";
				    	jobTitleID = ""; jobTitle = ""; jobTitle2 = "";
				    }
						document.getElementById("JobTitleOption").innerHTML = rtnVal;
		    	} else if (type == '002') {
					if (oRows.length > 0) {
				    	flag = true;
				    	rtnVal = "<select id='roleSelector' style='width:100%;height:25px;' onchange='jobChange(this)'>";
					    		rtnVal += "<option id='' nmval='' nmval2=''>(<spring:message code='ezApprovalG.t852' />)</option>";
				    	for (i = 0; i < oRows.length; i++) {
				    		if (SelectSingleNodeValue(GetChildNodes(oRows[i])[3],"VALUE") != "N") {
					    		if (flag) {
	// 					    		jobID = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE");
	// 					    		jobTitle = SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE");
	// 					    		jobTitle2 = SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE");
						    		jobRoleID = "";
						    		jobRole = "";
						    		jobRole2 = "";
						    		flag = false;
					    		}
	// 				    		rtnVal += "<option id='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE")) 
	// 						    		+ "' nmval='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE")) 
	// 						    		+ "' nmval2='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE")) + "'>";
					    		rtnVal += "<option id='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"DATA1")) 
							    		+ "' nmval='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE")) 
							    		+ "' nmval2='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE")) + "'>";
						    		
					    		if ("${userInfo.primary}" == "1") {
						    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE"));
					    		} else {
						    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE"));
					    		}
					    		
					    		rtnVal += "</option>";
				    		}
				    	}
				    	rtnVal += "</select>";
				    } else {
				    	rtnVal = "<select id='roleSelector' style='width:100%;height:25px;'></select>";
				    	jobRoleID = ""; jobRole = ""; jobRole2 = "";
				    }
					document.getElementById("JobRoleOption").innerHTML = rtnVal;
		    	}
			    
				});
		    
		    
		    }
		    
		    function jobChange(selectValue) {
		    	//var target = document.getElementById("titleSelector");
		    	//var option = target.options[target.options.selectedIndex];
		    	var option = selectValue.options[selectValue.options.selectedIndex];
		    	if (selectValue.id == 'titleSelector') {
		    		jobTitleID = option.id != "" ? option.id : "0";
			    	jobTitle = option.getAttribute("nmval");
			    	jobTitle2 = option.getAttribute("nmval2");
		    	} else {
		    		jobRoleID = option.id != "" ? option.id : "0";
		    		jobRole = option.getAttribute("nmval");
		    		jobRole2 = option.getAttribute("nmval2");
		    	}
		    }
			
			function jobCheck(cn, deptId, jobId, roleId){
				var result_data;
				
				$.ajax({
					type : "POST",
					url : "/admin/ezOrgan/getUserJobCheck",
					async : false,
					data : {cn : cn ,
							deptId : deptId,
							jobId : jobId, 
							roleId : roleId}, 
					success : function(data){
							result_data = data;
						}	
				});
				
				return result_data;
				
			}
			
			function recevieListview(pID, pListView) {
	            var listview = new ListView();
	            listview.SetID(pID);
	            listview.SetSelectFlag(false);
	            listview.SetMulSelectable(true);
	            listview.SetRowOnDblClick("DeleteReceiver");
	            listview.SetRowOnClick("SelectReceiverWindow");
	            listview.DataSource(loadXMLString("<LISTVIEWDATA></LISTVIEWDATA>"));
	            listview.DataBind(pListView);
	            listview.RowDataBind();
	        }
			
			 function SelectReceiverWindow() {
		        	var listview = new ListView();
	                listview.LoadFromID("notiTargetTable");
					var arrRows = listview.GetSelectedRows();
					
					if (arrRows == "") {
						return;
					} else {
						if (arrRows[0].getAttribute("DATA4") == "DEPT") { // 부서, 회사권한
							document.getElementById("admin_OK").disabled = false;
							document.getElementById("admin_NO").disabled = false;
							var _data5 = arrRows[0].getAttribute("DATA5");
	
							if (_data5 == "Y") { // _data5값은 하위부서 허용, 불가 여부 세팅값
								document.getElementById("admin_OK").checked = true;
								document.getElementById("admin_NO").checked = false;
							} else {
								document.getElementById("admin_OK").checked = false;
								document.getElementById("admin_NO").checked = true;
								arrRows[0].setAttribute("DATA5", "N");
							}
						} else { // PERSON, JIKWI, JIKCHEK
							document.getElementById("admin_OK").disabled = true;
							document.getElementById("admin_OK").checked = false;
							document.getElementById("admin_NO").disabled = true;
							document.getElementById("admin_NO").checked = true;
						}
					}
				}
			 
				 function checkbox_onclick(e) {
					var srcElementID = "";
					if (!CrossYN()) {
						srcElementID = window.event.srcElement.id;
					} else {
						srcElementID = e.target.id;
					}

					var checkFlag = "Y";
					if (srcElementID == "admin_OK") {
						document.getElementById("admin_OK").checked = true;
						document.getElementById("admin_NO").checked = false;
						checkFlag = "Y";
					} else {
						document.getElementById("admin_OK").checked = false;
						document.getElementById("admin_NO").checked = true;
						checkFlag = "N";
					}

					var pListViewDL = new ListView();
					pListViewDL.LoadFromID("notiTargetTable");
					var arrRows = pListViewDL.GetSelectedRows();
					
					// 여러 Row를 선택하여 하위부서 허용여부를 설정할 경우, 부서/회사만 변경사항이 적용되도록 수정
					if (arrRows == "") {
						return;
					} else {
						for (var i = 0; i < arrRows.length; i++) {
							if (arrRows[i].getAttribute("DATA4") == "DEPT") {
								arrRows[i].setAttribute("DATA5", checkFlag);
								var deptContent = "<spring:message code='ezEmail.t15' /> "
								deptContent += primary == "1" ? arrRows[i].getAttribute("DATA2") : arrRows[i].getAttribute("DATA3");
								deptContent += checkFlag == "Y" ? " " + '<spring:message code="ezNotification.hth68"/>' : " " + '<spring:message code="ezNotification.hth69"/>'; 
								arrRows[i].querySelector('td').textContent = deptContent;
							}
						}
					}
				}
				 
				function add_deptparment() {
					if (m_selectedTree == "dept") {
						InsertReceiver();
					}
				}
	    </script>
	</head>
	<body class="popup">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t67' /></NAME>
						<WIDTH>40</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t69' /></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t97' /></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>	
	    <div id="menu">
	        <ul>
	            <li><span onclick="OK_Click()"><spring:message code='ezOrgan.t167' /></span></li>
	        </ul>
	    </div>
	    <div id="close">
	        <ul>
	            <li><span onclick="closeWindow()"></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
	    <table id="TreeViewTD" style="margin-top:25px;">
	        <tr>
	            <td>
	                <div class="portlet_tabpart03" style="background-color: #f8f8fa; margin: 0px; padding: 0px; border: 1px solid #eaeaea;">
	                    <div class="portlet_tabpart03_top" id="tab1">
	                        <table style="margin-top: 3px; width: 100%;">
	                            <tr>
	                                <td>
                                        <div style="padding-left:5px">
                                        <input type="text" name="Input" id="deptkeyword" style="WIDTH: 120px; height:22px;" onkeypress="deptsearch_press()">
                                        <a class="imgbtn"><span onclick="deptsearch_click()"><spring:message code='ezOrgan.t93' /></span></a>
                                        </div>
	                                </td>
	                                <td>
	                                    <div style="float:right; height:25px;">
	                                        <select id="search_type" style="height:22px;">
	                                            <option selected value="displayname"><spring:message code='ezOrgan.t67' /></option>
					                            <option value="cn"><spring:message code='ezOrgan.t94' /></option>
					                            <option value="description"><spring:message code='ezOrgan.t68' /></option>
					                            <option value="title"><spring:message code='ezOrgan.t69' /></option>
					                            <option value="telephonenumber"><spring:message code='ezOrgan.t95' /></option>
					                            <option value="mobile"><spring:message code='ezOrgan.t96' /></option>
					                            <option value="HomePhone"><spring:message code='ezOrgan.t97' /></option>
					                            <option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98' /></option>
					                            <option value="mail"><spring:message code='ezOrgan.t99' /></option>
					                            <option value="streetAddress" style="display:none"><spring:message code='ezOrgan.t100' /></option>
	                                        </select>
	                                        <input type="text" id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; height:22px; margin: 0px;">
	                                        <a class="imgbtn"><span onclick="search_click()"><spring:message code='ezOrgan.t101' /></span></a>&nbsp;
	                                        <a class="imgbtn"><span onclick="add_deptparment()"><spring:message code='ezOrgan.t80' /></span></a>&nbsp;
	                                    </div>
	                                </td>    
	                                <td></td>
	                            </tr>
	                        </table>
	                    </div>
	                </div>
	                <table style="margin-top: 4px;">
	                    <tr>
	                        <td class="box">
	                            <div style="width: 250px; height: 472px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
	                        </td>
	                        <td></td>
	                        <td class="listview" style="width: 426px" id="orglistView">
	                            <table style="width: 100%; margin-top: -1px; height:35px" class="popup_mainlist">
	                                <tr>
	                                    <th style="white-space:normal;background-color: white;border-top:0px;border-bottom:1px solid #eaeaea">
											<span id="SelectDeptNM" style="font-weight: normal; width: 380px; height: 18px; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
	                                        <span style="float:right;">
	                                            <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                            <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                        </span>
	                                    </th>
	                                </tr>
	                            </table>
	                            <div style="vertical-align: top; height: 440px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
	                                    <tr>
	                                        <td style="width: 170px; color:#333;background-color: #f8f8fa;" class="td_gray"><spring:message code='ezOrgan.t67' /></td>
	                                        <td style="width: 150px; color:#333;background-color: #f8f8fa;" class="td_gray"><spring:message code='ezOrgan.t69' /></td>
	                                        <td class="td_gray" style="color:#333;background-color: #f8f8fa;"><spring:message code='ezOrgan.t97' /></td>
	                                    </tr>
	                                </table>
	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
	                                    <tr>
	                                        <td style="width: 130px; color:#333;background-color: #f8f8fa;" class="td_gray"><spring:message code='ezOrgan.t68' /></td>
	                                        <td style="width: 90px; color:#333;background-color: #f8f8fa;" class="td_gray"><spring:message code='ezOrgan.t67' /></td>
	                                        <td style="width: 90px; color:#333;background-color: #f8f8fa;" class="td_gray"><spring:message code='ezOrgan.t69' /></td>
	                                        <td class="td_gray" style="color:#333;background-color: #f8f8fa;"><spring:message code='ezOrgan.t97' /></td>
	                                    </tr>
	                                </table>
	                            </div>
	                            <div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
	                    	</td>        
	                    </tr>
	                </table>
	            </td>        
	            <td style="text-align:center; padding-left:3px;">
	                <img src="../../../images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver()"><br>
	                <img src="../../../images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver()">
	            </td>
	            <td style="vertical-align:top; padding-top:4px; padding-left:3px;">
	                <table>
	                    <tr>
	                        <td>
	                            <h2 class="receiver_tltype01">
	                                <span style="min-width: 45px;"><spring:message code="ezNotification.hth61"/></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="notiTargetListDiv" style="width: 300px; Height: 440px; overflow-x: auto; overflow-y: auto;" ondblclick="DeleteReceiver()"></div>
	                            </div>
	                            <table class="content" style="width: 100%;">
					            	<tbody>
					                	<tr>
					                    	<th><spring:message code='ezBoard.t999025' /></th>
					                    	<td>
												<div class='custom_checkbox'><input type="checkbox" id="admin_OK" onclick="checkbox_onclick(event)"></div>&nbsp;<spring:message code="ezNotification.hth70"/>
												<div class='custom_checkbox'><input type="checkbox" id="admin_NO" onclick="checkbox_onclick(event)"></div>&nbsp;<spring:message code="ezNotification.hth71"/>
						                    </td>
					                	</tr>
					            	</tbody>
					        	</table>
	                        </td>
	                    </tr>                    
	                </table>                                      
	            </td>
	        </tr>
	    </table>	
	</body>	
</html>