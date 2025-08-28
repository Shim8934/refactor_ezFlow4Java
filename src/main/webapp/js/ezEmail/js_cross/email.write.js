﻿/**
 * @file /ezEmail/mailWrite.do 호출 관련된 파일로 사용하면 좋을듯 합니다.
 * @author 솔루션1팀 김은실
 * @version 1.0.0
 * @date 2025-02-13
 */

/**
 * 전달 (FORWARD)
 * /ezEmail/mailWrite.do?cmd=FORWARD 호출 부분 통일.
 * 구분자 <sep> (separator)
 *    : 편지함 이름에 사용할 수 없는 문자는 < " \ / > 이므로 이를 이용. (mailbox_valid.js> checkBadFolderName)
 *    : 대용량 파일 관련 _kaonisplit_ 도 쓰고 있지만, 혹시나 중복되어 문제 생기는 걸 방지하기 위해 uniq를 유지.
 *
 * @param {Array} selectItems // ["INBOX/4", "SENT/4", "INBOX/5"]
 * @param {String} shareId
 *
 * @returns {boolean} false면 return;
 */
function forward_mail_call(selectItems, shareId) {
    if (selectItems.length == 0) {
        alert(strLang42); // 메일을 선택하세요.
        return false;
    }

    selectItems = selectItems.filter(URL => checkBlockedMail(URL) != '1'); // 열람 차단 제외

    if (selectItems.length == 0) {
        alert(strLangLDH07); // 관리자에 의해 열람차단된 메일입니다.
        return false;
    }

    var pURI = "/ezEmail/mailWrite.do?cmd=FORWARD&URL=" + encodeURIComponent(selectItems.join("<sep>")); // "INBOX/4<sep>SENT/4<sep>INBOX/5"

    if (shareId) {
        pURI += "&shareId=" + encodeURIComponent(shareId);
    }

    // window open
    var pheight = window.outerHeight;
    var conHeight = Math.max(pheight * 0.8, 840);
    var pwidth = window.outerWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > minimumWidth) // minimumWidth: Newemail.js, search_mail.js에 정의되어 있음.
        conWidth = minimumWidth;

    var pLeft = window.outerWidth / 2 + window.screenX - (conWidth / 2);
    var pTop = window.outerHeight / 2 + window.screenY - (conHeight / 2);

    var newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
    newwin.focus();

    return true;
}
