<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><spring:message code='ezApprovalG.t1'/></title>
		<script type="text/javascript">
		    window.onload = function () {
                if(sessionStorage.getItem("docID")){
                    reload.action = location.pathname;
                    var param = reload.children;
                    for(var i = 0; i < param.length; i++){
                        param[i].value = sessionStorage.getItem(param[i].id);
                    }
                    reload.submit();
                }else{
                    img.style.display = "";
                    document.title = "warning";
                }
		    }
        </script>
		<style type="text/css">
			<c:choose>
				<c:when test="${pPreviewShow_HOW eq 'W'}">
					.warningbox01 { width:540px; margin-top:50px; margin-left:auto; margin-right:auto; border:1px solid #cccaca; background:#e8e8e8;}
				</c:when>
				<c:otherwise>
					.warningbox01 { width:540px; margin-top:200px; margin-left:auto; margin-right:auto; border:1px solid #cccaca; background:#e8e8e8;}
				</c:otherwise>
			</c:choose>
			.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 20px 25px;}
			.warnintxt01 { position:relative ;padding-bottom:10px;}
			.warningimg { position:absolute; top:0px; left:0px;}
			.warningdl { padding:10px 0px 5px 150px; margin:0px 0px 0px 0px;}
			.warningdl dt { height:40px; margin-top:10px;}
			.warningdl dd { padding:0px 0px 0px 5px; margin:0px; height:50px; font-weight:bold; font-size:14px; color:#333333;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
		</style>
	</head>
	<body>
	<form id="reload" method="post">
	    <input type="hidden" id="docID" name="docID">
	    <input type="hidden" id="share" name="share">
	    <input type="hidden" id="isPreview" name="isPreview">
	    <input type="hidden" id="allFlag" name="allFlag">
	    <input type="hidden" id="listSusin" name="listSusin">
	    <input type="hidden" id="sendType" name="sendType">
	    <input type="hidden" id="docAttachParent" name="docAttachParent">
	    <input type="hidden" id="admin" name="admin">
	    <input type="hidden" id="listType" name="listType">
	    <input type="hidden" id="pageType" name="pageType">
	    <input type="hidden" id="isOpinion" name="isOpinion">
	    <input type="hidden" id="callBackType" name="callBackType">
	</form>
	<div id="img" class="warningbox01" style="display:none">
	  <div class="warningbox02">
	  	<div class="warnintxt01">
			<span class="warningimg"><img src="/images/warning02.gif" width="136" height="112"></span>
		<dl class="warningdl">
			<dt><img alt="" src="/images/warning01.gif" width="183" height="27"></dt>
			<c:choose>
				<c:when test="${chk == 'no'}">
				<dd><spring:message code='main.t00001_1' /><br/>
				</dd>
				</c:when>
				<c:otherwise>
				<dd><spring:message code='main.t00001' /><br/>
				</dd>
				</c:otherwise>
			</c:choose>
			
		</dl>
		</div>
		<!-- 삽입할 내용이 없으신경우 아래 <p></p> 태그를 삭제해주세요 -->
		</div>
	</div>
	</body>
</html>