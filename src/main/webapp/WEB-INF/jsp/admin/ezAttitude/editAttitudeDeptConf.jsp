<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t225' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jstree/style.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezJournal/journal_css.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jstree/jstree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezJournal/journal_script.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	   	<script type="text/javascript">
	   		//트리조직도 JSON
	   		var treeContent;
	   		//레이어팝업의 부서 정보
	   		var lpDeptId;
	   		var lpDeptName;
	   		//레이어팝업의 오른쪽의 부서정보
	   		var lpDepts = [];
	   		var lpDeptNames = [];
	   		//오른쪽에서 없앨 부서
	   		var targetDept;
	   		//회사 id
	   		var companyId = "${companyId}";
	   		//회사 출/퇴근 시간
			var companyStartTime = "${companyStartTime}";
			var companyEndTime = "${companyEndTime}";
	   		
	   		$(document).ready(function() {
	   			treeContent = ${deptList};
		   		setDeptList();
		    	
	   			$(function () {
		   			$(document).on({
		   				"dblclick":function(){delTargetDept(this);},
		   				"click":function(){targetDept = this;
			   				$("*").removeClass("selectTR");
				   			$(this).addClass("selectTR");
		   				}
	   				},"#lplistView tr");
	   			});

		   		//timepicker셋팅
		   		$('#workStartTime').timepicker({ 'timeFormat': 'H:i' });
        		$('#workEndTime').timepicker({ 'timeFormat': 'H:i' });
        		
        		//근무시간설정 회사 따르기 여부
    			$("#gubun").on('change', function() {
    				if($("#gubun").is(":checked") == true) {
    					$("#workStartTime").val(companyStartTime);
    					$("#workEndTime").val(companyEndTime);
    					$("#workStartTime").prop('readonly', true);
    					$("#workEndTime").prop('readonly', true);
    				} else {
    					$("#workStartTime").prop('readonly', false);
    					$("#workEndTime").prop('readonly', false);
    				}
    			});
        		
        		$("#gubun").click();
   			});
	   	
	   		//조직도 뿌리는 펑션
	   		function setDeptList() {
				$('#treeview').on('changed.jstree', function (e, data) {
					lpDeptId = data.instance.get_node(data.selected).id;
					lpDeptName = data.instance.get_node(data.selected).text;
				  }).on('dblclick.jstree', function (e, data) {
						addDeptInLP();
				}).jstree({ 
					'core' : {'data' : treeContent, 'multiple' : false},
					'plugins': ["wholerow"],
					 'themes' : {'responsive' : true}
				}).on('ready.jstree', function(e, data) {
					var offset = $(".jstree-wholerow-clicked").offset();
		   	    	var jstree = document.getElementById("treeview");
		   	        $('#treeview').animate({scrollTop : offset.top - jstree.offsetHeight / 2}, 40);
			    });
	   		}
			
	   		//부서 리스트에 추가
	   		function addDeptInLP() {
	   			var flag = true;
	   			
	   			for (var i = 0; i < lpDepts.length; i++) {
					if (lpDepts[i] == lpDeptId) {
		   				alert("<spring:message code='ezAttitude.t203' />");
						flag = false;
					}
				}
	   			
	   			if (flag) {
		   			$("#lplistView .mainlist_free").append("<tr targetId="+lpDeptId+" targetName="+lpDeptName+" style='cursor: pointer;' class='hover'><td align='left' style='width:250px;'>"+lpDeptName+"</td></tr>");
		   			lpDepts.push(lpDeptId);
		   			lpDeptNames.push(lpDeptName);
	   			}
	   		}
	   		
	   		//레이어팝업의 오른쪽에 선택된 부서를 삭제
	   		function delTargetDept(elem) {
	   			var targetDeptId = $(".selectTR").attr("targetId");
	   			if (targetDeptId) {
		   			var targetDeptName = $(".selectTR").attr("targetName");
		   			
	   				lpDepts.splice(lpDepts.indexOf(targetDeptId), 1);
	   				lpDeptNames.splice(lpDeptNames.indexOf(targetDeptName), 1);
	   				$(".selectTR").remove();
	   			} else {
	   				alert("<spring:message code='ezAttitude.t204' />");
	   			}
	   		}
	   		
	   		function checkPattern() {
				var timePattern = /^([01][0-9]|2[0-3]):([0-5][0-9])$/;
				
				if ((timePattern.test($("#workStartTime").val()) && timePattern.test($("#workEndTime").val())) || ($("#workStartTime").val() == "" && $("#workEndTime").val() == "")) {
					return true;
				} else {
					if (!timePattern.test($("#workStartTime").val())&& !timePattern.test($("workEndTime").val())) {
						$("#workStartTime").focus();
						return false;
					} else if (!timePattern.test($("#workStartTime").val())) {
						$("#workStartTime").focus();
						return false;
					} else if (!timePattern.test($("#workEndTime").val())) {
						$("#workEndTime").focus();
						return false;
					}
				}
			}
	   		
	   		//확인
	   		function btnOk_onclick() {
	   			if (lpDepts.toString() == "") {
	   				alert("<spring:message code='ezOrgan.t249' />");
	   				return;
	   			}
	   			
				if (!checkPattern()) {
	    			alert("<spring:message code='ezAttitude.t117' />")
	    			return;
	    		}
				
				if($("#gubun").is(":checked") == true) {
					workStartTime = companyStartTime;
					workEndTime = companyEndTime;
					gubun = "0";
				} else {
					workStartTime = $("#workStartTime").val();
					workEndTime = $("#workEndTime").val();
					gubun = "1";
				}
				
				if (workStartTime > workEndTime) {
					alert("<spring:message code='ezAttitude.t131' />");
		            return;
				}
				
				$.ajax({
	   				type:"post",
	   				dataType:"text",
	   				async : false,
	   				url:"/admin/ezAttitude/editAttitudeDeptConfig.do",
	   				data:{
	   					companyId : companyId,
	   					selectDeptIds : lpDepts.toString(),
	   					workStartTime : workStartTime,
	   					workEndTime : workEndTime,
	   					gubun : gubun
	   				},
	   				success: function(result){
						if (result == "ok") {
							alert("<spring:message code='ezAttitude.t155' />");
							opener.getUserConfList();
		   					window.close();
						} else {
							alert("<spring:message code='ezAttitude.t125' />");
		   					window.close();
						}
	   				}
	   			});
			}
			//취소
			function btncancel_onclick() {
				window.close();
			}
		</script>
		
		<style>
			tr.hover:hover{background:#eee; color:#fff;}
			
			.selectTR{
				background-color: #f1f8ff;
			}
		</style>
	</head>
	
	<body class="popup">
        <h1><spring:message code='ezAttitude.t225' /></h1>
        <div id="close">
            <ul>
                <li><span onclick="return btncancel_onclick()"></span></li>
            </ul>
        </div>
       	<table>
            <tr>
                <td class="box" style="width: 250px; height: 465px;">
                    <div style="width: 250px; height: 470px; overflow-x: auto; overflow-y: auto;" id="treeview"></div>
                </td>
                <td style="width: 30px; text-align: center;" rowspan="2">                            
                	<img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="addDeptInLP()"><br>
                	<img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="delTargetDept(targetDept)">
                </td>
                <td class="listview" style="width: 250px; height: 465px; vertical-align: top;" id="lplistView" rowspan="2">
                	<div style="width: 100%; height: 100%; overflow: auto;">
	                	<table class="mainlist_free">
						</table>
					</div>
                </td>    
            </tr>
        </table>
        <table class="content" style="margin-top: 8px;"> 
			<tr>
				<th><spring:message code='ezAttitude.t126' /></th>
				<td><input type="checkbox" id="gubun" name="gubun" /><spring:message code='ezAttitude.t127' /></td>
			</tr>
			<tr>
				<th><spring:message code='ezAttitude.t12' /></th>
				<td><span><input id="workStartTime" type="text" style="width:50px;" />&nbsp; ~ &nbsp;<input id="workEndTime" type="text" style="width:50px;" /></span></td>
			</tr>
		</table>
		<div class="btnpositionNew">
			<a class="imgbtn"><span onclick="return btnOk_onclick()"><spring:message code='ezAttitude.t16' /></span></a>
		</div>
	</body>
</html>