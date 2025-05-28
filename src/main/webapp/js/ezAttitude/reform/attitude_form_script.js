function startEndTimeCheck(id, selectYear, selectMonth, selectDay) {
	var returnVal = true;
	selectMonth = (Number(selectMonth) + 1) + "";
	if (selectMonth.length == 1) {
		selectMonth = "0" + selectMonth;
	}
	selectDay = selectDay + "";
	if (selectDay.length == 1) {
		selectDay = "0" + selectDay;
	}
	if (Number(id.split("#date")[1]) % 2 != 0) {
		var tempDate1 = new Date(selectYear + "-" + selectMonth + "-" + selectDay);
        $("#date" + (Number(id.split("#date")[1]) + 1)).datepicker('setDate', tempDate1);
        returnVal = true;
	} else {
		var tempDate1 = new Date(document.getElementById("date" + (Number(id.split("#date")[1]) - 1)).value).getTime();
		var tempDate2 = new Date(selectYear + "-" + selectMonth + "-" + selectDay).getTime();
		if (tempDate1 > tempDate2) {
			returnVal = false;
		}
	}
	return returnVal;
}

function mobileKeyUp(mobileId) {
   $('#p_' + mobileId).text($('#' + mobileId).val());
}

function selectChange(contID) {
    $('#' + contID).attr("attitudeType", $('#' + contID).val());
   $('#' + contID + ' option').not('option[value=' + $('#' + contID).val() + "]").attr("selected", false);
    $('#' + contID + ' option[value=' + $('#' + contID).val() + "]").attr("selected","");
	eval($('#' + contID).prev("input[id^=reform-title]").attr("viewer-listener"));
   setDocTitle($('#' + contID));
}

function getHolidayCnt(startDate, endDate, isAjax) {
   var returnCnt = 0;
   if (isAjax) {
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
            returnCnt = Number(result.length);
         },
         error : function(jqXHR, textStatus, errorThrown) {
            alert("에러발생! " + jqXHR.status + ", " + jqXHR.readyState);
         }
      })
   } else {
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
         
          for (var j = 0; j < disabledDays.length; j++) { 
            if($.inArray(year + '-' + month + '-' + date,disabledDays) != -1) { 
               returnCnt++;
               break;
            } 
         }
      }
   }
   return returnCnt;
}

function disableSomeDay(calDate) {
   var month = (calDate.getMonth() + 1) + "";
   var date = calDate.getDate() + "";
   var year = calDate.getFullYear();
   if(month.length == 1) {
      month = "0" + month;
   }
   if(date.length == 1) {
      date = "0" + date;
   }
   
    for (i = 0; i < disabledDays.length; i++) { 
        if($.inArray(year + '-' + month + '-' + date,disabledDays) != -1) { 
          return [false]; 
       } 
    }   
    return [true]; 
}

var disabledDays = new Array();
function getDisabledDays(searchYear, searchMonth) {
   searchMonth = searchMonth + "";
   if (searchMonth.length == 1) {
      searchMonth = "0" + searchMonth;
   }
   $.ajax({
      type:"GET",
      dataType : "json",
                async : false,
      url : "/ezAttitude/getHoliDays.do",
      data : {
         year : searchYear,
         month : searchMonth
      },
      success : function(result) {
         disabledDays = [];
         result.forEach(function(resultDateStr, index) {
            disabledDays.push(resultDateStr);
         })
      },
      error : function(jqXHR, textStatus, errorThrown) {
         alert("에러발생! " + jqXHR.status + ", " + jqXHR.readyState);
      }
   })
}

function attitude_annual_conn(formType, status) {
   if (formType === "annual" && status === "0") { //휴가계 기안
      var docId = parent.parent.pDocID;
      var attitudeTypeList = "";
      var startDateList = "";
      var endDateList = "";
      var startTimeList = "";
      var endTimeList = "";
      
      $("input[id^=date]").each(function() {
         var number = Number($(this).attr("id").split("date")[1]);
         //홀수는 시작 날짜, 짝수는 끝 날짜
         if (number % 2 != 0) {//시작날짜(홀수)
            startDateList += $("#date" + number).val() + ",";
         } else { //끝날짜(짝수)
            endDateList += $("#date" + number).val() + ",";
         }
      })
      
      
      startDateList = startDateList.slice(0,-1);
      endDateList = endDateList.slice(0,-1);
      
      $("select[id^=control]").each(function() {
         attitudeTypeList += $(this).val() + ",";
      })
      attitudeTypeList = attitudeTypeList.slice(0,-1);
      
//2020-03-12 김정언
      if(attitudeTypeList === "A21"){
    	  $("input[id^=time]").each(function() {
    		  var number = Number($(this).attr("id").split("time")[1]);
    		  //홀수는 시작 날짜, 짝수는 끝 날짜
    		  if (number % 2 != 0) {//시작날짜(홀수)
    			  startTimeList += $("#time" + number).val() + ",";
    		  } else { //끝날짜(짝수)
    			  endTimeList += $("#time" + number).val() + ",";
    		  }
    	  })
    	  
    	  startTimeList = startTimeList.slice(0,-1);
    	  endTimeList = endTimeList.slice(0,-1);
      }
      
      $.ajax({
         type:"POST",
         dataType : "json",
         async : false,
         url : "/ezAttitude/approvalGConn.do",
         data : {
            docId : docId,
            attitudeTypeList : attitudeTypeList,
            startDateList : startDateList,
            endDateList : endDateList,
            startTimeList : startTimeList,
            endTimeList : endTimeList,
            mobile : $('#mobile').val(),
            content : iframe_content_reform.GetEditorContent().replace(/(\s+)|(\s+)/gi, " "),
            formType : "annual",
            status : "0"
         },
         success : function(result) {
         
         },
         error : function() {
         
         }
      });
   }
}

function setAdditional(mdate1, mdate2, mcontrol, mdateadditional) {
   var tempDate1 = new Date(document.getElementById(mdate1).value).getTime();
   var tempDate2 = new Date(document.getElementById(mdate2).value).getTime();
   var controlVal = (document.getElementById(mcontrol).value == 'A12' || 
                  document.getElementById(mcontrol).value == 'A13' || 
                  document.getElementById(mcontrol).value == 'A15' || 
                  document.getElementById(mcontrol).value == 'A16') ? 2 : (document.getElementById(mcontrol).value == 'A21' ? 4 : 1);
   var holidayCnt = 0;
   if (annualDateResult == "") {
	   annualDateResult = document.getElementById(mdate1).value.split("-")[0] + " 년 " + document.getElementById(mdate1).value.split("-")[1] + " 월 " + document.getElementById(mdate1).value.split("-")[2] + " 일 ~ " + document.getElementById(mdate2).value.split("-")[0] + " 년 " + document.getElementById(mdate2).value.split("-")[1] + " 월 " + document.getElementById(mdate2).value.split("-")[2] + " 일";
   }
   
   if (document.getElementById(mcontrol).value == 'A18') { //산휴		  
	   tempDate2 = new Date(document.getElementById(mdate1).value);
	   tempDate2.setDate(tempDate2.getDate() + 89);
	   holidayCnt = getHolidayCnt(document.getElementById(mdate1).value, tempDate2.getFullYear() + "-" + ((tempDate2.getMonth() + 1).toString().length == 1 ? "0" + (tempDate2.getMonth() + 1) : (tempDate2.getMonth() + 1)) + "-" +  (tempDate2.getDate().toString().length == 1 ? "0" + tempDate2.getDate() : tempDate2.getDate()), true);
	      
	   
	   var addCnt = holidayCnt;
	   if (addCnt > 0) {
		   var sanhyuTempDate = new Date(document.getElementById(mdate1).value);
		   sanhyuTempDate.setDate(sanhyuTempDate.getDate() + 89);
		   while (true) {
			   sanhyuTempDate.setDate(sanhyuTempDate.getDate() + addCnt);
			   holidayCnt = getHolidayCnt(document.getElementById(mdate1).value, sanhyuTempDate.getFullYear() + "-" + ((sanhyuTempDate.getMonth() + 1).toString().length == 1 ? "0" + (sanhyuTempDate.getMonth() + 1) : (sanhyuTempDate.getMonth() + 1)) + "-" +  (sanhyuTempDate.getDate().toString().length == 1 ? "0" + sanhyuTempDate.getDate() : sanhyuTempDate.getDate()), true);
			   if((Math.ceil(((sanhyuTempDate.getTime() - tempDate1) + 1) / 86400000) - holidayCnt) == 90) {
				   tempDate2 = sanhyuTempDate;
				   break;
			   }
			   addCnt = (90 - (Math.ceil(((sanhyuTempDate.getTime() - tempDate1) + 1) / 86400000) - holidayCnt));
		   }
	   }
	   
	   document.getElementById(mdate2).value = tempDate2.getFullYear() + "-" + ((tempDate2.getMonth() + 1).toString().length == 1 ? "0" + (tempDate2.getMonth() + 1) : (tempDate2.getMonth() + 1)) + "-" +  (tempDate2.getDate().toString().length == 1 ? "0" + tempDate2.getDate() : tempDate2.getDate());
	   annualDateResult = annualDateResult.split("~")[0] + "~ " + tempDate2.getFullYear() + " 년 " + ((tempDate2.getMonth() + 1).toString().length == 1 ? "0" + (tempDate2.getMonth() + 1) : (tempDate2.getMonth() + 1)) + " 월 " + (tempDate2.getDate().toString().length == 1 ? "0" + tempDate2.getDate() : tempDate2.getDate()) + " 일";
	   tempDate2 = tempDate2.getTime();
   } else {
	   if (tempDate1 <= tempDate2) {
		   if (disabledDays.length > 0 && (document.getElementById(mdate1).value.substr(0,7) == document.getElementById(mdate2).value.substr(0,7)) && (disabledDays[0].substr(0,7) == document.getElementById(mdate1).value.substr(0,7))) {
			   holidayCnt = getHolidayCnt(document.getElementById(mdate1).value, document.getElementById(mdate2).value, false);
		   } else {
			   holidayCnt = getHolidayCnt(document.getElementById(mdate1).value, document.getElementById(mdate2).value, true);
		   }
	   }		   
   }
   
   var differencesTime = tempDate2 - tempDate1;
   var additional = '';
   if (differencesTime >= 0) {
      var day = Math.ceil((differencesTime + 1) / 86400000) - holidayCnt;
      additional += ' [ ' + (day / controlVal) + ' 일 ]';
      annualDateResult += additional;
   }
   document.getElementById(mdateadditional).innerHTML = additional;
   
   $('#' + mdate1).attr('value',$('#' + mdate1).val());
   $('#' + mdate2).attr('value',$('#' + mdate2).val());
}


var annualGnrtStd = "";
var initialDate = "";
var joinDate = "";
var useMinusAnnual = "";
var holiDays = new Array();
function setAnnualCntInfo() {
   $.ajax({
      type : "GET",
      url : "/ezAttitude/getAnnualreg.do",
      dataType : "json",
      success : function(result) {
         annualGnrtStd = result.annualconfig.annualGnrtStd;
         initialDate = result.annualconfig.initialDate;
         joinDate = result.joinDate;
         useMinusAnnual = result.annualconfig.useMinusAnnual;//1:허용 0:허용안함
         setAnnualCntInfo_complete();
      },
      error : function() {
         alert("<spring:message code='ezAttitude.t175' />");
      }
   });   
}

function setAnnualCntInfo_complete() {
	
	var mDate = new Date()
	var mYear = mDate.getFullYear(); //현재년도
	var todayMonth = (mDate.getMonth() + 1); //현재월
	var todayDate = mDate.getDate(); //현재일
	var paramStartDate = "";
	var paramEndDate = "";
	var secondYear = "N";
	if(joinDate == null || joinDate == "" || joinDate == "0") {
		joinDate = "0000-01-01";
	}
	if (annualGnrtStd == 1) {
		if(initialDate.substring(5, 7) < todayMonth || (initialDate.substring(5, 7) == todayMonth && initialDate.substring(8, 10) < todayDate)) {
			paramStartDate = mYear + "-" + initialDate.substring(5, 10);
			paramEndDate = caldate(new Date(mYear + 1, initialDate.substring(5, 7) - 1, initialDate.substring(8, 10)), 1);
		} else {
			paramStartDate = (mYear - 1) + "-" + initialDate.substring(5, 10);
			paramEndDate = caldate(new Date(mYear, initialDate.substring(5, 7) - 1, initialDate.substring(8, 10)), 1);
		}
	} else {
		if(joinDate.substring(5, 7) < todayMonth || (joinDate.substring(5, 7) == todayMonth && joinDate.substring(8, 10) < todayDate)) {
			paramStartDate = mYear + "-" + joinDate.substring(5, 10);
			paramEndDate = caldate(new Date(mYear + 1, joinDate.substring(5, 7) - 1, joinDate.substring(8, 10)), 1);
		} else {
			paramStartDate = (mYear - 1) + "-" + joinDate.substring(5, 10);
    	    paramEndDate = caldate(new Date(mYear, joinDate.substring(5, 7) - 1, joinDate.substring(8, 10)), 1);
        }
    }
   
    var startYear = paramStartDate.substring(0, 4);
    var joinYear = joinDate.substring(0, 4);
    			
    var startDate2 = new Date(paramStartDate);
    var endDate2 = new Date(paramEndDate);
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
         	startDate : paramStartDate,
         	endDate : paramEndDate
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
    	type : "GET",
    	url : "/ezAttitude/getUserAnnualList.do",
    	dataType : "json",
    	data : {
    		"startDate" : paramStartDate,
    		"endDate" : paramEndDate,
    		"secondYear" : secondYear
    	},
    	success : function(result) {
    		var totalAnnualCnt = 0;
    		var accumCnt = 0;
    		if (Number(result.list[0].totalAnnualCnt.split(".")[1]) > 0) {
    			totalAnnualCnt = result.list[0].totalAnnualCnt;
    		} else {
    			totalAnnualCnt = result.list[0].totalAnnualCnt.split(".")[0];
    		}
    	 
    		if (Number(result.list[0].annualCnt) > 0) {
    			result.list.forEach(function(vo, index) {
    				var holidayCnt = 0;
	    			if(vo.endDate != null) {
		    			holidayCnt = getHolidays(vo.startDate.substr(0,10), vo.endDate.substr(0,10));
	    			}
	    			var useAnnualCnt = (Number(vo.annualCnt) - holidayCnt);
		    		
	    			//누적 연차 수
	    			accumCnt += useAnnualCnt;
    			});
    		}
    		$("#total_annual_cnt").text(totalAnnualCnt);
    		$("#accum_annual_cnt").text(accumCnt);
    		$("#remain_annual_cnt").text(totalAnnualCnt - accumCnt - 1);
    	},
    	error : function() {
    		alert("<spring:message code='ezAttitude.t175' />");
    	}
    });   
}

function getHolidays(startDate, endDate) {
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

//실제 상위 프레임의 doctitle에 값 적용
function setDocTitle(element) {
	if (event) {
		if(event.keyCode == 9 || event.keyCode == 13 ||event.keyCode == 37 || event.keyCode == 38 || event.keyCode == 39 || event.keyCode == 40) {
    	   	return;
       	}
	}
   $("#cursorStartPosition").val(element.selectionStart);
   $("#cursorEndPosition").val(element.selectionEnd);

	var regStr = /(\d{4})-(\d{1,2})-(\d{1,2})/;
   var startDate = "";
   var endDate = "";
   var totalNight = 0;
   var totalDay = 0;
   var useAnnualCnt = 0;
   var isContinue = true;

   $("input[id^=reform-title]").not("input[type=checkbox]").each(function() {
	        if (startDate == "") {
	            startDate = $("#" + this.getAttribute('viewer').split(",")[0]).val();
	        } else {
	            if (startDate.split("-")[0] + "-" + (startDate.split("-")[1].length == 1 ? "0" + startDate.split("-")[1] : startDate.split("-")[1]) + "-" 
			 + (startDate.split("-")[2].length == 1 ? "0" + startDate.split("-")[2] : startDate.split("-")[2]) > $("#" + this.getAttribute('viewer').split(",")[0]).val()) {
	                startDate = $("#" + this.getAttribute('viewer').split(",")[0]).val();
	            }
	        }
	        if (endDate == "") {
	            endDate = $("#" + this.getAttribute('viewer').split(",")[1]).val();
	        } else {
	            if (endDate.split("-")[0] + "-" + (endDate.split("-")[1].length == 1 ? "0" + endDate.split("-")[1] : endDate.split("-")[1]) + "-" 
			 + (endDate.split("-")[2].length == 1 ? "0" + endDate.split("-")[2] : endDate.split("-")[2]) < $("#" + this.getAttribute('viewer').split(",")[1]).val()) {
	                endDate = $("#" + this.getAttribute('viewer').split(",")[1]).val();
	            }
	        }
	        
	        var attitudeType = $(this).siblings("select").val() == null ? "A12" : $(this).siblings("select").val();
            
	        //2020-03-10 김정언 - 반반차
	        halfOff(attitudeType, $(this).attr("viewer"), $(this).attr("id"));
			var addAnnualCnt = (attitudeType == "" || attitudeType == "A11" || attitudeType == "A12" || attitudeType == "A13" || attitudeType == "A21") ? true : false;
			var dateAdditionalId = $(this).attr("viewer-listener").substring($(this).attr("viewer-listener").lastIndexOf(',')+2,$(this).attr("viewer-listener").lastIndexOf('"'));
			 			
			totalDay = totalDay + Number($("#" + dateAdditionalId).text().trim().substr($("#" + dateAdditionalId).text().trim().indexOf("[")+1, $("#" + dateAdditionalId).text().trim().indexOf("일")-1).trim());
			if (addAnnualCnt) {
			   useAnnualCnt = useAnnualCnt + Number($("#" + dateAdditionalId).text().trim().substr($("#" + dateAdditionalId).text().trim().indexOf("[")+1, $("#" + dateAdditionalId).text().trim().indexOf("일")-1).trim());
		    }
   })
   
   if (isContinue) {	   
	   var totalTitle = startDate.split("-")[0] + " 년 " + startDate.split("-")[1] + " 월 " + startDate.split("-")[2] + " 일 ~ " + endDate.split("-")[0] + " 년 " + endDate.split("-")[1] + " 월 " + endDate.split("-")[2] + " 일 [ " + totalDay + " 일 ]";
	   
	   $("#totalAnnualDateTD").text(totalTitle)
	   $("#totalAnnualDate").val(totalTitle);
	   $("#totalAnnualDate").attr("type","hidden");
	   
	   $("#use_annual_cnt").text(useAnnualCnt);
	   $("#remain_annual_cnt").text(Number($("#total_annual_cnt").text()) - Number($("#accum_annual_cnt").text()) - useAnnualCnt);
	   
	   try {
		   parent.document.getElementById("doctitle").innerHTML = totalTitle;
	   } catch (ex) {}   
   }

   var sPosition = $("#cursorStartPosition").val();
   var ePosition = $("#cursorEndPosition").val();
   element.focus();
   element.setSelectionRange(sPosition,ePosition);
}

//휴가 selectBox 리스트
function vacationSelectInfo(contId) {
      var companyId = window.parent.parent.pCompanyID;

      $.ajax({
         type : "GET",
         url : "/admin/ezAttitude/attitudeTypeConfigInfo.do",
         dataType : "json",
         data : {companyId : companyId, isuse : "1"},
         success : function(result) {
            var htmlStr = "";
            
            result.forEach(function(vo, index) {
               htmlStr += "<option value='" + vo.typeId + "'>" + vo.typeName + "</option>";            
            })
            $("#" + contId).html(htmlStr);
            $("#" + contId).children().eq(0).attr("selected","");
            $("#" + contId).attr("attitudetype",$("#" + contId).children().eq(0).val());
            
         },
         error : function() {
            alert("<spring:message code='ezAttitude.t175' />");
         }
      });   
}


//minus버튼 함수
function minusBtnClick(trId) {
   var trList = $("tr[id^=annualDataTr_]");
   if (trList.length <= 1) {
      alert("휴가 일정이 한 개 이상 존재해야 합니다.");
      return;
   }

   $("#" + trId).remove();
   
   if ($("#annualDataTitleTd").length == 0) { 
      trList = $("tr[id^=annualDataTr_]");
      $("#" + trList[0].id).prepend("<td rowspan='" + trList.length + "' bgcolor='#edf3f8' id='annualDataTitleTd' style='vertical-align: middle; width: 114px; border-width: 1px; border-style: solid; border-color: rgb(0, 0, 0);' width='114'><p>휴 가 기 간</p></td>")
   } else {
      var rowspan = Number($("#annualDataTitleTd").attr("rowspan"));
      $("#annualDataTitleTd").attr("rowspan", rowspan - 1);
   }
}

//plus버튼 함수
function plusBtnClick(trId) {
   var nextContID = Number($("#__reform_next_auto_id").attr("value"));   
   var controlID1 = "control" + nextContID++;
   var controlID2 = "control" + nextContID++;
   var controlID3 = "control" + nextContID++;
   
   $("#__reform_next_auto_id").attr("value", nextContID);

   var annualDataLength = Number($("#__reform_annual_data_length").attr("value")) + 1;
   $("#__reform_annual_data_length").attr("value", annualDataLength);
   var dateLength = Number($("#__reform_datapicker_length").attr("value")) + 1;
   $("#__reform_datapicker_length").attr("value",dateLength);
   var timeLength = Number($("#__reform_timepicker_length").attr("value")) + 1;
   $("#__reform_timepicker_length").attr("value",timeLength);

   str = "<tr id='annualDataTr_" + annualDataLength + "'>"
   + "<td id='annualDateTd_" + annualDataLength + "' align='center' colspan='14' ordertab='2' style='border-bottom: 1px solid black;border-right: 1px solid black;position: relative; height:30px;' valign='middle'>"
   + "<div id='reform-title-checkbox-div" + annualDataLength + "' style='position: absolute;display: none;top: 2px;left: 0;z-index: 2;'>"
   + "      <input id='reform-title-checkbox" + annualDataLength + "' onchange='' style='    box-sizing: border-box;    margin: 0 0 0 5px;    vertical-align: middle;' type='checkbox'>"
   + "      <label for='reform-title-checkbox" + annualDataLength + "' style='padding-right: 5px;font-family: 굴림;font-size: 11px;font-weight: bold;color: #666;'>직접 입력</label>"
   + "</div>"
   + "<div id='reform-date-title" + annualDataLength + "' style='position: absolute;display: none;width: 100%;height: 100%;top: 0;vertical-align: middle;z-index: 1;'>"
   + "      <table style='    height: 100%;    width: 100%;    border-collapse: collapse;'>"
   + "         <tbody>"
   + "            <tr>"
   + "               <td style='border: none; padding: 0;'>"
   + "                  <p style='margin-top: 0pt;margin-bottom: 0pt;font-family: 굴림;font-size: 13px;text-align: center;opacity: 1;height: 80%;'>"
   + "                     <input data-reform_date_picker_flag='1' data-reform_flag='1' data-reform_on_click='dateControlClick(&quot;date" + dateLength + "&quot;)' id='date" + dateLength + "' onclick='return reform_onClickHandler(event);' onkeyup='reform_onKeyUpHandler(event);' readonly='readonly' style='width: 145px; height: 100%; box-sizing: border-box; border: none; text-align: right; font-family: 굴림; font-size: 18px; color: transparent; background-color: transparent;' type='text' value='' viewer-args-build='{0} 년 {1} 월 {2} 일' viewer-args-regexp='/(&#92;d{4})-(&#92;d{1,2})-(&#92;d{1,2})/'>"
   + "                     <input data-reform_time_picker_flag='1' data-reform_flag='1' data-reform_on_click='timeControlClick(&quot;time" + timeLength + "&quot;)' id='time" + timeLength + "' onclick='return reform_onClickHandler(event);' onkeyup='reform_onKeyUpHandler(event);' style='display:none; width: 40px; height: 100%; box-sizing: border-box; border: none; text-align: center; font-family: 굴림; font-size: 16px; color: transparent; background-color: transparent;' type='text' value='' viewer-args-build=' {0} 시' viewer-args-regexp='/(&#92;d{2}):(&#92;d{2})/'>"
   + "                     <input data-reform_date_picker_flag='1' data-reform_flag='1' data-reform_on_click='dateControlClick(&quot;date" + (dateLength + 1) + "&quot;)' id='date" + (dateLength + 1) + "' onclick='return reform_onClickHandler(event);' onkeyup='reform_onKeyUpHandler(event);' readonly='readonly' style='width: 100px; height: 100%; box-sizing: border-box; border: none; text-align: center; font-family: 굴림; font-size: 18px; margin-left: 15px; color: transparent; background-color: transparent;' type='text' value='' viewer-args-build='{0} 년 {1} 월 {2} 일' viewer-args-regexp='/(&#92;d{4})-(&#92;d{1,2})-(&#92;d{1,2})/'>"
  + "                      <input data-reform_time_picker_flag='1' data-reform_flag='1' data-reform_on_click='timeControlClick(&quot;time" + (timeLength + 1) + "&quot;)' id='time" + (timeLength + 1) + "' onclick='return reform_onClickHandler(event);' onkeyup='reform_onKeyUpHandler(event);' style='display:none; width: 40px; height: 100%; box-sizing: border-box; border: none; text-align: center; font-family: 굴림; font-size: 16px; color: transparent; background-color: transparent;' type='text' value='' viewer-args-build=' {0} 시' viewer-args-regexp='/(&#92;d{2}):(&#92;d{2})/'>"
   + "                     <span id='date-additional" + annualDataLength + "' selectId='" + controlID1 + "' style='visibility: hidden;'> </span>"
   + "                  </p>"
   + "               </td>"
   + "            </tr>"
   + "         </tbody>"
   + "      </table>"
   + "</div>"
   + "<p style='margin-top: 0pt;margin-bottom: 0pt;font-family: 굴림;font-size: 13px;height: 100%;/* vertical-align: top; */padding-left: 20px;'>"
   + "<input data-reform_flag='1' data-reform_on_key_up='setDocTitle' id='reform-title" + annualDataLength + "' onclick='return reform_onClickHandler(event);' onkeyup='reform_onKeyUpHandler(event);' style='width: 83%; height: 100%; border: none; box-sizing: border-box; text-align: center; font-family: 굴림; font-size: 12px; letter-spacing: 0px; color: black; padding-left: 7px; background-color: transparent;' type='text' value='년  월  일 ~  년  월  일 [  일 ]' viewer='date" + dateLength + ",date" + (dateLength + 1) + ",time" + timeLength + ",time" + (timeLength +1 ) + "'   viewer-can-build='query(&quot;#reform-title-checkbox" + annualDataLength + "&quot;)[0].checked'   viewer-format='{0}{2} ~ {1}{3}' viewer-listener='setAdditional(&quot;date" + dateLength + "&quot;,&quot;date" + (dateLength + 1) +"&quot;,&quot;" + controlID1 + "&quot;,&quot;date-additional" + annualDataLength + "&quot;)'>"
   + "      <select data-reform_flag='1' data-reform_on_change='selectChange(&quot;" + controlID1 + "&quot;);' onchange='reformUseProc.defaultChangeHandler(this);' style='width: 65px; overflow: auto; position: absolute; left: 4px; top: 17px; z-index: 2;' size='0' id='" + controlID1 + "'>"
   + "      </select>"
   + "<input data-reform_flag='1' data-reform_on_click='minusBtnClick(&quot;annualDataTr_" + annualDataLength + "&quot;)' id='" + controlID2 + "' onclick='return reform_onClickHandler(event);' style='width: 16px;height: 16px;position: absolute;right: 27px;top: 17px;z-index: 2;padding: 0px;' type='button' value='-'>"
   + "<input data-reform_flag='1' data-reform_on_click='plusBtnClick(&quot;annualDataTr_" + annualDataLength + "&quot;)' id='" + controlID3 + "' onclick='return reform_onClickHandler(event);' style='width: 16px; height: 16px; position: absolute; right: 4px; top: 17px; padding: 0px; z-index: 2;' type='button' value='+'>"
   + "   </p>"
   + "</td>"
   + "</tr>";
$("#" + trId).after(str);

if (annualDataLength > 1) {
   var rowspan = Number($("#annualDataTitleTd").attr("rowspan"));
   $("#annualDataTitleTd").attr("rowspan", rowspan + 1);
} else {
   $("#annualDataTitleTd").attr("rowspan", 2);   
}

var dateListStr = $("#__reform_date_picker_list").attr("value");
dateListStr = dateListStr.split("]")[0];
dateListStr += ",\"date" + dateLength + "\",\"date" + (dateLength + 1) + "\"]";
$("#__reform_date_picker_list").attr("value", dateListStr);

var timeListStr = $("#__reform_time_picker_list").attr("value");
timeListStr = timeListStr.split("]")[0];
timeListStr += ",\"time" + timeLength + "\",\"time" + (timeLength + 1) + "\"]";
$("#__reform_time_picker_list").attr("value", timeListStr);

var noDataBoundListStr = $("#__reform_no_data_bound_control_list").attr("value");
noDataBoundListStr = noDataBoundListStr.split("]")[0];
noDataBoundListStr += ",\"reform-title" + annualDataLength + "\",\"date" + dateLength + "\",\"date" + (dateLength + 1)
   + "\",\"" + controlID1 + "\",\"" + controlID2 + "\",\"" + controlID3 + "\"]";
$("#__reform_no_data_bound_control_list").attr("value", noDataBoundListStr);


var controlListStr = $("#__reform_control_list").attr("value");
controlListStr = controlListStr.split("]")[0];
controlListStr += ",\"reform-title" + annualDataLength + "\",\"date" + dateLength + "\",\"date" + (dateLength + 1) 
   + "\",\"" + controlID1 + "\",\"" + controlID2 + "\",\"" + controlID3 + "\"]";
$("#__reform_control_list").attr("value", controlListStr);



var cssStr = "#reform-title" + annualDataLength + " {height:43px !important; padding-top: 10px;}"
            + "#reform-date-title" + annualDataLength + " > p {padding-top: 5px;}";
tag.addStyle(null, cssStr);

$("#reform-style").after("<p css='" + cssStr + "' id='reform-style" + annualDataLength + "' style='display:none;'>&nbsp;</p>");
 

var scriptStr = "var target" + annualDataLength + " = document.getElementById('reform-title-checkbox" + annualDataLength + "');"
               + "var titleToggle" + annualDataLength + " = function(target" + annualDataLength + ") { tag.remove('title-checkbox" + annualDataLength + "');"
               + "query('#reform-title" + annualDataLength + "')[0].disabled = !target" + annualDataLength + ".checked; "
               + "if (!target" + annualDataLength + ".checked) {  tag.addStyle('title-checkbox" + annualDataLength + "', '#reform-date-title" + annualDataLength + "{display:block !important;}');$('#reform-title-checkbox" + annualDataLength + "').attr('checked', false);} " 
               + "else {$('#reform-title-checkbox" + annualDataLength + "').attr('checked', 'checked');}};"
               + "titleToggle" + annualDataLength + "(target" + annualDataLength + ");"
               + "target" + annualDataLength + ".addEventListener('change', function(event) { titleToggle" + annualDataLength + "(event.target);});";
tag.addScript(null, scriptStr);

scriptStr = "var target" + annualDataLength + " = document.getElementById(&quot;reform-title-checkbox" + annualDataLength + "&quot;);"
               + "var titleToggle" + annualDataLength + " = function(target" + annualDataLength + ") { tag.remove(&quot;title-checkbox" + annualDataLength + "&quot;);"
               + "query(&quot;#reform-title" + annualDataLength + "&quot;)[0].disabled = !target" + annualDataLength + ".checked; "
               + "if (!target" + annualDataLength + ".checked) {  tag.addStyle(&quot;title-checkbox" + annualDataLength + "&quot;, &quot;#reform-date-title" + annualDataLength + "{display:block !important;}&quot;); }};"
               + "titleToggle" + annualDataLength + "(target" + annualDataLength + ");"
               + "target" + annualDataLength + ".addEventListener(&quot;change&quot;, function(event) { titleToggle" + annualDataLength + "(event.target);});";
$("#reform-script").after("<p code='" + scriptStr + "' id='reform-script" + annualDataLength + "' style='display:none;'>&nbsp;</p>");


//datepicker
for (var i = 0; i < 2; i++) {
   var controlId = "date" + (dateLength + i);
   var controlElement = document.getElementById(controlId);
   if (controlElement != null) {
      controlElement.removeAttribute("class");
      
      $(controlElement).datepicker({
         changeMonth: true,
         changeYear: true,
         autoSize: true,
         dateFormat: "yy-mm-dd",
         beforeShowDay: disableSomeDay
      });
      
      if ($(controlElement).val() === "") {
         $(controlElement).datepicker('setDate', new Date());
      }
   }
}

//timepicker
for (var i = 0; i < 2; i++) {
	var controlId = "time" + (timeLength + i);
	var controlElement = document.getElementById(controlId);
	if (controlElement != null) {
		controlElement.removeAttribute("class");

		$(controlElement).timepicker({
			timeFormat: "H:i",
			step : 60,
			minTime : '8:00am',
			maxTime : '8:00pm'
		});

		if ($(controlElement).val() === "") {
			var currentTime = new Date().getHours();
			var plusTime = currentTime + 2;

			if(i == 0) {
				$(controlElement).timepicker('setTime', new Date(0,0,0,currentTime,0,0));
			} else {
				$(controlElement).timepicker('setTime', new Date(0,0,0,plusTime,0,0));
			}	  
		}  
	}
}

setInputViewer(document.getElementById("reform-title"+annualDataLength));
vacationSelectInfo(controlID1);

$("#__reform_datapicker_length").attr("value",Number(dateLength) + 1);



}

// https://stackoverflow.com/questions/610406/javascript-equivalent-to-printf-string-format/4673436#4673436
if (!String.format) {
  String.format = function(format) {
    var args = Array.prototype.slice.call(arguments, 1);
    return format.replace(/{(\d+)}/g, function(match, number) { 
      return typeof args[number] != 'undefined'
        ? args[number] 
        : match
      ;
    });
  };
}

// https://stackoverflow.com/questions/432493/how-do-you-access-the-matched-groups-in-a-javascript-regular-expression
function getRegexMatches(regex, string) {
    var matches = [];
    var match = regex.exec(string);
   var isGlobal = regex.global;
   
    while (match) {
        if (match.length > 2) {
            var group_matches = [];
         
            for (var i = 1; i < match.length; i++) {
                group_matches.push(match[i]);
            }
         
            matches.push(group_matches);
        } else {
            matches.push(match[1]);
        }
      
      if (!isGlobal) {
         break;
      }
      
        match = regex.exec(string);
    }
   
    return matches;
}

var annualDateResult = "";
function setInputViewer(viewer) {
   var controlProcessor = [];
   var formatter = viewer.getAttribute("viewer-format");
   var changeListener = viewer.getAttribute("viewer-listener");
   var beforeBuildCheck = viewer.getAttribute("viewer-can-build");
   
   var inputIdArray = viewer.getAttribute("viewer").split(",");
   
   var build = function() {
      setTimeout(function() {
               formatter = viewer.getAttribute("viewer-format");
            inputIdArray = viewer.getAttribute("viewer").split(",");
		if (!document.getElementById(viewer.getAttribute("id"))) {
			return;
		}
		
         if (beforeBuildCheck) {
            if (eval(beforeBuildCheck)) {
               return;
            }
         }
         
         //var result = "";
         var valueArray = [formatter];
         
         controlProcessor.forEach(function(processor) {
            valueArray.push(processor());
         });
         annualDateResult = "";
         annualDateResult = String.format.apply(null, valueArray);
         
         if (changeListener) {
            eval(changeListener);
         }
         
         reformUseProc.setTextBoxValue(viewer, annualDateResult);
         setDocTitle(viewer);
       }, 10);
   }
   
   inputIdArray.forEach(function(id) {
      var control = document.getElementById(id);
      var argsRegexpAttr = control.getAttribute("viewer-args-regexp");
      var getFormatValueFunc = null;
      
      if (argsRegexpAttr === undefined) {
         getFormatValueFunc = function() {
            return control.value;
         };
      } else {
         getFormatValueFunc = (function(control, buildFormat, argsRegexp) {
            return function() {
               if (control.getAttribute("viewer-disable") == "true") {
                   return "";
                  }
               var matches = getRegexMatches(new RegExp(argsRegexp), control.value);
            
               if (matches.length === 1 && matches[0] instanceof Array && buildFormat) {
                  return String.format.apply(null, [buildFormat].concat(matches[0]));
               }
               
               return control.value;   
            }
         })(control, control.getAttribute("viewer-args-build"), eval(argsRegexpAttr));
      }
      
      controlProcessor.push(getFormatValueFunc);
      control.addEventListener("focus", function() {
         control.setSelectionRange(null, null);
      });
   });
   
   document.body.addEventListener("mouseup", build);
   build();
}

var tag = (function() {
   var headNode = document.querySelector("head");
   
   return {
      addStyle: function(id, css) {
         var style = document.createElement("style");
         style.type = "text/css";
         
         if (id) {
            style.id = id;
         }
         
         if (style.styleSheet) {
            style.styleSheet.cssText = css;
         } else {
            style.appendChild(document.createTextNode(css));
         }
         
         headNode.appendChild(style);
      },
      addScript: function(id, code) {
         var script = document.createElement("script");
         script.type = "text/javascript";
         script.innerHTML = code;
         
         if (id) {
            style.id = id;
         }
         
         headNode.appendChild(script);
      },
      remove: function(id) {
         var target = document.getElementById(id);
         
         if (target && target.parentNode) {
            target.parentNode.removeChild(target);
         }
      }
   };
})();

function reform_onBeforeLoadHandler() {
   var attachedNetworkElements = [];
   var attached1000SepElements = [];
   
   // edit mode
   if (document.querySelector("td#doctitle.FIELD") == null) {
      
      $("p[id^=reform-style]").each(function() {
         tag.addStyle(null, $(this).attr("css"));
      })
      
      $("p[id^=reform-script]").each(function() {
         tag.addScript(null, $(this).attr("code"));
      })

      tag.addStyle(null, "input[sum][readonly] {background: #f5f5f5 !important;}");
      
      query("[viewer]").forEach(function(element) {
         setInputViewer(element);
      });
      
      query("input[type=checkbox]").forEach(function(element) {
         element.addEventListener("change", function(event) {
            if (event.target.checked) {
               event.target.setAttribute("checked", "checked");
            } else {
               event.target.removeAttribute("checked");
            }
         });
      });
      
      if (reformUseProc.getCurrentStage() == "approve") {
         $("input[type=button][id^=control]").each(function() {
            $(this).css("display","");
         })
         $("select[id^=control]").each(function() {
            $(this).css("top","17px");
         })
      }
   } else {   
      $("input[type=button][id^=control]").each(function() {
         $(this).css("display","none");
      })
      $("select[id^=control]").each(function() {
         $(this).css("top","7px");
      })
   }
   
   var addInputListenerForClient = function(observerElement, clientElement) {
      var clientsSelector = observerElement.getAttribute("sum");
      
      if (clientsSelector === null) {
         return;
      }
      
      if (attached1000SepElements.indexOf(clientElement) == -1) {
         clientElement.addEventListener("input", function(event) {
            onMoneyInputEvent(clientElement, event);
         }, true);
         // 포커스 잃으면 0일 때 빈 스트링으로 설정
         clientElement.addEventListener("blur", function(event) {
            var value = clientElement.value;
            
            try {
               value = mark1000Sep(value);
            } catch (error) {
               // ignore
            }
            
            reformUseProc.setTextBoxValue(clientElement, value);
         });
         
         attached1000SepElements.push(clientElement);
      }
      
      clientElement.addEventListener("input", function(event) {
         refreshObserver(observerElement);
      });
   };
   
   var setSumClient = function(observerElement, clientElement) {
      if (clientElement.readOnly || clientElement.disabled) {
         var clientsSelector = clientElement.getAttribute("sum");
 
         setSumNetwork(clientElement);
 
         query(clientsSelector).forEach(function(clientOfClientElement) {
            setSumClient(observerElement, clientOfClientElement);
         });
      } else {
         setOnlyNumberInput(clientElement);
         addInputListenerForClient(observerElement, clientElement);
      }
   }
   
   var setSumNetwork = function(observerElement) {
      if (attachedNetworkElements.indexOf(observerElement) > -1) {
         return;
      }
      
      var clientsSelector = observerElement.getAttribute("sum");
      
      query(clientsSelector).forEach(function(clientElement) {
         setSumClient(observerElement, clientElement);
      });
      
      clientsSelector = observerElement.getAttribute("subsum");
      
      query(clientsSelector).forEach(function(clientElement) {
         setSumClient(observerElement, clientElement);
      });
      
      attachedNetworkElements.push(observerElement);
   };
 
   query("input[sum], input[subsum]").forEach(function(observerElement) {
      setSumNetwork(observerElement);
      refreshObserver(observerElement);
   });
   
   query("input[sum][readonly]").forEach(function(element) {
      element.disabled = true;
   });
   
   query(".money").forEach(function(element) {
      setOnlyNumberInput(element);
      
      element.addEventListener("input", function(event) {
         onMoneyInputEvent(element, event);
      });
      
      // 포커스 잃으면 0일 때 빈 스트링으로 설정
      element.addEventListener("blur", function(event) {
         var value = element.value;
         
         try {
            value = mark1000Sep(value);
         } catch (error) {
            // ignore
         }
         
         reformUseProc.setTextBoxValue(element, value);
      });
   });
   
   query(".number").forEach(function(element) {
      setOnlyNumberInput(element, true);
   });
   
   query("textarea").forEach(function(element) {
      if (element.innerHTML === " ") {
         element.innerHTML = "";
      }
   });
   
   if (reformUseProc.getCurrentStage() != "approve" && (parent.parent.FormHref).search("TMP") <= 0) {
      
      $('#mobile').val($('#p_mobile').text().trim());
      $('#mobile2').val($('#p_mobile2').text().trim());
      $('#mobile').css('display',"");
      $('#p_mobile').css('display',"none");
      $('#mobile2').css('display',"");
      $('#p_mobile2').css('display',"none");
      
	  if (parent.parent.DraftFlag != "REDRAFT"){
		setAnnualCntInfo();
		vacationSelectInfo("control10");
	  }
      
   } else {
      $('#mobile').css('display',"none");
      $('#p_mobile').css('display',"");
      $('#mobile2').css('display',"none");
      $('#p_mobile2').css('display',"");
   
      $("select[id^=control]").each(function() {
         $(this).val($(this).attr("attitudetype"));
         $(this).children("option[value=" +$(this).attr("attitudetype") + "]").attr("selected","");
      })
   }
}
 
function query(selector) {
   var result = [];
   
   try {
      result = nodesToArray(document.querySelectorAll(selector));
   } catch (ex) {}
   
   return result
}
 
function nodesToArray(nodeList) {
   return Array.prototype.slice.call(nodeList);
}
 
function refreshObserver(observerElement) {
   var result = 0;
   
   if (observerElement.hasAttribute("sum")) {
      result += sum(observerElement.getAttribute("sum"));
   }
   
   if (observerElement.hasAttribute("subsum")) {
      result -= sum(observerElement.getAttribute("subsum"));
   }
   
   try {
      reformUseProc.setTextBoxValue(observerElement, mark1000Sep(result, true));
   } catch (error) {
      // ignore
   }
}
 
// css 선택자에 해당되는 모든 input의 값을 더하여 반환
function sum(selector) {
   var elements = query(selector);
   var result = 0;
 
   elements.forEach(function(element) {
      result += reformUseProc.getFloatValueOfControl(element.id);
   });
 
   return result;
}
 
// 콤마로 천 단위 자릿수 끊어 반환
function mark1000Sep(elementValue, canZeroFill) {
   var value = getFloatValue(elementValue);
   
   if (canZeroFill) {
      value = elementValue;
   } else if (value === 0) {
      return "";
   }
   
   return reformUseProc.mark1000Sep(value);
}
 
// 천 단위 표시 문자열을 정수로 반환
function getFloatValue(elementValue) {
   elementValue = elementValue.toString().replace(/,/g, '');
   elementValue = elementValue.replace(/%/g, '');
   elementValue = elementValue.trim();
   
   if (isNaN(elementValue)) {
      throw new Error(elementValue + " is not a number");
   }
   
   return elementValue == "" ? 0 : parseFloat(elementValue);
}
 
// InputEvent listener (천 단위 자릿수로 끊어줌)
function onMoneyInputEvent(element, event) {
   var selectionStart = element.selectionStart;
   var selectionPos = selectionStart;
   var selectionPosEnd;
   
   var previousSelection = element.previousSelection;
   var previousValue = element.previousValue;
   var value = element.value;
   
   var result;
   
   validation: try {
      var isCollapsed = previousSelection.start == previousSelection.end;
      var additionalSelectionPos = 0;
      
      result = mark1000Sep(value, true);
      
      // 콤마를 지웠을 경우
      if (previousValue.length == value.length + 1 && previousValue[selectionStart] === "," && isCollapsed) {
         // Backspace, Delete 두 개의 경우가 있음
         var isBackspace = previousSelection.start != selectionStart;

         if (isBackspace) {
            // 콤마 앞 문자 삭제
            result = result.slice(0, selectionStart - 1) + result.slice(selectionStart + 1, result.length);
         } else {
            // 콤마 뒷 문자 삭제
            result = result.slice(0, selectionStart) + result.slice(selectionStart + 2, result.length);
            additionalSelectionPos = 1;
         }

         result = mark1000Sep(result, true);
      }
      
      if (isCollapsed) {
         selectionPos = Math.max(0, selectionStart + additionalSelectionPos + result.length - value.length);
      }
   } catch (error) {
      // NaN 일 때는 이전 값으로 복원
      result = previousValue;
      selectionPos = previousSelection.start;
      selectionPosEnd = previousSelection.end;
   }
   
   if (selectionPosEnd === undefined) {
      selectionPosEnd = selectionPos;
   }
   
   reformUseProc.setTextBoxValue(element, result);
   element.setSelectionRange(selectionPos, selectionPosEnd);
}
 
// input selection 저장
function captureSelection(element) {
   element.previousSelection = {
      start: element.selectionStart,
      end: element.selectionEnd
   };
}
 
// input value 저장
function captureValue(element) {
   element.previousValue = element.value;
}
 
// 정수만 입력 가능한 input으로 만듦
function setOnlyNumberInput(element, isNotMoney) {
   // 최대 길이 15
   if (!element.hasAttribute("maxlength")) {
      element.setAttribute("maxlength", 15);
   }
   
   // money 클래스가 아니라면 숫자만 입력되도록 조정
   if (isNotMoney && element.className.indexOf("money") == -1) {
      element.addEventListener("input", function() {
         if (/[^0-9]/.test(element.value)) {
            reformUseProc.setTextBoxValue(element, element.previousValue);
            element.setSelectionRange(element.previousSelection.start, element.previousSelection.end);
         }
      });
   }
   
   // 키 누를 때 이전 값 저장
   element.addEventListener("keydown", function(event) {
      captureSelection(element);
      captureValue(element);
   });
   
   // 정수가 아닌 문자열은 붙여넣기 막기
   element.addEventListener("paste", function(event) {
      var data = (event.clipboardData || window.clipboardData).getData("text");
      
      if (/\D/ig.test(data.replace(/,/g, ''))) {
         event.preventDefault();
      }
   });
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

parent.$('#div_Content').on('click', function () {
	$.datepicker._hideDatepicker();
});

//2020-03-10 김정언 : 반반차
function halfOff(attitudeType , halfOffViewer, halfOffReformId) {
	console.log("연차타입 : " + attitudeType);
	console.log("뷰어 : " + halfOffViewer);
	console.log("리폼아이디 : " + halfOffReformId);

	//date id 가져오는 변수
	var halfOffViewer2 = halfOffViewer.split(",");
	var halfOffViewer3 = halfOffViewer.replace(/date/g, "time").split(",");

	console.log("halfOffViewer2 : " + halfOffViewer2);
	console.log("halfOffViewer3 : " + halfOffViewer3);

	if(attitudeType === "A21"){
		$("#" + halfOffViewer3[0] + ", #" + halfOffViewer3[1]).css("display","");
		$("#" + halfOffViewer3[0] + ", #" + halfOffViewer3[1]).attr("viewer-disable","false");
		$("#" + halfOffReformId).attr("viewer-format","{0}{2} ~ {1}{3}");
		$("#" + halfOffReformId).attr("viewer",halfOffViewer2[0] + "," + halfOffViewer2[1] + "," + halfOffViewer3[0] + "," + halfOffViewer3[1]);

		var sTime = "";
		var eTime = "";
		var plusTime = "";

		//시작시간 선택
		$("#" + halfOffViewer3[0]).change(function(e){
			sTime = $(e.target).timepicker('getTime').getHours();
			plusTime = sTime + 2;
			$("#" + halfOffViewer3[1]).timepicker('setTime', new Date(0,0,0,plusTime,0,0));
		});

		//종료시간 선택
		$("#" + halfOffViewer3[1]).change(function(e){
			eTime = $(e.target).timepicker('getTime').getHours();
			if(eTime <= sTime){
				$("#" + halfOffViewer3[1]).timepicker('setTime', new Date(0,0,0,plusTime,0,0));
				parent.parent.OpenAlertUI("시작 시간을 종료 시간 보다 빠르게 지정해 주십시오.");
			}
		});

	} else {
		$("#" + halfOffViewer2[2] + ", #" + halfOffViewer2[3]).css("display","none");
		$("#" + halfOffReformId).attr("viewer-format","{0} ~ {1}");
		$("#" + halfOffReformId).attr("viewer",halfOffViewer2[0] + "," + halfOffViewer2[1]);
		$("#" + halfOffViewer3[0] + ", #" + halfOffViewer3[1]).attr("viewer-disable","true");
	}
}

//2020-03-10 김정언 : 반반차
function hideTime(){
	$("#reform-title").attr("viewer-format","{0} ~ {1}");
	$("#reform-title").attr("viewer","date1,date2");

	var currentTime = new Date().getHours();
	var plusTime = currentTime + 2;
	$("#time1").timepicker('setTime', new Date(0,0,0,currentTime,0,0));
	$("#time2").timepicker('setTime', new Date(0,0,0,plusTime,0,0));

	$("#time1, #time2").timepicker({
		timeFormat: "H:i",
		step : 60,
		minTime : '8:00am',
		maxTime : '8:00pm'
	});
}