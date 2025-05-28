<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />	
		<link rel="stylesheet" href="${util.addVer('/css/ezMemo/boardMemo.css')}">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var g_windowReference = null;
			var use_date =  "<c:out value='${memoConfigVO.use_date}' />";
			var use_gadget =  "<c:out value='${memoConfigVO.use_gadget}' />";
			var font_size =  "<c:out value='${memoConfigVO.font_size}' />";
			
         	document.onselectstart = function () { return false; };
         	
        	window.onload = function () {        		
           		if (navigator.userAgent.indexOf('Firefox') != -1) {
               		document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
       		        document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
               		document.body.style.UserSelect = 'none';
           		}	
           		
           		if(font_size === "12") {
        			$(".preview").text("<spring:message code='ezMemo.t0010' />");
        		} else if(font_size === "14") {
        			$(".preview").text("<spring:message code='ezMemo.t0011' />");
        		} else {
        			$(".preview").text("<spring:message code='ezMemo.t0012' />");
        		}
           		$(".preview").css("font-size", font_size + "px");
           		preview();
        	}  
        	
        	// 폰트 사이즈 미리보기
        	function preview() {
        		var previewSize;
        		$(".setFontSize").on("change", function(){
        			previewSize = $(".setFontSize option:selected").val() + "px";
        			
        			if(previewSize === "12px") {
            			$(".preview").text("<spring:message code='ezMemo.t0010' />");
            		} else if(previewSize === "14px") {
            			$(".preview").text("<spring:message code='ezMemo.t0011' />");
            		} else {
            			$(".preview").text("<spring:message code='ezMemo.t0012' />");
            		}
        			$(".preview").css("font-size", previewSize);
        		});
        	}
        	
        	// 저장
        	function Change_Click() {
        		$.ajax({
    				type: "POST",
    				url: "/ezBoard/boardMemoConfigSave.do",
    				dataType: "json",
    				traditional: true,
    				async : false,
    				data: {
    					"use_date": $(".setDateFlag option:selected").val(),
    					"use_gadget": $(".setQuickFlag option:selected").val(),
    					"font_size" : $(".setFontSize option:selected").val() 
    				},
    				success: function() {
    					use_date = $(".setDateFlag option:selected").val();
    					use_gadget = $(".setQuickFlag option:selected").val();
    					font_size = $(".setFontSize option:selected").val();
    					
    					alert("<spring:message code='ezMemo.t0025' />");
    					parent.parent.parent.quickMemoDisplay();
    					parent.parent.parent.getMemoConfig();
    					parent.parent.parent.getMemoList();
    				}, error: function() {
    					alert("<spring:message code='ezMemo.t0059' />");
    				}
    			}); 
        	}
        	
        	// 취소
        	function Cancel_Click() {
        		$(".setDateFlag").val(use_date).attr("selected", "selected");
        		$(".setQuickFlag").val(use_gadget).attr("selected", "selected");
        		$(".setFontSize").val(font_size).attr("selected", "selected");
        		
        		if(font_size === "12") {
        			$(".preview").text("<spring:message code='ezMemo.t0010' />");
        		} else if(font_size === "14") {
        			$(".preview").text("<spring:message code='ezMemo.t0011' />");
        		} else {
        			$(".preview").text("<spring:message code='ezMemo.t0012' />");
        		}
        		$(".preview").css("font-size", font_size + "px");
        	}
        	
        	
    	</script>
	</head>
		<body style="margin-left: 10px; margin-right: 10px;">
			<%-- 
			<br/>	
    		<span class="txt">▒ <spring:message code="ezMemo.t002" /></span>
    		 --%>   
    		<br />
    		<span class="txt">▒ <spring:message code="ezMemo.t003" /></span>
        	<br />
        	<span class="txt">▒ <spring:message code="ezMemo.t004" /></span>
        	<br />
        	<table class="content">
            	<%-- 
            	<tr>
                	<th><spring:message code="ezMemo.t005" /></th>
                	<td> 
						<select class="setQuickFlag">
							<option value="1" <c:if test = "${memoConfigVO.use_gadget eq '1' }" >selected="selected"</c:if>><spring:message code="ezMemo.t008"/></option>
							<option value="2" <c:if test = "${memoConfigVO.use_gadget eq '2' }" >selected="selected"</c:if>><spring:message code="ezMemo.t009"/></option>
						</select>
                   	</td>                   	
            	</tr>
            	 --%>
            	<tr>
                	<th><spring:message code="ezMemo.t006" /></th>
                	<td>
                		<select class="setDateFlag">							
							<option value="1" <c:if test = "${memoConfigVO.use_date eq '1' }" >selected="selected"</c:if>><spring:message code="ezMemo.t008"/></option>
							<option value="2" <c:if test = "${memoConfigVO.use_date eq '2' }" >selected="selected"</c:if>><spring:message code="ezMemo.t009"/></option>							
						</select>
                	</td>
            	</tr>
            	<tr>
                	<th><spring:message code="ezMemo.t007" /></th>
                	<td>
               			<select class="setFontSize">							
							<option value="12" <c:if test = "${memoConfigVO.font_size eq '12' }" >selected="selected"</c:if>><spring:message code="ezMemo.t0010"/></option>
							<option value="14" <c:if test = "${memoConfigVO.font_size eq '14' }" >selected="selected"</c:if>><spring:message code="ezMemo.t0011"/></option>
							<option value="16" <c:if test = "${memoConfigVO.font_size eq '16' }" >selected="selected"</c:if>><spring:message code="ezMemo.t0012"/></option>							
						</select>
						<span class="preview"></span>
                	</td>
            	</tr>
        	</table>
    		<div class="btnpositionJsp">      
        		<a class="imgbtn" onclick="Change_Click()"><span><spring:message code="ezBoard.t98" /></span></a>
        		<a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezBoard.t15" /></span></a>
    		</div>
		</body>
</html>