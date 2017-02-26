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
    
    selTab1EI.item(0).className = "on";
     
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
    
    selTab1EI.item(0).className = "on";
     
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
		this.className = "on";
	}
}
function mouseOut_Sub2()
{
	if( prevSelMenu2 != this )
	{
		this.className = "off";
	}
}
////////////////////////////////////////////////////////////////////////

var currentListNum;
var level1El;
var level2El;
var level3El;
function initToggleList(ulEl, level1, level2, level3)
{
    currentListNum = true;
    
    level1El = ulEl.getElementsByTagName(level1);
    level2El = ulEl.getElementsByTagName(level2);
    level3El = ulEl.getElementsByTagName(level3);
    
    for( var i = 0 ; i < level1El.length ; i++ )
    {
			level1El.item(i).listNum = i;
			level1El.item(i).onclick = toggleList;
			
			level2El.item(i).listNum = i;
			level2El.item(i).className = "off";
			level2El.item(i).subtag = level3;
		}
	
	for( var j = 0 ; j < level3El.length ; j++ )
  {
		level3El.item(j).onclick = toggleList_Sub;
		level3El.item(j).onmouseover = mouseOver_Sub;
		level3El.item(j).onmouseout = mouseOut_Sub;
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
	    || itemId == "searchBoard" || itemId == "btn_MemberJoinIng" || itemId == "MYCONT" || itemId == "btn_MemberInfo"
        || itemId == "m01" || itemId == "m02" || itemId == "m03" || itemId == "m04" || itemId == "m05" || itemId == "m06" || itemId == "m07" || itemId == "m08" || itemId == "m09"))) {
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
        if (level1El.item(this.listNum).children.length > 0 && level1El.item(this.listNum).children[0].id != undefined && level1El.item(this.listNum).children[0].id != "") {
            //window.event.srcElement.id = level1El.item(this.listNum).children[0].id;
            if (!CrossYN()){
                //level1El.item(this.listNum).children[0].onclick();
            }else{
                //level1El.item(this.listNum).children[0].onclick;
            }
        }
        level2El.item(this.listNum).className = "on";
    }

    currentListNum = this.listNum + 1;

    setMenu(level2El.item(this.listNum));
}

var prevSelMenu = null;
function toggleList_Sub()
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
		this.className = "on";
	}
}

function mouseOut_Sub()
{
	if( prevSelMenu != this )
	{
		this.className = "off";
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
	return new Date(today.toUTCString().replace(" GMT", ""));
}

function specialChk(val){
	var special_pattern = /[`^|\\\'\"\/]/gi;
	var rVal = false;
	
	if (special_pattern.test(val) == true ){	    
	    rVal = true;
	}
	return rVal;
}
