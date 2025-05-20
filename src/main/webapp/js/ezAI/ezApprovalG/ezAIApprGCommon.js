// draftUI
// 데이터 가공 추출
// apprDoc, draftDoc
function makeApprovalDataForAI() {
    let dataArray = [];
    const subModuleType = getSubModuleType();

    // 기안자 정보
    let drafterName, drafterPosition, drafterDept;
    if ('draftDoc' == subModuleType) {
        drafterName = arr_userinfo[2];
        drafterPosition = arr_userinfo[3];
        drafterDept = arr_userinfo[4];
    } else if ('apprDoc' == subModuleType) {
        drafterName = drafterName;
        drafterPosition = "";
        drafterDept = drafterDept;
    }
    
    // 본문
    let contentStr = message.Get_EditorBodyHTML();
    contentStr = removeHtmlTag(contentStr);
    
    const data = {
        formTitle : formName,
        docTitle : trim_Cross(message.GetDocTitle()),
        drafterName : drafterName,
        drafterPosition : drafterPosition,
        drafterDept : drafterDept,
        body : contentStr
    }
    
    dataArray.push(data);
    return dataArray;
}

function insertApprBodyContent(content) {
    if (!!message.document.iframe_content) { 
        message.document.iframe_content.SetEditorTextContent(content);
    } else {
        message.document.getElementById("body").innerText = content;
    }
}