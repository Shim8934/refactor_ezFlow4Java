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
		<style>
			#attiStatis table td {
				color : #777;
				font-size : 13px;
				text-align : center;
				border : 1px solid #dedede;
			}
			#attiStatis {
				border : 1px solid #dedede;
			}
			.statsP {
				text-align: center;
    			border: 0px;
    			text-decoration: none;
    			font-weight: normal;
    			color: #333;
    			font-size: 12px;
/*     			border-top: 1px solid #e2e3e6; */
    			border-bottom: 1px solid #e2e3e6;
    			background-color: #f1f3f5;
    			height: 23px;
    			margin-top: 0px;
  				margin-bottom: 0px;
    			padding-top: 8px;
    			padding-bottom: 8px;
    			padding-left: 4px;
    			height: 17px;
    			width: 151px;
			}
			dl {
				display: inline-block;
			}
			.time_stats .statsUL {
/* 				border-left: 1px solid #eaeaea; */
				margin: 0px 0px 0px 0px;
    			padding: 0px 0px;
    			list-style: none;
    			box-sizing: border-box;
			}
			.time_stats .statsUL li .statsDL {
			    margin: 0px;
			    padding: 5px 10px;
			    overflow: hidden;
			    /* border-bottom: 1px solid #f1f1f1; */
			    box-sizing: border-box;
			    height: 31px;
			}
			.time_stats .statsUL li .statsDL dt {
			    margin: 0px;
			    float: left;
			    font-family: malgun gothic, Meiryo UI;
			    font-size: 12px;
			    color: #000;
			    padding: 4px 0px 0px 21px;
			}
			.time_stats .statsUL li .statsDL dd {
			    margin: 0px;
			    padding: 2px 5px;
			    float: right;
			    font-size: 12px;
			    color: #0470e4;
			    font-family: malgun gothic, Meiryo UI;
			    font-weight: bold;
			    height: 21px;
			    line-height: 21px;
			    box-sizing: border-box;
			    /* background: rgb(243, 245, 247); */
			    /* border: 1px solid #c8ccd0; */
			    border-radius: 25px;
			    -webkit-border-radius: 25px;
			    -moz-border-radius: 20px;
			    cursor: pointer;
			}
			.timecheck_info .timeInfo {
				float: left;
				position: static;
				margin-right: 20px;
				margin-top: 20px;
			}
			.countDL {
				margin: 35px 0px 0px 0px;
			}
			.mainlist th, td{
			    overflow: hidden;
			    text-overflow: ellipsis;
			    white-space: nowrap;
			}
		</style>	
	    <script type="text/javascript">
	    	var date = new Date()
        	var year = date.getFullYear(); //현재년도
        	var selyear = year; //선택한 년도
	    	var companyId = "<c:out value="${companyId}" />";
	    	var userId = "<c:out value="${userId}" />";
	    	var userDeptId;
	    	var userDeptName;
	    	var yearLength = 10;
	    	var orderCell = ""; //정렬 명
	    	var orderOption = ""; //정렬 형식(ASC, DESC)
   			var src = "";
	    
	    	$(document).ready(function() {
	    		//헤더 클릭 시 정렬
	    		$(document).on('click', '.mainlist th', function(){
	    			if ($(this).attr("colname") != "") {
	    				if (!$(this).find("img").length) { // 새로운 th를 클릭한 경우
	    					src = "";
	    					orderOption = "";
	    					orderCell = $(this).attr("colname");
	    				}
	    			
		    			if (orderOption == "" || orderOption == "DESC") {
		    				src = '/images/etc/view-sortup.gif';
		    				orderOption = "ASC";
		    			} else {
		    				src = '/images/etc/view-sortdown.gif';
		    				orderOption = "DESC";
		    			}
		    			
		    			$(".mainlist th").find("img").remove();
		    			$(this).append("<img src='" + src + "' align='absmiddle'/>");
	    			}
		    		makeoptionyear();	    		
	    		});
	    		getMonthlyAnnualList();
	    		makeoptionyear();
   			});
	    	
	    	//년도 selectBox
	    	function makeoptionyear() {
	            var tempyear = year;
	    		
	    		if ($("#searchYear").val() != null && $("#searchYear").val() != "") {
	    			selyear = Number($("#searchYear").val());
	    			tempyear = (selyear + 4 > year) ? year : selyear + 4;
	    		}
                
	    		if (tempyear <= year || selyear == year) {
		    		//초기화
		    		$("#searchYear").html("");
		    		
		    		var optionHtml = "";
	                for (var i = 0; i < yearLength; i++) {
	                	optionHtml += "<option value='" + tempyear + "'>";
	                	optionHtml += tempyear + "</option>";
	                	
	                	tempyear--;
	                }
	                
	                $("#searchYear").html(optionHtml);
	                $("#searchYear").val(selyear);
	    		}
	    		
	    		//리스트
	    		getUserAnnualList();
	    	}
	    	
	    	function getUserAnnualList() {
	    		$.ajax({
	    			data : "GET",
	    			dataType : "json",
	    			url : "/ezAttitude/getUserAnnualList.do",
	    			data : {
	   					year : selyear,
	   					orderCell : orderCell,
	   					orderOption : orderOption
    				},
	    			success : function(result) {
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
	    				
	    				userAnnualListSet(result.list);
	    				
	    				//스크롤 생길시
	    				if(result.list.length > 15) {
	    		    		var addTh = "<th style='width: 9px;'></th>";
	    		    		$(".mainlist tr th:eq(4)").after(addTh);
	    				}
	    			},
	    			error : function() {
	    				alert("<spring:message code='ezAttitude.t59'/>");
	    			}
	    		});
	    	}
	    	
	    	function userAnnualListSet(list) {
	    		var html = "";
	    		var accumCnt = 0;
	    		var annualCnt = 0;//연차 수
	    		var morningCnt = 0;//오전반차 수
	    		var afternoonCnt = 0;//오후반차 수
	    		var i = 1; //NO
	    		
	    		$("#contentlist .mainlist tr").remove();
	    		
	    		if (list.length > 0) {
		    		list.forEach(function(vo, index) {
		    			var content = $.trim($("<p></p>").html(vo.content).text());
		    			html = "<tr id='" + vo.attitudeId + "'>";
			    		html += "<td style='width:60px'>" + i + "</td>";
			    		html += "<td style='width:25%'>";
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
		    			html += "<td style='width:15%'>" + vo.typeName + "</td>";
		    			html += "<td style='width:12%'>" + Number(vo.annualCnt) + "</td>";
		    			html += "<td style='width:44%'>" + content + "</td>";
		    			html += "</tr>";
			    		$("#contentlist .mainlist tbody").after(html);
			    		
		    			//누적 연차 수
		    			accumCnt += Number(vo.annualCnt);
		    			i++;
		    		});
	    		} else {
		    			html = "<tr>";
			    		html += "<td colspan='5' style='text-align: center'><spring:message code='ezAttitude.t130' /></td>";
		    			html += "</tr>";
			    		$("#contentlist .mainlist tbody").html(html);
	    		}
	    		
	    		$("#accumCnt").text(accumCnt);
	    		$("#remainCnt").text(Number($("#totalAnnualCnt").text()) - accumCnt);	    		
	    		
	    		$("#FA11").text(annualCnt);
	    		$("#FA12").text(morningCnt);
	    		$("#FA13").text(afternoonCnt);
	    	}
	    	
	    	/**
			* [개인근태현황, 부서근태현황] 근태유형 메소드
			*/
			function getMonthlyAnnualList() {
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getMonthlyAnnualList.do",
					data : {
						year : selyear
					},
					success : function(result) {
						getMonthlyAnnualList_After(result);
					}
				})
			}
	    	
	    	/**
			* [개인근태현황, 부서근태현황] 통계바 메소드
			*/
			function getMonthlyAnnualList_After(result) {
				//, "height":$("#attiCalendar").css("height")
				var objDiv = $("<div></div>").addClass("time_stats");
				var objP = $("<p></p>").addClass("statsP").text("월별통계");
				var objUl = $("<ul></ul>").addClass("statsUL");
				var objLi = $("<li></li>");
				var objDl = "";
				var objDt = "";
				var objDd = "";
				
				objDiv.append(objP);
				for (var i = 0; i < result.length; i++) {
					objDl = $("<dl></dl>").addClass("statsDL");
					objDt = $("<dt></dt>");
					
					objDt.html($("<div style='width:70px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;' title='" + result[i].month + "'></div>").html(result[i].month + "월"));
					objDd = $("<dd></dd>")
					 .text(result[i].annualCount + "일")
					 .attr("id", result[i].month)
					
					objDl.append(objDt);
					objDl.append(objDd);
					objLi.append(objDl);
				}
				
				objUl.append(objLi);
				$("#attiStatis").append(objP);
				$("#attiStatis").append(objUl);
				
			}
	    	
			//엑셀 다운로드
			function exportExcel() {
				if ($('#contentlist table.mainlist tbody tr').eq(0).attr('id') == 'List_TR_noItems') {
					alert("<spring:message code='ezAttitude.t56'/>");
					return;
				}
				
		    	exportExcelframe.location.href="/ezAttitude/excelUserAnnualExport.do?year=" + selyear;
		    	exportExcelframe.target="_blank";
			}
	    	
			function slideTd() {
				if ($("#slideImg").attr("src") == "/images/ImgIcon/slideLeft.png") {
					$("#attiStatis").css("height", "");
					
					$("#attiStatis").animate({
						width: "151px"
					}, 500);
					
					$("#slideBtn").animate({
						right: "147px"
					}, 500, function(){
						$("#slideImg").attr("src", "/images/ImgIcon/slideRight.png");
					});
				} else {
					$("#attiStatis").animate({
						width: "0px"
					}, 500, function(){
						$("#attiStatis").css("height", "0px");
					});
					
					$("#slideBtn").animate({
						right: "2px"
					}, 500, function(){
						$("#slideImg").attr("src", "/images/ImgIcon/slideLeft.png");
					});
				}
			}
	    	
		</script>
	</head>
	<body class="mainbody" style="overflow:auto;" marginwidth="0" marginheight="0">
	    <h1>
	    	개인연차현황
	    </h1>
<!-- 	    <table class="content"> -->
			<div class="timecheck_info">
		    	<dl class="timeInfo">
		        	<dt class="timeInfoPic" style="margin: 0px;">	
						<img id="userImage" src="/images/kr/main/bestEmployee_pic_none.png" width="48px" height="48px">
		        	</dt>
		            <dd class="timeInfoText"><span id="userName"></span><span id="userTitle"></span><span id="userDept" style="color:#aaa9a9"></span></dd>
		        </dl>
			     <dl class="countDL">
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_day.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t239' /><span class="timeCountR" id="totalAnnualCnt">0</span></dd>
			        </dl>
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_am.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t238' /><span class="timeCountR" id="accumCnt">0</span></dd>
			        </dl>
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_pm.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t253' /><span class="timeCountR" id="remainCnt">0</span></dd>
			        </dl>
			     </dl>
		        <dl class="countDL">
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_day.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t254' /><span class="timeCountR" id="FA11">0</span></dd>
			        </dl>
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_am.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t255' /> <span class="timeCountR" id="FA12">0</span></dd>
			        </dl>
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_pm.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t256' /> <span class="timeCountR" id="FA13">0</span></dd>
			        </dl>
			     </dl>
		    </div>
		    <div id="mainmenu">
			    <ul id="tb_Parent">
			    	<li>
				    	<select id="searchYear" onchange="makeoptionyear();" style="padding-right:50px;height:24px">
				    	</select>			    	
			    	</li>
			    	<li id="reply"><span onclick="exportExcel()">엑셀다운로드</span></li>
		    </div>
<!-- 	    </table> -->
	    <!-- 리스트 -->
	    <table>
			<tr>
				<td style="vertical-align:top; width:100%;">
			        <div style="width: 100%; height: 100%;">
			            <table class="mainlist" style="width: 100%;">
			                <tr>
			                    <th style="width: 60px;"><span>NO.</span></th>
			                    <th style="width: 25%; padding-left:15px; cursor: pointer;" colname="START_DATE"><span><spring:message code='ezAttitude.t107' /></span></th>
			                    <th style="width: 15%; cursor: pointer;" colname="TYPE_NAME"><span><spring:message code='ezAttitude.t35' /></span></th>
			                    <th style="width: 12%; cursor: pointer;" colname="annualCnt"><span><spring:message code='ezAttitude.t252' /></span></th>
			                    <th style="width: 44%;"><span>내용</span></th>
			                </tr>
			            </table>
			            <div id="contentlist" name="contentlist" style="height: 520px; overflow-y: auto;">
			                <table class="mainlist" style="width: 100%;">
			                    <tr>
			                        <td colspan="5" style="text-align: center;"><spring:message code='ezAttitude.t130' /></td>
			                    </tr>
			                </table>
			            </div>
			        </div>
				</td>
				<td style="vertical-align:top;white-space: normal;">
					<div style="vertical-align:top;width:0px;height:0px;overflow:hidden;" class="time_stats" id="attiStatis"></div>
					<div id="slideBtn" style="position:absolute;top:164px;right:2px;"><img id="slideImg" onclick="javascript:slideTd()" src="/images/ImgIcon/slideLeft.png"></div>
				</td>
			</tr>
		</table>
		<iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
	</body>
</html>

