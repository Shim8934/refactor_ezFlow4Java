<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t88'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jstree/jstree.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	   	<script type="text/javascript">
	   		//트리조직도 JSON
	   		var treeContent;
	   	
	   		function close_Click(){
	   			window.close();
	   		}
	   		//조직도 뿌리는 펑션
	   		function setDeptList(){
				$('#treeview').on('changed.jstree', function (e, data) {
			     	var id = data.instance.get_node(data.selected).id;
					setUserList("DEPARTMENT", id);
				  })
				.jstree({ 
					'core' 	 : {'data' : treeContent},
					'plugins': ["wholerow"],
					'themes' : {'responsive' : true}
				});
	   		}
	   		
	   		//사원 리스트 뿌리기
	   		function setUserList(key, value){
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezJournal/userList.do",
	   				data:{"key" : key, "value" : value},
	   				success: function(result){
	   					$("#orglistView").html(result);
	   				}
	   			});
	   		}
	   		
	   		//검색
	   		function search_click(){
	   			var key = $("#search_type").val();
	   			var value = $("#keyword").val();
	   			setUserList(key, value);
	   		}
	   		
	   		//열람궎란정보 저장
	   		function insertAuthDept(){
	   			var jsonString = JSON.stringify({"userId":updateUserId,"depts":lpDepts});
				$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezJournal/saveAuthor.do",
	   				contentType:"application/json;",
	   				data:jsonString,
	   				success: function(result){
	   					alert(result);
   						$('.journal-layer').fadeOut();
   						opener.location.reload();
   						location.reload(true);
	   				}
	   			});
	   		}
	   		
	   		//레이어팝업의 오른쪽에 선택된 부서를 삭제
	   		function delTargetDept(elem){
	   			var targetDeptId = $(elem).attr("targetId");
   				lpDepts.splice(lpDepts.indexOf(targetDeptId),1);
   				$(elem).remove();
	   		}
	   		
	   		$(document).ready(function(){
	   			treeContent = ${deptList};
	   			$("#1tab1").click();
	            ChangeTab(document.getElementById("1tab1"));
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
   			});
	   		
	   		var Tab1_SelectID = "1tab1";
		    function ChangeTab(obj) {
		    	var pSelectTab = GetAttribute(obj, "tdname");

		        switch (pSelectTab) {
		            case "journalOrgan":
		                if (document.getElementById("journalOrgan_content").style.display == "none") {
		                    document.getElementById("journalOrgan_content").style.display = "";
		                    document.getElementById("journalFavorite_content").style.display = "none";
		                    $("#List_TBODY tr").css("backgroundColor", "#ffffff"); // 탭 바꾸면 즐겨찾기에 선택되어있던 것 해제
		                    _RowObjectID = null; // 탭 바꾸면 기존에 가지고 있던 값 초기화
		                }
		                break;
		            case "journalFavorite":
		                if (document.getElementById("journalFavorite_content").style.display == "none") {
		                    document.getElementById("journalOrgan_content").style.display = "none";
		                    document.getElementById("journalFavorite_content").style.display = "";
		                }
		                break;
		    	}
		    }
	   		
	   		function Tab1_MouseClick(obj) {
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                    document.getElementById(Tab1_SelectID).className = "";

	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
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
	<body class="popup" style="overflow: hidden;"> 
        <h1 style="height: 20px;"><spring:message code='ezJournal.t88'/></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()"><spring:message code='ezOrgan.t143'/></span></li>
	        </ul>
	    </div>
	    <table style="width:100%">
			<tr>
				<td>
					<table id="TreeViewTD">
					 	<tr>
			                <div class="portlet_tabpart01">
			                	<div class="portlet_tabpart01_top" id="tab1">
					            	<p><span id="1tab1" tdname="journalOrgan" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)"><spring:message code='ezJournal.t89' /></span></p>
									<p><span id="1tab2" tdname="journalFavorite" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)"><spring:message code='ezJournal.t90' /></span></p>
					        	</div>
					        </div>
				        	<td id="journalOrgan_content" style="display: none;">
				        		<div class="portlet_tabpart03" style="background-color: #e9e9e9; margin-top: 4px; padding:0px;">
				                    <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2;">
				                        <table style="margin-top: 3px; width: 100%;">
				                            <tr>
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
								<table style="margin-top: 3px;">
						            <tr>
						                <td class="box" style="border-right: 0px;">
						                    <div style="width: 250px; height: 500px; overflow-x: auto; overflow-y: auto;" id="treeview"></div>
						                </td>
						                <td></td>
						                <td class="listview" style="width: 426px" id="orglistView">
						                </td>    
						            </tr>
						        </table>
		                  	</td>   
		                  	<td id="journalFavorite_content" style="display:none; width:750px;">
	                        	<table style="width:100%">
	                                <tr>
	                                    <td style="background-color: #f3f3f3; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
	                                        <h2 class="h2_dot" style="padding-top: 2px;"><spring:message code='ezJournal.t95'/></h2>
	                                        <div class="border_gray">
	                                            <div id="circularDept" style="Width: 100%; Height: 182px; OVERFLOW: AUTO; padding-top: 0px;">
	                                            	<table class="mainlist" style="width: 100%;">
								                        <thead id="List_THEAD">
									                        <tr>
									                        	<th style="width: 5%;"><span><spring:message code='ezCircular.t31' /></span></th>
									                            <th style="width: 35%; "><span><spring:message code='ezCircular.t32' /></span></th>
									                            <th style="width: 27%; "><span><spring:message code='ezCircular.t33' /></span></th>
									                            <th style="width: 19%; "><span><spring:message code='ezCircular.t34' /></span></th>
									                            <th style="width: 13%; "></th>
									                        </tr>
								                        </thead>
								                        <tbody id="List_TBODY">					                        
								                        </tbody>
								                    </table>
	                                            </div>
	                                        </div>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td style="vertical-align: top;">
	                                        <div class="border_gray">
	                                            <div id="circularTemp" style="Width: 100%; Height: 329px; OVERFLOW: AUTO; padding-top: 0px;">
	                                            	<table id="List" class="mainlist" style="width:100%">
														<thead id="List_THEAD2">
															<tr>
																<th id="TH_0" style="width:5%"><spring:message code='ezCircular.t31' /></th>
																<th id="TH_1" style="width:15%"><spring:message code='ezCircular.t76' /></th>
																<th id="TH_2" style="width:17%"><spring:message code='ezCircular.t78' /></th>
																<th id="TH_3" style="width:12%"><spring:message code='ezCircular.t79' /></th>
																<th id="TH_4" style="width:13%"><spring:message code='ezCircular.t80' /></th>
																<th id="TH_5" style="width:38%"><spring:message code='ezCircular.t81' /></th>
															</tr>
														</thead>
														<tbody id="List_TBODY2">
														</tbody>
													</table>
	                                            </div>
                                            </div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                        <td style="width: 30px; text-align: center;">                            
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver(ListViewMsgTo)"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgTo)">
	                        </td>
	                        <td style="vertical-align: top;">
	                            <h2 class="receiver_tltype01" style="margin-top:4px;">
									<span style="min-width: 45px;" id="PermissionStr"><spring:message code='ezJournal.t80'/> </span>
								</h2>
								<div class="receiver_borderbox">
									<div id="authorDeptList" style="width: 250px; Height: 500px; overflow-x: auto; overflow-y: auto;">
									</div>
								</div>
	                        </td>
	                    </tr>
	                </table>
	      		</td> 
			</tr>
        </table>
	</body>
</html>

