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
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
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
	   	
	   		function close_Click(){
	   			window.close();
	   		}
	   		
	   		$(document).ready(function(){
	   			treeContent = ${deptList};
		   		setDeptList();
   			});
	   		
	   		//조직도 뿌리는 펑션
	   		function setDeptList(){
				$('#treeview').on('changed.jstree', function (e, data) {
			     	var id = data.instance.get_node(data.selected).id;
					setUserList("DEPARTMENT",id);
				  })
				.jstree({ 
					'core' : {'data' : treeContent},
					'plugins': ["wholerow"],
					 'themes' : {'responsive' : true}
				});
	   		}
	   		
	   		//사원 리스트 뿌리기
	   		function setUserList(key,value){
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezJournal/userList.do",
	   				data:{"key":key, "value":value},
	   				success: function(result){
	   					$("#orglistView").html(result);
	   				}
	   			});
	   		}
	   		
	   		//선택된 사원의 권한 부서 보여주기
	   		function setUserAuthorDept(elem){
	   			selectedUser = $(elem).attr("id");
	   			selectedUserName = $(elem).attr("name");
	   			$("*").removeClass("selectTR");
	   			$(elem).addClass("selectTR");
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezAttitude/attitudeAuthorDeptList.do",
	   				data:{"userId":$(elem).attr("id")},
	   				success: function(result) {
	   					lpDepts = [];
	   					lpDeptNames = [];
	   					$("#authorDeptList").html(result);
	   					var deptList = $("#authorDeptList tr");
	   					if (deptList.length == 1) {
	   						$(".mainlist_free").append('<tr><td align="center" style="width:250px;">해당하는 부서가 없습니다.</td></tr>');
	   						
	   						$("#authorDeptList tr").each(function(){
		   						if ($(this).attr("mine") == "Y") {
		   							userDeptId = $(this).attr("targetId");
		   						}
	   						})
	   					} else {
		   					$("#authorDeptList tr").each(function(){
		   						if ($(this).attr("mine") == "Y") {
		   							userDeptId = $(this).attr("targetId");
		   						} else {
			   						lpDepts.push($(this).attr("targetId"));
			   						lpDeptNames.push($(this).find("td").text());
		   						}
		   					})
	   					}
	   				}
	   			});
	   		}
	   		
	   		//검색
	   		function search_click(){
	   			var key = $("#search_type").val();
	   			var value = $("#keyword").val();
	   			setUserList(key,value);
	   		}
	   		
	   		//사원선택
	   		function setAuthorViewUser(){
	   			alert(lpDepts);
	   			alert(userDeptId);
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
        <h1>권한등록</h1>
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
				<td style="vertical-align:top; padding-top:4px; padding-left:3px;">
	                <table>
						<tbody>
							<tr>
								<td>
									<h2 class="receiver_tltype01" >
										<span style="min-width: 45px;" id="PermissionStr">권한부여부서 </span>
									</h2>
									<div class="receiver_borderbox">
										<div id="authorDeptList" style="width: 250px; Height: 465px; overflow-x: auto; overflow-y: auto;">
										</div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
        </table>
	</body>
</html>

