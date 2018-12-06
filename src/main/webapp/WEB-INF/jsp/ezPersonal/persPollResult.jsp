<%@page import="org.w3c.dom.Document"%>
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
		<link rel="stylesheet" href="${util.addVer('/css/ezPoll/vote.css')}" type="text/css">
		<style type="text/css">
			.poll_list1 {
				display: inline-block;
				width: 100%;
				font-size: 12px;
				border-bottom: 1px dashed rgb(229, 229, 229);
				height:36px;
				line-height: 36px;
			}
			.question {
				background: #f2f2f2 0px 0px;
				margin-top: 0px;
				height: 60px;
				word-break: break-all;
				border: 1px solid #ddd;
				overflow-y: hidden;
				width: auto;
			}

			/* 2018-07-27 김보미 */
			.question span {
				display: inline-block;
				font-size: 13px;
				font-weight: bold;
				width:45%;
				margin: 5px;
			}

			.box {
				OVERFLOW-X: hidden;
				padding: 10px;
				overflow-y: auto;
				height: 225px;
				width: 413px;
				border-top: 0px;
				border-collapse: collapse;
				empty-cells: show;
				margin-top: -5px;
				border: 1px solid #ddd;
			}

			.Vnum {
				margin: 0px 5px 0px 0px;
				padding: 1px 6px;
				border-radius: 25px;
				-webkit-border-radius: 25px;
				/*-moz-border-radius: 25px; */
				font-size: 13px;
				font-weight: bold;
				color: #fff;
			}

			.Pt_QstOptTitleDiv {
				width: 22%;
				overflow: hidden;
			}

			.graphbar1 {
				width: 60%;
				overflow: hidden;
				height: 13px;
			}

			.poll_list1 .graphbar1 .gx_bar11 {
				height: 13px;
				margin: 0px;
				padding: 0px;
				border: 0px;
				margin-top: -1px;
				background: #0470e4;
			}
			
			.poll_list1 .graphbar1 {
				margin: 11px 0px 10px 0px;
				padding: 0px;
				border: 1px solid #eee;
				height: 13px;
				background-color: #d5d5d5;
				border-radius:25px;
			}

			li:nth-child(1) .Vnum, li:nth-child(1) .graphbar1 .gx_bar11 {
				background: #0470e4;
				border: 1px solid #0470e4;
			}
			li:nth-child(2) .Vnum, li:nth-child(2) .graphbar1 .gx_bar11 {
				background: #81bc3d;
				border: 1px solid #81bc3d;
			}
			li:nth-child(3) .Vnum, li:nth-child(3) .graphbar1 .gx_bar11 {
				background: #fa9900;
				border: 1px solid #fa9900;
			}
			li:nth-child(4) .Vnum, li:nth-child(4) .graphbar1 .gx_bar11 {
				background: #0dbeff;
				border: 1px solid #0dbeff;
			}
			li:nth-child(5) .Vnum, li:nth-child(5) .graphbar1 .gx_bar11 {
				background: #0dbeff;
				border: 1px solid #0dbeff;
			}
			li:nth-child(6) .Vnum, li:nth-child(6) .graphbar1 .gx_bar11 {
				background: #0470e4;
				border: 1px solid #0470e4;
			}
			li:nth-child(7) .Vnum, li:nth-child(7) .graphbar1 .gx_bar11 {
				background: #81bc3d;
				border: 1px solid #81bc3d;
			}
			li:nth-child(8) .Vnum, li:nth-child(8) .graphbar1 .gx_bar11 {
				background: #fa9900;
				border: 1px solid #fa9900;
			}
			li:nth-child(9) .Vnum, li:nth-child(9) .graphbar1 .gx_bar11 {
				background: #0dbeff;
				border: 1px solid #0dbeff;
			}
			li:nth-child(10) .Vnum, li:nth-child(10) .graphbar1 .gx_bar11 {
				background: #0470e4;
				border: 1px solid #0470e4;
			}
			li:nth-last-child(1) {
				border-bottom: 0px;
			}
			.spanPollCount {
				float: right;
				width: 50%;
				display: inline-block;
				text-align: right;"
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
		<h1>빠른설문</h1>
		<div id="close">
			<ul>
				<li>
					<span onClick="close_btn()"></span>
				</li>
			</ul>
		</div>
		<table id="popupContentTb">
			<tr>
				<td>
					<div class="question">
						<span class="spanPollTitle" title='${subject}'>"${subject}"</span>
						<span class="spanPollCount">${subjectCont}</span>
					</div>
				</td>
			</tr>
			<tr style="height: 100%">
				<td>
					<div id="receivelist" class="box">${strHtml}</div>
				</td>
			</tr>
		</table>
	</body>
</html>