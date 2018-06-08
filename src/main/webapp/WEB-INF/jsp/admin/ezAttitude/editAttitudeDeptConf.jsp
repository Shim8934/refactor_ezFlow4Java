<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>부서근무시간수정</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code ='ezAttitude.i1' />" type="text/css"/>
		<link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
		<link rel="stylesheet" href="/css/ezJournal/journal_css.css" type="text/css" />
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezJournal/journal_script.js"></script>
		<script type="text/javascript" src="/js/jstree/jstree.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
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
	   		var lpAuthTypes = [];
	   		//오른쪽에서 없앨 부서
	   		var targetDept;
	   		//현재 레이어팝업에 선택된 유저
	   		var updateUserId;
	   		//선택된 유저의부서
	   		var userDeptId;
	   		//회사 id
	   		var companyId = "${companyId}";
	   		//회사 출/퇴근 시간
			var companyStartTime = "${companyStartTime}";
			var companyEndTime = "${companyEndTime}";
	   	
	   		function close_Click(){
	   			window.close();
	   		}
	   		
	   		$(document).ready(function() {
	   			//조직도 리스트
	   			treeContent = ${deptList};
		   		setDeptList();
		   		
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
					var offset = $(".jstree-wholerow-clicked").offset();
		   	    	var jstree = document.getElementById("treeview");
		   	        $('#treeview').animate({scrollTop : offset.top - jstree.offsetHeight / 2}, 40);
			    });
	   		}
	   		
	   		function goScroll(){
				var offset = $("#opensol").offset();
	   	        $('html, body').animate({scrollTop : offset.top}, 400);
	   		}
	   		
	   		//사원 리스트 뿌리기
	   		function setUserList(key,value,deptName) {
	   			var listType = getOrganListType();
	   			function getOrganListType() {
		        	var organListType = "TXT";
		        	$.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		url : "/ezOrgan/getListType.do",
		        		async : false,
		        		success : function(result) {
		        			organListType = result;
		        		}
		        	})
		        	return organListType;
		        }
	   			
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezAttitude/userList.do",
	   				data:{"key":key, "value":value,"deptName":deptName,"companyId":companyId, "listType" : listType},
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
	   		
	   		//검색
	   		function search_click() {
	   			var key = $("#search_type").val();
	   			var value = $("#keyword").val().trim();
	   			if(value) {
		   			setUserList(key, value);
	   			} else {
	   				alert("<spring:message code='ezAttitude.t202' />");
	   			}
	   		}
	   		
		</script>
		<style>
/* 			tr.hover:hover{background:#eee; color:#fff;} */
			
/* 			.selectTR{ */
/* 				background-color: rgb(233, 241, 255); */
/* 			} */
		</style>
	</head>
	<body class="popup"> 
        <h1>부서근무시간수정</h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()"><spring:message code='ezAttitude.t157' /></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		<table id="TreeViewTD">
		 	<tr>
	            <td>
	                 <div class="portlet_tabpart03" style="background-color: #f8f8fa; margin: 0px; padding: 0px; border: 1px solid #eaeaea;">
	                    <div class="portlet_tabpart03_top" id="tab1">
	                        <table style="margin-top: 3px; width: 100%;">
	                            <tr>
	                                <td>
	                                </td>
	                                <td>
	                                    <div style="float:right; margin-right:5px;">
	                                        <select id="search_type" style="height:22px;">
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
	                            </tr>
	                        </table>
	                    </div>
	                </div>
					<table style="margin-top: 4px;">
			            <tr>
			                <td class="box" style="border-right: 0px; height: 465px;">
			                    <div style="width: 250px; height: 470px; overflow-x: auto; overflow-y: auto;" id="treeview"></div>
			                </td>
			                <td></td>
			                <td class="listview" style="width: 426px" id="orglistView">
			                </td>    
			            </tr>
			        </table>
			        <table style="border: 0; border-collapse: collapse; border-spacing: 0; padding: 0px; width: 650px;">
				        <tbody>
				        	<tr>
				        		<input type="checkbox" id="gubun" name="gubun"/><spring:message code='ezAttitude.t127' />
				        	</tr>
				        	<tr>
				            	<td style="height: 50px; text-align: left; padding-left: 10px;">
						        	<div style="display: inline-block; vertical-align: middle;">
					                	근무시간&nbsp;
						        		<input id="workStartTime" type="text" style="width:50px; text-align:center;"/>&nbsp; ~ &nbsp;<input id="workEndTime" type="text" style="width:50px; text-align:center;"/>
						        	</div>
									&nbsp;
									<div style="display: inline-block; vertical-align: middle;" align="right">
					            		<a class="imgbtn"><span onclick="">저장</span></a>
					            		<a class="imgbtn"><span onclick="">취소</span></a>
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

