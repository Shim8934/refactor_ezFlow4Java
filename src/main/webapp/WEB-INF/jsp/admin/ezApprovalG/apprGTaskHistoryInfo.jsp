<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var TaskCode, companyID;
		    var OrderCell = "";
		    var RetValue;
		    var ReturnFunction;
		    
		    window.onload = function () {
		        try {
		            try {
		                RetValue = parent.taskhistoryinfo_cross_dialogArguments[0];
		                ReturnFunction = parent.taskhistoryinfo_cross_dialogArguments[1];
		            } catch (e) {
		                try {
		                    RetValue = opener.taskhistoryinfo_cross_dialogArguments[0];
		                    ReturnFunction = opener.taskhistoryinfo_cross_dialogArguments[1];
		                } catch (e) {
		                    RetValue = window.dialogArguments;
		                }
		            }
		            
		            TaskCode = RetValue[1];
		            companyID = RetValue[2];
		            
		            $.ajax({
		            	type : "POST",
		            	url : "/admin/ezApprovalG/getTaskHistory.do",
		            	async : false,
		            	data : {docID : TaskCode, companyID : companyID},
		            	success : function(result) {
		            		var RtnVal = loadXMLString(result);
		            		
		            		var lvAprLineList = new ListView();
				            lvAprLineList.SetID("DocList");                               
				            lvAprLineList.SetMulSelectable(true);                        
				            lvAprLineList.DataSource(RtnVal);                             
				            lvAprLineList.DataBind("lvAprLine");                          
				            lvAprLineList = null;
		            	}
		            });
	
		            /* var xmlhttp = createXMLHttpRequest();
		            var RtnVal = createXmlDom();
	
		            var xmlpara = createXmlDom();
		            var objRoot, objNode;
	
		            objRoot = createNodeInsert(xmlpara, objRoot, "ASSIGN");
		            objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "pDocID", TaskCode);
		            objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "companyID", companyID);
	
		            xmlhttp.open("POST", "aspx/API_GetTaskHistory.aspx", false); 
		            xmlhttp.send(xmlpara);
	
		            RtnVal = xmlhttp.responseXML;
	
		            var lvAprLineList = new ListView();
		            lvAprLineList.SetID("DocList");                               
		            lvAprLineList.SetMulSelectable(true);                        
		            lvAprLineList.DataSource(RtnVal);                             
		            lvAprLineList.DataBind("lvAprLine");                          
		            lvAprLineList = null; */
		        } catch (e) {
		        }
		    };
		    
		    function lvAprLine_DBSelChange() {
		    }
		    function lvAprLine_SelChange() {
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code = 'ezApprovalG.t808' /></h1>
		<div id="close"><ul><li><span onClick="window.close()"><spring:message code = 'ezApprovalG.t64' /></span></li></ul></div>
		<div class="listview" style="overflow:hidden">
			<div id="lvAprLine" style="border:0;HEIGHT: 240px; WIDTH: 818px;overflow:auto;" ></div>
		</div>
	</body>
</html>