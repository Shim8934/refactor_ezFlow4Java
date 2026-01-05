<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
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
                    case 16:
                        //원문공개문서함
                        url = "/admin/ezApprovalG/openGovForDoc.do?type=admin";
                        break;
                    case 17:
                    	// 기록물철 인계 2019-06-18 임민석
                    	url = "/admin/ezApprovalG/cabTransfer.do";
                    	break;
                    case 20:
    				    url = "/admin/ezApprovalG/apprGeneralAuditingStatistics.do";
    					break;
					case "enforce":
						//시행문변환 - 관인등록
						url = "/admin/ezApprovalG/enforceSihangSeal.do";
						break;
					/* 2020-05-14 홍승비 - 전자결재 첨부파일 개수제한 설정메뉴 */
					case "attachLimit":
						url = "/admin/ezApprovalG/manageAttachLimit.do";
						break;
					case "share":
						//문서함공유
						url = "/admin/ezApprovalG/docDirShareManage.do";
						break;
					case "sendout":
						//문서유통 발송현황
						url = "/admin/ezApprovalG/sendOut.do";
						break;	
					case "auditApprLineManage":
						//감사결재선관리
						url = "/admin/ezApprovalG/auditApprLineManage.do";
						break;
					/* 2022-12-09 홍승비 - 전자결재G > 생산연도 입력받는 기록물철 자동생성 메뉴 추가 */
					case "autoRegCabinet":
						url = "/admin/ezApprovalG/registerCabinetSemiAutoManage.do";
						break;
					/* 2025-02-28 이가은 - 전자결재 > 결재연동 테스트 메뉴 추가 */
					case "approvalConn":
					    url = "/admin/ezApprovalG/connTestManage.do";
					    break;
				}
				
                parent.document.querySelector("iframe[name=right]").src = url;
				
				$("#left .adminListBox h2 span").click(function(){
					$("#left .adminListBox h2").removeClass("on");
					$(this).parent().addClass("on");
				})
				
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
            
            function btnChangeSDept_onclick() {
            	SelectDept("OPEN", btnChangeSDept_onclick_Complete);
            }
            
            var selectdept_cross_dialogArguments = new Array();
            function SelectDept(opentype, CompleteFunction) {
            	var rtn;
            	var para = new Array();
            	var url = "/ezApprovalG/selectDept.do";
            
            	selectdept_cross_dialogArguments[0] = para;
            
            	if (opentype == undefined && CompleteFunction == undefined) {
            		selectdept_cross_dialogArguments[1] = SelectDept_Complete;
            		DivPopUpShow(350, 360, url);
            	} else if (opentype == undefined && CompleteFunction != undefined) {
            		selectdept_cross_dialogArguments[1] = CompleteFunction;
            		DivPopUpShow(350, 360, url);
            	} else if (opentype != undefined && CompleteFunction == undefined) {
            		selectdept_cross_dialogArguments[1] = SelectDept_Complete;
            		var OpenWin = window.open(url, "SelectDept_Cross", GetOpenWindowfeature(350, 360));
            		try { OpenWin.focus(); } catch (e) { }
            	} else {
            		selectdept_cross_dialogArguments[1] = CompleteFunction;
            		var OpenWin = window.open(url, "SelectDept_Cross", GetOpenWindowfeature(350, 360));
            		try { OpenWin.focus(); } catch (e) { }
            	}
            selectdept_cross_dialogArguments[2] = true;
            }
            
            function btnChangeSDept_onclick_Complete(rtn) {
                console.log(rtn);
                console.log(rtn[1]);
                
                url = "/admin/ezApprovalG/apprGDocListAdminIndex.do?listType=1&selectDeptID=" + rtn[1];                
                var OpenWin = window.open(url, "Cabinet");
                
                try { OpenWin.focus(); } catch (e) { }
            }
            
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" title="<spring:message code='main.t10'/>"><spring:message code='main.t25'/></div>
			
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
	        	<h2 class="on"><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(1)"><spring:message code='main.t10'/></span></h2>
				<spring:message code='ezApprovalG.csj02' var="csj02"/>
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(15)" title="${lang eq '1' ? '' : csj02}"><spring:message code='ezApprovalG.csj02'/></span></h2>
				<spring:message code='main.t36' var="t36"/>
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(2)" title="${lang eq '1' ? '' : t36}"><spring:message code='main.t36'/></span></h2>
				
				<c:if test="${approvalFlag == 'S' }">
					<spring:message code='main.t37' var="t37"/>
					<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(3)" title="${lang eq '1' ? '' : t37}"><spring:message code='main.t37'/></span></h2>
					<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(4)"><spring:message code='main.t38'/></span></h2>
					<c:if test="${useEnforceSihang == 'YES'}"><!-- 시행문변환 관인등록 옵션 -->
						<spring:message code='main.t41' var="t41"/>
						<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage('enforce')" title="${lang eq '1' ? '' : t41}"><spring:message code='main.t41'/></span></h2>
					</c:if>
				</c:if>
				
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(5)"><spring:message code='main.t39'/></span></h2>
				
				<c:choose>
					<c:when test="${approvalFlag == 'S' }">
						<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(6)"><spring:message code='main.t40'/></span></h2>	
					</c:when>
					<c:otherwise>
						<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(6)"><spring:message code='main.t46'/></span></h2>	
						<spring:message code='main.t47' var="t47"/>
						<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(7)" title="${lang eq '1' ? '' : t47}"><spring:message code='main.t47'/></span></h2>
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${approvalFlag == 'S' }"></c:when>
					<c:otherwise>
						<spring:message code='main.t41' var="t41"/>
						<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(8)" title="${lang eq '1' ? '' : t41}"><spring:message code='main.t41'/></span></h2>
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${approvalFlag == 'S' }"></c:when>
					<c:otherwise>
						<spring:message code='main.t48' var="t48"/>
						<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(9)" title="${lang eq '1' ? '' : t48}"><spring:message code='main.t48'/></span></h2>
						<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(10)"><spring:message code='main.t49'/></span></h2>
					</c:otherwise>
				</c:choose>
				<c:if test="${useAdminBujae == 'YES'}">
					<spring:message code='main.t0628' var="t0628"/>
					<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(14)" title="${lang eq '1'? '' : t0628}"><spring:message code='main.t0628'/></span></h2>				
				</c:if>
				<spring:message code='main.t45' var="t45"/>
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage('share')" title="${lang eq '1'? '' : t45}"><spring:message code='main.t45'/></span></h2>	<!-- 2019-10-11 김민성 - 구문서함 전체 조회 추가 -->
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(11)"><spring:message code='main.t42'/></span></h2>	
				<spring:message code='main.t50' var="t50"/>
				<spring:message code='main.t51' var="t51"/>
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(12)" title="${lang eq '1'? '' : t50}"><spring:message code='main.t50'/></span></h2>	
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(13)" title="${lang eq '1'? '' : t51}"><spring:message code='main.t51'/></span></h2>	
				<c:if test="${approvalFlag == 'G'}">
				    <h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="btnChangeSDept_onclick()"><spring:message code='ezApprovalG.lhr001'/></span></h2>
					<spring:message code='ezApprovalG.t560' var="t560"/>
					<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(17)" title="${lang eq '1'? '' : t560}"><spring:message code='ezApprovalG.t560'/></span></h2>
				</c:if>
				<c:if test="${useSendOutState == 'YES'}">
					<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage('sendout')"><spring:message code='ezApprovalG.yjh08'/></span></h2>
				</c:if>
				<c:if test="${useOpenGov == 'YES'}">
					<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(16)"><spring:message code='ezApprovalG.LeftMenu04'/></span></h2>				
				</c:if>
				<%-- 2020-05-14 홍승비 - 전자결재 첨부파일 개수제한 설정메뉴 추가 --%>
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage('attachLimit')"><spring:message code='ezApprovalG.hsbAL01'/></span><ul></ul></h2>
				<%-- <h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage('auditApprLineManage')">
						<spring:message code='ezAdmin.auditApprLine.01'/></span>
					<ul></ul>
				</h2>
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(20)"><spring:message code='main.t98'/></span></h2> --%>
				<%-- 2022-12-09 홍승비 - 전자결재G > 생산연도 입력받는 기록물철 자동생성 메뉴 추가 (useRegisterCabinetSemiAuto 테넌트 컨피그 체크) --%>
				<c:if test="${approvalFlag == 'G' && useRegisterCabinetSemiAuto == 'YES'}">
					<spring:message code='ezApprovalG.HSBAC01' var="HSBAC01"/>
					<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage('autoRegCabinet')" title="${lang eq '1' ? '' : HSBAC01}"><spring:message code='ezApprovalG.HSBAC01'/></span></h2>
				</c:if>
				<%-- 2025-02-28 이가은 - 전자결재 > 연동 테스트 메뉴 추가 --%>
				<spring:message code='ezApprovalG.connTest01' var="connTest01"/>
                <h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage('approvalConn')" title="${lang eq '1' ? '' : connTest01}"><spring:message code='ezApprovalG.connTest01'/></span></h2>
			</div>
		</div>
	</body>
</html>
