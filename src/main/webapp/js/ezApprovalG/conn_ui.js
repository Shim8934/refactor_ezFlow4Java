var orgWin = null;

function init(initDataSetFunc, returnDataSetFunc) {
    try {
        window.opener.postMessage("load", "*");
    } catch (e) {
        try {
            window.parent.postMessage("load", "*");
        } catch (e) {}
    }

    window.addEventListener("message", function(e) {
        orgWin = e.source;
        
        var req = e.data;
        if(initDataSetFunc && typeof initDataSetFunc === "function") {
            initDataSetFunc(req);
        }
        
    }, false);

    if (document.querySelector("#btn_ok")) {
        document.querySelector("#btn_ok").addEventListener("click", function() { clickBtnOk(returnDataSetFunc); });
    }
    if (document.querySelector("#btn_cancel")) {
        document.querySelector("#btn_cancel").addEventListener("click", clickBtnCancel);
    }
    if (document.querySelector("#btn_close")) {
        document.querySelector("#btn_close").addEventListener("click", clickBtnCancel);
    }
}

function clickBtnOk(returnDataSetFunc) {
    if(returnDataSetFunc && typeof returnDataSetFunc === "function") {
        makeDataSet(returnDataSetFunc);
    }

    var retXmlStr = makeDataSet(returnDataSetFunc);
    orgWin.postMessage(retXmlStr, "*");
}

function clickBtnCancel() {
    orgWin.postMessage("cancel", "*");
}

function makeDataSet(makeFunc) {
    var xmlDom = createXmlDom();

    var outerRoot = createNodeInsert(xmlDom, null, "RETURNDATA");
    SetAttribute(outerRoot, "RESULT", "true");

    var innerRoot = createNodeAndAppandNode(xmlDom, outerRoot, null, "PARAMETER");

    if(makeFunc && typeof makeFunc === "function") {
        makeFunc(xmlDom, innerRoot);
    }

    return getXmlString(xmlDom);
}