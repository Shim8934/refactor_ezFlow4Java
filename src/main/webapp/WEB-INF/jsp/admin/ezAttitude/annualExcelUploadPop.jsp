<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<spring:message code='ezAttitude.t235' />
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<style>
			table.content {
				width:100%;
				table-layout:fixed;
				white-space:nowrap;
			}
	    	table.content tr:not(.tr_noItems) td {
	    		table-layout : fixed;
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    		text-align:center;
	    	}
	    	#loading-image {  
				 position: absolute;  
				 top: 50%;  
				 left: 50%; 
				 z-index: 100; 
			 }
	    </style>
	    <script type="text/javascript">	
	    	$(document).ready(function(){
   			});
	    	
	    	function CheckUploadFileSize(objFile) {
    	 		var nMaxSize = 10 * 1024 * 1024; // 10 MB
	    		var nFileSize = objFile.files[0].size;

		    	if (nFileSize > nMaxSize) {
		    		alert("<spring:message code='ezAttitude.t261' />\n" + nFileSize + " byte");
		    		objFile.outerHTML = objFile.outerHTML;
		    	}
	    	}

	    	function CheckuploadFileExt(objFile) {
	    		var strFilePath = objFile.value;

	    	 	var strExt = strFilePath.split('.').pop().toLowerCase();

	    	 	if ($.inArray(strExt, ["xls"]) == -1) {
	    	  		alert("<spring:message code='ezAttitude.t260' />");
	    	  		objFile.outerHTML = objFile.outerHTML;
	    	 	}
	    	}
	    	
	    	function exportExcel() {
	    		exportExcelframe.location.href="/admin/ezAttitude/excelAnnualFormatDownload.do";
		    	exportExcelframe.target="_blank";
	    	}
	    	
			function ShowMailProgress() {
				var CurrenWidth = window.innerWidth;
	        	
			    document.getElementById("mailPanel").style.display = "";
			    document.getElementById("MailProgress").style.top = "60px";
			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
			    document.getElementById("MailProgress").style.display = "";
			}
			function HiddenMailProgress() {
			    document.getElementById("mailPanel").style.display = "none";
			    document.getElementById("MailProgress").style.display = "none";
			}

	    	//전체 연차 등록/수정
	    	function annualExcelUpload() {
	    		if($("[name=excelFile]").val() == null || $("[name=excelFile]").val() == "") {
	                alert("<spring:message code='ezAttitude.t259' />");
	                return;
	            }
// 	    		if($("[name=changeReason]").val() == null || $("[name=changeReason]").val() == "") {
// 	                alert("<spring:message code='ezAttitude.t243' />");
// 	                return;
// 	            }
	    		var form = $("#cForm")[0];
	    		var formData = new FormData(form);

				$.ajax({
	   				type:"post",
	   				url:"/admin/ezAttitude/annualExcelUpload.do",
	   				processData: false,
	   				contentType: false,
	   				data: formData,
	   				dataType: "json",
	   				beforeSend : function() {
	   					ShowMailProgress();
					},
					success : function(data) {
	            		if (data.status + "" == "ok") {
	            			alert(data.data+"");
	            			opener.getAnnualList();
	            			HiddenMailProgress();
	   						window.close();
	            		} else if (data.status + "" == "UPLOAD_EXT_ERROR") {
	            			HiddenMailProgress();
	            			alert("<spring:message code='ezAttitude.t260' />");
	            		} else {
	            			HiddenMailProgress();
	            			alert("<spring:message code='ezAttitude.t175' />");
	            		}
	            	},
	   				error : function() {
	   					alert("<spring:message code='ezAttitude.t175' />");
	   				}
	   			});
	   		}
	    	
		</script>
	</head>
	<body class="popup">
	    <h1>
	    	<spring:message code='ezAttitude.t235' />
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
        <div>
       	<form name="cForm" id="cForm" method="post" onsubmit="return false;" enctype="multipart/form-data">
		<div>
	       	<h2 style="font-weight: normal;font-size:12px;padding-bottom: 5px; float:left;">▒&nbsp;<spring:message code='ezAttitude.t258' /></h2>
	       	<a class="imgbtn" style ="margin-top:3px; float:right;"><span onclick="exportExcel();"><spring:message code='ezAddress.lhm2' /></span></a>
       	</div>
        <table class="content">
        	<tr>
	            <th style="width:100px; text-align:center"><spring:message code='ezAttitude.t257' /></th>
	            <td>
	        		<input name="excelFile" id="excelFile" type="file" style="width:100%; height: 25px !important;" accept=".xls" onchange="CheckUploadFileSize(this); CheckuploadFileExt(this);">
	            </td>
	        </tr>
<!--         	<tr> -->
<%-- 	            <th style="width:100px; text-align:center"><spring:message code='ezAttitude.t262' /></th> --%>
<!-- 	            <td> -->
<!--         			<input name="changeReason" id="changeReason" type="text"  style="width:100%;text-align:left;padding-bottom: 5px;" value=""> -->
<!-- 	            </td> -->
<!-- 	        </tr> -->
        </table>
			<span style="color: red;font-weight: bold;font-size: 13px;">※ <spring:message code='ezAttitude.t315' /></span>
       		<input name="companyId" id="companyId" type="hidden" value="${companyId}">
       		<input name="flagCheck" id="flagCheck" type="hidden" value="excelChange">
        </form>
        </div>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="annualExcelUpload();" ><spring:message code='ezBoard.t321' /></span></a>
	    </div>
        <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
	    <div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="padding-top:20px;">
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
        </div>
        <iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
	</body>
</html>