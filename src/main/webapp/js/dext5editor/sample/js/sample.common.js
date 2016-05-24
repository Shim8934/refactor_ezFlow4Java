//////////////////////////////////////////////////////////////////////////////////////////////////////
//				  	sample을 실행할 언어를 기입해 주세요 ex: NET, JAVA, PHP			                //		
//////////////////////////////////////////////////////////////////////////////////////////////////////
var SampleLanguage = "NET"; // NET, JAVA, PHP
var SampleRunTimes = "html5"; // html5, ieplugin, versionieplugin(10ieplugin)

function fn_getHtmlValueEx(editorID) {
    document.getElementById("logBox").value += editorID + ' 작성 내용 : \n';
    document.getElementById("logBox").value += DEXT5.getHtmlValueEx(editorID) + '\n';
}

function fn_setHtmlValueEx(editorID) {
    DEXT5.setHtmlValueEx(document.getElementById("txtTestValue1").value, editorID);
}
function fn_setHtmlValueEx2(editorID) {
    DEXT5.setHtmlValueEx(document.getElementById("txtTestValue").value, editorID);
}

function fn_getBodyValue(editorID) {
    document.getElementById("logBox").value += editorID + ' 작성 내용 : \n';
    document.getElementById("logBox").value += DEXT5.getBodyValue(editorID) + '\n';
}

function fn_setBodyValue(editorID) {
    DEXT5.setBodyValue(document.getElementById("txtTestValue2").value, editorID);
}

// 에디터 내용 작성 유무
function fn_isEmpty(editorID) {
    alert('isEmpty : ' + DEXT5.isEmpty(editorID));
}

// HTML 소스 삽입
function fn_setInsertHtml(editorID) {
    DEXT5.setInsertHTML(document.getElementById("txtTestValue").value, editorID);
}

// CSS 삭제
function fn_removeCss(editorID) {
    var deleteAll = false; // true : 에디터 에서 사용하는 css link까지 모두 삭제
    DEXT5.clearUserCssUrl(deleteAll, editorID);
}

// UI 컨트롤 
function fn_showTopMenu(value, editorID) {
    DEXT5.showTopMenu(value, editorID);
}

function fn_showToolbar(value, editorID) {
    DEXT5.showToolbar(value, editorID);
}

function fn_showStatusbar(value, editorID) {
    DEXT5.showStatusbar(value, editorID);
}
function fn_setNextTabElementId() {
    DEXT5.setNextTabElementId("title");
}
