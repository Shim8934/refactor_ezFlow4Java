<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.kbm31' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code ='ezAttitude.i1' />" type="text/css"/>
		<link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
		<link rel="stylesheet" href="/css/ezJournal/journal_css.css" type="text/css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jstree/jstree.js"></script>
		<script type="text/javascript" src="/js/ezJournal/journal_script.js"></script>
	   	<script type="text/javascript">
	   		//트리조직도 JSON
	   		var treeContent;
	   		//선택된 사원
	   		var selectedUser;
	   		var selectedUserName;
	   		//레이어팝업의 부서 정보
	   		var lpDeptId;
	   		var lpDeptName;
	   		//레이어팝업의 오른쪽의 부서정보
	   		var lpDepts = [];
	   		var lpDeptNames = [];
	   		var lpAuthTypes = [];
	   		//오른쪽에서 없앨 부서
	   		var targetDept;
	   		//현재 레이어팝업에 선택된 유저
	   		var updateUserId;
	   	
	   		function close_Click() {
	   			window.close();
	   		}
	   		//조직도 뿌리는 펑션
	   		function setDeptList() {
				$('#treeview').on('changed.jstree', function (e, data) {
					lpDeptId = data.instance.get_node(data.selected).id;
					lpDeptName = data.instance.get_node(data.selected).text;
					lpAuthType = "R"; //초기값(기본값)
				  }).on('dblclick.jstree', function (e, data) {
						addDeptInLP();
				}).jstree({ 
					'core' : {'data' : treeContent, 'multiple' : false},
					'plugins': ["wholerow"],
					 'themes' : {'responsive' : true}
				});
	   		}
			
	   		//권한부서 리스트에 추가
	   		function addDeptInLP() {
	   			var flag = true;
	   			for (var i = 0; i < lpDepts.length; i++) {
					if (lpDepts[i] == lpDeptId) {
		   				alert("<spring:message code='ezAttitude.kbm33' />");
						flag = false;
					}
				}
	   			if (flag) {
		   			$("#lplistView .mainlist_free").append("<tr targetId="+lpDeptId+" targetName="+lpDeptName+" targetAuthType="+lpAuthType+" style='cursor: pointer;' class='hover'><td align='left' style='width:250px;'>"+lpDeptName+"</td></tr>");
		   			lpDepts.push(lpDeptId);
		   			lpDeptNames.push(lpDeptName);
		   			lpAuthTypes.push(lpAuthType);
	   			}
	   		}
	   		
	   		//레이어팝업의 오른쪽에 선택된 부서를 삭제
	   		function delTargetDept(elem) {
	   			var targetDeptId = $(".selectTR").attr("targetId");
	   			if (targetDeptId) {
		   			var targetDeptName = $(".selectTR").attr("targetName");
		   			var targetAuthType = $(".selectTR").attr("targetAuthType");
		   			
	   				lpDepts.splice(lpDepts.indexOf(targetDeptId), 1);
	   				lpDeptNames.splice(lpDeptNames.indexOf(targetDeptName), 1);
	   				lpAuthTypes.splice(lpAuthTypes.indexOf(targetAuthType), 1);
	   				$(".selectTR").remove();
	   			} else {
	   				alert("<spring:message code='ezAttitude.kbm34' />");
	   			}
	   		}
	   		
	   		//오프너의 부서 이름과 아이디 세팅
	   		function setAuthorViewDept() {
	   			opener.setDeptName(lpDepts, lpDeptNames);
	   			opener.authRadioSet(lpAuthTypes);
	   			window.close();
	   		}
	   		
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

	   			for (var i = 0; i < opener.deptIds.length; i++) {
	   				lpDeptId = opener.deptIds[i];
	   				lpDeptName = opener.deptNames[i];
	   				lpAuthType = opener.authTypes[i];
	   				addDeptInLP();
				}
   			});
		</script>
		
		<style>
			tr.hover:hover{background:#eee; color:#fff;}
			
			.selectTR{
				background-color: rgb(233, 241, 255);
			}
		</style>
	</head>
	
	<body class="popup">
        <h1><spring:message code='ezAttitude.kbm31' /></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="setAuthorViewDept()"><spring:message code='main.t4008'/></span></li>
	            <li><span onclick="close_Click()"><spring:message code='ezOrgan.t143'/></span></li>
	        </ul>
	    </div>
       	<table>
            <tr>
                <td class="box" style="width: 250px; height: 465px;">
                    <div style="width: 250px; height: 100%; overflow-x: auto; overflow-y: auto;" id="treeview"></div>
                </td>
                <td style="width: 30px; text-align: center;" rowspan="2">                            
                	<img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="addDeptInLP()"><br>
                	<img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="delTargetDept(targetDept)">
                </td>
                <td class="listview" style="width: 200px; height: 465px; vertical-align: top;" id="lplistView" rowspan="2">
                	<div style="width: 200px%; height: 100%; overflow: auto;">
	                	<table class="mainlist_free">
						</table>
					</div>
                </td>    
            </tr>
        </table>
	</body>
</html>