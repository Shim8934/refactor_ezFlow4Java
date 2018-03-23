<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title>title</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
<!-- 	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css"> -->
	    <style>
	    	.box {
	    		border-right:0px;
	    	}
	    </style>
<!-- 	    <script type="text/javascript" src="/js/mouseeffect.js"></script> -->
<!-- 	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script> -->
<!-- 	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script> -->
<!-- 	    <script type="text/javascript" src="/js/ezEmail/Controls/ListView_list.js"></script>	     -->
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/jstree/jstree.js"></script>
		<script type="text/javascript" language="javascript">
		    var ReturnFunction;
		    var treeContent = ${deptList};
			
		    $(document).ready(function(){
		    	setDeptList();
// 		    	try {
// 	                ReturnFunction = opener.permissions_check_dialogArguments[1];
// 	            } catch (e) {}	        

// 		        try {
// 		            var ua = navigator.userAgent;
// 		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
// 		                var input = document.getElementsByTagName("input");
		                
// 		                for (var i = 0; i < input.length; i++) {
// 		                    if (input[i].getAttribute("type") == "text") {
// 		                        KeEventControl(input[i]);
// 		                    }
// 		                }
// 		            }
// 		        } catch (e) {}
		    })
		    //부서 리스트
	   		function setDeptList(){
				$('#treeView').on('changed.jstree', function (e, data) {
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
	   				url:"/admin/ezJournal/authorDeptList.do",
	   				data:{"userId":$(elem).attr("id")},
	   				success: function(result){
	   					$("#authorDeptList").html(result);
	   				}
	   			});
	   		}
		    
	        function close_Click() {
	            if (ReturnFunction!=null) {
	                ReturnFunction();
	            }
	            window.close();
	        }
	    </script>
	</head>
	<body class="popup">
	    <div id="menu">
	        <ul>
	            <li><span onclick="OK_Click()">저장</span></li>
	        </ul>
	    </div>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()">닫기</span></li>
	        </ul>
	    </div>
	    <table id="TreeViewTD">
	        <tr>
	        	<td style="width: 650px;">
	                <div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
	                    <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2;">
	                        <table style="margin-top: 3px; width: 100%;">
	                            <tr>
	                                <td>
	                                	<div style="padding-left:60px">
	                                    	<input type="text" name="Input" id="deptkeyword" style="WIDTH: 110px; margin: 0px;" onkeypress="deptsearch_press()" />
	                                        <a class="imgbtn"><span onclick="deptsearch_click()">부서검색</span></a>
	                                	</div>
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
	                                        <input type="text" id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;" />
	                                        <a class="imgbtn"><span onclick="search_click()">검색</span></a>
	                                    </div>
	                                </td>    
	                                <td></td>
	                            </tr>
	                        </table>
	                    </div>
	                </div>
	                <table style="margin-top: 3px;">
	                    <tr>
	                        <td class="box">
	                            <div style="width: 250px; height: 465px; overflow-x: auto; overflow-y: auto;" id="treeView"></div>
	                        </td>
	                        <td></td>
	                        <td class="listview" style="width: 426px" id="orglistView">
	                            <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
	                                <tr>
	                                    <th style="white-space:normal">
	                                        <span id="SelectDeptNM" style="font-weight: bold; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
	                                        <span style="float:right;">
	                                            <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                            <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                        </span>
	                                    </th>
	                                </tr>
	                            </table>
	                            <div style="vertical-align: top; height: 440px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
	                                    <tr>
	                                    <!-- 이름 직위 전화번호 -->
	                                        <td style="width: 20%; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t67'/></td>
	                                        <td style="width: 20%; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t69'/></td>
	                                        <td class="td_gray" style="width: 60%;font-weight: bold;"><spring:message code='ezOrgan.t97'/></td>
	                                    </tr>
	                                </table>
	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
	                                    <tr>
	                                    <!-- 이름 부서 직위 전화번호 -->
<%-- 	                                        <td style="width: 130px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t68'/></td> --%>
<%-- 	                                        <td style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t67'/></td> --%>
<%-- 	                                        <td style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t69'/></td> --%>
<%-- 	                                        <td class="td_gray" style="font-weight: bold;"><spring:message code='ezOrgan.t97'/></td> --%>
	                                    </tr>
	                                </table>
	                            </div>
	                            <div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
	                        </td>    
	                    </tr>
	                </table>
	            </td>  
	            <!-- 위에까지 조직도 -->
	            <td style=" width:20px; text-align:center; padding:1px;">
	            	<img src="../../../images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver()" />
	                            <img src="../../../images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver()" />
	            </td>
	            <!-- 위에까지 화살표 -->     
	            <td style="width:450px;">
	                <div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
	                    <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2; text-align:center;">
	                        <table style="margin-top: 3px; width: 100%;">
	                        	<tr>
	                        		<h2>사용자별 설정시간</h2>
	                        	</tr>
	                        	<tr>
	                        		근무시간
	                        		<input type="text" style="width:50px;"/>시
	                        		<input type="text" style="width:50px;"/>분
	                        		~
	                        		<input type="text" style="width:50px;"/>시
	                        		<input type="text" style="width:50px;"/>분
	                        	</tr>
	                        </table>
	                    </div>
	                </div>
	                <table style="margin-top: 3px;">
	                    <tr>
	                        <td></td>
	                        <td class="listview" style="width: 100%" id="orglistView">
	                            <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
	                                <tr>
	                                    <th style="white-space:normal; padding-left:60px;">
	                                    	이름
	                                    </th>
	                                    <th style="white-space:normal">
	                                    	근무시간
	                                    </th>
	                                </tr>
	                            </table>
	                            <div style="vertical-align: top; overflow: auto; width: 340px;  height: 440px;" id="txtlist_Layer">
	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
	                                    <tr>
	                                     <!-- 이름 직위 전화번호 -->
	                                    
<%-- 	                                        <td style="width: 170px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t67'/></td> --%>
<%-- 	                                        <td style="width: 150px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t69'/></td> --%>
<%-- 	                                        <td class="td_gray" style="font-weight: bold;"><spring:message code='ezOrgan.t97'/></td> --%>
	                                    </tr>
	                                </table>
	                            </div>
	                        </td>    
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	</body>	
</html>