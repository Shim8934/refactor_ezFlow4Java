<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="${util.addVer('main.e15', 'msg')}" type="text/css">
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<style>
			#mCSB_1_container {
				margin-right: 0px;
			} 
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript">
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
		    };
		    
		    function goPage(idx) {
				var url = "";
				
				switch(idx)	{
					case 1:
						//양식등록
						url = "/admin/ezApprovalG/formAdmin.do";
						break;					
				    case 2:
				    	//문서함관리
	                    url = "/admin/ezApprovalG/apprGMCont.do";
	                    break;						
				    case 3:
				    	//문서이동
				        url = "/admin/ezApprovalG/apprGMoveContainer.do";
						break;
				    case 4:
				    	//문서삭제
				        url = "/admin/ezApprovalG/docDelete.do";
						break;
				    case 5:
				    	//수신처, 수신자 그룹지정
				        url = "/admin/ezApprovalG/apprGReceiveGroup.do";
						break;
				    case 6:
				    	//분류코드관리 , 분류, 단위업무관리
				        url = "/admin/ezApprovalG/apprGTaskCodeManage.do";
						break;					
					case 7:
						//부서별 단위업무 조회
					    url = "/admin/ezApprovalG/taskAdminDept.do";
						break;						
					case 8:
						//관인대장
					    url = "/admin/ezApprovalG/manageSeal.do";
						break;						
					case 9:
						//부서별관인대장
					    url = "/admin/ezApprovalG/manageDeptSeal.do";
						break;					
					case 10:
						//문서 유통 암호화 설정
						url = "/admin/ezApprovalG/manageSendInfo.do";
						break;						
					case 11:
						//결재 건수 조회
					    url = "/admin/ezApprovalG/statistics.do";
						break;						
					case 12:
						//전체 문서 조회(진행문서)
					    url = "/admin/ezApprovalG/forAprDoc.do?type=admin";
						break;						
					case 13:
						//전체 문서 조회(완료문서)
					    url = "/admin/ezApprovalG/forDoc.do?type=admin";
						break;
					case 14:
						//2018-08-07 구해안
						//부재자 설정관리
					    url = "/admin/ezApprovalG/adminBujae.do";
						break;
					case 15:
						//채번 관리
						url = "/admin/ezApprovalG/docNumZeroCnt.do";
						break;
				}
				
				window.open(url,"right");
			}
		    
		    $(document).ready(function() {
				leftResize();
		        $(".adminListBox").mCustomScrollbar({
		    		theme : "dark"
		    	});
			});
	        
	        function leftResize(){
	        	$(".adminListBox").height(window.innerHeight-58);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
	    	});
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" title="<spring:message code='main.t10'/>"><spring:message code='main.t25'/></div>
			
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
	        	<h2><span style="display:inline-block;width:100%;" onClick="goPage(1)"><spring:message code='main.t10'/></span></h2>
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(15)"><spring:message code='ezApprovalG.csj02'/></span></h2>
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(2)"><spring:message code='main.t36'/></span></h2>
				
				<c:if test="${approvalFlag == 'S' }">
					<h2><span style="display:inline-block;width:100%;" onClick="goPage(3)"><spring:message code='main.t37'/></span></h2>
					<h2><span style="display:inline-block;width:100%;" onClick="goPage(4)"><spring:message code='main.t38'/></span></h2>
				</c:if>
				
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(5)"><spring:message code='main.t39'/></span></h2>
				
				<c:choose>
					<c:when test="${approvalFlag == 'S' }">
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(6)"><spring:message code='main.t40'/></span></h2>	
					</c:when>
					<c:otherwise>
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(6)"><spring:message code='main.t46'/></span></h2>	
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(7)"><spring:message code='main.t47'/></span></h2>
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${approvalFlag == 'S' }"></c:when>
					<c:otherwise>
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(8)"><spring:message code='main.t41'/></span></h2>
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${approvalFlag == 'S' }"></c:when>
					<c:otherwise>
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(9)"><spring:message code='main.t48'/></span></h2>
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(10)"><spring:message code='main.t49'/></span></h2>
					</c:otherwise>
				</c:choose>
				<c:if test="${useAdminBujae == 'YES'}">
					<h2><span style="display:inline-block;width:100%;" onClick="goPage(14)"><spring:message code='main.t0628'/></span></h2>				
				</c:if>
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(11)"><spring:message code='main.t42'/></span></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(12)"><spring:message code='main.t50'/></span></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(13)"><spring:message code='main.t51'/></span></h2>	
			</div>
		</div>
	</body>
</html>
