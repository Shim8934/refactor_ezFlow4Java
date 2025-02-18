<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t808' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			.mainlist tr th { border-top:0px }
		</style>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var TaskCode, companyID;
		    var OrderCell = "";
		    var RetValue;
		    var ReturnFunction;
		    
		    $(document).ready(function(){
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
		        } catch (e) {
		        }
		    });
		    
		    function lvAprLine_DBSelChange() {
		    }
		    function lvAprLine_SelChange() {
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code = 'ezApprovalG.t808' /></h1>
		<div id="close"><ul><li><span onClick="window.close()"></span></li></ul></div>
		<div class="listview" style="overflow:hidden; width: 818px;">
			<div id="lvAprLine" style="border:0;HEIGHT: 240px; WIDTH: 818px;overflow:auto;" ></div>
		</div>
	</body>
</html>