(function() {
	var listModules = [];
	init();
	
	function init() {
		document.onselectstart = function() {return false;};
		var buttons = document.querySelectorAll("a[class='imgbtn']");
		buttons[0].firstElementChild.onclick = function(e) {setAllCheckBox(true);};
		buttons[1].firstElementChild.onclick = function(e) {setAllCheckBox(false);};
		buttons[2].firstElementChild.onclick = function(e) {save();};
		buttons[3].firstElementChild.onclick = function(e) {cancel();};
		
		var companyListElmt = document.getElementById("companyList");
		
		if (companyListElmt) {companyListElmt.addEventListener("change", function(e) {getModules();}, false);}
		
		setListModules();
	}
	
	function setListModules() {
		listModules = [];
		var activeInputs = document.querySelectorAll("input[type='radio'][role='on']");
		for (var i = 0, len = activeInputs.length; i < len; i++) {
			listModules.push({
				name   : activeInputs[i].getAttribute("name"),
				status : activeInputs[i].checked == true ? "on" : "off"
			});
		}
	}
	
	function setAllCheckBox(flag) {
		var radioOnList  = document.querySelectorAll("input[type='radio'][role='on']");
		var radioOffList = document.querySelectorAll("input[type='radio'][role='off']");
		
		for (var i = 0, len = radioOnList.length; i < len; i++) {
			radioOnList[i].checked  = flag;
			radioOffList[i].checked = flag == true ? false : true;
		}
	}
	
	function getAllModulesInfo() {
		var moduleList    = [];
		var checkedInputs = document.querySelectorAll("input[type='radio']:checked");
		
		for (var i = 0, len = checkedInputs.length; i < len; i++) {
			var moduleName = checkedInputs[i].getAttribute("name");
			var activeType = checkedInputs[i].getAttribute("role") == "on" ? 1 : 0;
			moduleList.push({
				module  : moduleName,
				actType : activeType
			});
		}
		
		return JSON.stringify(moduleList);
	}
	
	function getModules() {
		var url  = "/admin/ezCabinet/getModules.do";
		var data = {"companyId" : document.getElementById("companyList").value};
		
		makeAjaxCall (data, "GET", url, checkingData, null, true, null);
	}
	
	function checkingData(data) {
		var code = data.code;
		switch(code) {
			case 0 : processData(data.modules)         ; break;
			case 1 : alert(CabinetMessages.strParamErr); break;
			case 2 : alert(CabinetMessages.strError)   ; break;
			default: alert(CabinetMessages.strError)   ; return; 
		}
	}
	
	function processData(modules) {
		if (!modules || modules.length == 0) {alert(CabinetMessages.strError); return;}
		
		for (var i = 0, len = modules.length; i < len; i++) {
			var module        = modules[i];
			var moduleType    = module["moduleType"];
			var activeStatus  = module["activeStatus"] == 1 ? "on" : "off";
			document.querySelector("input[type='radio'][name='" + moduleType + "'][role='" + activeStatus + "']").checked = true;
		}
		
		setListModules();
	}
	
	function cancel() {
		for (var i = 0, len = listModules.length; i < len; i++) {
			document.querySelector("input[type='radio'][name='" + listModules[i]["name"] + "'][role='" + listModules[i]["status"] + "']").checked = true;
		}
	}
	
	function save() {
		var companyListElmt = document.getElementById("companyList");
		var url             = "";
		var data            = null;
		
		if (companyListElmt) {
			url  = "/admin/ezCabinet/saveModules.do";
			data = {
				"modules"   : getAllModulesInfo(),
				"companyId" : document.getElementById("companyList").value
			};
		}
		else {
			url  = "/ezCabinet/saveModules.do";
			data = {"modules"   : getAllModulesInfo()};
		}
		
		makeAjaxCall (data, "GET", url, afterSaveChange, null, true, null);
	}
	
	function afterSaveChange(data) {
		console.log("Code: " + code);
		var code = data.code;
		switch(code) {
			case 0 : alert(CabinetMessages.strSave)    ; break;
			case 1 : alert(CabinetMessages.strParamErr); break;
			case 2 : alert(CabinetMessages.strError)   ; break;
			default: alert(CabinetMessages.strError)   ; return; 
		}
	}
	
	function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode) {
		$.ajax({
			type: ajaxType,
			url: ajaxUrl,
			data: ajaxData,
			dataType: "JSON",
			async: asyncMode != false ? true : false,
			success : function(data) {
				handleSuccess(data);
			},
			error : function(error) {
				if (handleError != null) {handleError();}
				
				alert(CabinetMessages.strError);
			}
		});
	}
})();