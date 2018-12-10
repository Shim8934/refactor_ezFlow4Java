function getYearList() {
	var regular = document.getElementById("regular");
	
	for (var i = nowYear - 20; i < nowYear + 21; i++) {
		var sliderDiv  = document.createElement("div");
		var sliderSpan = document.createElement("span");
		
		sliderDiv.className = "yearDiv";
		sliderSpan.className = "yearSpan";
		sliderSpan.setAttribute("id", i);
		sliderSpan.textContent = i;
		
		sliderDiv.appendChild(sliderSpan);
		regular.appendChild(sliderDiv);
	}
	
	$(".regular").slick({
		dots: false,
		infinite: false,
		slidesToShow: 5,
		initialSlide: 20,
		slidesToScroll: 5,
		focusOnSelect: true,
		centerMode: true,
		speed: 500,
		centerPadding: '0px',
		draggable: false,
		allow: true,
		prevArrow: '<div class="slick-prev"><span class="icon16 calendarleft"></span></div>',
		nextArrow: '<div class="slick-next"><span class="icon16 calendarright"></span></div>',
	});
}

function changeYear() {
	var mainList = document.getElementById("mainlist");
	while (mainList.firstChild) {
		mainList.removeChild(mainList.firstChild);
	}
	getEmployeeList(selectedYear);
}

function getEmployeeList(year) {
	selectedYear = year;
	
	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/getEmployeeOfMonthList.do",
		dataType : "JSON",
		data : {year: selectedYear},
		success : function(result) {
			renderList(result.list);
		}
	});
}

function renderList(result) {
	var mainList = document.getElementById("mainlist");
	
	for (var month = 1; month < 13; month++) {
		var liElmt         = document.createElement("li");
		var empBttnDivElmt = document.createElement("div");
		var empInfoDivElmt = document.createElement("div");
		var empAddDivElmt  = document.createElement("div");
		var titleElmt      = document.createElement("p");
		
		liElmt.className = "employee";
		empBttnDivElmt.className = "empBttn";
		empInfoDivElmt.className = "empInfo";
		empAddDivElmt.className = "empAdd";
		
		titleElmt.textContent = month + strLangkhj26;
		
		result.forEach(function(item, index) {
			if (month == item.term.substring(5)) {
				var updBttnElmt   = document.createElement("img");
				var delBttnElmt   = document.createElement("span");
				var empImgDivElmt = document.createElement("div");
				var dlElmt        = document.createElement("dl");
				var dtElmt        = document.createElement("dt");
				var imgElmt       = document.createElement("img");
				var ddElmt1       = document.createElement("dd");
				var ddElmt2       = document.createElement("dd");
				var ddElmt3       = document.createElement("dd");
				
				delBttnElmt.className = "sub_iconLNB tree_delete";
				empImgDivElmt.className = "empImg";
				
				updBttnElmt.setAttribute("src", "/images/admin/slideUpdate.png");
				delBttnElmt.setAttribute("src", "/images/admin/slideDelete.png");
				
				updBttnElmt.addEventListener("click", function(event) {btn_modify(item.term);});
				delBttnElmt.addEventListener("click", function(event) {btn_delete(item.term);});
				
				imgElmt.style.border = "1px solid #999";
				imgElmt.setAttribute("src", item.filePath);
				imgElmt.addEventListener("click", function(event) {OpenUserInfo(item.cn);});
				
				ddElmt1.className = "empCompany"
				ddElmt1.textContent = item.company;
				ddElmt2.textContent = item.description;
				ddElmt3.textContent = item.title + " " + item.displayName;
				
				empBttnDivElmt.appendChild(updBttnElmt);
				empBttnDivElmt.appendChild(delBttnElmt);
				
				dtElmt.appendChild(imgElmt);
				dlElmt.appendChild(dtElmt);
				dlElmt.appendChild(ddElmt1);
				dlElmt.appendChild(ddElmt2);
				dlElmt.appendChild(ddElmt3);
				
				empImgDivElmt.appendChild(dlElmt);
				empInfoDivElmt.appendChild(titleElmt);
				
				liElmt.appendChild(empBttnDivElmt);
				liElmt.appendChild(empInfoDivElmt);
				liElmt.appendChild(empImgDivElmt);
				
				return false;
			}
		});
		
		var imgElmt  = liElmt.getElementsByClassName("empImg")[0];
		if (!imgElmt) {
			var addBttnElmt    = document.createElement("img");
			var dlElmt         = document.createElement("dl");
			var dtElmt         = document.createElement("dt");
			var imgElmt        = document.createElement("img");
			var ddElmt1        = document.createElement("dd");
			var ddElmt2        = document.createElement("dd");
			
			ddElmt1.textContent = month + strLangkhj27;
			ddElmt2.textContent = strLangkhj28;
			
			addBttnElmt.setAttribute("id", "add_" + month);
			addBttnElmt.setAttribute("src", "/images/admin/slideAdd.png");
			addBttnElmt.addEventListener("click", function(event) {btn_add(this);});

			dtElmt.appendChild(addBttnElmt);
			dtElmt.appendChild(ddElmt1);
			dtElmt.appendChild(ddElmt2);
			dlElmt.appendChild(dtElmt);
			
			empInfoDivElmt.appendChild(titleElmt);
			empAddDivElmt.appendChild(dlElmt);
			
			liElmt.appendChild(empBttnDivElmt);
			liElmt.appendChild(empInfoDivElmt);
			liElmt.appendChild(empAddDivElmt);
		}
		
		mainList.appendChild(liElmt);
	}
}

function OpenUserInfo(pUserID) {
	var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	var left = (width - 500) / 2;
	var top = (heigth - 400) / 2;
	window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
}

var selectperson_cross_dialogArguments = new Array();
function btn_add(obj) {
	if (popup) {popup.close();} 
	
	selectperson_cross_dialogArguments[1] = btn_add_Complete;
	
	var month = obj.getAttribute("id");
	var term = selectedYear + "-" + month.substring(4);
	selectedTerm = term;
	
	selectperson_cross_dialogArguments[1] = btn_add_Complete;
	var SelectPerson_cross = window.open("/ezPersonal/selectPerson.do?type=EMP", "SelectPerson", GetOpenWindowfeature(760, 535));
	popup = SelectPerson_cross;
	try { SelectPerson_cross.focus(); } catch (e) { }
	
}

function btn_add_Complete(rtv) {
	if (typeof (rtv) != "undefined") {
		var userId = rtv.split(":")[0];
		var deptId = rtv.split(":")[4];
	}
	
	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/setEmployeeMonth.do",
		async : true,
		data : {type : "INS", userID : userId, deptID : deptId, term : selectedTerm},
		dataType : "text",
		success : function (result) {
			if (result != "OK") {
				alert(strLangkhj29);
			} else {
				alert(strLangkhj30);
				window.close();
				//window.location.reload(false);
				changeYear();
			}
		}
	});
}

function btn_modify(term) {
	if (popup) {popup.close();} 
	
	selectperson_cross_dialogArguments[1] = btn_modify_Complete;
	selectedTerm = term;
	
	var SelectPerson_cross = window.open("/ezPersonal/selectPerson.do?type=EMP", "SelectPerson", GetOpenWindowfeature(760, 535));
	popup = SelectPerson_cross;
	
	try { SelectPerson_cross.focus(); } catch (e) { }
}

function btn_modify_Complete(rtv) {
	if (typeof (rtv) != "undefined") {
		var userId = rtv.split(":")[0];
		var deptId = rtv.split(":")[4];
	}
	
	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/setEmployeeMonth.do",
		async : true,
		data : {type : "UPD", userID : userId, deptID : deptId, term : selectedTerm},
		dataType : "text",
		success : function (result) {
			if (result != "OK") {
				alert(strLangkhj29);
			} else {
				alert(strLangkhj30);
				window.close();
				//window.location.reload(false);
				changeYear();
			}
		}
	});
}

function btn_delete(term) {
	if (confirm(strLangkhj24)) {
		$.ajax({
			type : "POST",
			url : "/admin/ezPersonal/setEmployeeMonth.do",
			async : false,
			data : {type : "DEL", userID : "", deptID : "", term : term},
			dataType : "text",
			success : function (result) {
				if (result != "OK") {
					alert(strLangkhj31);
				} else {
					alert(strLangkhj25);
					//window.location.reload(false);
					changeYear();
				}
			}
		});
	}
}