<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1279' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			.mainlist tr th { border-top:0px }
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		
		<script type="text/javascript">
			var g_xmlHTTP = createXMLHttpRequest();
		    var pUserID  = "<c:out value = '${userInfo.id}' />";
		    var pUserName = "<c:out value = '${userInfo.displayName1}' />";
		    var pUserName1 = "<c:out value = '${userInfo.displayName1}' />";
		    var pUserName2 = "<c:out value = '${userInfo.displayName2}' />";
		    var pCompanyID = "<c:out value = '${userInfo.companyID}' />";
		    var pLang = "<c:out value = '${userInfo.lang}' />";
		    var parameter = new Array();
		    var listview = new ListView();
		    var OrderCell = "";
		    
		    $(document).ready(function(){
		        ListCompany.value = pCompanyID;
		        
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
		            var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
		            try { ezAPRALERT_Cross.focus(); } catch (e) { }
		        } else {
		            var parameter = pAlertContent;
		            var url = "/ezApprovalG/ezAprAlert.do";
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
		        	data : {
		        		listFlag : "ADMIN",
	        			companyID : pCompanyID
	        			},
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
		        		alert("<spring:message code = 'ezApprovalG.t228' />" + jqXHR.status);
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
		    		},
		    		error : function() {
		    			tempRet = "FALSE";
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
		    		data : {
		    			pSealNum : pSealNum,
		    			companyID : pCompanyID
		    		},
		    		success : function (result) {
		    			tempRet = result;
		    		},
		    		error : function() {
		    			tempRet = "FALSE";
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
		    
		    /* 2020-02-17 홍승비 - 관인정보보기 팝업창에 삭제를 위한 파라미터 전달 */
		    var ezsealinfo_dialogArguments = new Array();
		    function btnInfo_onclick() {
		    	var listview = new ListView();
	            listview.LoadFromID("lvtDocForm");
	            var selRow = listview.GetSelectedRows();
		        
		        if (selRow.length > 0) {
		        	parameter[0] = GetAttribute(selRow[0], "DATA1");
	                parameter[1] = getNodeText(selRow[0].cells[0]);
	                parameter[2] = escape(GetAttribute(selRow[0], "DATA2"));
	                parameter[3] = getNodeText(selRow[0].cells[1]);
	                parameter[4] = getNodeText(selRow[0].cells[2]);
	                parameter[5] = getNodeText(selRow[0].cells[3]);
	                parameter[6] = getNodeText(selRow[0].cells[4]);
	                parameter[7] = GetAttribute(selRow[0], "DATA3")
	                parameter[8] = getNodeText(selRow[0].cells[5]);
	                parameter[9] = "";  // 현재 선택된 부서ID (부서직인 관리 시에만 사용되므로, 공백으로 넘김)
	                parameter[10] = pCompanyID;  // 현재 선택된 회사ID
	                
	                ezsealinfo_dialogArguments[0] = parameter;
	                ezsealinfo_dialogArguments[1] = btnInfo_onclick_Complete;
	                ezsealinfo_dialogArguments[2] = btnInfo_onDelete_Complete; // 관인삭제 후 동작
	
	                var ezSealInfo = window.open("/admin/ezApprovalG/sealInfo.do", "ezSealInfo", GetOpenWindowfeature(504, 470))
		        } else {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1280' />";
		            OpenAlertUI(pInformationString);
		          
		            return;
		        }
		    }
	
		    function btnInfo_onclick_Complete() {
		    }
		    /* 2020-02-17 홍승비 - 관인삭제 이후 리스트 갱신 함수 */
		    function btnInfo_onDelete_Complete() {
		    	getSealList();
		    }
		    
		    /* 2020-02-17 홍승비 - 관인등록 완료 시, 기존 관인을 삭제하지 않도록 수정 */
		    var AddSealInfo_dialogArguments = new Array();
		    function btnAdd_onclick() {
		        var parameter = new Array();
		        parameter[0] = pUserID;
				if(pLang == "1"){
					parameter[1] = pUserName;
				}else{
					parameter[1] = pUserName2;
				}
		        parameter[2] = pCompanyID;
		        
		        if (CrossYN()) {
		        	AddSealInfo_dialogArguments[0] = parameter;
			        AddSealInfo_dialogArguments[1] = btnAdd_onclick_complete;
			        
			        var url = "/admin/ezApprovalG/addSealInfo.do";
			        var ezSealInfo = window.open(url, "", GetOpenWindowfeature(435, 390));
			        try { ezSealInfo.focus(); } catch (e) {
	                }
		        } else {
		        	var url = "/admin/ezApprovalG/addSealInfo.do";
	                var feature = "status:no;dialogWidth:435px;dialogHeight:390px;edge:sunken;scroll:no;help:no"
	                var ret = window.showModalDialog(url, parameter, feature);

	                if (ret[0] == "OK") {
/* 	                    var RtnVal = DeleteSealInfo("");

	                    if (RtnVal == "TRUE") { */
	                        var RtnVal = InsertSealInfo(ret[1], ret[2], ret[3], ret[4], ret[5]);
	                        if (RtnVal == "TRUE") {
	                            var pInformationString = "<spring:message code = 'ezApprovalG.t1281' />";
	                            OpenAlertUI(pInformationString);
	                            getSealList();
	                        }
	                        else {
	                            var pInformationString = "<spring:message code = 'ezApprovalG.t1282' />";
	                            OpenAlertUI(pInformationString);
	                            return;
	                        }
/* 	                    }
	                    else {
	                        var pInformationString = "<spring:message code = 'ezApprovalG.t1282' />";
	                        OpenAlertUI(pInformationString);
	                        return;
	                    } */
	                }
		        }
		    }
		    
		    /* 2020-02-17 홍승비 - 관인등록 완료 시, 기존 관인을 삭제하지 않도록 수정 */
		    function btnAdd_onclick_complete(RtnVal) {
		    	if (RtnVal[0] == "OK") {
/* 	                var DelRtnVal = DeleteSealInfo("");
	              	if (DelRtnVal == "TRUE") { */
	                    RtnVal = InsertSealInfo(RtnVal[1], RtnVal[2], RtnVal[3], RtnVal[4], RtnVal[5]);
	                    if (RtnVal == "TRUE") {
	                        var pInformationString = "<spring:message code = 'ezApprovalG.t1281' />";
	                        OpenAlertUI(pInformationString);
	                        getSealList();
	                    }
	                    else {
	                        var pInformationString = "<spring:message code = 'ezApprovalG.t1282' />";
	                        OpenAlertUI(pInformationString);
	                        return;
	                    }
/* 	                }
	                else {
	                    var pInformationString = "<spring:message code = 'ezApprovalG.t1282' />";
	                    OpenAlertUI(pInformationString);
	                    return;
	                } */
	            }
		    }
		    
		    function selectCompanyID() {
		        if (pCompanyID != document.getElementById("ListCompany").value) {
		            pCompanyID = document.getElementById("ListCompany").value;
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
		<h1>
			<spring:message code = 'ezApprovalG.t1283' />
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select id="ListCompany" name="SCompID" class="companySelect" onChange="selectCompanyID()">
	        	<c:forEach var="item" items="${list}">
            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
	        </select>
		</h1>
		<div id="mainmenu">
		  	<ul>
		  		<%-- <b><spring:message code = 'ezApprovalG.t1276' /></b>
		        <select id="SCompID" name="SCompID" onChange="selectCompanyID()">
		        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
		        </select><br /><br /> --%>
		        <li id="GetEDMSXML"><span onClick="return btnAdd_onclick()" ><spring:message code = 'ezApprovalG.t1261' /></span></li>
		    	<li id="SearchCondi"><span onClick="return btnInfo_onclick()"><spring:message code = 'ezApprovalG.t1284' /></span></li>		    	
		  	</ul>
		</div>

		<div class="listview" style="width:790px; height:550px; overflow-y:auto; overflow-x:hidden" >
			<DIV id=lvtForm class="text" style="OVERFLOW-Y:auto; overflow-x:auto; border:0; width:790px; height:550px;"></DIV>
		</div>
	
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>
