<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<spring:message code='ezSchedule.companySc02' />
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
        <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>	
		<style>
			table.content {
				width:100%;
				table-layout:fixed;
				white-space:nowrap;
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
	    	    var strBody = '<html><head><meta content="text/html; charset=utf-8" http-equiv="Content-Type"><style type="text/css">P { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } DIV { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }TD { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } UL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } OL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } LI { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } BODY { MARGIN-RIGHT: 10px; FONT-SIZE:10PT; LINE-HEIGHT:1.3; FONT-FAMILY:Malgun Gothic } TABLE TD { text-indent: 0px } BLOCKQUOTE { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px;}</style></head><body><div><p style="font-size:13pt;font-family:맑은 고딕"><br></p></div></body></html>';
	    	    
                var htmlConv = ConvertHTMLtoMHT(strBody);
	    	    
	    	    $('#content').val(pidCryptUtil.encodeBase64(htmlConv, 64));
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

	    	 	if ($.inArray(strExt, ["xlsx"]) == -1) {
	    	  		alert("<spring:message code='ezAttitude.t260' />");
	    	  		objFile.outerHTML = objFile.outerHTML;
	    	 	}
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

	    	function scheduleExcelUpload() {
	    		if($("[name=excelFile]").val() == null || $("[name=excelFile]").val() == "") {
	                alert("<spring:message code='ezPMS.t106' />");
	                return;
	            }
	    		var form = $("#cForm")[0];
	    		var formData = new FormData(form);

				$.ajax({
	   				type:"post",
	   				url:"/admin/ezSchedule/excelSaveSchedule.do",
	   				processData: false,
                    contentType: false,
	   				data: formData,
	   				dataType: "json",
	   				beforeSend : function() {
	   					ShowMailProgress();
					},
					success : function(data) {
                        HiddenMailProgress();
					    opener.getCompanyScheduleList();
	            		if (data.status == "SUCCESS") {
					        alert("<spring:message code='ezSchedule.t4012' />");
	   						window.close();
	            			opener.getAnnualList();
	            		} else if (data.status == "UPLOAD_EXT_ERROR") {
	            			alert("<spring:message code='ezAttitude.t260' />");
	            		} else if (data.status == "FORM_ERROR") {
	            			alert("<spring:message code='ezSchedule.companySc08' />");
	            		} else {
	            		    alert("<spring:message code='ezSchedule.companySc09' />");
	            		}
	            	},
	   				error : function(xhr, status, error) {
	   				    HiddenMailProgress();
	   					alert("<spring:message code='ezAttitude.t175' />");
	   				}
	   			});
	   		}
	   		
	    	function changeCompany() {
	    	    $('#companyId').val($('#ListCompany option:selected').val());
	    	}
		</script>
	</head>
	<body class="popup">
	    <h1>
	    	<spring:message code='ezSchedule.companySc02' />
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
        <div>
       	<form name="cForm" id="cForm" method="post" onsubmit="return false;" enctype="multipart/form-data">
		<div>
	       	<h2 style="font-weight: normal;font-size:12px;padding-bottom: 5px; float:left;">▒&nbsp;<spring:message code='ezSchedule.companySc06' /></h2>
       	    <a class="imgbtn" style="margin-top:3px; float:right;" href="/files/calendarForAllYears.xlsx" download="<spring:message code='ezSchedule.companySc07' />"><span><spring:message code='ezAddress.lhm2' /></span></a>
       	</div>
        <table class="content" style="margin-bottom:10px;">
        	<tr>
                <th style="width:100px; text-align:center"><spring:message code='ezSchedule.t2000' /></th>
                <td>
                    <select id="ListCompany" onchange="changeCompany()">${companySel}</select>               
                </td>
            </tr>
        	<tr>
	            <th style="width:100px; text-align:center"><spring:message code='ezAttitude.t257' /></th>
	            <td>
	        		<input name="excelFile" id="excelFile" type="file" style="width:100%; height: 25px !important;" accept=".xlsx" onchange="CheckUploadFileSize(this); CheckuploadFileExt(this);">
	            </td>
	        </tr>
        </table>
            <span style="color: red;font-weight: bold;font-size: 13px;">※ <spring:message code='ezSchedule.companySc03' /></span><br>
            <span style="color: red;font-weight: bold;font-size: 13px;">※ <spring:message code='ezSchedule.companySc04' /></span><br>
            <!--<span style="color: red;font-weight: bold;font-size: 13px;">※ <spring:message code='ezSchedule.companySc05' /></span>-->
       		<input name="companyId" id="companyId" type="hidden" value="${companyId}">
       		<input name="content" id="content" type="hidden">
        </form>
        </div>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="scheduleExcelUpload();" ><spring:message code='ezBoard.t321' /></span></a>
	    </div>
        <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
	    <div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="padding-top:20px;">
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
        </div>
        <iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
	</body>
</html>