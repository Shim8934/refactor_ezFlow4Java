<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<title><spring:message code='ezEmail.userDL14'/></title>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style>
			.countColor { color:#017BEC; font-weight:bold; }
			.DL_title {
				box-sizing: border-box;
				height: 31px;
				padding: 5px 10px;
			}
			.DL_title > div{ display:inline-block; }
			.mainlist tr th {text-align: center; }
			
			.DL_Table { width: 100%; text-align: center; }
	    	.DL_Table thead tr, tbody tr{ height:30px; }
	    	.DL_Table tbody tr{
	    		height:30px;
			    border-bottom: 1px solid #d2d2d2;
	    	}
	    	.DL_Table tr>*:nth-child(1) { width: 25%; }
	    	.DL_Table tr>*:nth-child(2) { text-align: left; }
	    	.DL_Table tr>*:nth-child(3) { width: 25%; }
	    	.DL_Table tr>*:nth-child(4) { width: 20%; }
	    	
	    	#DL_Head th{ border: none; }
	    	.DL_Body_div {
		    	width: 100%;
			    overflow-y: auto;
		    }
	    </style>
	</head>
	<body class="popup" style="overflow:hidden;">
		<div id="normalScreen">
  			<div id="menu"></div>
  			<div id="close">
    			<ul>
      				<li><span onClick="window.close()"></span></li>
    			</ul>
  			</div>
  			<div style="border:1px solid #eaeaea; margin-top:20px;">
  				<div class="DL_title">
  					<div class="DL_title_sub">
  						<span>공용배포그룹 이름</span>
  						<span id="countInfo">&nbsp;&nbsp;<span class="countColor">3</span><spring:message code='main.t20000' /></span>
  					</div>
  					
  					<div class="DL_title_Btn" style="float:right;">
  						<c:choose>
  							<c:when test="${join eq 'YES'}">
		  						<a class="imgbtn"><span onclick="secessionUserDL()"><spring:message code='ezEmail.userDL09' /></span></a>						
  							</c:when>
  							<c:otherwise>
  								<a class="imgbtn"><span onclick="joinUserDL()"><spring:message code='ezEmail.userDL10' /></span></a>
  							</c:otherwise>
  						</c:choose>
  					</div>
  				</div>
  				
  				<div>   
       				<table id="DL_Head" class="mainlist DL_Table" style="width: 100%; border-bottom: 1px solid #eaeaea;"> 
           				<tbody>
	           				<tr>
								<th><spring:message code='main.t76' /></th>
								<th style="text-align: left; "><spring:message code='main.t78' /></th>
								<th><spring:message code='main.t75' /></th>
								<th><spring:message code='ezEmail.userDL15' /></th>
								<th width="4" id="forScroll"></th>
	           				</tr>
						</tbody>
					</table>
					<div class="DL_Body_div" style="height:430px; overflow:auto; ">
						<table id="DL_Body" class="DL_Table"></table>
					</div>
       			</div>
  			</div>
  			
		</div>
	</body>
	<script type="text/javascript">
		var showItem = ["name", "email", "deptName", "joinDate"];
		
		window.onload = window_onload;
		
		function window_onload() {
			makeDlMemList();
		}
		
		function getDLMemList() {
			$.ajax({
				type:"post",
				url:"",
				dataType:"json",
				data:{},
				success:function(data) {
					makeDlMemList(data);
					isScroll();
				}
			})
		}
		
		function makeDlMemList(data) {
			var $DL_Tbody = $("<tbody></tbody>");
			var $DLTable = $("#DL_Body");
			if (data.length > 1) {
				for (var i in data) {
					var $TR_Temp = $("<tr></tr>");
					
					$.each(data[i], function(key, value){
						$TR_Temp.attr("data-" + key, value);
						
						if (showItem.indexOf(key) > -1) {
							var $TD_Temp = $("<td>" + value + "</td>");
							$TR_Temp.append($TD_Temp);
						}
					});
					
					$DL_Tbody.append($TR_Temp);
				}
			} else {
				var $TR_Temp = $("<tr id='noData'><td><spring:message code='ezEmail.userDL06' /></td></tr>");
				$DL_Tbody.append($TR_Temp);
			}				
			
			$DLTable.html($DL_Tbody);
			isScroll();
		}
	
		function isScroll(){
			var forScroll = $("#DL_Head #forScroll"); 
		
			if ($(".DL_Body_div").height() < $(".DL_Body_div table").height()) {
				forScroll.css("display", "");
			} else {
				forScroll.css("display", "none");
			}
		}
		
		// 탈퇴
		function secessionUserDL() {
			var ret = confirm("<spring:message code='ezEmail.userDL13' />");
        	if (ret) {
				$.ajax({
					type:"post",
					url:"",
					data:{},
					success:function(e) {
						alert("<spring:message code='ezEmail.userDL08' />");
						getDLList();
					}, error:function(er) {
						alert("<spring:message code='ezEmail.t53' />");
					}
				});
        	}
		}
		
		// 가입
		function joinUserDL() {
			$.ajax({
				type:"post",
				url:"",
				data:{},
				success:function(e) {
					alert("<spring:message code='ezEmail.userDL19' />");
					joinCheck();
				}, error:function(er) {
					alert("error");
				}
			});
       	}
		
		function joinCheck() {
			
		}
		
	</script>
</html>