
// ai 애니메이션 효과 start
//var $ = jQuery.noConflict();
$(document).ready(function() {
    console.log("jQuery noConflict");
    // 첨부펼치기
    $(document).on('click', '.textarea_value .btn_upload_drop', function () {
        $('.btn_upload_drop, .upload_file').toggleClass('active');
    });

    // 첨부닫기
    $(document).on('click', '.textarea_value textarea', function () {
        $('.btn_upload_drop, .upload_file').removeClass('active');
    });
});

function fn_showViewoption() {
    var pActiveView = null;
    var thisObj = document.getElementById("aiView");
    // hide
    if ($(thisObj).hasClass("ds_active")) {
        $(thisObj).removeClass("ds_active");
        $(thisObj.parentElement).removeClass('on');
        $(thisObj.querySelector(".docinfotoggleimg")).removeClass('on');
    }
    // show
    else {
        $(thisObj).toggleClass('ds_active');
        $(thisObj.parentElement).toggleClass('on');
        $(thisObj.querySelector(".docinfotoggleimg")).toggleClass('on');

        if (thisObj.parentElement.classList.contains("ds_lay_viewOpenAI")) {
            if (thisObj.parentElement.querySelector(".ds_settings_section_body") != null) {
                if (thisObj.parentElement.querySelector(".ds_settings_section_body").innerHTML.replace(/ /gi, "").replace(/\n/gi, "").replace(/\r/gi, "").replace(/\t/gi, "") == "") {
                    var openUrl = getCoreAppPath() + "/ezAi/Main/UseAI";
                    var pPageType_AI = thisObj.parentElement.dataset.type;
                    var pPageSubType_AI = thisObj.parentElement.dataset.subtype;
                    openUrl += "?type=" + pPageType_AI + "&subtype=" + pPageSubType_AI;
                    SessionLoadUrlContent(openUrl, thisObj.parentElement.querySelector(".ds_settings_section_body"), function (responsText, textStatus, xhrObject, selObj) {

                        document.querySelectorAll(".ai_chat_body > .ai_chat_input_area > .ai_chat_input_div > .ai_chat_input_scroll > .ai_chat_input_text").forEach(function (element) {
                            element.setAttribute("contenteditable", "true");
                            element.focus();
                            element.blur();
                        });
                    });
                }
            }
        }
    }
}
// ai 애니메이션 효과 end

// *** ai chat start
document.getElementById("chatInput").addEventListener("keyup", function(event) {
    if (event.key === 'Enter' && !event.shiftKey) {
        event.preventDefault();
        userInput();
    }
});

// 추천 promt 클릭
function simplePrompt(element) {
    const displayText = element.textContent.trim(); // 화면에 보일 텍스트
    const userText = element.getAttribute("data-comment"); // 실제 프롬프트로 사용할 값

    if (!userText) {
        return;
    }

    const chatInput = document.getElementById("chatInput");
    chatInput.value = "";

    aiSend(userText, displayText);
}

// 사용자 입력
function userInput() {
    const chatInput = document.getElementById("chatInput");
    const userText = chatInput.value.trim();
    chatInput.value = "";
    
    if (!userText) {
        return;
    }

    aiSend(userText, userText);
}

// ai 전송 main
async function aiSend(userText, displayText) {
    appendUserChatWithLoading(displayText);

    const aiTextDivs = document.querySelectorAll('.ai_text.al_loading');
    const aiLoadingDiv = aiTextDivs[aiTextDivs.length - 1];

    if (!aiLoadingDiv) {
        console.warn('No loading div found.');
        return;
    }

    const requestData = createRequestData(userText);

    try {
        const response = await fetch('/ezAI/ai/stream.do', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(requestData)
        });

        if (!response.ok) {
            throw new Error(`HTTP error ${response.status}: ${response.statusText}`);
        }

        const resultSpan = renderAiResultContainer(aiLoadingDiv);
        const reader = response.body.getReader();
        await streamAndRender(reader, resultSpan);

    } catch (error) {
        console.error('AI streaming failed:', error.message || error);
        showError(aiLoadingDiv);
    }

    scrollToBottom();
}

// 데이터
function createRequestData(userText) {
    return {
        meta: extractEmailMetaData(),
        userPrompt: userText,
        content: extractEmailContent(), // 메일본문
        attachedFiles: extractAttachedFiles() // 첨부파일 정보 추가
    };
}

// 로딩 div -> 응답 UI, 응답 출력을 표출할 span 반환
function renderAiResultContainer(aiLoadingDiv) {
    const resultDiv = document.createElement("div");
    resultDiv.className = "ai_text";
    resultDiv.setAttribute("name", "chatText");

    const iconSpan = document.createElement("span");
    iconSpan.className = "icon_ai";

    const resultSpan = document.createElement("span");
    resultSpan.className = "ai_text_detail";

    // 버튼 start
    const editBtn = document.createElement("button");
    editBtn.type = "button";
    editBtn.setAttribute("data-mode", "EDIT");
    editBtn.innerText = msgEdit;
    editBtn.onclick = toggleEditMode;

    // 버튼 사이에 띄어쓰기용 공백 span 추가
    const space = document.createElement("span");
    space.innerHTML = "&nbsp;"; // 공백 문자
    
    const copyBtn = document.createElement("button");
    copyBtn.type = "button";
    copyBtn.innerText = msgCopy;
    copyBtn.onclick = copy;
    // 버튼 end

    resultDiv.appendChild(iconSpan);
    resultDiv.appendChild(resultSpan);
    resultDiv.appendChild(editBtn);
    resultDiv.appendChild(space); // 공백 삽입
    resultDiv.appendChild(copyBtn);

    aiLoadingDiv.replaceWith(resultDiv);

    return resultSpan;
}

// SSE 스트림 읽고 결과 출력
async function streamAndRender(reader, resultSpan) {
    const decoder = new TextDecoder("utf-8");
    let buffer = "";

    while (true) {
        const { done, value } = await reader.read();
        if (done) {
            if (buffer.trim()) {
                renderLine(resultSpan, buffer);
            }
            break;
        }

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop(); // incomplete line

        for (const line of lines) {
            if (line.startsWith('event: error')) {
                console.error('Server sent error event');
                showError(resultSpan.parentNode); // 부모 노드로 이동해서 에러표시
                return;
            }

            if (line.startsWith('data: ')) {
                renderLine(resultSpan, line.replace(/^data:\s*/, ''));
            } else {
                renderLine(resultSpan, ''); // 빈 라인도 출력
            }
        }
    }
}

// 한 줄 렌더링
   function renderLine(resultSpan, text) {
       resultSpan.innerHTML += escapeHtml(text) + '<br>';
       scrollToBottom();
}

// 에러 처리
function showError(aiLoadingDiv) {
    const errorDiv = document.createElement("div");
    errorDiv.className = "ai_text";
    errorDiv.setAttribute("name", "chatText");

    const iconSpan = document.createElement("span");
    iconSpan.className = "icon_ai";

    const resultSpan = document.createElement("span");
    resultSpan.className = "ai_text_detail";
    resultSpan.innerHTML = '<span style="color:red;">' + msgErrShow + '</span>';

    errorDiv.appendChild(iconSpan);
    errorDiv.appendChild(resultSpan);

    aiLoadingDiv.replaceWith(errorDiv);
}

function scrollToBottom() {
    const container = document.querySelector(".container_main_simple");
    if (container) {
        container.scrollTo({
            top: container.scrollHeight,
            behavior: "smooth"
        });
    }
}

// 사용자 요청 chat에 올리기
function appendUserChatWithLoading(userText) {
    // 입력값 가져오기
    if (userText === "") return; // 빈 문자열일 경우 종료

    // 사용자 메시지 div 생성
    const newUserDiv = document.createElement("div");
    newUserDiv.className = "user_text";
    newUserDiv.setAttribute("name", "chatText");
    newUserDiv.innerText = userText;

    // AI 로딩 div 생성
    const loadingDiv = document.createElement("div");
    loadingDiv.className = "ai_text al_loading";
    loadingDiv.setAttribute("name", "chatText");
    loadingDiv.innerHTML = `
        <span class="icon_ai"></span>
        <span class="loading_icon"></span>
    `;

    // 마지막 chatText 요소 찾기
    const chatContent = document.getElementById("chatContent");
    const chatTexts = chatContent.querySelectorAll('div[name="chatText"]');
    const lastChatText = chatTexts[chatTexts.length - 1];

    // DOM에 삽입
    if (lastChatText && lastChatText.parentNode === chatContent) {
        lastChatText.insertAdjacentElement("afterend", newUserDiv);
        newUserDiv.insertAdjacentElement("afterend", loadingDiv);
    } else {
        chatContent.appendChild(newUserDiv);
        chatContent.appendChild(loadingDiv);
    }
    
    scrollToBottom();
}

// 편집 버튼
function toggleEditMode(event) {
    const button = event.target;
    const currentMode = button.getAttribute("data-mode");

    const aiTextDiv = button.closest(".ai_text");
    const detailDiv = aiTextDiv.querySelector(".ai_text_detail");

    if (currentMode === "EDIT") {
        button.setAttribute("data-mode", "COMPLETE");
        button.innerText = msgComplete;

        detailDiv.setAttribute("contenteditable", "true");
        detailDiv.focus();

    } else {
        button.setAttribute("data-mode", "EDIT");
        button.innerText = msgEdit;

        detailDiv.removeAttribute("contenteditable");
    }
}


// 복사 버튼
function copy(event) {
    const aiTextDiv = event.target.closest(".ai_text");
    if (!aiTextDiv) return;

    const contentElement = aiTextDiv.querySelector(".ai_text_detail");
    const text = contentElement.tagName === 'TEXTAREA' ? contentElement.value : contentElement.innerText;

    // fallback 복사
    const temp = document.createElement("textarea");
    temp.value = text;
    document.body.appendChild(temp);
    temp.select();
    try {
        document.execCommand("copy");
        toastr.success(msgCopySucc);
    } catch (err) {
        toastr.error(msgCopyFail);
        console.log(msgCopyFail + ": " + err);
    } finally {
        document.body.removeChild(temp);
    }
}

// HTML escape 함수
function escapeHtml(text) {
    var map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
}

function extractAttachedFiles() {
    const uploadFileDiv = document.querySelector(".upload_file");
    const spans = uploadFileDiv.querySelectorAll("span");

    const attachedFiles = [];

    spans.forEach(span => {
        const filePath = span.getAttribute("data-filepath");
        const fileName = span.getAttribute("data-filename");

        if (filePath && fileName) {
            attachedFiles.push({
                FilePath: filePath,
                FileName: fileName
            });
        }
    });

    return attachedFiles;
}

function extractEmailContent() {
  const normalScreen = document.getElementById('normalScreen');
  if (normalScreen) {
    const tempDiv = document.createElement('div');
    const htmlString = normalScreen.outerHTML;
    tempDiv.innerHTML = htmlString;
    
    return tempDiv.textContent || tempDiv.innerText || "";
  } else {
    console.log(msgErrExtract);
    return "";
  }
}

function extractEmailMetaData() {
  const parentDoc = window.parent.document;
  
  // 제목
  const subjectEl = parentDoc.querySelector('.mail_readTitle');
  const subject = subjectEl ? subjectEl.innerText : '';

    // From
    const senderEl = parentDoc.querySelector('#MsgToPut');
    const senderName = senderEl ? senderEl.innerText : '';
    const senderEmail = senderEl ? senderEl.getAttribute('title') || '' : '';
    const sender = senderName && senderEmail ? `${senderName}<${senderEmail}>` : senderName || senderEmail;
    
    // To
    const recipientNameEl = parentDoc.querySelector('.recipient_list .name');
    const recipientName = recipientNameEl ? recipientNameEl.innerText : '';
    const recipientEmail = recipientNameEl ? recipientNameEl.getAttribute('title') || '' : '';
    const recipient = recipientName && recipientEmail ? `${recipientName}<${recipientEmail}>` : recipientName || recipientEmail;
  
  // 날짜
  const dateEl = parentDoc.querySelector('.day_mark .day span');
  const date = dateEl ? dateEl.innerText : '';

  return "subject: " + subject +", sender: " + sender + ", recipient: " + recipient + ", received date: " + date;
}
// ai chat end

// ai file upload start
var filesize = 0;
var fileArray = [];
var xhr = new XMLHttpRequest();
var filelist;
var isfileup = false;
var filedate = new Date().getTime().toString(); // 파일 업로드 타임스탬프

function btnfileup() {
    document.getElementById("file").click();
}

function filechange(e) {
    if (!document.getElementById("file").value == "") {
        onDrop();
    }
}

function onDrop(evt) {
    if (evt != undefined) {
        evt.stopPropagation();
        evt.preventDefault();

        if (evt.dataTransfer.items == undefined || evt.dataTransfer.items == null) {

            if (evt.dataTransfer.files.length == 0) {
                alertPopup(strLangKMS08);
                return;
            }

        } else {
            for (const item of evt.dataTransfer.items) {
                const entry = item.webkitGetAsEntry();

                if (entry.isFile) {
                } else if (entry.isDirectory) {
                    alertPopup(strLangKMS08);
                    return;
                }
            }
        }
    }

    if (isfileup) {
        alertPopup(strLang86);
        return;
    }

    if (evt == undefined) {
        filelist = document.getElementById("file").files;
    } else {
        filelist = evt.dataTransfer.files;
    }

    var tempfilesize = 0;
    var filecnt = fileArray.length;

    if (aiAttachMBSize > 0) { // 0 일때는 무제한으로 else 탐
        for (var i = 0; i < filelist.length; i++) {
            if (filelist[i].size / 1024 / 1024 > aiAttachMBSize) {
                if ("${ userInfo.lang }" == "2") {
                    alertPopup(strLang75 + aiAttachMBSize + strLang76);
                } else {
                    alertPopup(strLang75 + aiAttachMBSize + "MB" + strLang76);
                }
                return;
            } else {
                fileArray[filecnt + i] = filelist[i];
                tempfilesize += filelist[i].size;
            }
        }
    
        if ((filesize + tempfilesize) / 1024 / 1024 > aiAttachMBSize) {
            if ("${ userInfo.lang }" == "2") {
                alertPopup(strLang75 + aiAttachMBSize + strLang76);
            } else {
                alertPopup(strLang75 + aiAttachMBSize + "MB" + strLang76);
            }
            return;
        }
    } else {
        for (var i = 0; i < filelist.length; i++) {
            fileArray[filecnt + i] = filelist[i];
            tempfilesize += filelist[i].size;
        }
    }

    filesize += tempfilesize;

    fileupload();

    if (CrossYN()) {
        if (navigator.userAgent.search('Trident') != -1) { //IE 11
            document.getElementById("file").type = "text";
            document.getElementById("file").type = "file";
        } else {
            document.getElementById("file").value = "";
        }

    } else {
        document.getElementById("file").type = "text";
        document.getElementById("file").type = "file";
    }
}

var attachedFileNameFilteringArr = [];

function fileupload() {
    isfileup = true;

    var fd = new FormData();
    var fdSize = 0;
    var plainText_BigAttChk = false;

    for (var i = 0; i < filelist.length; i++) {
        var fnl = filelist[i].name.length;

        if (fnl > attachFileNameMaxLength) {
            alertPopup("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
            isfileup = false;
            return;
        } else if (attachedFileNameFilteringArr.length > 0) {
            var validFilteringFileName = true;

            for (var attachedFileNameFilter of attachedFileNameFilteringArr) {

                // 첨부파일명에 필터링 문구가 하나라도 포함되면 리턴 있으면 발송
                if ((filelist[i].name).indexOf(attachedFileNameFilter) > -1) {
                    fdSize++;
                    fd.append("fileToUpload", filelist[i]);
                    validFilteringFileName = true;
                    break;
                // 첨부파일명에 필터링 문구가 없으면 리턴
                } else {
                    validFilteringFileName = false;
                }
            }

            if (!validFilteringFileName) {
                fileNameFiltering(attachedFileNameFilteringArr);
                isfileup = false;
                return;
            }
        } else {
            fdSize++;
            fd.append("files", filelist[i]);
        }
    }

    fd.append("maxsize", aiAttachMBSize);
    fd.append("cnt", filelist.length);
    fd.append("txtName", filedate);
    
    xhr.open("POST", "/ezAI/ai/upload.do");
    xhr.send(fd);
    
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            isfileup = false;
    
            if (xhr.status === 200) {
                try {
                    const response = JSON.parse(xhr.responseText);
                    if (Array.isArray(response)) {
                        renderUploadedFiles(response); // 성공적으로 파일을 받으면 UI 갱신
                    } else {
                        toast(msgErrUpload).error();
                    }
                } catch (e) {
                    console.error("upload response error :", e);
                    toast(msgErrUpload).error();
                }
            } else {
                toast(msgErrUpload).error();
            }
        }
    };
}

function renderUploadedFiles(newFiles) {
    const uploadFileDiv = document.querySelector(".upload_file");

    // fileCount 버튼 처리
    let fileCountBtn = uploadFileDiv.querySelector(".btn_upload_drop");
    if (!fileCountBtn) {
        fileCountBtn = document.createElement("button");
        fileCountBtn.type = "button";
        fileCountBtn.className = "btn_upload_drop";
        uploadFileDiv.appendChild(fileCountBtn);
    }

    const currentFileCount = uploadFileDiv.querySelectorAll("span").length;
    fileCountBtn.textContent = currentFileCount + newFiles.length + "개";

    newFiles.forEach(file => {
        const span = document.createElement("span");
        span.id = file.id;
        span.setAttribute("data-filepath", file.filepath);
        span.setAttribute("data-filename", file.filename);
        span.setAttribute("data-file-size", file.fileSize);
        span.setAttribute("data-file-ext", file.fileExt || "");

        span.innerHTML = `${file.filename}<button type="button" class="btn_close" onclick="removeFile(this)"></button>`;

        uploadFileDiv.appendChild(span);
    });
}

function removeFile(obj) {
    if (!obj) {
        return;
    }

    var refDocumentsObj = document.querySelector(".ds_lay_viewOpenAI.on .refDocuments");
    var refDocumentsContainerObj = refDocumentsObj.querySelector(".upload_file");

    // 파일 삭제
    var delObj = document.getElementById(obj.parentElement.id);
    if (delObj) {
        // 삭제된 파일의 파일경로를 가져와 해당 파일 요소 삭제
        var filepath = delObj.dataset.filepath;
        delObj.remove();

        // 삭제 후, 남은 파일 개수 업데이트
        updateFileCount(refDocumentsContainerObj);
    }
}

// 파일 개수 업데이트 함수
function updateFileCount(refDocumentsContainerObj) {
    var remainingFiles = refDocumentsContainerObj.querySelectorAll("span");
    var fileCount = remainingFiles.length;  // 현재 남아있는 파일 개수
    
    if (fileCount === 0) {
        refDocumentsContainerObj.innerHTML = "";
        return; // 파일이 없으면 종료
    }
    
    var fileCountBtn = refDocumentsContainerObj.querySelector('.btn_upload_drop');
    
    if (fileCountBtn) {
        fileCountBtn.textContent = fileCount + "개";  // 버튼의 텍스트를 갱신
    }
}

// drag&drop으로 파일 첨부
window.addEventListener("DOMContentLoaded", function () {
    const dropZone = document.getElementById("dropZone");

    // 드래그 중일 때 시각적 효과
    dropZone.addEventListener("dragover", function (e) {
        e.preventDefault();
        dropZone.classList.add("dragover");
    });

    // 드래그 취소 시 효과 제거
    dropZone.addEventListener("dragleave", function (e) {
        e.preventDefault();
        dropZone.classList.remove("dragover");
    });

    // 드롭 시 파일 처리
    dropZone.addEventListener("drop", function (e) {
        e.preventDefault();
        dropZone.classList.remove("dragover");
        onDrop(e);  // 기존 함수 호출
    });
});
// ai file upload end

