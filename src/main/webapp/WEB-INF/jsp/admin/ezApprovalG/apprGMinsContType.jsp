<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1653'/></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MinsContType_Cross.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			var i,pXML;
		    var xmlhttp = createXMLHttpRequest();
		    var Arr_ContType1 = new Array();
		    var Arr_ContType2 = new Array();
		    var P_companyID;
		    var count, StateCount, chkVal;
		    var lvDocTypeList = new ListView();
		    var lvContDocList = new ListView();
		    var OrderCell = "";
		    var RetValue;
		    var ReturnFunction;
		    
		    $(document).ready(function(){
		    	try {
		            RetValue = parent.minsconttype_cross_dialogArguments[0];
		            ReturnFunction = parent.minsconttype_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.minsconttype_cross_dialogArguments[0];
		                ReturnFunction = opener.minsconttype_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        P_companyID = RetValue["P_companyID"];
		        InitlvDocTypeList();
		        InitlvContTypeList();
		    });
		    
		    function InitListView() {
		        var xmlTree = createXmlDom();

		        lvDocTypeList.SetID("lvtDocForm");
		        lvDocTypeList.SetMulSelectable(false);
		    }

		    function lvDocTypeList_onSel_Changed() {}
		    function lvDocTypeList_onSel_Click() {}
		    function lvDocTypeList_onSel_DBclick() {}
		    function lvDocTypeList_onclick() {}
		    function lvContDocList_onSel_Changed() {}
		    function lvContDocList_onSel_Click() {}
		    function lvContDocList_onSel_DBclick() {}
		    function lvContDocList_onclick() {}
		    
		    function DocTypeDel_onclick() {        
		        DocTypeDel();
		    }
		    
		    function DocTypeIns_onclick() {
		        DocTypeIns();
		    }
			    
		    function save_onclick() {
		        ContSave();
		    }
		    
		    function close_onclick() {
		        window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1653'/></h1>
		<table>
			<tr>
				<td style="vertical-align:top;">
			        <div class="listview">
						<div id="lvDocTypeList" style="BORDER:0;HEIGHT: 270px; WIDTH: 225px; overflow-x: hidden; overflow-y: auto"></div>
					</div>
				</td>
				<td style="text-align:center;width:30px;">
					<img src="/images/arr_right.gif" width="16" height="16" id="formIns" onClick="DocTypeIns_onclick()" /><br/>
					<img src="/images/arr_left.gif" width="16" height="16" id="formDel" onClick="DocTypeDel_onclick()" />
				</td>
				<td style="vertical-align:top;">
					<div class="listview">
						<div id="lvContDocList" style="BORDER:0; HEIGHT: 270px; WIDTH: 255px; overflow-x: hidden; overflow-y: auto"></div>
					</div>
				</td>
			</tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn"><span onClick="return save_onclick()"><spring:message code='ezApprovalG.t59'/></span></a>
		    <a class="imgbtn"><span onClick="return close_onclick()"><spring:message code='ezApprovalG.t64'/></span></a>
		</div>
	</body>
</html>
