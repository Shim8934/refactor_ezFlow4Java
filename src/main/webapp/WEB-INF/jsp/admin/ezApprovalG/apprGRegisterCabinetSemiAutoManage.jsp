<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.HSBAC01' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			// 회계연도를 보정한 연도값을 전달 (-0개월 또는 -2개월 감소 보정을 완료한 연도)
			// 올해 1월 1일 ~ 12월 31일까지를 회계연도로 가지는 경우는 현재 날짜에 -0 (변함없음)
			// 올해 3월 1일 ~ 내년 2월 28/29일까지를 회계연도로 가지는 경우는 현재 날짜에 -2개월 감소 보정
			var nowYear = parseInt("<c:out value = '${nowYear}' />");
			var isRegCabIng = false; // 중복 동작 방지용 플래그
			
			function registerCabinetManual() {
				
				// 중복 동작 방지
				if (isRegCabIng == true) {
					return;
				}
				
				var regYearInput = document.getElementById("regYear");
				onlyNumberInput(regYearInput); // 제출 전 한번 더 입력 체크, 숫자만 허용
				
				var regYear = regYearInput.value;
				
				// 생산연도가 입력되지 않은 경우
				if (regYear.trim() == "") {
					alert("<spring:message code='ezApprovalG.HSBAC09'/>");
					return;
				}
				// 생산연도가 회계연도를 보정한 현재 연도보다 이전이거나 동일한 경우
				// 예 : 현재 연도 2022년 / 생산연도 2019년 철 생성 시도 -> 제한
				// 예 : 올해 3월 1일 ~ 내년 2월 28/29일까지를 회계연도로 가지는 경우 -> 2022년 2월 10일에 2022년도 철 생성 -> 허용 (회계연도 보정으로 2021년 12월 10일로 비교됨, 2022년도부터 철 생성 가능) 
				// 예 : 올해 3월 1일 ~ 내년 2월 28/29일까지를 회계연도로 가지는 경우 -> 2022년 3월 1일에 2022년도 철 생성 -> 제한 (회계연도 보정으로 2022년 1월 1일로 비교됨, 2023년도부터 철 생성 가능) 
				else if (parseInt(regYear) <= nowYear) {
					alert("<spring:message code='ezApprovalG.HSBAC10' arguments='" + nowYear + "'/>");
    				return;
    			}
				
	    		var ret = confirm("<spring:message code='ezApprovalG.HSBAC02'/>"); // 입력한 생산연도로 기록물철 자동생성을 진행하시겠습니까?
	    		
	    		if (ret) {
	    			isRegCabIng = true;
	    			
					// 진행상황 갱신 (없음 -> 진행중)
	    			document.getElementById("processTxt").innerHTML = "<spring:message code='ezBoard.HSBAt008'/>";
					
					$.ajax({
						type : "POST",
						url : "/admin/ezApprovalG/registCabinetSemiAutoManual.do",
						async : false,
						data : {
							regYear : regYear,
							companyID : $("#ListCompany").val()
						},
						success : function (result) {
							isRegCabIng = false;
							
	    					if (result == "TRUE") {
	    						// 진행상황 갱신 (진행중 -> 완료)
		    					document.getElementById("processTxt").innerHTML = "<spring:message code='ezBoard.HSBAt009'/>";
		    					alert("<spring:message code='ezApprovalG.HSBAC03'/>"); // 기록물철 자동 생성을 완료하였습니다.
	    					}
	    					else if (result == "EMPTY") {
	    						// 진행상황 갱신 (진행중 -> 없음)
	    						document.getElementById("processTxt").innerHTML = "<spring:message code='ezBoard.HSBAt007'/>";
		    					alert("<spring:message code='ezApprovalG.HSBAC11'/>"); // 자동 생성의 대상이 되는 기록물철이 존재하지 않습니다.
	    					}
	    					else if (result.indexOf("FALSE") > -1) {
	    						// 진행상황 갱신 (진행중 -> 일부 오류 발생 / n개의 기록물철 자동생성 실패)
	    						var failCnt = result.split(";")[1];
		    					document.getElementById("processTxt").innerHTML = "<spring:message code='ezBoard.HSBAt011'/> /" + failCnt + "개의 기록물철 자동 생성 실패";
		    					alert("<spring:message code='ezApprovalG.HSBAC04'/>"); // 기록물철 자동 생성 중 오류가 발생했습니다.
	    					}
						},
						error : function (request, status, error) {
							isRegCabIng = false;
							
							console.log("code : " + request.status + "\n" + "error : " + error);
							
							// 진행상황 갱신 (진행중 -> 중단 (오류 발생))
							document.getElementById("processTxt").innerHTML = "<spring:message code='ezBoard.HSBAt011'/>";
	    					alert("<spring:message code='ezApprovalG.HSBAC04'/>");
						}
					});
				}
			}
			
			// 숫자만 입력받도록 제한 (자릿수는 maxlength로 4자리 제한)
			function onlyNumberInput(obj) {
				obj.value = obj.value.replace(/[^0-9]/g,'');
			}
			
			// 회사 선택 시, 해당 회사의 회계연도를 보정하여 nowYear를 갱신
			function selectCompanyID() {
			    $.ajax({
			        type : "GET",
			        async : false,
			        url : "/admin/ezApprovalG/getAccountingYMByCompanyID.do",
			        data : {
			        	companyID : $("#ListCompany").val()
			        },
			        success : function (result) {
			        	var resYMArray = result.split(";"); // 회계종료 연;월 형태를 반환
			            nowYear = resYMArray[0];
			        	
			        	// 만약 회계종료월이 12월이 아니라면, 내년도의 1월, 2월, 3월....이 되므로 연도에 + 1 처리
			        	var accountYear = parseInt(nowYear);
			        	if (resYMArray[1] != 12) {
			        		accountYear += 1;
			        	}
			        	
			            document.getElementById("nowYearSpan1").innerHTML = ("<spring:message code='ezApprovalG.HSBAC05' arguments='" + nowYear + "'/>");
			            document.getElementById("nowYearSpan2").innerHTML = ("* <spring:message code='ezApprovalG.HSBAC12'/>" + accountYear + strLang1028 + " " + resYMArray[1] + strLang1029);
			            document.getElementById("nowYearSpan3").innerHTML = ("* <spring:message code='ezApprovalG.HSBAC10' arguments='" + nowYear + "'/>");
			        },
			        error : function (request, status, error) {
			        	console.log("code : " + request.status + "\n" + "error : " + error);
					}
				});
			}
			
		</script>
		
	</head>
	<body class="mainbody">
	    <h1>
	    	<spring:message code = 'ezApprovalG.HSBAC01' />
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
	    	<select id="ListCompany" class="companySelect" onChange="selectCompanyID()">
	        	<c:forEach var="item" items="${list}">
            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
		    </select>
	    </h1>
	
		<div style="max-width:800px;">			
			<div class="box" style="padding:10px; line-height:22px;" >
			  	<span id="nowYearSpan1"><spring:message code="ezApprovalG.HSBAC05" arguments="${nowYear}"/></span><br>
			  	<span id="nowYearSpan2">* <spring:message code="ezApprovalG.HSBAC12"/><c:out value="${accountYear}"/><spring:message code="main.t00048"/> <c:out value="${accountLastMonth}"/><spring:message code="main.t00049"/></span><br>
			  	<span id="nowYearSpan3">* <spring:message code="ezApprovalG.HSBAC10" arguments="${nowYear}"/></span><br><br>
			  	<spring:message code="ezApprovalG.HSBAC06"/><input id="regYear" type="text" onKeyup="onlyNumberInput(this);" maxlength="4"/>
			</div>
			<br>
			<div class="box" style="padding:10px; line-height:22px;" >
			  	<spring:message code="ezApprovalG.HSBAC07"/> <span id="processTxt"><spring:message code="ezBoard.HSBAt007"/></span>
			  	<br>
			  	* <spring:message code="ezApprovalG.HSBAC08"/>
			</div>			
			<div class="btnpositionJsp">
			    <a class="imgbtn"><span onclick="registerCabinetManual()" ><spring:message code="ezApprovalG.HSBAC01"/></span></a>
			</div>
		</div>
	
	</body>
</html>