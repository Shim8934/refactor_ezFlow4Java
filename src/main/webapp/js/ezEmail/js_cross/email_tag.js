/*
    메일 태그기능 공통 함수 
*/

function showError(message) {
    alert(message || strLang321);
}

function removeTag(span) {
    // g_paramURL이 빈값이면 분류에서 사용
    if (typeof g_paramURL !== 'undefined' || typeof Old_Preview_Href !== 'undefined') {
        var folderPath, mailUid;
        
        if (typeof g_paramURL !== 'undefined') {
            [folderPath, mailUid] = g_paramURL.split("/");
        } else {
            [folderPath, mailUid] = Old_Preview_Href.split("/");
        }
        
        var tagName = span.innerText;

        deleteTag(folderPath, mailUid, tagName, function(success) {
            if (success && window.leftMenu) {
                leftMenu.reloadTags();
            }
           
        });
    }
    // 항상 태그를 제거
    $(span.nextElementSibling).remove();
    $(span.parentNode).remove();
    $(span).remove();
}

function deleteTag(folderPath, mailUid, tagName, callback) {
    $.ajax({
        method: "post",
        url: "/ezEmail/deleteMailTag.do",
        data: { folderPath, mailUid, tagName, shareId },
        success: function(result) {
            callback(result.status !== "error");
        },
        error: function() {
            showError();
            callback(false);
        }
    });
}

function appendTag(tagName, containerId) {
    var tagContainer = document.getElementById(containerId);
    var tagListDiv = document.createElement("div");
    tagListDiv.className = "tag_list";
    tagListDiv.style.display = "flex";

    var tagSpan = document.createElement("span");
    tagSpan.innerText = tagName;
    tagSpan.className = "tag_name";
    tagSpan.style.flex = "1";

    var deleteSpan = document.createElement("span");
    deleteSpan.className = "tag_del";
    deleteSpan.addEventListener("click", function() { removeTag(tagSpan); });

    tagListDiv.appendChild(tagSpan);
    tagListDiv.appendChild(deleteSpan);
    tagContainer.appendChild(tagListDiv);
}

function onEnterTagInput(tagInputId, idPrefix ,successCallback) {
    var tagInput = document.getElementById(tagInputId);
    var tagName = tagInput.value.trim();
    if (tagName.length <= 0) return;
    
    var tagview = idPrefix != "" ?  idPrefix + 'view' : 'tag_view';
    
    if ($.grep(document.querySelectorAll("#"+tagview+"> div > span"), function(span) { return span.innerText === tagName; }).length > 0) {
        alert(strLangTagAlreadyUse);
        return;
    }

    var folderPath, mailUid;

    // g_paramURL 또는 Old_Preview_Href 중 하나를 선택
    if (typeof g_paramURL !== 'undefined') {
        [folderPath, mailUid] = g_paramURL.split("/");
    } else if (typeof Old_Preview_Href !== 'undefined') {
        [folderPath, mailUid] = Old_Preview_Href.split("/");
    } else {
        showError();
        return;
    }
    
    $.ajax({
        cache: false,
        method: 'post',
        url: "/ezEmail/addMailTag.do",
        data: { folderPath, mailUid, tagName, shareId },
        success: function(result) {
            if (result.status === "error") {
                showError();
                return;
            }
            if (window.leftMenu) {
                leftMenu.reloadTags();
            }
            successCallback(tagName);
            tagInput.value = "";
        },
        error: function() {
            showError();
        }
    });
}

function onEnterPreviewTagInput() {
    onEnterTagInput("tag_add", "",function(tagName) {
        appendTag(tagName, "tag_view");
    });
}

function onEnterPreviewTagInput_previewShow() {
    var idPrefix = pPreviewShow_HOW === "H" ? "pre_h_tag_" : "pre_w_tag_";
    onEnterTagInput(idPrefix + "add", idPrefix,function(tagName) {
        appendTag(tagName, idPrefix + "view");
    });
}

function getTagList(type) {
    var ulTag = document.getElementById(type ? "layer_select_" + type : "layer_select");

    // 기존 자식 요소 제거
    while (ulTag.firstChild) {
        ulTag.removeChild(ulTag.firstChild);
    }

    fetchTags(function(tags) {
        tags.forEach(function(tag) {
            var li = document.createElement('li');
            li.textContent = tag;
            li.addEventListener('click', function() {
                var tagInputId = type ? (pPreviewShow_HOW === "H" ? "pre_h_" : "pre_w_") + "tag_add" : "tag_add";
                document.getElementById(tagInputId).value = this.textContent;

                if (type) {
                    onEnterPreviewTagInput_previewShow();
                } else {
                    onEnterPreviewTagInput();
                }

                var inputWrap = document.getElementById(type ? "input_wrap_" + type : "input_wrap");
                inputWrap.classList.remove("on");
                document.getElementById(tagInputId).value = "";
            });
            ulTag.appendChild(li);
        });
    });
}

function fetchTags(callback) {
    $.ajax({
        cache: false,
        data: { shareId: shareId },
        url: "/ezEmail/getUserTagList.do",
        success: function(result) {
            if (result.status === "error") {
                showError();
                return;
            }
            var tags = result.data;
            window.cacheTags = $.map(tags, function(ul) {
                return ul.name;
            });
            callback(window.cacheTags);
        },
        error: function() {
            showError();
        }
    });
}


/*
mailNewInboxRule.jsp
mailDetailInboxRule.jsp
공통 코드
*/

function addTag() {
    var tagInput = document.getElementById("tag_add");
    var tagName = tagInput.value.trim();
    if (tagName.length <= 0) return;
    if ($.grep(document.querySelectorAll("#tag_view > .tag_list > span"), function(span) { return span.innerText == tagName }).length > 0) {
        alert(strLangTagAlreadyUse);
        return;
    }
    if (document.querySelectorAll("#tag_view > .tag_list > .tag_name").length >= 5 ) {
        alert(strLangTagLimit);
        return;
    }

    appendTag(tagName, "tag_view");
    tagInput.value = "";
}

function getTagList_Rule() {
    var ulTag = document.getElementById("layer_select");

    // 기존 자식 요소 제거
    while (ulTag.firstChild) {
        ulTag.removeChild(ulTag.firstChild);
    }

    fetchTags(function(tags) {
        for (var i = 0; i < tags.length; i++) {
            var li = document.createElement('li');
            li.textContent = tags[i];
            li.addEventListener('click', function() {
                document.getElementById("tag_add").value = this.textContent;

                addTag();

                var inputWrap = document.getElementById("input_wrap");

                // 클래스에 "on"이 있으면 제거
                if (inputWrap.classList.contains("on")) {
                    inputWrap.classList.remove("on");
                }

                document.getElementById("tag_add").value = "";
            });
            ulTag.appendChild(li);
        }
    });
}

function tag_confirm() {
    var _exp = "";
    var _value = "";
    document.getElementById('tag_add').value = '';
    
    if (tag_view.children.length == 0) {

        _curCellObj.innerHTML = "<span onclick='tagRuleselectcell(this);' value=''><nobr><u>" + strLang219 + "</u></nobr></span>";
        _curCellObj.setAttribute("RuleKind", _RuleKind);
        _curCellObj.setAttribute("value", "");
        $.modal.close();
        _curCellObj = null;
        _RuleKind = null;
        tag_view.innerHTML = "";
        return;
    }
    
    for (var i = 0; i < tag_view.children.length; i++) {
        if (i === 2) {
            // i가 2일 때
            _exp += "...";
            _value += ";" + MakeXMLString(TrimText(tag_view.children.item(i).textContent));
        } else if (i < 2) {
            // i가 0 또는 1일 때
            if (_exp == "") {
                _exp = "\"" + TrimText(tag_view.children.item(i).textContent) + "\"";
                _value = MakeXMLString(TrimText(tag_view.children.item(i).textContent));
            } else {
                _exp += "" + strLang235 + "" + TrimText(tag_view.children.item(i).textContent) + "\"";
                _value += ";" + MakeXMLString(TrimText(tag_view.children.item(i).textContent));
            }
        } else {
            // i가 3 이상일 때
            _value += ";" + MakeXMLString(TrimText(tag_view.children.item(i).textContent));
        }
    }

    if (_curCellObj != null) {
        _curCellObj.innerHTML = "<span onclick='tagRuleselectcell(this);' value='" + _value + "'><nobr><u></u></nobr></span>";
        $(_curCellObj).find("span nobr u").text(_exp);
        _curCellObj.setAttribute("value", _value);
        _curCellObj.setAttribute("RuleKind", _RuleKind);
    }
    $.modal.close();
    ConCellRow = null;
    _curCellObj = null;
    _RuleKind = null;
    tag_view.innerHTML = "";
}

function tag_cancel() {
    var rtnValue = false;
    document.getElementById('tag_add').value = '';
    if (tag_view.children.length > 0) {
        rtnValue = confirm(strLang313);
        if (!rtnValue)
            return;
    }

    if (_curCellObj.getAttribute("value") == null || _curCellObj.getAttribute("value") == "") {
        _curCellObj.innerHTML = "<span onclick='tagRuleselectcell(this);' value=''><nobr><u>" + strLang219 + "</u></nobr></span>";
        _curCellObj.setAttribute("RuleKind", _RuleKind);
        _curCellObj.setAttribute("value", "");
        $.modal.close();
        _curCellObj = null;
        _RuleKind = null;
        tag_view.innerHTML = "";
        ConCellRow = null;
        return;
    }
    
    $.modal.close();
    ConCellRow = null;
    _curCellObj = null;
    _RuleKind = null;
    tag_view.innerHTML = "";
}


function tagRuleselectcell(obj) {
    _curCellObj = obj.parentNode;
    _RuleKind = _curCellObj.getAttribute("RuleKind");
    const tagList = obj.getAttribute("value").split(';');
    if (obj.getAttribute("value") !== '' && tagList.length > 0) {
        for (let tagName of tagList) {
            tagName = escapeHtml(tagName);
            appendTag(tagName, "tag_view");
        }
    }
    document.getElementById("inboxRuleAddTag").style.width = "auto";
    $("#inboxRuleAddTag").modal({escapeClose: false, clickClose: false});
    Commentdsc(_RuleKind)
}