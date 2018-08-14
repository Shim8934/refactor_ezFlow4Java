<%@page import="org.w3c.dom.Document"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPersonal.t246' />${title}</title>
		<link rel="stylesheet"  href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<!-- 2018-07-25 김보미 - 투표모듈 css맞추기 위해 추가 -->
		<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/ezPoll/vote.css")%>" type="text/css">
		<style type="text/css">
        	.question {
	            background: url(/images/kr/main/popup_pollimg.gif) no-repeat #f2f2f2 0px 0px;
            	padding: 5px 0px 5px 55px;
            	margin-top: 0px;
            	height: 60px;
            	word-break: break-all;
            	border: 1px solid #ddd;
        	}
        	.question p {
        		/* 2018-07-27 김보미 */
	            /* margin: 0px; */
	            margin: 0px 0px 4px 0px;
            	padding: 0px;
            	font-size: 12px;
            	font-weight: bold;
            	color: #4a83d5;
        	}
        	/* 2018-07-27 김보미 */
        	.question span {
        		display: block;
        		padding-right: 2px;
        	}
    	</style>
		<script type="text/javascript">
			var ReturnFunction;
			var parent;
			var paparent;
        	window.onload = function () {
	            try {
                	ReturnFunction = opener.PollResult_Cross_dialogArguments[1];
                	
                	if(ReturnFunction!= null) {
                		if(window.opener.opener != null) {
                			parent = window.opener.opener;
                			
        		            if(window.opener.opener.opener != null) {
        		            	paparent = window.opener.opener.opener;
        		            }
        		        }
                		window.opener.close();
                	}
            	} catch (e) {}
		    	//2018-07-26 김보미 - 크롬/ie 양 사이드 여백 상이한것 조정
		    	var ua = navigator.userAgent;
		    	if (ua.indexOf("Chrome") == -1) {
		    		$("#popupContentTb").css("margin-left","2px");
		    	}
        	}
        	function close_btn() {
	            if(ReturnFunction!= null) {
	            	if(parent != null) {
                		parent.location.reload();
	            	}
	            	
	            	if(paparent != null) {
	            		paparent.location.reload();
	            	}
	            }
            	window.close();
        	}
		</script>
	</head>
	<body class="popup" style="overflow:hidden"> 
  		<h1>Quick Poll</h1>
  		<div id="close"><ul><li><span onClick="close_btn()"></span></li></ul></div>
  		<!-- 2018-07-26 김보미 - 테이블 아이디 추가 -->
    	<!-- <table> -->
    	<table id="popupContentTb">
	        <tr>
    	        <td>
    	        	<!-- 2018-07-27 김보미 - 스크롤바 생성 제거, ellipsis처리 -->
<!--         	        <div class="question" style="overflow-y:auto;width:378px"> -->
<%-- 	        	        <p><spring:message code='ezPersonal.t2000' />:</p> --%>
<%--                     	<span>${subject}</span> --%>
<!--                 	</div> -->
        	        <div class="question" style="overflow-y:hidden;width:378px">
	        	        <p><spring:message code='ezPersonal.t2000' />:</p>
                    	<span title='${subject}'>${subjectCont}</span>
                	</div>
            	</td>
        	</tr>
        	<tr style="height:100%">
            	<td>
                	<div id="receivelist" style="OVERFLOW-X: hidden; padding:10px;overflow-y:auto;height:225px;width:413px;border-top:0px" class="box"> 
						${strHtml}                    	
                	</div>
            	</td>
        	</tr>
    	</table>
	</body>
</html>