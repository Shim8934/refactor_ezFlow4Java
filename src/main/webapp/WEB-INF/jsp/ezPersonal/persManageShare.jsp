<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPersonal.t4465'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<!-- data picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<style>
			.mouseIn {
				background-color : rgb(244,245,245);
			}
			
			.trClick {
				background-color : rgb(237,244,253);
			}
			
			#shareApprovalList tbody tr:not(#noItem) {
				cursor : pointer;
			}
		</style>
		<script type="text/javascript">
			$(document).on('mouseover', '#shareApprovalList tbody tr:not(#noItem)', function(){
				$(this).addClass("mouseIn");
			});
			
			$(document).on('mouseout', '#shareApprovalList tbody tr:not(#noItem)', function(){
				$(this).removeClass("mouseIn");
			});
			
			$(document).on('click', '#shareApprovalList tbody tr:not(#noItem)', function(){
				if ($(this).find("input[type=checkbox]").prop("checked")) {
					$(this).removeClass("trClick").find("input[type=checkbox]").prop("checked", false);
				} else {
					$(this).addClass("trClick").find("input[type=checkbox]").prop("checked", true);
				}
			});
			
			//체크박스로 클릭하면 체크가 되지 않는 문제로 추가.
			$(document).on('click', '#shareApprovalList input[type=checkbox]:not(#checkboxAll)', function(){
				if ($(this).prop("checked")) {
					$(this).prop("checked", false);
				} else {
					$(this).prop("checked", true);
				}
			});
			
			window.onload = function() {
				shareSetList();
			}
			
			function shareSetList() {
				//리스트 뿌리기
				$.ajax({
					url : '/ezPersonal/shareApprovalList.do',
					method : 'POST',
					dataType : 'text',
					success : function(rtnValue) {
						shareSetList_complete(rtnValue);
					},
					error : function() {
						alert("<spring:message code='ezApprovalG.bhs04'/>");
					}
				})
			}
			
			function shareSetList_complete(rtnValue) {
				var listdom = loadXMLString(rtnValue);
				var listLength = listdom.getElementsByTagName("ROW").length;
				var strHTML = "";
				
				if (listLength == 0) {
					strHTML = "<tr id='noItem'><td colspan='5' style='text-align: center'><spring:message code='ezApprovalG.bhs21'/></td></tr>";	
				} else {
					for (var i = 0; i < listdom.getElementsByTagName("ROW").length; i++) {
						strHTML += "<tr data1='" + getNodeText(listdom.getElementsByTagName("SHAREUSERID")[i]) + "'>";
						
						strHTML += "<td style='text-align: center;'><div class='custom_checkbox'><input type='checkbox'/></div></td>";
						strHTML += "<td>" + getNodeText(listdom.getElementsByTagName("SHAREUSERNAME")[i]) + "</td>";
						strHTML += "<td>" + getNodeText(listdom.getElementsByTagName("SHAREUSERDEPTNAME")[i]) + "</td>";
						strHTML += "<td>" + getNodeText(listdom.getElementsByTagName("SHAREUSERTITLE")[i]) + "</td>";
						strHTML += "<td>" + getNodeText(listdom.getElementsByTagName("SHAREDATE")[i]).split(" ")[0] + "</td>";
					}
				}
				
				document.getElementById("shareApprovalList").getElementsByTagName("tbody")[0].innerHTML = strHTML;
			}
			
			var share_cross_dialogArguments = new Array();
			function addShare_onclick() {
			    share_cross_dialogArguments[1] = addShare_onclick_complete;
		        var OpenWin = window.open("/ezPersonal/selectShareApproval.do", "SelectPerson_cross", GetOpenWindowfeature(715, 535));
		        try { OpenWin.focus(); } catch (e) { }
			}
			
			function addShare_onclick_complete(userId, deptId) {
				$.ajax({
					url : '/ezPersonal/saveShareApproval.do',
					method : 'POST',
					dataType : 'text',
					data : {
						shareUserId : userId,
						shareUserDeptId : deptId
					},
					success : function() {
						shareSetList();
						alert("<spring:message code='ezApprovalG.bhs05'/>");
					},
					error : function() {
						
					}
				})
			}
			
			function delShare_onclick() {
				var checkedUserList = "";
				var selectedChkLength = $("#shareApprovalList tbody").find("input[type=checkbox]:checked").length;
				
				if (selectedChkLength == 0) {
					alert("<spring:message code='ezApprovalG.bhs06'/>");
					return;
				}
				
				$("#shareApprovalList tbody").find("input[type=checkbox]:checked").each(function(index, item){
					if ($(item).prop("checked")) {
						checkedUserList += $(item).closest("tr").attr("data1");
						if (index != selectedChkLength - 1) {
							checkedUserList += ",";
						}
					}
				});
				
				$.ajax({
					url : '/ezPersonal/removeShareApproval.do',
					method : 'POST',
					dataType : 'text',
					data : {
						shareUserId : checkedUserList
					},
					success : function() {
						alert("<spring:message code='ezApprovalG.bhs07'/>");
						shareSetList();
					},
					error : function() {
						
					}
				})
			}
						
			function checkboxAll_click() {
				var chk = $("#checkboxAll").prop("checked"); //true, false
				if (chk) {
					$("#shareApprovalList tbody").find("input[type=checkbox]").prop("checked", true);
					$("#shareApprovalList tbody tr:not(#noItem)").addClass("trClick");
				} else {
					$("#shareApprovalList tbody").find("input[type=checkbox]").prop("checked", false);
					$("#shareApprovalList tbody tr:not(#noItem)").removeClass("trClick");
				}
			}
		</script>
	</head>
	<body>
		<br>
		<span class="txt">▒ <spring:message code='ezApprovalG.bhs08' /></span><br/>
		<span class="txt">▒ <spring:message code='ezApprovalG.bhs09' /></span><br/>
	   	<%--
	    <h2 class="txt">▒ <spring:message code='ezApprovalG.bhs08'/></h2>
	    <h2 class="txt" style="margin-top:3px">▒ <spring:message code='ezApprovalG.bhs09'/></h2> 
	    --%>
	    <table class="mainlist" style="width:750px; margin-top: 10px;">
	    	<tbody>
	    		<tr>
	    			<td style="padding-left:0px; border-bottom:0;">
	    				<div style="BORDER:0;WIDTH:100%; height:400px; overflow-y: auto; border-top-color: #dbdbda; border-right-color: #dbdbda; border-bottom-color: #dbdbda; border-left-color: #dbdbda; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid;">
	    					<table id="shareApprovalList" class="mainlist" cellspacing="0" cellpadding="0" border="0" style="width:100%;">
						    	<thead>
						    		<tr>
						    			<th style="width: 30px; text-align: center;"><div class='custom_checkbox'><input type="checkbox" id="checkboxAll" name="checkboxAll" onclick="checkboxAll_click()"/></div></th>
						    			<th><spring:message code='ezApprovalG.bhs10'/></th>
						    			<th><spring:message code='ezApprovalG.bhs11'/></th>
						    			<th><spring:message code='ezApprovalG.bhs12'/></th>
						    			<th><spring:message code='ezApprovalG.bhs13'/></th>
						    		</tr>
						    	</thead>
						    	<tbody>
						    		<tr>
						    			<td colspan="5" style="text-align:center;"><spring:message code='ezApprovalG.bhs21'/></td>
						    		</tr>
						    	</tbody>
						    </table>
	    				</div>
	    			</td>
	    		</tr>
	    	</tbody>
	    </table>
	    <div class="btnpositionJsp" style="width:750px;">
	    	<a class="imgbtn" onclick="addShare_onclick()"><span><spring:message code='ezApprovalG.bhs14'/></span></a>
	    	<a class="imgbtn" onclick="delShare_onclick()"><span><spring:message code='ezApprovalG.bhs15'/></span></a>
	    </div>    
	</body>
</html>