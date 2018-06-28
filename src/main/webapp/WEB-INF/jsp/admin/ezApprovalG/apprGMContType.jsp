<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1594'/></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			var labelcolor = "gray";
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc = createXmlDom();
		    var gFContID, gFormID, gState, gRtnVal;
		    var P_companyID;
		    var listview = new ListView();
		    var OrderCell = "";
		    var RetValue;
		    var ReturnFunction;
		    
		    $(document).ready(function(){
		    	try {
		            RetValue = parent.mconttype_cross_dialogArguments[0];
		            ReturnFunction = parent.mconttype_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.mconttype_cross_dialogArguments[0];
		                ReturnFunction = opener.mconttype_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        P_companyID = RetValue["P_companyID"];
		        InitListView();
		        getDocType();

		        try {
		            var ua = navigator.userAgent;
		            
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("DocTypeName"));
		                KeEventControl(document.getElementById("DocTypeName2"));
		            }
		        } catch (e) { }
		    });
		    
		    function InitListView() {
		        var xmlTree = createXmlDom();

		        listview.SetID("lvtDocForm");
		        listview.SetMulSelectable(false);
		    }

		    function getDocType() {
		        $.ajax({
		        	type : "POST",
		        	dataType : "html",
		        	url : "/admin/ezApprovalG/apprGMLgetDoctype.do",
		        	async : false,
		        	data : {comID : P_companyID},
		        	success : function(result){
						xmlRtn = loadXMLString(result);
						document.getElementById('lvDocTypeList').innerHTML = "";
				        listview.LoadFromID("lvtDocForm");
				        listview.DataSource(xmlRtn);
				        listview.DataBind("lvDocTypeList");		        		 
		        	}
		        });
		    }
		    
		    function SelContName_Check() {
		        var j;
		        var i = listview.GetRowCount();
		        var k = 0;

		        for (j = 0; j < i; j++) {
		            if (document.getElementById("DocTypeName").value == listview.GetDataRows()[j].cells[0].innerText) {            	
		                k++;
		            }
		        }
		        return k;
		    }
		    
		    function btnOk_onclick() {
		        var cnt = SelContName_Check();
		        
		        if (cnt == 0) {
		            if (document.getElementById("DocTypeName").value != "") {
		                var xmlRtn = createXmlDom();
		                
		                $.ajax({
		                	type : "POST",
		                	dataType : "html",
		                	url : "/admin/ezApprovalG/apprGInsertContType.do",
		                	async : false,
		                	data : {docTypeName : document.getElementById("DocTypeName").value, comID : P_companyID, docTypeName2 : document.getElementById("DocTypeName2").value},
		                	success : function() {
		                		alert("<spring:message code='ezApprovalG.t1596'/>");
			                    getDocType();
			                    document.getElementById("DocTypeName").value = "";
			                    document.getElementById("DocTypeName2").value = "";
		                	},
		                	error : function() {
		                		alert("<spring:message code='ezApprovalG.t1595'/>");
		                	}
		                });
		            } else {
		                alert("<spring:message code='ezApprovalG.t1597'/>");
		            }
		        } else {
		            alert("<spring:message code='ezApprovalG.t1598'/>");
		            document.getElementById("DocTypeName").value = "";
		            document.getElementById("DocTypeName2").value = "";
		            document.getElementById("DocTypeName").focus();
		        }
		    }
		    
		    function btnDel_onclick() {
		        var i, ContDocInfo, NodeName;
		        listview.LoadFromID("lvtDocForm");
		        var selRow = listview.GetSelectedIndexes().split(",");
		        ContDocInfo = listview.GetDataRows()[selRow].getAttribute("DATA1");
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "html",
		        	url : "/admin/ezApprovalG/apprGDeleteContType.do",
		        	async : false,
		        	data : {docTypeID : ContDocInfo, comID : P_companyID},
		        	success : function(result) {
		        		if (result == "TRUE") {
		        			alert("<spring:message code='ezApprovalG.t1599'/>");
			            	getDocType();
		        		} else if (result == "USE") {
		        			alert("<spring:message code='ezApprovalG.t1601'/>");
		        		} else {
		        			alert("<spring:message code='ezApprovalG.t1600'/>");
		        		}		        	
		        	},
		        	error : function() {
		        		alert("<spring:message code='ezApprovalG.t1600'/>");
		        	}
		        });
		    }
		    
		    function btncancel_onclick() {
		        window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1594'/></h1>
		<div class="listview" style="width:265px;height:210px;overflow-y:auto;overflow-x:hidden;">
			<div id="lvDocTypeList" style="BORDER:0; HEIGHT: 200px; WIDTH: 250px"></div>
		</div>
		<table class="content" style="margin-top:5px">
			<tr>
				<th><spring:message code='ezApprovalG.t1549'/></th>
				<td>
					<table style="width:100%">
	                    <tr class="primary">
		                    <th><c:out value="${primary}" /></th>
		                    <td><input type="text" id="DocTypeName" name="DocTypeName" style="width:100%" maxlength="50" /></td>
	                    </tr>
	                    <tr class="secondary">
		                    <th><c:out value="${secondary}" /></th>
		                    <td><input type="text" id="DocTypeName2" name="DocTypeName2" style="width:100%" maxlength="50" /></td>
	                    </tr>
	                </table>
				</td>
			</tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn"><span onClick="return btnOk_onclick()"><spring:message code='ezApprovalG.t949'/></span></a>
		    <a class="imgbtn"><span onClick="return btnDel_onclick()"><spring:message code='ezApprovalG.t266'/></span></a>
		    <a class="imgbtn"><span onClick="return btncancel_onclick()"><spring:message code='ezApprovalG.t64'/></span></a>
		</div>
	</body>
</html>
