/**
 * @file 메일쓰기/수정> 수신자 자동완성(autocomplete)을 구현합니다.
 *  - 참조하는 jsp에는 theadTr가 정의되어 있어야 합니다.
 * @author 솔루션1팀 김은실
 * @version 1.0.0
 * @date 2024-11-29
 *
 * @description (outline)
 * 변수:
 *  - IsInsert[]
 *
 * 주요 메서드:
 * autocomplete 객체 생성   // document ready
 *      - setupAutocomplete() : autocomplete()
 *
 * autocomplete 옵션 재정의
 *  - 1. renderMenu
 *  - 2. focus
 *
 * @see {@link https://jsdoc.app} jsDoc 사용법
 */

var IsInsert = [ false, false, false ]; // 0:MsgToGot, 1:MsgCCGot, 2:MsgBCCGot

// document ready
$(function() {
    setupAutocomplete("#MsgTo", 0, MsgToGot);
    setupAutocomplete("#MsgCC", 1, MsgCCGot);
    setupAutocomplete("#MsgBCC", 2, MsgBCCGot);
})

// autocomplete 객체 생성
function setupAutocomplete(selector, iType, element) {
    $(selector).autocomplete({
        source : function(request, response) {
            $.ajax({
                type : 'post',
                url : "/ezEmail/autoCompleteList.do",
                dataType : "json",
                data : {
                    value : request.term,
                    shareId : shareId,
                    company : '' // useShowAllCompanies config가 YES일 경우 그룹사 전체 조직도를 대상으로 검색하기 위해 추가함.
                },
                success : function(data) {
                    var susinList = data.susinList;
                    response($.map(susinList, function(ul, item) {
                        return {
                            label : ul.name + " " + ul.title + " "
                                    + ul.description + " "
                                    + "<" + ul.mail + ">",
                            value : ul.name,
                            email : ul.mail,
                            dept : ul.description,
                            title : ul.title,
                            type : ul.type,
                            href : ul.href
                        };
                    }));
                }
            });
        },
        minLength : 2,
        selectFirst : true,
        autoFocus: true,
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

                element.appendChild(newElem);
                $(this).val("");
                IsInsert[iType] = true;
            }
        },
        focus : function(event, ui) {
            return false;
        },
        open : function(event, ui) {
            // 20180628 자동완성창의 width 값 고정
            var ul =  $(this).autocomplete("widget");
            ul.outerWidth($(this).outerWidth()); // current input width
        },
        close : function(event, ui) {
            if (IsInsert[iType])
                $(this).val("");
            IsInsert[iType] = false;
        },
        appendTo : "#AutoCompleteResults"
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
// 재정의 1. renderMenu
$.ui.autocomplete.prototype._renderMenu = function(ul, items) {
    items.forEach(function (item, index) {
        // theadTr
        if (index == 0) {
            ul.append(theadTr);
        }

        // td
        $("<li style='border-bottom:1px solid #e8e8ef'>")
        .data("ui-autocomplete-item", item)
        .append("<a title='" + item.email + "'>"
                    + "<table class='width100percent' width='100%' height='100%' style='display:inline-table;'>"
                        + "<tr>" // inline style
                            + "<td style='width:20%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>" + item.value + "</td>"
                            + "<td style='width:20%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>" + item.dept + "</td>"
                            + "<td style='width:15%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>" + item.title + "</td>"
                            + "<td style='max-width:45%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>" + item.email + "</td>"
                        + "</tr>"
                    + "</table>"
                + "</a>")
        .appendTo(ul);
    });
};

// 재정의 2. focus
var originalFocus = $.ui.menu.prototype.focus;  // 기존 focus 메서드를 저장
$.ui.menu.prototype.focus = function(event, item) {
    // 컬럼 헤더는 focus 제외한다.
    if (item.attr("id") == "theadTr") {
        item = this.activeMenu.find( this.options.items ).eq( 1 );
    }

    originalFocus.call(this, event, item);
};
