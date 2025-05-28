// it needs swiper.min.js, swiper.min.css
function  FixBoardUtil() {
    var _area;
    var _thisDom;
    var _id;
    var _delay = 5000;
    var _lazy = 0;
    var _boardList;
    var _defaultImg = ['/images/slide_sample.png', '/images/slide_sample2.png', '/images/slide_sample3.png', '/images/slide_sample4.png'];
    var _title;
    var _swiper;
    var _enum = Object.freeze({
        CLASS_IMG_SLIDE: 'img_slide', // 최상단 css용
            CLASS_FIX_PORTLET: 'fix-portlet',
                CLASS_BOX: 'box_shadow',
                    CLASS_LAYER: 'layDIV',
                        CLASS_TITLE: 'portlet_title',
                            CLASS_TITLE_TEXT: 'portletText',
                            CLASS_TITLE_PLUS: 'portletPlus',
                        CLASS_SWIPER: 'swiper',
                        CLASS_CONTAINER:'swiper-container',
                            CLASS_WRAPPER: 'swiper-wrapper',
                                CLASS_SLIDE: 'swiper-slide',
                                CLASS_CONT_TEXT: 'slide_txt',
                            CLASS_PREV: 'swiper-button-prev',
                            CLASS_NEXT: 'swiper-button-next',
                            CLASS_PAGINATION: 'swiper-pagination',
        CLASS_HIDE: 'display_none'
    });

    var _makeWrap = function () {
        var area = document.querySelector(_area);
        area.classList.add(_enum.CLASS_IMG_SLIDE);
        _thisDom = document.createElement('div');
        _thisDom.id = _id;
        _thisDom.classList.add(_enum.CLASS_FIX_PORTLET);
        _thisDom.classList.add(_enum.CLASS_HIDE);
        area.appendChild(_thisDom);

        var article = document.createElement('article');
        article.classList.add(_enum.CLASS_BOX);
        _thisDom.appendChild(article);

        var layDiv  = document.createElement('div');
        layDiv.classList.add('layDIV');
        article.appendChild(layDiv);

        var dlTitle = document.createElement('dl');
        dlTitle.classList.add(_enum.CLASS_TITLE);
        layDiv.appendChild(dlTitle);

        var titleText = document.createElement('dt');
        titleText.classList.add(_enum.CLASS_TITLE_TEXT);
        dlTitle.appendChild(titleText);
        textNode = document.createTextNode(_title);
        titleText.appendChild(textNode);
        var titlePlus = document.createElement('dd');
        titlePlus.classList.add(_enum.CLASS_TITLE_PLUS);
        titlePlus.classList.add('plus');
        dlTitle.appendChild(titlePlus);
        // var plusImg = document.createElement('img');
        // plusImg.setAttribute('src', '/images/ezNewPortal/portlet_Plus1_white.png');
        // titlePlus.appendChild(plusImg);

        var swiper = document.createElement('div');
        swiper.classList.add(_enum.CLASS_SWIPER);
        swiper.classList.add(_enum.CLASS_CONTAINER);
        layDiv.appendChild(swiper);
        var wrapper = document.createElement('div');
        wrapper.classList.add(_enum.CLASS_WRAPPER);
        swiper.appendChild(wrapper);
        var dNext = document.createElement('div');
        dNext.classList.add(_enum.CLASS_NEXT);
        swiper.appendChild(dNext);
        var dPrev = document.createElement('div');
        dPrev.classList.add(_enum.CLASS_PREV);
        swiper.appendChild(dPrev);
        var pagination = document.createElement('div');
        pagination.classList.add(_enum.CLASS_PAGINATION);
        swiper.appendChild(pagination);
    }

    var _makeSlidPage = function () {
        if (!_boardList) return;
        var title = _thisDom.getElementsByClassName(_enum.CLASS_TITLE)[0];
        var boardID = _boardList[0].boardID;
        title.setAttribute('data1', boardID);
        title.getElementsByClassName(_enum.CLASS_TITLE_PLUS)[0].addEventListener("click", function (event) {
            window.open("/ezBoard/boardMainRedirect.do?boardID=" + encodeURIComponent(boardID), "main", "");
        });

        var slideLink = [];

        var max = _boardList.length;
        for (var i = 0; i < max; i++) {
            var board = _boardList[i];
            var slide = document.createElement('div');
            slide.classList.add(_enum.CLASS_SLIDE);
            var wrapper = _thisDom.getElementsByClassName(_enum.CLASS_WRAPPER)[0];
            wrapper.appendChild(slide);

            var img = document.createElement('img');
            var thumbnail = !!board.thumbnail ? board.thumbnail : _defaultImg[i % _defaultImg.length];
            img.setAttribute('src', thumbnail);
            slide.appendChild(img);

            var divText = document.createElement('div');
            divText.classList.add(_enum.CLASS_CONT_TEXT);
            slide.appendChild(divText);

            var dl = document.createElement('dl');
            divText.appendChild(dl);

            var dTitle = document.createElement('dt');
            dl.appendChild(dTitle);
            textNode = document.createTextNode(board.title);
            dTitle.appendChild(textNode);

            var dd = document.createElement('dd');
            dl.appendChild(dd);
            textNode = document.createTextNode(!!board.content ? board.content : "");
            dd.appendChild(textNode);

            var dd2 = document.createElement('dd');
            dl.appendChild(dd2);

            slideLink[i] = [board.itemID, board.guBun, board.boardID];
        }

        _thisDom.addEventListener("click", function (event) {
            if (!event.target.closest('.swiper-slide')) return;
            var index = event.target.closest('.swiper-slide').getAttribute('data-swiper-slide-index');
            openBoard(slideLink[index][0],slideLink[index][1],slideLink[index][2]);
        });
    }


    var _initSwiper = function () {
        var areaSelector = "#" + _id;
        var classSelector = " .";
        _swiper = new Swiper(areaSelector + classSelector + _enum.CLASS_SWIPER, {
            direction: 'horizontal',
            loop: true,
            pagination: {
                el: areaSelector + classSelector + _enum.CLASS_PAGINATION,
                type: "fraction",
            },
            navigation: {
                nextEl: areaSelector + classSelector + _enum.CLASS_NEXT,
                prevEl: areaSelector + classSelector + _enum.CLASS_PREV,
            },
            autoplay: {
                delay: _delay,
                disableOnInteraction: false,
            }
        });
        
        if (_lazy != 0) {
        	_swiper.autoplay.stop();
        	setTimeout(function () {
        		_swiper.autoplay.start();
        	}, _lazy);
        }
    }

    var _chkBuild = function () {
        if (!_area) {
            console.error('area is not defined');
            return false;
        }
        if (!_id) {
            console.error('id is not defined');
            return false;
        }
        return true;
    }

    var _chkStart = function () {
        if (!_boardList) {
            console.error('boardList is not defined');
            return false;
        }

        if (!_thisDom) {
            console.error('thisDom is not defined');
            return false;
        }
        return true;
    }

    return {
        title: function (title) {
            _title = title;
            return this;
        },
        area: function (sel) {
            _area = sel;
            return this;
        },
        id: function (id) {
            _id = id;
            return this;
        },
        makeShell: function () {
            if (!_chkBuild()) return;
            _makeWrap();
            return this;
        },
        start : function (bList) {
            _boardList = bList;
            _thisDom.classList.remove(_enum.CLASS_HIDE);
            if (!_chkStart()) return;
            _makeSlidPage();
            _initSwiper();
            return this;
        },
        getId : function () {
            return _id;
        },
        getTargetDom : function () {
            return _thisDom;
        },
        getEnum : function () {
            return _enum;
        },
        getList : function () {
            return _boardList;
        },
        getSwiper : function () {
            return _swiper;
        },
        hide : function () {
            _thisDom.classList.add(_enum.CLASS_HIDE);
            return this;
        },
        setSwiperTime : function (delay, lazy) {
        	_delay = delay;
        	_lazy = lazy;
        	return this;
        }
    };
}