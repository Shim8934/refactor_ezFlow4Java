<%-- 사용 안 해서 주석처리
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<title><spring:message code='ezMemo.t0055'/></title>
</head>
<script>
			var memoId = "<c:out value='${memo.memo_id}' />";
			
			window.onload = function() {
				var MainHeight = document.documentElement.clientHeight - 122;
		        var MainWidth = document.documentElement.clientWidth - 32;
		        $("textarea").css("height", parseInt(MainHeight) +"px");
		        $("textarea").css("width", parseInt(MainWidth) +"px");
			}
			
			window.onresize = function() {
				var MainHeight = document.documentElement.clientHeight - 122;
		        var MainWidth = document.documentElement.clientWidth - 32;
		        $("textarea").css("height", parseInt(MainHeight) +"px");
		        $("textarea").css("width", parseInt(MainWidth) +"px");
			};
			
			function modifyMemo(status) {
				var beforeContents = $("textarea").html();
				var afterContents = $("textarea").val();
				
				if(beforeContents != afterContents && status == 'save') {
			    	$.ajax ({
		 			   	url : '/ezMemo/memoModify.do',
		 			   	type : 'post',
		                dataType : 'json',
		                async : false,
		                data : { 
		                	memoId : memoId,
		                	contents : afterContents
		                },  
		                cache: false,
		                success: function(result) {
		                	parent.opener.getMemoList();							// 메모 게시판의 리스트 새로고침()				
		                	parent.opener.parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
		                },
		                error : function(e) {
		                	
		                },
		                complete : function() {
							window.close();
						}
					}); 
				}
				else
					window.close();
		    }
			
			function close_onclick() {
		    	window.close();
		    }
</script>
<body class="popup" style="overflow:hidden" onBeforeUnload="modifyMemo()">
		<h1><spring:message code='ezMemo.t0055'/></h1>
		 <div id="close">
		    <ul>
		      <li><span onclick="close_onclick()"></span></li>
		    </ul>
		 </div>
		<div>
			<textarea id="content" style="margin: 0px; resize: none;"><c:out value='${memo.contents}' /></textarea>
		</div>
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn"><span onClick="modifyMemo('save')" style="text-align:center;"><spring:message code='ezBoard.t98' /></span></a>
		</div>
</body>
</html>
 --%>