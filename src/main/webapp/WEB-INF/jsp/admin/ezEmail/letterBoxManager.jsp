<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
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
	    
	    .myScrollableBlock {
		  display: block;
		  overflow: auto;
		}
	    
	    </style>
	    
	    <script type="text/javascript">
	    var result = [];
	    var letter_displayname;
	    var letter_displayname2;
	    var treeCollection = [];
	    var xmlhttp;
	    var responseResult;
	    var selectNode;
	    var addCheck = 0;
	    var company;
	    var returnCompany = '${companyId}';
	    
	    window.onload = window_onload;
	    
	    function window_onload() {
	    	resultRead();
	    }
	    
		function resultRead() {
			$.ajax({
				type : "POST",
				url : "/admin/ezEmail/getLetterBox.do?companyId=" + returnCompany,
				datatype : 'json',
				error : function(data) {
					alert("error");
					console.log(data);
				},
				complete : function(data) {
			        result = data.responseJSON;
			        treeSet();
			        setCompany();
			    	treeView();
			    	treeInit();
			    }
			});
	    }
	    
	    function treeInit() {
	    	$("#divTree").on('ready.jstree', function (e, data) {
	    		selectNode = data;
	    		data.instance.select_node([treeCollection[0].id]);
	    	});
	    }
	    
	    function setCompany() {
	    	company = treeCollection[0].company_id;
	    	
	    	if (company == null) {
	    		company = "";
	    	}
	    }
	    
	    function treeOnclick() {
	    	var parent;
	    	var nodeId;
	    	
	    	$('#divTree').on('changed.jstree', function (e, data) {
	    		
	    		if (addCheck == -1) {
	    			//추가하면 다른 node 못누르게됨
	    			$("#divTree").jstree('select_node', "#temp");
	    			setDisplay("편지지함", "letterbox_temp");
	    			return;
	    		}
	    		
	    		selectNode = data;
	    		nodeId = selectNode.node.id;
	    		parent = selectNode.node.parent;
	    		
	    		if (parent == '#') {
	    			parent = '0';
	    		}
	    		
	    		document.getElementById("parent_letterbox_no").value = parent;
	    		document.getElementById("letterbox_no").value = nodeId;
	    		document.getElementById("company_id").value = company;
	    		
	    		if (!(selectNode.node.id.indexOf('temp'))) {
	    			// 편지지함이 임시 추가라면
	    			setDisplay("편지지함", "letterbox_temp");
	    		} else { 
	    			selectBox(selectNode.node.id);
	    		}
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
	    
	    function deleteBox(letterBoxNo) {
	    	var query = "/admin/ezEmail/deleteLetterBox.do?letterbox_no=" + letterBoxNo;
	    	
	    	xmlhttp = createXMLHttpRequest();
	        xmlhttp.open("POST", query, true);
	        xmlhttp.responseType = 'json'; 
	        xmlhttp.onreadystatechange = deleteText;
	        xmlhttp.send();
	    }
	    
	    function deleteText() {
	    	if (xmlhttp == null || xmlhttp.readyState != 4) return;
	    	responseResult = xmlhttp.response;
	    	
	    	if (responseResult == "ERROR") {
	    		return;
	    	}
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
	    	document.getElementById("display").value = letter_displayname;
	    	document.getElementById("display2").value = letter_displayname2;
	    }
	    
	    function treeSet() {
	    	for(var i = 0; i < result.length; i++) {
	    		var treeId = result[i].letterbox_no;
	    		var treeParent = result[i].parent_letterbox_no;
	    		var treeText = result[i].displayname;
	    		var companyId = result[i].company_id;
	    		
	    		if (treeParent == '0') {
	    			treeParent = '#'; 
	    		}
	    		
	    		treeCollection.push({id:treeId, parent:treeParent, text:treeText, company_id:companyId});
	    	}
	    	
	    	
	    }
	    
	    function treeView() {
	    	$('#divTree').jstree({
	    		"plugins" : [ "changed", "wholerow", "types" ],
	    		'core' : {
	    			'data' : treeCollection,
	    			"check_callback": true
	    			},
	    			"types" : {
	                    "default": {
	                        "icon" :"/images/OrganTree_cross/fldr.gif" 
	                    }
	                }
	    	});
	    	treeOnclick();
	    }
	    
	    function addLetterBox() {
	    	
	    	if (addCheck == -1) {
	    		alert("추가 더이상 안돼"); // 이거 strLang으로 바꾸기
	    		return;
	    	}
	    	
	    	var parent = selectNode.node.id;
	    	var node = { id: 'temp', text:"편지지함"};
	    	$('#divTree').jstree('create_node', parent, node, 'last');
	    	
	    	$("#divTree").jstree("open_node", $('#'+parent));
	    	$("#divTree").jstree("select_node", $('#temp'));
	    	
	    	document.getElementById("parent_letterbox_no").value = parent;
	    	document.getElementById("company_id").value = company;
	    	
	    	$("#letterbox_no").attr("disabled","disabled");
	    	
	    	addCheck = -1;
	    	
	    }
	    
	    // 폴더명 중복 체크
	    function boxNameCheck() {
	    	var boxNamearr = [];
	    	var returnVal = false;
	    	
	    	for(var i = 0; i < result.length; i++) {
	    		if(selectNode.node.parent == result[i].parent_letterbox_no) {
	    			boxNamearr.push(result[i].displayname);
	    		}
	    	}
	    	 
	    	for (var i = 0; i < boxNamearr.length; i++) {
	    		if (document.getElementById("display").value == boxNamearr[i]) {
	    			returnVal = true;
	    		}
	    	}
	    	
	    	return returnVal;
	    }
	    
	    function deleteLetterBox() {
	    	var id = selectNode.node.id;
	    	var realCheck = false;
	    	
	    	if (id == treeCollection[0].id) {
	    		alert("기본편지지함은 삭제가 불가능합니다.");
	    		return;
	    	}
	    	
	    	if (selectNode.node.children.length != 0) {
	    		alert("하위 편지지함이 존재합니다. 하위편지지함을 삭제해주세요");
	    		return;
	    	} else {
	    		var con = confirm("편지지함을 삭제하시겠습니까?");
	    		if (con == true) {
	    			realCheck = true;
	    		}
	    	}
	    	
	    	if (realCheck == true) {
	    		$('#divTree').jstree().delete_node($('#'+id));
	    		var a = deleteBox(id);
	    		alert("삭제를 완료하였습니다.");
	    		refreshLetterBox();
	    		
	    	}
	    	
	    }
	    
	    function submitClick() {
	    	var formData = $("#myForm").serialize();
	    	var formUrl = "/admin/ezEmail/updateLetterBox.do";
	    	if (document.getElementById("letterbox_no").disabled) {
	    		formUrl = "/admin/ezEmail/createLetterBox.do";
	    	}
	    	
	    	var checkVal = boxNameCheck();
    		
    		if (checkVal == true) {
    			alert("편지지함명 이 중복되었습니다.");
				document.getElementById("display").focus();
				return;
    		}
	    	 
			$.ajax({
				type : "POST",
				url : formUrl,
				cache : false,
				data : formData,
				error : function(data) {
					console.log(data);
				},
				complete : function() {
					refreshLetterBox();
				}
			});
	    }
	    
	    function refreshLetterBox() {
	    	window.location.reload();
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
		<div id="divTree" class="myScrollableBlock">
		</div>
		<div id="divInput">
			<form id="myForm" action="/admin/ezEmail/updateLetterBox.do" method="post"><br>
				<b><spring:message code='main.t76'/></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" id="display" name="displayname" size="30"><br><br>
				<b><spring:message code='main.t76'/>(<spring:message code='ezSchedule.t4014'/>)</b>&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" id="display2" name="displayname2" size="30"><br>
				<input type="hidden" id="letterbox_no" name="letterBoxNo">
				<input type="hidden" id="parent_letterbox_no" name="parentLetterBoxNo">
				<input type="hidden" id="company_id" name="companyID">
				<div style="position:absolute; bottom:20px; right:50px;"><input type="button" id="submitBtn" onclick="submitClick()" value=" 확인 "></div>
			</form>
		</div>
	</body>
</html>