<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>mail_outofoffice_template</title>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/composeappt.js')}"></script>
	</head>
	<body style="margin-left:10px;margin-right:10px;">	
	<br>
	
	<div style="width:768px;">
		<span class="txt">▒ <spring:message code='ezEmail.ksaOutOfOffice02' /><br>
		
		<div style="height:30px; line-height:35px;">
			<div style="float:left;">
				<span><spring:message code='ezEmail.ksaOutOfOffice03'/> : </span>
				<input type="text" id="templateDisplayName" style="width: 250px;" maxlength="20">
			</div>
			
			<div style="float:right; margin-right:5px;">
		    	<span><b><spring:message code='ezEmail.jje16'/> : </b></span>
		    	<select id="templateSelect" onchange="selectOOOTemplate()" style="width:255px;">
		    		<option id="noneOption"><spring:message code='ezEmail.ksaOutOfOffice08'/></option>
           			<c:forEach var="item" items="${templateList}">
	        			<option value="<c:out value='${item.displayName}'/>"><c:out value='${item.displayName}'/></option>
            		</c:forEach>
		    	</select>
		    </div>
		</div>
		<div class="nobox" style="height:500px;margin-top:5px;">
			<iframe id="tbContentElement1" class="viewbox" src="/ezEditor/selectEditor.do?type=MAILOUTOFOFFICE" name="tbContentElement1" style="padding:0; height:500px; width:100%; overflow:auto;"></iframe>
		</div>
		<div style="text-align:center;">
			<div class="btnpositionJsp">
		    	<a class="imgbtn" id="saveBtn" onClick="Save_Click()"><span><spring:message code='main.sp09' /></span></a>
		    	<a class="imgbtn" id="cancleBtn" onClick="Cancel_Click()"><span><spring:message code='ezEmail.t39' /></span></a>
		    	<a class="imgbtn" id="delBtn" style="display:none;" onClick="Del_Click()"><span><spring:message code='ezEmail.t95' /></span></a>
		    </div>	
		</div>	
	
	</div>
	</body>
	<script> 
		var templateSelect = document.getElementById("templateSelect"); 
		var displayNameInput = document.getElementById("templateDisplayName"); 
		var saveBtn = document.getElementById("saveBtn");
		var cancleBtn = document.getElementById("cancleBtn");
		var deleteBtn = document.getElementById("delBtn");
		
		function Editor_Complete() {}
		
		function Cancel_Click() {
			tbContentElement1.SetEditorContent("");
			displayNameInput.value = "";
		}
		
		function add_option(opt_val, type) {
			if (type == "mod") {
				var selectOpt = templateSelect.querySelector("option:checked");
				selectOpt.value = opt_val;
				selectOpt.text = opt_val;
				return;
			}
			
		  	var objOption = document.createElement("option");       
		    objOption.text = opt_val;
		    objOption.value = opt_val;
		    objOption.selected = true
		    templateSelect.options.add(objOption);
		    changeCancleBtn("del");
		}
		
		function del_option(opt_val) {
			// IE에서 remove() 를 지원하지 않아 아래처럼 수정
			var selectOpt = templateSelect.querySelector("option:checked");
			selectOpt.parentElement.removeChild(selectOpt);
			templateSelect.querySelector("option[id='noneOption']").selected = true;
			selectOOOTemplate();
		}
		
		function Save_Click() {
			var objVal = templateSelect.value;
			var type = "add";
			var displayName = displayNameInput.value;
			var templateContent = tbContentElement1.GetEditorContent();
			
			if (templateSelect.querySelector("option:checked").id != "noneOption") { type = "mod"; } 

			if (displayName.trim() == "") {
				alert("<spring:message code='ezEmail.ksaOutOfOffice09' />");
				return;
			}
			
			$.ajax({
        		type : "POST",
        		async: false,
        		url : "/ezEmail/saveMailOutOfOfficeTemplate.do",
        		datatype : 'json',
        		data : {
        			"modDisplayName" : objVal,
        			"displayName" : displayName,
        			"type" : type,
        			"content" : templateContent
        			},
        		error : function(data) {
    				alert("<spring:message code='ezEmail.ksaOutOfOffice07' />");
        		}, success : function(data) {
        			if (data == "DUPLICATE_NAME") {
        				alert("<spring:message code='ezEmail.ksaOutOfOffice10' />");
        			} else if (data != "OK") {
        				alert("<spring:message code='ezEmail.ksaOutOfOffice07' />");
        			} else {
        				add_option(displayName, type);
        				alert("<spring:message code='ezEmail.ksaOutOfOffice06' />");
        			}
        	    }
        	});
		}
		
		function Del_Click() {
			var objVal = templateSelect.value;

			if (templateSelect.querySelector("option:checked").id == "noneOption") { return; } 
			
			if (confirm("<spring:message code='ezEmail.ksaOutOfOffice04' />")) {
				$.ajax({
	        		type : "POST",
	        		async: false,
	        		url : "/ezEmail/deleteMailOutOfOfficeTemplate.do",
	        		datatype : 'json',
	        		data : {"displayName" : objVal},
	        		error : function(data) {
        				alert("<spring:message code='ezEmail.ksaOutOfOffice07' />");
	        		}, success : function(data) {
	        			if (data != "OK") {
	        				alert("<spring:message code='ezEmail.ksaOutOfOffice07' />");
	        			} else {
	        				del_option(objVal);
	        				alert("<spring:message code='ezEmail.ksaOutOfOffice05' />");
	        			}
	        	    }
	        	});
			}
		}
		
		function selectOOOTemplate() {
	    	var objVal = templateSelect.value;
	    	
	    	if (typeof objVal == "undefined") {
	    		return;
	    	} else if (templateSelect.querySelector("option:checked").id == "noneOption") {
    			changeCancleBtn("cancle");
	    	} else {
	    		$.ajax({
	        		type : "POST",
	        		url : "/ezEmail/getMailOutOfOfficeTemplate.do",
	        		datatype : 'json',
	        		data : {"displayName" : objVal},
	        		error : function(data) {
	        			alert("error.");
	        		}, success : function(data) {
	        			tbContentElement1.SetEditorContent(data.content);
	        			displayNameInput.value = data.displayName;
	        			changeCancleBtn("del");
	        	    }
	        	});
	    	}
	    }
		
		function changeCancleBtn(btnType) { // del, cancle
			if (btnType == "del") {
				cancleBtn.style.display = "none";
	    		deleteBtn.style.display = "inline-block";
			} else {
				Cancel_Click();
	    		cancleBtn.style.display = "inline-block";
	    		deleteBtn.style.display = "none";
			}
		}
	</script>
</html>



