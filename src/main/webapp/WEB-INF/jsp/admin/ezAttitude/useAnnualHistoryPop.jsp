<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('ezAttitude.i1', 'msg')}" type="text/css"/>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">
	    	var companyId = "<c:out value="${companyId}" />";
	    	var userId = "<c:out value="${userId}" />";
	    	var year = "<c:out value="${year}" />";
	    	var userDeptId;
	    	var userDeptName;
	    
	    	$(document).ready(function() {
	    		useAnnualHistory();
   			});
	    	
	    	function useAnnualHistory() {
	    		$.ajax({
	    			data : "GET",
	    			dataType : "json",
	    			url : "/admin/ezAttitude/useAnnualHistoryList.do",
	    			data : {
	    				companyId : companyId,
	    				userId : userId,
	   					year : year,
    				},
	    			success : function(result){
	    				$("#userName").text(result.list[0].userName);
	    				$("#userTitle").text(result.list[0].userTitle);
	    				$("#userDept").text(result.list[0].deptName);
	    				if (result.list[0].imgPath != null && result.list[0].imgPath != "") {
		    				$("#userImage").attr("src","/admin/ezOrgan/getPersonalInfo.do?fileName=" + result.list[0].imgPath);
	    				} 
	    				var totalAnnualCnt = 0;
		    			if (Number(result.list[0].totalAnnualCnt.split(".")[1]) > 0) {
		    				totalAnnualCnt = result.list[0].totalAnnualCnt;
		    			} else {
		    				totalAnnualCnt = result.list[0].totalAnnualCnt.split(".")[0];
		    			}
	    				$("#totalAnnualCnt").text(totalAnnualCnt);
	    				if (result.list[0].startDate != null && result.list[0].startDate != "") {
		    				userAnnualListSet(result.list);
	    				}
	    				
	    				//스크롤 생길시
	    				if(result.list.length > 8) {
	    		    		var addTh = "<th style='width: 9px;'></th>";
	    		    		$(".mainlist tr th:eq(3)").after(addTh);
	    				}
	    			},
	    			error : function() {
	    				alert("<spring:message code='ezAttitude.t59'/>");
	    			}
	    		});
	    	}
	    	
	    	function userAnnualListSet(list) {
	    		var html = "";
	    		var AccumCnt = 0;
	    		var annualCnt = 0;//연차 수
	    		var morningCnt = 0;//오전반차 수
	    		var afternoonCnt = 0;//오후반차 수
	    		
	    		$("#contentlist .mainlist tbody").html("");
	    		
	    		list.forEach(function(vo, index) {
	    			html = "<tr>";
		    		html += "<td style='width:35%'>";
	    			if (vo.typeId === "A11") { //연차
		    			html += vo.startDate.substr(0,10) + " ~ " + vo.endDate.substr(0,10);
		    			annualCnt ++;
	    			} else if (vo.typeId === "A12") { //오전반차
		    			html += vo.startDate.substr(0,10);
		    			morningCnt ++;
	    			} else { //오후반차
	    				html += vo.startDate.substr(0,10);
	    				afternoonCnt ++;
	    			}
	    			html += "</td>";
	    			html += "<td style='width:25%'>" + vo.typeName + "</td>";
	    			html += "<td style='width:15%'>" + Number(vo.annualCnt) + "</td>";
	    			//누적 연차 수
	    			AccumCnt += Number(vo.annualCnt);
	    			html += "<td style='width:15%'>" + AccumCnt + "</td>";
	    			html += "</tr>";
		    		$("#contentlist .mainlist tbody").after(html);
	    		})
	    		
	    		$("#FA11").text(annualCnt);
	    		$("#FA12").text(morningCnt);
	    		$("#FA13").text(afternoonCnt);
	    	}
	    	
		</script>
	</head>
	<body class="popup">
	    <h1>
	    	사용내역확인
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
			<div class="timecheck_info">
		    	<dl class="timeInfo" style="position:static">
		        	<dt class="timeInfoPic">	
						<img id="userImage" src="/images/kr/main/bestEmployee_pic_none.png" width="48px" height="48px">
		        	</dt>
		            <dd class="timeInfoText"><span id="userName"></span><span id="userTitle"></span><span id="userDept" style="color:#aaa9a9"></span></dd>
		        </dl>
		        <dl class="timeIcconDL">
		        	<dt class="timeIconDT"><img src="/images/ImgIcon/late_icon.png"></dt>
		            <dd class="timeIconDD">총 연차수 <span class="timeCountR" id="totalAnnualCnt">0</span></dd>
		        </dl>
		        <dl class="timeIcconDL">
		        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_day.png"></dt>
		            <dd class="timeIconDD">연차 <span class="timeCountR" id="FA11">0</span></dd>
		        </dl>
		        <dl class="timeIcconDL">
		        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_am.png"></dt>
		            <dd class="timeIconDD">오전반차 <span class="timeCountR" id="FA12">0</span></dd>
		        </dl>
		        <dl class="timeIcconDL">
		        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_pm.png"></dt>
		            <dd class="timeIconDD">오후반차 <span class="timeCountR" id="FA13">0</span></dd>
		        </dl>
		    </div>
	    </table>
	    <br/>
	    <!-- 리스트 -->
		<div style="width: 100%; height: 100%;">
            <table class="mainlist" style="width: 100%;">
                <tr>
                    <th style="width: 35%; padding-left:15px;"><span>일자</span></th>
                    <th style="width: 25%; "><span>휴가유형</span></th>
                    <th style="width: 15%; "><span>금번 사용 연차수</span></th>
                    <th style="width: 15%; "><span>누적 사용 연차 수</span></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="height: 235px; overflow-y: auto;">
                <table class="mainlist" style="width: 100%;">
                    <tr>
                        <td colspan="4" style="text-align: center;"><spring:message code='ezAttitude.t130' /></td>
                    </tr>
                </table>
            </div>
        </div>
	</body>
</html>

