<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1279' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		
		<script type="text/javascript">
			var g_xmlHTTP = createXMLHttpRequest();
		    var pUserID  = "<c:out value = '${userInfo.id}' />";
		    var pUserName = "<c:out value = '${userInfo.displayName1}' />";
		    var pUserName1 = "<c:out value = '${userInfo.displayName1}' />";
		    var pUserName2 = "<c:out value = '${userInfo.displayName2}' />";
		    var pCompanyID = "<c:out value = '${userInfo.companyID}' />";
		    var parameter = new Array();
		    var listview = new ListView();
		    var OrderCell = "";
		    
		    $(document).ready(function(){
		        SCompID.value = pCompanyID;
		        
		        InitListView();
		        getSealList();
		    });
	
		    function InitListView() {
		        var xmlTree = createXmlDom();
		        xmlTree = loadXMLString(LISTHEADER.innerHTML.toUpperCase());
		        document.getElementById("lvtForm").innerText = "";
		        listview.SetID("lvtDocForm");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnDblClick("lvtForm_onDblclick");
		        listview.DataSource(xmlTree);
		        listview.DataBind("lvtForm");
		    }
		    
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent) {
		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = pAlertContent;
		            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
		            try { ezAPRALERT_Cross.focus(); } catch (e) { }
		        } else {
		            var parameter = pAlertContent;
		            var url = "/myoffice/ezApprovalG/ezAPRALERT_Cross.aspx";
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		    
		    function OpenAlertUI_Complete() {
		    }
		    
		    var ezapropinion_cross_dialogArguments = new Array();
		    function OpenInformationUI(pInformationContent, CompleteFunction) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";

		        if (CrossYN()) {
		            ezapropinion_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		        return RtnVal;
		    }
		    
		    function OpenInformationUI_Complete() {
		        DivPopUpHidden();
		    }
		    
		    function getSealList() {
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezApprovalG/getSealList.do",
		        	async : false,
		        	data : {listFlag : "ADMIN", companyID : pCompanyID},
		        	success : function(result){
	        			var listview = new ListView();
		                listview.LoadFromID("lvtDocForm");
		                listview.SetRowOnDblClick("lvtForm_onDblclick");
	
		                if (SelectNodes(loadXMLString(result), "ROW")[0] != undefined) {
		                    listview.DataSource(loadXMLString(result));
		                    listview.RowDataBind("lvtForm");
		                }
	
		                if (listview.GetRowCount() < 1) {
		                    var listview = new ListView();
		                    listview.SetID("lvtDocForm");
		                    listview.DataSource(LISTHEADER);
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
		    		url : "/admin/ezApprovalG/insertSealInfo.do",
		    		async : false,
		    		data : {pSealNum : pSealNum, 
		    				pSealName : pSealName,
		    				pSealPath : pSealPath,
		    				pSealWidth : pSealWidth,
		    				pSealHeight : pSealHeight,
		    				pRegUserID : pUserID,
		    				pRegUserName : pUserName1,
		    				pRegUserName2 : pUserName2,
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
		    		url : "/admin/ezApprovalG/deleteSealInfo.do",
		    		async : false,
		    		data : {pSealNum : pSealNum, companyID : pCompanyID},
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
		        
		        if (selRow) {
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
		                ezsealinfo_dialogArguments[1] = btnInfo_onclick_Complete;
	
		                var ezSealInfo = window.open("/admin/ezApprovalG/ezSealInfo.do", "ezSealInfo", GetOpenWindowfeature(500, 420));
		                try { ezSealInfo.focus(); } catch (e) {
		                }
		            } else {
		                var url = "/admin/ezApprovalG/ezSealInfo.do";
		                var feature = GetShowModalPosition(610, 265);
		                var retVal = window.showModalDialog(url, parameter, "dialogWidth:500px;dialogHeight:420px;status:no;help:no;scroll:no;edge:sunken" + feature);
		            }
		        } else {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1280' />";
		            OpenAlertUI(pInformationString);
		          
		            return;
		        }
		    }
	
		    function btnInfo_onclick_Complete() {
		    }
	
		    var ezapralert_cross_dialogArguments = new Array();
		    function btnAdd_onclick() {
		        var parameter = new Array();
		        parameter[0] = pUserID;
		        parameter[1] = pUserName;
		        parameter[2] = pCompanyID;
	
		        ezapralert_cross_dialogArguments[0] = parameter;
		        ezapralert_cross_dialogArguments[1] = btnAdd_onclick_complete;
		        
		        var url = "/admin/ezApprovalG/addSealInfo.do";
				window.open(url, "", GetOpenWindowfeature(430, 350));
		    }
		    
		    function btnAdd_onclick_complete(ret) {
		    	if (ret[0] == "OK") {
		            var RtnVal = DeleteSealInfo("");
		            if (RtnVal == "TRUE") {
		                RtnVal = InsertSealInfo(ret[1], ret[2], ret[3], ret[4], ret[5]);
		                if (RtnVal == "TRUE") {
		                    var pInformationString = "<spring:message code = 'ezApprovalG.t1281' />";
		 		            OpenAlertUI(pInformationString);
		                    getSealList();
		                } else {
		                    var pInformationString = "<spring:message code = 'ezApprovalG.t1282' />";
		 		            OpenAlertUI(pInformationString);

		                    return;
		                }
		            } else {
		                var pInformationString = "<spring:message code = 'ezApprovalG.t1282' />";
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
		            InitListView();
		            getSealList();
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

	<body  class="mainbody">
		<h1><spring:message code = 'ezApprovalG.t1283' /></h1>
		<div id="mainmenu">
	  	<ul>
	  		<b><spring:message code = 'ezApprovalG.t1276' /></b>
	        <SELECT id="SCompID" name="SCompID" onChange="selectCompanyID()">
	        	<c:forEach var="item" items="${list}">
            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
	        </SELECT><br /><br />
	    	<li id="SearchCondi"><span onClick="return btnInfo_onclick()"><spring:message code = 'ezApprovalG.t1284' /></span></li>
	    	<li id="GetEDMSXML"><span onClick="return btnAdd_onclick()" ><spring:message code = 'ezApprovalG.t1261' /></span></li>
	    	<!-- 2016-08-26 이효진 삭제버튼 생성 -->
	    	<li><span onClick="return btnDel_onclick()" ><spring:message code = 'ezApprovalG.lhj11' /></span></li>
	  	</ul>
		</div>
	
		<div class="listview"  style="width:790px" >
			<DIV id=lvtForm class="text" style="border:0; WIDTH:790px"></DIV>
		</div>
	
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>