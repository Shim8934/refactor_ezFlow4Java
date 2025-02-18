<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezJournal.t204'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <style>
	    	.mainlist tr th {
	    		border-top:0px;
	    	}
			.listview {
				width: 100%; height: 180px; overflow-x:hidden; overflow-y: AUTO;
			}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var pDocID;
	        var pDeptID;
	        var OrderCell = "";
	        var Resultxml = createXmlDom();
	        var xmlhttp = createXMLHttpRequest();
// 	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
// 	            window.onblur = function () {
// 	                window.focus();
// 	            };
// 	        }
	        var orgCompanyID;
	        window.onload = function () {
	            pDocID = "${docID}";
	            pDeptID = "${deptID}";
	
	            getReceiptHistoryInfo();
	        };
	        function getReceiptHistoryInfo() {
	            document.getElementById("RECEIPTHISTORY").innerText = "";
	            
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getReceiptHistoryInfo.do",
		    		data : {
		    			docID : pDocID,
		    			deptID : pDeptID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}
		    	});
		    	
	            Resultxml = result;
	            var listview = new ListView();
	            listview.SetID("receiptHistory");
	            listview.SetMulSelectable(false);
	            listview.DataSource(Resultxml);
	            listview.DataBind("RECEIPTHISTORY");
	        }
	        function btn_exit_onclick() {
                window.close();
	        }
	    </script>
	    
	</head>
	<body class="popup">
	    <h1><spring:message code='ezJournal.t204'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="return btn_exit_onclick()"></span></li>
            </ul>
        </div>
	    <div class="listview">
	        <div id="RECEIPTHISTORY" style="border: 0; Height: 150px;"></div>
	    </div>
	</body>
</html>