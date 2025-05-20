// board _ view, preview
function makeBoardDataForAI() {
    let dataArray = [];
    const subModuleType = getSubModuleType();
    
    // 게시판 본문 data
    let textElement = "";
    let contentStr = "";
    if (subModuleType == "view") {
        const frame = document.querySelector("#message");
        if (frame && frame.contentDocument) {
            textElement = frame.contentDocument.querySelector('#txtContent');
        }
    } else if (subModuleType == "preview") {
        textElement = document.querySelector('#divContent');
    }
    contentStr = !!textElement ? textElement.innerHTML || '' : '';
    contentStr = removeHtmlTag(contentStr);
    
    // 확장컬럼 data
    const attrData = makeAttributeData();
    
    const data = {
        writerID : boardItemJson.writerID,
        writerName : boardItemJson.writerName,
        writerDeptName : boardItemJson.writerDeptName,
        writerCompanyName : boardItemJson.writerCompanyName,
        writeDate : boardItemJson.startDate,
        endDate : boardItemJson.endDate,
        boardName : pBoardName,
        title : boardItemJson.title,
        content : contentStr,
        extensionAttribute : attrData
    }
    dataArray.push(data);
    return dataArray;
}

// 확장컬럼 data 추출
function makeAttributeData() {
    const contentAttrListData = [];

    for (let i = 0; i < boardAttrListJson.length; i++) {
        const tableColName = boardAttrListJson[i].tableCol || ''; // 확장컬럼 테이블 컬럼명
        const colName = userLang === '1' ? boardAttrListJson[i].colName1 || '' : boardAttrListJson[i].colName2 || '';
        const colVal = boardItemJson[tableColName] || ''; // null처리

        const contentAttrObj = { 
            columnName : colName,
            columnValue : colVal
        };
        contentAttrListData.push(contentAttrObj);
    }
    return contentAttrListData;
}