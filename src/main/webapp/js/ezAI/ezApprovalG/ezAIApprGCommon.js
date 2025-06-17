// draftUI
// 데이터 가공 추출
// apprDoc, draftDoc
function makeApprovalDataForAI() {
    let dataArray = [];
    const subModuleType = getSubModuleType();

    // 기안자 정보
    let pDrafterName, pDrafterPosition, pDrafterDept;
    if ('draftDoc' == subModuleType) {
        pDrafterName = arr_userinfo[2];
        pDrafterPosition = arr_userinfo[3];
        pDrafterDept = arr_userinfo[4];
    } else if ('apprDoc' == subModuleType) {
        pDrafterName = drafterName;
        pDrafterPosition = "";
        pDrafterDept = drafterDept;
    }
    
    // 본문
    let contentStr = message.Get_EditorBodyHTML();
    contentStr = stripHtmlExceptTableTags(contentStr);
    
    const data = {
        formTitle : formName,
        docTitle : trim_Cross(message.GetDocTitle()),
        drafterName : pDrafterName,
        drafterPosition : pDrafterPosition,
        drafterDept : pDrafterDept,
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

///////////////////////// 전자결재문서 전처리 함수 //////////////////////////////
// HTML 문자열에서 테이블 관련 태그(TABLE, TR, TD)만 유지하고 나머지 태그는 제거하는 함수
function stripHtmlExceptTableTags(html) {
    // HTML 파싱을 위한 DOMParser 생성
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    
    // style 태그 제거
    const style = doc.querySelector('style');
    if (style) {
        style.remove();
    }
    
    // 줄바꿈을 생성할 태그 정의
    const BREAK_TAGS = ['P', 'DIV', 'BR', 'LI', 'H1', 'H2', 'H3', 'H4', 'H5', 'H6'];
    
    // 줄바꿈 태그를 만날 때 개행문자 추가
    doc.querySelectorAll(BREAK_TAGS.join(',')).forEach(el => {
        el.parentNode.insertBefore(doc.createTextNode('\n'), el.nextSibling);
    });
    processNode(doc.body);
    
    // 결과 HTML 정리
    return doc.body.innerHTML
        .replace(/&nbsp;/g, ' ')
        .replace(/[ \t]+/g, ' ')       // 연속된 공백을 하나로
        .replace(/[\n\r]+/g, '\n')     // 연속된 줄바꿈을 하나로
        .replace(/>\s+</g, '><')       // 태그 사이 공백 제거
        .replace(/^\s+|\s+$/g, '');    // 양끝 공백 제거
}

// 노드 내부의 태그를 순회하며 허용된 태그(테이블 태그) 외에는 제거하는 재귀 함수
function processNode(node) {
    // 테이블 관련 태그 정의
    const ALLOWED_TAGS = new Set(['TABLE', 'TR', 'TD', 'TH', 'THEAD', 'TBODY', 'TFOOT', 'IMG']);
    const children = Array.from(node.childNodes);
    
    // 자식 노드들을 재귀적으로 순회하며 허용태그와 비허용태그를 다르게 처리함
    for (const child of children) {
        if (child.nodeType === Node.ELEMENT_NODE) {
            if (!ALLOWED_TAGS.has(child.tagName)) {
                processNode(child);
                while (child.firstChild) { // 제거해야 할 태그의 내부 텍스트 처리
                    node.insertBefore(child.firstChild, child);
                }
                node.removeChild(child); // 태그 제거
            } else {
                cleanAttributes(child);
                processNode(child);
            }
        }
    }
}

// 허용된 태그에서 지정된 속성만 남기고 나머지는 제거하는 함수
function cleanAttributes(element) {
    // 남길 속성
    const KEEP_ATTRIBUTES = new Set(['id', 'colspan', 'rowspan', 'href', 'src', 'alt']);
    
    // 요소의 모든 속성을 배열로 변환 (removeAttribute 호출 시 속성 목록이 변경되므로)
    const attributes = Array.from(element.attributes);
    
    // 유지할 속성 외의 모든 속성 제거
    for (const attr of attributes) {
        if (!KEEP_ATTRIBUTES.has(attr.name.toLowerCase())) {
            element.removeAttribute(attr.name);
        }
    }
}