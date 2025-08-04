/**
 * @file 예약발송수정에만 해당 js
 * @author 솔루션1팀 김은실
 * @version 1.0.0
 * @date 2024-12-12
 */

function ReserverdMail_Save()
{
        var xmlhttp_1 = createXMLHttpRequest();
        var strQuery = "<DATA><MESSAGEID>"+pCDOMessageId+"</MESSAGEID></DATA>";
// 2025-07-21 김대현 기존 예약메일 수정을 발송 30분 전에는 못하던걸 가능하게 변경
//        xmlhttp_1.open("POST", "/ezEmail/reservedMailCheck.do", false);
//        xmlhttp_1.send(strQuery);
//        if(xmlhttp_1.responseText == "<DATA>MAIL-EXISTS</DATA>")
    Send_onClick();
//        else
//            alert(strLang243);

    try {
        window.opener.window.close();
    } catch (e) {
        console.log(e);
    }
}

