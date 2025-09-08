var DefaultView = 1;
var sStartDate, sEndDate;
var sDate = new Date();

//리스트뷰 바디 생성
var startOfWeek, endOfWeek;
var typeCal = 0;

var xmlhttp;
var g_szCurrentApptNum = null;
var g_szCurrentApptPNum;
var g_szCurrentApptOwnerID;
var g_szCurrentApptWriterID;
var g_szCurrentApptInsType;
var g_szCurrentApptGFlag;
var g_szCurrentApptSDate;
var g_szCurrentApptEDate;
var g_szCurrentApptDivID;
var dayOfWeeks;

var g_selDivID = null;
var g_selTRID = null;
var g_selTDID = null;

var monthHeight = ((parseInt(document.documentElement.clientHeight, 10) - 250) / 6) - 12;

function CalendarView(pTagetID) {

    document.getElementById(pTagetID).innerHTML = "";

    if (DefaultView == 0)
        dayOfWeeks = strLang241; // 일>토
    else if (DefaultView == 1)
        dayOfWeeks = strLang242; // 월>일

    var objElm = document.getElementById(pTagetID);
    if (objElm) {

        var tDiv = document.createElement("DIV");
        tDiv.setAttribute("id", "tooltip");
        tDiv.style.position = "absolute";
        tDiv.style.visibility = "hidden";
        tDiv.style.zIndex = "1000";
        tDiv.style.backgroundColor = "white";
        tDiv.innerHTML = "";
        objElm.appendChild(tDiv);

        /*if (sDate.getFullYear() > 1800 && sDate.getFullYear() <= 2101) {
            if (lunarMonthTable[sDate.getFullYear() - 1 - 1799][11] == 1)
                memorialDays[1].day = 29;
            else if (lunarMonthTable[sDate.getFullYear() - 1 - 1799][11] == 2)
                memorialDays[1].day = 30;
        }*/

        if (typeCal != 1) {
            var oTable = document.createElement("TABLE");
            var oTBody = document.createElement("TBODY");
            var oTr = document.createElement("TR");
            var oTh = document.createElement("TH");
            oTable.setAttribute("cellpadding", "0");
            oTable.setAttribute("cellspacing", "0");
            oTable.setAttribute("border", "0");
            oTable.setAttribute("width", "100%");
            //oTh.setAttribute("id", "calTitle");
            /*oTh.style.padding = "1px 0px 1px 0px";*/
            //oTh.style.fontSize = "15px";
            //oTh.colSpan = "2";
            if (typeCal == 2) {
                var tempyear = sDate.getFullYear();
                var tempmemorial;
                var tempyearmemorial;
                var LunarDate2;
                if (tempyear > 1800 && tempyear <= 2101) {
                    var month = sDate.getMonth() + 1;
                    var LunarDate = lunarCalc(tempyear, month, sDate.getDate(), 1);
                    var LunarDatemonth = LunarDate.month;
                    var LunarDateday = LunarDate.day;
                    tempmemorial = memorialDayCheck(sDate, LunarDate);
                    tempyearmemorial = yearmemorialDayCheck(sDate, LunarDate);
                    LunarDate2 = LunarDatemonth + "." + LunarDateday;
                    
                    if (LunarDate.leapMonth) {
                    	LunarDate2 = strLangkmsr04 + LunarDate2;
                    }
                }
                oTable.className = "calendar_day_title";
                if (tempyear > 1800 && tempyear <= 2101) {
                    var isholiday = false;
                    var holidayname = "";;
                    var holidayname2 = "";;

                    for (var i = 0; i < tempmemorial.length; i++) {
                        memorial = tempmemorial[i];
                        
                        // 윤달일 때 기념일 안나타나도록 수정
                        if(LunarDate.leapMonth == 1 && memorial.solarLunar == 2) {
                        	continue;
                        }
                        
                        if (uselang == "1") {
                            if (i == tempmemorial.length - 1)
                                holidayname += memorial.name;
                            else
                                holidayname += memorial.name + ", ";
                        }
                        else {
                            if (i == tempmemorial.length - 1)
                                holidayname += memorial.name2;
                            else
                                holidayname += memorial.name2 + ", ";
                        }
                        if (memorial.holiday)
                            isholiday = true;
                    }

                    for (var i = 0; i < tempyearmemorial.length; i++) {
                        yearmemorial = tempyearmemorial[i];
                        
                        // 윤달일 때 기념일 안나타나도록 수정
                        if(LunarDate.leapMonth == 1 && yearmemorial.solarLunar == 2) {
                        	continue;
                        }
                        
                        if (uselang == "1") {
                            if (i == tempyearmemorial.length - 1)
                                holidayname2 += yearmemorial.name;
                            else
                                holidayname2 += yearmemorial.name + ", ";
                        }
                        else {
                            if (i == tempyearmemorial.length - 1)
                                holidayname2 += yearmemorial.name2;
                            else
                                holidayname2 += yearmemorial.name2 + ", ";
                        }
                        if (yearmemorial.holiday)
                            isholiday = true;
                    }

                    if (holidayname != "" && holidayname2 != "")
                        holidayname = holidayname + ", " + holidayname2;
                    else if (holidayname == "" && holidayname2 != "")
                        holidayname = holidayname2;

                    var dayText;
                    if (LunarUse)
                        dayText = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2) +  " (" + LunarDate2 + ")";
                    else
                        dayText = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2);


                    var current_day = new Date(sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2));
                    
                    if (current_day.getDay() == "0" || isholiday)
                    	document.getElementById("calTitle").style.color = "#ee1c25";
                    else if (current_day.getDay() == "6")
                    	document.getElementById("calTitle").style.color = "rgb(0, 72, 149)"
                    else {
                    	document.getElementById("calTitle").style.color = "black"
                    };

                }
                else
                    var dayText = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2);
            } else {
            	document.getElementById("calTitle").style.color = "black"
            	
                oTable.className = "calendar_month_navi";
                var dayText = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2);
            }

            var mSpan = document.createElement("SPAN");
            mSpan.className = "icon16 calendarleft";
            
            if (typeCal == 0)
            	mSpan.setAttribute("onclick", "preMonth()");
            else
            	mSpan.setAttribute("onclick", "preDay()");
            
            $("#preM").html("");
            $("#preM").append(mSpan);
            
            /*2018-06-04 구해안 dayText 대신에 DatePicker 시작*/
           
            var oText = document.createTextNode(" " + dayText + " ");            
            
            $("#calTitle").html("");
            $("#calTitle").append(oText);           
            
            var uploadSDate = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2);
            var datePick = document.createElement("INPUT");
            datePick.setAttribute("type", "hidden");
            datePick.setAttribute("name", "datePick");
            datePick.setAttribute("class", "datePick");
            datePick.setAttribute("value", uploadSDate);
            
            $("#calTitle").append(datePick);
            
            /*2018-06-04 구해안 dayText 대신에 DatePicker 끝*/
            var mSpan = document.createElement("SPAN");
            mSpan.className = "icon16 calendarright";
            
            if (typeCal == 0)
            	mSpan.setAttribute("onclick", "nextMonth()");
            else
            	mSpan.setAttribute("onclick", "nextDay()");
            
            $("#preN").html("");
            $("#preN").append(mSpan);

            if (typeCal == 2) {
                var oTr = document.createElement("TR");
                oTr.setAttribute("id", "calTR");
                var oTd = document.createElement("TD");
                oTd.className = "calendar_time";

                var dTable = document.createElement("TABLE")
                var dTbody = document.createElement("TBODY");
                dTable.setAttribute("cellpadding", "0");
                dTable.setAttribute("cellspacing", "0");
                dTable.setAttribute("border", "0");
                dTable.setAttribute("width", "100%");
                dTable.className = "calendar_row";
                var dTr = document.createElement("TR")
                var dTd = document.createElement("TD")
                dTd.className = "calendar_t_time";
                dTd.innerHTML = "<span class=\"point\">" + strLang306 + "</span>";
                dTr.appendChild(dTd);
                dTbody.appendChild(dTr);
                var dTr = document.createElement("TR")
                var dTd = document.createElement("TD")
                dTr.appendChild(dTd);
                dTbody.appendChild(dTr);
                dTable.appendChild(dTbody);
                oTd.appendChild(dTable);
                oTr.appendChild(oTd);

                var oTd = document.createElement("TD");
                oTd.className = "td_list";
                var dTable = document.createElement("TABLE")
                dTable.setAttribute("cellpadding", "0");
                dTable.setAttribute("cellspacing", "0");
                dTable.setAttribute("border", "0");
                dTable.setAttribute("width", "100%");
                dTable.className = "calendar_row";
                var dTr = document.createElement("TR")
                var dTd = document.createElement("TD")
                dTd.className = "calendar_t_time";
                dTd.setAttribute("dispDate", dayText.substring(0,10));
                dTd.setAttribute("onclick", "newSchedule_onclick(event)");
                dTd.setAttribute("ondblclick", "newSchedule_onclick(event)");
                var dDiv = document.createElement("DIV")
                dDiv.setAttribute("id", dayText.substring(0, 10) + "ALL");
                dDiv.style.width = "100%"
                dDiv.style.height = "100px";
                dDiv.style.overflowY = "auto";
                dTd.appendChild(dDiv);
                dTr.appendChild(dTd);
                dTable.appendChild(dTr);
                var dTr = document.createElement("TR")
                var dTd = document.createElement("TD")
                dTd.className = "calendar_t_text";
                dTd.setAttribute("dispDate", dayText.substring(0,10));
                dTd.setAttribute("onclick", "newSchedule_onclick(event)");
                dTd.setAttribute("ondblclick", "newSchedule_onclick(event)");
                dTr.appendChild(dTd);
                dTable.appendChild(dTr);
                oTd.appendChild(dTable);
                oTr.appendChild(oTd);
                oTBody.appendChild(oTr);
            }

            oTable.appendChild(oTBody);
            objElm.appendChild(oTable);
            if (typeCal == 2) {
                var oDiv = document.createElement("DIV");
                oDiv.setAttribute("id", "CalDiv")
            }

        }
        else {
        	document.getElementById("calTitle").style.color = "black"
            /*var oTable = document.createElement("TABLE");
            oTable.className = "calendar_week_navi";
            oTable.setAttribute("cellpadding", "0");
            oTable.setAttribute("cellspacing", "0");
            oTable.setAttribute("border", "0");
            oTable.setAttribute("width", "100%");
            var oTbody = document.createElement("TBODY");
            var objTr = document.createElement("TR");
            var objTd = document.createElement("TH");
            objTd.setAttribute("id", "list_Top");
            objTd.colSpan = "9";
            objTr.appendChild(objTd);
            oTbody.appendChild(objTr);
            oTable.appendChild(oTbody);
            objElm.appendChild(oTable);*/

            var oTBody = GetWeekTopObj();
            objElm.appendChild(oTBody);
            var oDiv = document.createElement("DIV");
            oDiv.setAttribute("id", "CalDiv")
        }



        var oTable = document.createElement("TABLE");
        oTable.setAttribute("id", "dayDiv");
        oTable.setAttribute("cellpadding", "0");
        oTable.setAttribute("cellspacing", "0");
        oTable.setAttribute("border", "0");
        oTable.setAttribute("width", "100%");
        if (typeCal == 0)
            oTable.className = "calendar_month";
        else if (typeCal == 1)
            oTable.className = "calendar_week";
        else if (typeCal == 2)
            oTable.className = "calendar_day";

        if (typeCal == 0)
            var oTBody = GetMonthBodyObj();
        else if (typeCal == 1)
            var oTBody = GetWeekBodyObj();
        else if (typeCal == 2)
            var oTBody = GetDayBodyObj();

        oTable.appendChild(oTBody);

        if (typeCal != 0) {
            oDiv.style.height = "580px";
            oDiv.style.borderBottomColor = "#b5b5b5";
            oDiv.style.borderBottomStyle = "solid";
            oDiv.style.borderBottomWidth = "1px";
            oDiv.style.overflowY = "auto";
            oDiv.appendChild(oTable);
            objElm.appendChild(oDiv);
        }
        else
            objElm.appendChild(oTable);

        objElm = null;
    }

    CalViewSource();
    
    Window_resize();
    
    /*//2018-06-05 구해안 datepicker 호출함수
    $('.datePick').datepicker({
   	    changeMonth: true,
    	changeYear: true,
    	autoSize: true,
    	showOn: "both",
    	buttonImage: "/images/ImgIcon/calendar-month.png",
    	buttonImageOnly: true,
    	onSelect: function (dateText, inst) {
    	   var iMonth = parseInt($('.datePick').val().substring(5,7),10)-1;
    	   var iYear = $('.datePick').val().substring(0,4);
    	   var iDay = $('.datePick').val().substring(8,10);
    	    
    	   var beforeMonth = leadingZeros((sDate.getMonth() + 1), 2) - 1; 	
    	   var beforeYear = sDate.getFullYear();
    	   
    	   sDate.setFullYear(iYear, iMonth, iDay); 
    	   if(typeCal == 0){    		   
    		   if(iYear == beforeYear && iMonth == beforeMonth){
    			   return;   			   
    		   }else CalendarView("Calendar");
    	   }else{
    		   CalendarView("Calendar");
    	   }
    	}
    });*/
 // 2018-06-07 구해안 datepicker 호출함수    
    var WstartDate, WendDate; 
    var monthCssHidden = function(){
		window.setTimeout(function(){
			 $('.ui-datepicker-month').css('display','none');
			 $('.ui-datepicker-year').css('margin','0 auto');
		}, 1);
	}
    var monthCssShow = function(){
		window.setTimeout(function(){
			 $('.ui-datepicker-month').css('display','');
			 $('.ui-datepicker-year').css('margin','');
		}, 1);
	}
    var removeMonthClass = function(){
		window.setTimeout(function(){
			 $('#ui-datepicker-div').removeClass('ui-monthpicker');
		}, 1);
	}
    if(typeCal == 2){    
    	$('.datePick').datepicker({
    		changeMonth: true,
    		changeYear: true,
    		autoSize: true,
    		showOn: "both",
    		buttonImage: "/images/ImgIcon/calendar-month.png",
    		buttonImageOnly: true,
    		dateFormat: 'yy-mm-dd',
    		showMonthAfterYear: true, 
    		onSelect: function (dateText, inst) {
    			var iMonth = parseInt($('.datePick').val().substring(5,7),10)-1;
    			var iYear = $('.datePick').val().substring(0,4);
    			var iDay = $('.datePick').val().substring(8,10);
    			
    			var beforeMonth = leadingZeros((sDate.getMonth() + 1), 2) - 1; 	   
    			var beforeYear = sDate.getFullYear();
    			
    			sDate.setFullYear(iYear, iMonth, iDay); 
    			
    			CalendarView("Calendar");    			
    		},
    		beforeShow: function(input, inst) {
    			/*monthCssShow();    */		
    			removeMonthClass();
    		}
    	});
    	$(document).off('mousemove','.ui-datepicker-calendar tr');
    	$(document).off('mouseleave', '.ui-datepicker-calendar tr');
    	
    }else if(typeCal == 1){
    	var selectCurrentWeek = function() { 
            window.setTimeout(function () { 
                $(document).find('.ui-datepicker-current-day a').addClass('ui-state-active'); 
            }, 1); 
        }     	
    	$('.datePick').datepicker({
    		showOtherMonths: true, 
            selectOtherMonths: true, 
    		changeMonth: true,
    		changeYear: true,
    		autoSize: true,
    		showOn: "both",
    		buttonImage: "/images/ImgIcon/calendar-month.png",
    		buttonImageOnly: true,
    		dateFormat: 'yy-mm-dd',
    		showMonthAfterYear: true, 
    		onSelect: function (dateText, inst) {
    			var iMonth = parseInt($('.datePick').val().substring(5,7),10)-1;
    			var iYear = $('.datePick').val().substring(0,4);
    			var iDay = $('.datePick').val().substring(8,10);
    			    			
    			var date = $(this).datepicker('getDate'); 
                WstartDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay()); 
                WendDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay() + 6);                
                 
                selectCurrentWeek(); 
    			sDate.setFullYear(iYear, iMonth, iDay);     			
    			CalendarView("Calendar");    			
    		  },
	    	  beforeShowDay: function(date) { 
	    		  /*monthCssShow();*/
	    		  removeMonthClass();
	    	      
	              var cssClass = ''; 
	              if (date >= WstartDate && date <= WendDate) 
	                  cssClass = 'ui-datepicker-current-day'; 
	              return [true, cssClass]; 	              
	          }, 
	          onChangeMonthYear: function(year, month, inst) { 
	              selectCurrentWeek(); 
	          } 
    	});
    	$(document).on('mousemove', '.ui-datepicker-calendar tr', function() { $(this).find('td a').addClass('ui-state-hover'); }); 
	    $(document).on('mouseleave', '.ui-datepicker-calendar tr', function() { $(this).find('td a').removeClass('ui-state-hover'); });
    }else{   
            $(".datePick").monthpicker({
            	showOn: "both",
        		buttonImage: "/images/ImgIcon/calendar-month.png",
        		buttonImageOnly: true,
        		onSelect: function (dateText, inst) {
        			var iMonth = parseInt($('.datePick').val().substring(5,7),10)-1;
        			var iYear = $('.datePick').val().substring(0,4);
        			var iDay = $('.datePick').val().substring(8,10);
        			
        			var beforeMonth = leadingZeros((sDate.getMonth() + 1), 2) - 1; 	   
        			var beforeYear = sDate.getFullYear();
        			
        			sDate.setFullYear(iYear, iMonth, iDay); 
        			if (typeCal == 0 && iYear == beforeYear && iMonth == beforeMonth) {
                        return;   			   
                    } else {
        				CalendarView("Calendar");
        			}
        		}
            });               
 
    }
    
    //2018-11-05 김혜정 월보기화면에서 드래그앤드롭을 위해 추가
    $("td[id^='index_']").droppable({
        tolerance: "pointer",
        drop: function(event, ui) {
            var typeCal = 0;
            var dragOwnerId = ui.draggable.find('td').attr("owner_id");
            var dragNum = ui.draggable.find('td').attr("num");
            var dragDay = ui.draggable.children().attr("id");
            var dropDay = $(this).attr("day");
            var completeFG = ui.draggable.find('td').attr("completefg");
            
            if (dragDay.substring(4, 14) == dropDay) {
                return;
            }

            if (updateDragSchedule(typeCal, dragOwnerId, dragNum, dragDay.substring(4, 14), dropDay, completeFG)) {
                RefreshView();
            }
        }
    });
    
    //2018-11-05 김혜정 주보기화면에서 드래그앤드롭을 위해 추가 - 하루종일
    $("div[id$='ALL']").droppable({
        tolerance: "pointer",
        addClasses: false,
        drop: function(event, ui) {
            var typeCal = 1;
            var dragOwnerId = ui.draggable.find('div').context.getAttribute("owner_id");
            var dragNum = ui.draggable.find('div').context.getAttribute("num");
            var dropDay = $(this).attr("id");
            var dragDay = ui.draggable.find('div').context.id
            var completeFG = ui.draggable.find('div').context.getAttribute("completefg");

            if (dragDay.substring(4, 14) == dropDay.substring(0, 10)) {
                return;
            }

            dragDay = dragDay.substring(4, dragDay.lastIndexOf("_"));
            dragDay = changeDateFormat(dragDay);

            if (updateDragSchedule(typeCal, dragOwnerId, dragNum, dragDay, dropDay, completeFG)) {
                RefreshView();
            }
        }
    });
    
    //2018-11-06 김혜정 주보기/일보기 화면에서 드래그앤드롭을 위해 추가 - 시간지정
    $("td[id^='TD_'][id$='_Value']").droppable({ //뒤에가 Value로 끝나는
        tolerance: "pointer",
        drop: function(event, ui) {
            var typeCal = 1;
            var dragOwnerId = ui.draggable.attr("owner_id");
            var dragNum = ui.draggable.attr("num");
            var dropOwnerId  = $(this).attr("owner_id");
            var dropNum  = $(this).attr("num");
            var dragDay = ui.draggable.attr("id");
            var dropDay = $(this).attr("id").substring(3, $(this).attr("id").indexOf("_Value"));

            dragDay = dragDay.substring(4, dragDay.lastIndexOf("_"));
            
            if (dragDay == dropDay) {
                return;
            }

            dragDay = changeDateFormat(dragDay);
            dropDay = changeDateFormat(dropDay);

            if (updateDragSchedule(typeCal, dragOwnerId, dragNum, dragDay, dropDay)) {
                RefreshView();
            }
        }
    });
}

///////////// 월보기 Calendar 생성 시작 /////////////
function GetMonthBodyObj() {
	
	//2018-06-05 구해안 mini에서 호출하는 부분 전부 제거
    var year = sDate.getFullYear();
    var month = parseInt(leadingZeros((sDate.getMonth() + 1), 2), 10);
   
    oBeforeDate = new Date(new Date(year, month - 1, 1) - 86400000);  // 이전달
    oThisDate = new Date(year, month - 1, 1); // 현재달
    oBeforeDate.setTime(oBeforeDate.getTime() + (oBeforeDate.getTimezoneOffset() + (oBeforeDate.getHours() * 60) + oBeforeDate.getMinutes()) * 60 * 1000);
    oThisDate.setTime(oThisDate.getTime() + (oThisDate.getTimezoneOffset() + (oThisDate.getHours() * 60) + oThisDate.getMinutes()) * 60 * 1000);

    var oBeforeMaxDay = oBeforeDate.getDate();
    var startThisDay = oThisDate.getDay();
    oThisMonth = oBeforeDate.getMonth() + 1;

    if (oThisMonth == 12) {
        oThisMonth = 0;
    }

    oBeforeDate.setDate(oBeforeMaxDay - startThisDay + 1 + DefaultView); // 월의 시작일 지정

    var oTbody = document.createElement("TBODY");
    var objTr = document.createElement("TR");

    // day of the week Start
    for (var j = 0; j < 7; j++) {
        var objTh = document.createElement("TH");
        var oText = document.createTextNode(dayOfWeeks.split(";")[j]);

        if (DefaultView == 0 && j == 0)
            objTh.className = "sun";
        else if (DefaultView == 0 && j == 6)
            objTh.className = "sat";

        if (DefaultView == 1 && j == 6)
            objTh.className = "sun";
        else if (DefaultView == 1 && j == 5)
            objTh.className = "sat";

        var className = "";
        if (DefaultView == 0 && j == 0 || DefaultView == 1 && j == 6)
            className = "sun";
        else if (DefaultView == 0 && j == 6 || DefaultView == 1 && j == 5)
            className = "sat";

        objTh.appendChild(oText);
        objTr.appendChild(objTh);
        objTh = null;
    }
    oTbody.appendChild(objTr);
    // day of the week End
    if (oBeforeMaxDay != 0) {
        oThisDate = oBeforeDate;
    }
    sStartDate = oThisDate.getFullYear() + "-" + leadingZeros((oThisDate.getMonth() + 1), 2) + "-" + leadingZeros(oThisDate.getDate(), 2);
    
    //Month Start
    var TDIndex = 0;
    for (var i = 0; i < 6; i++) {
        var objTr = document.createElement("TR");

        for (var j = 0; j < 7; j++) {
            var objTd = MonthData(oThisDate, TDIndex);
            TDIndex++;
            objTr.appendChild(objTd);
            objTd = null;
        }
        oTbody.appendChild(objTr);
    }
    //Month End
    oThisDate.setDate(oThisDate.getDate());
    sEndDate = oThisDate.getFullYear() + "-" + leadingZeros((oThisDate.getMonth() + 1), 2) + "-" + leadingZeros(oThisDate.getDate(), 2);
    objTr = null;

    return oTbody;
}

// 선택한 월의 날짜 입력 시작
function MonthData(oThisDate, TDIndex) {
    var tempyear = oThisDate.getFullYear();
    var LunarDateFull;
    var LunarDate;
    var LunarDate2;
    if (tempyear > 1800 && tempyear <= 2101) {
        var month = oThisDate.getMonth() + 1;
        LunarDate = lunarCalc(tempyear, month, oThisDate.getDate(), 1);
        var LunarDatemonth = LunarDate.month;
        var LunarDateday = LunarDate.day;
        LunarDate2 = LunarDatemonth + "." + LunarDateday;
        
        if (LunarDate.leapMonth) {
        	LunarDate2 = strLangkmsr04 + LunarDate2;
        }
    }

    var objTd = document.createElement("TD");

    // 매월 1일은 월/일 모두 표시
    if (oThisDate.getDate() == "1")
        var pDateData = (oThisDate.getMonth() + 1) + strLang304 + " " + oThisDate.getDate() + strLang305
    else
        var pDateData = oThisDate.getDate()

    var tempmemorial = memorialDayCheck(oThisDate, LunarDate);
    var tempyearmemorial = yearmemorialDayCheck(oThisDate, LunarDate);

    var isholiday = false;
    var holidayname = "";;
    var holidayname2 = "";;

    for (var i = 0; i < tempmemorial.length; i++) {
        memorial = tempmemorial[i];
        
        // 윤달일 때 기념일 안나타나도록 수정
        if(LunarDate.leapMonth == 1 && memorial.solarLunar == 2) {
        	continue;
        }
        
        if (uselang == "1") {
            if (i == tempmemorial.length - 1)
                holidayname += memorial.name;
            else
                holidayname += memorial.name + ", ";
        }
        else {
            if (i == tempmemorial.length - 1)
                holidayname += memorial.name2;
            else
                holidayname += memorial.name2 + ", ";
        }
        if (memorial.holiday)
            isholiday = true;
    }
	
    for (var i = 0; i < tempyearmemorial.length; i++) {
        yearmemorial = tempyearmemorial[i];
        
        // 윤달일 때 기념일 안나타나도록 수정
        if(LunarDate.leapMonth == 1 && yearmemorial.solarLunar == 2) {
        	continue;
        }
        
        if (uselang == "1") {
            if (i == tempyearmemorial.length - 1)
                holidayname2 += yearmemorial.name;
            else
                holidayname2 += yearmemorial.name + ", ";
        }
        else {
            if (i == tempyearmemorial.length - 1)
                holidayname2 += yearmemorial.name2;
            else
                holidayname2 += yearmemorial.name2 + ", ";
        }
        if (yearmemorial.holiday)
            isholiday = true;
    }

    if (holidayname != "" && holidayname2 != "")
        holidayname = holidayname + ", " + holidayname2;
    else if (holidayname == "" && holidayname2 != "")
        holidayname = holidayname2;

    var className = "";
    if (oThisMonth != oThisDate.getMonth()) // 현재월 이외의 날
        className = " gray";
    else if (oThisDate.getDay() == 0 || isholiday)  // 일요일
        className = " sun";
    else if (oThisDate.getDay() == 6)  // 토요일
        className = " sat";


    var nowDate = new Date();
    var cell_ID = (oThisDate.getFullYear()) + "-" + leadingZeros((oThisDate.getMonth() + 1), 2) + "-" + leadingZeros(oThisDate.getDate(), 2);
    var nowDay = (nowDate.getFullYear()) + "-" + leadingZeros((nowDate.getMonth() + 1), 2) + "-" + leadingZeros(nowDate.getDate(), 2);

    if (cell_ID == nowDay)
        objTd.className = "today";  // 현재일
    else
        objTd.className = className; // 나머지일

    objTd.setAttribute("id", "index_" + TDIndex);
    objTd.setAttribute("day", cell_ID);
    objTd.onmousedown = function () { MultiSelectStart(this, event); };
    objTd.onmouseup = function () { MultiSelectEnd(this, event); };
    //objTd.onmouseover = function () { MultiSelectItems(this); };

    // 일자 영역
    var subTable = document.createElement("TABLE")
    var subTr = document.createElement("TR")
    var subTd = document.createElement("TD")
    subTable.className = "td_day" + className;
    subTable.setAttribute("cellpadding", "0");
    subTable.setAttribute("cellspacing", "0");
    subTable.setAttribute("border", "0");
    subTd.setAttribute("id", "TD_" + cell_ID + "_Day");
    subTd.setAttribute("onmouseover", "MonthlyViewHeader_onMouseOver(this)");
    subTd.setAttribute("onmouseout", "MonthlyViewHeader_onMouseOut(this)");
    subTd.setAttribute("onclick", "newSchedule_onclick(event)");
    subTd.setAttribute("ondblclick", "newSchedule_onclick(event)");
    subTd.setAttribute("dispDate", cell_ID);
    //subTd.innerHTML = pDateData;
    if (tempyear > 1800 && tempyear <= 2101) {
		if (LunarUse)
            subTd.innerHTML = pDateData + " (" + LunarDate2 + ") " + holidayname;
        else
            subTd.innerHTML = pDateData + " " + holidayname;
    }
    else
        subTd.innerHTML = pDateData;
    subTr.appendChild(subTd);
    subTable.appendChild(subTr);
    objTd.appendChild(subTable);

    // 데이터 영역
    var subSpan = document.createElement("SPAN")
    var subTable = document.createElement("TABLE")
    subSpan.className = "span_list";

    if (monthHeight < 50)
        monthHeight = 70;
    subSpan.style.height = monthHeight + "px"
    subSpan.setAttribute("name", "span_list");
    subTable.setAttribute("id", "TD_" + cell_ID + "_Value");
    subTable.className = "td_list";
    subTable.setAttribute("cellpadding", "0");
    subTable.setAttribute("cellspacing", "0");
    subTable.setAttribute("border", "0");
    subSpan.appendChild(subTable);
    objTd.appendChild(subSpan);

    oThisDate.setDate(oThisDate.getDate() + 1);
    return objTd;
}// 선택한 월의 날짜 입력 완료
///////////// 월보기 Calendar 생성 종료 /////////////

///////////////////////Drag/////////////////////////
var DragStartItemID = "";
var DragEndItemID = "";
var IsDrag = false;
function MultiSelectStart(obj, event) {
    IsDrag = true;
    DragStartItemID = GetAttribute(obj,"id");
}
function MultiSelectItems(obj, event) {
    if (IsDrag) {
        var StartIdex = parseInt(DragStartItemID.replace("index_", ""));
        var Endidex = parseInt(GetAttribute(obj,"id").replace("index_", ""));

        if (StartIdex > Endidex) {
            var tempIndex = Endidex;
            Endidex = StartIdex;
            StartIdex = tempIndex;
        }

        for (var i = 0; i <= 41; i++) {
            if (StartIdex <= i && Endidex >= i)
                document.getElementById("index_" + i).style.backgroundColor = "#f1f8ff";
            else
                document.getElementById("index_" + i).style.backgroundColor = "";
        }
    }
}
function MultiSelectEnd(obj, event) {
    IsDrag = false;
    DragEndItemID = GetAttribute(obj,"id");
    if (DragStartItemID == DragEndItemID) {
        document.getElementById(DragEndItemID).style.backgroundColor = "";
        DragStartItemID = "";
        DragEndItemID = "";
        return;
    }
    obj.style.backgroundColor = "#f1f8ff";
    Write();
}
function Write() {	
    var StartIdex = parseInt(DragStartItemID.replace("index_", ""));
    var Endidex = parseInt(DragEndItemID.replace("index_", ""));

    if (StartIdex > Endidex) {
        var tempIndex = DragEndItemID;
        DragEndItemID = DragStartItemID;
        DragStartItemID = tempIndex;
    }
    var startdate = GetAttribute(document.getElementById(DragStartItemID),"day");
    var enddate = GetAttribute(document.getElementById(DragEndItemID),"day");

    var feature = GetOpenPosition(820, 700);
    if (CrossYN() || pNoneActiveX == "YES") {
        window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView="+ dayView +"&ownerID=" + ResID + "&startDate=" + startdate + "&endDate=" + enddate + "", "", "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
    }
    else {
        window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView="+ dayView +"&ownerID=" + ResID + "&startDate=" + startdate + "&endDate=" + enddate + "", "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
    }

    DragStartItemID = "";
    DragEndItemID = "";
    for (var i = 0; i <= 41; i++) {
        document.getElementById("index_" + i).style.backgroundColor = "";
    }
}
///////////////////////Drag/////////////////////////

///////////// 주보기 Calendar 생성 시작 /////////////
function GetWeekTopObj() {

    var oTable = document.createElement("TABLE");
    oTable.className = "calendar_week_title";
    oTable.setAttribute("cellpadding", "0");
    oTable.setAttribute("cellspacing", "0");
    oTable.setAttribute("border", "0");
    oTable.setAttribute("width", "100%");
    var oTbody = document.createElement("TBODY");
    var objTr = document.createElement("TR");
    var objTd = document.createElement("TH");
    objTd.className = "calendar_th_time"
    objTr.appendChild(objTd);
    // this Month Start
    for (var j = 0; j < 7; j++) {
        var objTd = document.createElement("TH");

        var className = "";
        if (DefaultView == 0 && j == 0 || DefaultView == 1 && j == 6)
            className = "sun";
        else if (DefaultView == 0 && j == 6 || DefaultView == 1 && j == 5)
            className = "sat";

        objTd.className = "calendar_th_list " + className;

        objTd.setAttribute("id", "list_Title" + j);
        objTr.appendChild(objTd);

        objTd.style.overflow = "hidden";
        objTd.style.textOverflow = "ellipsis";
    }

    var objTd = document.createElement("TH");
    objTd.className = "calendar_th_last"
    objTr.appendChild(objTd);
    oTbody.appendChild(objTr);

    var objTr = document.createElement("TR");
    objTr.setAttribute("id", "calTR");
    var objTd = document.createElement("TD");
    objTd.className = "calendar_time";

    var dTable = document.createElement("TABLE")
    var dTbody = document.createElement("TBODY");
    dTable.setAttribute("cellpadding", "0");
    dTable.setAttribute("cellspacing", "0");
    dTable.setAttribute("border", "0");
    dTable.setAttribute("width", "100%");
    dTable.className = "calendar_row";
    var dTr = document.createElement("TR")
    var dTd = document.createElement("TD")
    dTd.className = "calendar_t_time";
    dTd.innerHTML = "<span class=\"point\">" + strLang306 + "</span>";
    dTr.appendChild(dTd);
    dTbody.appendChild(dTr);
    var dTr = document.createElement("TR")
    var dTd = document.createElement("TD")
    dTr.appendChild(dTd);
    dTbody.appendChild(dTr);
    dTable.appendChild(dTbody);
    objTd.appendChild(dTable);
    objTr.appendChild(objTd);

    oTbody.appendChild(objTr);
    oTable.appendChild(oTbody);

    return oTable;
}

function GetWeekBodyObj() {
    startOfWeek = new Date(sDate);
    startOfWeek.setDate(sDate.getDate() - sDate.getDay() + DefaultView);
    var startYear = startOfWeek.getFullYear();
    var startMonth = startOfWeek.getMonth();
    var startDate = startOfWeek.getDate();

    sStartDate = startYear + "-" + (startMonth + 1) + "-" + startDate
    endOfWeek = new Date(sDate);
    endOfWeek.setDate(sDate.getDate() + (6 - sDate.getDay()) + DefaultView);

    var endYear = endOfWeek.getFullYear();
    var endMonth = endOfWeek.getMonth();
    var endDate = endOfWeek.getDate();

    sEndDate = endYear + "-" + (endMonth + 1) + "-" + (endDate + 1);
    var oTbody = document.createElement("TBODY");
    var oTr = document.createElement("TR");
    var oTD = document.createElement("TD");
    oTD.className = "calendar_time";

    var oText = document.createTextNode(" " + startYear + "-" + leadingZeros((startMonth + 1), 2) + "-" + leadingZeros(startDate, 2) + " ~ " + endYear + "-" + leadingZeros((endMonth + 1), 2) + "-" + leadingZeros(endDate, 2) + " ");
    var mSpan = document.createElement("SPAN");
    
    mSpan.className = "icon16 calendarleft";
    mSpan.setAttribute("onclick", "preWeek()");
    
    /*2018-06-04 구해안 dayText 대신에 DatePicker 시작*/    
    var uploadSDate = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2);
    var datePick = document.createElement("INPUT");
    datePick.setAttribute("type", "hidden");
    datePick.setAttribute("name", "datePick");
    datePick.setAttribute("class", "datePick");
    datePick.setAttribute("value", uploadSDate);
    
    var mSpan2 = document.createElement("SPAN");
    mSpan2.className = "icon16 calendarright";
    mSpan2.setAttribute("onclick", "nextWeek()");
    
    $("#preM").html("");
    $("#preM").append(mSpan);
    
    $("#calTitle").html("");
    $("#calTitle").append(oText);
    $("#calTitle").append(datePick);
    
    $("#preN").html("");
    $("#preN").append(mSpan2);

    for (var k = 0; k < 24; k++) {
        var dTable = document.createElement("TABLE")
        var dTbody = document.createElement("TBODY");
        dTable.setAttribute("cellpadding", "0");
        dTable.setAttribute("cellspacing", "0");
        dTable.setAttribute("border", "0");
        dTable.setAttribute("width", "100%");
        dTable.className = "calendar_row";
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_time";

        if (k == 0)
            dTd.innerHTML = strLang238 + " <span class=\"point\">12</span> " + strLang310;
        else if (k == 12)
            dTd.innerHTML = strLang239 + " <span class=\"point\">" + k + "</span> " + strLang310;
        else
            dTd.innerHTML = "<span class=\"point\">" + k + "</span> " + strLang310;
        dTr.appendChild(dTd);
        dTbody.appendChild(dTr);
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTr.appendChild(dTd);
        dTbody.appendChild(dTr);
        dTable.appendChild(dTbody);
        oTD.appendChild(dTable);
    }
    oTr.appendChild(oTD);


    // this Month Start
    for (var j = 0; j < 7; j++) {
        var objTD = WeekData(startOfWeek, dayOfWeeks.split(";")[j], j);
        oTr.appendChild(objTD);

        startOfWeek.setDate(startOfWeek.getDate() + 1)
        endOfWeek.setDate(endOfWeek.getDate() + 1)

    }// this Month Start

    var calTr = document.getElementById("calTR");
    if (calTr) {
        var objTd = document.createElement("TD");
        objTd.className = "calendar_td_last"
        calTr.appendChild(objTd);
    }
    oTbody.appendChild(oTr);
    oTr = null;
    return oTbody;
}

// 시작과 끝의 월이 같은 데이터 입력
function WeekData(startOfWeek, dayOfWeek, pCnt) {
    var tempyear = startOfWeek.getFullYear();
    var LunarDateFull;
    var LunarDate;
    var LunarDate2;

    if (tempyear > 1800 && tempyear <= 2101) {
        var month = startOfWeek.getMonth() + 1;
        LunarDate = lunarCalc(tempyear, month, startOfWeek.getDate(), 1);
        var LunarDatemonth = LunarDate.month;
        var LunarDateday = LunarDate.day;
        LunarDate2 = LunarDatemonth + "." + LunarDateday;
        
        if (LunarDate.leapMonth) {
        	LunarDate2 = strLangkmsr04 + LunarDate2;
        }
    }

    var divID = (startOfWeek.getFullYear()) + "-" + leadingZeros((startOfWeek.getMonth() + 1), 2) + "-" + leadingZeros(startOfWeek.getDate(), 2);

    if (tempyear > 1800 && tempyear <= 2101) {
        var tempmemorial = memorialDayCheck(startOfWeek, LunarDate);
        var tempyearmemorial = yearmemorialDayCheck(startOfWeek, LunarDate);

        var isholiday = false;
        var holidayname = "";;
        var holidayname2 = "";;

        for (var i = 0; i < tempmemorial.length; i++) {
            memorial = tempmemorial[i];
            
            // 윤달일 때 기념일 안나타나도록 수정
            if(LunarDate.leapMonth == 1 && memorial.solarLunar == 2) {
            	continue;
            }
            
            if (uselang == "1") {
                if (i == tempmemorial.length - 1)
                    holidayname += memorial.name;
                else
                    holidayname += memorial.name + ", ";
            }
            else {
                if (i == tempmemorial.length - 1)
                    holidayname += memorial.name2;
                else
                    holidayname += memorial.name2 + ", ";
            }
            if (memorial.holiday)
                isholiday = true;
        }

        for (var i = 0; i < tempyearmemorial.length; i++) {
            yearmemorial = tempyearmemorial[i];
            
            // 윤달일 때 기념일 안나타나도록 수정
            if(LunarDate.leapMonth == 1 && yearmemorial.solarLunar == 2) {
            	continue;
            }
            
            if (uselang == "1") {
                if (i == tempyearmemorial.length - 1)
                    holidayname2 += yearmemorial.name;
                else
                    holidayname2 += yearmemorial.name + ", ";
            }
            else {
                if (i == tempyearmemorial.length - 1)
                    holidayname2 += yearmemorial.name2;
                else
                    holidayname2 += yearmemorial.name2 + ", ";
            }
            if (yearmemorial.holiday)
                isholiday = true;
        }

        if (holidayname != "" && holidayname2 != "")
            holidayname = holidayname + ", " + holidayname2;
        else if (holidayname == "" && holidayname2 != "")
            holidayname = holidayname2;

        if (LunarUse)
            weekData = leadingZeros((startOfWeek.getMonth() + 1), 2) + "-" + leadingZeros(startOfWeek.getDate(), 2) + " [" + dayOfWeek + "] " + holidayname + " (" + LunarDate2 + ")";
        else
            weekData = leadingZeros((startOfWeek.getMonth() + 1), 2) + "-" + leadingZeros(startOfWeek.getDate(), 2) + " [" + dayOfWeek + "] " + holidayname;

        if (isholiday) {
            if (document.getElementById("list_Title" + pCnt).className.indexOf("sat") > -1)
                document.getElementById("list_Title" + pCnt).className = ReplaceText(document.getElementById("list_Title" + pCnt).className, "sat", "sun");
            else
                document.getElementById("list_Title" + pCnt).className += " sun";
        }
    }
    else
        var weekData = leadingZeros((startOfWeek.getMonth() + 1), 2) + "-" + leadingZeros(startOfWeek.getDate(), 2) + " [" + dayOfWeek + "]";

    var oText = document.createTextNode(weekData);
    document.getElementById("list_Title" + pCnt).appendChild(oText);

    if (screen.width < 1025) {
        document.getElementById("list_Title" + pCnt).style.whiteSpace = "nowrap";
        document.getElementById("list_Title" + pCnt).style.overflow = "hidden";
        document.getElementById("list_Title" + pCnt).style.textOverflow = "ellipsis";
        document.getElementById("list_Title" + pCnt).title = weekData;
    }

    var objTd = document.createElement("TD");
    objTd.className = "td_list";

    var calTr = document.getElementById("calTR");
    if (calTr) {

        var tTd = document.createElement("TD");
        tTd.className = "td_list";
        var dTable = document.createElement("TABLE")
        dTable.setAttribute("cellpadding", "0");
        dTable.setAttribute("cellspacing", "0");
        dTable.setAttribute("border", "0");
        dTable.setAttribute("width", "100%");
        dTable.className = "calendar_row";
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_time";
        dTd.setAttribute("onclick", "newSchedule_onclick(event)");
        dTd.setAttribute("ondblclick", "newSchedule_onclick(event)");
        dTd.setAttribute("dispDate", divID);
        var dDiv = document.createElement("DIV")
        dDiv.setAttribute("id", divID + "ALL");
        dDiv.style.height = "100px";
        dDiv.style.overflowY = "auto";
        dDiv.style.overflowX = "hidden";
        dDiv.style.whiteSpace = "noWrap";
        dTd.appendChild(dDiv);
        dTr.appendChild(dTd);
        dTable.appendChild(dTr);
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_text";
        dTd.setAttribute("dispDate", divID);
        dTd.setAttribute("onclick", "newSchedule_onclick(event)");
        dTd.setAttribute("ondblclick", "newSchedule_onclick(event)");
        dTr.appendChild(dTd);
        dTable.appendChild(dTr);
        tTd.appendChild(dTable);
        calTr.appendChild(tTd);
    }

    for (var k = 0; k < 24; k++) {
        var dTable = document.createElement("TABLE")
        dTable.setAttribute("cellpadding", "0");
        dTable.setAttribute("cellspacing", "0");
        dTable.setAttribute("border", "0");
        dTable.setAttribute("width", "100%");
        if (pDisplaySTime <= k && pDisplayETime > k)
            dTable.className = "calendar_row today";
        else
            dTable.className = "calendar_row";
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_time";
        dTd.setAttribute("id", "TD_" + divID + "_" + k + ":0_Value");
        dTd.setAttribute("onclick", "newSchedule_onclick(event)");
        dTd.setAttribute("ondblclick", "newSchedule_onclick(event)");
        dTd.setAttribute("dispTime", divID + " " + leadingZeros(k, 2) + ":00:00");
        dTr.appendChild(dTd);
        dTable.appendChild(dTr);
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_text";
        dTd.setAttribute("id", "TD_" + divID + "_" + k + ":3_Value");
        dTd.setAttribute("onclick", "newSchedule_onclick(event)");
        dTd.setAttribute("ondblclick", "newSchedule_onclick(event)");
        dTd.setAttribute("dispTime", divID + " " + leadingZeros(k, 2) + ":30:00");
        dTr.appendChild(dTd);
        dTable.appendChild(dTr);
        objTd.appendChild(dTable);

    }
    return objTd;
}
///////////// 주보기 Calendar 생성 종료 /////////////

///////////// 일보기 Calendar 생성 시작 /////////////
function GetDayBodyObj() {
    var oTbody = document.createElement("TBODY");
    var objTr = document.createElement("TR");
    var objTd = document.createElement("TD");
    objTd.className = "calendar_time";

    for (var k = 0; k < 24; k++) {
        var dTable = document.createElement("TABLE")
        var dTbody = document.createElement("TBODY");
        dTable.setAttribute("cellpadding", "0");
        dTable.setAttribute("cellspacing", "0");
        dTable.setAttribute("border", "0");
        dTable.setAttribute("width", "100%");
        dTable.className = "calendar_row";
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_time";

        if (k == 0)
            dTd.innerHTML = strLang238 + " <span class=\"point\">12</span> " + strLang310;
        else if (k == 12)
            dTd.innerHTML = strLang239 + " <span class=\"point\">" + k + "</span> " + strLang310;
        else
            dTd.innerHTML = "<span class=\"point\">" + k + "</span> " + strLang310;
        dTr.appendChild(dTd);
        dTbody.appendChild(dTr);
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTr.appendChild(dTd);
        dTbody.appendChild(dTr);
        dTable.appendChild(dTbody);
        objTd.appendChild(dTable);
    }

    objTr.appendChild(objTd);


    var objTd = document.createElement("TD");
    objTd.className = "td_list";

    for (var j = 0; j < 24; j++) {

        var objTD = DayData(j);
        objTd.appendChild(objTD);
    }
    objTr.appendChild(objTd);
    oTbody.appendChild(objTr);

    objTr = null;
    sDate.setDate(sDate.getDate() - 1);
    sStartDate = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2)
    sDate.setDate(sDate.getDate() + 2);
    sEndDate = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2)
    sDate.setDate(sDate.getDate() - 1);

    return oTbody;
}


function DayData(j) {

    var divID = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2);
    var sTable = document.createElement("TABLE");
    sTable.setAttribute("cellpadding", "0");
    sTable.setAttribute("cellspacing", "0");
    sTable.setAttribute("border", "0");
    sTable.setAttribute("width", "100%");
    if (pDisplaySTime <= j && pDisplayETime > j)
        sTable.className = "calendar_row today";
    else
        sTable.className = "calendar_row";
    var s_Tr = document.createElement("TR");
    var s_Td = document.createElement("TD");
    s_Td.className = "calendar_t_time";
    s_Td.setAttribute("id", "TD_" + divID + "_" + j + ":0_Value");
    s_Td.setAttribute("onclick", "newSchedule_onclick(event)");
    s_Td.setAttribute("ondblclick", "newSchedule_onclick(event)");
    s_Td.setAttribute("dispTime", divID + " " + leadingZeros(j, 2) + ":00:00");
    s_Tr.appendChild(s_Td);
    sTable.appendChild(s_Tr);
    var s_Tr = document.createElement("TR");
    var s_Td = document.createElement("TD");
    s_Td.className = "calendar_t_text";
    s_Td.setAttribute("onclick", "newSchedule_onclick(event)");
    s_Td.setAttribute("ondblclick", "newSchedule_onclick(event)");
    s_Td.setAttribute("id", "TD_" + divID + "_" + j + ":3_Value");
    s_Td.setAttribute("dispTime", divID + " " + leadingZeros(j, 2) + ":30:00");
    s_Tr.appendChild(s_Td);
    sTable.appendChild(s_Tr);
    return sTable;
}
///////////// 일보기 Calendar 생성 종료 /////////////

//이전월 이동
function preMonth() {
	//2018-06-05 구해안 기존 mini 달력에서 가져오는 값을 제거하고 datepicker에서 가져오도록 수정		
    var iMonth = parseInt($('.datePick').val().substring(5,7),10) - 1;
    var iYear = $('.datePick').val().substring(0,4);

    if (iMonth < 1) {
        iYear--;
        iMonth = 12;
    }
    else if (iMonth > 12) {
        iYear++;
        iMonth = 1;
    }

    /*document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;*/
    sDate.setFullYear(iYear, iMonth - 1, 14);

    CalendarView('Calendar');
     
}

//다음월 이동
function nextMonth() {
	var iMonth = parseInt($('.datePick').val().substring(5,7),10) + 1;
	var iYear = $('.datePick').val().substring(0,4);

    if (iMonth < 1) {
        iYear--;
        iMonth = 12;
    }
    else if (iMonth > 12) {
        iYear++;
        iMonth = 1;
    }

    sDate.setFullYear(iYear, iMonth - 1, 14);
    /*document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;*/

    CalendarView('Calendar');
     
}

//이전년도 이동
function preYear() {
	var iMonth = parseInt($('.datePick').val().substring(5,7),10);
	var iYear = $('.datePick').val().substring(0,4);

    iYear--;
    /*document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;*/
    sDate.setFullYear(iYear, iMonth - 1, 14);

    CalendarView('Calendar');
     
}

//다음년도 이동
function nextYear() {
	var iMonth = parseInt($('.datePick').val().substring(5,7),10);
	var iYear = $('.datePick').val().substring(0,4);

    iYear++;
    sDate.setFullYear(iYear, iMonth - 1, 14);
    /*document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;*/

    CalendarView('Calendar');
     
}

//선택한 년도 이동
function changeYear() {
	var iMonth = parseInt($('.datePick').val().substring(5,7),10);
	var iYear = $('.datePick').val().substring(0,4);

    sDate.setFullYear(iYear, iMonth - 1, 14);
    /*document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;*/

    CalendarView('Calendar');
     
}

//선택한 월 이동
function changeMonth() {
    var iMonth = document.getElementById("iMon").value;
    var iYear = document.getElementById("iYear").value;

    document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;
    sDate.setFullYear(iYear, iMonth - 1, 14);

    CalendarView('Calendar');
     
}


//2018-06-05 구해안 월, 주, 일 달력 이동하는 이벤트 mini 호출하는 부분 삭제
function preWeek() {
    sDate.setDate(sDate.getDate() - 7);
    
    CalendarView("Calendar");
}

function nextWeek() {

    sDate.setDate(sDate.getDate() + 7);
   
    CalendarView("Calendar");
}


function preDay() {
    sDate.setDate(sDate.getDate() - 1);
   
    CalendarView("Calendar");
}

function nextDay() {

    sDate.setDate(sDate.getDate() + 1);
 
    CalendarView("Calendar");
}

function memorialDayCheck(solarDate, lunarDate) {
    var i;
    var memorial;

    var tempmemorialDays = new Array();
    for (i = 0; i < memorialDays.length; i++) {
        if (solarDate.getFullYear() > 1800 && solarDate.getFullYear() <= 2101) {
        	if (memorialDays[i].type == 'Y') {
        		var resultDate = changeRepetitionToDate(memorialDays[i].repetition, solarDate.getFullYear());
        		if (resultDate.getMonth() == solarDate.getMonth() && resultDate.getDate() == solarDate.getDate() && memorialDays[i].solarLunar == 1) {
        			tempmemorialDays.push(memorialDays[i]);
        		}        		
        	} else {
        		if (memorialDays[i].month == solarDate.getMonth() + 1 &&
        				memorialDays[i].day == solarDate.getDate() &&
        				memorialDays[i].solarLunar == 1) {
        			tempmemorialDays.push(memorialDays[i]);
        		}
        		
        		if (memorialDays[i].month == "12" && memorialDays[i].day == "30" && memorialDays[i].solarLunar == 2 && !memorialDays[i].leapMonth
        			&& (lunarDate.month == "12" && lunarDate.day == "29")) {
        			var tempDate = new Date(solarDate.getTime());
    				tempDate.setDate(tempDate.getDate() + 1);
    				var tempLunarDate = lunarCalc(tempDate.getFullYear(), tempDate.getMonth() + 1, tempDate.getDate(), 1);
                    var tempLunarDatemonth = tempLunarDate.month;
                    var tempLunarDateday = tempLunarDate.day;
                    
                    if (!(tempLunarDatemonth == "12" && tempLunarDateday == "30")) {
                    	var tempMemorial = {}
                    	var keys = Object.keys(memorialDays[i]);
                        
                        for (var j = 0; j < keys.length; j++) {
                            var key = keys[j];
                            tempMemorial[key] = memorialDays[i][key];
                        }
                        tempMemorial.day = "29"
                    	tempmemorialDays.push(tempMemorial);
                    }
    				
    			} else if (memorialDays[i].month == lunarDate.month &&
        				memorialDays[i].day == lunarDate.day &&
        				memorialDays[i].solarLunar == 2 &&
        				!memorialDays[i].leapMonth) {
        			tempmemorialDays.push(memorialDays[i]);
        		}
        	}
        }
    }
    return tempmemorialDays;
}

function yearmemorialDayCheck(solarDate, lunarDate) {
    var i;
    var yearmemorial;

    var tempyearmemorialDays = new Array();
    for (i = 0; i < yearmemorialDays.length; i++) {
        if (solarDate.getFullYear() > 1800 && solarDate.getFullYear() <= 2101) {
        	if (yearmemorialDays[i].type == 'Y') {
        		var resultDate = changeRepetitionToDate(yearmemorialDays[i].repetition, '');
        		if (resultDate.getFullYear() == solarDate.getFullYear() && resultDate.getMonth() == solarDate.getMonth() && resultDate.getDate() == solarDate.getDate()  && yearmemorialDays[i].solarLunar == 1) {
        			tempyearmemorialDays.push(yearmemorialDays[i]);
        		}        		
        	} else {
        		if (yearmemorialDays[i].year == solarDate.getFullYear() &&
        				yearmemorialDays[i].month == solarDate.getMonth() + 1 &&
        				yearmemorialDays[i].day == solarDate.getDate() &&
        				yearmemorialDays[i].solarLunar == 1) {
        			tempyearmemorialDays.push(yearmemorialDays[i]);
        		}
        		

        		if (yearmemorialDays[i].year == lunarDate.year && yearmemorialDays[i].month == "12" && yearmemorialDays[i].day == "30" && yearmemorialDays[i].solarLunar == 2 && !yearmemorialDays[i].leapMonth
        			&& (lunarDate.month == "12" && lunarDate.day == "29")) {
        			var tempDate = new Date(solarDate.getTime());
    				tempDate.setDate(tempDate.getDate() + 1);
    				var tempLunarDate = lunarCalc(tempDate.getFullYear(), tempDate.getMonth() + 1, tempDate.getDate(), 1);
                    var tempLunarDatemonth = tempLunarDate.month;
                    var tempLunarDateday = tempLunarDate.day;
                    
                    if (!(tempLunarDatemonth == "12" && tempLunarDateday == "30")) {
                    	var tempMemorial = {}
                    	var keys = Object.keys(yearmemorialDays[i]);
                        
                        for (var j = 0; j < keys.length; j++) {
                            var key = keys[j];
                            tempMemorial[key] = yearmemorialDays[i][key];
                        }
                        tempMemorial.day = "29"
                        tempyearmemorialDays.push(tempMemorial);
                    }
        				
        		} else if (yearmemorialDays[i].year == lunarDate.year &&
        				yearmemorialDays[i].month == lunarDate.month &&
        				yearmemorialDays[i].day == lunarDate.day &&
        				yearmemorialDays[i].solarLunar == 2 &&
        				!yearmemorialDays[i].leapMonth) {
        			tempyearmemorialDays.push(yearmemorialDays[i]);
        		}
        	}
        }
    }
    return tempyearmemorialDays;
}

function lunarCalc(year, month, day, type, leapmonth) {
    var solYear, solMonth, solDay;
    var lunYear, lunMonth, lunDay;
    var lunLeapMonth, lunMonthDay;
    var i, lunIndex;
    var solMonthDay = [31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    /* range check */
    if (year < 1800 || year > 2101) {
        alert('1800년부터 2101년까지만 지원합니다');
        return;
    }
    /* 속도 개선을 위해 기준 일자를 여러개로 한다 */
    if (year >= 2080) {
        /* 기준일자 양력 2080년 1월 1일 (음력 2079년 12월 10일) */
        solYear = 2080;
        solMonth = 1;
        solDay = 1;
        lunYear = 2079;
        lunMonth = 12;
        lunDay = 10;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 2080 년 2월 28일 */
        lunMonthDay = 30; /* 2079년 12월 */
    }
    else if (year >= 2060) {
        /* 기준일자 양력 2060년 1월 1일 (음력 2059년 11월 28일) */
        solYear = 2060;
        solMonth = 1;
        solDay = 1;
        lunYear = 2059;
        lunMonth = 11;
        lunDay = 28;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 2060 년 2월 28일 */
        lunMonthDay = 30; /* 2059년 11월 */
    }
    else if (year >= 2040) {
        /* 기준일자 양력 2040년 1월 1일 (음력 2039년 11월 17일) */
        solYear = 2040;
        solMonth = 1;
        solDay = 1;
        lunYear = 2039;
        lunMonth = 11;
        lunDay = 17;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 2040 년 2월 28일 */
        lunMonthDay = 29; /* 2039년 11월 */
    }
    else if (year >= 2020) {
        /* 기준일자 양력 2020년 1월 1일 (음력 2019년 12월 7일) */
        solYear = 2020;
        solMonth = 1;
        solDay = 1;
        lunYear = 2019;
        lunMonth = 12;
        lunDay = 7;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 2020 년 2월 28일 */
        lunMonthDay = 30; /* 2019년 12월 */
    }
    else if (year >= 2000) {
        /* 기준일자 양력 2000년 1월 1일 (음력 1999년 11월 25일) */
        solYear = 2000;
        solMonth = 1;
        solDay = 1;
        lunYear = 1999;
        lunMonth = 11;
        lunDay = 25;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 2000 년 2월 28일 */
        lunMonthDay = 30; /* 1999년 11월 */
    }
    else if (year >= 1980) {
        /* 기준일자 양력 1980년 1월 1일 (음력 1979년 11월 14일) */
        solYear = 1980;
        solMonth = 1;
        solDay = 1;
        lunYear = 1979;
        lunMonth = 11;
        lunDay = 14;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1980 년 2월 28일 */
        lunMonthDay = 30; /* 1979년 11월 */
    }
    else if (year >= 1960) {
        /* 기준일자 양력 1960년 1월 1일 (음력 1959년 12월 3일) */
        solYear = 1960;
        solMonth = 1;
        solDay = 1;
        lunYear = 1959;
        lunMonth = 12;
        lunDay = 3;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1960 년 2월 28일 */
        lunMonthDay = 29; /* 1959년 12월 */
    }
    else if (year >= 1940) {
        /* 기준일자 양력 1940년 1월 1일 (음력 1939년 11월 22일) */
        solYear = 1940;
        solMonth = 1;
        solDay = 1;
        lunYear = 1939;
        lunMonth = 11;
        lunDay = 22;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1940 년 2월 28일 */
        lunMonthDay = 29; /* 1939년 11월 */
    }
    else if (year >= 1920) {
        /* 기준일자 양력 1920년 1월 1일 (음력 1919년 11월 11일) */
        solYear = 1920;
        solMonth = 1;
        solDay = 1;
        lunYear = 1919;
        lunMonth = 11;
        lunDay = 11;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1920 년 2월 28일 */
        lunMonthDay = 30; /* 1919년 11월 */
    }
    else if (year >= 1900) {
        /* 기준일자 양력 1900년 1월 1일 (음력 1899년 12월 1일) */
        solYear = 1900;
        solMonth = 1;
        solDay = 1;
        lunYear = 1899;
        lunMonth = 12;
        lunDay = 1;
        lunLeapMonth = 0;
        solMonthDay[1] = 28; /* 1900 년 2월 28일 */
        lunMonthDay = 30; /* 1899년 12월 */
    }
    else if (year >= 1880) {
        /* 기준일자 양력 1880년 1월 1일 (음력 1879년 11월 20일) */
        solYear = 1880;
        solMonth = 1;
        solDay = 1;
        lunYear = 1879;
        lunMonth = 11;
        lunDay = 20;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1880 년 2월 28일 */
        lunMonthDay = 30; /* 1879년 11월 */
    }
    else if (year >= 1860) {
        /* 기준일자 양력 1860년 1월 1일 (음력 1859년 12월 9일) */
        solYear = 1860;
        solMonth = 1;
        solDay = 1;
        lunYear = 1859;
        lunMonth = 12;
        lunDay = 9;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1860 년 2월 28일 */
        lunMonthDay = 30; /* 1859년 12월 */
    }
    else if (year >= 1840) {
        /* 기준일자 양력 1840년 1월 1일 (음력 1839년 11월 27일) */
        solYear = 1840;
        solMonth = 1;
        solDay = 1;
        lunYear = 1839;
        lunMonth = 11;
        lunDay = 27;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1840 년 2월 28일 */
        lunMonthDay = 30; /* 1839년 11월 */
    }
    else if (year >= 1820) {
        /* 기준일자 양력 1820년 1월 1일 (음력 1819년 11월 16일) */
        solYear = 1820;
        solMonth = 1;
        solDay = 1;
        lunYear = 1819;
        lunMonth = 11;
        lunDay = 16;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1820 년 2월 28일 */
        lunMonthDay = 30; /* 1819년 11월 */
    }
    else if (year >= 1800) {
        /* 기준일자 양력 1800년 1월 1일 (음력 1799년 12월 7일) */
        solYear = 1800;
        solMonth = 1;
        solDay = 1;
        lunYear = 1799;
        lunMonth = 12;
        lunDay = 7;
        lunLeapMonth = 0;
        solMonthDay[1] = 28; /* 1800 년 2월 28일 */
        lunMonthDay = 30; /* 1799년 12월 */
    }
    lunIndex = lunYear - 1799;
    while (true) {
        if (type == 1 &&
         year == solYear &&
         month == solMonth &&
         day == solDay) {
            return new myDate(lunYear, lunMonth, lunDay, lunLeapMonth);
        }
        else if (type == 2 &&
          year == lunYear &&
          month == lunMonth &&
          day == lunDay &&
          leapmonth == lunLeapMonth) {
            return new myDate(solYear, solMonth, solDay, 0);
        }
        /* add a day of solar calendar */
        if (solMonth == 12 && solDay == 31) {
            solYear++;
            solMonth = 1;
            solDay = 1;
            /* set monthDay of Feb */
            if (solYear % 400 == 0)
                solMonthDay[1] = 29;
            else if (solYear % 100 == 0)
                solMonthDay[1] = 28;
            else if (solYear % 4 == 0)
                solMonthDay[1] = 29;
            else
                solMonthDay[1] = 28;
        }
        else if (solMonthDay[solMonth - 1] == solDay) {
            solMonth++;
            solDay = 1;
        }
        else
            solDay++;
        /* add a day of lunar calendar */
        if (lunMonth == 12 &&
         ((lunarMonthTable[lunIndex][lunMonth - 1] == 1 && lunDay == 29) ||
         (lunarMonthTable[lunIndex][lunMonth - 1] == 2 && lunDay == 30))) {
            lunYear++;
            lunMonth = 1;
            lunDay = 1;
            if (lunYear > 2101) {
                alert("입력하신 날 또는 달은 없습니다. 다시 입력하시기 바랍니다.");
                break;
            }
            lunIndex = lunYear - 1799;
            if (lunarMonthTable[lunIndex][lunMonth - 1] == 1)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 2)
                lunMonthDay = 30;
        }
        else if (lunDay == lunMonthDay) {
            if (lunarMonthTable[lunIndex][lunMonth - 1] >= 3
             && lunLeapMonth == 0) {
                lunDay = 1;
                lunLeapMonth = 1;
            }
            else {
                lunMonth++;
                lunDay = 1;
                lunLeapMonth = 0;
            }
            if (lunarMonthTable[lunIndex][lunMonth - 1] == 1)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 2)
                lunMonthDay = 30;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 3)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 4 &&
              lunLeapMonth == 0)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 4 &&
              lunLeapMonth == 1)
                lunMonthDay = 30;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 5 &&
              lunLeapMonth == 0)
                lunMonthDay = 30;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 5 &&
              lunLeapMonth == 1)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 6)
                lunMonthDay = 30;
        }
        else
            lunDay++;
    }
}

var lunarMonthTable = [
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2],
[2, 1, 2, 5, 2, 1, 2, 1, 2, 1, 2, 1],
[1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2], /* 1801 */
[1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2, 1],
[2, 3, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 3, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 2, 1, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 5, 2, 1, 2, 1, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 1, 5, 2, 1, 2, 2, 1, 2, 2, 1, 2], /* 1811 */
[1, 1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 5, 2, 1, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 5, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 5, 2, 2, 1, 2, 2, 1, 2, 1],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2], /* 1821 */
[2, 1, 5, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 4, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 4, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 3, 2, 1, 2, 2, 1, 2, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2], /* 1831 */
[1, 2, 1, 2, 1, 1, 2, 1, 5, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 5, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 5, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 4, 1, 1, 2, 1, 2, 1, 2, 2, 1],   /* 1841 */
[2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 4, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 5, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 3, 2, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 3, 2, 1, 2, 2],   /* 1851 */
[2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 5, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 2, 1, 1, 5, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[2, 1, 6, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2],   /* 1861 */
[2, 1, 2, 1, 2, 2, 1, 5, 2, 1, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 4, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],
[1, 2, 2, 3, 2, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 2, 1, 1, 5, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2],   /* 1871 */
[1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2],
[1, 1, 2, 1, 2, 4, 2, 1, 2, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 1, 5, 1, 2, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 4, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 2, 1, 2, 5, 2, 2, 1, 2, 1],   /* 1881 */
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 3, 2, 1, 2, 2, 1, 2, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 5, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 5, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],   /* 1891 */
[1, 1, 2, 1, 1, 5, 2, 2, 1, 2, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 5, 1, 2, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 5, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 5, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],   /* 1901 */
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 3, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 4, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2],
[1, 5, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 5, 1, 2, 2, 1, 2, 2],   /* 1911 */
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 5, 1, 2, 1, 2, 1, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 3, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 1, 2, 1, 5, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],   /* 1921 */
[2, 1, 2, 2, 3, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 5, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 5, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],
[1, 2, 2, 1, 1, 5, 1, 2, 1, 2, 2, 1],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],   /* 1931 */
[2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 6, 1, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 4, 1, 1, 2, 2, 1, 2, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 1, 2, 1, 4, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 2, 4, 1, 1, 2, 1, 2, 1],   /* 1941 */
[2, 1, 2, 2, 1, 2, 2, 1, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 4, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 5, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 3, 2, 1, 2, 1, 2],
[1, 2, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],   /* 1951 */
[1, 2, 1, 2, 4, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[2, 1, 4, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 5, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 5, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],   /* 1961 */
[1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 2, 3, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 2],
[1, 2, 5, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 2, 1, 5, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 5, 2, 1, 2, 2, 2, 1, 2],   /* 1971 */
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 5, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 5, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 6, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],   /* 1981 */
[2, 1, 2, 3, 2, 1, 1, 2, 1, 2, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[2, 1, 2, 2, 1, 1, 2, 1, 1, 5, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 1, 2, 5, 2, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 5, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],   /* 1991 */
[1, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 5, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 5, 2, 1, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 3, 2, 2, 1, 2, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 1, 5, 2, 1, 1, 2, 1, 2, 1, 2],   /* 2001 */
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 5, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 5, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 5, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],   /* 2011 */
[2, 1, 2, 5, 2, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 5, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 2, 1, 4, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2],
[2, 1, 2, 5, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],   /* 2021 */
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 5, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 2, 1, 1, 5, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 2, 1, 5, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 1, 2, 2, 1, 1, 2, 1, 1, 2, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 5, 2, 1, 2, 2, 1, 2, 1, 2, 1],   /* 2031 */
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 5, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 4, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1],
[2, 2, 1, 2, 5, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],   /* 2041 */
[1, 5, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 3, 2, 1, 2, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[2, 1, 2, 2, 4, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1],
[1, 2, 4, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],   /* 2051 */
[1, 2, 1, 1, 2, 1, 1, 5, 2, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],
[1, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 4, 1, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 2, 1, 1, 2, 1],
[2, 1, 2, 4, 2, 1, 2, 1, 2, 2, 1, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 1],
[2, 2, 3, 2, 1, 1, 2, 1, 2, 2, 2, 1],   /* 2061 */
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 1, 2, 1, 2, 3, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 1, 2, 5, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 5, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 1, 2, 1, 2, 1, 1, 5, 2, 1, 2, 2],   /* 2071 */
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 5, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 2, 3, 2, 1, 2, 2, 2, 1, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 5, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2],   /* 2081 */
[1, 2, 2, 2, 1, 2, 3, 2, 1, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 6, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 5, 1, 2, 1, 1, 2, 2, 2, 1],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 2, 1, 2, 1, 1, 5, 1, 2, 2, 1],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1],   /* 2091 */
[2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[1, 2, 2, 1, 2, 4, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 3, 2, 1, 1, 2, 2, 2, 1, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 5, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 5, 2, 1, 1, 2, 1]];

function myDate(year, month, day, leapMonth) {
    this.year = year;
    this.month = month;
    this.day = day;
    this.leapMonth = leapMonth;
}
//- 주 - 요일을 - 일로 바꿔주는 함수
function changeRepetitionToDate(repetition, solarYear) {
	var date = repetition.split('|');
	var year = date[0];
	if (solarYear != null && solarYear != '') {
		year = solarYear;
	}
	var month = date[1]; 
	var order = date[2];
	var day  = date[3];
	
	var resultDate = changeDayToDate(year, month, order, day);
	
	return resultDate;
}

function changeDayToDate(year, month, order, day) {
	//해당 년,월의 첫번째 날의 요일을 구한다.
	var firstDate = new Date(year + '/' + month + '/01');
	var firstDateDay = firstDate.getDay();
	var resultDay;
	
	if (day < firstDateDay) {
		order = parseInt(order) + 1;
		if (order == 5) {
			resultDay = (order - 1) * 7 + (day - firstDateDay) + 1;
			var resultDate = new Date(year + '/' + month + '/' + resultDay);
			
			return resultDate;
		}
	}
	
	//order > 4는 마지막주일때 계산
	if (order > 4) {
		var lastDateDay = getLastDateDay(year, month, day, firstDate);
		
		var totalDate = getTotalDate(year, month);
		
		if (day <= lastDateDay) {
			resultDay = totalDate + (day - lastDateDay);
		} else {
			resultDay = totalDate + (day - lastDateDay) - 7;
		}
	} else {
		resultDay = (order - 1) * 7 + (day - firstDateDay) + 1; 
	}
	
	var resultDate = new Date(year + '/' + month + '/' + resultDay);
		
	return resultDate;
}

// 이번달의 마지막일의 요일을 구하는 함수
function getLastDateDay(year, month, day, firstDate) {
	var firstDateDay = firstDate.getDay();
	var temp_Date = firstDate.getDate();
	var lastDay = firstDateDay; //시작요일을 저장하는 변수이다. 먼저 기본값으로 현재 요일을 저장한다.
	
	//먼저 당월에 대한 총 일수를 구한다. 위에서 선언한 메소드를 가지고 구한다.
	var totalDate = getTotalDate(year, month);
	lastDay = lastDay - 1;
	for(temp_Date ; temp_Date <= totalDate ; temp_Date++) { //시작값:현지 일자, 끝값 : 당월 마지막일
		lastDay++; // +1씩 증가
		if(lastDay > 6) //요일은 0부터 6까지 있기 때문에 6을 초과하면 0으로 초기화 해준다.(한바퀴)
		{
			lastDay = 0;
		}			
	}
	return lastDay;
}

function getTotalDate(year, month) {
	if(month.indexOf('0') == 0) {
		 month = month.substring(1);
	 }
	
	if(month==4 || month==6 || month==9 || month==11) {
		return 30;
	} else if(month==2) {
		if(year%4 == 0) { // 2월이면서 윤년일 때
			return 29;
		} else { // 2월이면서 윤년이 아닐 때
			return 28;
		}			
	} else {
		return 31;
	}
}

function OnDoubleClickAppointment(srcEl) {

    //if (!event) event = window.event;
    if (GetAttribute(srcEl,"command") == 'open') {
        var szNum = GetAttribute(srcEl,"num");
        var szPNum = GetAttribute(srcEl,"pnum");
        var szOwnerID = GetAttribute(srcEl,"owner_id");
        var szWriterID = GetAttribute(srcEl,"writer_id");
        var szGroupFlag = GetAttribute(srcEl,"groupflag");
        var szStart = new Date(GetAttribute(srcEl,"dtend"));
        var szEnd = new Date(GetAttribute(srcEl,"dtend"));
        var szInstancetype = GetAttribute(srcEl,"instancetype");
        var szType, startDate, endDate, filename;

        szType = "Master";
        startDate = szStart.getFullYear() + "-" + parseInt(szStart.getMonth() + 1, 10) + "-" + szStart.getDate();
        endDate = szEnd.getFullYear() + "-" + parseInt(szEnd.getMonth() + 1, 10) + "-" + szEnd.getDate();

        if (parseInt(szGroupFlag) == 2 || parseInt(szGroupFlag) == 4) {
            //메인화면에서 더블클릭하면 분기
            filename = "Schedule_UnReg.asp";

        } else {
            filename = "scheduleRead.do";

            // 반복자원예약에 대한 처리
            if (parseInt(szInstancetype) == 1 || parseInt(szInstancetype) == 3) {
                if (parseInt(szInstancetype) == 3) {
                    szNum = szPNum;
                    szOwnerID = szWriterID;
                }
            }
        }
        windowName = "";

        if (CrossYN()) {
            GetOpenWindow(filename + "?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + startDate + "&endDate=" + endDate, "", 820, 700);

        }
        else {
            var feature = GetOpenPosition(790, 420);
            window.open(filename + "?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + startDate + "&endDate=" + endDate, "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
        }
    }
}

function GetOpenPosition(popUpW, popUpH) {
    //2011.07.28 FireFox는 ShowModalDialog() 호출시 화면 중앙에 뜨지 않아 top, left를 지정해 줘야한다.
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;

    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;

    left = pleftpos / 2;
    top = heigth / 2;

    var feature = ",left=" + left + ",top=" + top;

    return feature
}

function changeDateFormat(date) {
	var day  = date.substring(0, 10);
	var hour = date.substring(11, date.indexOf(":"));
	var Minu = date.substring(date.indexOf(":") + 1);
	
	hour = (hour.length == 1) ?  "0" + hour : hour;
	day  = day + " " + hour + ":" + Minu + "0:00";
	
	return day;
}

function updateDragSchedule(typeCal, dragOwnerId, dragNum, dragDay, dropDay, completeFG) {
	var rtv = true;
	$.ajax({
		type : "POST",
		async : false,
		dataType : "text",
		url : "/ezResource/scheduleDragSave.do",
		data : {
			typeCal: typeCal,
			dragOwnerId : dragOwnerId,
            dragNum : dragNum,
			dragDay: dragDay,
			dropDay: dropDay,
			completeFG: completeFG,
            resApprFlag : ApproveFlag
		},
		success: function(text) {
			if (text == "1") { //권한 없음
				setTimeout(function() { alert(strLangModSche01); }, 10)
				rtv = false;
			}else if (text == "2") { //이전날짜사용하는데 종료일이 현재날짜보다 큰 경우
				setTimeout(function() { alert(strLangModSche02); }, 10)
				rtv = false;
			} else if (text == "3") { // 중복예약인 경우
                setTimeout(function() { alert(strLang248); }, 10)
				rtv = false;
            }
		},
		error: function(error) {
			console.log("error");
		}
	});
	
	return rtv;
}