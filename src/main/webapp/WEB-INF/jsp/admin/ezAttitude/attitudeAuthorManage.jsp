<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
<%-- 		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" /> --%>
<!-- 		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />		 -->
<%-- 		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>	     --%>
	    <link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>	
	    <script type="text/javascript">
	    	var adminCompany = "${adminCompany}";
	    	var selectUserId = "";
// 			document.onselectstart = function () {
// 	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
// 	            return false;
// 	        else
// 	            return true;
// 			};
			
	        $(document).ready(function() {
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezAttitude.t32' />");
		        } else {
		    		if (adminCompany != null) {
		    			$('#ListCompany').val(adminCompany);
		    		} else {
			            document.getElementById("ListCompany").selectedIndex = 0;
		    		}
		            company_change();
		        }
	        });
	        
	        function company_change() {
	            $.ajax({
	            	type : "GET",
	            	url : "/admin/ezAttitude/attitudeAuthList.do",
	            	dataType : "json",
	            	data : {companyId : encodeURI($("#ListCompany").val())},
	            	success : function(result) {
	            		attitudeAuthListSet(result);
	            	},
	            	error : function() {
	            		alert("리스트를 가져오는 도중 에러 발생");
	            	}
	            });
	        }
	        
	        //권한자 리스트 셋팅
	        function attitudeAuthListSet(result) {
                var html = "";
                if (result.length != null && result.lenth != 0) {
	                for (var i = 0; i < result.length; i++) {
	                    html += "<tr id='" + result[i].userId + "' onclick='listClick(this);' style='cursor: pointer;'>";
	                    html += "<td style='width:28%;color:gray;'>" + result[i].userName + "</td>";
	                    html += "<td style='width:22%;color:gray;'>" + result[i].userTitle + "</td>";
	                    html += "<td style='width:25%;color:gray;'>" + result[i].userDeptName + "</td>";
	                    html += "<td style='width:25%;color:gray;'>" + result[i].authDeptName + "</td>";
	                    html += "</tr>";
	                }
                } else {
                	html = "<tr><td colspan='4' style='text-align:center'>등록된 정보가 없습니다.</td></tr>";
                }
                
                $("#contentlist table.mainlist").html(html);
	        }
	        
	        //리스트 tr클릭시
	        function listClick(elem) {
	        	selectUserId = $(elem).attr('id');
	        }
	        
	        //권한 삭제
	        function author_delete() {
	        	if (confirm("정말로 삭제하시겠습니까?")) {
					$.ajax({
						type : "POST",
						url : "/admin/ezAttitude/deleteAttitudeAuth.do",
						data : {
							selectUserId : selectUserId,
							companyId : encodeURI($("#ListCompany").val())
						},
						success : function() {
							alert("삭제되었습니다.");
							company_change();
						},
						error : function() {
							alert("삭제하는 도중 오류 발생");
						}
					})
	        	}
	        }
	        
	        //권한추가
	        function author_add() {
	        	var url = "/admin/ezAttitude/saveAttitudeAuth.do";
				var companyId = $("#ListCompany").val();
				url+="?companyId="+companyId;
				window.open(url, "saveAttitudeAuth", "width=500, height=180");
	        }
	        
		</script>
	</head>
	<body class="mainbody">
	    <h1>근태권한관리</h1>
	    <div id="mainmenu">
			<ul>
	        	<li style="background: none;">
				<span style="border: none;"><b><spring:message code='ezAttitude.t15' /></b></span>
				</li>
				<li>
				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
					<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
					</c:forEach>
	      		</select>
	      		</li>
	      	</ul>
		    <ul>
		        <li><span onClick="author_add()">권한추가</span></li>
		        <li><span onClick="author_delete()">권한삭제</span></li>
		    </ul>
		</div>
	    <br />
	    <table style="width: 650px; height: 385px;" >
            <tr>
                <td>
                    <div style="border: 1px solid #dbdbda;border-top:0px; width: 650px; height: 396px;">
                        <table class="mainlist" style="width: 100%;">
                            <tr>
                                <th style="width: 28%;"><span>사용자</span></th>
                                <th style="width: 22%;"><span>직위</span></th>
                                <th style="width: 25%;"><span>부서</span></th>
                                <th style="width: 25%;"><span>관리부서</span></th>
                            </tr>
                        </table>
                        <div id="contentlist" name="contentlist" style="height: 360px; overflow-y: auto;">
                            <table class="mainlist" style="width: 100%;">
                                <tr>
                                    <td style="text-align: center;">
                                        <img src="/images/email/progress_img.gif" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>

