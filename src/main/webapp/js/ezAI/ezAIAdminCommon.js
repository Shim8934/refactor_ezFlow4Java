
var SendData = {};
var MainAppPath = `${getCoreAppPath()}/ezAi/Main`;
var RemoteAppPath = `${getCoreAppPath()}/ezAi/Remote`;
var AttachAppPath = `${getCoreAppPath()}/ezAi/Attach`;
var PopupAppPath = `${getCoreAppPath()}/ezAi/Popup`;
var AdminAppPath = `${getCoreAppPath()}/ezAi/Admin`;
var AdminRemoteAppPath = `${getCoreAppPath()}/ezAi/AdminRemote`;
/**
 * API 추가버튼 event
 * @param {any} type 추가/삭제 분기
 * @returns PopupWindow
 */
function SetApiKey(type, flag) {
    try {
        ApiKey_dialogArguments = new Array();
        ApiKey_dialogArguments[0] = "";
        ApiKey_dialogArguments[1] = SaveApiConfig;

        let URL = "";
        if (type === "ADD") {
            var apiKeyTrCount = document.querySelectorAll('#apikeyList tr.apiKeyTr').length;
            if (apiKeyTrCount > 1) {
                Alert_Message('이미 API-KEY를 등록하셨습니다.', null, "2");
                return;
            }
            // degisn을 위한 임시분기
            if (flag)
                URL = `${AdminAppPath}/API_KEY_Popup_design`;
            else
                URL = `${AdminAppPath}/API_KEY_Popup`;

            DivPopUpShow(900, 410, URL);
        } else if (type === "DEL") {
            var tbody = document.getElementById('statistics_list');

            // tbody 안에 tr 요소가 있는지 확인
            if (tbody && tbody.getElementsByTagName('tr').length > 0) {
                Confirm_Alert_Message("API-KEY를 삭제하시겠습니까? <br/> 삭제하실 경우 AI기능 동작이 제한됩니다.", DeleteApiKey, "", type)
            } else {
                Alert_Message('등록된 API-KEY가 없습니다. API-KEY를 등록해주세요', null, "2");
                return;
            }

        }

    } catch (e) {
        console.error(e);
    }
}

/**
 * Api 추가 Parameter 구성 및 Service Reqeust
 * @param {any} mode 추가/삭제 분기
 * @returns 추가/삭제 결과값
 */
function SaveApiConfig(mode) {
    var sendData = {};
    var apiKey = "";
    var adminKey = "";
    var projectID = "";

    if (document.getElementById("openAiProjectID")) {
        if (document.getElementById("openAiProjectID").value.trim() == "") {
            Alert_Message("생성하신 Project ID를 입력 해 주세요", null, "3");
            return;
        } else if (document.getElementById("openAiProjectID").value.trim().length < 11) {
            Alert_Message("생성하신 Project ID를 입력 해 주세요.", null, "4");
            return;
        }
        projectID = document.getElementById("openAiProjectID").value;
    }

    if (document.getElementById("openAiServiceApiKey")) {
        if (document.getElementById("openAiServiceApiKey").value.trim() == "") {
            Alert_Message("발급받은 Service-API-KEY를 입력 해 주세요", null, "3");
            return;
        } else if (document.getElementById("openAiServiceApiKey").value.trim().length < 11) {
            Alert_Message("올바른 Service-API-KEY를 입력 해 주세요.", null, "4");
            return;
        }
        apiKey = document.getElementById("openAiServiceApiKey").value;
    }

    if (document.getElementById("openAiAdminApiKey")) {
        if (document.getElementById("openAiAdminApiKey").value.trim() == "") {
            Alert_Message("Admin-API-KEY를 입력 해 주세요", null, "", "3");
            return;
        } else if (document.getElementById("openAiAdminApiKey").value.trim().length < 11) {
            Alert_Message("올바른 Admin-API-KEY를 입력 해 주세요.", null, "4");
            return;
        }
        adminKey = document.getElementById("openAiAdminApiKey").value;
    }

    sendData = { adminKey, apiKey, projectID, mode }

    if (CheckApiKeyResult) {
        try {
            SetApiConfig(sendData, data => {
                let okFlag = data;
                let msg = okFlag == "OK" ? "API-KEY가 등록되었습니다." : "API-KEY 등록에 실패했습니다. <br/>입력하신 KEY를 확인해주세요";

                Alert_Message(msg, () => {
                    if (okFlag == "OK") {
                        parent.DivPopUpHidden();
                        URL = `${AdminAppPath}/API_KEY_Setting`;
                        parent.LoadUrlContent(URL, "RIGHTDIV");
                    }
                }, okFlag == "OK" ? "2" : "4");
            });

        } catch (e) {
            console.log(e.message);
        }
    } else {
        Alert_Message("API-KEY 유효성 검사를 진행해주세요.", null, "3");
        return;
    }
}

function DeleteApiKey(rtnVal, mode) {
    if (rtnVal) {
        let sendData = {};
        sendData = { mode }

        try {
            SetApiConfig(sendData, data => {
                let okFlag = data;
                let msg = okFlag == "OK" ? "API-KEY가 삭제되었습니다." : "API-KEY 삭제에 실패했습니다. <br/> 관리자에게 문의 해 주세요";

                Alert_Message(msg, () => {
                    if (okFlag == "OK") {
                        parent.DivPopUpHidden();
                        URL = `${AdminAppPath}/API_KEY_Setting`;
                        parent.LoadUrlContent(URL, "RIGHTDIV");
                    }
                }, okFlag == "OK" ? "3" : "4");
            });

        } catch (e) {
            console.log(e.message);
        }
    }
}

/**
 * 추가/삭제 Service Request Call
 * @param {any} pMode ADD, MOD, DEL
 */
function DeleteAgent(obj, pMode) {
    objId= obj.closest("li").id;

    let sendData =
    {
        AgentID: objId,
        mode: pMode,
    };
    
    try {
        SetAgent(sendData, data => {
            let okFlag = data;
            let msg = okFlag == "OK" ? "Agent가 삭제되었습니다." : "Agent 삭제에 실패했습니다. <br/>관리자에게 문의하세요.";

            Alert_Message(msg, () => {
                if (okFlag == "OK") {
                    parent.DivPopUpHidden();
                    URL = `${AdminAppPath}/ManageAgent`;
                    parent.LoadUrlContent(URL, "RIGHTDIV");
                }
            }, okFlag == "OK" ? "2" : "4");
        });

    } catch (e) {
        console.log(e.message);
    }

}

/**
 * 추가/삭제 Service Request Call
 * @param {any} param       Mode
 * @param {any} callback    결과 전달을 위한 사용자 함수
 * @returns 성공/실패 결과값
 */
function SetApiConfig(param, callback) {
    let res = 0;
    try {
        let companyid = SelectedCompanyID();
        //let params = setQueryString({ companyid }, encodeURIComponent);

        let url = `${AdminRemoteAppPath}/SetApiConfig`;
        res = postXhr(url, JSON.stringify(param), callback);
    } catch (e) {
        console.error(e);
    }
    return res;
}

function CheckApiKey() {
    ShowMailProgress();

    let sendData = {};
    let projectID = "";
    let apiKey = "";

    try {
        if (document.getElementById("openAiProjectID")) {
            if (document.getElementById("openAiProjectID").value.trim() == "") {
                Alert_Message("발급받은 Projiect-ID를 입력 해 주세요", null, "3");
                HiddenMailProgress();
                return;
            } else if (document.getElementById("openAiProjectID").value.trim().length < 11) {
                Alert_Message("올바른 Projiect-ID를 입력 해 주세요.", null, "4");
                HiddenMailProgress();
                return;
            }
            projectID = document.getElementById("openAiProjectID").value;
        }
        if (document.getElementById("openAiServiceApiKey")) {
            if (document.getElementById("openAiServiceApiKey").value.trim() == "") {
                Alert_Message("발급받은 Service-API-KEY를 입력 해 주세요", null, "3");
                HiddenMailProgress();
                return;
            } else if (document.getElementById("openAiServiceApiKey").value.trim().length < 11) {
                Alert_Message("올바른 Service-API-KEY를 입력 해 주세요.", null, "4");
                HiddenMailProgress();
                return;
            }
            apiKey = document.getElementById("openAiServiceApiKey").value;
        }
    } catch (e) {
        console.log(e.message);
    }

    sendData = { projectID, apiKey }

    try {
        CheckApiKeyToPython(sendData, data => {
            let okFlag = data.toUpperCase();
            let msg = okFlag == "TRUE" ? "사용 가능한 API-KEY입니다." : "잘못 된 API-KEY입니다 . <br/>입력하신 KEY를 확인해주세요";
            CheckApiKeyResult = okFlag == "TRUE" ? true : false;

            Alert_Message(msg, () => {
                if (okFlag == "TRUE") {
                    document.getElementById("openAiProjectID").disabled = true;
                    document.getElementById("openAiServiceApiKey").disabled = true;
                }
            }, okFlag == "TRUE" ? "2" : "4");
            HiddenMailProgress();
        });
    } catch (e) {
        console.log(e.message);
    }
}

function CheckApiKeyToPython(param, callback) {
    let res = 0;
    try {
        let companyid = SelectedCompanyID();
        //let params = setQueryString({ companyid }, encodeURIComponent);

        let url = `${AdminAppPath}/CheckAPIKey`;
        res = postXhrAsync(url, JSON.stringify(param), callback);
    } catch (e) {
        console.error(e);
    }
    return res;
}

var aprattach_dialogArgument = new Array();
function openFileAttachUI() {
    try {
        var parameter = "";
        var pPopupStyle = "DIV";
        var url = `${AttachAppPath}/AiAttach`;
        aprattach_dialogArgument[0] = parameter;
        aprattach_dialogArgument[1] = openFileAttachUI_Complete;
        CommonPopUp(url, 620, 450, "", pPopupStyle);
    } catch (e) {
        Alert_Message("openFileAttachUI()" + e.description, null, "4");
    }
}
function openFileAttachUI_Complete(RtnVal) {
    if (RtnVal != "cancel") {
        if (typeof (pPageType) === "string" && pPageType == "ENDUI") {
            setAttachInfo(pDocID, "END", lstAttachLink);
        } else {
            setAttachInfo(pDocID, "APR", lstAttachLink);
        }
    }
}

function ChangeAgentName(obj) {
    try {
        let agentID = document.getElementById("agentID").textContent;
        let escapedId = escapeIdSelector(agentID);

        let spanElement = document.querySelector(`#AgentListDiv #${escapedId}`);

        spanElement.textContent = obj.value;

    } catch (e) {

    }
}

function FileUpdateAfter(pXml) {
    if (attachResultJson == "") {
        attachResultJson = {
            "companyid": "@userinfo.CompanyID",
            "agentId": "@agentID",
            "files": [],
        }
    }
    let attachXml = loadXMLString(pXml);
    let fileName = attachXml.getElementsByTagName("PFILENAME")[0].textContent;
    let attachId = attachXml.getElementsByTagName("PUPLOADSN")[0].textContent;
    let fileExtention = attachXml.getElementsByTagName("EXTENSION")[0].textContent;
    let fileSize = attachXml.getElementsByTagName("FILESIZE")[0].textContent;
    let sn = attachResultJson.files.length + 1;

    attachResultJson.files.push({
        "fileName": fileName,
        "attachId": attachId,
        "fileExtention": fileExtention,
        "fileSize": fileSize,
        "sn": sn,
    });

    return attachResultJson;
}

function MakeAttachList() {
    try {
        var str = "";
        let sendData = {};
        
        sendData =
        {
            "AgentID": document.querySelector("#AgentID").textContent,
        }

        GetEmbeddingsToDb(sendData, data => {
            let pos = 0;
            let filename = "";
            let filepath = "";

            let embeddins = JSON.parse(data);


            str += "<LISTVIEWDATA><HEADERS><HEADER><NAME>첨부파일명</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>파일크기</NAME><WIDTH>50</WIDTH></HEADER></HEADERS><ROWS>";
            embeddins.forEach(x => {
                filepath = x.FilePhysicalPath;

                var filenameTemp = filepath.split('/')[filepath.split('/').length - 1];
                filename = `<![CDATA[${x.FileName}]]>`;

                filepath = MakeXMLString("/Upload_ezAi/" + filepath);
                str += "<ROW><CELL>";
                str += "<VALUE>" + filename + "</VALUE>";

                str += "<DATA2>" + MakeXMLString(filepath.replace("TempUploadFile/", "")) + "</DATA2>";
                str += "<DATA3>" + MakeXMLString(x.FileEXT) + "</DATA3>";
                str += "<DATA4></DATA4>";
                str += "<DATA5>Y</DATA5>";
                str += "<DATA6>" + MakeXMLString(x.FileSize) + "</DATA6>";
                // 2023-03-22 BJH : GUID, FOLDERID, FOLDERNAME 추가
                //str += "<GUID>" + MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "GUID")) + "</GUID>";
                //str += "<FOLDERID>" + MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FOLDERID")) + "</FOLDERID>";
                //str += "<FOLDERNAME>" + MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FOLDERNAME")) + "</FOLDERNAME>";
                str += "</CELL>";
                str += "<CELL><VALUE></VALUE>";
                str += "</CELL></ROW>";
            });
            str += "</ROWS></LISTVIEWDATA>";            
            
        });

    } catch (e) {
        console.error(e);
    }

    
    return str;
}

function GetEmbeddingsToDb(param, callback) {
    let res = 0;
    try {
        let companyid = SelectedCompanyID();
        //let params = setQueryString({ companyid }, encodeURIComponent);

        let url = `${AdminAppPath}/GetAgentEmbeddings`;
        res = postXhr(url, JSON.stringify(param), callback);
    } catch (e) {
        console.error(e);
    }
    return res;
}

function EmbeddingRequest() {
    let sendData = {};
    let agentFiles;
    embeddingLoading = createLoadingFun('loadEmbedding');
    embeddingLoading(true);

    sendData =
    {
        companyId: selectedCompanyID(),
        agentId: agentID,
        files: GetAgentAttachFilesInfo(),
    };
    if (sendData.files.length < 1) {
        Alert_Message("학습을 위한 파일을 업로드해주세요.", null, "3");
        embeddingLoading(false);
        embeddingFlag = true;
        return;
    }
        
    try {
        EmbeddingRequestToPython(sendData, data => {
            let responseData = JSON.parse(data); // data를 JSON 객체로 변환
            // 성공과 실패 개수 계산
            let successCnt = responseData.SUCESS.length;
            let failCnt = responseData.FAIL.length;
            let fileData = responseData.DATA;

            // 성공 여부 판단
            let msg = "";
            if (successCnt > 0 && failCnt < 1)
                msg = "학습 완료되었습니다.";
            else
                msg = "일부 파일 학습에 실패하였습니다. 실패한 파일은 리스트에서 제외됩니다.<br/>파일을 확인 해 주세요." 

            embeddingFlag = failCnt > 0 ? false : true;

            // 메시지 알림
            Alert_Message(msg, () => {
                if (!embeddingFlag) {
                    DeleteFromFileList(responseData.FAIL);
                } else {


                }
            }, successCnt > 0 ? "2" : "4");

            // 로딩 상태 종료
            embeddingLoading(false);
        });
    } catch (e) {
        console.log(e.message);
    }
}

function EmbeddingRequestToPython(param, callback) {
    let res = 0;
    try {
        let companyid = SelectedCompanyID();
        //let params = setQueryString({ companyid }, encodeURIComponent);

        let url = `${AdminRemoteAppPath}/EmbeddingRequest`;
        res = postXhrAsync(url, JSON.stringify(param), callback);
    } catch (e) {
        console.error(e);
    }
    return res;
}

function SaveAgent() {
    if (CheckValidation()) {
        var sendData = {};
        sendData = GetSetAgentParam();
        try {
            SetAgent(sendData, data => {
                let okFlag = data;
                let msg = okFlag == "OK" ? "Agent가 등록되었습니다." : "Agent 등록에 실패했습니다. <br/>관리자에게 문의하세요.";

                Alert_Message(msg, () => {
                    if (okFlag == "OK") {
                        parent.DivPopUpHidden();
                        URL = `${AdminAppPath}/ManageAgent`;
                        parent.LoadUrlContent(URL, "RIGHTDIV");
                    }
                }, okFlag == "OK" ? "2" : "4");
            });

        } catch (e) {
            console.log(e.message);
        }
    }
}
function SetAgent(param, callback) {
    let res = 0;
    try {
        let companyid = SelectedCompanyID();
        //let params = setQueryString({ companyid }, encodeURIComponent);

        let url = `${AdminRemoteAppPath}/SetAgent`;
        res = postXhr(url, JSON.stringify(param), callback);
    } catch (e) {
        console.error(e);
    }
    return res;
}

function GetSetAgentParam() {
    let pSendData = {};
    try {
        pSendData.AgentID = GetAgentValue("AgentID");
        pSendData.CompanyID = SelectedCompanyID();
        pSendData.AgentType = GetAgentValue("AgentType", "name");
        pSendData.AttachLimit = GetAgentValue("AttachLimit");
        pSendData.AgentNames = GetAgentValue("agentNames", "AgentName");
        pSendData.Descriptions = GetAgentValue("agentDescriptions", "Description");
        pSendData.QueryGuides = GetAgentValue("agentQueries", "QueryGuide");
        pSendData.SN = GetAgentSN(pSendData.AgentID);
        pSendData.Files = GetAgentAttachFilesInfo();
        pSendData.mode = mode;

    } catch (e) {

    }
    return pSendData;
}

function GetAgentSN(pAgentID) {
    let AgentList = document.querySelectorAll("#AgentListDiv li");
    let AgentSN = AgentList.length + 1;
    AgentList.forEach((x, index) => {
        if (x.id == pAgentID)
            AgentSN = index + 1;
    });
    return AgentSN;
}

function GetAgentAttachFilesInfo() {
    let jsonArray = [];
    try {
        let rows = pAttachListXml.querySelectorAll("ROWS > ROW")

        rows.forEach((row, index) => {
            const cells = row.querySelectorAll("CELL");
            const firstCell = cells[0];
            // 파일 정보 JSON 객체 생성
            const fileData = {
                fileName: firstCell.querySelector("DATA1")?.textContent || "",
                attachId: firstCell.querySelector("ATTACHID")?.textContent || "",
                fileExtention: "." + firstCell.querySelector("DATA3")?.textContent.split('.').pop() || "",
                fileLocation: firstCell.querySelector("DATA4")?.textContent || "",
                fileSize: Number(firstCell.querySelector("DATA6")?.textContent || 0),
                sn: index
            };
            jsonArray.push(fileData)
        });
    } catch (e) {

    }
    return jsonArray;
}

function CheckValidation() {
    let checkValidationResult = false;
    try {
        if (document.getElementById("AgentName").value.trim() == "" && document.getElementById("AgentName2").value.trim() == "") {
            Alert_Message("Agent명을 입력 해 주세요.", null, "3");
            return;
        }
        if (document.getElementById("Description").value.trim() == "" && document.getElementById("Description2").value.trim() == "") {
            Alert_Message("Agent에 대한 설명을 입력 해 주세요.", null, "3");
            return;
        }
        if (document.getElementById("AttachLimit").value < 1) {
            Alert_Message("첨부파일 제한을 설정 해주세요.", null, "3");
            return;
        }

        let QueryGuideFlag = false;
        let queryItemList = document.querySelectorAll(".queryItem");
        if (queryItemList.length > 0) {
            QueryGuideFlag = true;
        } 

        if (!QueryGuideFlag) {
            Alert_Message("Agent에 대한 예시 질의를 입력 해 주세요.", null, "3");
            return;
        }

        /*if (!embeddingFlag) {*/
        if (false) {
            Alert_Message("첨부파일 및 Content를 학습시켜 주세요.", null, "3");
            return;
        }

        checkValidationResult = true;

    } catch (e) {
        Alert_Message(e.message, null, "4");
    }
    return checkValidationResult;
}
function GetAgentValue(key, selector) {
    var getAgentValueResult;
    var SelectorObj;
    try {
        if (typeof selector != "undefined" && selector) {
            switch (selector.toUpperCase()) {
                case "NAME":
                    SelectorObj = document.querySelectorAll("input[name='" + key + "']:checked");
                    if (SelectorObj.length > 1) {
                        getAgentValueResult = [];
                        SelectorObj.forEach(x => {
                            getAgentValueResult.push({
                                [x.id]: x.value
                            });
                        });
                    }
                    break;
                case "QUERYGUIDE":
                    getAgentValueResult = [];
                    
                    SelectorObj = document.querySelectorAll(".queryItem");
                    SelectorObj.forEach((x, index) => {
                        let getqueryListResult = [];
                        let spanEle = x.querySelector('span.questionList_txt');
                        let checkboxEle = x.querySelector('input[type="checkbox"]');                        
                        if (spanEle) {
                            getqueryListResult.push({
                                CompanyID: SelectedCompanyID(),
                                AgentID: agentID,
                                QueryID: x.id,
                                [spanEle.name]: spanEle.textContent,
                                UseFlag: checkboxEle.checked ? "Y" : "N",
                                SN: index + 1,
                            });
                        }

                        //let TrObj = query.querySelectorAll('tr');
                        //TrObj.forEach(x => {
                        //    let inputEle = x.querySelector('input');  // 각 tr에서 첫 번째 input 요소 선택
                        //    if (inputEle) {
                        //        getqueryListResult.push({
                        //            [inputEle.name]: inputEle.value
                        //        });
                        //    }
                        //});
                        getAgentValueResult.push(getqueryListResult);
                    });
                    break;
                case "AGENTNAME":
                case "DESCRIPTION":
                    getAgentValueResult = [];
                    
                    SelectorObj = document.querySelectorAll(`[id^='${selector}']`);
                    SelectorObj.forEach((x, index) => {
                        getAgentValueResult.push({                            
                            [x.id]: x.value,
                        });
                    });
                    break;
                default:
                    getAgentValueResult = SelectorObj[0].value;
                    break;
            }
        } else {
            SelectorObj = document.getElementById(key);

            switch (SelectorObj.tagName.toUpperCase()) {
                case "INPUT":
                    getAgentValueResult = SelectorObj.value;
                    break;
                case "SPAN":
                case "DIV":
                    getAgentValueResult = SelectorObj.textContent;
                    break;
                case "TABLE":
                    getAgentValueResult = [];
                    let TrObj = SelectorObj.querySelectorAll('tr');
                    TrObj.forEach(x => {
                        let inputEle = x.querySelector('input');  // 각 tr에서 첫 번째 input 요소 선택
                        if (inputEle) {
                            getAgentValueResult.push({
                                [inputEle.id]: inputEle.value
                            });
                        }
                    });
                    break;
            }
        }
    } catch (e) {
        console.log(e);
    }
    return getAgentValueResult;
}


function GetAgentInfo(obj) {
    AgentLoading = createLoadingFun('AgentConfigDiv');
    AgentLoading(true);   
    try {
        let agentList = AgentListDiv.querySelectorAll("li");

        agentList.forEach(x => {
            if (obj.id == x.id) {
                x.className = "on";
            } else {
                x.className = "";
            }        
        });

        let displayAgentName = document.querySelector("#displayAgentName");
        displayAgentName.textContent = obj.querySelector("span").textContent;
        manageType.textContent = "Agent 수정";

        let agentID = obj.id;
        selectedAgentID = agentID;
        let sendData = {};

        sendData = { agentID }

        GetAgentInfoToDb(sendData, data => {
            let okFlag = SetAgentData(data);
            mode = "MOD";
            AppendFileAttachInfo(MakeAttachList());
            AgentLoading(false);
        });
        
    } catch (e) {
        console.error(e);
    }
}

function GetAgentInfoToDb(param, callback) {
    let res = 0;
    try {
        let companyid = SelectedCompanyID();
        //let params = setQueryString({ companyid }, encodeURIComponent);

        let url = `${AdminAppPath}/GetAgentInfo`;
        res = postXhr(url, JSON.stringify(param), callback);
    } catch (e) {
        console.error(e);
    }
    return res;
}
function SetAgentData(param) {
    try {
        param = JSON.parse(param);
        for (var key in param) {
            switch (key) {
                case "AgentModel":
                case "AgentQueryModelList":
                    if (Array.isArray(param[key])) {
                        ClearQueryList();
                        param[key].forEach(function (queryModel, index) {
                            AddQueryElement(queryModel, index);
                        });
                    } else {
                        for (var property in param[key]) {
                            if (param[key].hasOwnProperty(property)) {
                                var element = document.getElementById(property);
                                if (element) {
                                    if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA' || element.tagName === 'SELECT') {
                                        element.value = param[key][property] || '';
                                    } else {
                                        element.textContent = param[key][property] || '';
                                    }
                                }
                            }
                        }
                    }
                    break;
                case "AgentEmbeddingsModelList":
                    break;
                default:
            }
        }
    } catch (e) {
        console.error('Error setting agent data:', e);
    }
}
// Agent 생성
function CreateAgent() {
    try {
        mode = "ADD";
        document.querySelector("#AgentID").textContent = agentID;
        document.querySelector("#manageType").textContent = "Agent 생성";
        document.querySelector("#displayAgentName").textContent = "[AI 가이드 이름]";
        document.querySelector("#AttachLimit").value = 0;
        document.querySelector("#AgentName").value = "";
        document.querySelector("#AgentName2").value = "";
        document.querySelector("#AgentName3").value = "";
        document.querySelector("#AgentName4").value = "";
        document.querySelector("#Description").value = "";
        document.querySelector("#Description2").value = "";
        document.querySelector("#Description3").value = "";
        document.querySelector("#Description4").value = "";
        document.querySelector("#QueryGuide").value = "";
        document.querySelector("#QueryGuide2").value = "";
        document.querySelector("#QueryGuide3").value = "";
        document.querySelector("#QueryGuide4").value = "";
        ClearQueryList();
        dadiframe.btnfiledel_all();
    } catch (e) {
        console.log(e);
    }
}



// 임베딩후 테스트 START
function executeOpenAI(thisObj) {
    if (!thisObj || thisObj.getAttribute("disabled") == "disabled") {
        return;
    }

    gAiObj = thisObj;
    let companyid = SelectedCompanyID();
    let pAi_result_area = thisObj.parentElement.parentElement.parentElement.querySelector(".ai_result_area");
    let pExecuteContent = "";

    if (pAi_result_area != null) {

        let userPromptObj = thisObj.parentElement.parentElement.parentElement.querySelector(".ai_chat_input_text");
        let userPrompt = userPromptObj.value;

        if (thisObj.dataset.simpletype == null && userPrompt.replace(/ /gi, "").replace(/\n/gi, "").replace(/\r/gi, "").replace(/\t/gi, "") == "") {
            return;
        }

        let pRowDivEle = document.createElement("p");
        pRowDivEle.classList.add("rowContent_AI");
        pRowDivEle.classList.add("right");

        // 질문
        let pDivEle = document.createElement("div");
        pDivEle.classList.add("myContent_AI");
        pDivEle.innerText = userPrompt;

        pRowDivEle.appendChild(pDivEle);
        pAi_result_area.appendChild(pRowDivEle);

        pExecuteContent = userPrompt;
        userPromptObj.value = "";
        chat_area_resize_trgger(userPromptObj);

        scrollBottom(pAi_result_area);

        let xmlpara = createXmlDom();
        let objNode;
        objNode = createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "MESSAGE", pExecuteContent);
        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyid);
        createNodeAndInsertText(xmlpara, objNode, "AGENTID", agentID);

        // python 백엔드 api 호출
        callPostAsyncStreaming(getXmlString(xmlpara));
    }
}
// python 백엔드 api 호출
function callPostAsyncStreaming(strXml) {
    if (!gAiObj) {
        return;
    }

    fetch(`${AdminRemoteAppPath}/AgentTest`, {
        method: 'POST',
        headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'Accept': 'text/event-stream'  // 수신 시 스트리밍만 허용
        },
        body: strXml
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }

            var newResponseId = GetGUID();
            var newResponseMenuId = GetGUID();
            var pAi_result_area = gAiObj.parentElement.parentElement.parentElement.querySelector(".ai_result_area");
            if (pAi_result_area != null) {
                var pRowDivEle = document.createElement("p");
                pRowDivEle.classList.add("rowContent_AI");
                pRowDivEle.classList.add("left");

                // 답변 영역
                var pDivEle = document.createElement("div");
                pDivEle.setAttribute("id", newResponseId);
                pDivEle.classList.add("myContent_AI");
                pDivEle.innerText = "";

                // // 답변에 대한 서브 메뉴 생성
                // var pDivEleMenu = document.createElement("div");
                // pDivEleMenu.classList.add("myContent_AI_Menu");
                // pDivEleMenu.innerHTML = '<div class="expandButton" id="' + newResponseMenuId + '" style="display: none;"><ul style="top:auto">  <li title="복사" onclick="javascript:CopyClipboard(\'' + newResponseId + '\');"><img src="" style="width:20px; height:20px;"></li>  </ul></div>';

                pRowDivEle.appendChild(pDivEle);
                //pRowDivEle.appendChild(pDivEleMenu);
                pAi_result_area.appendChild(pRowDivEle);
            }

            const reader = response.body.getReader();
            const decoder = new TextDecoder('utf-8');

            var buffer = "";
            function read() {
                reader.read().then(({ done, value }) => {
                    //console.log("done: ", done);
                    //console.log("value: ", value);

                    var area = document.getElementById(newResponseId);

                    // 응답이 완료된 후 별도 처리가 필요한 경우 여기에서 처리
                    if (done) {
                        // 마지막줄 처리
                        setMessageArea(area, buffer);

                        // ai로 부터 응답 완료 후 연동 처리
                        var bMenuShow = setResponseEndFromAi(newResponseId);

                        // 응답이 완료된 후 답변에 대한 메뉴가 보이도록 처리
                        if (bMenuShow == true) {
                            if (newResponseMenuId) {
                                var menu = document.getElementById(newResponseMenuId);
                                if (menu) {
                                    menu.style.display = "inline";
                                }
                            }
                        }

                        scrollBottom(pAi_result_area);
                        return;
                    }

                    var chunk = decoder.decode(value, { stream: true });
                    //console.log(chunk);

                    buffer += chunk;

                    // 새 응답을 업데이트 후 불완전한 마지막줄 보관
                    buffer = updateAiMessage(buffer, area);

                    scrollBottom(pAi_result_area);

                    read();
                });
            }

            read();
        })
        .catch(error => {
            Alert_Message("callPostAsyncStreaming error: " + error, null, "4");
        });
}

function AddQueryElement(queryModel, index) {
    try {
        // MAIN DIV
        let queryDiv = document.createElement("DIV");
        queryDiv.className = "queryItem";
        if (queryModel.QueryID)
            queryDiv.id = queryModel.QueryID;
        // MAIN DIV END

        // SWITCH DIV
        let switchDiv = document.createElement("DIV");
        switchDiv.className = "switchWrap";
        queryDiv.appendChild(switchDiv);

        // SWITCH DIV >> SWITCH INPUT
        let queryUseCheckInput = document.createElement("INPUT");
        queryUseCheckInput.id = "chbox_" + queryModel.AgentID + index;
        queryUseCheckInput.type = "CHECKBOX";
        if (queryModel.UseFlag == "Y")
            queryUseCheckInput.checked = true;

        switchDiv.appendChild(queryUseCheckInput);
        // SWITCH DIV >> SWITCH INPUT END

        // SWITCH DIV >> SWITCH LABEL
        let queryCheckDiv = document.createElement("DIV");

        let queryCheckLabel = document.createElement("LABEL");
        SetAttribute(queryCheckLabel, "for", "chbox_" + queryModel.AgentID + index)
        queryCheckDiv.appendChild(queryCheckLabel);

        let queryCheckLaSpan = document.createElement("SPAN");
        queryCheckLabel.appendChild(queryCheckLaSpan);

        switchDiv.appendChild(queryUseCheckInput);
        switchDiv.appendChild(queryCheckDiv);
        // SWITCH DIV >> SWITCH LABEL END
        // SWITCH DIV END

        // QUERY CONTENT SPAN        
        let queryGuideKeys = Object.keys(queryModel).filter(key => key.startsWith('QueryGuide'));
        
        let queryContentSpan = document.createElement("SPAN");
        queryContentSpan.textContent = queryModel[queryGuideKeys[0]];
        queryContentSpan.className = "questionList_txt";
        queryContentSpan.name = queryGuideKeys[0];
        queryDiv.appendChild(queryContentSpan);
        // QUERY CONTENT SPAN END

        //Query Button
        let QueryModifyBtn = document.createElement("BUTTON");
        QueryModifyBtn.type = "button";
        QueryModifyBtn.className = "btn20_text";
        QueryModifyBtn.textContent = "수정";
        QueryModifyBtn.addEventListener("click", function () {
            alert("수정");
        });

        let QueryDeleteBtn = document.createElement("BUTTON");
        QueryDeleteBtn.type = "button";
        QueryDeleteBtn.className = "btn20_text";
        QueryDeleteBtn.textContent = "삭제";
        QueryDeleteBtn.addEventListener("click", function () {
            let queryItem = this.closest(".queryItem");

            if (queryItem) {
                queryItem.remove(); // queryItem 요소를 삭제
            }
            let queryItemList = document.querySelectorAll(".queryItem");
            if (queryItemList.length < 1) {
                let addQueryBtn = document.querySelector("#displayAddQueryBtn");
                if (addQueryBtn) {  // #displayAddQueryBtn 요소가 존재할 경우에만 클릭
                    addQueryBtn.click();
                }
            }
        });

        queryDiv.appendChild(QueryModifyBtn);
        queryDiv.appendChild(QueryDeleteBtn);
        //Query Button END

        document.getElementById("queryListDiv").appendChild(queryDiv);
    } catch (e) {

    }
}

function ClearQueryList() {
    let queryListDiv = document.querySelector("#queryListDiv");
    let divElements = queryListDiv.querySelectorAll("div"); // #queryListDiv 안에 있는 모든 div 요소들

    // 첫 번째 div를 제외하고 나머지 div들 삭제
    divElements.forEach((div, index) => {
        if (index !== 0) { // 첫 번째 요소는 건너뛰고
            div.remove(); // 나머지 div 제거
        }
    });

    document.querySelector("#InputQueryDiv").style.display = "";

}

function SetAgentSort() {
    try {
        let agentSort = [];
        let agentList = document.querySelectorAll("#AgentListDiv li");

        agentList.forEach((item, index) => {
            agentSort.push({
                AgentID: item.id,
                SN: index + 1
            });
        });
        sendData =
        {
            AgentSort: agentSort,
        };
        if (agentSort.length > 0) {
            SetAgentSortToDb(sendData, data => {
                let okFlag = data;
                let msg = okFlag == "OK" ? "Agent Sorting이 완료되었습니다." : "Agent Sorting에 실패했습니다.";

                Alert_Message(msg, () => {
                    
                }, okFlag == "OK" ? "2" : "4");
            });
        }

    } catch (e) {
        console.log(e);
    }
}

function SetAgentSortToDb(param, callback) {
    let res = 0;
    try {
        let companyid = SelectedCompanyID();
        //let params = setQueryString({ companyid }, encodeURIComponent);

        let url = `${AdminRemoteAppPath}/SetAgentSort`;
        res = postXhr(url, JSON.stringify(param), callback);
    } catch (e) {
        console.error(e);
    }
    return res;
}

function escapeIdSelector(id) {
    return id.replace(/([\\{}])/g, '\\$1');
}

function SelectedCompanyID() {
    //let CompanyID = '@companyid';
    let CompanyID = '';
    try {
        let dom = GetPageType() === 'LOAD' ? document : isPopupOpener().document;
        let ListCompany = dom.getElementById('ListCompany');
        if (ListCompany) {
            CompanyID = ListCompany.value;
        }
        else {
            try {
                CompanyID = userinfoCompanyID;
            } catch (e) {
                CompanyID = parent.userinfoCompanyID;
            }
        }
    } catch (e) {
        console.error(e);
    }
    return CompanyID;
}

function ShowMailProgress() {
    //document.getElementById("mailPanel").style.display = "";
    document.getElementById("MailProgress").style.top = "100px";
    document.getElementById("MailProgress").style.left = (document.documentElement.clientWidth / 2) - 100 + "px";
    document.getElementById("MailProgress").style.display = "";
}

function HiddenMailProgress() {
    //document.getElementById("mailPanel").style.display = "none";
    document.getElementById("MailProgress").style.display = "none";
}

/** 메시지 영역에 새 응답을 업데이트 */
function updateAiMessage(buffer, messageDiv) {
    // 개행문자로 행간 구분
    var lines = buffer.split('\n');

    // 불완전한 마지막 줄을 제외하고 모든 완전한 줄을 처리합니다.
    for (var i = 0; i < lines.length - 1; i++) {
        var line = lines[i].trim();
        setMessageArea(messageDiv, line);
    }

    // 불완전한 마지막줄 보관
    buffer = lines[lines.length - 1];

    return buffer;
}

function setMessageArea(messageDiv, message) {
    var formattedMessage = formatMessage(message);
    if (!formattedMessage) {
        formattedMessage = "<br />";
    }

    messageDiv.innerHTML += formattedMessage;
}

/** 마크다운과 유사한 구문을 HTML로 변환 */
function formatMessage(message) {
    // Convert Markdown to HTML
    var rawHTML = marked.parse(message);

    // xss 공격 방지
    var sanitizedHTML = DOMPurify.sanitize(rawHTML);

    return sanitizedHTML;
}
function chat_area_resize(obj) {

    if (event.key === "Enter" && event.keyCode === 13 && event.which === 13 && !event.shiftKey) {
        event.preventDefault();
        sendChatModelBtn.click();
    }

    if (obj.style.height == "0px" || obj.scrollHeight == 0) {
        obj.style.height = "100px";
    } else {
        obj.style.height = "auto";
        obj.style.height = obj.scrollHeight + "px";
    }
}

function chat_area_resize_trgger(obj) {   
    chat_area_resize(obj);
}

function scrollBottom(thisObj) {
    thisObj.scrollTop = thisObj.scrollHeight;
}
// 임베딩후 테스트 END