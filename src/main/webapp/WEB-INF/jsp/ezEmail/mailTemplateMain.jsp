<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezEmail.kasMailTemplate01'/></title>
	    <link rel="stylesheet" href="${util.addVer('/js/dist/themes/default/style.min.css')}" />
	    <link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />	
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script src="${util.addVer('/js/dist/jstree.min.js')}"></script>
	    <style>
	    	html, body {height:100%; }
	    	#mailTemplateMain table {width: 100%;}
	    	#mailTemplateTitle {border: 1px solid #ddd; border-bottom:none;}
	    	#mailTemplateTitle th {height: 25px; border: none;}
	    	#mailTemplateContentDiv {height:90%; border: 1px solid #ddd; overflow:hidden; overflow-y: auto;}
	    	#mailTemplateContent tr {cursor:pointer; }
	    	#mailTemplateContent td {height: 28px; border-bottom: 1px solid #ddd;}
	   
	   		#mailTemplateMain tr>*:nth-child(1) { }
	    	#mailTemplateMain tr>*:nth-child(2) { width: 40%; }
	    	#mailTemplateMain tr>*:nth-child(3) { width: 10%; }
	    	#mailTemplateMain tr>*:nth-child(4) { width: 1%; }
	    	
	    	#forScroll {display:none;}
	    	
	    	#mailTemplateContent a{
	    		background: white;
			    border: 1px solid #d2d2d2;
			    border-radius: 3px;
			    font-size: 12px;
			    color: #393939;
			    cursor: pointer;
			    outline: none;
			    height: 22px;
			    line-height: 20px;
			    vertical-align: middle;
		        padding: 1.5px 4px;
		    }
	    </style>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1><spring:message code='ezEmail.kasMailTemplate01'/></h1>
		<div id="close">  
            <ul>
                <li><span onclick="btn_Close()"></span></li>
            </ul>
        </div>
        <div id="mailTemplateMain" style="height: 78%;">
        	<table id="mailTemplateTitle">
        		<tr>
        			<th><spring:message code='ezEmail.kasMailTemplate03'/></th>
        			<th><spring:message code='ezEmail.kasMailTemplate04'/></th>
        			<th><spring:message code='ezEmail.kasMailTemplate05'/></th>
        			<th width="1" id="forScroll"></th>
        		</tr>
        	</table>
        	<div id="mailTemplateContentDiv">
	        	<table id="mailTemplateContent" style="text-align:center;"> </table>
        	</div>
        </div>
		<div>
			<div class="btnposition btnpositionNew" >
				<a class="imgbtn" onclick="templatePreview()"><span><spring:message code='ezEmail.t487'/></span></a>
				<a class="imgbtn" onclick="templateSelect()"><span><spring:message code='ezBoard.t47'/></span></a>
			</div>
		</div>
		
		<script type="text/javascript">
			window.onload = function() {
				getTemplateList();
			}

			$(document).on("dblclick", "#mailTemplateContent tr:not(#noData)", function(){
				templateSelect();
			});
			
			$(document).on("click", "#mailTemplateContent tr:not(#noData, .templateSelect)", function(){
				$(this).css("background","#f0f6ff");
				$(this).parents("table").find(".templateSelect").css("background","none").removeClass("templateSelect");
				$(this).addClass("templateSelect");
			});
			
			function getTemplateList() {
				$.ajax({
					type: "POST",
					url: "/ezEmail/getUserMailTemplateList.do",
					dataType: "json",
					success: function(data) {
						makeTemplateList(data);
					}, error: function(errData) {
						alert("<spring:message code='ezEmail.kasMailTemplate11' />");
					}
				});
			}
			
			function makeTemplateList(data) {
				var listHtml = "";
				
				if (data.length >= 1) {
					var listHtmlFrame = "<tr data-displayName=\"@_displayName\" data-id=\"@_id\" data-ediType=\"@_editype\">"
					+ "<td>@_displayName</td>"
					+ "<td>@_regDate</td>"
					+ "<td><a onClick=\"btn_delete(this)\"><spring:message code='ezEmail.kasMailTemplate05'/></a></td>"
					+ "</tr>";
					
					for (var i in data) {
						var nowData = data[i];
						var displayName = nowData.DISPLAYNAME;
						var regDate = nowData.REGDATE;
						var templateId = nowData.TEMPLATEID;
						var editorType = nowData.EDITORTYPE;
						
						var tempHtml = listHtmlFrame;
						tempHtml = tempHtml.replace(/@_regDate/g, regDate).replace(/@_displayName/g, displayName)
							.replace(/@_id/g, templateId).replace(/@_editype/g, editorType);
						
						listHtml += tempHtml;
					}
				} else {
					listHtml = "<tr id=\"noData\"><td colspan=\"1\"><spring:message code='main.t00026'/></td></tr>";
				}
				
				$("#mailTemplateContent").html(listHtml);
				isScroll();
			}
			
			function btn_delete(btnObj) {
				var templateTR = $(btnObj).parents("tr");
				var templateId = templateTR.attr("data-id");
				
				if (confirm("<spring:message code='ezEmail.kasMailTemplate12' />")) {
					$.ajax({
						type: "POST",
						data: {"templateId":templateId},
						url: "/ezEmail/deleteUserMailTemplate.do",
						success: function(data) {
							if (data == "OK") {
								alert("<spring:message code='ezEmail.kasMailTemplate13' />");
								getTemplateList();
							} else {
								alert("<spring:message code='ezEmail.kasMailTemplate11' />");
							}
						}, error: function(errData) {
							alert("<spring:message code='ezEmail.kasMailTemplate11' />");
						}
					});					
				}
			}
			
		    function templatePreview(btn){
				var templateTR = $(".templateSelect");
				var templateId = templateTR.attr("data-id");
				
				if (templateId !== undefined) {
		    		url = "/ezEmail/userMailTemplatePreview.do?" + "templateId=" + encodeURIComponent(templateId);  
		    		window.open(url,"_blank","width=890, height=660");
		    	} else {
		    		alert("<spring:message code='ezEmail.kasMailTemplate17' />");
		    	}
		    }
			
			function templateSelect() {
				var editorType = parent.bodyType.value; // 0:html, 1:plainTxt
				var templateTR = $(".templateSelect");
				var templateId = templateTR.attr("data-id");
				var templateEdiType = templateTR.attr("data-editype");
				var confirmMsg = (editorType == "1" && templateEdiType == "0") ? "<spring:message code='ezEmail.kasMailTemplate16' />" : 
					"<spring:message code='ezEmail.kasMailTemplate15' />";

				if (templateId !== undefined) {
					if (confirm(confirmMsg)) {
						$.ajax({
							type:"POST",
							data: {"templateId":templateId},
							url:"/ezEmail/getUserMailTemplate.do",
							dataType:"json",
							success:function(data){
								var templateContent = data.CONTENT;
								var templateEditorType = data.EDITORTYPE;
								
								if (editorType == 1){
									parent.message.SetEditorContent(templateContent);
									
									if (templateEditorType == 1) {
										parent.document.getElementById("plainTextArea").value = templateContent;
									} else{
										parent.document.getElementById("plainTextArea").value = htmlConvertToTextContent(templateContent)
									}
								} else {
									if (templateEditorType == 1) {
										parent.message.SetEditorTextContent(templateContent);
									} else{
										parent.message.SetEditorContent(templateContent);
									}
								}
								
								parent.DivPopUpHidden();	
							}
						});
					}
		    	} else {
		    		alert("<spring:message code='ezEmail.kasMailTemplate17' />");
		    	}
		    }
			
			function isScroll(){
				var forScroll = $("#DL_Head #forScroll"); 
			
				if ($(".DL_Body_div").height() < $(".DL_Body_div table").height()) {
					forScroll.css("display", "");
				} else {
					forScroll.css("display", "none");
				}
			}
			
			function btn_Close() {
		    	parent.DivPopUpHidden();
		    }
			
			function htmlConvertToTextContent(resultStr) {
				resultStr = resultStr.replace(/\r\n/gi, "\n");
           	    resultStr = resultStr.replace(/\n/gi, "");
           	    resultStr = resultStr.replace(/<p .*?>/gi, "<p>");
           	    resultStr = resultStr.replace(/<br .*?>/gi, "<br>");
           	    resultStr = resultStr.replace(/<hr .*?>/gi, "<hr>");
           	    resultStr = resultStr.replace(/&nbsp;/gi, " ");
           	    resultStr = resultStr.replace(/<p>/gi, "\r\n");
           	    resultStr = resultStr.replace(/<br>/gi, "\r\n");
           	    resultStr = resultStr.replace(/<hr>/gi, "\r\n----------------------------------------------------------------------");
           	    resultStr = resultStr.replace(/<style .*?>/gi, "<style>");
           	    resultStr = resultStr.replace(/<style>.*?<\/style>/gi, "");
           	    resultStr = resultStr.replace(/<script .*?>/gi, "<script>");
           	    resultStr = resultStr.replace(/<script>.*?<\/script>/gi, "");
           	    resultStr = resultStr.replace(/<.*?>/gi, "");
           	    
           	    return resultStr;
			}
		</script>
	</body>
</html>



