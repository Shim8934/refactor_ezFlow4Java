function GetOpenWindowfeature(popUpW, popUpH) {
	var heigth   = window.screen.availHeight;
	var width    = window.screen.availWidth;
	var left     = 0;
	var top      = 0;
	var pleftpos = parseInt(width) - popUpW;
	heigth       = parseInt(heigth) - popUpH;
	width        = parseInt(width) - pleftpos;
	left         = pleftpos / 2;
	top          = heigth / 2;
	var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
	return feature;
}

function DivPopUpShow(popUpW, popUpH, URL) {
	try {
		var position = DivPopUpPosition(popUpW, popUpH);
		
		document.getElementById("iFrameLayer").src           = URL;
		document.getElementById("iFramePanel").style.top     = position[0] + "px";
		document.getElementById("iFramePanel").style.right   = position[1] + "px";
		document.getElementById("iFramePanel").style.height  = popUpH + "px";
		document.getElementById("iFrameLayer").style.width   = popUpW + "px";
		document.getElementById("iFrameLayer").style.height  = popUpH + "px";
		document.getElementById("mailPanel").style.display   = "";
		document.getElementById("iFramePanel").style.display = "";
	} catch (e) {}
}

function DivPopUpHidden() {
	try {
		document.getElementById("mailPanel").style.display   = "none";
		document.getElementById("iFramePanel").style.display = "none";
		document.getElementById("iFrameLayer").src           = "";
	} catch (e) {}
}

function DivPopUpPosition(popUpW, popUpH) {
	var returnValue = new Array();
	var heigth      = window.parent.document.documentElement.clientHeight;
	if (heigth == 0) {heigth = window.parent.document.body.clientHeight;}
	
	var width = window.parent.document.documentElement.clientWidth;
	if (width == 0) {width = window.parent.document.body.clientWidth;}
	
	var pleftpos = parseInt(width) - popUpW;
	heigth       = parseInt(heigth) - popUpH;
	
	if (heigth < (popUpH + 50)) {
		returnValue[0] = (heigth / 2);
	}
	else {
		returnValue[0] = (heigth / 2) - 50;
	}
	
	returnValue[1] = pleftpos / 2;
	return returnValue;
}

function closeAllPopup() {
	if (!!window.parent.frames["left"]) {
		var leftFrame = window.parent.frames["left"].document;
		leftFrame.body.style.overflow = "auto";
		var blockLeft = leftFrame.getElementById("bnkBlockLeft");
		blockLeft.style.height        = "100%";
		blockLeft.style.display       = "none";
		DivPopUpHidden();
	}
}

function showProgress() {
	if (typeof listLoading == "function") {
		listLoading(true);
	} else {
		var CurrentHeight = document.documentElement.clientHeight;
		var CurrenWidth = document.documentElement.clientWidth;
		document.getElementById("progressPanel").style.top = (CurrentHeight / 2) + "px";
		document.getElementById("progressPanel").style.left = (CurrenWidth / 2) - 100 + "px";
		document.getElementById("progressPanel").style.display = "block";
	}
}

function hideProgress() {
	if (typeof listLoading == "function") {
		listLoading(false);
	} else {
		document.getElementById("progressPanel").style.display = "none";
	}
}