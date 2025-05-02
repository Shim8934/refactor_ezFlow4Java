<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezOrgan.t00004' /></title>
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
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript" language="javascript">
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
		    var isfirst = true;
		    var deptTreeTopId = "${deptTreeTopId}";
			var isAdmin = "${isAdmin}";
			var delType = "<c:out value='${DelType}'/>";
			var type = "<c:out value='${type}'/>";
			var companyId = "<c:out value='${companyID}'/>";
			var totalCnt = 0;
	        var CurPage = 1;
	        var totalPage = 0;
	        var pageSize = 1000;
	        var BlockSize = 10;
	        var orginArry = new Array();
	        var extraArry = new Array();
	        var deleteArry = new Array();
			var packageType = "${packageType}";
			
			// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/사용자 별 권한 설정 옵션에 따른 변수 삽입
			var permissionBasisDeptYN = "${permissionBasisDeptYN}"
			
		    $(document).ready(function(){
		    	try {
	                ReturnFunction = opener.permissions_check_dialogArguments[1];
	            } catch (e) {console.log(e);}

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
		        } catch (e) {console.log(e);}
	
		        popupTitle();
				var top = (type ==='c=1') ? "top" : deptTreeTopId + "/organ"
		        var strQuery = "<DATA><DEPTID></DEPTID><TOPID>" + top + "</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT><ADMINORGAN>y</ADMINORGAN></DATA>";
		        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		        xmlHTTP.onreadystatechange = event_GetDeptTreeInfo;
		        xmlHTTP.send(strQuery);
	
		        ListTypeChangeIcon();
			        
		        var Resultxml = loadXMLString(PermissionList.innerHTML.toUpperCase());
		        var pUserList = new ListView();
		        pUserList.SetID("lvPermissionBasic");
		        pUserList.SetMulSelectable(false);
		        pUserList.SetHeightFree(true);
		        pUserList.DataSource(Resultxml);
		        pUserList.DataBind("PermissionBasic"); 
		        
		        ChangeListView_onClick(getOrganListType());
		        
		        if (isAdmin == "false") {
		        	$("#lvPermissionBasic").find("tbody tr:first").css("display","none");
		        }
		        
		        Permissions_List();
		    });
		    
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
		        createNodeAndInsertText(xmlpara, objNode, "DISPLAY_TRASH_DEPT", "");
				createNodeAndInsertText(xmlpara, objNode, "ADMINORGAN", "y");

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
		        p_ListOrderObject = null;
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        nodeIdx = treeView.GetSelectNode();
        		document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" 
        		+ "<span id='spn_deptName' title='" + nodeIdx.GetNodeData("VALUE") + "'>" + nodeIdx.GetNodeData("VALUE") + "</span>"
        		+ "<span id='countInfo'></span>";
		        SelectDeptNM.setAttribute("countinfo", "")

		        //if (cn != "") {
		        if (isfirst && cn != "") {
		            document.getElementById('search_type').selectedIndex = 1;
		            document.getElementById('keyword').value = cn;
		            
		            $.ajax({
			        	type : "POST",
			        	dataType : "text",
			        	url : "/ezOrgan/getSearchList.do",
			        	async : false,
			        	data : {search : "cn::" + cn, cell : "company;description;displayname;title;telephonenumber;"+ document.getElementById("search_type").value, prop : 'mail;displayName;description;title;company;telephoneNumber;extensionAttribute1', type : 'user', adminOrgan : "y", noAddJob : "Y"},
			        	success : function(xml){
			        		result=loadXMLString(xml);
			        		var headerData = createXmlDom();
		                    headerData = result;
// 		                    headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());

		                    if (CrossYN()) {
		                        var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                        var Node = headerData.importNode(xmlRtn, true);
		                        headerData.documentElement.appendChild(Node);
		                    } else {
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
			        		alert("<spring:message code='ezOrgan.t9' />" + error);
			        	}
			        });			           
		        } else {
		            displayUserList(nodeIdx.GetNodeData("CN"));
		        }
		    }
		    
		    function displayUserList(DeptID) {
		    	$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : DeptID, cell : "company;description;displayName;title;telephoneNumber", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;extensionAttribute1;usertype;department;extensionAttribute7", type : "user", noAddJob : "Y", adminOrgan : 'y'},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		var headerData = createXmlDom();
// 		                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
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
			        			document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='txt_color'>" + result.totalCount + "</span> / <span class='txt_color'>" + result.totalCount2 + "</span>";
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
	                    M_TR.ondblclick = function () { event_listdblclick(this)};
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
	                        M_TR_IMG.setAttribute('onerror', "this.style.display='none'");
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
	                    
	                    // 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/사용자 별 권한 설정 옵션에 따라 부서, 직위 정보를 다루게 됨에 따라, 
	                    // DATA의 셀이 _DATA12 이후로 두 번호씩 밀려 해당부분 수정하였으며, 검색 개선에 따라 검색했을 때에도 _DATA21이 겸직여부라 분기 삭제함
	                    if($(M_TR).attr("_DATA22" ) == "addJob") {
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
	                    M_TR.ondblclick = function () { event_listdblclick(this)};
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
	                        if($(M_TR).attr("_DATA22") == "addJob") {
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
	                        if($(M_TR).attr("_DATA22") == "addJob") {
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
	        var listEventCheckbox = false;
	        var listSubEventCheckbox = false;
	        function event_listclick(obj) {
	            if (!listEventCheckbox) {
	                if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                        
							if(p_ListOrderObject != null){
		                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                        }
							}
	                    }
	                    listContentArry = new Array();
	                }
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
	            //Permissions_Check(GetAttribute(p_ListOrderObject, "_data2")); 
	        } 
	        
	        //더블 클릭 할 때
	        function event_listdblclick(elem) {
	        	InsertReceiver("lvPermissionList");
	        }
	        /* function Permissions_Check(UserID) {
	            var listview = new ListView();
	            listview.LoadFromID("lvUserList");

	            var xmlDom = createXmlDom();
	            
	            var addJob = GetAttribute(p_ListOrderObject, "_data19");
	            if (addJob == "addJob") {
	            	document.getElementById('UserAclList').innerHTML = "";
	            	return;
	            }
	            
	            $.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/getEntryInfo.do",
					async : false,
					data : {cn : UserID, prop : "extensionAttribute1", pMode : "user" },
					success : function(xml){
						result=loadXMLString(xml);
						xmlDom = result;
		                var AclList = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE1").toLowerCase().trim();
		                
		                if (AclList != "") {
		                    var Permission = loadXMLString(PermissionList.innerHTML.toUpperCase());
		                    var AclArray = AclList.split(';');
		                    var UserACL = "";
		                    var LISTVIEWDATA = "<LISTVIEWDATA><ROWS>";
		                    
		                    for (var j = 0; j < AclArray.length - 1; j++) {
		                        for (var i = 0; i < Permission.documentElement.getElementsByTagName("ROW").length; i++) {
		                            var AclValue = AclArray[j].split('=');

		                            if (getNodeText(GetChildNodes(GetChildNodes(Permission.documentElement.getElementsByTagName("ROW")[i])[0])[1]) == AclValue[0].toUpperCase()) {
		                                if (AclValue[1] == "1") {
		                                    LISTVIEWDATA = LISTVIEWDATA + "<ROW><CELL>";
		                                    LISTVIEWDATA = LISTVIEWDATA + "<VALUE>";
		                                    LISTVIEWDATA = LISTVIEWDATA + getNodeText(GetChildNodes(GetChildNodes(Permission.documentElement.getElementsByTagName("ROW")[i])[0])[0]);
		                                    LISTVIEWDATA = LISTVIEWDATA + "</VALUE>";
		                                    LISTVIEWDATA = LISTVIEWDATA + "<DATA1>";
		                                    LISTVIEWDATA = LISTVIEWDATA + getNodeText(GetChildNodes(GetChildNodes(Permission.documentElement.getElementsByTagName("ROW")[i])[0])[1]);
		                                    LISTVIEWDATA = LISTVIEWDATA + "</DATA1>";
		                                    LISTVIEWDATA = LISTVIEWDATA + "</CELL></ROW>";
		                                }
		                            }
		                        }
		                    }
		                    LISTVIEWDATA = LISTVIEWDATA + "</ROWS></LISTVIEWDATA>";
		                    document.getElementById('UserAclList').innerHTML = "";                   
		                } else {
		                    LISTVIEWDATA = "<LISTVIEWDATA><ROWS></ROWS></LISTVIEWDATA>";
		                    document.getElementById('UserAclList').innerHTML = "";
		                }
		                var Resultxml = loadXMLString(LISTVIEWDATA);
		                var pAclList = new ListView();
		                pAclList.SetID("lvAclList");
		                pAclList.SetMulSelectable(false);
		                pAclList.SetHeightFree(true);
		                pAclList.DataSource(Resultxml);
		                pAclList.DataBind("UserAclList");
					}
				});
	        } */
	        
	        //선택한 사원을 오른쪽 리스트에 삽입할 때
	        function InsertReceiver(elem) {
	        	var listid = "lvPermissionBasic";
	        	var getlistview = new ListView();
	            getlistview.LoadFromID(listid);
	        	var pparsingXML2 = "";
        		var pparsingXML = "";
	            var arrRows = getlistview.GetSelectedRows();
	            var length = arrRows.length;
	            var dataMatch = "";
	            var pattern = new RegExp(delType);
	            
	            var addJob = "";
	            if (pSeach){
		            addJob = GetAttribute(p_ListOrderObject, "_data21");
	            } else {
		            addJob = GetAttribute(p_ListOrderObject, "_data22");
	            }
	            
	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert(strLang13);
	                return;
	            } else if(addJob == "addJob" && permissionBasisDeptYN != "Y") {
	            	alert("<spring:message code='ezOrgan.psb01' />");
	                return;
	            } else {
	            	var strId = p_ListOrderObject.getAttribute("_data2");
	            	var strName = p_ListOrderObject.getAttribute("_data4");
	            	var strMail = p_ListOrderObject.getAttribute("_data3");
					var strDeptID = p_ListOrderObject.getAttribute("_data12");
					var strJobID = p_ListOrderObject.getAttribute("_data13");
	            	var strData = p_ListOrderObject.getAttribute("_data10");
	            	var strDept = p_ListOrderObject.getAttribute("_data16");
	            	var strTitleName = p_ListOrderObject.getAttribute("_data6"); // 우측 권한리스트에 직위 컬럼 추가
	            	var isThisAddJob = p_ListOrderObject.getAttribute("_data22"); // 겸직여부 확인
	            	var strDept = p_ListOrderObject.getAttribute("_data5");
	            	
	            	if (strData == null || strData == "") {
	            		strData = "c=0;k=0;g=0;a=0;n=0;l=0;q=0;w=0;f=0;e=0";
	            	}
	            	
	            	var _listView = new ListView();
	            	_listView.LoadFromID("lvPermissionList");
	            	var arrRows = _listView.GetDataRows();
	            	
	            	for (var i =0; i < arrRows.length; i++) {
	            		if (strId == arrRows[i].getAttribute("data1")) {
	            		// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/사용자 별 권한 설정 옵션에 따른 분기 추가
	            		// 리스트뷰 객체의 각 tr에 "data5" 속성으로 부서 ID 삽입
	            		    if (permissionBasisDeptYN == "Y") {
	            		        if (strDeptID == arrRows[i].getAttribute("data5") && strJobID == arrRows[i].getAttribute("data6")) {
                                    alert("<spring:message code='ezOrgan.mse2' />");
                                    return;
                                }
	            		    } else {
                                alert("<spring:message code='ezOrgan.mse2' />");
                                return;
	            		    }
	            		}
	            	}
	            	
	            	for (var i=0; i < deleteArry.length; i++) {
	            	    // 2023-08-17 전인하 - 권한 등록/수정 리스트 동작 시 부서, 직위 데이터를 추가하여 겸직권한이 잘못 조작되지 않도록 수정
	            		if (strId == deleteArry[i].data1 && strDeptID == deleteArry[i].data4 && strJobID == deleteArry[i].data5) {
	            			deleteArry.splice(i, 1);
	            		}
	            	}
	            	
	            	
	            	dataMatch = pattern.exec(strData);
	            	
	            	//권한관리 type 데이터 값이 없을 때
	            	if (dataMatch == null || dataMatch == "") {
	            		strData += delType + "=0";
	            	}
	            	
	            	        var extraInfo = new Object();
			                var tempDelType = delType;
			                var DelValue = tempDelType + "=1";
			                
			                if (tempDelType == "") {
			                    tempDelType = "c=0";
			                } else {
			                    tempDelType = tempDelType + "=0";
			                }
			                
			                strData = strData.replace(tempDelType, DelValue);
			                
			                extraInfo.data1 = strId;
			                extraInfo.data2 = strData;
			                extraInfo.data3 = DelValue; // 2022-01-20 이사라 - 변경하는 권한
							extraInfo.data4 = strDeptID; // 2023-07-31 전인하 - 해당 권한의 부서 ID
							extraInfo.data5 = strJobID; // 2023-07-31 전인하 - 해당 권한의 직위 ID
			                
			                extraArry.push(extraInfo);
			                
			                dataMatch = "";
			                
			                console.log(extraArry);
			                pparsingXML2 = "";
		            		pparsingXML = "";
		            		pparsingXML2 = "<LISTVIEWDATA><ROWS>";
		            		pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
		            		pparsingXML = pparsingXML + "<DATA2>" + strData + "</DATA2>";
		            		pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(strName) + "</DATA3>";
		            		pparsingXML = pparsingXML + "<DATA4>" + strMail + "</DATA4>";
							pparsingXML = pparsingXML + "<DATA5>" + strDeptID + "</DATA5>";
							pparsingXML = pparsingXML + "<DATA6>" + strJobID + "</DATA6>";
		            		pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + "</VALUE>";
		            		pparsingXML = pparsingXML + "<CLASSNAME>userName</CLASSNAME></CELL>";
		            		pparsingXML = pparsingXML + "<CELL><VALUE>" + MakeXMLString(strDept) + "</VALUE></CELL></ROW>";
	            		    if (isThisAddJob == "addJob") {  // 우측 권한리스트에 직위 컬럼 추가, 겸직 정보 삽입
		            		    pparsingXML = pparsingXML + "<CELL><VALUE>" + "<spring:message code='ezOrgan.psb03'/> " + MakeXMLString(strTitleName) + "</VALUE></CELL></ROW>";
		            		} else {
		            		    pparsingXML = pparsingXML + "<CELL><VALUE>" + MakeXMLString(strTitleName) + "</VALUE></CELL></ROW>";
		            		}
		            		pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA>";
		            		Resultxml = loadXMLString(pparsingXML2);
			                
		            		var listview = new ListView();
		            		listview.LoadFromID("lvPermissionList");
		            		
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
		        		    if (MaxCntNum != 0)
				                MaxCntNum = MaxCntNum + 1;
		            		SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + (MaxID + 1));
		            		listview.AddDataRow(objTr, Resultxml);
	            }
	        	
	            /* var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strSIP = "";
	            var pAddFlag = false;
	            var listid = "lvPermissionBasic";
	            var getlistview = new ListView();
	            getlistview.LoadFromID(listid);

	            var arrRows = getlistview.GetSelectedRows();
	            var length = arrRows.length;
	            
	            var addJob = GetAttribute(p_ListOrderObject, "_data19");

	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert(strLang13);
	                return;
	            } else if(addJob == "addJob"){
	            	alert("<spring:message code='ezOrgan.psb01' />");
	                return;
	            } else {
	                var UserAcllistview = new ListView();
	                UserAcllistview.LoadFromID("lvAclList");
	                var strId = GetAttribute(arrRows[0], "data1");
	                var strName = GetChildNodes(arrRows[0])[0].innerText;
	                var bFlag = UserAcllistview.ExistRow("data1", strId);

	                if (bFlag) {
	                    alert(strLang25);
	                    pAddFlag = true;
	                } else {
	                    pparsingXML2 = "";
	                    pparsingXML = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                    Resultxml = loadXMLString(pparsingXML2);

	                    var listview = new ListView();
	                    listview.LoadFromID("lvAclList");

	                    var MaxID = 0;
	                    var InitTr = listview.GetDataRows();
	                    var MaxCntNum = 0;

	                    for (var j = 0  ; j < listview.GetRowCount() ; j++) {
	                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                        
	                        if (MaxID < curnum) {
	                            MaxID = curnum;
	                            MaxCntNum = j;
	                        }
	                    }
	                    var objTr = listview.AddRow(listview.GetRowCount());
	                    
	                    if (MaxCntNum != 0) {
	                        MaxCntNum = MaxCntNum + 1;
	                    }
	                    SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                    listview.AddDataRow(objTr, Resultxml);

	                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                    
	                    for (var y = 0; y < _tdlength; y++) {
	                        document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                        document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                    }
	                }
	            } */
	        }

	        function DeleteReceiver() {
	            var listid = "lvPermissionList";
	            var selList = new ListView();
	            selList.LoadFromID(listid);

	            var arrRows = selList.GetSelectedRows();
	            var strId = arrRows[0].getAttribute("data1");
	            var strData = arrRows[0].getAttribute("data2")
	            var strDeptID = arrRows[0].getAttribute("data5");
	            var strJobID = arrRows[0].getAttribute("data6")
	            
	            var tempDelType = delType;
			    var DelValue = tempDelType + "=0";
			                
			    if (tempDelType == "") {
			        tempDelType = "c=0";
			    } else {
			        tempDelType = tempDelType + "=1";
			    }
			    strData = strData.replace(tempDelType, DelValue);
			    
			    for (var i=0; i < extraArry.length; i++) {
			        // 2023-08-17 전인하 - 권한 등록/수정 리스트 동작 시 부서데이터를 추가하여 겸직권한이 엉뚱하게 조작되지 않도록 조치함
            		if (strId == extraArry[i].data1 && strDeptID == extraArry[i].data4 && strJobID == extraArry[i].data5) {
            			extraArry.splice(i, 1);
            			console.log(extraArry);
            		}
            	}
			    
			    var deleteInfo = new Object();
			    deleteInfo.data1 = strId;
			    deleteInfo.data2 = strData;
			    deleteInfo.data3 = DelValue; // 2022-01-20 이사라 - 변경하는 권한
			    deleteInfo.data4 = strDeptID; // 2023-07-31 전인하 - 해당 권한의 부서 ID
			    deleteInfo.data5 = strJobID; // 2023-07-31 전인하 - 해당 권한의 job ID
			    
			    deleteArry.push(deleteInfo);
			    
			    console.log(deleteArry);

	            for (var i = 0; i < arrRows.length; i++) {
	                selList.DeleteRow(arrRows[i].id);
	            }
	        }
	        
	        String.prototype.trim = function () {
	            return this.replace(/(^\s*)|(\s*$)/g, "");
	        }
	        
	        function keyword_Clear() {
	            document.getElementsByName('keyword').value = "";
	        }
	        
	        function close_Click() {
	            if (ReturnFunction!=null) {
	                ReturnFunction();
	            }
	            window.close();
	        }

	        var rgParams = new Array();
		    var checkname2_cross_dialogArguments = new Array();
		    function deptsearch_click() {
		        if (document.all("deptkeyword").value == "") {
		        	alert("<spring:message code='ezOrgan.t56' />");
		            document.all("deptkeyword").focus();
		            return;
		        }

		        if ($.trim($("#deptkeyword").val()) == "") {
		        	alert("<spring:message code='ezOrgan.jsh1' />");
		            document.all("deptkeyword").focus();
		            return;
		        }

		        var xmlDOM = createXmlDom();
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : false,
		        	data : {search : "displayname::" + encodeURIComponent(document.all("deptkeyword").value), cell : "extensionAttribute3;displayname;extensionAttribute9;", prop : "cn", type : 'group', adminOrgan : "y", noAddJob : "Y"},
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
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>" + deptTreeTopId + "</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT><ADMINORGAN>y</ADMINORGAN></DATA>";
		            } else {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>" + deptTreeTopId + "</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT><ADMINORGAN>y</ADMINORGAN></DATA>";
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
		                try { OpenWin.focus(); } catch (e) {console.log(e);}
		            }else{
		                var feature = "dialogHeight:320px; dialogWidth:600px; status:no;scroll:no; help:no; edge:sunken";
		                feature = feature + GetShowModalPosition(600, 320);
		                window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, feature);

		                if (rgParams["deptid"] != "") {
		                    bSearch = true;
		                    g_xmlHTTP = createXMLHttpRequest();
		                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + deptTreeTopId + "</TOPID><PROP>mail</PROP><ADMINORGAN>y</ADMINORGAN></DATA>";
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
		            var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + deptTreeTopId + "</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT><ADMINORGAN>y</ADMINORGAN></DATA>";
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
		                    } catch (e) {console.log(e);}
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
				p_ListOrderObject = null;
				if (keyword.value == ""){
					alert("<spring:message code='ezOrgan.t56' />");
					keyword.focus();
					return;
				}			   
				$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",		        	
		        	data : {search : document.getElementById("search_type").value + "::" + encodeURIComponent(document.getElementById("keyword").value), cell : "company;description;displayname;title;telephonenumber;" + document.getElementById("search_type").value, 
		        			prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;extensionAttribute1;userType;department;extensionAttribute7", type : "user", adminOrgan : "y", noAddJob : "N"}, // noAddJob 플래그 변경 - 필요함.
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
						alert("<spring:message code='ezOrgan.t9' />" + error);
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
					p_ListOrderObject = null;
					search_click();
				}
			}
		    
		    function OK_Click() {
		    	var totalArry = new Array();
		    	var data1 = new Array();
		    	var data2 = new Array();
				var data3 = new Array();
				// 2023-07-31 전인하 - 변경된 권한 정보를 저장할 때, data4 배열에 부서정보 담아 반환 - 컨트롤러에서 처리
		    	var data4 = new Array(); 
		    	var data5 = new Array();
		    	
		    	totalArry = extraArry.concat(deleteArry);
		    	
		        for (var i=0; i<totalArry.length; i++){
		        	data1.push(totalArry[i].data1);
			        data2.push(totalArry[i].data2);
			        data3.push(totalArry[i].data3);
					data4.push(totalArry[i].data4);
					if (totalArry[i].data5 == '') { // jobId가 없음 - 원직일 경우
					    data5.push('empty');
					} else {
					    data5.push(totalArry[i].data5);
					}
		        }

				if(data1.length == 0 || data2.length == 0) {
					if(document.getElementById('lvPermissionList').children[1].childElementCount == 0) {
						alert("<spring:message code='ezAttitude.t52' />");
						return;
					}
					alert(strLang14);
					window.close();
					return;
		        }
				jQuery.ajaxSettings.traditional = true; 
		        $.ajax({
	            	type : "POST",
	            	dataType : "text",
	            	url : "/admin/ezOrgan/saveStoreUserInfo.do",
	            	async : false,
					data : {parentCn : "", cn : data1, extensionAttribute1 : data2, permissionChType : data3, dept: data4, job: data5},
	            	success : function(result){
	            		 alert(strLang14);
	            	
	            	if (ReturnFunction!=null) {
	     	            ReturnFunction();
	     	        }
	            		window.close();
	            	},
	            	error : function(){
	            		alert(strLang15);
	            	}
	            });
	            /* var PermissionList = new ListView();
	            PermissionList.LoadFromID("lvPermissionBasic");

	            var Acllistview = new ListView();
	            Acllistview.LoadFromID("lvAclList");

	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert(strLang13);
	                return;
	            }
	     
	            var AclList = "";
	            var AclText = "";
	            
	            for (var i = 0; i < PermissionList.GetRowCount() ; i++) {
	                AclList += GetAttribute(PermissionList.GetDataRows()[i], "data1").toLowerCase() + "=0;";
	            }

	            for (var j = 0; j < Acllistview.GetRowCount() ; j++) {
	                var AclCheck = GetAttribute(Acllistview.GetDataRows()[j], "data1").toLowerCase() + "=1";
	                AclList = AclList.replace(GetAttribute(Acllistview.GetDataRows()[j], "data1").toLowerCase() + "=0", GetAttribute(Acllistview.GetDataRows()[j], "data1").toLowerCase() + "=1");
	                AclText += "- " + GetChildNodes(Acllistview.GetDataRows()[j])[0].innerText + "<br>";
	            }

	            $.ajax({
	            	type : "POST",
	            	dataType : "html",
	            	url : "/admin/ezOrgan/saveUserInfo.do",
	            	async : false,
	            	data : {parentCn : "", cn : GetAttribute(p_ListOrderObject, "_data2"), extensionAttribute1 : AclList},
	            	success : function(result){
	            		//TODO : 2016-05-03 장진혁과장 -- Email 전송메소드 구현 필요
	            		//sendmail(GetAttribute(p_ListOrderObject, "_data2"), strLang18, AclText)
	            		
	            		if (result == 'CHECKPERMISSION') {
	            		    alert(strLang31);
	            		} else {
	            		    alert(strLang14);
	            		}
	            	},
	            	error : function(){
	            		alert(strLang15);
	            	}
	            }); */
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
		    
	        function Permissions_List() {
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/getPopUpPermissionsList.do",		        	
		        	data : {companyID : companyId, type : type, pageNum : CurPage, pageSize : pageSize, searchType : "", searchValue : ""},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		if (result.xml != "") {
		                    if (result.documentElement.getElementsByTagName("TOTALCNT")[0] != null) {
		                        totalCnt = getNodeText(result.documentElement.getElementsByTagName("TOTALCNT")[0]);
		                        totalPage = Math.ceil(new Number(totalCnt / pageSize));
		                    }
		                } else {
		                    totalCnt = 0;
		                    totalPage = 0;
		                }
		                var xmldom = result;
		                var headerData = createXmlDom();
		                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
		                
		                if (CrossYN()) {
		                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		                    var Node = headerData.importNode(xmlRtn, true);
		                    headerData.documentElement.appendChild(Node);
		                } else {
		                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		                    headerData.documentElement.appendChild(xmlRtn);
		                }

		                document.getElementById("PermissionPopUpList").innerHTML = "";

		                var listview = new ListView();
		                listview.SetID("lvPermissionList");
		                listview.SetMulSelectable(false);
		                //listview.SetRowOnClick("PermissionsPopUp_View");
		                listview.SetRowOnDblClick("DeleteReceiver");
		                listview.SetHeightFree(true);
		                listview.DataSource(headerData);
		                listview.DataBind("PermissionPopUpList");
		                
		                var a = document.getElementById("lvPermissionList_THEAD");
		                var noclick = document.getElementById("lvPermissionList_TR_0");
		                
		                if (noclick == null || noclick == "") {
		                	a.style.display = "none";
		                } else {
			                noclick.style.backgroundColor = "rgb(255, 255, 255)";
			                noclick.setAttribute("selected", "false");
			                $("#lvPermissionList_TR_0").mouseout(function(){
			                	$("#lvPermissionList_TR_0").css("background-color", "rgb(255, 255, 255)");
		                });
		                }
		                a.style.display = "none";
		               
		                
		        	},
		        	error : function(error){
		        	    alert("<spring:message code='ezOrgan.mse8'/>" + error);
		        	}
		        });		        
		    }
	        
	        function popupTitle() {
	        	var titleTxt_c = "<spring:message code='ezOrgan.t291' />";
	        	var titleTxt_k = "<spring:message code='ezOrgan.t293' />";
	        	var titleTxt_g = "<spring:message code='ezOrgan.t295' />";
	        	var titleTxt_a = "<spring:message code='ezOrgan.t292' />";
	        	var titleTxt_i = "<spring:message code='ezOrgan.t294' />";
	        	var titleTxt_n = "<spring:message code='ezOrgan.t297' />";
	        	var titleTxt_l = "<spring:message code='ezOrgan.t296' />";
	        	var titleTxt_w = "<spring:message code='ezOrgan.t301' />";
	        	var titleTxt_m = "<spring:message code='ezOrgan.t300' />";
	        	var titleTxt_q = "<spring:message code='ezOrgan.lhj1' />";
	        	var titleTxt_f = "<spring:message code='ezOrgan.t303' />";
	        	var titleTxt_e = "<spring:message code='ezOrgan.kbm01' />";
	        	var titleTxt_s = "<spring:message code='ezOrgan.t9904' />";	// 준법지원인
	        	var titleTxt_v = "<spring:message code='ezOrgan.lhr01' />";
	        	
	        	var titleTxt = "";

	        	if (delType == "c") {
	        	    titleTxt = titleTxt_c;
	        	} else if (delType == "k") {
	        	    titleTxt = titleTxt_k;
	        	} else if (delType == "g") {
	        	    titleTxt = titleTxt_g;
	        	} else if (delType == "a") {
	        	    titleTxt = titleTxt_a;
	        	} else if (delType == "i") {
	        	    titleTxt = titleTxt_i;
	        	} else if (delType == "n") {
	        	    titleTxt = titleTxt_n;
	        	} else if (delType == "l") {
	        	    titleTxt = titleTxt_l;
	        	} else if (delType == "w") {
	        	    titleTxt = titleTxt_w;
	        	} else if (delType == "m") {
	        	    titleTxt = titleTxt_m;
	        	} else if (delType == "q") {
	        	    titleTxt = titleTxt_q;
	        	} else if (delType == "f") {
	        	    titleTxt = titleTxt_f;
	        	} else if (delType == "e") {
	        	    titleTxt = titleTxt_e;
	        	} else if (delType == "s") {
	        	    titleTxt = titleTxt_s;
	        	}

	        	document.getElementById("subtitle").innerText = titleTxt;
	        	document.getElementById("PermissionStr").innerText = titleTxt;
	        }
	        
	    </script>
	</head>
	<body class="popup">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t67'/></NAME>
						<WIDTH>40</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t69'/></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t97'/></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<xml id="PermissionList" style="display:none">
			<LISTVIEWDATA>
				<ROWS>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t291'/></VALUE>
			                <DATA1>c</DATA1>
			            </CELL>
			        </ROW>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t293'/></VALUE>
			                <DATA1>k</DATA1>
			            </CELL>
			        </ROW>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t295'/></VALUE>
			                <DATA1>g</DATA1>
			            </CELL>
			        </ROW>
			        <c:if test="${packageType eq 'standard'}">
				        <ROW>
				            <CELL>            
				                <VALUE><spring:message code='ezOrgan.t292'/></VALUE>
				                <DATA1>a</DATA1>
				            </CELL>
				        </ROW>
				        <c:if test="${approvalFlag eq 'G'}">
				        <ROW>
				            <CELL>            
				                <VALUE><spring:message code='ezOrgan.t294'/></VALUE>
				                <DATA1>i</DATA1>
				            </CELL>
				        </ROW>
				        </c:if>
			        </c:if>
			        <c:if test="${packageType ne 'mail'}">
				        <ROW>
				            <CELL>            
				                <VALUE><spring:message code='ezOrgan.t297'/></VALUE>
				                <DATA1>n</DATA1>
				            </CELL>
				        </ROW>
					</c:if>
			        <c:if test="${packageType eq 'standard'}">
				        <ROW>
				            <CELL>            
				                <VALUE><spring:message code='ezOrgan.t296'/></VALUE>
				                <DATA1>l</DATA1>
				            </CELL>
				        </ROW>
				        <c:if test="${approvalForDoc == 'Y'}">
				        <ROW>
				            <CELL>
				                <VALUE><spring:message code='ezOrgan.lhj1'/></VALUE>
				                <DATA1>q</DATA1>
				            </CELL>
				        </ROW>
				        </c:if>
	                    <c:if test="${approvalFlag != 'S'}">
				        <ROW>
				            <CELL>            
				                <VALUE><spring:message code='ezOrgan.t301'/></VALUE>
				                <DATA1>w</DATA1>
				            </CELL>
				        </ROW>
				        <ROW>
				            <CELL>            
				                <VALUE><spring:message code='ezOrgan.t300'/></VALUE>
				                <DATA1>m</DATA1>
				            </CELL>
				        </ROW>   
	                    </c:if>
	                    <c:if test="${useWebfolder == 'YES'}">
	                    <ROW>
				            <CELL>            
				                <VALUE><spring:message code='ezOrgan.t303'/></VALUE>
				                <DATA1>f</DATA1>
				            </CELL>
				        </ROW>
				        </c:if>
				        <c:if test="${use_attitude == 'YES'}">
	                    <ROW>
				            <CELL>            
				                <VALUE><spring:message code='ezOrgan.kbm01' /></span></VALUE>
				                <DATA1>a1</DATA1>
				            </CELL>
				        </ROW>
				        </c:if>
			        </c:if>
				</ROWS>
			</LISTVIEWDATA>
		</xml>
	    <div id="menu">
	    	<h1 id="subtitle" class="authorText"></h1>
	    </div>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()"></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
	    <table id="TreeViewTD" style="margin-top:20px;">
	        <tr>
	            <td>
	                <div class="portlet_tabpart03" style="background-color: #f8f8fa; margin: 0px; padding: 0px; border: 1px solid #eaeaea;">
	                    <div class="portlet_tabpart03_top" id="tab1">
	                        <table style="margin-top: 3px; width: 100%;">
	                            <tr>
	                                <td>
	                                	<div style="padding-left:5px;">
	                                    	<input type="text" name="Input" id="deptkeyword" style="WIDTH: 120px; height:25px;" onkeypress="deptsearch_press()" />
	                                        <a class="imgbtn"><span onclick="deptsearch_click()"><spring:message code='ezOrgan.t93'/></span></a>
	                                	</div>
	                                </td>
	                                <td>
	                                    <div style="float:right; padding-right:5px;">
	                                        <select id="search_type" style="height:22px;">
	                                            <option selected value="displayname"><spring:message code='ezOrgan.t67'/></option>
					                            <option value="cn"><spring:message code='ezOrgan.t94'/></option>
					                            <option value="description"><spring:message code='ezOrgan.t68'/></option>
					                            <option value="title"><spring:message code='ezOrgan.t69'/></option>
					                            <option value="telephonenumber"><spring:message code='ezOrgan.t95'/></option>
					                            <option value="mobile"><spring:message code='ezOrgan.t96'/></option>
					                            <option value="HomePhone"><spring:message code='ezOrgan.t97'/></option>
					                            <option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98'/></option>
					                            <option value="mail"><spring:message code='ezOrgan.t99'/></option>
					                            <option value="streetAddress" style="display:none"><spring:message code='ezOrgan.t100'/></option>
	                                        </select>
	                                        <input type="text" id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; height:25px; margin: 0px;" />
	                                        <a class="imgbtn"><span onclick="search_click()"><spring:message code='ezOrgan.t101'/></span></a>
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
	                            <div style="width: 250px; height: 473px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
	                        </td>
	                        <td></td>
	                        <td class="listview" style="width: 426px" id="orglistView">
	                            <table style="width: 100%; margin-top: -1px; height:35px;" class="popup_mainlist">
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
	                            <div style="vertical-align: top; height: 441px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
	                                    <tr>
	                                        <td style="width: 170px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t67'/></td>
	                                        <td style="width: 150px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t69'/></td>
	                                        <td class="td_gray" style="color:#333;background-color: #f8f8fa"><spring:message code='ezOrgan.t95'/></td>
	                                    </tr>
	                                </table>
	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
	                                    <tr>
	                                        <td style="width: 130px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t68'/></td>
	                                        <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t67'/></td>
	                                        <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t69'/></td>
	                                        <td class="td_gray" style="color:#333;background-color: #f8f8fa"><spring:message code='ezOrgan.t95'/></td>
	                                    </tr>
	                                </table>
	                            </div>
	                            <div style="vertical-align: top; text-align: center; height: 441px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
	                        </td>    
	                    </tr>
	                </table>
	            </td>
	                 <td style="width: 30px; text-align: center;">                            
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver(this)"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver()">
	                 </td>   
	            <td style="vertical-align:top; padding-top:4px; padding-left:4
	            px;">
	                <table>
	                    <tr>
	                        <td>
	                            <h2 id="Permission" class="receiver_tltype01" onclick="SelectReceiverWindow(ToTitle,ListViewMsgTo)" style="margin-left:1px; border-bottom:0px;">
	                                <%-- <span style="min-width: 45px;" id="PermissionStr"><spring:message code='ezOrgan.t00011'/></span> --%>
	                                <span style="min-width: 45px;" id="PermissionStr"></span>
	                            </h2>
	                            <div class="receiver_borderbox" style="border-top: 1px solid #565b66; margin-top:1px;">
	                                <!-- <div id="PermissionBasic" style="width: 250px; Height: 210px; overflow-x: auto; overflow-y: auto;" ondblclick="InsertReceiver()"></div> -->
	                                <div id="PermissionPopUpList" style="width: 250px; Height: 475px; overflow-x: auto; overflow-y: auto;"></div>
	                            </div> 
	                        </td>
	                    </tr>
	                    <tr>
	                        <!-- <td style="text-align:center; padding-top:1px;">
	                            <img src="../../../images/kr/cm/arr_down.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver()" />
	                            <img src="../../../images/kr/cm/arr_up.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver()" />
	                        </td> -->
	                    </tr>
	                    <tr>
	                        <%-- <td>
	                            <h2 id="UserAcl" class="receiver_tltype01" onclick="SelectReceiverWindow(ToTitle,ListViewMsgTo)" style="margin-left:1px; border-bottom:0px;">
	                                <span style="min-width: 45px;" id="Span1"><spring:message code='ezOrgan.t00012'/></span>
	                            </h2>
	                            
	                            <div class="receiver_borderbox" style="border-top: 1px solid #565b66;">
	                                <div id="UserAclList" style="width: 250px; Height: 211px; overflow-x: auto; overflow-y: auto;" ondblclick="DeleteReceiver()"></div>
	                            </div>
	                        </td> --%>
	                    </tr>
	                </table>                                      
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn" onclick="OK_Click()"><span><spring:message code='ezOrgan.t167'/></span></a>
	    </div>
	</body>	
</html>