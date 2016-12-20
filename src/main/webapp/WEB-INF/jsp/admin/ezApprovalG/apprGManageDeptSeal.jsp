<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1267' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e3'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
		
		<script type="text/javascript">
			var g_xmlHTTP;
	
	        var OrderCell = "";
	        var pUserID = "<c:out value = '${userInfo.id}' />";
	        var pUserName = "<c:out value = '${userInfo.displayName1}' />";
	        var pUserName2 = "<c:out value = '${userInfo.displayName2}' />";
	        var pDeptID = "<c:out value = '${userInfo.deptID}' />";
	        var pCompanyID = "<c:out value = '${userInfo.companyID}' />";
	        var parameter = new Array();
	        var listview = new ListView();
	
	        $(document).ready(function(){
	            SCompID.value = pCompanyID;

	            Tree_setconfig();
	            InitListView();
	            TreeViewinitialize("", pCompanyID, "", "<c:out value='${serverName}'/>");
	            getSealList();
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
	
	        function InitListView() {
	            var xmlTree = createXmlDom();
	            xmlTree = loadXMLString(LISTHEADER.innerHTML.toUpperCase());
	
	            document.getElementById("lvtForm").innerText = "";
	            listview.SetID("lvtDocForm");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnClick("lvtForm_onSel_Changed");
	            listview.SetRowOnDblClick("lvtForm_onSel_DBclick");
	            listview.DataSource(xmlTree);
	            listview.DataBind("lvtForm");
	        }
	
	        function TreeViewNodeClick(pNodeID) {
	            TreeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            pDeptID = treeNode.GetNodeData("CN");
	            document.getElementById("selDept").innerText = treeNode.GetNodeData("VALUE");
	            getSealList();
	        }
	
	        function TreeViewNodeDbClick() {
	        }
	        
	        var ezapralert_cross_dialogArguments = new Array();
	        function OpenAlertUI(pAlertContent) {
	            if (CrossYN()) {
	                ezapralert_cross_dialogArguments[0] = pAlertContent;
	                var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
	                try { ezAPRALERT_Cross.focus(); } catch (e) {
	                }
	            } else {
	                var parameter = pAlertContent;
	                var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
	                var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	                var RtnVal = window.showModalDialog(url, parameter, feature);
	            }
	        }
	        
	        function getSealList() {
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezApprovalG/getDeptSealList.do",
	            	async : false,
	            	data : {listFlag : "ADMIN", deptID : pDeptID, companyID : pCompanyID},
	            	success : function(result) {
	            		var listview = new ListView();
	                    listview.LoadFromID("lvtDocForm");
	                    listview.SetRowOnDblClick("lvtForm_onDblclick");
	                    listview.DataSource(loadXMLString(result));
	                    listview.RowDataBind("lvtForm");
	                    
	                    if (listview.GetDataRows()[0].id.indexOf("noItems") > -1) {
	                        var listview = new ListView();
	                        listview.SetID("lvtDocForm");
	                        listview.DataSource(loadXMLString(LISTHEADER.innerHTML.toUpperCase()));
	                        listview.RowDataBind("lvtForm");
	                    }
	            	},
		        	error : function(jqXHR, textStatus, errorThrown) {
		        		alert("<spring:message code = 'ezApprovalG.t228' />" + jqXHR.statusText);
		        	}
	            });
	        }

		    function InsertSealInfo(pSealNum, pSealName, pSealPath, pSealWidth, pSealHeight) {
		    	var tempRet = "";
		    	$.ajax({
		    		type : "POST",
		    		url : "/admin/ezApprovalG/insertDeptSealInfo.do",
		    		async : false,
		    		data : {pSealNum : pSealNum, 
		    				pSealName : pSealName, 
		    				pSealPath : pSealPath, 
		    				pSealWidth : pSealWidth, 
		    				pSealHeight : pSealHeight, 
		    				pRegUserID : pUserID, 
		    				pRegUserName : pUserName,
		    				pRegUserName2 : pUserName2,
		    				deptID : pDeptID,
		    				companyID : pCompanyID
		    		},
		    		success : function (result) {
		    			tempRet = result;
		    		}
		    	});

		    	return tempRet;
		    }
		    
		    function DeleteSealInfo(pSealNum) {
		    	var tempRet = "";
		    	$.ajax({
		    		type : "POST",
		    		url : "/admin/ezApprovalG/deleteDeptSealInfo.do",
		    		async : false,
		    		data : {pSealNum : pSealNum, deptID : pDeptID, companyID : pCompanyID},
		    		success : function (result) {
		    			tempRet = result;
		    		}
		    	});
		    	
		    	return tempRet;
		    }
		    
		    function lvtForm_onclick() {
		    }
		    function lvtForm_onSel_Changed() {
		    }
		    
		    function lvtForm_onDblclick() {
		        btnInfo_onclick();
		    }
		    
		    var ezsealinfo_dialogArguments = new Array();
		    function btnInfo_onclick() {
		        var listview = new ListView();
		        listview.LoadFromID("lvtDocForm");
		
		        var selRow = listview.GetSelectedRows();

		        if (selRow!="") {
		            parameter[0] = selRow[0].getAttribute("DATA1");
		            parameter[1] = selRow[0].cells[0].innerText;
		            parameter[2] = encodeURI(selRow[0].getAttribute("DATA2"));
		            parameter[3] = selRow[0].cells[1].innerText;
		            parameter[4] = selRow[0].cells[2].innerText;
		            parameter[5] = selRow[0].cells[3].innerText;
		            parameter[6] = selRow[0].cells[4].innerText;
		            parameter[7] = selRow[0].getAttribute("DATA3");
		            parameter[8] = selRow[0].cells[5].innerText;
		
		            if (CrossYN()) {
		                ezsealinfo_dialogArguments[0] = parameter;
		
		                var ezSealInfo = window.open("/admin/ezApprovalG/ezSealInfo.do?pDeptYN=Y", "ezSealInfo", GetOpenWindowfeature(500, 420));
		                try { ezSealInfo.focus(); } catch (e) {
		                }
		            } else {
		                var url = "/admin/ezApprovalG/ezSealInfo.do?pDeptYN=Y";
		                var feature = GetShowModalPosition(610, 265);
		                var retVal = window.showModalDialog(url, parameter, "dialogWidth:500px;dialogHeight:420px;status:no;help:no;scroll:no;edge:sunken" + feature);
		            }
		        } else {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1280' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
		    }
			
		    var ezaddSeal_cross_dialogArguments = new Array();
	        function btnAdd_onclick() {
	            var parameter = new Array();
	            parameter[0] = pUserID;
	            parameter[1] = pUserName;
	            parameter[2] = pDeptID;
	            parameter[3] = pCompanyID;
	
	            ezaddSeal_cross_dialogArguments[0] = parameter;
	            ezaddSeal_cross_dialogArguments[1] = btnAdd_onclick_complete;
	            
	            var url = "/admin/ezApprovalG/addDeptSealInfo.do";
	            var addSealWindow = window.open(url, "", GetOpenWindowfeature(430, 360));
	            try { addSealWindow.focus(); } catch (e) {}   
	    	}
	        
	        function btnAdd_onclick_complete(ret) {
	        	if (ret[0] == "OK") {
	                var RtnVal = DeleteSealInfo("");
	                if (RtnVal == "TRUE") {
	                    RtnVal = InsertSealInfo(ret[1], ret[2], ret[3], ret[4], ret[5]);
	                    if (RtnVal == "TRUE") {
	                        var pInformationString = "<spring:message code = 'ezApprovalG.t1269' />";
	     		            OpenAlertUI(pInformationString);
		                    
		                    getSealList();
		                } else {
		                    var pInformationString = "<spring:message code = 'ezApprovalG.t1270' />";
		 		            OpenAlertUI(pInformationString);
		                    
		                    return;
		                }
		            } else {
		                var pInformationString = "<spring:message code = 'ezApprovalG.t1270' />";
	 		            OpenAlertUI(pInformationString);
		                
		                return;
	            	}
	        	}
	        }
	        
	        function btnDel_onclick() {
		    	var listview = new ListView();
		        listview.LoadFromID("lvtDocForm");
	
		        var selRow = listview.GetSelectedRows();
		        
		        if (selRow) {
		            if (confirm("관인을 삭제하시겠습니까?")) {
		            	DeleteSealInfo(selRow[0].getAttribute("DATA1"));
		            } else {
		            	return;
		            }
		        } else {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1280' />";
		            OpenAlertUI(pInformationString);
		          
		            return;
		        }
		    }
	        
		    function selectCompanyID() {
		        if (pCompanyID != document.getElementById("SCompID").value) {
		            pCompanyID = document.getElementById("SCompID").value;
		            TreeViewinitialize("", pCompanyID, "", "<c:out value='${serverName}'/>");
		        }
		    }
		</script>
	</head>
	<xml id = 'LISTHEADER' style="display:none">
		<LISTVIEWDATA>
		    <HEADERS>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1271' /></NAME>
					<WIDTH>100</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1272' /></NAME>
					<WIDTH>100</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1273' /></NAME>
					<WIDTH>100</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t831' /></NAME>
					<WIDTH>120</WIDTH>
				</HEADER>		
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1265' /></NAME>
					<WIDTH>120</WIDTH>
				</HEADER>		
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1274' /></NAME>
					<WIDTH>100</WIDTH>
				</HEADER>		
			</HEADERS>	
		</LISTVIEWDATA>
	</xml>
	<body class="mainbody">
	    <h1><spring:message code = 'ezApprovalG.t1275' /></h1>
	    <div id="mainmenu">
	        <ul>
	            <b><spring:message code = 'ezApprovalG.t1276' /></b>
	            <SELECT id="SCompID" name="SCompID" onChange="selectCompanyID()">
		        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
		        </SELECT><br /><br />
	            <li><span onclick="return btnInfo_onclick()"><spring:message code = 'ezApprovalG.t1277' /></span></li>
	            <li id="addbtn"><span onclick="return btnAdd_onclick()"><spring:message code = 'ezApprovalG.t1249' /></span></li>
				<li><span onClick="return btnDel_onclick()" >직인삭제</span></li>
	        </ul>
	    </div>
	
	    <span style="display: none"><spring:message code = 'ezApprovalG.t1278' /><b><span id="selDept"></span></b></span>
	
	    <table>
	        <tr>
	            <td>
	                <div class="box" id="TreeView" style="height: 400px; width: 250px; overflow-x: auto; overflow-y: auto;"></div>
	            </td>
	            <td style="padding-left: 5px">
	                <div class="listview">
	                    <div id="lvtForm" style="border: 0; HEIGHT: 400px; WIDTH: 700px; OVERFLOW-Y: auto; OVERFLOW-X: auto;">
	                    </div>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	</body>
</html>