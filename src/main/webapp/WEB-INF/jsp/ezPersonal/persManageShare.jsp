<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPersonal.t4465'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
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
			})
			
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
						alert("공유자 리스트를 가져오는 도중 오류가 발생했습니다.");
					}
				})
			}
			
			function shareSetList_complete(rtnValue) {
				var listdom = loadXMLString(rtnValue);
				var listLength = listdom.getElementsByTagName("ROW").length;
				var strHTML = "";
				
				if (listLength == 0) {
					strHTML = "<tr id='noItem'><td colspan='5' style='text-align: center'>데이터가 없습니다.</td></tr>";	
				} else {
					for (var i = 0; i < listdom.getElementsByTagName("ROW").length; i++) {
						strHTML += "<tr data1='" + getNodeText(listdom.getElementsByTagName("SHAREUSERID")[i]) + "'>";
						
						strHTML += "<td style='text-align: center;'><input type='checkbox'/></td>";
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
			
			function addShare_onclick_complete(rtnValue) {
				$.ajax({
					url : '/ezPersonal/saveShareApproval.do',
					method : 'POST',
					dataType : 'text',
					data : {
						shareUserId : rtnValue
					},
					success : function() {
						shareSetList();
					},
					error : function() {
						
					}
				})
			}
			
			function delShare_onclick() {
				var checkedUserList = "";
				var selectedChkLength = $("#shareApprovalList tbody").find("input[type=checkbox]:checked").length;
				
				if (selectedChkLength == 0) {
					alert("선택된 공유결재자가 없습니다.");
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
						alert("공유결재자를 삭제하였습니다.");
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
	    <h2 class="txt">▒ 공유결재자는 로그인 사용자의 결재할 문서를 대리 결재할 수 있습니다.</h2>
	    <h2 class="txt" style="margin-top:3px">▒ 대리 결재 시 공유자의 결재사인이 등록됩니다.</h2>
	    <table class="mainlist" style="width:750px;">
	    	<tbody>
	    		<tr>
	    			<td style="padding-left:0px; border-bottom:0;">
	    				<div style="BORDER:0;WIDTH:100%; height:400px; overflow-y: auto; border-top-color: #dbdbda; border-right-color: #dbdbda; border-bottom-color: #dbdbda; border-left-color: #dbdbda; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid;">
	    					<table id="shareApprovalList" class="mainlist" cellspacing="0" cellpadding="0" border="0" style="width:100%;">
						    	<thead>
						    		<tr>
						    			<th style="width: 30px; text-align: center;"><input type="checkbox" id="checkboxAll" name="checkboxAll" onclick="checkboxAll_click()"/></th>
						    			<th>공유자</th>
						    			<th>부서</th>
						    			<th>직급</th>
						    			<th>공유일</th>
						    		</tr>
						    	</thead>
						    	<tbody>
						    		<tr>
						    			<td colspan="5" style="text-align:center;">데이터가 없습니다.</td>
						    		</tr>
						    	</tbody>
						    </table>
	    				</div>
	    			</td>
	    		</tr>
	    	</tbody>
	    </table>
	    <div class="btnpositionJsp" style="width:750px;">
	    	<a class="imgbtn" onclick="addShare_onclick()"><span>추가</span></a>
	    	<a class="imgbtn" onclick="delShare_onclick()"><span>삭제</span></a>
	    </div>    
	</body>
</html>