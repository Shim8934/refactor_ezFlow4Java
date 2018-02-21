<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
		<c:choose>
			<c:when test="${mode == 'new'}">
			    <title><spring:message code='ezJournal.t131' /></title>
			</c:when>
			<c:otherwise>
			    <title><spring:message code='ezJournal.t131' /></title>
			</c:otherwise>
		</c:choose>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
	    <link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
	    <link rel="stylesheet" href="/css/ezJournal/journal_css.css" type="text/css" />
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/composeappt.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/jstree/jstree.js"></script>
	    <script type="text/javascript" src="/js/ezJournal/journal_script.js"></script>
	    <script type="text/javascript">
			var companyId = "${userInfo.companyID}"; 
			//트리조직도 JSON
	   		var treeContent;
	    
			// 선택된 일지함의 양식 리스트 가져오기
	    	function getFormList(elem) {
	    		var typeId = $(elem).val();
	    		$.ajax({
	    			type : "POST",
	    			dataType : "html",
	    			async : false,
	    			url : "/ezJournal/getFormList.do",
	    			data : {"companyId" : companyId,
	    					"typeId"	: typeId},
	    			success : function(result) {
	    				$("#optForm").html(result);
	    			}
	    		});
	    	}
	    	
	    	function selectReceiver(){			
				var url = "/ezJournal/selectReceiver.do";
				url += "?companyId=" + companyId;
				window.open(url, "selectReceiver", "width=1100, height=680");
			}
			
	    	$(document).ready(function() {
	    		var firstType = $("#optType").find("option:first");
	    		getFormList(firstType);
	    	});
	    
	    </script>
	</head>
	<body class="popup" style="height: 97%;" ondragover="bodydragover(event)">
	    <table class="layout" style="width: 100%;">
	        <tr>
	            <td style="height: 20px">
	                <div id="menu">
	                    <ul>
	                    	<c:choose>
	                    		<c:when test="${mode eq 'reuse'}">
			                        <li><span onclick="btn_Save('${mode}');"><spring:message code='ezJournal.t73' /></span></li>
	                    		</c:when>
	                    		<c:when test="${mode eq 'modify'}">
			                        <li><span onclick="btn_Save('${mode}');"><spring:message code='ezJournal.t73' /></span></li>
	                    		</c:when>
	                    		<c:otherwise>
			                        <li><span onclick="btn_Save('${mode}');"><spring:message code='ezJournal.t73' /></span></li>
			                        <li><span onclick="btn_TempSave()"><spring:message code='ezJournal.t74' /></span></li>
	                    		</c:otherwise>
	                    	</c:choose>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li><span onclick=""><spring:message code='ezJournal.t75' /></span></li>
	                        <li><span onclick="window.close();"><spring:message code='ezJournal.t27' /></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                    selToggleList(document.getElementById("close"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 20px">
	                <table class="content">
	                    <tr>
	                        <th><spring:message code='ezJournal.t76'/></th>
	                        <td style="width: 300px">
	                        	<select id="optType" style="width: 110px;" onchange="getFormList(this)">
	                        		<c:forEach var="type" items="${typeList}">
	                        			<option value="<c:out value='${type.journaltypeId }'/>"
	                        				<c:if test="${type.journaltypeId eq typeId}">
	                        					selected
	                        				</c:if>
	                        			><spring:message code='${type.journaltypeId }'/></option>
	                        		</c:forEach>
	                        	</select>
	                        	<select id="optForm" style="width:182px;" onchange="">
						                        	
	                        	</select>
	                        </td>
	                        <th><spring:message code='ezJournal.t77' /></th>
	                        <td style="width: 300px;">
	                        	<input type="radio" id="selPublic" name="isPublic" value="Y" checked onclick=""/><label for="selPublic"><spring:message code='ezJournal.t78'/></label>
	                        	<input type="radio" id="selPrivate" name="isPublic" value="N" onclick=""/><label for="selPrivate"><spring:message code='ezJournal.t79'/></label>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezJournal.t80' /></th>
	                        <td colspan="3">
	                            <input id="receiverInput" name="receiverInput" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box; display:none;" onkeyup="return on_keydown(event)" >
	                       		<div id="receiverlist" style="overflow-y: auto; height: 28px; display: inline;"></div>
	                        	<div style="position: absolute; right: 15px; top: 88px;">
	                        		<a class="imgbtn"><span style="text-align: right;" id="clickbtn" onclick="selectReceiver()"><spring:message code='ezJournal.t81'/></span></a>
	                        	</div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezJournal.t56' /></th>
	                        <td colspan="3">
	                            <input type="text" id="txtTitle" style="WIDTH: 100%; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onkeydown="Title_onkeyDown(event)" >
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>  
	        <tr>
	            <td style="vertical-align: top; height: 100%" id="EdtorSize">
	                <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do?type=BOARDBACKGROUND" style="padding: 0; height: 100%; width: 100%; overflow: auto; margin-top:-1px"></iframe>
	            </td>
	        </tr>
	        <tr>
  				<td>
   					<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezCircular/dragAndDrop.do?mode=${mode}&circularID=${circularID}"></iframe>
  				</td>
  			</tr>
	    </table>
	</body>
</html>