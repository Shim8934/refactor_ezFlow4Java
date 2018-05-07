<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
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
	   		var lpDepts=[];
	   		var lpDeptNames = [];
	   		//오른쪽에서 없앨 부서
	   		var targetDept;
	   		//현재 레이어팝업에 선택된 유저
	   		var updateUserId;
	   		//선택된 유저의부서
	   		var userDeptId;
	   		//회사 id
	   		var companyId = "${companyId}";
	   	
	   		function close_Click(){
	   			window.close();
	   		}
	   		
	   		$(document).ready(function() {
	   			treeContent = ${deptList};
		   		setDeptList();
   			});
	   		
	   		//조직도 뿌리는 펑션
	   		function setDeptList() {
				$('#treeview').on('changed.jstree', function (e, data) {
			     	var id = data.instance.get_node(data.selected).id;
			     	var deptName = $("#"+id+" a:first").text();
					setUserList("DEPARTMENT", id,deptName);
				}).jstree({ 
					'core'   : {'data' : treeContent, 'multiple' : false},
					'plugins': ["wholerow"],
					'themes' : {'responsive' : true}
				}).on('ready.jstree', function(e, data) {
					var offset = $(".jstree-clicked").offset();
		   	        $('#treeview').animate({scrollTop : offset.top}, 0);
			    });
	   		}
	   		
	   		//사원 리스트 뿌리기
	   		function setUserList(key,value,deptName) {
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezJournal/userList.do",
	   				data:{"key":key, "value":value,"deptName":deptName},
	   				success: function(result){
	   					var picList = $(result).find(".organwrap");
	   					if (picList.length==0 && key!="DEPARTMENT") {
	   						alert("<spring:message code='ezCommunity.t1379'/>");
	   					} else {
		   					$("#orglistView").html(result);
	   					}
	   				}
	   			});
	   		}
	   		
	   		//선택된 사원의 권한 부서 보여주기
	   		function setUserAuthorDept(elem) {
	   			selectedUser = $(elem).attr("id");
	   			selectedUserName = $(elem).attr("name");
	   			$("*").removeClass("selectTR");
	   			$(elem).addClass("selectTR");
	   		
	   			$.ajax({
	   				type:"post",
	   				dataType:"json",
	   				url:"/admin/ezAttitude/attitudeAuthorDeptList.do",
	   				data:{"userId":$(elem).attr("id"), companyId : companyId},
	   				success: function(result) {
	   					lpDepts = [];
	   					lpDeptNames = [];
	   					$.each(result, function(idx, deptInfo){
	   						if (deptInfo.mine == "yes") {
	   							userDeptId = deptInfo.deptId;
	   						} else {
		   						lpDepts.push(deptInfo.deptId);
		   						lpDeptNames.push(deptInfo.deptName);
	   						}
	   					})
	   				}
	   			});
	   		
	   		}
	   		
	   		//검색
	   		function search_click() {
	   			var key = $("#search_type").val();
	   			var value = $("#keyword").val().trim();
	   			if(value) {
		   			setUserList(key, value);
	   			} else {
	   				alert("검색어를 입력해주세요")
	   			}
	   		}
	   		
	   		//사원선택
	   		function setAuthorViewUser() {
	   			var userId = selectedUser;
				if (userId) {
					opener.setSelectedUser(userId,selectedUserName);
		   			opener.setDeptName(JSON.stringify(lpDepts), JSON.stringify(lpDeptNames));
		   			opener.userDeptId = userDeptId;
					window.close();
				} else {
					alert("사원을 선택해 주세요");
				}
	   		}
	   		
		</script>
		<style>
			tr.hover:hover{background:#eee; color:#fff;}
			
			.selectTR{
				background-color: rgb(233, 241, 255);
			}
		</style>
	</head>
	<body class="popup"> 
        <h1>권한자 지정</h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="setAuthorViewUser()">확인</span></li>
	            <li><span onclick="close_Click()">닫기</span></li>
	        </ul>
	    </div>
		<table id="TreeViewTD">
		 	<tr>
	            <td>
	                <div class="portlet_tabpart03" style="background-color: #e9e9e9; margin-top: 4px;">
	                    <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2;">
	                        <table style="margin-top: 3px; width: 100%;">
	                            <tr>
	                                <td>
	                                </td>
	                                <td>
	                                    <div style="float:right">
	                                        <select id="search_type">
	                                            <option selected value="displayname"><spring:message code='ezOrgan.t67'/></option>
					                            <option value="cn"><spring:message code='ezOrgan.t94'/></option>
					                            <option value="description"><spring:message code='ezOrgan.t68'/></option>
					                            <option value="title"><spring:message code='ezOrgan.t69'/></option>
					                            <option value="telephonenumber"><spring:message code='ezOrgan.t95'/></option>
					                            <option value="mobile"><spring:message code='ezOrgan.t96'/></option>
					                            <option value="HomePhone"><spring:message code='ezOrgan.t97'/></option>
					                            <option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98'/></option>
					                            <option value="mail"><spring:message code='ezOrgan.t99'/></option>
					                            <option value="streetAddress"><spring:message code='ezOrgan.t100'/></option>
	                                        </select>
	                                        <input type="text" id="keyword" value="" style="width: 130px; margin: 0px;" />
	                                        <a class="imgbtn"><span onclick="search_click()"><spring:message code='ezOrgan.t101'/></span></a>
	                                    </div>
	                                </td>    
	                                <td></td>
	                            </tr>
	                        </table>
	                    </div>
	                </div>
					<table>
			            <tr>
			                <td class="box">
			                    <div style="width: 250px; height: 465px; overflow-x: auto; overflow-y: auto;" id="treeview"></div>
			                </td>
			                <td></td>
			                <td class="listview" style="width: 426px" id="orglistView">
			                </td>    
			            </tr>
			        </table>
				</td>
			</tr>
        </table>
	</body>
</html>

