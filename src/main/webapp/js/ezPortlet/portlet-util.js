var gridElement;
var initCount = 0;
var GridSize = Object.freeze({
    ONE_BY_ONE: 'one_by_one',
    TWO_BY_ONE: 'two_by_one',
    ONE_BY_TWO: 'one_by_two',
    TWO_BY_TWO: 'two_by_two'
});
var ClassPortlet = Object.freeze({
    AREA_PORTLET: "portlet_area",
    PORTLET: "portlet",
    WRAP_PORTLET: "box_shadow",
    BTN_OPEN_POP: "set_portlet",
    BODY_POP: "body_pop_for_size",
    POP_STATE_OPEN: "pop_open",
    CUR_SIZE: "cur_size",
    HANDLE: "sortablePortlet",
    CHK_USE: "chk_portlet",
    OFF_PORTLET: "off_portlet",
    DISPLAY_NONE: "display_none",
    AVAILABLE_SIZE: "size_av",
    UNAVAILABLE_SIZE: "size_uav",
    EDITING: "editing"
});

//* 포틀릿 애니메이션 관련 옵션 *//
// https://docs.muuri.dev/grid-constructor.html#grid-options
var fixed = []
var portletOption = Object.freeze({
    dragEnabled: true, // 드래그 여부
    dragHandle: "." + ClassPortlet.HANDLE, // 드래그 핸들,
    itemPlaceholderClass: 'portlet-placeholder', //placeholder 로 추가될 클래스
    layout: {
        fillGaps: true,   // 빈칸 자동 채움
        horizontal: false,
        alignRight: false,
        alignBottom: false,
        rounding: false,
    },
    dragPlaceholder: {
        enabled: true,  // 드래그 시 placeholder 설정
        createElement: function (item) {
            return item.getElement().cloneNode(true);
        },
        onCreate: null,
        onRemove: null,
    },
    dragSortPredicate: function (item) {
        var result = Muuri.ItemDrag.defaultSortPredicate(item, {
            action: 'swap', // move/swap
            threshold: 0,  // 민감도
        });
        if (!!gridElement && !!result) {
            var chkBox = gridElement.getItem(result.index).getElement().getElementsByClassName(ClassPortlet.CHK_USE)[0];
            if (!!chkBox && chkBox.checked === false) return false;
        }
        return result;
    },
    dragStartPredicate: function (item, hammerEvent) {
        // 좌클릭으로만 동작
        if (!hammerEvent.srcEvent.type.includes('touch') && hammerEvent.srcEvent.button !== 0) return false;
        var target = hammerEvent.target;
        // 핸들클래스 안의 노드 중 드래그 이벤트를 실행시킬 노드를 추가 하려면 아래 배열에 추가
        var handleClass = ['portletText', 'handle-movie'];

        // 관리자 사이즈 선택 가용 범위 설정용 체크박스
        var chkBox = item.getElement().getElementsByClassName(ClassPortlet.CHK_USE)[0];
        if (!!chkBox && chkBox.checked === false) return false;

        // 핸들 노드 handleClass 들을 제외한 다른 노드 클릭시 이벤트 실행
        if (target.classList.contains(ClassPortlet.HANDLE)) return true;

        var handleClassChk = true;

        for (var i = 0; i < handleClass.length; i++) {
            if (target.classList.contains(handleClass[i])) {
                handleClassChk = false;
                break;
            }
        }

        return !handleClassChk;
    },
});

function makeGridChangeEvent(id) {
    // 각 포틀릿에 팝업 append
    createPopPortletSize(id);
    // 각 팝업에 클릭 이벤트 부여
    giveSetPortletEvent(id);
    resizePortlet();
}

function initGridConstruct() {
    startGridElement();
}

function startGridElement() {
    if (gridElement == null) {
        var area = document.getElementsByClassName(ClassPortlet.AREA_PORTLET)[0];
        if (!area) return;

        // grid 이벤트 부여 - position absolute로 변경해야 됨
        var portletArr = area.getElementsByClassName(ClassPortlet.PORTLET);
        Array.prototype.forEach.call(portletArr, function (portlet) {
            portlet.style.position = "absolute";
        });

        gridElement = new Muuri("." + ClassPortlet.AREA_PORTLET, portletOption);

        gridElement.on('dragEnd', function () {
            if (typeof usedTheme == 'undefined' || !usedTheme) usedTheme = document.querySelector('.portletList').getAttribute('data-themeid');
            gridElement.synchronize();
            userPortletUpdateWithSize(usedTheme);
        });
        gridElement.on('layoutStart', function (items, isInstant) {
            return false;
        });
        gridElement.on('layoutEnd', function (items, isInstant) {
            var dummy = document.getElementById('dummyArea');
            if (!!dummy) {
                var dummyParent = dummy.parentElement;
                dummyParent.removeChild(dummy);
            }
        });
    }
}

// 포틀릿 아이콘 클릭시 팝업창 뜨는 이벤트부여
function giveSetPortletEvent(portletId) {
    var nodes = document.getElementsByClassName(ClassPortlet.BTN_OPEN_POP);
    Array.prototype.forEach.call(nodes, function (node) {
        node.addEventListener("click", openPopPortletSize);
    });

    var btnList = $("#" + portletId + "Portlet")[0].querySelectorAll("img[data-size]");
    Array.prototype.forEach.call(btnList, function (btn) {
        btn.addEventListener("click", function (e) {
            e = e || window.event;
            var target = e.target;
            target.parentElement.classList.remove(ClassPortlet.POP_STATE_OPEN);
            changePortletSize(target.closest("." + ClassPortlet.PORTLET), target.dataset.size);
        });
    });

    // close event
    document.getElementsByTagName("body")[0].addEventListener("click", closePopPortletSizeAll);
}

// 포틀릿 사이즈 변경
function changePortletSize(pot, size) {
    pot.classList.remove(pot.dataset.size);
    pot.classList.add(size);
    pot.dataset.size = size;
    resizePortlet();
    if (typeof usedTheme == 'undefined' || !usedTheme) usedTheme = document.querySelector('.portletList').getAttribute('data-themeid');
    userPortletUpdateWithSize(usedTheme);

    var portletPagingArea = pot.querySelector('.portletPagingArea');
    if (portletPagingArea) { // 포틀릿 페이지네이션 처리
        changePortletViewCount(pot.id.replace('Portlet', ''));
    }
    
}

// 포틀릿 사이즈 변경 팝업 만들기
function createPopPortletSize(portletId) {
    var wrapPortlet = !!$("#" + portletId + "Portlet")[0] ? $("#" + portletId + "Portlet")[0].getElementsByClassName(ClassPortlet.WRAP_PORTLET)[0] : null;
    if (!wrapPortlet) return;
    var divIcon = document.createElement("div");
    divIcon.className = ClassPortlet.BTN_OPEN_POP;
    wrapPortlet.appendChild(divIcon);

    var pop = document.createElement("div");
    pop.className = ClassPortlet.BODY_POP;
    var availableArr = getAvailSize(portletId);
    if (!availableArr) availableArr = [GridSize.ONE_BY_ONE];

    Array.prototype.forEach.call(availableArr, function (size) {
        var img = document.createElement("img");
        img.src = "/images/portal/" + size + ".svg?version=23110801"; // queryString. 이미지 변경시 YYMMDD + 넘버링 (01, 02, 03)
        img.className = size;
        img.dataset.size = size;
        pop.appendChild(img);
    });
    wrapPortlet.appendChild(pop);
}

// 포틀릿 사이즈 변경 팝업 열기
function openPopPortletSize(e) {
    e = e || window.event;
    e.stopPropagation();
    closePopPortletSizeAll();
    var node = this.parentElement.getElementsByClassName(ClassPortlet.BODY_POP)[0];
    node.classList.add(ClassPortlet.POP_STATE_OPEN);
}

// 포틀릿 사이즈 변경 팝업 닫기
function closePopPortletSizeAll(e) {
    e = e || window.event;
    if (!e.target.closest("." + ClassPortlet.BODY_POP)) {
        var popList = document.querySelectorAll("." + ClassPortlet.BODY_POP + "." + ClassPortlet.POP_STATE_OPEN);
        Array.prototype.forEach.call(popList, function (node) {
            node.classList.remove(ClassPortlet.POP_STATE_OPEN);
        });
    }
}

function getAvailablePortletSize(companyId, themeId) {
    var result;
    var request = new XMLHttpRequest();
    request.open('POST', '/admin/ezNewPortal/getAvailablePortletSize.do', false);
    request.setRequestHeader('Content-Type', 'application/json');
    request.onload = function () {
        if (request.status === 200) {
            result = JSON.parse(request.responseText);
        } else {
            console.error(request.statusText);
        }
    }

    var data = JSON.stringify({
        companyId: companyId,
        themeId: themeId
    });

    request.send(data);
    return result;
}

// 유저 포틀릿 업데이트
function userPortletUpdateWithSize(usedTheme) {
    if (typeof usedTheme == 'undefined' || !usedTheme) usedTheme = document.querySelector('.portletList').getAttribute('data-themeid');
    var gridItems = gridElement.getItems();
    var updateOrder = [];

    for (var i = 0; i < gridItems.length; i++) {
        var portlet = gridItems[i].getElement();
        var portletId = !!portlet.id && portlet.id.substring(0, portlet.id.indexOf("P"));
        updateOrder.push({"portletOrder": i + 1, "portletId": portletId, "classSize": portlet.dataset.size});
    }

    var data = {
        themeId: usedTheme,
        updateOrder: updateOrder
    };

    //ajax로 순서 변경
    $.ajax({
        type: "POST",
        url: "/ezNewPortal/updatePortletOrderUser.do",
        contentType: "application/json",
        dataType: "text",
        data: JSON.stringify(data),
        success: function (result) {
            console.debug("포틀릿 순서 변경 성공");
        },
        error: function () {
            console.error("포틀릿 순서 변경 실패");
        }
    });
}

function resizePortlet(portletNode) {
    if (!!portletNode && gridElement.getItem(portletNode) != null) {
        gridElement.refreshItems(gridElement.getItem(portletNode));
    } else {
        gridElement.refreshItems();
    }
    gridElement.synchronize();
    gridElement.layout();
}

function reloadPortlet(portletId) {
    loadPortlet(portletId);
}

function getPortletSize(portletId) {
    return $("#" + portletId + "Portlet")[0].getAttribute("data-size");
}

function loadPortlet(portletId) {
    var portletUrl;
    var portletName;
    var portletCode;
    var portlet;
    var portletCount = portletOrder.length;
    for (var i = 0; i < portletCount; i++) {
        var portletId2 = portletOrder[i].portletId;
        if (portletId == portletId2) {
            portlet = portletOrder[i];
            portletUrl = portletOrder[i].portletUrl;
            portletName = portletOrder[i].portletName;
            portletCode = portletOrder[i].portletCode;
            break;
        }
    }

    frameSetting(frameId);

    $.ajax({
        type: "GET",
        dataType: "html",
        data: {
            "uniq_param": (new Date()).getTime(),
            "portletId": portletId,
            "portletName": portletName,
            "usedTheme": usedTheme
        },
        url: portletUrl,
        tryCount: 0,
        retryLimit: 3,
        success: function (result) {
            try {
                $("#" + portletId + "Portlet").empty();
                $("#" + portletId + "Portlet").append(result);

                if (portletId == 6) {
                    document.getElementById(portletId + "Portlet").style.background = "none";
                }

                eventSetting(portletId, usedTheme, portletCode, false);

                if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1) {
                    sortableEvent();
                }

            } catch (e) {
                // 포틀릿 내부 에러시에 포탈 전체 스크립트 에러가 나서 try catch 처리함
                console.log(e);

            } finally {
                if (usePortletSize) {
                    makeGridChangeEvent(portletId);
                }
            }
        },
        error: function () {
            this.url = "/ezNewPortal/errorPortlet.do";
            this.tryCount++;

            if (this.tryCount <= this.retryLimit) {
                //try again
                $.ajax(this);
                return;
            }

            if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1) {
                sortableEvent();
            }

            return;
        }
    });
}

function getAvailSize(id) {
    var portletCount = portletOrder.length;
    for (var i = 0; i < portletCount; i++) {
        if (id == portletOrder[i].portletId) return portletOrder[i].listPortletSize;
    }
}

function Paging() {
    // _로 시작하는 변수 및 함수는 객체 외부에서 직접 접근하지 않는 내부 변수/함수이다.
    // 내부 동작시 모든 시작 index는 0을 기준으로 한다.
    var _countPerPage; // 페이지당 elements 개수
    var _start = 0; // 쿼리 호출용 시작 넘버. 무조건 0부터 시작.
    var _page = 0; // 내부 동작용 페이지. 내부 동작은 모두 page 0부터 시작. 설정에 상관없이 무조건 0을 초기 기준으로 한다.
    var _total = -1; // 전체 개수. -1 일 경우 last같이 끝이 필요한 동작은 하지 않고, next는 마지막 페이지를 체크하지 않고 올라 감.
    // ez) new Paging().setPageStart(1).setMaintain(flase).setRoundPage(false).init() 과 같이 init() 함수로 초기화 전에
    //  체이닝 매서드로 옵션 설정하여 객체마다 다른 옵션을 준다. 아래에 있는 값들은 default
    var _option = {
        maintain:true, // 페이지 숫자 변환시 현제 페이지 유지 여부
        pageStart:0, // getPage()시 시작 페이지, page를 객체 외부에서 get 관련 함수를 실행할때 더해주기만 하므로 내부 동작에 영향을 주지 않는다.
        roundPage:true, // 페이지 끝으로 가면 순환할지 여부.
    }

    var _resetPage = function (count) {
        _page = 0;
        _countPerPage = count;
        _start = 0;
    }

    var _changeCount = function (count) {
        _start -= _start % count;
        _countPerPage = count;
        _page = _start / count;
    }

    var _getLastPage  = function () {
        return Math.ceil(_total / _countPerPage) - 1;
    }

    var _goPage = function (pageNum) {
        _page = pageNum;
        _start = pageNum * _countPerPage;
    }

    return {
        // 객체 생성 후 init() 함수를 실행하기전에 기본 설정을 커스텀 해야할 일이 있다면 아래 함수들을 사용하여 변경

        // 페이지 끝에서 처음으로 돌아올지 여부
        setRoundPage: function (roundPage) {
            _option.roundPage = !!roundPage;
            return this;
        },
        // 페이지 숫자 변환시 현제 페이지 유지 여부
        setMaintain: function (maintain) {
            _option.maintain = !!maintain;
            return this;
        },
        // 페이지 시작 숫자. 설정한다고 해서 내부 동작이 변하진 않고, getPage 시 반환되는 페이지 값만 바뀐다.
        setPageStart: function (pageStart) {
            _option.pageStart = parseInt(pageStart);
            return this;
        },
        init: function (count) {
            _resetPage(count);
            return {
                // 현재 페이지 얻음.
                getPage: function () {
                    return _page + _option.pageStart;
                },
                // 이 객체에설정된 시작 페이지를 얻음.
                getStartPage: function () {
                    return _option.pageStart;
                },
                // 이 객체의 페이지당 엘리먼트 수
                getCountPerPage: function () {
                    return _countPerPage;
                },
                // 페이징시 쿼리로 불러올 시작 수 (limit ~ limit + count)
                getStart: function () {
                    return _start;
                },
                // 다음 페이지
                next: function () {
                    if (_total !== -1 && _page >= _getLastPage()) {
                        if (_option.roundPage) {
                            _resetPage(_countPerPage);
                        }
                    } else {
                        _start += _countPerPage;
                        _page++;
                    }

                    return this;
                },
                // 이전 페이지
                previous: function () {
                    if (_total !== -1 && _page <= 0) {
                        if (_option.roundPage) {
                            _goPage(_getLastPage());
                        }
                    } else if (_page > 0){
                        _goPage(_page - 1);
                    }
                    return this;
                },
                // 현재 페이지당 엘리먼트수 변경. 변셩시 옵션 maintain 이 true면 보고있는 페이지가 포함된 페이지, 아니면 초기화 됨
                changeCount: function (count) {
                    if (_option.maintain) {
                        _changeCount(count);
                    } else {
                        _resetPage(count);
                    }
                    return this;
                },
                // 첫 페이지로 이동
                first: function () {
                    _goPage(0);
                    return this;
                },
                setTotal: function (total) {
                    _total = total;
                    return this;
                },
                getTotal: function () {
                    return _total;
                },
                // 마지막 페이지로 이동. 전체 카운트가 없을경우 마지막 페이지를 알수 없으므로 그대로 리턴
                last: function () {
                    if (_total === -1) return this;
                    _goPage(_getLastPage());
                    return this;
                },
                // 현재 객체의 옵션 리턴
                getCurrentOption : function () {
                    return _option;
                },
                // 해당 페이지로 이동 시작페이지를 1로 설정후 setPage(2) -> 두번째 페이지로 이동.
                setPage: function (pageNum) {
                    // 시작 페이지가 1 일경우, 3페이지를 호출할 경우 내부 동작은 2페이지를 호출하는 동작을 하면 됨.
                    pageNum -= _option.pageStart;
                    _goPage(pageNum);
                    return this;
                }
            }
        }
    };
}

function changePortletViewCount(portletId) {
    var portletInfoObj = portletInfoMap["portlet" + portletId];
    var portletPageObj = null;
    if (portletInfoObj.portletCode == "tabBoard") {
        var tabBoardIdList = portletInfoObj.tabIdList;
        for (var i = 0; i < tabBoardIdList.length; i++) {
            var tabBoardId = tabBoardIdList[i];
            portletPageObj = portletInfoObj.paging[tabBoardId];
            changePortletPageCount(portletInfoObj, portletPageObj, portletId);
        }
    } else if (portletInfoObj.portletCode == "favoriteboard") {
        var favoriteActiveTabId = portletInfoObj.activeTabId;
        portletPageObj = portletInfoObj.paging[favoriteActiveTabId];
        changePortletPageCount(portletInfoObj, portletPageObj, portletId);
    } else {
        portletPageObj = portletInfoObj.page;
        changePortletPageCount(portletInfoObj, portletPageObj, portletId);
    }
}

function changePortletPageCount(portletInfoObj, portletPageObj, portletId) {
    var perCount = portletPageObj.getPagePerCount(portletId);
    portletPageObj.changeCount(perCount);
    portletInfoObj.getPortletList();
}

function resetPortletPaging(portletId, totalCnt, currentPage, activeTabId) {
    var portletInfoObj = portletInfoMap["portlet" + portletId];
    var portletPageObj = null;

    if (portletInfoObj.portletCode == "tabBoard") {
        portletPageObj = portletInfoObj.paging[activeTabId];
    } else if (portletInfoObj.portletCode == "favoriteboard") {
        portletPageObj = portletInfoObj.paging[activeTabId];
    } else {
        portletPageObj = portletInfoObj.page;
    }

    portletPageObj.setPage(currentPage);
    portletPageObj.setTotal(totalCnt);

    var portletPageNav = document.getElementById(portletId + "Portlet").querySelector(".portletPageNav");
    if (!portletPageNav) return;
    if (totalCnt > 0) {
        if (portletInfoObj.portletCode != "tabBoard") {
            portletPageNav.style.display = "block";
        }

        if (usePaging != '1') {
            portletPageNav.style.display = "none";
        }

    } else {
        if (portletInfoObj.portletCode != "tabBoard") {
            portletPageNav.style.display = "none";
        }
    }
}

function portletMovePage(portletId, mode) {
    var portletInfoObj = portletInfoMap["portlet" + portletId];
    var portletPageObj = null;

    if (portletInfoObj.portletCode == "tabBoard") {
        var activeTabId = portletInfoObj.activeTabId;
        portletPageObj = portletInfoObj.paging[activeTabId]
    } else if (portletInfoObj.portletCode == "favoriteboard") {
        var activeTabId = portletInfoObj.activeTabId;
        portletPageObj = portletInfoObj.paging[activeTabId]
    } else {
        portletPageObj = portletInfoObj.page;
    }

    if (mode === "prev") {
        portletPageObj.previous();
    } else if (mode === "next") {
        portletPageObj.next();
    }
    portletInfoObj.getPortletList();
}

const fixBoardArr = {};

function makeFixPortlet(fixedPortletList) {
    var length = fixedPortletList.length;
    for (var i = 0; i < length; i++) {
    	var lazy = i == 1? 2000 : 0;
        const fixPortletCode = length===1? "fixCenter" : fixedPortletList[i].portletCode;
        const portletName = fixedPortletList[i].portletName;
        const fixUrl = URLParamsUtils(fixedPortletList[i].portletUrl).getFullUrl();
        const fixBoardUtil = new FixBoardUtil()
            .area("#fixBoardArea")
            .id(fixPortletCode)
            .title(portletName)
            .setSwiperTime(5000, lazy)
            .makeShell();
        fixBoardArr[fixPortletCode] = fixBoardUtil;
        $.ajax({
            type: "GET",
            dataType: "json",
            data: {
                "portletId": fixedPortletList[i].portletId,
                "startRow": 0,
                "count": 10
            },
            url: fixUrl,
            success: function (result) {
                var boardList = result.boardList || [];
                if (boardList.length > 0) {
                    // 하나라도 고정포틀릿이 표출될 경우 고정영역 버튼 활성화
                    $('.my_info_wrap .news_setting').show();
                    fixBoardArr[fixPortletCode].start(boardList);
                } else {
                    fixBoardArr[fixPortletCode].hide();
                    if (document.getElementsByClassName("news_setting")[0]){
                        document.getElementsByClassName("news_setting")[0].remove();
                    }
                }
            },
            error: function (error) {
                console.log(error);
            }
        });
    }
}

function makeErrorPortlet(portletId) {
    return function () {
        this.url = "/ezNewPortal/errorPortlet.do";
        this.tryCount++;

        if (this.tryCount <= this.retryLimit) {
            $.ajax(this);
            return;
        }

        if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1) {
            sortableEvent();
        }

        if (usePortletSize) {
            makeGridChangeEvent(portletId);
        }

        return;
    };
}

// 현재 사용중인 정렬 lib muuri 는 객체 정렬을 위해 position을 absolute로 바꾼뒤 수동 좌표로 정렬을 해준다. (IE에선 GRID가 없음 + murri 정렬 알고리즘)
// 정렬 알고리즘이 끝나야 포틀릿이 정렬되므로 makePortletsShell 에서 먼저 정렬에 필요한 구조 생성 및 정렬 -> makePortlets 각 포틀릿 비동기 호출 순으로 실행한다.
function makePortletsShell(portletOrder) {
    if (!portletOrder || !portletOrder.length) return;
    var portletCount = portletOrder.length;
    var portletArea = document.getElementsByClassName("portlet_area")[0];
    var dummyArea = document.getElementById("dummyArea");

    for (var i = 0; i < portletCount; i++) {
        var portletData = portletOrder[i];

        var dumEl = document.createElement("div");
        dumEl.classList.add("portlet");
        dumEl.classList.add(portletData.classSize);
        dumEl.dataset.size = portletData.classSize;
        var dumAr = document.createElement('article');
        dumAr.classList.add('box_shadow');
        dumEl.appendChild(dumAr);
        dummyArea.appendChild(dumEl);

        var element = document.createElement("div");
        element.id = portletData.portletId + "Portlet";
        element.classList.add("portlet");
        element.classList.add(portletData.classSize);
        element.dataset.size = portletData.classSize;
        var article = document.createElement('article');
        article.classList.add('box_shadow');
        element.appendChild(article);
        portletArea.appendChild(element);
    }

    frameSetting(frameId);

    if (usePortletSize) {
        initGridConstruct();
    }
}

function makePortlets(portletOrder) {
    if (portletOrder != null && portletOrder.length != 0) {
        var portletCount = portletOrder.length;

        //포틀릿별로 정보 및 포틀릿 jsp불러오기
        for (var i = 0; i < portletCount; i++) {
            var portletId = portletOrder[i].portletId;
            var portletUrl = portletOrder[i].portletUrl;
            if (!!portletUrl) portletUrl = URLParamsUtils(portletUrl).getFullUrl();
            var portletName = portletOrder[i].portletName;
            var portletCode = portletOrder[i].portletCode;
            (function (portletId, portletUrl, portletName, portletCode) {
                if (portletUrl.indexOf("http") !== -1) {
                    $.ajax({
                        type: "GET",
                        dataType: "html",
                        data: {
                            "portletId": portletId,
                            "portletName": portletName,
                            "usedTheme": usedTheme,
                            "iframeUrl": portletUrl
                        },
                        tryCount: 0,
                        retryLimit: 3,
                        url: "/ezNewPortal/iframePortlet.do",
                        success: function (data) {
                            try {
                                $("#" + portletId + "Portlet").empty().append(data);
                                if (usePortletSize) {
                                    makeGridChangeEvent(portletId);
                                }
                            } catch (e) {
                                console.log(e);
                                makeErrorPortlet(portletId);
                            }
                        },
                        error: makeErrorPortlet(portletId)
                    });
                } else {
                    $.ajax({
                        type: "GET",
                        dataType: "html",
                        data: {
                            "uniq_param": (new Date()).getTime(),
                            "portletId": portletId,
                            "portletName": portletName,
                            "usedTheme": usedTheme
                        },
                        url: portletUrl,
                        tryCount: 0,
                        retryLimit: 3,
                        success: function (result) {
                            try {
                                $("#" + portletId + "Portlet").empty().append(result);
                                if (usePortletSize) {
                                    makeGridChangeEvent(portletId);
                                }

                                if (portletId == 6) {
                                    document.getElementById(portletId + "Portlet").style.background = "none";
                                }

                                eventSetting(portletId, usedTheme, portletCode, false);

                                if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1) {
                                    sortableEvent();
                                }
                            } catch (e) {
                                // 포틀릿 내부 에러시에 포탈 전체 스크립트 에러가 나서 다른 포틀릿의 실행도 막으므로, try catch 처리함
                                console.log('portletId:' + portletId + ' / ' + portletCode);
                                console.log(e);
                                makeErrorPortlet(portletId);
                            }

                        },
                        error: makeErrorPortlet(portletId)
                    });
                }
            }(portletId, portletUrl, portletName, portletCode));
        }
    }
}

// 2024-08-13 황인경 - 포틀릿 제목 ... 처리시 title 표출
function ellipsisTitle(portletName, portletId) {
    var portlet = portletId + "Portlet";
    var portletTitleId = document.getElementById(portlet);
    var portletTitle = portletTitleId.querySelector(".portletText");
    portletTitle.textContent = htmlParser(portletName);
    
    if (portletTitle.scrollWidth > portletTitle.clientWidth) {
        $(portletTitle).on({
            "mouseenter" : function(){
                $(".title_tooltip").text($(this).text());
                $(portletTitle).mousemove(function(){
                    var mouseX = event.clientX;
                    var mouseY = event.clientY;
                    var scrollLeft = $("html").scrollLeft();
                    var scrollTop = $("html").scrollTop();
                    $(".title_tooltip").css({
                        left : mouseX + scrollLeft - 15,
                        top : mouseY + scrollTop + 25
                    })
                })
                $(".title_tooltip").show();
            },
    
            "mouseleave" : function(){
                $(".title_tooltip").hide();
            }
        })
    }
}

// 포틀릿 모달창
function makeInputModal(domArea, placeHold, btnMsg, returnFunction) {
    var layer = document.createElement("div");
    layer.className = 'portlet_modal_layer';
    var wrap = document.createElement("div");
    wrap.className = 'portlet_modal_wrap';
    var input = document.createElement("input");
    input.className = 'portlet_modal_input';
    input.type = 'password';
    input.placeholder = placeHold;
    var btn = document.createElement("div");
    btn.className = 'portlet_modal_btn';
    btn.innerText = btnMsg;
    domArea.append(layer);
    layer.append(wrap);
    wrap.append(input);
    wrap.append(btn);
    
    input.focus();

    input.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            returnFunction(input.value);
            domArea.removeChild(layer);
        }
        else if (e.key === 'Escape') {
            domArea.removeChild(layer);
        }
    });

    layer.addEventListener("click", (function (e) {
        if (e.target === layer) {
            domArea.removeChild(layer);
        } else {
            return false;
        }
    }));
    
    btn.addEventListener("click", (function () {
        returnFunction(input.value);
        domArea.removeChild(layer);
    }));
}

function openAnonymousModal(portletId, pItemID, pType, oBoardID, openFunc) {
    var parser = new DOMParser();
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - 720) / 2;
    var pLeft = (pwidth - 765) / 2;

    $.ajax({
        url: "/ezBoard/boardItemView.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID),
        success: function(response) {
            var returnDom = parser.parseFromString(response, "text/xml")
            if (!returnDom || returnDom.querySelector('title').textContent ==="warning") {
                makeInputModal($('#' + portletId + 'Portlet')[0], strBoardPassword, strBoardOk, (function (password) {
                    openFunc(pItemID, pType, oBoardID, password);
                }));
            } else {
                var newWindow = window.open("", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft);
                newWindow.document.write(response);
                newWindow.document.close();
            }
        },
        error: function(xhr, status, error) {
            console.error('Error:', error);
            makeInputModal($('#' + portletId + 'Portlet')[0], strBoardPassword, strBoardOk, (function (password) {
                openFunc(pItemID, pType, oBoardID, password);
            }));
        }
    });
}

// 툴팁 추가 - 즐겨찾기게시판, 탭게시판 포틀릿
$(document).on('mouseenter', '.longTitle', function() {
    var tooltipText = $(this).text();
    $(".title_tooltip").text(tooltipText);
    $(".title_tooltip").show();
});

$(document).on('mousemove', '.longTitle', function(event) {
    var mouseX = event.clientX;
    var mouseY = event.clientY;
    var scrollLeft = $(window).scrollLeft();
    var scrollTop = $(window).scrollTop();
    
    $(".title_tooltip").css({
        left: mouseX + scrollLeft - 15,
        top: mouseY + scrollTop + 25
    });
});

$(document).on('mouseleave', '.longTitle', function() {
    $(".title_tooltip").hide();
});