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

textarea {
  overflow-y: hidden;
  resize: none;
  height: 20px;
}



</style>


		<title><spring:message code="ezCar.smb03"/></title>
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
		<link rel="stylesheet" href="${util.addVer('/js/ezCar/jquery.ui.datepicker.css')}" />
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
			var car_form_id = "${car_form_id}"
			var startNum = "${startNum}";
			var allNo = 0;
			var complete = "<c:out value='${complete}'/>";
			
			
			 function resize(obj) {
				  obj.style.height = "1px";
				  obj.style.height = (1 + obj.scrollHeight) + "px";
			 }
			 

			
			

			function btnClose_Click() {
				window.close();
			}
	    	
	    	function maxLengthCheck(object){
			    if (object.value.length > object.maxLength){
			      //object.maxLength : 매게변수 오브젝트의 maxlength 속성 값입니다.
			      object.value = object.value.slice(0, object.maxLength);
			    }    
			  }
			
			
	    	function checkDuplicateValue(dateArr, sTimeArr, eTimeArr) { 
	    	    var comparisonFlag = true; 
	    	 
	    	    if(dateArr.length > 0 && sTimeArr.length > 0 && eTimeArr.length > 0) { 
	    	        for(var i = 0 ; i < (dateArr.length - 1) ; i++) { 
	    	            for(var j = ( i + 1) ; j < dateArr.length ; j++) { 
	    	                if( (dateArr[i] == dateArr[j]) && comparisonTime(sTimeArr[i], eTimeArr[i], sTimeArr[j], eTimeArr[j]) ) { 
	    	                    comparisonFlag = false; 
	    	                } 
	    	            } 
	    	        } 
	    	    } else { 
	    	        return null; 
	    	    } 
	    	 
	    	    return comparisonFlag; 
	    	} 
	    	 
	    	function comparisonTime(sTimeRange, eTimeRange, sTime, eTime) {
	    	    if(sTimeRange == "" || eTimeRange == "" || sTime == "" || eTime == "") return false;

	    	    if( (sTimeRange <= sTime && sTime < eTimeRange) || (sTime < sTimeRange && eTime > sTimeRange) ) {
	    	        return true;
	    	    } else {
	    	        return false;
	    	    }
	    	}
			
			 function saveClick(){
				 //check();
				 //document.body.appendChild(carForm);
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
					
					var indexing = "";
					var arrayindex = document.getElementsByName("Sdatepicker");
					var str = [];
					for(var i=0; i<arrayindex.length; i++){
						var str1 = document.getElementsByName("Sdatepicker")[i].id;
						var strArray = str1.split('_');
						str[i+1] = strArray[1];
						indexing = indexing + strArray[1] + ',' //indexing에 쉼표와함께 인덱스번호를 추가한다.
					} //id값 뒤에 붙는 addNum들을 str배열에 받아두었다. -> str[1]배열부터 시작하여 넣어둠
					
					document.getElementById('indexing').value = indexing;
					
					for(var i=1; i<=startNum-1; i++){
						Sdatepicker = document.getElementById("Sdatepicker_"+str[i]).value;
						Stimepicker = document.getElementById("Stimepicker_"+str[i]).value;
						Etimepicker = document.getElementById("Etimepicker_"+str[i]).value;
						driverdeptname = document.getElementById("driverdeptname_"+str[i]).value;
						dirvername = document.getElementById("dirvername_"+str[i]).value;
						S2timepicker = document.getElementById("S2timepicker_"+str[i]).value;
						bdistance = document.getElementById("bdistance_"+str[i]).value;
						drivepurpose = document.getElementById("drivepurpose_"+str[i]).value;
						drivepoint = document.getElementById("drivepoint_"+str[i]).value;
						S3timepicker = document.getElementById("S3timepicker_"+str[i]).value;
						adistance = document.getElementById("adistance_"+str[i]).value;
						adistanceauto = document.getElementById("adistanceauto_"+str[i]).value;
						adistancecommute = document.getElementById("adistancecommute_"+str[i]).value;
						adistancework = document.getElementById("adistancework_"+str[i]).value;
						adistanceetc = document.getElementById("adistanceetc_"+str[i]).value;
						controlY = document.getElementById("Ycontrol_"+str[i]).value;
						controlN = document.getElementById("Ncontrol_"+str[i]).value;
						
						if (controlY == "on") {
							controlY = "";
						}
						if (controlN == "on") {
							controlN = "";
						}		
						
						
							//모두입력하지 않았을때
							if(Sdatepicker == "" && Stimepicker == "" && Etimepicker == "" && driverdeptname == "" && dirvername =="" && 
									S2timepicker == "" && bdistance == "" && drivepurpose == "" && drivepoint =="" && S3timepicker =="" &&
											adistance == "" && adistanceauto == "" && adistancecommute == "" && adistancework == "" && adistanceetc == "" &&
													controlY =="" && controlN =="" ){
								allNo++;
							}		
							
							if(allNo == startNum-1){
								alert("<spring:message code='ezCar.shb07' />");
								return false;
							}
						
							//하나라도 입력한 값이 있을때 열 검사
							if(Sdatepicker != "" || Stimepicker != "" || Etimepicker != "" || driverdeptname != "" || dirvername !="" 
									|| S2timepicker != "" || bdistance != "" || drivepurpose != "" || drivepoint !="" || S3timepicker !=""
										|| adistance != "" || adistanceauto != "" || adistancecommute != "" || adistancework != "" || adistanceetc != "" 
											||controlY !="" || controlN !=""){ //하나라도 입력했다면,
										
								if(Sdatepicker == "" || Stimepicker == "" || Etimepicker == "" || driverdeptname == "" || dirvername =="" ){
									alert("<spring:message code='ezCar.shb08' />");
									return false;
								}						
							}
							
						
						
				  }
					
					for(var i=1; i<=startNum-1; i++){
					    if(document.getElementById('Etimepicker_'+str[i]).value < document.getElementById('Stimepicker_'+str[i]).value ){
					    	alert("<spring:message code='ezCar.shb09' />"+i+"<spring:message code='ezCar.shb10' />");
					    	return false;
					    }
					    if(document.getElementById('S3timepicker_'+str[i]).value < document.getElementById('S2timepicker_'+str[i]).value ){
					    	alert("<spring:message code='ezCar.shb11' />"+i+"<spring:message code='ezCar.shb10' />");
					    	return false;
					    }
					    if(parseInt(document.getElementById('adistance_'+str[i]).value) < parseInt(document.getElementById('bdistance_'+str[i]).value)){
					    	alert("<spring:message code='ezCar.shb12' />"+i+"<spring:message code='ezCar.shb10' />");
					    	return false;
					    }
					}
					
					
					//차례대로 입력하지 않았을때 
					var binNum = 0; //가장마지막에 있는 빈값을 갖고있는 SdatePicker의 아이디를 찾는다.
					for(var i=1; i<=startNum-1; i++){
						if(document.getElementById('Sdatepicker_'+str[i]).value!=""){
							binNum = i; 
						}
					}
					
					for(var j=1; j<=binNum-1; j++){
						if(document.getElementById('Sdatepicker_'+str[j]).value==""){
							alert("<spring:message code='ezCar.shb13' />");
							return false;
						}
					}
					
					var initialDate = window.opener.document.getElementById('calTitle').innerText.trim(" ");
					initialDate = initialDate + "-1";
					
				    var jjungbok = true;	
					
					 $.ajax({
				    	type : "GET",
				    	dataType : "json",
				    	async : false,
				    	data : {
				    		carID : car_ID,
				    		date : window.opener.document.getElementById('calTitle').innerText.trim(" "),
				    		carFormID : car_form_id
				    	},
				    	url : "/ezCar/carRevItemExceptcarFormIdAjax.do",
				    	success: function(result){
				    		list = result.carFormList;
				    		/* var test = document.getElementsByName('Sdatepicker');
				    		var test1 = document.getElementsByName('Stimepicker');
				    		var test2 = document.getElementsByName('Etimepicker'); */
				    		var test = new Array();
				    		var test1 = new Array();
				    		var test2 = new Array();
				    		
				    		$("input[name=Sdatepicker]").each(function(index, item){
				    			test.push($(item).val());
				    		});
				    		$("input[name=Stimepicker]").each(function(index, item){
				    			test1.push($(item).val());
				    		});
				    		$("input[name=Etimepicker]").each(function(index, item){
				    			test2.push($(item).val());
				    		});
				    		
				    		if(list.length > 0){
				    			for(var i=0; i<list.length; i++){
				    				test.push(list[i].rev_date); //시작시간들을 배열에담음
				    				test1.push(list[i].rev_time);
				    				test2.push(list[i].rev_time2); //종료시간들응 배열에담음
				    				
				    			}
				    		}
				    	
				    		
						if(!checkDuplicateValue(test,test1,test2)){
							alert("<spring:message code='ezCar.shb14' />");
							jjungbok = false;
						}
				    		
				    	},
				    	error: function(err){
				    		alert("<spring:message code='ezCar.shb15' />");
				    	}
				     }); 
					 

					if(!jjungbok){
						return false;
					}	
					
				 carForm.submit();
				 //document.body.removeChild(carform);
				 alert("<spring:message code='ezCar.shb76' />");
			 } 
			 
			 function radioClickY(event){
						event.target.value = "Yselect";
						document.getElementById("N"+event.target.name).value="";
			} 
			 function radioClickN(event){
						event.target.value = "Nselect";
						document.getElementById("Y"+event.target.name).value="";
			} 
			
			 function addBtn() {
					var carTb = $("#testTb").find('tbody');
					var html = "<tr style='height: auto;'>";
					html += "<td style='vertical-align: middle; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222);  text-align: center; width: 25px; width='25' colspan='1'>";
					html += "<input type='checkbox' name='chkbox' id='chk_"+addNum+"' style='width:20px;text-align:center' value='' >";
					html += "</td>";
					html += "<td style='vertical-align: middle; width: 125px; border-width: 1px; border-style: solid; border-color: #dedede; text-align: center;' width='125'>";
					html += "<input type='text' name='Sdatepicker' id='Sdatepicker_"+addNum+"' style='width:80px;text-align:center' readonly='readonly' value='' class='Sdate'>";
					html += "</td>"; //운행일자

					html += "<td style='vertical-align: middle; border-width: 1px 0px 1px 1px; border-style: solid; border-color: rgb(222, 222, 222) rgb(0, 0, 0) rgb(222, 222, 222) rgb(222, 222, 222); text-align: center; width: 65px;' width='65' colspan='1'>";
					html += "<input id='Stimepicker_"
							+ addNum
							+ "' name='Stimepicker' type='text' class='Stime' style='width:43px; vertical-align: middle; text-align:center' onkeypress='return KeEventControl(this);' onkeydown='return KeEventControl(this);' onkeyup='return KeEventControl(this);' onmousedown='return false' autocomplete='off' value=''>";
					html += "</td>"; //예약시간 앞
					html += "<td style='vertical-align: middle; border-width: 1px 0px; border-style: solid; border-color: rgb(222, 222, 222) rgb(0, 0, 0); text-align: center; width: 15px; background-image: none;' width='15' colspan='1'><p><span>~</span></p></td>";
					html += "<td style='vertical-align: middle; border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(222, 222, 222) rgb(222, 222, 222) rgb(222, 222, 222) rgb(0, 0, 0); text-align: center; width: 54px;' width='54' colspan='1'>";
					html += "<input id='Etimepicker_"+addNum+"' name='Etimepicker' type='text' class='Stime' style='width:43px; vertical-align: middle; text-align:center' value=''>";
					html += "</td>"; //예약시간 뒤
					html += "<td style='vertical-align: middle; width: 65px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='65'>";
					html += "<input type='text' id='driverdeptname_"+addNum+"' name='driverdeptname' style='text-align: center; width: 150px; border:0;' value='' class=''>";
					html += "</td>"; //부서
					html += "<td style='vertical-align: middle; width: 66px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='150'>";
					html += "<input type='text' id='dirvername_"+addNum+"' name='dirvername' style='text-align: center; width: 80px; border:0;' value=''>";
					html += "</td>"; //사용자
					html += "<td style='vertical-align: middle; width: 62px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='62'>";
					html += "<input id='S2timepicker_"
							+ addNum
							+ "' type='text' name='S2timepicker' class='Stime' style='width:43px; vertical-align: middle; text-align:center' onkeypress='return KeEventControl(this);' onkeydown='return KeEventControl(this);' onkeyup='return KeEventControl(this);' onmousedown='return false' autocomplete='off' value=''>";
					html += "</td>"; //회사 출발시간
					html += "<td style='vertical-align: middle; width: 98px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='98'>";
					html += "<input type='number' id='bdistance_"
							+ addNum
							+ "' name='bdistance' onkeypress='txtOnlyNum(event)' onkeyup='maxLengthCheck(this); this.value=this.value.replace(/[^0-9]/g,&#39;&#39;);' maxlength='8' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value='' class='clacA'>";
					html += "</td>"; //출발시 누적거리
					html += "<td style='vertical-align: middle; width: 184px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='184'>";
					html += "<textarea id='drivepurpose_"+addNum+"' name='drivepurpose' style='display:block; text-align: center; width: 90%; border: 0;' onkeydown='resize(this)' onkeyup='resize(this)'></textarea>";
					html += "</td>"; //주행목적
					html += "<td style='vertical-align: middle; width: 112px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='90%'>";
					html += "<input type='text' id='drivepoint_"+addNum+"' name='drivepoint' style='text-align: center; width: 150px; border:0;' value=''>";
					html += "</td>"; //행선지
					html += "<td style='vertical-align: middle; width: 72px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='72'>";
					html += "<input id='S3timepicker_"
							+ addNum
							+ "' type='text' name='S3timepicker' class='Stime' style='width:43px; vertical-align: middle; text-align:center' onkeypress='return KeEventControl(this);' onkeydown='return KeEventControl(this);' onkeyup='return KeEventControl(this);' onmousedown='return false' autocomplete='off' value=''>";
					html += "</td>"; //회사도착시간
					html += "<td style='vertical-align: middle; width: 85px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' width='85'>";
					html += "<input type='number' id='adistance_"
							+ addNum
							+ "' name='adistance' onkeypress='txtOnlyNum(event)' onkeyup='maxLengthCheck(this); this.value=this.value.replace(/[^0-9]/g,&#39;&#39;);' maxlength='8' oninput='call(this.id)' ' style='text-align: center; width: 100px; border:0;' value='' class='calcB'>";
					html += "</td>"; //도착시 누적거리
					html += "<td style='vertical-align: middle; width: 73px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' colspan='' width='73'>";
					html += "<input type='number' id='adistanceauto_"
							+ addNum
							+ "' name='adistanceauto' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value='' class='calcC' >";
					html += "</td>"; //주행거리
					html += "<td style='vertical-align: middle; width: 86px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' colspan='' width='86'>";
					html += "<input type='number' id='adistancecommute_"
							+ addNum
							+ "' name='adistancecommute' onkeypress='txtOnlyNum(event)' onkeyup='maxLengthCheck(this); this.value=this.value.replace(/[^0-9]/g,&#39;&#39;);' maxlength='4' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value=''>";
					html += "</td>"; //업무용사용거리(출퇴근용)
					html += "<td style='vertical-align: middle; width: 93px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' colspan='' width='93'>";
					html += "<input type='number' id='adistancework_"
							+ addNum
							+ "' name='adistancework' onkeypress='txtOnlyNum(event)' onkeyup='maxLengthCheck(this); this.value=this.value.replace(/[^0-9]/g,&#39;&#39;);' maxlength='4' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value=''>";
					html += "</td>"; //업무용사용거리(업무용)
					html += "<td style='vertical-align: middle; width: 113px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' colspan='2' width='113' rowspan='1'>";
					html += "<input type='number' id='adistanceetc_"
							+ addNum
							+ "' name='adistanceetc' oninput='call(this.id)' style='text-align: center; width: 100px; border:0;' value='' >";
					html += "</td>"; //업무 외이용
					html += "<td style='vertical-align: middle; width: 45px; border-width: 1px 0px 1px 1px; border-style: solid; border-color: rgb(222, 222, 222); background-image: none; text-align: center;' colspan='' width='45'><p style='text-align: center;'>";
					html += "<input type='radio' onclick='radioClickY(event)' name='control_"
							+ addNum
							+ "' id='Ycontrol_"
							+ addNum
							+ "' style=''>&nbsp;<span style='font-family: 맑은 고딕;'>Y</span></p></td>";
					html += "<td style='vertical-align: middle; width: 55px; border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;' colspan='' width='55'><p style='text-align: left;'>";
					html += "<input type='radio' onclick='radioClickN(event)' name='control_"
							+ addNum
							+ "' id='Ncontrol_"
							+ addNum
							+ "' style=''>&nbsp;<span style='font-family: 맑은 고딕;'>N</span></p></td>";

					carTb.append(html);
					$("input:radio[name='control_" + addNum + "']").removeAttr("checked"); //라디오버튼 초기화 위해 추가

				addNum ++;
				startNum++; //행추가될때 증가
				document.getElementById("count").value = startNum;
				
				var lastLength2 = $('#testTb').find('tr:last');
	            
	            var initialDate = window.opener.document.getElementById('calTitle').innerText.trim(" ");
	            initialDate=initialDate+"-1";
	              $(".Sdate").datepicker({
	                 defaultDate : initialDate,
	                  changeMonth: false,
	                  changeYear: false,
	                  autoSize: true,
	                  showOn: "both",
	                  buttonImage: "/images/ImgIcon/calendar-month.png",
	                  buttonImageOnly: true,
	                  dateFormat:"yy-mm-dd",
	                  stepMonths: 0,
	                   showOtherMonths: false,
	                   selectOtherMonths: false,
	                   monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                                "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                                "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                                "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	                   monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                                     "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                                     "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                                     "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	              }).focus(function () {
	                  $(".ui-datepicker-next").hide();
	                  $(".ui-datepicker-prev").hide();
	              });
	              
				$(document).find(".Sdate").removeClass('hasDatepicker').datepicker({
	                 defaultDate : initialDate,
	                  changeMonth: false,
	                  changeYear: false,
	                  autoSize: true,
	                  //showOn: "both",
	                  buttonImage: "/images/ImgIcon/calendar-month.png",
	                  buttonImageOnly: true,
	                  dateFormat:"yy-mm-dd",
	                  stepMonths: 0,
	                   showOtherMonths: false,
	                   selectOtherMonths: false,
	                   monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                                "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                                "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                                "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	                   monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                                     "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                                     "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                                     "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	              }).focus(function () {
	                  $(".ui-datepicker-next").hide();
	                  $(".ui-datepicker-prev").hide();
	              });//동적으로 늘어나는 datepicker처리
		        	
				 
				//$(document).find(".Sdate").removeClass('hasDatepicker').datepicker();  //동적으로 늘어나는 datepicker처리
				$(document).find(".Stime").removeClass('ui-timepicker-input').timepicker();  //동적으로 늘어나는 datepicker처리
				

	        } 
	        
	       
	        
	        function deleteBtn() {
	        /* 	 var lo_table = document.getElementById("testTb"); 
	        	   var li_rows  = lo_table.rows.length; 
	        	   var li_row_index = li_rows -1; 

	        	   if(li_row_index < 3) {
	        		   alert('원본 행은 삭제하실 수 없습니다.');
	        	   } else{
	        	      lo_table.deleteRow(li_row_index);
	        		  startNum--; //행삭제될때 감소
	        		  document.getElementById("count").value = startNum;
	        		   return;
	       			} */
	        	   
	       
	       		
	       		var lo_table = document.getElementById("testTb");
	       		var checkIndex = []; 
	       		var obj_length = document.getElementsByName("chkbox").length;
	       		  
	       		var j = 0;
	           	for (var i=0; i<obj_length; i++) {
	               	if (document.getElementsByName("chkbox")[i].checked == true) {
	                  	   checkIndex[j] = i+3;
	                  	   j++;
	               	}
	           	}
	           	
	           	if(checkIndex.length <= 0){
	    	    	alert("<spring:message code='ezCar.shb17' />");
	    	    	return;
	    	    }else{
	    	    	for(var i=0; i<checkIndex.length; i++){
	    				lo_table.deleteRow(checkIndex[i]-i);
	    				startNum--; //행삭제될때 감소
	    				document.getElementById("count").value = startNum;
	    	    	}
	    	    }
	        	   
	        }
	        
	        function call(tagId){
	        	 var tagetArr = tagId.split("_");
	        	 var tagetNumber = tagetArr[1];
	        	
	        	 if(document.getElementById("adistance_"+tagetNumber).value && document.getElementById("bdistance_"+tagetNumber).value){
	        		document.getElementById('adistanceauto_'+tagetNumber).value =
	        	  parseInt(document.getElementById('adistance_'+tagetNumber).value) - parseInt(document.getElementById('bdistance_'+tagetNumber).value);
	        	 }
	     
	        	 if(document.getElementById('adistanceauto_'+tagetNumber).value){
	        		 document.getElementById('adistanceetc_'+tagetNumber).value =
		        		 parseInt(document.getElementById('adistanceauto_'+tagetNumber).value) - 
		        		 (parseInt(document.getElementById('adistancecommute_'+tagetNumber).value) + parseInt(document.getElementById('adistancework_'+tagetNumber).value));
	              } 
	        }
	        
	       /*  function call2(tagId){
	        	 var tagetArr = tagId.split("_");
	        	 var tagetNumber = tagetArr[1];
	        	 
	        	 if(document.getElementById('adistanceauto_'+tagetNumber).value){
	        		 document.getElementById('adistanceetc_'+tagetNumber).value =
		        		 parseInt(document.getElementById('adistanceauto_'+tagetNumber).value) - 
		        		 (parseInt(document.getElementById('adistancecommute_'+tagetNumber).value) + parseInt(document.getElementById('adistancework_'+tagetNumber).value));
	              } 
	         }
	         */
	        
		    $(function () {
		    	
		    	var initialDate = window.opener.document.getElementById('calTitle').innerText.trim(" ");
	            initialDate=initialDate+"-1";
	        	 $(".Sdate").datepicker({
	                 defaultDate : initialDate,
	                  changeMonth: false,
	                  changeYear: false,
	                  autoSize: true,
	                  showOn: "both",
	                  buttonImage: "/images/ImgIcon/calendar-month.png",
	                  buttonImageOnly: true,
	                  dateFormat:"yy-mm-dd",
	                  stepMonths: 0,
	                   showOtherMonths: false,
	                   selectOtherMonths: false,
	                   monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                                "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                                "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                                "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	                   monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                                     "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                                     "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                                     "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	              }).focus(function () {
	                  $(".ui-datepicker-next").hide();
	                  $(".ui-datepicker-prev").hide();
	              });
	        	
	    	   	$('.Stime').timepicker();
	    	   	addNum = startNum;
	    	   	document.getElementById("count").value = startNum;
				document.getElementById("carID").value = car_ID;
				document.getElementById("car_form_id").value = car_form_id;
				
				if(complete != null && complete == "1"){
					window.open("about:blank", "_self").close();
					window.opener.RefreshPageDoc();
				}
				
				for(var i=1; i<=startNum-1; i++){
					if(document.getElementById("Ycontrol_"+i).checked){
						document.getElementById("Ycontrol_"+i).value = "Yselect";
						document.getElementById("Ncontrol_"+i).value="";
					}
					if(document.getElementById("Ncontrol_"+i).checked){
						document.getElementById("Ncontrol_"+i).value = "Nselect";
						document.getElementById("Ycontrol_"+i).value="";
					}
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
	       
	       function txtOnlyNum(e) {
				var keycode = (window.netscape) ? e.which : e.keyCode;
				if(!(keycode == 0 || keycode == 8 ||(keycode >=48 && keycode <= 57 ))){
				if(window.netscape){
				e.preventDefault();
				}else{
				e.returnValue = false;
				}
				}
				}
	   
	       
	</script>
	</head>
	<body class="popup" style="height:0%; ">
	
		<table class="layout">
  			<tr>
				<td style="height:20px">
    				<div id="menu">
	        			<ul>
    	      				<li><button type="button" onclick="saveClick()" form="carForm" style="display: inline-block; background: white; border-top: 1px solid #c7c7c7; border-left: 1px solid #c7c7c7;
	border-right: 1px solid #c7c7c7; border-bottom: 1px solid #909193; height: 25px; padding: 0px 8px 2px 8px;
	line-height: 25px; font-size: 13px; color: #393939;" ><spring:message code="ezResource.t114"/></button></li>
        				</ul>
      				</div>
      				<div id="close">
        				<ul>
          					<li><span onClick="btnClose_Click()"></span></li>
        				</ul>
      				</div>
      				<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
					</script>
				</td>
		    </tr>
	    </table>

<%-- <table class="kk_table" width="914" height="40" style="margin-left: auto; margin-right: auto; text-align: center; border-collapse: collapse; border: 1px none rgb(0, 0, 0); font-size: 13px;  background-image: none; word-break: break-all; overflow-wrap: break-word;">
   <tbody>
      <tr>
         <td style="vertical-align: middle; width: 4px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;" width="4" rowspan="1" colspan=""><p style="text-align: center; "><span style="font-family: &quot;맑은 고딕&quot;"><span style="font-size: 26px;"><br></span></span></p></td>
         <td style="vertical-align: middle; width: 306px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;"
          width="306" rowspan="1" colspan=""><p style="font-family: 'malgun gothic'; font-size:25px;  text-align: center;"><span style="text-align:center; font-size: 26px;">차 량 운 행 기 록 일 지</span></p></td>
         <td style="vertical-align: middle; width: 92px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;"
          width="92"><p style="text-align: right; font-family: 'malgun gothic'; font-size:25px; "><span style="font-size: 26px;">( 차종 :</span></p></td>
         <td style="vertical-align: middle; width: 111px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); text-align: center;"
          width="111" colspan="">
             <input type="text" name="Brd_NM" id="Brd_NM" idval="${car_name}" title = "<c:out value='${car_name}' />" value="<c:out value='${car_name}' />" style="text-overflow:ellipsis; background-color:transparent; border:0; width: 100%; font-family: 'malgun gothic'; text-align: center; font-size:20px;" maxlength="500" disabled>
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
									<span style="text-align: center; font-size: 26px;"><spring:message code='ezCar.shb18' /><c:out value='${car_name}' /> <spring:message code='ezCar.shb19' /><c:out value='${car_nm}' />   )</span>
								</p></td>
							
						</tr>
					</tbody>
				</table>
   
<table width="1700" height="40" class="kk_table"
					style="border: 1px rgb(0, 0, 0); border-image: none; font-size: 13px; border-collapse: collapse; -ms-word-break: break-all; background-image: none; overflow-wrap: break-word;">
					<tbody>
						<tr style="height: auto;">
							<td width="81" height="21"
								style="padding-left: 10px; border: 0px solid rgb(0, 0, 0); border-image: none; width: 81px; height: 21px; vertical-align: middle;" colspan="8"><p
									style="">
									<span style='font-family: "맑은 고딕";'><spring:message code='ezCar.shb20' /><c:out value='${ownerName}'/> ( ${ownerCall} )</span>
								</p></td>
		
						</tr>
						<tr>
						<td colspan="4"
								style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 363px; height: 19px; color: red; vertical-align: middle;">
								&nbsp&nbsp <spring:message code='ezCar.shb21' /></td>
						</tr>
						<tr>
							<td colspan="4"
								style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 300px; height: 19px; color: red; vertical-align: middle;">
								&nbsp&nbsp <spring:message code='ezCar.shb22' /></td>
								<td rowspan="1" colspan="1"
								style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 300px; height: 19px; color: red; vertical-align: middle;">
								</td>
								<td rowspan="1" colspan="1"
								style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 300px; height: 19px; color: red; vertical-align: middle;">
								</td>
								<td rowspan="1" colspan="1"
								style="border: 0px solid rgb(0, 0, 0); border-image: none; width: 300px; height: 19px; vertical-align: middle;">
								<p style="text-align: right;"><spring:message code='ezCar.shb23' /></p></td>
							</tr>
					</tbody>
				</table> 
	<!-- <form id="carForm" name="carForm" method="post" onsubmit="return check()" action="/ezCar/addCarForm.do"> -->
				<div style="width: 100%; height: 580px; overflow-y: auto;">
					<form id="carForm" name="carForm" method="post"
						onsubmit="return false;" action="/ezCar/modifyCarForm.do">
						<table class="kk_table" id="testTb" width="1700" height="" style="word-break: break-all; overflow-wrap: break-word; border-collapse: collapse; border: 1px none rgb(0, 0, 0); font-size: 13px; background-image: none; width: 1700px; height: ;">
	<tbody class="test1">
		<tr style="height: auto;">
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 37px; width: 31px;" height="37" width="31" rowspan="3" colspan="1"><p style="text-align: center;"><br></p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 37px; width: 645px;" height="37" width="645" rowspan="1"
			 colspan="8"><p style="text-align: center;"><span style="font-weight: 700; text-align: center;"><spring:message code='ezCar.shb24' /></span></p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 860px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 37px;"
			 height="37" width="860" rowspan="1" colspan="9"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb25' /></span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 97px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 92px;"
			 colspan="2" width="97" height="92" rowspan="3"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb26' /></span> </p>
			
				<p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb27' /></span> </p></td>
		</tr>
		<tr style="height: auto;">
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px; width: 111px;" rowspan="2" width="111" height="55" colspan="1"><p><span style="font-weight: 700;"><spring:message code='ezCar.shb28' /><sup style="font-size: 15px; color:red;">*</sup></span></p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 124px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 rowspan="2" width="124" height="55" colspan="3"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb29' /><sup style="font-size: 15px; color:red;">*</sup></span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 133px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 rowspan="2" width="133" height="55"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb30' /><sup style="font-size: 15px; color:red;">*</sup></span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 66px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 rowspan="2" width="66" height="55"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb31' /><sup style="font-size: 15px; color:red;">*</sup></span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 62px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 rowspan="2" width="62" height="55"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb32' /></span> </p>
			
				<p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb33' /></span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 98px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 rowspan="2" width="98" height="55"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb34' /></span> </p>
			
				<p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb35' /></span> </p>
			
				<p style="text-align: center;"> <span style="font-weight: bold;">(km)</span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 184px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 rowspan="2" width="184" height="55"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb36' /></span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 157px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 rowspan="2" width="157" height="55"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb37' /></span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 58px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 rowspan="2" width="58" height="55"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb32' /></span> </p>
			
				<p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb38' /></span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 76px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 rowspan="2" width="76" height="55"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb39' /></span> </p>
			
				<p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code='ezCar.shb35' /></span> </p>
			
				<p style="text-align: center;"> <span style="font-weight: bold;">(km)</span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 77px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 colspan="" width="77" rowspan="2" height="55"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code="ezCar.shb77"/></span> </p>
			
				<p style="text-align: center;"> <span style="font-weight: bold;">(Km)</span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 110px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 33.5px; text-align: center;"
			 colspan="2" width="110" height="33.5" rowspan="1"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code="ezCar.shb40"/>&nbsp;</span><span style="font-weight: bold; font-family: inherit;"><spring:message code="ezCar.shb41"/>(km)</span> </p></td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 67px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; height: 55px;"
			 colspan="2" width="67" rowspan="2" height="55"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code="ezCar.shb42"/>&nbsp;</span><span style="font-weight: bold; font-family: inherit;"><spring:message code="ezCar.shb43"/>&nbsp;</span> </p>
			
				<p style="text-align: center;"> <span style="font-weight: bold; font-family: inherit;"><spring:message code="ezCar.shb44"/>(km)</span> </p></td>
		</tr>
     <tr style="height: auto;">
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 7px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 21px; text-align: center;" colspan="" width="7" height="21"> <p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code="ezCar.shb45"/></span> </p>
			
			</td>
			<td style="background-color: rgb(241, 243, 245); vertical-align: middle; width: 0px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); height: 21px; text-align: center;" colspan="" width="-9" rowspan="1" height="21"><p style="text-align: center;"> <span style="font-weight: bold;"><spring:message code="ezCar.shb46"/></span> </p></td>
		</tr>
      
      <c:if test="${!empty carFormList}" >
			<c:forEach var="list"  items="${carFormList}" varStatus="value">
			
	  		
	  				<tr style="height: auto;">
	  				<td style="vertical-align: middle; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center; width: 25px;" width="25" colspan="1">
					<input type="checkbox" id="chk_${value.count}" name="chkbox" style="width: 20px; text-align: center" value="">
					</td>
			
	    			<td style="vertical-align: middle; width: 119px; border-width: 1px; border-style: solid; border-color: #dedede; text-align: center;" width="119">
	    			<input type="text" id="Sdatepicker_${value.count}" name="Sdatepicker" style="width:80px;text-align:center" readonly="readonly" value="${list.rev_date}" class="Sdate">
	    			</td>
	    			
	    			<td style="vertical-align: middle; width: 48px; border-width: 1px 0px 1px 1px; border-style: solid; border-color: rgb(222, 222, 222) rgb(0, 0, 0) rgb(222, 222, 222) rgb(222, 222, 222); text-align: center;" width="48">
	    			<input id="Stimepicker_${value.count}" readonly="readonly" type="text" name="Stimepicker" class="Stime" style="vertical-align: middle; width:43px; text-align:center" value="${list.rev_time}">
					</td>
					
         			<td style="vertical-align: middle; width: 14px; border-width: 1px 0px; border-style: solid; border-color: rgb(222, 222, 222) rgb(0, 0, 0); text-align: center; background-image: none;" width="14" colspan=""><p><span>~</span></p></td>
         			<td style="vertical-align: middle; width: 53px; border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(222, 222, 222) rgb(222, 222, 222) rgb(222, 222, 222) rgb(0, 0, 0); text-align: center;" width="53" colspan="">
            		<input id="Etimepicker_${value.count}" readonly="readonly" type="text" name="Etimepicker" class="Stime" style="width:43px; vertical-align: middle; text-align:center" value="${list.rev_time2}">
         			</td>
         
         			<td style="vertical-align: middle; width: 133px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="133">
            		<input type="text" id="driverdeptname_${value.count}" name="driverdeptname" style="text-align: center; width: 150px; border:0;" value="${list.driver_deptname}">
         			</td>
         
         			<td style="vertical-align: middle; width: 66px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="66">
            		<input type="text" id="dirvername_${value.count}" name="dirvername" style="text-align: center; width: 80px; border:0;" value="${list.driver_name}">
         			</td>
         
         			<td style="vertical-align: middle; width: 62px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="62">
            		<input id="S2timepicker_${value.count}" readonly="readonly" type="text" name="S2timepicker" class="Stime" style="width:43px; vertical-align: middle; text-align:center" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"
             		autocomplete="off" value="${list.b_depart_time}">
			        </td>
			        
         			<td style="vertical-align: middle; width: 98px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="98">
            		<input type="number" id="bdistance_${value.count}" name="bdistance" oninput="call(this.id)"  maxlength="8" onkeypress="txtOnlyNum(event);" 
onkeyup="this.value=this.value.replace(/[^0-9]/g,''); maxLengthCheck(this);" style="IME-MODE: disabled; text-align: center; width: 100px; border:0;" value="${list.b_distance}" class="clacA">
         			</td>
         
         			<td style="vertical-align: middle; width: 184px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="184"><textarea id="drivepurpose_${value.count}" name="drivepurpose" style="text-align: center; width: 90%; border: 0;" onkeydown="resize(this)" onkeyup="resize(this)">${list.drive_purpose}</textarea></td>
           			
	         		</td>
	         		
         			<td style="vertical-align: middle; width: 157px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="157">
            		<input type="text" id="drivepoint_${value.count}" name="drivepoint" style="text-align: center; width: 150px; border:0;" value="${list.drive_point}">
         			</td>
         			
         			<td style="vertical-align: middle; width: 58px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="58">
            		<input id="S3timepicker_${value.count}" readonly="readonly" type="text" name="S3timepicker" class="Stime" style="width:43px; vertical-align: middle; text-align:center" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"
             		autocomplete="off" value="${list.a_arrive_time}">
         			</td>
         
         			<td style="vertical-align: middle; width: 76px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" width="76">
            		<input type="number" id="adistance_${value.count}" name="adistance" onkeyup="maxLengthCheck(this)" maxlength="8" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.a_distance}" class="calcB">
	         		</td>
         			
         			<td style="vertical-align: middle; width: 77px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" colspan="" width="77">
            		<input type="number" id="adistanceauto_${value.count}" name="adistanceauto" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.a_distance_auto}" class="calcC"  >
         			</td>
         
         			<td style="vertical-align: middle; width: 7px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" colspan="" width="7">
            		<input type="number" id="adistancecommute_${value.count}" name="adistancecommute" onkeyup="maxLengthCheck(this)" maxlength="4" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.a_distance_commute}">
         			</td>
         			
         			<td style="vertical-align: middle; width: 0px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" colspan="" width="-9">
            		<input type="number" id="adistancework_${value.count}" name="adistancework" onkeyup="maxLengthCheck(this)" maxlength="4" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.a_distance_work}">
         			</td>
         
         			<td style="vertical-align: middle; width: 67px; border-width: 1px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;" colspan="2" width="67" rowspan="1">
            		<input type="number" id="adistanceetc_${value.count}" name="adistanceetc" oninput="call(this.id)" style="text-align: center; width: 100px; border:0;" value="${list.a_distance_etc}"  >
         			</td>
         			
         			<c:if test="${list.a_submit_flag == 1}" >
         			<td style="vertical-align: middle; width: 48px; border-width: 1px 0px 1px 1px; border-style: solid; border-color: rgb(222, 222, 222); background-image: none; text-align: center;" colspan="" width="48"><p style="text-align: center;"> 
         			<input type="radio" name="control_${value.count}" checked="checked" onclick="radioClickY(event)" id="Ycontrol_${value.count}" style="">&nbsp;<span style="font-family: &quot;맑은 고딕&quot;">Y</span></p></td>
         			<td style="vertical-align: middle; width: 43px; border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;"
          			colspan="" width="43"><p style="text-align: left;">  
          			<input type="radio" name="control_${value.count}" onclick="radioClickN(event)" id="Ncontrol_${value.count}" style="">&nbsp;<span style="font-family: &quot;맑은 고딕&quot;">N</span></p></td>
					</c:if>
					<c:if test="${list.a_submit_flag == 0}" >
					<td style="vertical-align: middle; width: 48px; border-width: 1px 0px 1px 1px; border-style: solid; border-color: rgb(222, 222, 222); background-image: none; text-align: center;" colspan="" width="48"><p style="text-align: center;"> 
         			<input type="radio" name="control_${value.count}" onclick="radioClickY(event)" id="Ycontrol_${value.count}" style="">&nbsp;<span style="font-family: &quot;맑은 고딕&quot;">Y</span></p></td>
         			<td style="vertical-align: middle; width: 43px; border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(222, 222, 222); text-align: center;"
          			colspan="" width="43"><p style="text-align: left;">  
          			<input type="radio" name="control_${value.count}" checked="checked" onclick="radioClickN(event)" id="Ncontrol_${value.count}" style="">&nbsp;<span style="font-family: &quot;맑은 고딕&quot;">N</span></p></td>
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
      <input type="hidden" name="car_form_id" id="car_form_id" value="">
      <input type="hidden" name="indexing" id="indexing" value=""> 
</form>
</div>

<table class="kk_table" width="1700" height="40" style="word-break: break-all; overflow-wrap: break-word; border-collapse: collapse; border: 1px none rgb(0, 0, 0); font-size: 13px; ">
   <tbody>
      <tr style="height: auto;">
         <td style="vertical-align: middle; width: 1386px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); background-image: none; height: 11px;" width="1386" height="11"><p><br></p></td>
         <td style="vertical-align: middle; width: 48px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); background-image: none; height: 11px;" width="48" height="11" rowspan="1"><p style="text-align: center; "> 
         <input type="button" onclick="addBtn();" value="<spring:message code='ezCar.shb47'/>" id="control13" style=""></p></td>
         <td style="vertical-align: middle; width: 38px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); background-image: none; height: 11px;"
          width="38" height="11" rowspan="1"><p style="text-align: center;">
          <input type="button" onclick="deleteBtn();"value="<spring:message code='ezCar.shb48'/>" id="control14" style=""></p></td>
      </tr>
      <tr style="height: auto;">
         <td style="vertical-align: middle; width: 1386px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); background-image: none; height: 22.5px;" width="1386" height="22.5"><p><span style="font-size: 12px;"><spring:message code="ezCar.shb49"/></span></p><p><span style="white-space: pre; font-size: 12px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
         <span style="font-size: 12px;">&nbsp;&nbsp;<spring:message code="ezCar.shb50"/></span></p><p></p><p><span style="font-size: 12px;"><spring:message code="ezCar.shb51"/></span></p></td>
         <td
          style="vertical-align: middle; width: 48px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); background-image: none; height: 18px;" width="48" height="18" rowspan="1"><p><span><br></span></p></td>
            <td style="vertical-align: middle; width: 38px; border-width: 0px; border-style: solid; border-color: rgb(0, 0, 0); background-image: none; height: 18px;" width="38" height="18" rowspan="1"><p><span><br></span></p></td>
      </tr>
   </tbody>
</table>
   </body>
</html>