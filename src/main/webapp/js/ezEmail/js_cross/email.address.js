﻿/**
 * @file 메일주소 처리 관련된 파일로 사용하면 좋을듯 합니다.
 * @author 솔루션1팀 김은실
 * @version 1.0.0
 * @date 2025-08-06
 */

/**
 * newMail_Cross.js에서 가져옴.
 * 현재는 mailWrite.jsp와 수신거부에서만 쓰임.
 *
 * @param {*} ReceiverList
 * @returns retVal
 */
function getEmailAddressList(ReceiverList) {
    var count, count2, count3, length, length2;
    var szType, szName, szEmail, szHref;

    var receivers;
    var receiver;

    var retVal = {
        "type": new Array(),
        "name": new Array(),
        "email": new Array(),
        "href": new Array()
    };

    receivers = ReceiverList.split(">,");
    length = receivers.length;
    //receivers[ length - 1 ] = receivers[ length - 1 ].substr( 0, receivers[ length - 1].length - 1);
    for (count = 0, count3 = 0; count < length; count++) {
        receiver = receivers[count];
        receiver = ReplaceText(receiver, "-leftSeperator-kaoni-", "<");
        receiver = ReplaceText(receiver, "-rightSeperator-kaoni-", ">");
        if (ReplaceText(receiver, " ", "") == "") continue;
        receiverPart = receiver.split(" <");
        var pName = receiverPart[0];
        var pEmail = receiverPart[1].replace("<", "").replace(">", "");

        // g_cmd가 있을 때.
        if (window.g_cmd && g_cmd != "EDIT") {
            if (pEmail == g_myemail) {
                if (Org_cmd == "attitudeAbsented") {
                    attitudeIncludeMe = true;
                }

                continue;
            }
        }

        retVal["name"][count3] = pName.replace("\"", "").replace("\"", "");

        if (receiverPart[1].indexOf('@') > 0) {
            retVal["type"][count3] = "email";
            retVal["email"][count3] = pEmail;
            retVal["href"][count3] = "";
        } else {
            retVal["type"][count3] = "mailgroup";
            retVal["email"][count3] = strLang126;
            retVal["href"][count3] = pEmail;
        }

        count3++;
    }

    return retVal;
}

/**
 * 이메일 주소 파싱에 오류가 (new InternetAddress => javax.mail.internet.AddressException: name에 허락되지 않은 패턴 => 따옴표(") 추가해주면 된다.)
 * 발생할만한 이름을 이중따옴표로 감싸는 작업.
 *
 * 1) "01099455495 <발신전용>" <01099455495@ktfmms.magicn.com>와 같이 이름안에 <> 기호가 있는 경우
 * 2) "Cardio 2025 | London, UK" <cardiology@globalsummitnetwork.com>와 같이 이름안에 , 기호가 있는 경우
 * 3) "광고) 김판매원" <seller@sample.com> 괄호의 짝이 안맞는 경우 등
 *
 * @param {String} name
 * @param {String} email
 * @returns {String} "name" <email>
 */
function quoteEmailName(name, email) {
    let result = email;

    if (name && name != email) {
        if (/[\.,:;"<>()\[\]\\@]/.test(name) && !(name.startsWith('"') && name.endsWith('"'))) {
            result = '"' + name.replace(/"/g, '\\"') + '"'; // "홍\"길\"동"
        } else {
            result = name;
        }

        result += " <" + email + ">";
    }

    return result;
}
