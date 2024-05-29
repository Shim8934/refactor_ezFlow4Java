var gridElement;
var initCount = 0;
var GridSize = Object.freeze({
    ONE_BY_ONE:'one_by_one',
    TWO_BY_ONE:'two_by_one',
    ONE_BY_TWO:'one_by_two',
    TWO_BY_TWO:'two_by_two'
});
var ClassPortlet = Object.freeze({
    AREA_PORTLET:"portlet_area",
    PORTLET:"portlet",
    WRAP_PORTLET:"box_shadow",
    BTN_OPEN_POP:"set_portlet",
    BODY_POP:"body_pop_for_size",
    POP_STATE_OPEN:"pop_open",
    CUR_SIZE:"cur_size",
    HANDLE:"sortablePortlet",
    CHK_USE:"chk_portlet",
    OFF_PORTLET:"off_portlet",
    DISPLAY_NONE:"display_none",
    AVAILABLE_SIZE:"size_av",
    UNAVAILABLE_SIZE:"size_uav",
    EDITING:"editing"
});

//* 포틀릿 애니메이션 관련 옵션 *//
// https://docs.muuri.dev/grid-constructor.html#grid-options
var fixed = []
var portletOption = Object.freeze({
    dragEnabled: true, // 드래그 여부
    dragHandle:"." + ClassPortlet.HANDLE, // 드래그 핸들,
    itemPlaceholderClass: 'portlet-placeholder', //placeholder 로 추가될 클래스
    layout: {
        fillGaps:       true,   // 빈칸 자동 채움
        horizontal:     false,
        alignRight:     false,
        alignBottom:    false,
        rounding:       false,
    },
    dragPlaceholder: {
        enabled: true,  // 드래그 시 placeholder 설정
        createElement : function(item) {
            return item.getElement().cloneNode(true);
        },
        onCreate: null,
        onRemove: null,
    },
    dragSortPredicate: function (item) {
        var result = Muuri.ItemDrag.defaultSortPredicate(item, {
            action: 'swap', // move/swap
            threshold: 40,  // 민감도
        });
        if (!!gridElement && !!result) {
            var chkBox = gridElement.getItem(result.index).getElement().getElementsByClassName(ClassPortlet.CHK_USE)[0];
            if (!!chkBox && chkBox.checked === false) return false;
        }
        return result;
    },
    dragStartPredicate: function (item, hammerEvent) {
        // 좌클릭으로만 동작
        if (hammerEvent.srcEvent.button !== 0) return false;
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

        if (handleClassChk) {
            return false;
        }

        return true;
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

        // offLoadingLayer();
        gridElement.on('dragEnd', function () {
            if (typeof usedTheme == 'undefined' || !usedTheme) usedTheme = document.querySelector('.portletList').getAttribute('data-themeid');
            gridElement.synchronize();
            userPortletUpdateWithSize(usedTheme);
        });
        gridElement.on('layoutStart', function (items, isInstant) {
            return false;
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
            e = e||window.event;
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
    resizePortlet(pot);
    if (typeof usedTheme == 'undefined' || !usedTheme) usedTheme = document.querySelector('.portletList').getAttribute('data-themeid');
    userPortletUpdateWithSize(usedTheme);
    
    var portletPagingArea = pot.querySelector('.portletPagingArea');
    if (portletPagingArea) { // 포틀릿 페이지네이션 처리
    	changePortletViewCount(pot.id.replace('Portlet',''), portletPagingArea);
    }
    
    // 게시판 포틀릿 사이즈 변경시 게시판 뷰 카운트 변경
    if (typeof changeBoardViewCount == 'function') {
        changeBoardViewCount(pot.id.replace('Portlet',''));
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
    if(!availableArr) availableArr = [GridSize.ONE_BY_ONE];

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
    e = e||window.event;
    e.stopPropagation();
    closePopPortletSizeAll();
    var node = this.parentElement.getElementsByClassName(ClassPortlet.BODY_POP)[0];
    node.classList.add(ClassPortlet.POP_STATE_OPEN);
}

// 포틀릿 사이즈 변경 팝업 닫기
function closePopPortletSizeAll(e) {
    e = e||window.event;
    if (!e.target.closest("." + ClassPortlet.BODY_POP)) {
        var popList = document.querySelectorAll("." + ClassPortlet.BODY_POP + "." + ClassPortlet.POP_STATE_OPEN);
        Array.prototype.forEach.call(popList, function(node){
            node.classList.remove(ClassPortlet.POP_STATE_OPEN);
        });
    }
}

function getAvailablePortletSize(companyId, themeId) {
    var result;
    var request = new XMLHttpRequest();
    request.open('POST', '/admin/ezNewPortal/getAvailablePortletSize.do', false);
    request.setRequestHeader('Content-Type', 'application/json');
    request.onload = function() {
        if (request.status === 200) {
            result = JSON.parse(request.responseText);
        } else {
            console.error(request.statusText);
        }
    }

    var data = JSON.stringify({
        companyId : companyId,
        themeId : themeId
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
        updateOrder.push({"portletOrder" : i + 1, "portletId" : portletId, "classSize" : portlet.dataset.size});
    }

    var data = {
        themeId : usedTheme,
        updateOrder : updateOrder
    };

    //ajax로 순서 변경
    $.ajax({
        type : "POST",
        url : "/ezNewPortal/updatePortletOrderUser.do",
        contentType : "application/json",
        dataType : "text",
        data : JSON.stringify(data),
        success : function(result) {
            console.debug("포틀릿 순서 변경 성공");
        },
        error : function() {
            console.error("포틀릿 순서 변경 실패");
        }
    });
}

function resizePortlet(portletNode) {
    gridElement.refreshItems();
    gridElement.layout();
}

function reloadPortlet(portletId){
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
    for(var i = 0; i < portletCount; i++) {
        var portletId2 = portletOrder[i].portletId;
        if(portletId == portletId2){
            portlet = portletOrder[i];
            portletUrl = portletOrder[i].portletUrl;
            portletName = portletOrder[i].portletName;
            portletCode = portletOrder[i].portletCode;
            break;
        }
    }

    frameSetting(frameId);

    $.ajax({
        type : "GET",
        dataType : "html",
        data : {"uniq_param" : (new Date()).getTime(), "portletId" : portletId, "portletName" : portletName, "usedTheme" : usedTheme},
        url : portletUrl,
        tryCount : 0,
        retryLimit : 3,
        success : function(result) {
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
        error : function() {
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
    for(var i = 0; i < portletCount; i++) {
        if (id == portletOrder[i].portletId) return portletOrder[i].listPortletSize;
    }
}

function Paging() {
    var _countPerPage;
    var _start;
    var _page;
    var _total = -1;
    var _option = {
        maintain:true, // 페이지 숫자 변환시 현제 페이지 유지 여부
        pageStart:0, // getPage()시 시작 페이지
    }

    var _resetPage = function (count) {
        _page = _option.pageStart;
        _countPerPage = count;
        _start = 0;
    }

    var _changeCount = function (count) {
        _start -= _start % count;
        _countPerPage = count;
        _page = _start / count + _option.pageStart;
    }

    return {
        init: function (count) {
            _resetPage(count);
            return {
                getPage: function () {
                    return _page;
                },
                getStartPage: function () {
                    return _option.pageStart;
                },
                getCountPerPage: function () {
                    return _countPerPage;
                },
                getStart: function () {
                    return _start;
                },
                next: function () {
                    _start += _countPerPage;
                    _page++;
                    return this;
                },
                previous: function () {
                    _start -= _countPerPage;
                    _start = _start < 0 ? 0 : _start;
                    _page--;
                    return this;
                },
                changeCount: function (count) {
                    if (_option.maintain) {
                        _changeCount(count);
                    } else {
                        _resetPage(count);
                    }
                    return this;
                },
                first: function () {
                    _start = 0;
                    return this;
                },
                setTotal: function (total) {
                    if (total < _start) {
                        console.error("The total must be greater than the start.");
                        return this;
                    }
                    _total = total;
                    return this;
                },
                getTotal: function () {
                    return _total;
                },
                last: function () {
                    if (_total === -1) return this;
                    _start = _total - _total % _countPerPage;
                    _page = _start / _countPerPage + _option.pageStart;
                    return this;
                },
                resetPage : function () {
                	_page = _option.pageStart;
                	_start = 0;
                }
            }
        }
    };
}

function changePortletViewCount(portletId, portletPagingArea) {
	var portletPageObj = portletInfoMap["portlet" + portletId].page;
	var perCount = portletPageObj.getPagePerCount(portletId);
	portletPageObj.changeCount(perCount);
	var startRowIdx = portletPageObj.getStart();
	var portletPageList = portletPagingArea.children;
	
	portletListDisplayProcess(portletPageList, startRowIdx, perCount);
	
}

function resetPortletList(portletId, totalCnt) {
	var portletPageObj = portletInfoMap["portlet" + portletId].page;
	portletPageObj.resetPage();
	var perCount = portletPageObj.getPagePerCount(portletId);
	portletPageObj.setTotal(totalCnt);
	
	if (totalCnt > 0) {
		var portletPageList = document.getElementById(portletId + "Portlet").querySelector(".portletPagingArea").children;
		var startRowIdx = portletPageObj.getStart();
		var currentPage = portletPageObj.getPage();
		portletListDisplayProcess(portletPageList, startRowIdx, perCount);
	}
}

function portletListDisplayProcess(portletPageList, startRowIdx, perCount) {
	for (var i = 0; i < portletPageList.length; i++) {
		portletPageList[i].style.display = "none";
		if (i >= startRowIdx && i < startRowIdx + perCount) {
			portletPageList[i].style.display = "block";
		}
	}
}

function portletMovePage(portletId, mode) {
	var portletPageObj = portletInfoMap["portlet" + portletId].page;
	var currPage = portletPageObj.getPage();
	var totalCnt = portletPageObj.getTotal();
	var startRowIdx = portletPageObj.getStart();
	var perCount = portletPageObj.getPagePerCount(portletId);
	
	var moveFlag = false;
	if (mode == "prev" && startRowIdx > 0) {
		portletPageObj.previous();
		moveFlag = true;
	} else if (mode == "next" && startRowIdx + perCount < totalCnt) {
		portletPageObj.next();
		moveFlag = true;
	}
	
	if (!moveFlag) {
		return;
	}
	
	var portletPageList = document.getElementById(portletId + "Portlet").querySelector(".portletPagingArea").children;
	
	startRowIdx = portletPageObj.getStart();
	perCount = portletPageObj.getPagePerCount(portletId);
	portletListDisplayProcess(portletPageList, startRowIdx, perCount);
}
