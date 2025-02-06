function getMealData() {
	$.ajax({
		url: "/rest/MenuSchedule",
		type: "GET",
		data: {
			date : document.getElementById("mealPlanDatePicker").value,
			companyID : companyID,
			tenantID : tenantID
		},
		async: false,
		success: function(response, status, xhr) {
			
			if (response.RTNVALUE == "OK") {
				document.getElementById("mealPlanTable").style.display = "";
				document.getElementById("mealPlan_Portlet_List").scrollTop = 0;
				document.getElementById("noMealPlanDl").style.display = "none";
				
				var data = response.lunch;
				document.getElementById("aCourseData").innerText = data.aCourse;
				document.getElementById("bCourseData").innerText = data.bCourse;
				document.getElementById("saladBarData").innerText = data.saladBar;
				document.getElementById("dessertData").innerText = data.dessert;
				document.getElementById("totalCalData").innerText = data.totalCal;
			} else if (response.RTNVALUE == "NO_MENU"){
				document.getElementById("mealPlanTable").style.display = "none";
				document.getElementById("noMealPlanDd").innerText = messages.strLang1;
				document.getElementById("noMealPlanDl").style.display = "";
			} else {
				document.getElementById("mealPlanTable").style.display = "none";
				document.getElementById("noMealPlanDd").innerText = messages.strLang2;
				document.getElementById("noMealPlanDl").style.display = "";
			}
		},
		error: function(xhr, status, error) {
			console.log("Status: " + status);
			console.log("Error: " + error);
			document.getElementById("mealPlanTable").style.display = "none";
			document.getElementById("noMealPlanDd").innerText = messages.strLang2;
			document.getElementById("noMealPlanDl").style.display = "";
		}
	});
}


function settingMealPlanCalendar() {
	var dayList = messages.strLangSchedule01.split(";");
 	var dSun = dayList[0];
	var dMon = dayList[1];
	var dTue = dayList[2];
	var dWed = dayList[3];
	var dThu = dayList[4];
	var dFri = dayList[5];
	var dSat = dayList[6];
	$("#mealPlanDatePicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ezNewPortal/calIcon.png",
		buttonImageOnly: true,
		closeText: messages.strLang601,
		prevText: messages.strLang599,
		nextText: messages.strLang600,
		currentText: messages.strLang598,
		monthNames: [messages.strLang586, messages.strLang587, messages.strLang588, messages.strLang589, messages.strLang590, messages.strLang591, messages.strLang592, messages.strLang593, messages.strLang594, messages.strLang595, messages.strLang596, messages.strLang597],
		monthNamesShort: [messages.strLang586, messages.strLang587, messages.strLang588, messages.strLang589, messages.strLang590, messages.strLang591, messages.strLang592, messages.strLang593, messages.strLang594, messages.strLang595, messages.strLang596, messages.strLang597],
		dayNames: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		dayNamesShort: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		dayNamesMin: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		weekHeader: "Wk",
		dateFormat: "yy.mm.dd",
		firstDay: 0,
		isRTL: false,
		duration: 200,
		showAnim: "show",
		showMonthAfterYear: true,
		onSelect: function(dateText, inst) {
			var date = $(this).val();
			getMealData();
		}
	});
	
	var SDate = new Date();
	$("#mealPlanDatePicker").datepicker('setDate', SDate);
}

document.getElementById("mealPlanPlus").addEventListener("click", function() {
	window.open("/ezBoard/boardMainRedirect.do?boardID=" + encodeURIComponent("{MMMMMMMM-MMMM-MMMM-MMMM-MMMMMMMMMMMM}"), "main", "");
});
