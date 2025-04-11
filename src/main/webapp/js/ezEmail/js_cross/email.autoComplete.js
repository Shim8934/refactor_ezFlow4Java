/**
 * @file 메일쓰기/수정> 수신자 자동완성(autocomplete)을 구현합니다.
 *  - 참조하는 jsp에는 theadTr가 정의되어 있어야 합니다.
 *  - 주요 기능:
 *      1. 최근 사용 주소 (lastSent)
 *      2. 주소 자동 완성 (auto)
 * @author 솔루션1팀 김은실
 * @version 1.1.0
 * @date 2024-12-02
 *
 * @description (outline)
 * 변수:
 *  - IsInsert[]
 *  - mode : 객체 저장. (mode에 따라 다르게 처리)
 *  - emailToDelete : 삭제할 메일 주소
 *  - checkKeyEvent : isDuble, prev, setIsDuble()
 *
 * 주요 메서드:
 * autocomplete 객체 생성   // document ready
 *      - setupAutocomplete() : autocomplete(), select(), onkeydown(), onclick()
 *
 * autocomplete 옵션 재정의
 *  - 1. select (*위에)
 *  - 2. renderMenu
 *  - 3. focus
 *  - 4. search
 *
 * 클래스:
 *  - class Mode : constructor → getSource() → getList → fetchServerList
 *      - lastSentStash : lastSent list 저장
 *      - 1. 최근 사용 주소 (lastSent)  : getList(), tr(), ulCss()
 *      - 2. 주소 자동 완성 (auto)      : tr(), ulCss()
 *
 * fetch util
 *
 * @see {@link https://jsdoc.app} jsDoc 사용법
 */

var IsInsert = [ false, false, false ]; // 0:MsgToGot, 1:MsgCCGot, 2:MsgBCCGot
var isCallLastSent = false; // 최근사용주소는 클릭 시에만 실행하도록 수정.
var mode = null;
var emailToDelete = null; // 최근 사용 주소 삭제 시 : 삭제 click 이벤트 외에 발생하는 select 이벤트를 실행하지 않기 위함.
// 최근사용주소는 클릭 시에만 실행하도록 수정하면 될 것 같아서 해당 문제 제외해 봄.
// var checkKeyEvent = { // 한글 조합문자 특성으로 인해 keydown event 두 번 발생할 때 search 이벤트를 실행하지 않기 위함. (가독성을 위해 객체화)
//     isDuble: false,
//     prev: false,
//     setIsDuble: function(currentE) {
//         // console.debug(currentE.type, ": ", currentE.key, ", keyCode: ", currentE.keyCode, ", isComposing: ", currentE.originalEvent.isComposing);
// 		/*
//          * keydown :  Process , keyCode: 229 , isComposing:  true
// 		 * keydown :  Enter , keyCode: 13 , isComposing:  false
// 		 * 이벤트 두 번 실행될 때 하나는 search 차단.
//          */
//
//         // search 실행 차단할 조건
//         checkKeyEvent.isDuble = checkKeyEvent.prev && (currentE.keyCode == 13);
//         // previous isComposing 저장
//         checkKeyEvent.prev = currentE.originalEvent.isComposing;
//         /*
//          * JavaScript의 this는 함수 호출 방식에 따라 동적으로 결정.
//          * 이벤트 핸들러로 사용될 경우, this는 이벤트를 트리거한 DOM 요소를 참조함. 여기서 this는 $("#MsgTo")이 된다.
//          * checkKeyEvent 객체를 명시적으로 지정함.
//          */
//     }
// }

// document ready
$(function() {
    setupAutocomplete("#MsgTo", "#MsgTo_TR .btn_AutoCompleteResults", 0, MsgToGot);
    setupAutocomplete("#MsgCC", "#MsgCC_TR .btn_AutoCompleteResults", 1, MsgCCGot);
    setupAutocomplete("#MsgBCC", "#MsgBCC_TR .btn_AutoCompleteResults", 2, MsgBCCGot);
})

// autocomplete 객체 생성
/** @param {String} inputSelector
 * @param {String} autoCompleteBtnSelector
 * @param {Number} iType
 * @param {HTMLElement} recipientContainerElement */
function setupAutocomplete(inputSelector, autoCompleteBtnSelector, iType, recipientContainerElement) {
    $(inputSelector).autocomplete({
        source : function(request, response) {
            if (request.term.length < 2) { // 기존(auto) minLength : 2
                mode = new LastSent(request, response);
            } else {
                mode = new Auto(request, response);
            }
        },
        minLength : 0,
        select : function(event, ui) {
            var addressType = "email";
            var href = ""
            if(ui.item.type == "G") {
                addressType = "mailgroup";
                href = ui.item.href;
            }

            newElem = PrepareMailTag(iType, addressType, ui.item.value, ui.item.email, href);
            IsInsert[iType] = CheckMailReceiver(newElem);
            if (!IsInsert[iType]) {
                if (!increaseReceiverCount(addressType, href)) {
                    return;
                }

                recipientContainerElement.appendChild(newElem);
                $(this).val("");
                IsInsert[iType] = true;
            }
        },
        focus : function(event, ui) {
            return false;
        },
        open : function(event, ui) {
            $(autoCompleteBtnSelector).addClass("active");

            //$(recipientContainerElement).outerWidth()
            // 20180628 자동완성창의 width 값 고정
            mode.ulCss($(this).autocomplete("widget"), $(recipientContainerElement).outerWidth()); // ul, inputW(:current input width)
        },
        close : function(event, ui) {
            $(autoCompleteBtnSelector).removeClass("active");

            if (IsInsert[iType])
                $(this).val("");
            IsInsert[iType] = false;
        },
        appendTo : "#AutoCompleteResults",
        position: {
            my: 'left top',
            at: 'left bottom',
            collision: 'fit',
            of: recipientContainerElement
        }
    });

    /**
     * 1. Menu : 내부 UI 메뉴 동작을 정의 (먼저 작동)
     * 2. Option : 사용자 정의 이벤트 처리기로 작동 (menu 후에 작동)
     * menu.select와 option select는 호출 타이밍과 컨텍스트가 다릅니다.
     */
    // 재정의 1. select
    var instance = $(inputSelector).autocomplete("instance");
    var originalSelect = instance.menu.select;  // 기존 select 메서드를 저장
    instance.menu.select = async function(event) {
        // (클릭 때문에 자동으로 실행되는) select 옵션을 실행하지 않아야 함.
        if (emailToDelete) {
            // 삭제
            await fetchResponse("/ezAddress/deleteLastSentEmailAddress.do", {
                shareId : shareId,
                email : emailToDelete
            });

            // 초기화
            emailToDelete = null;
            lastSentStash = null;
            $(inputSelector).autocomplete("search", "");
            /*
             * 새로 받아오는 것이 너무 느리거나 성능상 문제가 된다면, 다음과 같이 간이처리로 수정해주세요.
             * this.active.remove(); // 1. 해당 li 삭제.
             * lastSentStash = lastSentStash.filter(item => item.mail != emailToDelete); // 2. lastSentStash 재구성.
             * if (lastSentStash.length == 0) { // 3. lastSentStash 없을 시 초기화 및 닫음.
             *     $(selector).autocomplete("close");
             * }
             * emailToDelete = null;
             */
            return;
        }

        originalSelect.call(this, event);
    };

//    $(selector).on("keydown", checkKeyEvent.setIsDuble);

    // 클릭 시 Autocomplete 목록을 열거나 닫기
    $(inputSelector + ', ' + autoCompleteBtnSelector).on("click", function(event) {
        event.preventDefault();
        event.stopPropagation();

        // 최근 사용 주소이면서 + 이미 목록이 열려 있으면 닫고,
        if($(inputSelector).autocomplete("widget").is(":visible") && mode instanceof LastSent) {
            $(inputSelector).autocomplete("close");
        // 그 외 클릭 시 최근 사용 주소
        } else {
            isCallLastSent = true; // 클릭 시에만 최근사용주소 목록 가져오도록 함.
            $(inputSelector).autocomplete("search", "");
        }
    });
}

/**
 * 1. 전역적 재정의
 *      (장점) 모든 Autocomplete 인스턴스에 적용. 코드가 간결. 유지보수 용이.
 *      (단점) 특정 인스턴스에만 적용이 어렵다.
 * 2. 개별적 재정의 (instance)
 *      (장점) 특정 인스턴스에만 적용 가능. 컨텍스트 기반으로 커스터마이징 가능.
 *      (단점) 개별적으로 처리해야 하므로 반복 작업 증가.
 */
// 재정의 2. renderMenu
$.ui.autocomplete.prototype._renderMenu = function(ul, items) {
    items.forEach(function (item, index) {
        // theadTr
        if (index == 0 && mode instanceof Auto) {
            ul.append(theadTr);
        }

        // td
        $("<li style='border-bottom:1px solid #e8e8ef'>")
        .data("ui-autocomplete-item", item)
        .append("<a title='" + item.email + "'>"
                    + mode.tr(item)
                + "</a>")
        .appendTo(ul);
    });
};

// 재정의 3. focus
var originalFocus = $.ui.menu.prototype.focus;  // 기존 focus 메서드를 저장
$.ui.menu.prototype.focus = function(event, item) {
    // 컬럼 헤더는 focus 제외한다.
    if (item.attr("id") == "theadTr") {
        item = this.activeMenu.find( this.options.items ).eq( 1 );
    }

    originalFocus.call(this, event, item);
};

// 재정의 4. search
// var originalSearch = $.ui.autocomplete.prototype.search;  // 기존 search 메서드를 저장
// $.ui.autocomplete.prototype.search = function(value) {
//     if (checkKeyEvent.isDuble) { // minLength : 0 때문에 search 발생
//         checkKeyEvent.isDuble = false;
//         // console.debug("한글 조합문자 특성으로 인해 keydown event 두 번 발생할 때 search 실행 차단");
//         return;
//     }
//
//     // 기존 search 호출
//     originalSearch.call(this, value);
// };

/**
 * JS Class는 ES6(ECMAScript 2015) 이상에서 사용 가능. (오.. email.rowselector.js에서도 Class 사용중!)
 * 다형성을 구현하고 싶었음.. 더 좋은 방법이 있다면 추천바람!
 * 만약 버전 관련 문제 발생시 revert바람!
 */
class Mode {
    /**
     * @param request
     * @param response
     */
    constructor(request, response) {
        this.getSource(request, response);
    }

    // 공통메소드 1. list를 response에 셋팅.
    async getSource(request, response) {
        var list = await this.getList(request);

        response($.map(list, function(ul, item) {
            return {
                label : ul.name + " " + ul.title + " "
                        + ul.description + " "
                        + "<" + ul.mail + ">",
                value : ul.name,
                email : ul.mail,
                dept : ul.description,
                title : ul.title,
                type : ul.type,
                href : ul.href,
                sentDate : ul.sentDate
            };
        }));
    };

    async getList(request) {
        return await this.fetchServerList(request); // lastSent에서 재정의됨.
    };

    // 공통메소드 2. server에서 list 가져오기.
    async fetchServerList(request) {
        var response = await fetchResponse("/ezEmail/autoCompleteList.do", {
            value : request.term,
            shareId : shareId,
            company : '' // useShowAllCompanies config가 YES일 경우 그룹사 전체 조직도를 대상으로 검색하기 위해 추가함.
        });
        var data = await response.json(); // JSON 데이터 파싱;
        return data.susinList;
    };
}

var lastSentStash = null;

// 1. 최근 사용 주소
class LastSent extends Mode {
    // 절감 목적 : lastSent list는 데이터가 일정한데 비해, 빈번하게 발생할 것으로 예상된다. (term.length: 0-1)
    async getList(request) {
        // minLength : 0 이나, 클릭이 아닐 때는 수행하지 않도록 빈 목록을 반환하도록 했다.
        if (!isCallLastSent) return [];
        isCallLastSent = false;

        // length = 0 인것도 결과임. if null, DB에서 데이터 가져올 것.(fetchServerList)
        return lastSentStash? lastSentStash : super.fetchServerList(request);
    };

    tr(item) {
        return "<span class='flex_autocomplete'>"
            + "<span class='name'>" + item.value + "</span>" // max-width:200px;
            + "<span class='mail'>" + item.email + "</span>" // width:calc(100% - 255px);
            + "<span class='date'>" + item.sentDate + "</span>" // width:45px;
            + "<span class='delete' onclick=\"emailToDelete = '" + item.email + "';\"></span>" // width:10px;
        + "</span>";
    };

    ulCss(ul, inputW) {
        // [max-width: inputW-2] outerWidth는= (css) width, padding, border의 합으로, auto: ul.outerWidth(inputW);와 같으려면 현재 border가 1px이어서 -2px 차감해줬다.
        // name이 max-width:200이라 어차피 최대 510px임.
        ul.css({ 'max-width': inputW-2, 'min-width': (inputW < 400)? 0 : 400 });
        ul.outerWidth('');
    };
}

// 2. 주소 자동 완성
class Auto extends Mode {
    tr(item) {
        return "<table class='width100percent' width='100%' height='100%' style='display:inline-table;'>"
            + "<tr>" // inline style
                + "<td style='width:20%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>" + item.value + "</td>"
                + "<td style='width:20%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>" + item.dept + "</td>"
                + "<td style='width:15%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>" + item.title + "</td>"
                + "<td style='max-width:45%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>" + item.email + "</td>"
            + "</tr>"
        + "</table>";
    };

    ulCss(ul, inputW) {
        ul.css({ 'max-width': '', 'min-width': ''}); //ul[0].style.removeProperty('max-width');
        ul.outerWidth(inputW);
    };
}

/**
 * fetch util
 * "fetch는 비동기 HTTP 요청을 처리하는 강력한 도구입니다." -ChatGPT
 * @returns response
 */
async function fetchResponse(url, json) {
   try {
       var response = await fetch(url, {
           method: 'POST',
           headers: {
               'Content-Type': 'application/json; charset=utf-8', // JSON 데이터임을 명시
           },
           body: JSON.stringify(json),
       });

       if (!response.ok) throw new Error('Network response was not ok');
       return response;

   } catch (error) {
       console.error('Error fetchResponse:', error);
       throw error;
   }
}
