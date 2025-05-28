<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html style="height:0%;">
	<head>
		<title><spring:message code="ezCar.smb16"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
			var strBrd_ID = "${strBrdID}";
			var strOwnDeptID = "${ownDeptID}";
			var strOwnDeptNm = "${ownDeptNm}";
			var strOwnerID = "${ownerID}";
			var strOwnerNm = "${ownerNm}";
			var strOwnerPosition = "${ownerPosition}";
			var strOwnerCall = "${ownerCall}";
			var strMakeDate = "${makeDate}";
			var attachList1 = "${attachList1}";
			
			var car_nm = "${car_nm}";
			
			/* window.onload = function () { 
		    	document.getElementById("TitleInfo").innerHTML = " - [" + strLang1002 + "<span class='txt_color' style='font-weight:bold;'> " + TotalCnt + " </span>" + strLang1003 + "]";
			} */
			
			function btnClose_Click(){
				window.close();
			}
			
			/*  function carFormListLoad(date){
	    		$.ajax({
	    			type : "GET",
	    			async : false,
	    			url : "/ezCar/carFormListAjax.do",
	    			dataType : "json",
	    			data : {
	    				date : date,
	    				carID : pBrdid
	    			},
	    			success : function(result) {
	    				boardList = "<table class='mainlist' style='width:100%; min-width:700px;'>";
	    				boardList += "<tr>";
	    			    boardList += "<th style='padding:0px; width:30px'><input type='checkbox' name='checkbox' onClick='reverse(this.checked)' id='Checkbox1'></th>";
	    			    boardList += "<th> 제목</th>";
	    			    boardList += "<th style='width:100px'> 부서</th>";
	    			    boardList += "<th style='width:120px'> 게시자</th>";
	    			    boardList += "<th style='display:none; width:120px'> 게시자id</th>";
	    			    boardList += "<th style='width:120px'> 게시일</th>";
	    			    boardList += "</tr>";
	    				list = result.carFormList;
	    					if(list.length > 0){
	    						list.forEach(function(vo,index){
	    							boardList += "<tr>";
	    							boardList += "<td style='padding:0;'><input type='checkbox' name='chk' id='chk' value='"+vo.car_form_id+"'></td>";
	    							boardList += "<td ondblclick='Item_View("+vo.car_form_id+");' style='cursor: pointer; word-wrap:break-word;' align='left'>";
	    							var revdate = vo.rev_date;
	    							revdate = revdate.substring(0,7);
	    							boardList += vo.register_name+"_"+revdate+"_차량일지";
	    							boardList += "</td>";
	    							boardList += "<td id='dept_name' style='word-wrap:break-word;'>"+vo.register_deptname+"</td>";
	    							boardList += "<td id='register_name' style='word-wrap:break-word;'>"+vo.register_name+"</td>";
	    							boardList += "<td id='register_id' style='display:none; word-wrap:break-word;'>"+vo.register_id+"</td>";
	    							boardList += "<td id='register_date' style='word-wrap:break-word;'>"+vo.register_date+"</td>";
	    							boardList += "</tr>"
	    						});
	    					}
	    					else{
	    						boardList += "<tr>";
	    						boardList += "<td colspan='5' style='text-align: center'>데이터가 없습니다</td>";
	    						boardList += "</tr>"
	    					}
	    				boardList += "</table>";
	    				$('#carList').html("");
	    				$('#carList').append(boardList);
	    				
	    			}
	    		});
	    	} 
	    	
	    	function Item_View(carID) {
		        pURL = "/ezCar/carRevItem.do?carID=" + carID
		        var openLocation = pURL;
		        openwindow(openLocation, "", 580, 450);
	    	} */
		</script>
	</head>
	<body class="popup" style="height:100%">
	
	
		<table class="layout">
  			<tr>
    			<td height="20">
    				<h1 style="text-overflow:ellipsis;overflow:hidden;white-space:nowrap;"><spring:message code='ezCar.shb68' /><c:out value='${carName} ( ${car_nm} )'/><span id="TitleInfo"></span></h1>
      				<div id="close">
        				<ul>
          					<li><span onClick="btnClose_Click()"></span></li>
        				</ul>
      				</div>
      				
      		<div id="carList"> 
    	<table class="mainlist" style="width:100%; min-width:400px;">
	  			<tr>
	    			<th colspan="2" style="width:90px; text-align: center;"> <spring:message code='ezCar.shb31' /> </th>
	    			<th colspan="2" style="width:90px; text-align: center;"> <spring:message code='ezCar.shb28' /> </th>
	    			<th colspan="5" style="width:90px; text-align: center;"> <spring:message code='ezCar.shb29' /> </th>
	  			</tr>
	  			
	  			<c:if test="${!empty carFormList}" >
					<c:forEach var="list"  items="${carFormList}" begin="${start}" varStatus="value">
	  					<tr>
							<td colspan="2" id="dept_name" style="width:90px; text-align: center;"> ${list.driver_name}</td>			
							<td colspan="2" id="dept_name" style="width:90px; text-align: center;"> ${list.rev_date}</td>			
							<td colspan="2" id="register_name" style="width:90px; text-align: right;">${list.rev_time} </td>			
							<td colspan="1" id="register_id" style="width:90px; text-align: center;"> ~ </td>			
							<td colspan="2" id="register_date" style="width:90px; text-align: left;"> ${list.rev_time2}</td>		
							
						</tr> 
					</c:forEach>
				</c:if>
				
				<c:if test="${empty carFormList}">
					<tr>
	    				<td colspan="9" style="text-align: center"><spring:message code='main.t00026' /></td>
	    			</tr>
				</c:if> 
			</table>
		</div>
			</div>				
      	
	</tbody>
</table>
	</body>
</html>