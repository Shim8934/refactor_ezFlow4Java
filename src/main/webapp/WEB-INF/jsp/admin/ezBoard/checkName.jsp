<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t5" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />	     
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list_admin.js')}"></script>	    
		<script type="text/javascript" language="javascript">
			var ReturnFunction;
	    	var RetValue;
	    	
	    	$(document).ready(function(){
	    		try {
	    	        RetValue = parent.checkname2_cross_dialogArguments[0];
	    	        ReturnFunction = parent.checkname2_cross_dialogArguments[1];
	    	    } catch (e) {
	    	        try {
	    	            RetValue = opener.checkname2_cross_dialogArguments[0];
	    	            ReturnFunction = opener.checkname2_cross_dialogArguments[1];
	    	        } catch (e) {
	    	            RetValue = window.dialogArguments;
	    	        }
	    	    }
	    	        
	    		initializeReceiverList();	    		
	    	});
	    	
	    	function initializeReceiverList(){
	            var xmlpara = loadXMLString(listviewheader.innerHTML.toUpperCase());
	            document.getElementById("lvtDoclist").innerHTML = "";
	            var listView = new ListView();
	            listView.SetID("DocList");
	    		listView.DataSource(xmlpara);
	    		listView.DataBind("lvtDoclist");
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
	    	    DocList.LoadFromID("DocList"); 
	    	    DocList.SetRowOnDblClick("selectuser");			
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
	    	
	    	function selectuser(){
	    	    var SelList = new ListView();
	    	    SelList.LoadFromID("DocList");
	    	    var tr = SelList.GetSelectedRows();	            
	            
	            if (tr.length == 0){
	    			alert("<spring:message code='ezBoard.t9'/>");
	    			return;
	    		}
	    		if (tr.length > 1){
	    			alert("<spring:message code='ezBoard.t10'/>");
	    			return;
	    		}	    		
	    		var selRow = tr[0];
	    		
	    		if (ReturnFunction != null){
	    		    RetValue["deptid"] = selRow.getAttribute("DATA3");
	    		    RetValue["userid"] = selRow.getAttribute("DATA2");
    		    	RetValue["username"] = getNodeText(selRow.getElementsByTagName("td")[3]);
	    		    
	    		    ReturnFunction(RetValue);
	    		}else{
	    		    dialogArguments["deptid"] = selRow.getAttribute("DATA3");
	    		}
	            window.close();
	    	}
	    	
	    	function change_onClick(){
	    		var count1;
	    		var selectedItemCount;
	    		var selRow;
	    	
	    	    var DocList = new ListView();                          
	    	    DocList.LoadFromID("DocList"); 
	    	    
	    	    var selRow = DocList.GetSelectedRows();
	    		selectedItemCount = selRow.length;
	    		
	    		if (selectedItemCount == 0){
	    			alert("<spring:message code='ezPersonal.yej02'/>");
	    			return;
	    		}else if (selectedItemCount > 1){
	    			alert("<spring:message code='ezBoard.t34'/>");
	    			return;
	    		}
	    		
	    	    if (ReturnFunction != null) {
	    	        RetValue["deptid"] = selRow[0].getAttribute("DATA3");
	    	        RetValue["userid"] = selRow[0].getAttribute("DATA2");
	    	        RetValue["username"] = getNodeText(selRow[0].getElementsByTagName("td")[3]);
	    	        
	    	        ReturnFunction(RetValue);
	    	    }else{
	    	        dialogArguments["deptid"] = selRow[0].getAttribute("DATA3");
	    	    }
	    	    window.close();
	    	}
	    	
	    	function cancel_onClick(){
	    	    if (ReturnFunction != null) {
	    	        RetValue["recipientTDData"] = "dontprocess";
	    	        ReturnFunction(RetValue);
	    	    }else{
	    	        dialogArguments["recipientTDData"] = "dontprocess";
	    	    }
	    		window.close();
	    	}
	    </script>
	    <style>
	    	.mainlist tr th {border-top:0px}
	    </style>
	</head>
	<body class="popup">		
		<xml id="listviewheader" style ="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<TYPE>sNONE</TYPE>
		        		<NAME><spring:message code="ezBoard.t8"/></NAME>
		        		<WIDTH>100</WIDTH>
		        		<SORTABLE>TRUE</SORTABLE>
		        		<RESIZIBLE>FALSE</RESIZIBLE>
		        		<MINSIZE>10</MINSIZE>
		        		<MAXSIZE>200</MAXSIZE>
		        		<NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code="ezBoard.t9"/></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code="ezBoard.t10"/></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
			      	<HEADER>
			        	<NAME><spring:message code="ezBoard.t11"/></NAME>
				        <WIDTH>70</WIDTH>
		      		</HEADER>
			      	<HEADER>
				        <NAME>EMAIL</NAME>
				        <WIDTH>200</WIDTH>
				    </HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>		
		<h1><spring:message code="ezBoard.t5" /></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancel_onClick()"></span></li>
            </ul>
        </div>
		<h2 style="font-weight: normal">▒ <spring:message code="ezBoard.t13" /></h2>
        <div class="listview" style="width:100%; min-width:570px; height:285px;" >
            <div id="lvtDoclist" style="width:100%;min-width:570px; border:0; height:285px; overflow:AUTO;" ></div>
        </div>		            
		<div class="btnpositionNew">
		    <a class="imgbtn"><span onClick="change_onClick()"><spring:message code="ezBoard.t14" /></span></a>
		</div>
	</body>
</html>