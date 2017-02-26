<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="/css/help.css" rel="stylesheet" type="text/css">
		<style type="text/css">
			.warningbox01 { width:490px; margin-top:200px; margin-left:220px; border:1px solid #cccaca; background:#e8e8e8;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}
			.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 20px 25px;}
			.warnintxt01 { position:relative ;padding-bottom:10px;}
			.warningimg { position:absolute; top:0px; left:0px;}
			.warningdl { padding:10px 0px 5px 150px; margin:0px 0px 0px 0px;}
			.warningdl dt { height:40px; margin-top:10px;}
			.warningdl dd { padding:0px 0px 0px 5px; margin:0px; height:50px; font-weight:bold; font-size:14px; color:#333333;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
		</style>
		<script type="text/javascript" src="/js/pdf_Check.js"></script>	
		</head>
		<script type="text/javascript">
	        window.onload = function () {
	            var Rvalue = isInstalledAcrobatReader();
	            if (Rvalue != "OK") {
	                document.getElementById("div_warning").style.display = "";
	                document.getElementById("pdfcontent").style.display = "none";
	            }
	            else {
	                document.getElementById("div_warning").style.display = "none";
	                document.getElementById("pdfcontent").style.display = "";
	                document.getElementById("pdfcontent").src = getQuerystring("id", "") + ".pdf";
	            }            
	        }
	
	        function getQuerystring(key, default_) {
	            if (default_==null) default_=""; 
	            key = key.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
	            var regex = new RegExp("[\\?&]"+key+"=([^&#]*)");
	            var qs = regex.exec(window.location.href);
	            if(qs == null)
	                return default_;
	            else
	                return qs[1];
	        }
    </script>
		<body class="mbody">
      		<div id="div_warning" class="warningbox01">
        		<div class="warningbox02">
  	    			<div class="warnintxt01">
	    				<span class="warningimg"><img src="/images/help/warning02.gif" width="136" height="112"></span>
	    				<dl class="warningdl">
	    					<dt><img alt="" src="/images/help/warning01.gif" width="183" height="27"></dt>
	    					<dd>PDF Viewer가 설치되어 있지 않습니다.<br/></dd>
	    				</dl>
	    			</div>
	    		<!-- 삽입할 내용이 없으신경우 아래 <p></p> 태그를 삭제해주세요 -->
	    		</div>
    		</div>
    	<iframe id="pdfcontent" style="width:100%;height:100%" />  
	</body>
</html>