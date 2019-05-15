/**
 * 컨텍스트 메뉴
 */
var timelinePopupBtn = {
	paused: true,		
}

var animatePopupBtn = new TimelineLite(timelinePopupBtn);
animatePopupBtn.from('#popupMenuBtn', 0.45, {
	scale: '0',
	rotation: '-=135',
}, 0, 0); 

animatePopupBtn.eventCallback('onStart', function() {
	document.getElementById('contextMenuBtn').style.background = '#3398fe';
	document.getElementById('contextMenuBtn').style.opacity = '1';
});

animatePopupBtn.eventCallback('onReverseComplete', function () {
	document.getElementById('contextMenuBtn').style.opacity = '0.7';
	document.getElementById('contextMenuBtn').style.background = '#0470e4';
})

var contextMenuObject = {
	bottom: '',
	right: '',
	menuRadius: '',
	replaceAll: function(str, searchStr, replaceStr) {
		return str.split(searchStr).join(replaceStr);	
	},
	popupMenu: false,
	memoFlag: memoFlag,
	userDeptId: ''
}

/* 결재 연동을 위한 소스 시작 */
var checkBrowser = function () {
	var ua = navigator.userAgent;
	var result = true;

    // 크로스 브라우저 IE9이하:false IE외: true
    if (/msie 10/i.test(ua)){
        result = true;	
    }else if (/msie/i.test(ua)){
		result = false;
	}else if (/firefox/i.test(ua)){
		result = true;
	}else if (/chrome/i.test(ua)){
		result = true;
	}else if (/safari/i.test(ua)){
		result = true;
	}else if (/opera/i.test(ua)){
		result = true;
	}else if (/trident/i.test(ua)){
		result = true;
	}
	
    return result;
}
	
var openWindowForAppr = function (wfileLocation) {
    var height = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;

    if (window.screen.width > 800) {
        var pleftpos;
        pleftpos = parseInt(width) - 1150;
        height = parseInt(height) - 30;
        
        if (checkBrowser())	height = parseInt(height) - 25;

        if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
        	height = parseInt(height) - 40;
        }

        width = parseInt(width) - pleftpos;
        
        left = pleftpos / 2;
    } else {
    	height = parseInt(height) - 30;
        
        if (checkBrowser()) eight = parseInt(height) - 25;

        if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
        	height = parseInt(height) - 40;
        }
        
        width = parseInt(width) - 10;
    }
    window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + height + ",width=" + width + ",top=" + top + ",left = " + left);
}
			

var getOpenWindowfeature = function (popUpW, popUpH) {

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
	var feature = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
	return feature;
}

var formURL = "";
var formDocType = "";
var getformcont_cross_dialogArguments = new Array();
var url = "";

var openForm_Complete = function (ret) {
    formURL = ret[0];
    formDocType = ret[1];

    if (formURL != "cancel") {
        openDraftUI();
    }
}

var openForm = function () {
    var parameter = new Array();
    parameter[0] = contextMenuObject.userDeptId;
    parameter[1] = "A01000";
    
    url = "/ezApprovalG/getFormCont.do";
    
    if (checkBrowser()) {
        getformcont_cross_dialogArguments[0] = parameter;
        getformcont_cross_dialogArguments[1] = openForm_Complete;
        var getFormCont_Cross = window.open(url, "/ezApprovalG/getFormCont.do", getOpenWindowfeature(713, 570));
        
        try { getFormCont_Cross.focus(); } catch (e) {}
    } else {
        var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
        var ret = window.showModalDialog(url, parameter, feature);
        formURL = ret[0];
        formDocType = ret[1];
        
        if (formURL != "cancel") {
            openDraftUI(formURL, formDocType);
        }
    }
}

var openDraftUI = function () {
    var pArgument = new Array();
    var gb = "";
    
    if ("${userApprovalG}" == ("YES"))
        gb = "G";
    
	pArgument[0] = "${userInfo.id}";
    pArgument[1] = formURL;
    pArgument[2] = "DRAFT";
    pArgument[3] = formDocType;
    pArgument[4] = "0"
    pArgument[5] = ""
    pArgument[6] = ""
    pArgument[7] = "";

    var openLocation = "";
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
        if (!isIE()) {
            alert(messages.strLang16);
            return;
        } else {
           var openLocation = "/ezApprovalG/draftuiHWP.do";
        }
    } else {
        var openLocation = "/ezApprovalG/draftui.do";
    }
    
    openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
    openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1" + "&aprState=" + escape(pArgument[6]);
    openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
    
    openWindowForAppr(openLocation);
}
/* 결재 연동을 위한 소스 끝 */

var handleQuickMenuOpen = function (menu) {
	var url = '';
	var location = '';
	var option = '';
	
	var pheight = window.screen.availHeight;
	var conHeight = pheight * 0.8;
	var pwidth = window.screen.availWidth;
	var conWidth = pwidth * 0.8;			
			
	if (conWidth > 890) conWidth = 890;
		        
	var pTop = (pheight - conHeight) / 2;
	var pLeft = (pwidth - 890) / 2;			

	switch (menu) {
		case 'mail':    
		    url = '/ezEmail/mailWrite.do?cmd=NEW';
			location = '';
			option = 'top='+pTop+', left='+pLeft+', height='+conHeight+', width='+conWidth+', status=no, toolbar=no, menubar=no, location=no, resizable=1';
			break;
		case 'appr':
			openForm();
			break;
		case 'schedule':		
			url = '/ezSchedule/scheduleWrite.do?defaultid=0';
			location = '';
			pTop = (pheight - 819) / 2;
			pLeft = (pwidth - 890) / 2;	
			option = 'top='+pTop+', left='+pLeft+ ',height='+ '802' +', width='+'890'+', status=no, toolbar=no, menubar=no, location=no, resizable=1';			
			break;
		case 'organ':
			url = '/ezPersonal/personSearch.do';
			pTop = (pheight - 659) / 2;
			pLeft = (pwidth - 715) / 2;	
			option = 'top='+pTop+', left='+pLeft+ ',height=560px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0';			
			break;
	}
	
	if(menu!=='appr' && menu!=='memo') window.open(url, location, option);
}

var setImageName = function (type) {
	var span = document.createElement('span');
	var textContent;

	if(type === 'mail') {
		textContent = messages.strLang18;
	} else if(type ===  'appr') {
		textContent = messages.strLang19;
	} else if(type === 'schedule') {
		textContent = messages.strLang20;
	} else if(type === 'organ') {
		textContent = messages.strLang21;
	} else if(type === 'memo') {
		textContent = messages.strLang22;
	}
	span.textContent = textContent;
	span.className = 'image-name';	
	
	return span;
}

var setImageElement = function (parent, imgsrc, type) {
	var buttonDiv = document.createElement('div');
	buttonDiv.className = 'quickMenuBtnDiv';
	buttonDiv.style.height = '50px';

	var imageWrap = document.createElement('div');
	var imageElement = document.createElement('img');
	imageElement.src = imgsrc;
	imageElement.dataset.type = type;
	setImageName(type);
	if(type !== 'memo') {
		buttonDiv.addEventListener('click', function () {
			handleQuickMenuOpen(type);
		});		
	} else {
		imageElement.id = 'open-memo';
		buttonDiv.addEventListener('click', function(event) {
			event.preventDefault();
			//if(document.getElementById('layer-popup').style.display === 'none') {
			if(document.getElementById('layer-popup').style.visibility === 'hidden') {
				document.getElementById('noteBlock').style.visibility = 'visible';
				document.getElementById('layer-popup').style.visibility = 'visible';
				document.getElementById('contextMenuBlock').style.display = 'none';
			} else {
				//document.getElementById('layer-popup').style.display = 'none';
				document.getElementById('layer-popup').style.visibility = 'hidden';
				document.getElementById('contextMenuBlock').style.display = '';	
			}
			layerExpand();
		});
	}
	
	imageWrap.appendChild(imageElement);

	buttonDiv.appendChild(imageWrap);
	buttonDiv.appendChild(setImageName(type));
	
	parent.appendChild(buttonDiv);
}

var setQuickMenuBtnImg = function () {
	
	var menuBtnImg = 
		['/images/contextmenu/mail.png',  // 메일
		 '/images/contextmenu/approval.png',  // 결재
		 '/images/contextmenu/schedule.png',  // 일정
		 '/images/contextmenu/organ.png']; // 조직도
	
	var menuBtnSpans = document.getElementById('quickMenuBtn').childNodes;
	
	[].filter.call(menuBtnSpans, function(btnSpan) {
		if(btnSpan.className.indexOf('quickMenuTop') > -1) {
			setImageElement(btnSpan, menuBtnImg[0], 'mail');
		} else if(btnSpan.className.indexOf('quickMenuMiddle') > -1) {
			setImageElement(btnSpan, menuBtnImg[1], 'appr');
			setImageElement(btnSpan, menuBtnImg[2], 'schedule');
		} else if(btnSpan.className.indexOf('quickMenuBottom') > -1) {
			setImageElement(btnSpan, menuBtnImg[3], 'organ');
			if (contextMenuObject.memoFlag === 'YES') {
				setImageElement(btnSpan, '/images/contextmenu/memo.png', 'memo'); // 메모
			}
		}
	});
}

var setQuickMenuBtn = function () {
	var quickMenuBtn = document.getElementById('quickMenuBtn');
	
	while(quickMenuBtn.firstChild) {
		quickMenuBtn.removeChild(quickMenuBtn.firstChild);	
	}
	
	var btnClassNames;
	
	handleMemoFlag();
	if (contextMenuObject.memoFlag === 'YES') {
		btnClassNames = ['quickMenuTop_memo', 'quickMenuMiddle_memo', 'quickMenuBottom_memo'];
	} else {
		btnClassNames = ['quickMenuTop', 'quickMenuMiddle', 'quickMenuBottom'];	
	}
	
	btnClassNames.map(function(btnClassName) {
		var span = document.createElement('span');
		span.className = btnClassName;
		span.id = btnClassName;
		quickMenuBtn.appendChild(span);
	});
	
	setQuickMenuBtnImg();	
}

var getContextMenuPostion = function () {
	var contextMenuBtn = document.getElementById('contextMenuBtn');
	
	var offsetTop = contextMenuBtn.offsetTop;
	var offsetLeft = contextMenuBtn.offsetLeft;
	
	var windowHeight = Number(window.innerHeight);
	var windowWidth = Number(window.innerWidth);
	
	var menuHeight = contextMenuObject.replaceAll(getComputedStyle(contextMenuBtn).height, 'px', '');
	var menuWidth = contextMenuObject.replaceAll(getComputedStyle(contextMenuBtn).width, 'px', '');
	
	var offsetBottom = windowHeight - menuHeight - offsetTop;
	var offsetRight = windowWidth - menuWidth - offsetLeft;
	
	var obj = {
		offsetTop: offsetTop,
		offsetLeft: offsetLeft,
		offsetBottom: offsetBottom,
		offsetRight: offsetRight,
	}
	
	return obj;
}
	
var setConextMenuPositionResize = function () {
	
	var obj = getContextMenuPostion();
	var contextMenuBtn = document.getElementById('contextMenuBtn');

	if (Number(obj.offsetTop) < 0 ) {
		contextMenuBtn.style.bottom = '';
		contextMenuBtn.style.top = '0';
	}
	
	if (Number(obj.offsetLeft) < 0 ) {
		contextMenuBtn.style.right = '';
		contextMenuBtn.style.left = '0';		
	}

}

var checkPopupMenuPosition = function () {
	var popupMenuBtn = document.getElementById('popupMenuBtn');
	var popupMenuCss = getComputedStyle(popupMenuBtn);
	var top = contextMenuObject.replaceAll(popupMenuCss.top, 'px', '');
	var left = contextMenuObject.replaceAll(popupMenuCss.left, 'px', '');
	var right = contextMenuObject.replaceAll(popupMenuCss.right, 'px', '');
	var bottom = contextMenuObject.replaceAll(popupMenuCss.bottom, 'px', '');
	
	var width = contextMenuObject.replaceAll(popupMenuCss.width, 'px', '');
	var popupMenuRadius = Number(width) / 2;	
	
	var isRight = false;
	var isBottom = false;
	
	var contextMenuBtn = document.getElementById('contextMenuBtn');

	if (right < 0) {
		isRight = true;
		popupMenuBtn.style.right = '0';
		contextMenuBtn.style.left = '';
		contextMenuBtn.style.right = (popupMenuRadius - contextMenuObject.menuRadius) + 'px';
	}
	if (bottom < 0) {
		isBottom = true;
		popupMenuBtn.style.bottom = '0';
		contextMenuBtn.style.top = '';
		contextMenuBtn.style.bottom = (popupMenuRadius - contextMenuObject.menuRadius) + 'px';
	}	
	
	if (!isBottom && (top < 0 || top === 'auto')) {
		popupMenuBtn.style.top = '0';
		contextMenuBtn.style.bottom = '';
		contextMenuBtn.style.top = (popupMenuRadius - contextMenuObject.menuRadius) + 'px';
	}
	
	if (!isRight && (left < 0 || left === 'auto')) {
		popupMenuBtn.style.left = '0';
		contextMenuBtn.style.right = '';
		contextMenuBtn.style.left = (popupMenuRadius - contextMenuObject.menuRadius) + 'px';
	}

	
	var obj = getContextMenuPostion();
	if(contextMenuBtn.style.left && contextMenuBtn.style.right) {
		contextMenuBtn.style.left = '';		
	}
	if(contextMenuBtn.style.top && contextMenuBtn.style.bottom) {
		contextMenuBtn.style.top = '';		
	}	
}

var setMenuPostionResize = function () {
	if(contextMenuObject.popupMenu) {
		checkPopupMenuPosition();
	} else {
		setConextMenuPositionResize();	
	}
}


var setContextMenuGadgetPosition = function () {
	var obj = getContextMenuPostion();
	
	var xhr = new XMLHttpRequest();
    xhr.onload = function () {
        if (xhr.status >= 200 && xhr.status < 300) {
        } else {
            console.error(xhr.responseText);
        }
    }
    xhr.open('POST', '/ezMemo/setGadgetPosition.do', false);
    
    var formData = new FormData();
    formData.append('gadgetBottom', obj.offsetBottom);
    formData.append('gadgetRight', obj.offsetRight);
    xhr.send(formData);
}

var handlePopupMenuBtn = function (type) {
	if (type === 'on') {
		animatePopupBtn.play();
		contextMenuObject.popupMenu = true;
		$('#contextMenuBtn').draggable('disable');		
	} else if (type === 'off') {
		$('#contextMenuBtn').draggable('enable');
		animatePopupBtn.reverse();
		contextMenuObject.popupMenu = false;
	} else if (type === 'ing') {
		contextMenuObject.popupMenu = true;
		$('#contextMenuBtn').draggable('disable');
	}
}

var setRightAndBottom = function () {
	var obj = getContextMenuPostion();

	contextMenuObject.bottom = obj.offsetBottom;
	contextMenuObject.right = obj.offsetRight;
}

var moveContextMenu = function () {
	document.getElementById('popupMenuBtn').style.visibility = 'visible';
	
	if(!contextMenuObject.popupMenu) {
		setPopupMenuPosition();
		handlePopupMenuBtn('on');
		return;
	}
	handlePopupMenuBtn('off');	
}

var checkContextMenuPosition = function () {
	var obj = getContextMenuPostion();
	var popupMenuBtn = document.getElementById('popupMenuBtn');
	var popupMenuCss = getComputedStyle(popupMenuBtn);
	var width = contextMenuObject.replaceAll(popupMenuCss.width, 'px', '');
	var popupMenuRadius = Number(width) / 2;
	var menuRadius = contextMenuObject.menuRadius;
	
	var contextMenuBtn = document.getElementById('contextMenuBtn');
	var isChanged = false;
	
	var tmpTop = obj.offsetTop;
	var tmpLeft = obj.offsetLeft;
	
	if(popupMenuRadius > Number(obj.offsetTop) + menuRadius) {
		tmpTop = popupMenuRadius - menuRadius;// + 'px';
		isChanged = true;
	} 
	if (popupMenuRadius > Number(obj.offsetLeft) + menuRadius) {
		tmpLeft = popupMenuRadius - menuRadius;// + 'px';
		isChanged = true;
	} 
	if (popupMenuRadius > Number(obj.offsetBottom) + menuRadius) {
		var windowHeight = Number(window.innerHeight);
		tmpTop = (windowHeight - (popupMenuRadius + menuRadius));// + 'px';
		isChanged = true;
	} 
	if (popupMenuRadius > Number(obj.offsetRight) + menuRadius) {
		var windowWidth = Number(window.innerWidth);		
		tmpLeft = (windowWidth - (popupMenuRadius + menuRadius));// + 'px';
		isChanged = true;
	}
	if(isChanged) {
		$('#contextMenuBtn').css({
			'top': obj.offsetTop, 
			'left' : obj.offsetLeft
		});
		$('#contextMenuBtn').animate({
			top: tmpTop,
			left: tmpLeft,
		}, 100 , function() {
			setRightAndBottom();
			moveContextMenu();
		});		
	} else {
		moveContextMenu();
	}
}

var handleMemoFlag = function () {
	if(!useMemoContextMenu) {
		contextMenuObject.memoFlag = 'NO';
		return;
	}
	contextMenuObject.memoFlag = 'YES';
}


var setContextMenuEvent = function () {
	$('#contextMenuBtn').draggable({
		containment : "#contextMenuBlock",
		scroll: false, 
		start: function () {
			handleContextMenuBlock(true);	
		},
		stop: function() {
			setContextMenuGadgetPosition();
			getContextMenuPosition();
			handleContextMenuBlock(false);
		},
	});
	
	var contextMenuBtn = document.getElementById('contextMenuBtn');
	
	contextMenuBtn.addEventListener('click', function (event) {
		setQuickMenuBtn();
		checkContextMenuPosition();
	});	
}

var handleContextMenuBlock = function (type) {
	var contextMenuBlock = document.getElementById('contextMenuBlock');
	if(!type) {
		contextMenuBlock.style.visibility = 'hidden';
		return;
	}
	contextMenuBlock.style.visibility = 'visible';
}

var setPopupMenuPosition = function () {
	var popupMenuBtn = document.getElementById('popupMenuBtn');
	var popupMenuCss = getComputedStyle(popupMenuBtn);
	
	var width = contextMenuObject.replaceAll(popupMenuCss.width, 'px', '');
	var height = contextMenuObject.replaceAll(popupMenuCss.height, 'px', '');
	var menuRadius = contextMenuObject.menuRadius;
	var distance = (width / 2) - menuRadius;

	popupMenuBtn.style.top = '';
	popupMenuBtn.style.left = '';
	popupMenuBtn.style.bottom = (contextMenuObject.bottom - distance) + 'px';
	popupMenuBtn.style.right = (contextMenuObject.right - distance) + 'px';
}


var setContextMenuPosition = function (config) {
	var bottom = config.memoConfigVO.gadget_bottom;
	var right = config.memoConfigVO.gadget_right;
	
	contextMenuObject.bottom = bottom;
	contextMenuObject.right = right;
	
	var contextMenuBtn = document.getElementById('contextMenuBtn');
	var contextMenuCss = getComputedStyle(contextMenuBtn);
	var width = contextMenuObject.replaceAll(contextMenuCss.width, 'px' ,'');
	var height = contextMenuObject.replaceAll(contextMenuCss.height, 'px','');
	
	contextMenuObject.menuRadius = width / 2;
	
	contextMenuBtn.style.top = '';
	contextMenuBtn.style.left = '';
	contextMenuBtn.style.bottom = bottom + 'px';
	contextMenuBtn.style.right = right + 'px';
	contextMenuBtn.style.visibility = 'visible';
}

var getContextMenuPosition = function () {
    var xhr = new XMLHttpRequest();
    xhr.onload = function () {
        if (xhr.status >= 200 && xhr.status < 300) {
        	var memoConfig = JSON.parse(xhr.responseText);
        	
        	if (memoConfig.memoConfigVO != null) {
        		setContextMenuPosition(JSON.parse(xhr.responseText));
        	} else {
        		console.log("start insert context menu config..");
        		insertContextMenuConfig();
        	}
        } else {
            console.error(xhr.responseText);
        }
    }

    xhr.open('GET', '/ezMemo/getMemoConfig.do', false);
    xhr.send();
};

//var contextMenuRePosition = function () {
//	
//	var contextMenuBtn = document.getElementById('contextMenuBtn');
//	var contextMenuCss = getComputedStyle(contextMenuBtn);
//	if (Number(contextMenuCss.bottom) < 0) {
//		contextMenuBtn.style.left = '';
//		contextMenuBtn.style.right = '';		
//		contextMenuBtn.style.top = 'auto';
//		contextMenuBtn.style.bottom = '15';
//	}
//	if (Number(contextMenuCss.right) < 0) {
//		contextMenuBtn.style.top = '';
//		contextMenuBtn.style.bottom = '';		
//		contextMenuBtn.style.left = 'auto';
//		contextMenuBtn.style.right = '15';
//	}
//}

var createContextMenu = function (userDeptId) {
	getContextMenuPosition();
	setContextMenuEvent();
	contextMenuObject.userDeptId = userDeptId;
}

var setMemoFlag = function (type) {
	contextMenuObject.memoFlag = type; 
}

/**
 * tenant config -- useMemo가 초기에 NO여도 값 세팅할 수 있도록 조절 
 * 초기 config값 insert 메서드
 */
function insertContextMenuConfig() {	
	$.ajax({
		type : "POST",
		dataType : "JSON",
		url : "/ezMemo/insertMemoConfig.do",
		success : function(result) {
			getContextMenuPosition();
		}
	});
}