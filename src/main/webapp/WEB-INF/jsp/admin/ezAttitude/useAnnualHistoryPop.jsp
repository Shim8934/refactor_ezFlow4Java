<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
		<style>
			dl {
				display: inline-block;
			}
			.timecheck_info .timeInfo {
				float: left;
				position: static;
				margin-top: 20px;
    			width: 29%;
			}
			.countDL {
				margin: 0px;
			}
		</style>	
	    <script type="text/javascript">
			var date = new Date();
	    	var year = date.getFullYear(); //현재 년도
	    	var todayMonth = (date.getMonth() + 1); //현재 월
	    	var todayDate = date.getDate(); //현재 일
	    	var selyear = year; //선택한 년도
	    	var companyId = "<c:out value="${companyId}" />";
	    	var userId = "<c:out value="${userId}" />";
	    	var useAnnualAutoGnrt = "<c:out value="${annualconfig.useAnnualAutoGnrt}" />";
	    	var annualGnrtStd = "<c:out value="${annualconfig.annualGnrtStd}" />";
	    	var initialDate = "<c:out value="${annualconfig.initialDate}" />";
	    	var joinDate = "<c:out value="${joinDate}" />";
	    	var userDeptId;
	    	var userDeptName;
	    	var yearLength = Number(year) - Number(joinDate.split("-")[0]) + 1;
	        var orderCell = ""; //정렬 명
	    	var orderOption = ""; //정렬 형식(ASC, DESC)
	    	var src = "";
	    	var selAttitudeId = "";
	    	var holiDays = new Array();
	    
	    	$(document).ready(function() {
	    		if(joinDate == null || joinDate == "" || joinDate == "0") {
           			joinDate = "0000-01-01";
           			yearLength = 20;
           		}
	    		
	    		makeoptionyear();
   			});
	    	
    		function caldate(date, day){
    			 
 				var caledmonth, caledday, caledYear;
 				var loadDt = date;
 				var v = new Date(Date.parse(loadDt) - day*1000*60*60*24);
 
 				caledYear = v.getFullYear();
 
			 	if ( v.getMonth() < 9 ){
			  		caledmonth = '0'+(v.getMonth()+1);
			 	} else {
			  		caledmonth = v.getMonth()+1;
			 	}
			 	if ( v.getDate() < 9 ){
			  		caledday = '0'+v.getDate();
			 	} else {
			  		caledday = v.getDate();
			 	}
			 	return caledYear+'-'+caledmonth+'-'+caledday;
			}
	    	
	    	//년도 selectBox
	    	function makeoptionyear() {
	            var tempyear = year;
	            var startDate = "";
	            var endDate = "";
	    		
				if ($("#searchYear").val() == null || $("#searchYear").val() == "") {
					selyear = initialDate.split("-")[0];
	    		}

	    		if ($("#searchYear").val() != null && $("#searchYear").val() != "") {
	    			selyear = Number($("#searchYear").val());
	    			tempyear = year;
	    		}
		        
                if (tempyear <= year || selyear == year) {
		    		//초기화
		    		$("#searchYear").html("");
		    		
		    		var optionHtml = "";
	                for (var i = 0; i < yearLength; i++) {
						if (i == 0) {
							optionHtml += "<option selected value='" + tempyear + "' ";
						} else {
							optionHtml += "<option value='" + tempyear + "' ";
						}
	                	if (annualGnrtStd == 1) {
	                		if(initialDate.substring(5, 7) < todayMonth || (initialDate.substring(5, 7) == todayMonth && initialDate.substring(8, 10) < todayDate)) {
	                			startDate = tempyear + "-" + initialDate.substring(5, 10);
	                			endDate = caldate(new Date(tempyear + 1, initialDate.substring(5, 7) - 1, initialDate.substring(8, 10)), 1);
	                		} else {
	                			startDate = (tempyear - 1) + "-" + initialDate.substring(5, 10);
	                			endDate = caldate(new Date(tempyear, initialDate.substring(5, 7) - 1, initialDate.substring(8, 10)), 1);
	                		}
	                		optionHtml += "startDate='" + startDate + "' endDate='" + endDate + "'>";
		                	optionHtml += startDate + " ~ " + endDate + "</option>";
	                	} else {
	                		if(joinDate.substring(5, 7) < todayMonth || (joinDate.substring(5, 7) == todayMonth && joinDate.substring(8, 10) < todayDate)) {
	                			startDate = tempyear + "-" + joinDate.substring(5, 10);
	                			endDate = caldate(new Date(tempyear + 1, joinDate.substring(5, 7) - 1, joinDate.substring(8, 10)), 1);
	                		} else {
	                			startDate = (tempyear - 1) + "-" + joinDate.substring(5, 10);
	                			endDate = caldate(new Date(tempyear, joinDate.substring(5, 7) - 1, joinDate.substring(8, 10)), 1);
	                		}
	                		optionHtml += "startDate='" + startDate + "' endDate='" + endDate + "'>";
		                	optionHtml += startDate + " ~ " + endDate + "</option>";
	                	}
	                	
	                	tempyear--;
	                }
	                $("#searchYear").html(optionHtml);
	                $("#searchYear").val(selyear);
	    		}

	    		//리스트
	    		useAnnualHistory();
	    	}
                
	    	function useAnnualHistory() {
	    		var startDate = $("#searchYear option:selected").attr("startDate");
				console.log(startDate);
	    		var endDate = $("#searchYear option:selected").attr("endDate");
				var startYear = "";
				var joinYear = "";
	    		var secondYear = "N";
				
				if (startDate != null) {
					startYear = startDate.substring(0, 4);
					joinYear = joinDate.substring(0, 4);
				}
    			
    			var startDate2 = new Date(startDate);
    			var endDate2 = new Date(endDate);
    			var joinDate2 = new Date(Number(joinDate.substring(0, 4)) + 1, joinDate.substring(5, 7) - 1, joinDate.substring(8, 10));
    			var joinDate3 = new Date(Number(joinDate.substring(0, 4)) + 2, joinDate.substring(5, 7) - 1, joinDate.substring(8, 10));
	    		if(annualGnrtStd == 0) {
	    			if(startYear - joinYear == 1) {
	    				secondYear = "Y";
	    			}
	    		} else {
	    			if(startDate2 <= joinDate2 && endDate2 >= joinDate2) {
	    				secondYear = "Y";
	    			} else if(startDate2 <= joinDate3 && endDate2 >= joinDate3) {
	    				secondYear = "T";
	    			}
	    		}
	    		
	    		$.ajax({
			    	type:"GET",
			       	dataType : "json",
			       	async : false,
			       	url : "/ezAttitude/getHoliDays.do",
			       	data : {
			          	startDate : startDate,
			          	endDate : endDate
			       	},
			       	success : function(result) {
			       		holiDays = [];
			       		result.forEach(function(resultDateStr, index) {
			          		holiDays.push(resultDateStr);
			       		})
			       	},
			       	error : function(jqXHR, textStatus, errorThrown) {
 			  			alert("에러발생! " + jqXHR.status + ", " + jqXHR.readyState);
					}
				})
	    		
	    		$.ajax({
	    			data : "GET",
	    			dataType : "json",
	    			url : "/admin/ezAttitude/useAnnualHistoryList.do",
	    			data : {
	    				companyId : companyId,
	    				userId : userId,
	    				startDate : startDate,
	    				endDate : endDate,
	    				orderCell : orderCell,
	   					orderOption : orderOption,
	   					secondYear : secondYear
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
		    			
	    				userAnnualListSet(result.list);
	    				
	    				//스크롤 생길시
	    				if(result.list.length > 15) {
	    		    		var addTh = "<th style='width: 9px;'></th>";
	    		    		$(".mainlist tr th:eq(3)").after(addTh);
	    				}
	    			},
	    			error : function() {
	    				alert("<spring:message code='ezAttitude.t59'/>");
	    			}
	    		});
	    	}
	    	
	    	function getHolidayCnt(startDate, endDate) {
    			var returnCnt = 0;
   		    	var subDate = calDateRange(startDate, endDate);      
   		    	var betweenDate = new Date(startDate);
   		    	for (var i = 0; i <= subDate; i++) {
   		        	betweenDate.setDate(betweenDate.getDate() + (i == 0 ? 0 : 1));
   		         
   		         	var year = betweenDate.getFullYear();
   		         	var month = (betweenDate.getMonth() + 1) + "";
   		         	var date = betweenDate.getDate() + "";
   		         	if(month.length == 1) {
   		            	month = "0" + month;
   		         	}
   		         	if(date.length == 1) {
   		            	date = "0" + date;
   		         	}
   		         
   		         	for (var j = 0; j < holiDays.length; j++) {
   		            	if($.inArray(year + '-' + month + '-' + date,holiDays) != -1) {
   		               		returnCnt++;
 	  		               	break;
   			            } 
   			        }
   		    	}
    			return returnCnt;
	    	}
	    	
	    	/**
	    	* 두 날짜의 차이를 구하는 메소드
	    	* val1 = startDate, val2 = endDate
	    	*/
	    	function calDateRange(val1, val2)
	    	{
	    	   var FORMAT = "-";

	    	   // 년도, 월, 일로 분리
	    	   var start_dt = val1.split(FORMAT);
	    	   var end_dt = val2.split(FORMAT);

	    	   // Number()를 이용하여 08, 09월을 10진수로 인식하게 함.
	    	   start_dt[1] = (Number(start_dt[1]) - 1) + "";
	    	   end_dt[1] = (Number(end_dt[1]) - 1) + "";

	    	   var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2]);
	    	   var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2]);

	    	   return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;
	    	}
	    	
	    	function userAnnualListSet(list) {
	    		var html = "";
	    		var accumCnt = 0;
	    		var annualCnt = 0;//연차 수
	    		var morningCnt = 0;//오전반차 수
	    		var afternoonCnt = 0;//오후반차 수
	    		var halfOffCnt = 0; //반반차 수
	    		var i = 1; //NO
	    		
	    		$("#contentlist .mainlist tr").remove();
		    	if (Number(list[0].annualCnt) > 0) {
		    		list.forEach(function(vo, index) {
		    			var holidayCnt = 0;
		    			if(vo.endDate != null) {
			    			holidayCnt = getHolidayCnt(vo.startDate.substr(0,10), vo.endDate.substr(0,10));
		    			}
		    			var useAnnualCnt = (Number(vo.annualCnt) - (vo.annualApprStatus == -1 ? 0 : holidayCnt));
		    			html = "<tr>";
		    			html += "<td style='width:60px'>" + i + "</td>";
			    		html += "<td style='width:35%'>";
		    			if (vo.typeId === "A11") { //연차
			    			html += vo.startDate.substr(0,10) + " ~ " + vo.endDate.substr(0,10);
			    			annualCnt += useAnnualCnt;
		    			} else if (vo.typeId === "A12") { //오전반차
			    			html += vo.startDate.substr(0,10);
			    			morningCnt += useAnnualCnt;
		    			} else if (vo.typeId === "A13"){ //오후반차
		    				html += vo.startDate.substr(0,10);
		    				afternoonCnt += useAnnualCnt;
		    			} else if (vo.typeId === "A21") { //반반차
		    				html += vo.startDate.substr(0,10) + " ~ " + vo.endDate.substr(0,10);
		    				halfOffCnt += useAnnualCnt;
		    			}
		    			html += "</td>";
		    			html += "<td style='width:25%'>" + vo.typeName + "</td>";
		    			html += "<td style='width:15%'>" + useAnnualCnt + "</td>";
		    			html += "</tr>";
			    		$("#contentlist .mainlist tbody").after(html);
			    		
		    			//누적 연차 수
		    			accumCnt += useAnnualCnt;
		    			i++;
		    		});
	    		} else {
		    		html += "<tr><td colspan='4' style='text-align: center'><spring:message code='ezAttitude.t130' /></td></tr>";
		    		$("#contentlist .mainlist tbody").html(html);
	    		}
	    		
	    		
	    		$("#accumCnt").text(accumCnt);
	    		$("#remainCnt").text(Number($("#totalAnnualCnt").text()) - accumCnt);	    		
	    		
	    		$("#FA11").text(annualCnt);
	    		$("#FA12").text(morningCnt);
	    		$("#FA13").text(afternoonCnt);
	    		$("#FA21").text(halfOffCnt);
	    	}
	    	
		</script>
	</head>
	<body class="popup">
	    <h1>
	    	<spring:message code='ezAttitude.t240' />
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
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
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_pm02.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.kje04' /> <span class="timeCountR" id="FA21">0</span></dd>
			        </dl>
			     </dl>
		    </div>
		<div id="mainmenu">
			<ul id="tb_Parent">
				<li>
					<select id="searchYear" onchange="makeoptionyear();" style="padding-right:50px;height:24px">
				    </select>			    	
			    </li>
		</div>
	    <!-- 리스트 -->
		<div style="width: 100%; height: 100%;">
            <table class="mainlist" style="width: 100%;">
                <tr>
                	<th style="width: 60px;"><span>NO.</span></th>
                    <th style="width: 35%; padding-left:15px;"><span><spring:message code='ezAttitude.t107' /></span></th>
                    <th style="width: 25%; "><span><spring:message code='ezAttitude.t35' /></span></th>
                    <th style="width: 15%; "><span><spring:message code='ezAttitude.t252' /></span></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="height: 320px; overflow-y: auto;">
                <table class="mainlist" style="width: 100%;">
                	<tbody></tbody>
                </table>
            </div>
        </div>
	</body>
</html>

