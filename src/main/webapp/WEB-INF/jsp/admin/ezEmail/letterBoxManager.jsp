<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="/css/default_kr.css" type="text/css" />
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <link rel="stylesheet" href="/js/dist/themes/default/style.min.css" />
	    <script src="/js/dist/jstree.min.js"></script>
	    
	    <style>
	    #divTree {
	    	height:350px;
	    	width:250px;
	    	background-color:#f5f6f6;
	    	float:left;
	    }
	    
	    #divInput {
	    	float:left;
	    	width:350px;
	    	height:350px;
	    	margin-left:20px;
	    	position:relative;
	    }
	    
	    </style>
	    
	    <script type="text/javascript">
	    var result = ${result};
	    var letter_displayname;
	    var letter_displayname2;
	    var treeCollection = [];
	    var xmlhttp;
	    var responseResult;
	    var selectNode;
	    
	    window.onload = function() {
	    	treeSet();
	    	treeView();
	    	treeInit();
	    }
	    
	    function treeInit () {
	    	$("#divTree").on('ready.jstree', function (e, data) {
	    		selectNode = data;
	    		data.instance.open_node(["1"]);
	    		data.instance.select_node(["1"]); //option
	    	});
	    }
	    
	    //jstree click event
	    function treeOnclick() { 	
	    	$('#divTree').on('changed.jstree', function (e, data) {
	    		selectNode = data; //selectNode => delete, update, insert 에 사용!!
	    		selectBox(selectNode.node.id);
	        });
	    }
	    
	    function selectBox(letterBoxNo) {
	    	var query = "/admin/ezEmail/readLetterBox.do?letterBoxNo=" + letterBoxNo;
	    	
	    	xmlhttp = createXMLHttpRequest();
	        xmlhttp.open("POST", query, true);
	        xmlhttp.responseType = 'text'; 
	        xmlhttp.onreadystatechange = readText;
	        xmlhttp.send();
	    }
	    
	    function readText() { 
	    	if (xmlhttp == null || xmlhttp.readyState != 4) return;
	    	responseResult = xmlhttp.response;
	    	var displayname = 'displayname":"';
	    	var displayname2 = 'displayname2":"';
	    	var displayname_start = responseResult.indexOf(displayname) + displayname.length;
	    	var displayname2_start = responseResult.indexOf(displayname2) + displayname2.length;
	    	var displayname_end = responseResult.indexOf('","par');
	    	var displayname2_end = responseResult.indexOf('","com');
	    	
	    	letter_displayname = responseResult.substring(displayname_start, displayname_end);
	    	letter_displayname2 = responseResult.substring(displayname2_start, displayname2_end);
	    	
	    	setDisplay(letter_displayname, letter_displayname2);
	    }
	    
	    
	    function setDisplay(letter_displayname, letter_displayname2) {
	    	//change displayname
	    	document.getElementById("display").value = letter_displayname;
	    	document.getElementById("display2").value = letter_displayname2;
	    }
	    
	    function treeSet() {
	    	for(var i = 0; i < result.length; i++) {
	    		var treeId = result[i].letterbox_no; //uuid
	    		var treeParent = result[i].parent_letterbox_no;
	    		var treeText = result[i].displayname;
	    		
	    		if (treeParent == null) {
	    			treeParent = '#'; //root node
	    		}
	    		
	    		treeCollection.push({id:treeId, parent:treeParent, text:treeText});
	    		
	    	}
	    }
	    
	    function treeView() {
	    	$('#divTree').jstree({
	    			"plugins" : [ "changed", "wholerow" ],
	    			 'core' : {
	    	    'data' : treeCollection
	    	} });
	    	
	    	treeOnclick();
	    }
	    
	    function addLetterBox() {
	    	alert("letterBox add");
	    	console.log(selectNode);
	    }
	    
	    function deleteLetterBox() {
	    	alert("letterBox delete");
	    }
	    
	    </script>
	</head>
	<body style="height: 95%; overflow:hidden;">
	    <br><div><h3><b>편지지함 관리  · 수정 · 삭제</b></h3></div><br>
	    <div id="mainmenu">
		    <ul class="on">
		        <li><span onclick="addLetterBox()">&nbsp;&nbsp;+ 편지지함 <spring:message code='ezQuestion.t176'/>&nbsp;&nbsp;</span></li>
		        <li><span onclick="deleteLetterBox()">&nbsp;&nbsp;- 편지지함 <spring:message code='ezQuestion.t177'/>&nbsp;&nbsp;</span></li>
		    </ul>
		</div>
		<div id="divTree">
		</div>
		<div id="divInput">
			<form action=""><br>
				<b><spring:message code='main.t76'/></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" id="display" name="display" size="30"><br><br>
				<b><spring:message code='main.t76'/>(<spring:message code='ezSchedule.t4014'/>)</b>&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" id="display2" name="display" size="30"><br>
			
				<div style="position:absolute; bottom:20px; right:50px;"><input type="submit" value=" 확인 "></div>
			</form>
		</div>
	</body>
</html>