<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezOrgan.t105" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
	    <script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var ReturnFunction;
	    	var RetValue;
	    	var openerFlag = false;
	    	
			$(document).ready(function(){
				try {
					RetValue = parent.checkname2_cross_dialogArguments[0];
	    	        ReturnFunction = parent.checkname2_cross_dialogArguments[1];        
		        } catch (e) {
		            try {
		            	RetValue = opener.checkname2_cross_dialogArguments[0];
	    	            ReturnFunction = opener.checkname2_cross_dialogArguments[1];
		                openerFlag = true;
		            } catch (e) {
		                openerFlag = false;
		            }
		        }
				initializeReceiverList();
			});			
			
			function initializeReceiverList(){
	            var xmlpara = loadXMLString(listviewheader.innerHTML.toUpperCase());
	            document.getElementById("OrganListView").innerHTML = "";
	            var listView = new ListView();
	            listView.SetID("lvDeptrList");
	    		listView.DataSource(xmlpara);
	    		listView.DataBind("OrganListView");
	    		listView = null;
	    		
	    		SetDataSource();
	    	}
	    	
	    	function SetDataSource() {
	    	    var tempXML;
	    	    tempXML = SelectSingleNodeNew(RetValue["addrBook"], "LISTVIEWDATA/ROWS");
	    	    
	    	    if (tempXML == null) {
	    	        return;
	    		}
	    		
	    		var DocList = new ListView();                          
	    	    DocList.LoadFromID("lvDeptrList"); 
	    	    DocList.SetRowOnDblClick("change_onClick");			
	    	    var tempRow;
	    	    var currentRowNumber = 0;
	    	    
	    	    for (var i=0; i<tempXML.childNodes.length; ++i){	    	    
	    	        if(tempXML.childNodes[i].nodeType == 1){
    	                tempRow = tempXML.childNodes[i];
    	                var objTr = DocList.AddRow(currentRowNumber);
    	                DocList.AddDataRow(objTr,tempRow); 
    	                currentRowNumber++;
					}
				}            
	    	    DocList = null;	
			}
			
			function change_onClick(){
				var listview = new ListView();
			    listview.LoadFromID("lvDeptrList");

				var count1;
				var selectedItemCount;
				var selRow;
			
				selectedItemCount = listview.GetSelectedIndexes().length;
				
				if (selectedItemCount == 0){
					alert("<spring:message code='ezOrgan.t106' />");
					return;
				}else if (selectedItemCount > 1){
					alert("<spring:message code='ezOrgan.t107' />");
					return;
				}
			
			    if (ReturnFunction != null) {
			        RetValue["deptid"] = listview.GetSelectedRows()[0].getAttribute("DATA2");
			        ReturnFunction(RetValue);			        
			        if (openerFlag){
			            window.close();
			        }
			    }else{
			        dialogArguments["deptid"] = listview.GetSelectedRows()[0].getAttribute("DATA2");
			        window.close();
			    }
			}			

			function cancel_onClick(){
			    if (ReturnFunction != null) {
			        RetValue["recipientTDData"] = "dontprocess";
			        ReturnFunction(RetValue);
			        if (openerFlag){
			            window.close();
			        }
			    }else {
			        dialogArguments["recipientTDData"] = "dontprocess";
			        window.close();
			    }
			}
	    </script>
	</head>
	<body class="popup">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t108' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t67' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t71' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	
	    <h1><spring:message code='ezOrgan.t105' /></h1>
	    <h2><spring:message code='ezOrgan.t109' /></h2>
	    <div class="listview" style="width: 570px;">
	        <div id="OrganListView" style="border: 0px solid #B6B6B6; Width: 570px; Height: 160px; overflow: auto; BACKGROUND-COLOR: white;"></div>
	    </div>
	    <div class="btnposition">
	        <a class="imgbtn"><span onClick="change_onClick()"><spring:message code='ezOrgan.t110' /></span></a>
	        <a class="imgbtn"><span onClick="cancel_onClick()"><spring:message code='ezOrgan.t111' /></span></a>
	    </div>
	</body>
</html>