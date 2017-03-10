<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='main.e15'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
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
				        url = "/admin/ezApprovalG/apprGMCont.do";
						break;
				    case 4:
				    	//문서삭제
				        url = "/admin/ezApprovalG/apprGMCont.do";
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
					    url = "/admin/ezApprovalG/forAprDoc.do";
						break;						
					case 13:
						//전체 문서 조회(완료문서)
					    url = "/admin/ezApprovalG/forDoc.do";
						break;
				}
				
				window.open(url,"right");
			}
		</script>
	</head>
	<body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
		<div id="left" style="overflow-x:hidden">
			<div class="left_admin" title="<spring:message code='main.t10'/>"><spring:message code='main.t10'/></div>
			
	        	<h2><span style="display:inline-block;width:100%;" onClick="goPage(1)"><spring:message code='main.t10'/></span><ul></ul></h2>
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(2)"><spring:message code='main.t36'/></span><ul></ul></h2>	
				
				<c:if test="${approvalFlag == 'S' }">
					<h2><span style="display:inline-block;width:100%;" onClick="goPage(3)"><spring:message code='main.t37'/></span><ul></ul></h2>
					<h2><span style="display:inline-block;width:100%;" onClick="goPage(4)"><spring:message code='main.t38'/></span><ul></ul></h2>
				</c:if>
				
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(5)"><spring:message code='main.t39'/></span><ul></ul></h2>	
				
				<c:choose>
					<c:when test="${approvalFlag == 'S' }">
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(6)"><spring:message code='main.t40'/></span><ul></ul></h2>	
					</c:when>
					<c:otherwise>
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(6)"><spring:message code='main.t46'/></span><ul></ul></h2>	
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(7)"><spring:message code='main.t47'/></span><ul></ul></h2>
					</c:otherwise>
				</c:choose>
				
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(8)"><spring:message code='main.t41'/></span><ul></ul></h2>
				
				<c:choose>
					<c:when test="${approvalFlag == 'S' }">
					</c:when>
					<c:otherwise>
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(9)"><spring:message code='main.t48'/></span><ul></ul></h2>
						<h2><span style="display:inline-block;width:100%;" onClick="goPage(10)"><spring:message code='main.t49'/></span><ul></ul></h2>
					</c:otherwise>
				</c:choose>
				
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(11)"><spring:message code='main.t42'/></span><ul></ul></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(12)"><spring:message code='main.t50'/></span><ul></ul></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(13)"><spring:message code='main.t51'/></span><ul></ul></h2>	
			</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>
