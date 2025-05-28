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

function changeCompany() {
	changeYear();
}

function getEmployeeList(year) {
	selectedYear = year;
	
	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/getEmployeeOfMonthList.do",
		dataType : "JSON",
		data : {year: selectedYear, companyID : companySelectID},
		success : function(result) {
			renderList(result.list, selectedYear);
		}
	});
}

function renderList(result, selectedYear) {
	var mainList = document.getElementById("mainlist");
	var today = new Date();
	var thisMonth = today.getMonth() + 1;
	var thisYear = today.getFullYear();
	
	for (var month = 1; month < 13; month++) {
		var liElmt         = document.createElement("li");
		var monthElemt	   = document.createElement("p");
		var empTopElemt    = document.createElement("dl");
		var empBottomElemt = document.createElement("dl");
		var titleElmt      = document.createElement("span");
		
		/*var empBttnDivElmt = document.createElement("div");
		var empInfoDivElmt = document.createElement("div");
		var empAddDivElmt  = document.createElement("div");
		*/
		
		if (month === thisMonth && selectedYear == thisYear) {
			liElmt.className = "employee_blue";
		} else {
			liElmt.className = "employee";
		}
		monthElemt.className = "month_num";
		empTopElemt.className = "emTop";
		empBottomElemt.className = "emBottom";
		/*empBttnDivElmt.className = "empBttn";
		empInfoDivElmt.className = "empInfo";
		empAddDivElmt.className = "empAdd";*/
		
		var MonthList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var monthForString;
        monthForString = MonthList[month -1];
        monthElemt.textContent =  monthForString;
        titleElmt.textContent = '';
		
		monthElemt.appendChild(titleElmt);
		
		result.forEach(function(item, index) {
			if (month == item.term.substring(5)) {
				//삭제 부분
				var empDelElmt = document.createElement("p");
				var empDelSpan = document.createElement("span");
				//사원 사진
				var topDtElmt = document.createElement("dt");
				var topDdElmt = document.createElement("dd");
				//사원 정보
				var bottomCompElmt = document.createElement("dt");
				var bottomDeptElmt = document.createElement("dt");
				var bottomNameElmt = document.createElement("dd");
				
				//이미지
				var empPicElmt = document.createElement("img");
				var editElmt = document.createElement("img");
				
				/*var updBttnElmt   = document.createElement("img");*/
				/*var delBttnElmt   = document.createElement("span");
				var empImgDivElmt = document.createElement("div");
				var dlElmt        = document.createElement("dl");
				var dtElmt        = document.createElement("dt");
				var imgElmt       = document.createElement("img");
				var ddElmt1       = document.createElement("dd");
				var ddElmt2       = document.createElement("dd");
				var ddElmt3       = document.createElement("dd");
				*/
				empDelElmt.className = "emDelete";
				empDelSpan.className = "sub_iconLNB tree_delete";
				empDelSpan.style.cursor = "pointer";
				
				topDtElmt.className = "emPic";
				topDdElmt.className = "emEdit";
				
				bottomCompElmt.className = "emCompany";
				bottomDeptElmt.className = "emTeam";
				bottomNameElmt.className = "emName";
				
				//empImgDivElmt.className = "empImg";
				
				/*updBttnElmt.setAttribute("src", "/images/admin/slideUpdate.png");*/
				editElmt.src = "/images/admin/admin_employee_edit.png";
				//empDelSpan.setAttribute("src", "/images/admin/slideDelete.png");
				
				editElmt.addEventListener("click", function(event) {btn_modify(item.term);});
				empDelSpan.addEventListener("click", function(event) {btn_delete(item.term);});
				
				/*imgElmt.style.border = "1px solid #999";*/
				empPicElmt.setAttribute("src", item.filePath);
				empPicElmt.style.width = "84px";
				empPicElmt.style.height = "84px";
				empPicElmt.addEventListener("click", function(event) {OpenUserInfo(item.cn);});
				
				/*ddElmt1.className = "empCompany"*/
				bottomCompElmt.textContent = item.description;
				bottomDeptElmt.textContent = item.title;
				bottomNameElmt.textContent = '"' + item.displayName + '"';
				
				empDelElmt.appendChild(empDelSpan);
				topDtElmt.appendChild(empPicElmt);
				topDdElmt.appendChild(editElmt);
				
				empTopElemt.appendChild(topDtElmt);
				empTopElemt.appendChild(topDdElmt);
				
				empBottomElemt.appendChild(bottomCompElmt);
				empBottomElemt.appendChild(bottomDeptElmt);
				empBottomElemt.appendChild(bottomNameElmt);
				
				liElmt.appendChild(monthElemt);
				liElmt.appendChild(empDelElmt);
				liElmt.appendChild(empTopElemt);
				liElmt.appendChild(empBottomElemt);
				/*empBttnDivElmt.appendChild(delBttnElmt);
				
				dtElmt.appendChild(imgElmt);
				dlElmt.appendChild(dtElmt);
				dlElmt.appendChild(ddElmt1);
				dlElmt.appendChild(ddElmt2);
				dlElmt.appendChild(ddElmt3);
				
				empImgDivElmt.appendChild(dlElmt);
				empInfoDivElmt.appendChild(titleElmt);
				
				liElmt.appendChild(empBttnDivElmt);
				liElmt.appendChild(empInfoDivElmt);
				liElmt.appendChild(empImgDivElmt);*/
				
				return false;
			}
		});
		
		var imgElmt  = liElmt.getElementsByClassName("emPic")[0];
		
		if (!imgElmt) {
			var addBttnElmt    = document.createElement("img");
			//var dlElmt         = document.createElement("dl");
			var dtElmt         = document.createElement("dt");
			//var imgElmt        = document.createElement("img");
			/*var ddElmt1        = document.createElement("dd");
			var ddElmt2        = document.createElement("dd");*/
			var textElmt	   = document.createElement("dt");
			
			/*ddElmt1.textContent = month + strLangkhj27;*/
			textElmt.textContent = strLangkhj28;
			
			//addBttnElmt.setAttribute("id", "add_" + month);
			addBttnElmt.setAttribute("src", "/images/admin/addPlus.png");
			//addBttnElmt.addEventListener("click", function(event) {btn_add(this);});
			
			dtElmt.setAttribute("id", "add_" + month);
			dtElmt.addEventListener("click", function(event) {btn_add(this);});
			
			dtElmt.className = "emPic_add";
			textElmt.className = "emAdd_text";
			
			dtElmt.appendChild(addBttnElmt);
			
			empTopElemt.appendChild(dtElmt);
			empBottomElemt.appendChild(textElmt);
			
			liElmt.appendChild(monthElemt);
			liElmt.appendChild(empTopElemt);
			liElmt.appendChild(empBottomElemt);
			
			/*dtElmt.appendChild(ddElmt1);
			dtElmt.appendChild(ddElmt2);
			dlElmt.appendChild(dtElmt);*/
			
			/*empInfoDivElmt.appendChild(titleElmt);
			empAddDivElmt.appendChild(dlElmt);*/
			
			/*liElmt.appendChild(empBttnDivElmt);
			liElmt.appendChild(empInfoDivElmt);
			liElmt.appendChild(empAddDivElmt);*/
			
		}
		
		mainList.appendChild(liElmt);
	}
}

function OpenUserInfo(pUserID) {
	var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	var left = (width - 500) / 2;
	var top = (heigth - 400) / 2;
	window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
}

var selectperson_cross_dialogArguments = new Array();
function btn_add(obj) {
	if (popup) {popup.close();} 
	
	selectperson_cross_dialogArguments[1] = btn_add_Complete;
	
	var month = obj.getAttribute("id");
	var term = selectedYear + "-" + month.substring(4);
	selectedTerm = term;
	
	selectperson_cross_dialogArguments[1] = btn_add_Complete;
	var SelectPerson_cross = window.open("/ezPersonal/selectPerson.do?type=EMP&companyID=" + companySelectID, "SelectPerson", GetOpenWindowfeature(860, 535));
	popup = SelectPerson_cross;
	try { SelectPerson_cross.focus(); } catch (e) { }
	
}

function btn_add_Complete(rtv) {
	if (typeof (rtv) != "undefined") {
		var userId = rtv.split(":")[0];
		var deptId = rtv.split(":")[4];
		var jobName = rtv.split(":")[3]; // 같은 부서에 겸직이 되어있는경우 오류가 발생하여 직위 조건 추가

		if (jobName.includes("(겸)")) {
			jobName = jobName.replace("(겸)", "").trim();
		}
	}
	
	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/setEmployeeMonth.do",
		async : true,
		data : {type : "INS", userID : userId, deptID : deptId,companyID: companySelectID, term : selectedTerm, jobName : jobName},
		dataType : "text",
		success : function (result) {
			if (result != "OK") {
				//alert(strLangkhj29);
			} else {
				//alert(strLangkhj30);
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
	
	var SelectPerson_cross = window.open("/ezPersonal/selectPerson.do?type=EMP", "SelectPerson", GetOpenWindowfeature(860, 535));
	popup = SelectPerson_cross;
	
	try { SelectPerson_cross.focus(); } catch (e) { }
}

function btn_modify_Complete(rtv) {
	if (typeof (rtv) != "undefined") {
		var userId = rtv.split(":")[0];
		var deptId = rtv.split(":")[4];
		var jobName = rtv.split(":")[3]; // 같은 부서에 겸직이 되어있는경우 오류가 발생하여 직위 조건 추가

		if (jobName.includes("(겸)")) {
			jobName = jobName.replace("(겸)", "").trim();
		}
	}
	
	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/setEmployeeMonth.do",
		async : true,
		data : {type : "UPD", userID : userId, deptID : deptId, term : selectedTerm, jobName : jobName},
		dataType : "text",
		success : function (result) {
			if (result != "OK") {
				//alert(strLangkhj29);
			} else {
				//alert(strLangkhj30);
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
					//alert(strLangkhj31);
				} else {
					//alert(strLangkhj25);
					//window.location.reload(false);
					changeYear();
				}
			}
		});
	}
}