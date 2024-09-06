/* left menu over-out / show-hidden */
var currentTab;
var selTab1EI;
var selTab2EI;

function selToggleList(ulEl, selPTab, selTab, flag)
{
    currentTab = false;
    selTab1EI = ulEl.getElementsByTagName(selPTab);
    selTab2EI = ulEl.getElementsByTagName(selTab);
    for( var i = 0 ; i < selTab1EI.length ; i++ )
    {
        selTab1EI.item(i).tabNum = i;
    }
    
    for( var j = 0 ; j < selTab2EI.length ; j++ )
    {
		if( flag == "1" )
			selTab2EI.item(j).onclick = toggleList_Sub;
        selTab2EI.item(j).onmouseover = mouseOver_Sub;
		selTab2EI.item(j).onmouseout = mouseOut_Sub;
    }
    
    if (selTab1EI.length > 0) {
    	selTab1EI.item(0).className = selTab1EI.item(0).className.replace('off','on');
    }
     
    //KMS에서 사용합니다.
    if( parseInt(flag)>0 && selTab2EI.length > 0 )
    {
		selTab2EI.item(parseInt(flag)-1).className = "on";
		prevSelMenu = selTab2EI.item(parseInt(flag)-1);
    }
    
    /*
    if( flag == "1" && selTab2EI.length > 0 )
    {
		selTab2EI.item(0).className = "on";
		prevSelMenu = selTab2EI.item(0);
    }
    */
}

////////////////////////////////////////////////////////////////////////
// selToggleList가 한페이지에 2개 있을 때 사용
function selToggleList2(ulEl, selPTab, selTab, flag)
{
    currentTab = false;
    selTab1EI = ulEl.getElementsByTagName(selPTab);
    selTab2EI = ulEl.getElementsByTagName(selTab);
    for( var i = 0 ; i < selTab1EI.length ; i++ )
    {
        selTab1EI.item(i).tabNum = i;
    }
    
    for( var j = 0 ; j < selTab2EI.length ; j++ )
    {
		if( flag == "1" )
			selTab2EI.item(j).onclick = toggleList_Sub2;
		
        selTab2EI.item(j).onmouseover = mouseOver_Sub2;
		selTab2EI.item(j).onmouseout = mouseOut_Sub2;
    }
    if (selTab1EI.length > 0) {
    	selTab1EI.item(0).className = "on";
    }
     
    if( flag == "1" && selTab2EI.length > 0 )
    {
		selTab2EI.item(0).className = "on";
		prevSelMenu2 = selTab2EI.item(0);
    }
}
var prevSelMenu2 = null;
function toggleList_Sub2()
{
	if( prevSelMenu2 != null )
		prevSelMenu2.className = "off";
	
	this.className = "on";
	prevSelMenu2 = this;
}
function mouseOver_Sub2()
{
	if( prevSelMenu2 != this )
	{
		if (this.className == "important") {			
			this.className = "important on";
		} else {
			this.className = "on";
		}
	}
}
function mouseOut_Sub2()
{
	if( prevSelMenu2 != this )
	{
		if (this.className == "important") {
			this.className = "important off";
		} else {
			this.className = "off";
		}
	}
}
////////////////////////////////////////////////////////////////////////

var currentListNum;
var level1El;
var level2El;
var level3El;
function initToggleList(ulEl, level1, level2, level3)
{
	var elementItem;
	var elementCount;
    currentListNum = true;
    
    level1El = ulEl.getElementsByTagName(level1);
    level2El = ulEl.getElementsByTagName(level2);
    level3El = ulEl.getElementsByTagName(level3);
    
    elementCount = level1El.length;
    
    for (var i = 0; i < elementCount; i++) {
    	elementItem = level1El.item(i);
    	
    	elementItem.listNum = i;
    	elementItem.addEventListener("click", toggleList);
    	
    	elementItem = level2El.item(i);
			
    	elementItem.listNum = i;
    	elementItem.className = "off";
    	elementItem.subtag = level3;
	}
	
    elementCount = level3El.length;
    
	for(var j = 0; j < elementCount; j++) {
		elementItem = level3El.item(j);
		// 2018.01.16 jwseo99
		elementItem.addEventListener("click", toggleList_Sub);
		// 2018.01.16 jwseo99	span 태그가 아닌 영역을 클릭하면 li에 on 클래스만 박히는 문제 (span 태그의 글자는 굵어지지만 right 프레임이 갱신 안 됨)
		
		// IE에서 왼쪽 메뉴 중 팝업 메뉴를 오픈하는 메뉴를 클릭할 때 두 번 오픈되는 문제 수정
		/*
		var firstChild = elementItem.firstChild;
		// 만약 li의 첫 번재 자식이 span 태그라면 
		if(firstChild != undefined && firstChild.tagName === "SPAN") {
			// 해당 span 태그에 onclick 속성이 있다면
			if (firstChild.hasAttribute("onclick") && !elementItem.hasAttribute("onclick")) {
				// span의 onclick을 li로 옮긴다 (기존 span의 onclick 삭제)
				// addEventListener를 안 쓰는 이유: 어떤 클릭 이벤트가 발생되는지 디버깅이 힘듦
				elementItem.setAttribute("onclick", firstChild.getAttribute("onclick"));
				firstChild.removeAttribute("onclick");
			}
		}
		*/
		
		//
		elementItem.onmouseover = mouseOver_Sub;
		elementItem.onmouseout = mouseOut_Sub;
	}
	
	level2El.item(0).className = "on";
	level1El.item(0).className = "on";
}

function toggleList() {
    //level1El.item(0).className = "off";
    //level2El.item(0).className = "off";

    if (currentListNum && currentListNum != this.listNum + 1) {
        level1El.item(currentListNum - 1).className = null;
        level2El.item(currentListNum - 1).className = "off";
    }

    //커뮤니티 회원가입.회원탈퇴 창이 2번뜨는것을 방지하기위해서 클릭 시점에서 분기할때 조건으로 추가하여 위의 소스를 건너뛰도록 했음 2007-12-02
    //2009.03.19 : 게시판관리자 메뉴 클릭 시 alert()창 2번뜨는것 방지, BoardAdminLeftOn 추가
    var itemId = level2El.item(this.listNum).previousSibling.id;
    if (level2El.item(this.listNum).className == "on"  && (itemId != undefined &&
	    (itemId == "btn_Manager" || itemId == "Del_Cache" || itemId == "btn_MemberIn" || itemId == "btn_MemberOut"
	    || GetAttribute(level2El.item(this.listNum).previousSibling, 'name') == "BoardAdminLeftOn"
	    || itemId == "searchBoard" || itemId == "btn_MemberJoinIng" || itemId == "btn_MemberInfo"
	    	//2018-07-24 이효진 전자결재G LEFT메뉴 toggle
//        || itemId == "m01" || itemId == "m02" || itemId == "m03" || itemId == "m04" || itemId == "m05" || itemId == "m06" || itemId == "m07" || itemId == "m08" || itemId == "m09"))) {
    	))) {
        level1El.item(this.listNum).className = null;
        level2El.item(this.listNum).className = "off";
    }
    else {
        level1El.item(this.listNum).className = "on";
        level1El.item(this.listNum).className = "on";
        //게시판명 옆에 화살표버튼을 클릭하면 해당 게시판의 
        //하위 게시판트리가 보이지 않고, 리스트페이지도 변경되지 안는것 패치.
        //if(level1El.item(this.listNum).children(0) != undefined)
        //2011.01.25 cop 관리자메뉴 두번 호출되는 오류 처리
//        if (level1El.item(this.listNum).children.length > 0 && level1El.item(this.listNum).children[0].id != undefined && level1El.item(this.listNum).children[0].id != "") {
//            //window.event.srcElement.id = level1El.item(this.listNum).children[0].id;
//            if (!CrossYN()){
//                //level1El.item(this.listNum).children[0].onclick();
//            }else{
//                //level1El.item(this.listNum).children[0].onclick;
//            }
//        }
        level2El.item(this.listNum).className = "on";
    }

    currentListNum = this.listNum + 1;

    setMenu(level2El.item(this.listNum));
}

var prevSelMenu = null;
function toggleList_Sub(event)
{
	if( prevSelMenu != null )
		prevSelMenu.className = "off";
	
	this.className = "on";
	prevSelMenu = this;
}

function mouseOver_Sub()
{	
	if( prevSelMenu != this )
	{
		if (this.className.indexOf("important") > -1) {
			this.className = "important on ing";
		} else {
			//this.className = "on ing";
			this.className = this.className.replace('off','on ing');
		}
	}
}

function mouseOut_Sub()
{
	if( prevSelMenu != this )
	{
		if (this.className.indexOf("important") > -1) {
			this.className = "important off";
		} else {
			this.className = this.className.replace('off','on ing');
		}
	}
}

function setMenu(obj)
{
	var subTags = obj.getElementsByTagName(obj.subtag);
	if( subTags.length > 0 )
	{
		if( subTags.item(0).evt != "0" )
		{
			if( prevSelMenu != null )
				prevSelMenu.className = "off";
			
			subTags.item(0).className = "on";
			prevSelMenu = subTags.item(0);
		}
	}
}

// Disabled Image  
function SwapImage(obj,flag) 
{
	var pSrc = "";
	var pImgName ="";

	if( obj != null )
	{
	    pSrc = GetChildNodes(obj)[0].src;
		
		if ( flag == "dis")
		{
			if (pSrc.indexOf("_dis.gif") == -1)
			{
		
				pImgName= pSrc.substr(pSrc.lastIndexOf("/")+1,(pSrc.lastIndexOf(".")-pSrc.lastIndexOf("/")-1));
				GetChildNodes(obj)[0].src = "/images/" + pImgName + "_dis.gif";
			}
		}
		else
		{
			if (pSrc.indexOf("_dis.gif") == -1)
			{
				pImgName= pSrc.substr(pSrc.lastIndexOf("/")+1,(pSrc.lastIndexOf(".")-pSrc.lastIndexOf("/")-1));
			}
			else
			{
				pImgName= pSrc.substr(pSrc.lastIndexOf("/")+1,(pSrc.lastIndexOf("_")-pSrc.lastIndexOf("/")-1));
			}
		
			GetChildNodes(obj)[0].src = "/images/" + pImgName + ".gif";
		}
	}
}

function SetFormProc_SetLineStyle(obj) {
    try {
        var styleTag;
        if (obj.editor.DOM.getElementsByTagName("style").length > 0) {
            styleTag = obj.editor.DOM.getElementsByTagName("style").item(0);
        }
        else {
            styleTag = obj.editor.DOM.createElement("style");
            styleTag.setAttribute("title", "ezform_style_1");
            var head = obj.editor.DOM.getElementsByTagName("head")[0];
            head.appendChild(styleTag);
        }
        var sheet = styleTag.sheet ? styleTag.sheet : styleTag.styleSheet;
        if (sheet.insertRule) {
            sheet.insertRule("P {LINE-HEIGHT: 1.2; MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm}", 0);
            sheet.insertRule("div {LINE-HEIGHT: 1.2; MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm}", 0);
        }
        else {
            sheet.addRule("P", "LINE-HEIGHT: 1.2; MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm;", 0);
            sheet.addRule("DIV", "LINE-HEIGHT: 1.2; MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm;", 0);
        }

        // <style title=\"ezform_style_1\">P {LINE-HEIGHT: 1.2; MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm} div {LINE-HEIGHT: 1.2; MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm}</style>
    } catch (e) { }
}

function utcDate(offset){
	var today = new Date();
	today.setTime(today.getTime()+(1000*60*offset));
	var utcTime = new Date(today).toISOString().substring(0,10);
	
	return utcTime;
}

function utcDate2(offset){
	var today = new Date();
	today.setTime(today.getTime()+(1000*60*offset));
	return new Date(today.toUTCString().replace(" GMT", "").replace(" UTC", ""));
}

function specialChk(val){
	var special_pattern = /[`^|\\\'\"\/]/gi;
	var rVal = false;
	
	if (special_pattern.test(val) == true ){	    
	    rVal = true;
	}
	return rVal;
}

/** 1. 로그인>첫로그인, 비밀번호 기한 만료 > 비밀번호 변경 : pw, chkCompanyId, userId */
function loginCheckPasswordPolicy(dataParams) {
	return checkPasswordPolicy(dataParams, "/user/login");
}

/**
 * 암호 정책 확인
 *
 * @param dataParams
 * 2. 포탈>환경설정>개인정보관리> 비밀번호관리 : pw, useLoginCookie
 * 3. 관리자>조직도/메일>퇴직자관리/공유사서함관리> 암호관리/공유사서함 추가 : pw, chkCompanyId
 * 4. 관리자>조직도>조직도관리> 암호관리 : pw, chkCompanyId, userId
 * 5. 관리자>조직도>조직도관리> 사원추가 : pw, chkCompanyId, userId, usePropParams, TELEPHONENUMBER, MOBILE, HOMEPHONE, BIRTH
 *
 * @require jsp : <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
 */
function checkPasswordPolicy(dataParams, path) {
	var result = false;
	
	$.ajax({
		type:"post",
		data: dataParams,
		async:false,
		url : (path? path : "/ezOrgan") + "/checkPasswordPolicy.do",
		success : function(data) {
			if (data == "OK") {
				result = true;

			} else if (data.includes("PREVERROR")) { // 2021-10-26 이사라 : 최근사용 비밀번호는 사용할 수 없는 로직 추가
				var rememberPWCount = data.split('|');
				alert(strLangLS06.replace("%s",rememberPWCount[1]));
			} else if (data == "NUMBERERROR") { // 2023-06-09 이사라 : 패스워드 설정 시 연속숫자, 생일, 전화번호 방지 기능
				alert(strLangLS07);
			} else {
				alert(strLangKSA07);
			}
		}, error : function (err) {
			alert(strLangKSA06);
		}
	});
	
	return result;
}

/** 기존 공유사서함 관련 암호 정책 확인. ▲checkPasswordPolicy() 로 통합함. */
function sharedMailCheckPassword(str) {
	var pw = str;
	var num = pw.search(/[0-9]/g);
	var eng = pw.search(/[a-z]/ig);
	var spe = pw.search(/[^0-9a-z]/gi);
	
	if (pw.length < 8 || pw.length > 50) {
		return false;
	}
	
	if (pw.search(/\s/) != -1) {
		return false;
	}
	
	if (num < 0 || eng < 0 || spe < 0) {
		return false;
	}
	return true;
}