
    function replaceMailboxNameForJmocha(szName) {
        // commit efc6d3598e
        szName = szName.replace(/&/g, "＆");		// global : 문자열 내의 모든 패턴 변경.
        szName = szName.replace(/'/g, "＇");
        szName = szName.replace(/\./g, "․");
        szName = szName.replace(/'/g, "＇");
        szName = szName.replace(/\*/g, "＊");
        szName = szName.replace(/%/g, "％");

        return szName;
    }

    function checkBadFolderName(szName) {
        var szBadChars = /[\<\>\"\\\/]/;	// 체크용이기 때문에 global 하지 않음.

        if (szBadChars.test(szName)) {
            alert(strLangNJK01 + "< \" \\ / >)" + strLangNJK02);
            return true;
        }
        //"＇＇" 들어올 시, 이름 없는 메일함이 생성되는 버그 발생 : imap 프로토콜단 또는 james 특유의 문제인데, 현재로썬 원인을 정확히 파악하기 어렵다.
        else if (szName.trim() == "＇＇") {
            alert(strLangNJK01 + "'')" + strLangNJK02);
            return true;
        }

        return false;
    }

    //TODO: copy일때 비동기로 처리하도록 함수 따로 만들어야함.
    function mail_make_folder(szCMD, szURL, destURL, szName) {
        var xmlHTTP = createXMLHttpRequest();
        var xmlDOM = createXmlDom();
        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "CMD", szCMD);
        createNodeAndInsertText(xmlDOM, objNode, "URL", szURL);
        createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", destURL);
        createNodeAndInsertText(xmlDOM, objNode, "NAME", szName);

        var requestUrl = "/ezEmail/mailMakeFolder.do";

        if (shareId != "") {
            requestUrl += "?shareId=" + encodeURIComponent(shareId);
        }

        xmlHTTP.open("POST", requestUrl, false);
        xmlHTTP.send(xmlDOM);

        if (xmlHTTP.status >= 200 && xmlHTTP.status < 300) {
            return xmlHTTP.responseText;
        } else {
            return "ERROR";
        }

    }
