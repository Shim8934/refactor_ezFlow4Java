<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:70%;">
	<head>
	
<style type="text/css">
input[type='number']::-webkit-outer-spin-button,
input[type='number']::-webkit-inner-spin-button {
    -webkit-appearance: none;
       -moz-appearance: none;
            appearance: none;
}

input[type='number'] {
    -moz-appearance: textfield;
}

input { 
  border:none; 
  border-right:0px; 
  border-top:0px; 
  boder-left:0px; 
  boder-bottom:0px;  /* 테두리 없애기 */
}

input[type="number"]:disabled{

background-color:transparent;
}



input[type="text"]:disabled{

background-color:transparent;
}

textarea {
  overflow-y: true;
  background-color:transparent;
  resize: none;
  height: 20px;
  text-overflow: ellipsis
}



</style>


		<title><spring:message code="ezCar.smb15"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/ezResource/Schedule_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/functionLib_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<!-- time picker-->
		<script type="text/javascript" src="${util.addVer('/js/ezCar/jquery.timepicker.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript">
		
			var carFormList = "${carFormList}";
			var car_name = "${car_name}";
			var car_nm = "${car_nm}";
			var car_ID = "${carID}";

			var startNum = "${startNum}";
			var allNo = 0;
			var complete = "<c:out value='${complete}'/>";
			var ownerNm = "<c:out value='${ownerNm}'/>"; 
			
			
			 function resize(obj) {
				  obj.style.height = "1px";
				  obj.style.height = (1 + obj.scrollHeight) + "px";
			 }
			 
			 
			/* function popupReload(){
				  document.carForm.submit();
				  window.open("about:blank", "_self").close();
				  window.opener.RefreshPageDoc();
				
			}
			
			function RefreshPageDoc() {
	        	//window.parent.left.location.href = "/ezCar/leftCar.do?flag=SELECT_NO";
	        	window.parent.right.location.reload();
	    	} */
			
			window.onbeforeunload = function () {
				btnClose_Click();
	    	} 

			function btnClose_Click() {
				window.close();
			}
			
			function check(){
				//유효성검사를 위해 넣어두었음
				var Sdatepicker = "";
				var Stimepicker = "";
				var Etimepicker = "";
				var driverdeptname = "";
				var dirvername = "";
				var S2timepicker = "";
				var bdistance = "";
				var drivepurpose = "";
				var drivepoint = "";
				var S3timepicker = "";
				var adistance = "";
				var adistanceauto = "";
				var adistancecommute = "";
				var adistancework = "";
				var adistanceetc = "";
				var controlY = "";
				var controlN = "";
				allNo = 0;
				for(var i=1; i<=startNum-1; i++){
					Sdatepicker = document.getElementById("Sdatepicker_"+i).value;
					Stimepicker = document.getElementById("Stimepicker_"+i).value;
					Etimepicker = document.getElementById("Etimepicker_"+i).value;
					driverdeptname = document.getElementById("driverdeptname_"+i).value;
					dirvername = document.getElementById("dirvername_"+i).value;
					S2timepicker = document.getElementById("S2timepicker_"+i).value;
					bdistance = document.getElementById("bdistance_"+i).value;
					drivepurpose = document.getElementById("drivepurpose_"+i).value;
					drivepoint = document.getElementById("drivepoint_"+i).value;
					S3timepicker = document.getElementById("S3timepicker_"+i).value;
					adistance = document.getElementById("adistance_"+i).value;
					adistanceauto = document.getElementById("adistanceauto_"+i).value;
					adistancecommute = document.getElementById("adistancecommute_"+i).value;
					adistancework = document.getElementById("adistancework_"+i).value;
					adistanceetc = document.getElementById("adistanceetc_"+i).value;
					controlY = document.getElementById("Ycontrol_"+i).value;
					controlN = document.getElementById("Ncontrol_"+i).value;
					
					if(controlY == "on"){
						controlY ="";
					}
					if(controlN == "on"){
						controlN = "";
					}
					
						//모두입력하지 않았을때
						if(Sdatepicker == "" && Etimepicker == "" && driverdeptname == "" && dirvername =="" && 
								S2timepicker == "" && bdistance == "" && drivepurpose == "" && drivepoint =="" && S3timepicker =="" &&
										adistance == "" && adistanceauto == "" && adistancecommute == "" && adistancework == "" && adistanceetc == "" &&
												controlY =="" && controlN =="" ){
							allNo++;
						}		
						
						if(allNo == startNum-1){
							alert("<spring:message code='ezCar.shb07'/>");
							return false;
						}
					
						//하나라도 입력한 값이 있을때 열 검사
						if(Sdatepicker != "" || Etimepicker != "" || driverdeptname != "" || dirvername !="" || 
								S2timepicker != "" || bdistance != "" || drivepurpose != "" || drivepoint !="" || S3timepicker !="" ||
										adistance != "" || adistanceauto != "" || adistancecommute != "" || adistancework != "" || adistanceetc != "" ||
												controlY != "" || controlN != "" ){ //하나라도 입력했다면,
									
							if(Sdatepicker == "" || Etimepicker == "" || driverdeptname == "" || dirvername =="" || 
									S2timepicker == "" || bdistance == "" || drivepurpose == "" || drivepoint =="" || S3timepicker =="" ||
											adistance == "" || adistanceauto == "" || adistancecommute == "" || adistancework == "" || adistanceetc == "" ||
													(controlY =="" && controlN =="") ){
								alert("<spring:message code='ezCar.shb08'/>");
								return false;
							}						
						}
						
					
					
			  }
		  }
			
			
			 function radioClickY(event){
						event.target.value = "Yselect";
						document.getElementById("N"+event.target.name).value="";
			} 
			 function radioClickN(event){
						event.target.value = "Nselect";
						document.getElementById("Y"+event.target.name).value="";
			} 
			
			 function addBtn(){
					var carTb = $("#testTb").find('tbody');
					var html = "<tr style='height: auto;'>";
					html += "<td style='vertical-align: middle; width: 125px; border-width: 1px; border-style: solid; border-color: #dedede; text-align: center;' width='125'>";
			         html += "<input type='text' name='Sdatepicker' id='Sdatepicker_"+startNum+"' style='width:80px;text-align:center' readonly='readonly' value='' class='Sdate'>";
			         html += "</td>"; //운행일자
			         html += "<td style='vertical-align: middle; border-width: 1px 0px 1px 1px; border-style: solid; border-color: rgb(222, 222, 222) rgb(0, 0, 0) rgb(222, 222, 222) rgb(222, 222, 222); text-align: center; width: 65px;' width='65' colspan='1'>";
			         html += "<input id='Stimepicker_"+startNum+"' name='Stimepicker' type='text' class='Stime' style='width:43px; vertical-align: middle; text-align:center' onkeypress='return KeEventControl(this);' onkeydown='return KeEventControl(this);' onkeyup='return KeEventControl(this);' onmousedown='return false' autocomplete='off' value=''>";
			         html += "</td>"; //예약시간 앞
			         html += "<td style='vertical-align: middle; border-width: 1px 0px; border-style: solid; border-color: rgb(222, 222, 222) rgb(0, 0, 0); text-align: center; width: 15px; background-image: none;' width='15' colspan='1'><p><span>~</span></p></td>";
			         html += "<td style='vertical-align: middle; border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(222, 222, 222) rgb(222, 222, 222) rgb(222, 222, 222) rgb(0, 0, 0); text-align: center; width: 54px;' width='54' colspan='1'>";
			         html += "<input id='Etimepicker_"+startNum+"' name='Etimepicker' type='text' class='Stime' style='width:43px; vertical-align: middle; text-align:center' value=''>";
			         html += "</td>"; //예약시간 뒤
			         html += "<td style='vertical-align: middle; width: 65px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='150'>";
			         html += "<input type='text' id='driverdeptname_"+startNum+"' name='driverdeptname' style='text-align: center; width: 150px; border:0;' value='' class=''>";
			         html += "</td>"; //부서
			         html += "<td style='vertical-align: middle; width: 66px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='66'>";
			         html += "<input type='text' id='dirvername_"+startNum+"' name='dirvername' style='text-align: center; width: 80px; border:0;' value=''>";
			         html += "</td>"; //사용자
			         html += "<td style='vertical-align: middle; width: 62px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='62'>";
			         html += "<input id='S2timepicker_"+startNum+"' type='text' name='S2timepicker' class='Stime' style='width:43px; vertical-align: middle; text-align:center' onkeypress='return KeEventControl(this);' onkeydown='return KeEventControl(this);' onkeyup='return KeEventControl(this);' onmousedown='return false' autocomplete='off' value=''>";
			         html += "</td>"; //회사 출발시간
			         html += "<td style='vertical-align: middle; width: 98px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='98'>";
			         html += "<input type='number' id='bdistance_"+startNum+"' name='bdistance' onkeyup='maxLengthCheck(this)' maxlength='8' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value='' class='clacA'>";
			         html += "</td>"; //출발시 누적거리
			         html += "<td style='vertical-align: middle; width: 184px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='184'>";
			 	     html += "<textarea id='drivepurpose_"+startNum+"' name='drivepurpose' style='display:block; text-align: center; width: 90%; border: 0;' onkeydown='resize(this)' onkeyup='resize(this)'></textarea>";
			 		 html += "</td>"; //주행목적
			         html += "<td style='vertical-align: middle; width: 112px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='112'>";
			         html += "<input type='text' id='drivepoint_"+startNum+"' name='drivepoint' style='text-align: center; width:90%; border:0;' value=''>";
			         html += "</td>"; //행선지
			         html += "<td style='vertical-align: middle; width: 72px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='72'>";
			         html += "<input id='S3timepicker_"+startNum+"' type='text' name='S3timepicker' class='Stime' style='width:43px; vertical-align: middle; text-align:center' onkeypress='return KeEventControl(this);' onkeydown='return KeEventControl(this);' onkeyup='return KeEventControl(this);' onmousedown='return false' autocomplete='off' value=''>";
			         html += "</td>"; //회사도착시간
			         html += "<td style='vertical-align: middle; width: 85px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='85'>";
			         html += "<input type='number' id='adistance_"+startNum+"' name='adistance' onkeyup='maxLengthCheck(this)' maxlength='8' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value='' class='calcB'>";
			         html += "</td>"; //도착시 누적거리
			         html += "<td style='vertical-align: middle; width: 73px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' colspan='' width='73'>";
			         html += "<input type='number' id='adistanceauto_"+startNum+"' name='adistanceauto' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value='' class='calcC'>";
			         html += "</td>"; //주행거리
			         html += "<td style='vertical-align: middle; width: 86px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' colspan='' width='86'>";
			         html += "<input type='number' id='adistancecommute_"+startNum+"' name='adistancecommute' onkeyup='maxLengthCheck(this)' maxlength='8' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value=''>";
			         html += "</td>"; //업무용사용거리(출퇴근용)
			         html += "<td style='vertical-align: middle; width: 93px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' colspan='' width='93'>";
			         html += "<input type='number' id='adistancework_"+startNum+"' name='adistancework' onkeyup='maxLengthCheck(this)' maxlength='8' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value=''>";
			         html += "</td>"; //업무용사용거리(업무용)
			         html += "<td style='vertical-align: middle; width: 113px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' colspan='2' width='113' rowspan='1'>";
			         html += "<input type='number' id='adistanceetc_"+startNum+"' name='adistanceetc' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value=''>";
			         html += "</td>"; //업무 외이용
			         html += "<td style='vertical-align: middle; width: 45px; border-width: 1px 0px 1px 1px; border-style: solid; border-color: rgb(222, 222, 222); background-image: none; text-align: center;' colspan='' width='45'><p style='text-align: center;'>"; 
			         html += "<input type='radio' onclick='radioClickY(event)' name='control_"+startNum+"' id='Ycontrol_"+startNum+"' style=''>&nbsp;<span style='font-family: 맑은 고딕;'>Y</span></p></td>";
			         html += "<td style='vertical-align: middle; width: 55px; border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' colspan='' width='55'><p style='text-align: left;'>";
			         html += "<input type='radio' onclick='radioClickN(event)' name='control_"+startNum+"' id='Ncontrol_"+startNum+"' style=''>&nbsp;<span style='font-family: 맑은 고딕;'>N</span></p></td>";
			         
				carTb.append(html);
				$("input:radio[name='control_"+startNum+"']").removeAttr("checked"); //라디오버튼 초기화 위해 추가
		
				startNum++; //행추가될때 증가
				document.getElementById("count").value = startNum;
				
				var lastLength2 = $('#testTb').find('tr:last');

				$(document).find(".Sdate").removeClass('hasDatepicker').datepicker();  //동적으로 늘어나는 datepicker처리
				$(document).find(".Stime").removeClass('ui-timepicker-input').timepicker();  //동적으로 늘어나는 datepicker처리
				

	        } 
	        
	       
	        
	        function deleteBtn() {
	        	 var lo_table = document.getElementById("testTb"); 
	        	   var li_rows  = lo_table.rows.length; 
	        	   var li_row_index = li_rows -1; 

	        	   if(li_row_index < 3) {
	        		   alert('원본 행은 삭제하실 수 없습니다.');
	        	   } else{
	        	      lo_table.deleteRow(li_row_index);
	        		  startNum--; //행삭제될때 감소
	        		  document.getElementById("count").value = startNum;
	        		   return;
	       			}
	        	   
	        }
	        
	        function call(tagId){
	        	 var tagetArr = tagId.split("_");
	        	 var tagetNumber = tagetArr[1];
	        	
	        	 if(document.getElementById("adistance_"+tagetNumber).value && document.getElementById("bdistance_"+tagetNumber).value){
	        		document.getElementById('adistanceauto_'+tagetNumber).value =
	        	  parseInt(document.getElementById('adistance_'+tagetNumber).value) - parseInt(document.getElementById('bdistance_'+tagetNumber).value);
	        	 }
	        }
	        
	        function call2(tagId){
	        	 var tagetArr = tagId.split("_");
	        	 var tagetNumber = tagetArr[1];
	        	 
	        	 if(document.getElementById('adistanceauto_'+tagetNumber).value){
	        		 document.getElementById('adistanceetc_'+tagetNumber).value =
		        		 parseInt(document.getElementById('adistanceauto_'+tagetNumber).value) - 
		        		 (parseInt(document.getElementById('adistancecommute_'+tagetNumber).value) + parseInt(document.getElementById('adistancework_'+tagetNumber).value));
	              } 
	         }
	        
	        
		    $(function () {
		    	
	    	    $(".Sdate").datepicker({
	        	    changeMonth: true,
	            	changeYear: true,
	            	autoSize: true,
	            	showOn: "both",
	            	//buttonImage: "/images/ImgIcon/calendar-month.png",
	            	buttonImageOnly: true,
	            	dateFormat:"yy-mm-dd",
	        	});
	        	
	    	   	$('.Stime').timepicker();
	    	   	document.getElementById("count").value = startNum;
				document.getElementById("carID").value = car_ID;
				
				if(complete != null && complete == "1"){
					window.open("about:blank", "_self").close();
					window.opener.RefreshPageDoc();
				}
				
	     	});
		    
  
	       /* $(document).on('click', ".ui-timepicker-list li", function() {
	        	timeSelect = true;
	        })
	        
	        function KeEventControl(obj) {
	            if ((window.event.keyCode >= 48 && window.event.keyCode <= 57) || (window.event.keyCode >= 96 && window.event.keyCode <= 105)) {
	                return false;
	            }
	            else obj.value = obj.value.replace(/[\a-zㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
	        }
	       */ 
	   
	       
	</script>
	</head>
	<body class="popup" style="height:0%; ">
	
		<table class="layout">
  			<tr>
				<td style="height:20px">
    				<div id="menu">
	        			<%-- <ul>
    	      				<li><button type="submit" form="carForm" ><spring:message code="ezResource.t114"/></span></li>
        				</ul> --%>
      				</div>
      				<div id="close">
        				<ul>
          					<li><span onClick="btnClose_Click()"></span></li>
        				</ul>
      				</div>
      				<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
					</script>

<%-- <table class="kk_table" width="914" height="20" style="margin-left: auto; margin-right: auto; text-align: center; border-collapse: collapse; border: 1px none rgb(0, 0, 0); font-size: 13px; width: 914px; height: 20px; background-image: none; word-break: break-all; overflow-wrap: break-word;">
   <tbody>
      <tr>
         <td style="vertical-align: middle; width: 4px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;" width="4" rowspan="1" colspan=""><p style="text-align: center; "><span style="font-family: &quot;맑은 고딕&quot;"><span style="font-size: 26px;"><br></span></span></p></td>
         <td style="vertical-align: middle; width: 306px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;"
          width="306" rowspan="1" colspan=""><p style="font-family: 'malgun gothic'; font-size:25px;  text-align: center;"><span style="text-align:center; font-size: 26px;">차 량 운 행 기 록 일 지</span></p></td>
         <td style="vertical-align: middle; width: 92px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;"
          width="92"><p style="text-align: right; font-family: 'malgun gothic'; font-size:25px; "><span style="font-size: 26px;">( 차종 :</span></p></td>
         <td style="vertical-align: middle; width: 111px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;"
          width="111" colspan="">
             <input type="text" name="Brd_NM" id="Brd_NM" idval="${car_name}" title="<c:out value='${car_name}' />" value="<c:out value='${car_name}' />" style="text-overflow:ellipsis; background-color:transparent; border:0; width: 100%; font-family: 'malgun gothic'; text-align: center; font-size:20px;" maxlength="500" disabled>
          </td>
         <td style="vertical-align: middle; width: 155px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;"
          width="155" colspan="">
          <p style="font-family: 'malgun gothic'; font-size:25px;  text-align: left;"><span style="font-size: 26px;">) , 차량번호 (</span></p></td>
         <td style="vertical-align: middle; width: 141px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;"
          width="141" colspan="">
           <input type="text" name="car_NM" id="car_NM" idval="${car_nm}" value="<c:out value='${car_nm}' />" style="background-color:transparent; font-family: 'malgun gothic'; text-align: center;  font-size:20px; border:0; width: 100%" maxlength="500" disabled></td>
         <td style="vertical-align: middle; width: 77px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;" width="77"><p style="font-family: 'malgun gothic'; font-size:26px; text-align: left;"><span style="font-size: 26px;">)</span></p></td>
      </tr>
   </tbody>
</table> --%>

<table class="kk_table" width="914" height="20"
					style="margin-left: auto; margin-right: auto; text-align: center; border-collapse: collapse; border: 1px none rgb(0, 0, 0); font-size: 13px; width: 1200px; height: 20px; background-image: none; word-break: break-all; overflow-wrap: break-word;">
					<tbody>
						<tr>
							
							<td
								style="vertical-align: middle; width: 306px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;"
								width="306" rowspan="1" colspan=""><p
									style="font-family: 'malgun gothic'; font-size: 25px; text-align: center;">
									<span style="text-align: center; font-size: 26px;"><spring:message code='ezCar.shb18'/><c:out value='${car_name}' /> <spring:message code='ezCar.shb19'/> <c:out value='${car_nm}' />   )</span>
								</p></td>
							
						</tr>
					</tbody>
</table>

<table width="1640" height="40" class="kk_table"
					style="border: 1px rgb(0, 0, 0); border-image: none; font-size: 13px; border-collapse: collapse; -ms-word-break: break-all; background-image: none; overflow-wrap: break-word;">
					<tbody>
						<tr style="height: auto;">
							<td width="81" height="21"
								style="padding-left: 10px; border: 0px solid rgb(0, 0, 0); border-image: none; width: 81px; height: 21px; vertical-align: middle;" colspan="8"><p
									style="">
									<span style='font-family: "맑은 고딕";'><spring:message code='ezCar.shb20'/><c:out value='${ownerName}'/> ( ${ownerCall} )</span>
								</p></td>
		
						</tr>
						<tr>
						<td colspan="4"
								style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 363px; height: 19px; color: red; vertical-align: middle;">
								&nbsp&nbsp <spring:message code='ezCar.shb21'/></td>
						</tr>
						<tr>
							<td colspan="4"
								style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 300px; height: 19px; color: red; vertical-align: middle;">
								&nbsp&nbsp <spring:message code='ezCar.shb22'/></td>
								<td rowspan="1" colspan="1"
								style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 300px; height: 19px; color: red; vertical-align: middle;">
								</td>
								<td rowspan="1" colspan="1"
								style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 300px; height: 19px; color: red; vertical-align: middle;">
								</td>
								<td rowspan="1" colspan="1"
								style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 300px; height: 19px; vertical-align: middle;">
								<p style="text-align: right;"> <spring:message code='ezCar.shb23'/></p></td>
							</tr>
					</tbody>
				</table>
<div style="width:100%; height:580px; overflow-y:auto;">
<form id="carForm" name="carForm" method="post" onsubmit="return false;" action="/ezCar/modifyCarForm.do">
<table class="kk_table" id="testTb" width="1650" height="" style="word-break: break-all; overflow-wrap: break-word; border-collapse: collapse; border: 1px none rgb(0, 0, 0); font-size: 13px; background-image: none;">
   <tbody class="test1">
      <tr style="height: auto;">
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 504px; border-width: 1px; border-style: solid; border-color: #dedede; height: 37px;" height="37" width="504" rowspan="1" colspan="8"><p style="text-align: center; "><span style="font-weight: bold; font-family: &quot;맑은 고딕&quot; color: #777;"><spring:message code='ezCar.shb24'/></span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 860px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 37px;"
          height="37" width="860" rowspan="1" colspan="9"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb25'/></span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 115px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 92px;"
          colspan="2" width="115" height="92" rowspan="3"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb26'/></span></p><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb27'/></span></p></td>
      </tr>
      <tr style="height: auto;">
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 119px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;" rowspan="2" width="119" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb28'/></span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 114px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          rowspan="2" width="114" height="55" colspan="3"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb29'/></span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 150px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          rowspan="2" width="150" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb30'/></span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 66px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          rowspan="2" width="66" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb31'/></span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 62px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          rowspan="2" width="62" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb32'/></span></p><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb33'/></span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 98px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          rowspan="2" width="98" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb34'/></span></p><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb35'/></span></p><p style="text-align: center;"><span style="font-weight: bold;">(km)</span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 184px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          rowspan="2" width="184" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb36'/>*</span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 157px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          rowspan="2" width="157" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb37'/>*</span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 58px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          rowspan="2" width="58" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb32'/></span></p><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb38'/></span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 76px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          rowspan="2" width="76" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb39'/></span></p><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb35'/></span></p><p style="text-align: center;"><span style="font-weight: bold;">(km)</span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 77px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          colspan="" width="71" rowspan="2" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb77'/></span></p><p style="text-align: center;"><span style="font-weight: bold;">(Km)</span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 110px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 33.5px; text-align: center;"
          colspan="2" width="110" height="33.5" rowspan="1"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb40'/>&nbsp;</span><span style="font-weight: bold; font-family: inherit;"><spring:message code='ezCar.shb41'/>(km)</span></p></td>
         <td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 67px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
          colspan="2" width="67" rowspan="2" height="55"><p style="text-align: center;"><span style="font-weight: bold;"><spring:message code='ezCar.shb42'/>&nbsp;</span><span style="font-weight: bold; font-family: inherit;"><spring:message code='ezCar.shb43'/>&nbsp;</span></p><p style="text-align: center;"><span style="font-weight: bold; font-family: inherit;"><spring:message code='ezCar.shb44'/>(km)</span></p></td>
      </tr>
     <tr style="height: auto;">
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 7px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 21px; text-align: center;" colspan="" width="7" height="21"> <p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb45'/></span> </p>
			
			</td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 0px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 21px; text-align: center;" colspan="" width="-9" rowspan="1" height="21"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb46'/></span> </p></td>
		</tr>
      
      <c:if test="${!empty carFormList}" >
			<c:forEach var="list"  items="${carFormList}" varStatus="value">
	  		
	  				<tr style="height: auto;">
	    			<td style="vertical-align: middle; width: 119px; border-width: 1px; border-style: solid; border-color: #dedede; text-align: center;" width="119">
	    			<input type="text" id="Sdatepicker_${value.count}" name="Sdatepicker" style="border: none; width:80px;text-align:center" readonly="readonly" disabled value="${list.rev_date}" class="Sdate">
	    			</td>
	    			
	    			<td style="vertical-align: middle; width: 51px; border-width: 1px 0px 1px 1px; border-style: solid; border-color: rgb(222, 222, 222) rgb(0, 0, 0) rgb(222, 222, 222) rgb(222, 222, 222); text-align: center;" width="51">
	    			<input id="Stimepicker_${value.count}" readonly="readonly" disabled  type="text" name="Stimepicker" class="Stime" style="border: none; vertical-align: middle; width:43px; text-align:center" value="${list.rev_time}">
					</td>
					
         			<td style="vertical-align: middle; width: 2px; border-width: 1px 0px; border-style: solid; border-color: rgb(222, 222, 222) rgb(0, 0, 0); text-align: center; background-image: none;" width="15" colspan=""><p><span>~</span></p></td>
         			<td style="vertical-align: middle; width: 54px; border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(222, 222, 222) rgb(222, 222, 222) rgb(222, 222, 222) rgb(0, 0, 0); text-align: center;" width="54" colspan="">
            		<input id="Etimepicker_${value.count}" readonly="readonly" disabled  type="text" name="Etimepicker" class="Stime" style="border: none; width:43px; vertical-align: middle; text-align:center" value="${list.rev_time2}">
         			</td>
         
         			<td style="vertical-align: middle; width: 150px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="150">
            		<input title="${list.driver_deptname}" type="text" id="driverdeptname_${value.count}" name="driverdeptname" style="text-align: center; width: 90%; border:0;" value="${list.driver_deptname}" readonly="readonly" disabled>
         			</td>
         
         			<td style="vertical-align: middle; width: 66px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="66">
            		<input type="text" id="dirvername_${value.count}" name="dirvername" style="text-align: center; width: 80px; border:0;" value="${list.driver_name}" readonly="readonly" disabled >
         			</td>
         
         			<td style="vertical-align: middle; width: 62px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="62">
            		<input id="S2timepicker_${value.count}" readonly="readonly" type="text" name="S2timepicker" class="Stime" style="border: none; width:43px; vertical-align: middle; text-align:center" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"
             		autocomplete="off" value="${list.b_depart_time}" readonly="readonly" disabled>
			        </td>
			        
         			<td style="vertical-align: middle; width: 98px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="98">
            		<input type="number" id="bdistance_${value.count}" name="bdistance" onkeyup="maxLengthCheck(this)" maxlength="8" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.b_distance}" class="clacA" readonly="readonly" disabled>
         			</td>
         
         			<td style="vertical-align: middle; width: 184px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="184"><textarea title="${list.drive_purpose}" id="drivepurpose_${value.count}" name="drivepurpose" style=" text-overflow: ellipsis; overflow: hidden; text-align: center; width: 90%; border: 0;" onkeydown="resize(this)" onkeyup="resize(this)" disabled>${list.drive_purpose}</textarea></td>
           			
	         		</td>
	         		
         			<td style="vertical-align: middle; width: 157px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="157">
            		<input type="text" id="drivepoint_${value.count}" name="drivepoint" style="text-align: center; width: 150px; border:0;" value="${list.drive_point}" readonly="readonly" disabled>
         			</td>
         			
         			<td style="vertical-align: middle; width: 58px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="58">
            		<input id="S3timepicker_${value.count}" readonly="readonly" disabled type="text" name="S3timepicker" class="Stime" style="border: none; width:43px; vertical-align: middle; text-align:center" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"
             		autocomplete="off" value="${list.a_arrive_time}">
         			</td>
         
         			<td style="vertical-align: middle; width: 76px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="76">
            		<input type="number" id="adistance_${value.count}" name="adistance" onkeyup="maxLengthCheck(this)" maxlength="8" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.a_distance}" class="calcB" readonly="readonly" disabled>
	         		</td>
         			
         			<td style="vertical-align: middle; width: 77px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" colspan="" width="77">
            		<input type="number" id="adistanceauto_${value.count}" name="adistanceauto" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.a_distance_auto}" class="calcC" readonly="readonly" disabled >
         			</td>
         
         			<td style="vertical-align: middle; width: 7px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" colspan="" width="7">
            		<input type="number" id="adistancecommute_${value.count}" name="adistancecommute" onkeyup="maxLengthCheck(this)" maxlength="8" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.a_distance_commute}" readonly="readonly" disabled >
         			</td>
         			
         			<td style="vertical-align: middle; width: 0px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" colspan="" width="-9">
            		<input type="number" id="adistancework_${value.count}" name="adistancework" onkeyup="maxLengthCheck(this)" maxlength="8" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.a_distance_work}" readonly="readonly" disabled >
         			</td>
         
         			<td style="vertical-align: middle; width: 67px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" colspan="2" width="67" rowspan="1">
            		<input type="number" id="adistanceetc_${value.count}" name="adistanceetc" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.a_distance_etc}"  readonly="readonly" disabled>
         			</td>
         			
         			<c:if test="${list.a_submit_flag == 1}" >
         			<td style="vertical-align: middle; width: 60px; border-width: 1px 0px 1px 1px; border-style: solid; border-color: rgb(222, 222, 222); background-image: none; text-align: center;" colspan="" width="74" readonly="readonly" disabled ><p style="text-align: center;"> 
         			<input type="radio" name="control_${value.count}" checked="checked" onclick="radioClickY(event)" id="Ycontrol_${value.count}" style="" readonly="readonly" disabled >&nbsp;<span style="font-family: &quot;맑은 고딕&quot;">Y</span></p></td>
         			<td style="vertical-align: middle; width: 60px; border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;"
          			colspan="" width="41" readonly="readonly" disabled ><p style="text-align: left;">  
          			<input type="radio" name="control_${value.count}" onclick="radioClickN(event)" id="Ncontrol_${value.count}" style="" readonly="readonly" disabled>&nbsp;<span style="font-family: &quot;맑은 고딕&quot;">N</span></p></td>
					</c:if>
					<c:if test="${list.a_submit_flag == 0}" >
					<td style="vertical-align: middle; width: 60px; border-width: 1px 0px 1px 1px; border-style: solid; border-color: rgb(222, 222, 222); background-image: none; text-align: center;" colspan="" width="74" readonly="readonly" disabled ><p style="text-align: center;"> 
         			<input type="radio" name="control_${value.count}" onclick="radioClickY(event)" id="Ycontrol_${value.count}" style="" readonly="readonly" disabled >&nbsp;<span style="font-family: &quot;맑은 고딕&quot;">Y</span></p></td>
         			<td style="vertical-align: middle; width: 60px; border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;"
          			colspan="" width="41" readonly="readonly" disabled><p style="text-align: left;">  
          			<input type="radio" name="control_${value.count}" checked="checked" onclick="radioClickN(event)" id="Ncontrol_${value.count}" style="" readonly="readonly" disabled>&nbsp;<span style="font-family: &quot;맑은 고딕&quot;">N</span></p></td>
					</c:if>
			</tr> 
			</c:forEach>
	  </c:if>
	  <c:if test="${empty carFormList}">
			<tr>
	    		<td colspan="5" style="text-align: center"><spring:message code='main.t00026' /></td>
	    	</tr>
	  </c:if> 
   </tbody>
</table>

      <input type="hidden" name="count" id="count" value="">
      <input type="hidden" name="carID" id="carID" value="">
</form>
</div>

<table class="kk_table" width="1650" height="40" style="word-break: break-all; overflow-wrap: break-word; border-collapse: collapse; border: 1px none rgb(0, 0, 0); font-size: 13px; ">
   <tbody>
      <tr style="height: auto;">
         <td style="vertical-align: middle; width: 1386px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); background-image: none; height: 22.5px;" width="1386" height="22.5"><p><span style="font-size: 12px;"><spring:message code='ezCar.shb49'/></span></p><p><span style="white-space: pre; font-size: 12px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
         <span style="font-size: 12px;">&nbsp;&nbsp;<spring:message code='ezCar.shb50'/></span></p><p></p><p><span style="font-size: 12px;"><spring:message code='ezCar.shb51'/></span></p></td>
         <td
          style="vertical-align: middle; width: 48px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); background-image: none; height: 18px;" width="48" height="18" rowspan="1"><p><span><br></span></p></td>
            <td style="vertical-align: middle; width: 38px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); background-image: none; height: 18px;" width="38" height="18" rowspan="1"><p><span><br></span></p></td>
      </tr>
   </tbody>
</table>
   </body>
</html>