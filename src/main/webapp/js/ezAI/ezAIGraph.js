/**
    * graph 클래스
    * info 참조
    * ezTime_common.js 필수
    * @returns
*/
window.GraphDocument = class GraphDocument {

    /**
        * 타입 donut / line / xline ( 도넛형/ 막대형 / 가로 막대형)
        */
    type = 'donut';

    /**
        * 정의할 데이터
        * info = {
        *      ( option(막대형일 경우) )
        *      graph_line_option : {
        *          dot_view_fun : ( Function ),
        *          unit : ( Number ),
        *          units_fixed : [ Number , Number, ... ],
        *          height : ( Number )
        *      },
        *      graph_donut_option : {
        *          diameter : ( 직경 Number  없으면 부모 태그 직경 ),
        *          stroke_width : ( 도넛 굵기, 없으면 diameter / 3 )
        *      },
        *      graph_limit : ( Number : 없으면 graph_values의 colnamem의 값들의 총합 중 가장 큰 값 ),
        *      graph_info_view : ( Boolean default : true ),
        *      graph_white_area_event ( 화이트 부분 갓을 때 생기는 이벤트 처리 )
        *      graph_info : {
        *          key : {
        *              view_text : ( String )
        *              calc : ( Function ),
        *              color : ( css Color ),
        *              subfix_calc : ( option : Function ),
        *              info_box_display : ( Boolean  default : true ),
        *              click_event : ( Function ),
        *              mousemove_event : ( Function )
        *              percent_calc : ( Function )
        *          }, ...
        *      },
        *      graph_values : {
        *          col_name : {         
        *              key : value
        *              , key : value
        *              , ...  
        *          }, ...
        *      },
        *      graph_col_views : {
        *          col_name : ( String )
        *          ,...
        *      },
        *      ( 없을 경우 기본 graph_limit, 없으면 graph_values의 colnamem의 값들의 총합 중 가장 큰 값  )
        *      graph_col_totals : {
        *          col_name : ( Number )
        *          ,...
        *      }
        * }
        */
    #info = {
        graph_donut_option: {},
        graph_line_option: {},
        graph_limit: 0,
        graph_info_view: true,
        graph_white_area_event: null,
        graph_info: {},
        graph_values: {},
        graph_col_views: {},
        graph_col_totals: {}
    };

    get info() {
        return this.#info
    }

    set info(val) {

        if (!val)
            val = {};

        // 검수
        if (typeof val['graph_info'] !== 'undefined') {

            let graph_info = val['graph_info'];
            Object.keys(graph_info).forEach(key => {
                let obj = graph_info[key];
                if (typeof obj['calc'] !== 'function' || !obj['calc'])
                    obj['calc'] = (value) => value;
                if (typeof obj['subfix_calc'] !== 'function' || !obj['subfix_calc'])
                    obj['subfix_calc'] = () => '';
                if (typeof obj['color'] === 'undefined' || !obj['color'])
                    obj['color'] = getRandomColor();
                if (typeof obj['view_text'] === 'undefined')
                    obj['view_text'] = key;
                if (typeof obj['info_box_display'] !== 'boolean')
                    obj['info_box_display'] = true;
                if (typeof obj['click_event'] !== 'function')
                    obj['click_event'] = null;
                if (typeof obj['mousemove_event'] !== 'function')
                    obj['mousemove_event'] = null;
                if (typeof obj['percent_calc'] !== 'undefined')
                    obj['percent_calc'] = null;
            });

        } else
            val['graph_info'] = {};

        if (!val['graph_values'])
            val['graph_values'] = {};

        if (typeof val['graph_limit'] !== 'number' || isNaN(val['graph_limit']))
            val['graph_limit'] = 0;

        if (typeof val['graph_info_view'] !== 'boolean')
            val['graph_info_view'] = true;

        if (this.type === 'line') {

            let linePosInfo = val['graph_line_option'];
            if (linePosInfo) {


                if (typeof linePosInfo['dot_view_fun'] !== 'function' || !linePosInfo['dot_view_fun'])
                    linePosInfo['dot_view_fun'] = (info) => info;

                if (typeof linePosInfo['unit'] === 'undefined' || !linePosInfo['unit'] || isNaN(linePosInfo['unit']))
                    linePosInfo['unit'] = 0;

                if (typeof linePosInfo['height'] === 'undefined' || !linePosInfo['height'] || isNaN(linePosInfo['height']))
                    linePosInfo['height'] = 350;

                if (typeof linePosInfo['units_fixed'] === 'undefined' || !linePosInfo['units_fixed'] || Array.isArray(linePosInfo['units_fixed']))
                    linePosInfo['units_fixed'] = [];
            } else
                val['graph_line_option'] = {
                    limit: 0,
                    dot_view_fun: (info) => info,
                    unit: 0,
                }

        } else if (this.type === 'donut') {
            let donutOption = val['graph_donut_option'];
            if (donutOption) {

                if (typeof donutOption['diameter'] !== 'number' || isNaN(donutOption['diameter']))
                    donutOption['diameter'] = 0;
                if (typeof donutOption['stroke_width'] !== 'number' || isNaN(donutOption['stroke_width']))
                    donutOption['stroke_width'] = 0;
                if (typeof donutOption['graph_donut_button'] !== 'boolean')
                    donutOption['graph_donut_button'] = false;

            }
        }
        if (typeof val['graph_col_views'] === 'undefined' || !val['graph_col_views'])
            val['graph_col_views'] = {};

        if (typeof val['graph_col_totals'] === 'undefined' || !val['graph_col_totals'])
            val['graph_col_totals'] = {};

        this.#info = val;
    }

    /**
        * 붙일 document id
        */
    #appendCont = null;

    /**
        * 붙일 document Element
        */
    get appendContainer() {
        let res = null;
        if (this.#appendCont) {
            if (typeof this.#appendCont === 'string')
                res = document.getElementById(this.#appendCont);
            else
                res = this.#appendCont;
        }
        return res;
    }

    get keys() {
        if (this.info['graph_info'])
            return Object.keys(this.info['graph_info']);
        else
            return []
    }

    get colnames() {
        if (this.info['graph_values'])
            return Object.keys(this.info['graph_values']);
        else
            return []
    }

    get graph_info() {
        return this.info['graph_info'] || {};
    }

    get graph_values() {
        return this.info['graph_values'] || {};
    }

    get graph_limit() {
        let res = 0;
        if (typeof this.info['graph_limit'] === 'number' && !isNaN(this.info['graph_limit']))
            res = Number(this.info['graph_limit']);
        if (!res) {
            // limit 없는 경우 colname 지정 values의 총합 중 가중 큰 값
            let colValueTotals = this.colnames.map(colname => this.getGraphValueTotal(colname));
            res = Math.max(...colValueTotals);
        }
        return res;
    }

    get graph_info_view() {
        return this.info['graph_info_view'] || true;
    }

    get graph_col_views() {
        return this.info['graph_col_views'] || {};
    }

    get graph_dot_view_fun() {
        return (this.info['graph_line_option'] || {})['dot_view_fun'] || ((val) => val);
    }

    get graph_line_unit() {
        return Number((this.info['graph_line_option'] || {})['unit'] || 0);
    }

    get graph_line_units_fixed() {
        let res = (this.info['graph_line_option'] || {})['units_fixed'] || [];
        return res;
    }

    get graph_line_height() {
        return Number((this.info['graph_line_option'] || {})['height'] || 0);
    }

    get graph_col_totals() {
        return this.info['graph_col_totals'] || {};
    }

    get graph_donut_diameter() {
        let res = Number((this.info['graph_donut_option'] || {})['diameter'] || 0);
        if (res > 0)
            res = res / 2;
        return res;
    }

    get graph_donut_stroke_width() {
        return Number((this.info['graph_donut_option'] || {})['stroke_width'] || 0);
    }
    get graph_donut_button() {
        return (this.info['graph_donut_option'] || {})['graph_donut_button'] || false;
    }

    /**
        * key의 컬러값
        * @param {any} key
        * @returns
        */
    getColorOfKey(key) {
        let res = this.graph_info[key]['color'];
        if (!res) {
            res = getRandomColor();
            this.graph_info[key]['color'] = res;
        }
        return res;
    }

    /**
        * key의 함수
        * @param {any} key
        * @returns
        */
    getCalcOfKey(key) {
        let res = this.graph_info[key]['calc'];
        if (!res) {
            res = value => value;
            this.graph_info[key]['calc'] = res;
        }
        return res.bind(this);
    }

    /**
        * key 에 표현할 함수
        * @param {any} key
        * @returns
        */
    getSubCalcOfKey(key) {
        let res = this.graph_info[key]['subfix_calc'];
        if (!res) {
            res = () => '';
            this.graph_info[key]['subfix_calc'] = res;
        }
        return res.bind(this);
    }

    /**
     * key 기준 percent 계산 함수
     * @param {any} key
     * @returns
     */
    getPercentCalcOfKey(key) {
        let res = this.graph_info[key]['percent_calc'];
        if (!res) {
            res = (val, total, perFlag) => val / total * (perFlag? 100 : 1);
            this.graph_info[key]['percent_calc'] = res;
        }
        return res.bind(this);
    }

    /**
        * key의 화면에 보여줄 Text ( 없을 시 key )
        * @param {any} key
        */
    getViewTextOfKey(key) {
        let res = this.graph_info[key]['view_text'];
        if (!res) {
            res = key;
            this.graph_info[key]['view_text'] = res;
        }
        return res;
    }

    /**
        * key 기반으로 각 col의 value 값 추출 { colname : value, ... }
        * @param {any} key
        * @returns
        */
    getValuesOfKey(key) {
        let values = this.graph_values
        return this.colnames.reduce((acc, colname) => {
            if (values[colname])
                acc[colname] = values[colname][key] || '';
            return acc;
        }, {});
    }

    /**
        * 지정 key 기준으로 각 colname에 있는 key의 value 치환 처리
        * 정의 되어 있지 않는 key값은 제외 처리
        * @param {any} key graph_info에 정의 되어 있는 key
        * @param {any} inserObject { colname : value, ... }
        * @param {any} redraw 재생성
        */
    setValuesOfKey(key, inserObject, redraw) {
        try {

            if (this.keys.findIndex(k => k === key) > -1) {
                let changeChk = 0;
                let iColNames = Object.keys(inserObject);
                iColNames.forEach(colname => {
                    if (this.colnames.findIndex(c => c === colname) > -1) {
                        this.graph_values[colname][key] = inserObject[colname];
                        changeChk++;
                    }
                })
                if (changeChk > 0 && redraw)
                    this.redraw();
            }

        } catch (e) {
            console.error(e);
        }
    }

    /**
        * colname으로 지정 key, value 추출 { key : value, ... }
        * @param {any} colname
        * @returns
        */
    getValuesOfColName(colname) {
        return this.graph_values[colname] || {};
    }


    /**
        * 지정 colname 기준으로 key의 value 치환 처리
        * 정의 되어 있지 않는 colname값은 제외 처리
        * @param {any} colname graph_vallues에 정의 되어 있는 colname
        * @param {any} inserObject { colname : value, ... }
        * @param {any} redraw 재생성
        */
    setValueOfColName(colname, inserObject, redraw) {

        try {

            if (this.colnames.findIndex(c => c === colname) > -1) {
                let changeChk = 0;
                let iKeys = Object.keys(inserObject);
                iKeys.forEach(key => {
                    if (this.keys.findIndex(key) > -1) {
                        this.graph_values[colname][key] = inserObject[key];
                        changeChk++;
                    }
                });
                if (changeChk > 0 && redraw)
                    this.redraw();
            }

        } catch (e) {
            console.error(e);
        }

    }

    /**
        * 지정 colname기준으로 colname 대신 표시할 명칭 ( 없으면 colname 그대로 )
        * @param {any} colname
        */
    getViewTextOfColName(colname) {
        return this.graph_col_views[colname] || colname;
    }

    /**
        * 지정 colname의 표시 명칭 변경
        * @param {any} colname
        * @param {any} viewText
        */
    setViewTextOfColName(colname, viewText, redraw) {
        try {
            if (this.graph_col_views[colname] !== viewText) {
                this.graph_col_views[colname] = viewText;
                if (redraw)
                    this.redraw();
            }
        } catch (e) {
            console.error(e);
        }
    }

    /**
        * 지정 Key의 클릭이벤트
        * @param {any} key
        * @returns
        */
    getClickEventOfKey(key) {
        let res = null;
        try {
            let obj = this.graph_info[key] || {};
            if (typeof obj['click_event'] !== 'function')
                res = null;
            else
                res = obj['click_event'].bind(this);

        } catch (e) {
            console.error(e);
        }
        return res;
    }

    /**
        * 클릭이벤트가 하나라도 있는지 체크
        * @returns
        */
    hasClickEvent() {
        let res = false;
        try {
            res = this.keys.findIndex(key => typeof this.graph_info[key]['click_event'] === 'function') > -1;
        } catch (e) {
            console.error(e);
        }
        return res;
    }


    /**
        * 지정 Key의 마우스 무브 이벤트
        * @param {any} key
        * @returns
        */
    getMouseMoveEventOfKey(key) {
        let res = null;
        try {
            let obj = this.graph_info[key] || {};
            if (typeof obj['mousemove_event'] !== 'function')
                res = null;
            else
                res = obj['mousemove_event'].bind(this);

        } catch (e) {
            console.error(e);
        }
        return res;
    }

    /**
        * 마우스 무브 이벤트가 하나라도 있는지 체크
        * @returns
        */
    hasMouseMoveEvent() {
        let res = false;
        try {
            res = this.keys.findIndex(key => typeof this.graph_info[key]['mousemove_event'] === 'function') > -1;
        } catch (e) {
            console.error(e);
        }
        return res;
    }


    /**
        * 컬러값으로 key찾기
        * @param {any} color
        */
    getKeyOfColor(color) {
        let res = '';
        try {
            color = color.toUpperCase();
            res = this.keys.find(key => {
                let keyColor = (this.graph_info[key]['color'] || '').toUpperCase();
                return keyColor === color;
            });

        } catch (e) {
            console.error(e)
        }
        return res;
    }


    /**
        * 키 정의 추가
        * @param {any} key
        * @param {any} keyinfo { color, calc, subfix_calc, view_text }
        */
    addKey(key, keyinfo) {
        try {

            let { calc, color, subfix_calc, view_text } = keyinfo || {};
            if (typeof calc !== 'function' || !calc)
                calc = value => value;
            if (typeof calc === 'undefined' || !color)
                color = getRandomColor();
            if (typeof view_text !== 'function' || !view_text)
                view_text = key;

            this.graph_info[key] = { calc, color, subfix_calc, view_text };

        } catch (e) {
            console.error(e);
        }
    }

    /**
        * 지정 colname 추가
        * 정의되지 않는 keyValue 값은 제외 처리
        * @param {any} colname
        * @param {any} keyValues { key : value, ... }
        * @param {any} redraw 재생성
        */
    addColname(colname, keyValues, redraw) {
        try {

            this.graph_values[colname] = {};

            let iKeys = Object.keys(keyValues);

            iKeys.forEach(key => {
                if (this.keys.findIndex(k => k === key) > -1)
                    this.graph_values[colname][key] = keyValues[key]
            });

            if (redraw)
                this.redraw();

        } catch (e) {
            console.error(e);
        }
    }


    /**
        * 지정 colname에 포함된 모든 값 합계
        * @param {any} colname
        * @returns
        */
    getGraphValueTotal(colname) {
        let res = 0;
        try {
            let keyValues = this.getValuesOfColName(colname);
            let keys = Object.keys(keyValues);
            keys.forEach(key => {
                let val = keyValues[key];
                if (!isNaN(val))
                    res += Number(val);
            });
        } catch (e) {
            console.error(e);
        }
        return res;
    }

    /**
        * 지정 colname 기준으로 최대값
        * @param {any} colname
        * @param {any} replaceLimit 총합값이 없는 경우 지정 최대값
        */
    getTotalOfColName(colname, replaceLimit) {
        let res = 0;
        try {

            if (typeof this.graph_col_totals[colname] === 'number' && !isNaN(this.graph_col_totals[colname]))
                res = Number(this.graph_col_totals[colname]);

            if (!res)
                res = replaceLimit || this.graph_limit;

        } catch (e) {
            console.error(e);
        }
        return res;
    }


    /**
        * 키를 Info Box에 표시 하는지 제어
        * @param {any} key
        */
    isDoNotDisplayOfKey(key) {
        let isCheck = true;
        try {

            if (this.keys.findIndex(k => k === key) > -1) {
                isCheck = this.graph_info[key]['info_box_display'];
                if (typeof isCheck !== 'boolean')
                    isCheck = true;
            } else
                isCheck = false;

        } catch (e) {
            console.error(e);
        }
        return isCheck;
    }


    /**
        * 그래프를 감쌓고 있는 최상위 Div
        */
    get topDiv() {
        return this.appendContainer.querySelector('.conts_box');
    }
    /**
        * 그래프 뼈대 정보 Div
        */
    get skelDiv() {
        let res = null;
        if (this.topDiv) {
            if (this.type === 'donut')
                res = this.topDiv.querySelector('.all');
            else if (this.type === 'line')
                res = this.topDiv.querySelector('ul.graph_detail');
            else if (this.type === 'xline')
                res = this.topDiv.querySelector('div.graph_detail');
        }
        return res;
    }

    /**
        * 그래프 뼈대 정의 Element 배열
        */
    get skelDetails() {
        let res = [];
        if (this.skelDiv) {
            if (this.type === 'donut')
                res = Array.from(this.skelDiv.querySelectorAll('.detail > div'));
            else if (this.type === 'line')
                res = Array.from(this.skelDiv.querySelectorAll('li.item'));
            else if (this.type === 'xline')
                res = Array.from(this.skelDiv.querySelectorAll('span.item'));
        }
        return res;
    };

    /**
        * graph 감쌓고 있는 wrap
        */
    get graphWrap() {
        let res = null;
        if (this.topDiv)
            res = this.topDiv.querySelector('.graph_wrap');
        return res;
    }
    /**
        * 생성된 그래프 배열
        */
    get graphElements() {
        let res = [];
        if (this.topDiv)
            res = Array.from(this.topDiv.querySelectorAll(`.graph_item_${this.type}`));
        return res;
    }

    /**
        * 막대 그래프일 경우 Y축 표시 Elements
        */
    get graphYUnitElement() {
        let res = [];
        if (this.graphWrap && this.type === 'line')
            res = Array.from(this.topDiv.querySelectorAll('ul.axis_y > li.item'));
        return res;
    }

    drawing = false;
    draw(type, appendTarget, info, callback) {

        this.drawing = true;
        try {

            if (appendTarget)
                this.#appendCont = appendTarget;

            if (type)
                this.type = type;

            if (info)
                this.info = info;

            let graphDom = null
            if (this.type === 'donut')
                graphDom = this.#createDonuts();
            else if (this.type === 'line')
                graphDom = this.#createLines();
            else if (this.type === 'xline')
                graphDom = this.#createXLine();


            if (graphDom) {

                if (this.appendContainer) {
                    this.appendContainer.append(graphDom);
                    if (this.type === 'line') {

                        setTimeout((() => {

                            this.topDiv.querySelector('.vertical_chart_box').style.visibility = '';

                            if (typeof callback === 'function')
                                callback.bind(this, this);

                        }).bind(this), 1);

                    } else if (this.type === 'donut') {

                        setTimeout((() => {

                            this.#createDonutCanvas();

                            let resize = (e => {

                                if (this.appendContainer) {

                                    let diameter = this.graph_donut_diameter;
                                    if (!diameter) {

                                        let wrap = this.graphWrap;

                                        let wrapDiameter = Math.min(wrap.offsetWidth, wrap.offsetHeight);

                                        diameter = wrapDiameter / this.graphElements.length / 2 - 5;

                                        if (Number(wrap.dataset.d) !== diameter)
                                            this.redraw();
                                    } else
                                        window.removeEventListener('resize', resize);
                                }
                                else
                                    window.removeEventListener('resize', resize);

                            }).bind(this);

                            window.addEventListener('resize', resize);

                            if (typeof callback === 'function')
                                callback.bind(this, this);

                        }).bind(this), 1);

                    }
                }
                else
                    console.error('AppendContainer not found.')

            } else
                console.error('Create Graph Error.')


        } catch (e) {
            console.error(e);
        }
        this.drawing = false;
    }

    /**
        * ( 캔버스로 전환하면서 사용 안함 )
        * donut 일 경우 Conic 값 구하기
        * @param {any} colname
        * @returns
        */
    #getDountConicValue(colname) {

        let bg = '';
        try {
            if (this.type === 'donut') {

                let graph_values = this.getValuesOfColName(colname);
                let graph_limit = this.graph_limit;
                let colTotal = this.getTotalOfColName(colname, graph_limit);
                let conicStr = '';
                let accValue = 0;
                let iKeys = Object.keys(graph_values);
                iKeys.forEach((key, idx) => {

                    if (this.keys.findIndex(k => k === key) > -1) {

                        let color = this.getColorOfKey(key);
                        let calc = this.getCalcOfKey(key);
                        let val = graph_values[key];
                        val = Number(calc(val, key, idx, colname, this.info)) / colTotal * 100;
                        accValue += val;
                        conicStr += `${color} 0% ${accValue}%, `;
                    }

                });

                if (accValue < 100) {

                    let emptyPercent = 100 - accValue;
                    conicStr += `#E9E9E9 0% ${emptyPercent}%`;

                } else {

                    conicStr = conicStr.trim();
                    conicStr = conicStr.substring(0, conicStr.length - 1);

                }

                bg = `conic-gradient(${conicStr})`;

            }

        } catch (e) {
            console.error(e);
        }
        return bg;
    }

    /**
        * 원형 그래프 생성
        * @returns
        */
    #createDonuts() {
        let dom = document.createDocumentFragment();
        try {


            let colNames = this.colnames;

            let conts_box = document.createElement('div');
            conts_box.classList.add('conts_box');
            //conts_box.style.cssText = 'display: flex;justify-content: center;align-items: center;overflow:hidden;position:relative';
            conts_box.style.width = '100%';
            conts_box.style.height = '100%';
            
            /**
                * 그래프 전체 정의
                */
            let graph_title= document.createElement('p');
            graph_title.classList.add('test');
            let graph_wrap = document.createElement('div');
            graph_wrap.classList.add('graph_wrap');
            graph_wrap.style.display = 'flex';
            graph_wrap.style.flexFlow = 'row';
            graph_wrap.style.position = 'relative';
            graph_wrap.style.alignItems = 'center';
            graph_wrap.style.justifyContent = 'center';
            if (this.graph_donut_diameter === 0) {
                graph_wrap.style.width = '100%';
                graph_wrap.style.height = '100%';
            }

            colNames.forEach(colname => colname.toUpperCase() == "GRAPH" ? graph_wrap.append(this.#createDonutGraph(colname)) : graph_title.append(this.getValuesOfColName(colname)) );

            conts_box.append(graph_title);
            conts_box.append(graph_wrap);

            /**
                * 그래프 뼈대 정의
                */
            let skelDom = this.#createDonutGraphInfoBox();
            conts_box.append(skelDom);

            dom.append(conts_box);

        } catch (e) {
            console.error(e);
        }
        return dom;

    }

    #createDonutCanvas() {

        try {

            let graphs = this.graphElements;
            let graph_limit = this.graph_limit;
            let graphsCount = graphs.length;

            let diameter = this.graph_donut_diameter;
            let wrap = this.graphWrap;
            if (!diameter) {

                let wrapDiameter = Math.min(wrap.offsetWidth, wrap.offsetHeight);
                //if (this.skelDiv)
                //    diameter -= this.skelDiv.offsetWidth;

                diameter = wrapDiameter / graphsCount / 2 - 5;
            }
            wrap.dataset.d = diameter;

            let strokeWidth = this.graph_donut_stroke_width;
            if (!strokeWidth)
                strokeWidth = diameter / 3;
            let keys = this.keys;

            let radius = diameter - strokeWidth;

            if (radius < 0)
                return;

            graphs.forEach(canvas => {
                let colname = canvas.dataset.colname;
                let colTotal = this.getTotalOfColName(colname, graph_limit);
                let accPercentage = 0;
                let startAngle = -Math.PI / 2;

                canvas.width = diameter * 2;
                canvas.height = diameter * 2;

                let ctx = canvas.getContext('2d');
                let keyValues = this.getValuesOfColName(colname);
                keys.forEach((key, idx) => {

                    let val = keyValues[key];
                    if (val && Number(val)) {

                        if (val < 0)
                            val = 0;

                        let color = this.getColorOfKey(key);
                        let calc = this.getCalcOfKey(key)
                        let percentCalc = this.getPercentCalcOfKey(key);
                        let percentage = percentCalc(Number(calc(val, key, idx, colname, this.info)), colTotal);
                        if (Math.abs(percentage) === Infinity)
                            percentage = 0;

                        if (!isNaN(percentage)) {

                            let endAngle = startAngle + (percentage * 2 * Math.PI);

                            ctx.beginPath();
                            ctx.arc(diameter, diameter, radius, startAngle, endAngle);
                            ctx.lineWidth = strokeWidth * 2;
                            ctx.strokeStyle = color;
                            ctx.stroke();

                            accPercentage += percentage;
                            startAngle = endAngle;

                        }
                    }

                });
                
                if (accPercentage < 1 || graph_limit === 0) {
                    let emptyPercent = graph_limit === 0 ? 100 : (colTotal - (accPercentage * colTotal));
                    let endAngle = startAngle + (emptyPercent * 2 * Math.PI);

                    ctx.beginPath();
                    ctx.arc(diameter, diameter, radius, startAngle, endAngle);
                    ctx.lineWidth = strokeWidth * 2;
                    ctx.strokeStyle = '#E9E9E9';
                    ctx.stroke();

                }

                // let clickEvent = this.getClickEventOfKey(key);
                let mouseEvent = (type, e) => {

                    try {
                        let _canvas = e.currentTarget;
                        let ctx = _canvas.getContext('2d');
                        let x = e.offsetX;
                        let y = e.offsetY;
                        let clickColor = ctx.getImageData(x, y, 1, 1).data;
                        let hexCode = rgbToHex([...clickColor]);
                        let key = this.getKeyOfColor(hexCode);

                        if (key) {
                            if (type === 'click') {
                                let func = this.getClickEventOfKey(key);
                                if (typeof func === 'function')
                                    func(e, key, colname, this.info, this);
                            } else if (type === 'move') {
                                let func = this.getMouseMoveEventOfKey(key);
                                if (typeof func === 'function')
                                    func(e, key, colname, this.info, this);
                            }
                        } else if (hexCode === '#FFFFFF' || hexCode === '#000000')
                            if (typeof this.info['graph_white_area_event'] === 'function')
                                this.info['graph_white_area_event'](e);


                    } catch (e) {
                        console.error(e);
                    }
                }

                if (this.hasClickEvent()) {
                    canvas.onclick = (e => {
                        mouseEvent('click', e);
                    }).bind(this);
                }

                if (this.hasMouseMoveEvent()) {
                    canvas.onmousemove = (e => {
                        mouseEvent('move', e);
                    }).bind(this);
                }

            });

        } catch (e) {
            console.error(e);
        }

    }

    /**
        * 하나 생성
        * @param {any} colname
        * @returns
        */
    #createDonutGraph(colname) {

        let dom = document.createDocumentFragment();
        try {

            let div = document.createElement('div');
            div.style.cssText = "width: 100%;height: 100%;position: relative;display: flex;justify-content: center;align-items: center;";

            let donut = document.createElement('canvas');
            donut.classList.add(`graph_item_${this.type}`);
            donut.dataset.colname = colname;

            donut.classList.add('donut_canvas');

            let persentage = document.createElement('div');
            persentage.id = "persentage";
            persentage.classList.add("graph_value");
            div.append(persentage);

            div.append(donut);
            dom.append(div);


        } catch (e) {
            console.error(e);
        }
        return dom;
    }

    /**
        * Donut에 사용되는 InfoBox 생성
        * @returns
        */
    #createDonutGraphInfoBox() {

        let dom = document.createDocumentFragment();
        try {

            if (this.graph_info_view) {

                let keys = this.keys;
                let skelDiv = document.createElement('div');
                skelDiv.classList.add('all');

                let detailDiv = document.createElement('div');
                detailDiv.classList.add('detail');

                keys.forEach(key => {
                    if (this.isDoNotDisplayOfKey(key)) {
                        let color = this.getColorOfKey(key);
                        let viewText = this.getViewTextOfKey(key);
                        let subCalc = this.getSubCalcOfKey(key);
                        let div = document.createElement('div');
                        let html = `<span>${viewText}</span>`;
                        if (key == "totalLimit") {
                            html = `${html}<input id="setListCostInput" type="text" autocomplete="off" style="display:none;" />`
                        }
                        html = `${html}<span id="${key}">${subCalc(key, this.info)}</span>`;
                        
                        div.insertAdjacentHTML('beforeend', html);
                        detailDiv.append(div);

                    }

                });

                skelDiv.append(detailDiv);

                dom.append(skelDiv);

                if (this.graph_donut_button) {
                    let setbutton = document.createElement('button');
                    setbutton.classList.add('btn34_text');
                    setbutton.type = "button";
                    setbutton.id = "setLimt";
                    setbutton.textContent = "제한금액 재설정";
                    setbutton.style.display = "";
                    setbutton.onclick = (e => {
                        setLimitCost(e);
                    }).bind(this);

                    let savebutton = document.createElement('button');
                    savebutton.classList.add('btn34_text');
                    savebutton.type = "button";
                    savebutton.id = "saveLimt";
                    savebutton.textContent = "저장";
                    savebutton.style.display = "none";
                    savebutton.onclick = (e => {
                        saveLimitCost(e);
                    }).bind(this);

                    dom.append(setbutton);
                    dom.append(savebutton);

                }
            }

        } catch (e) {
            console.error(e);
        }
        return dom;
    }

    /**
        * 막대형 그래프 생성
        */
    #createLines() {

        let dom = document.createDocumentFragment();
        try {


            let colNames = this.colnames;

            let conts_box = document.createElement('div');
            conts_box.classList.add('conts_box');
            conts_box.classList.add('weekwork_graph');
            conts_box.classList.add('aiUsage');
            conts_box.style.cssText = 'display: flex;flex-flow: column;justify-content: center;align-items: center;width:100%;height:100%;';
            // 그래프 정보 생성
            conts_box.append(this.#createLineGraphInfoBox());

            let vertical_chart_box = document.createElement('div');
            vertical_chart_box.classList.add('vertical_chart_box');
            vertical_chart_box.style.width = '100%';
            vertical_chart_box.style.height = '100%';
            vertical_chart_box.style.display = 'flex';
            vertical_chart_box.style.visibility = 'hidden';
            conts_box.append(vertical_chart_box);

            // 그래프 생성
            let chart_box = document.createElement('div');
            chart_box.classList.add('chart_box');
            chart_box.style.display = 'flex';
            chart_box.style.width = '100%';
            /*chart_box.style.height = '100%';*/
            chart_box.style.height = `${this.graph_line_height}px`;
            vertical_chart_box.append(chart_box);

            // Y축 표시 줄 생성
            chart_box.append(this.#createLineYTextItem());

            // X축 및 막대 그래프 생성
            let axis_x = document.createElement('ul');
            axis_x.classList.add('axis_x');
            axis_x.classList.add('graph_wrap');
            axis_x.style.width = '100%';
            chart_box.append(axis_x);

            // Y축 구분 선 생성
            axis_x.append(this.#createLineYGubun());

            // let cNum = Array.from(axis_x.querySelectorAll('span.y_span')).length / 2;
            let cNum = 0;

            colNames.forEach(colname => axis_x.append(this.#createLineGraph(colname, cNum)));


            dom.append(conts_box);

        } catch (e) {
            console.error(e);
        }
        return dom;
    }

    /**
        * 막대형 그래프 정보
        */
    #createLineGraphInfoBox() {

        let dom = document.createDocumentFragment();
        try {
            if (this.graph_info_view) {
                let keys = this.keys;
                let graph_detail = document.createElement('ul');
                graph_detail.classList.add('graph_detail');
                graph_detail.style.width = '100%';

                keys.forEach(key => {

                    if (this.isDoNotDisplayOfKey(key)) {

                        let color = this.getColorOfKey(key);
                        let viewText = this.getViewTextOfKey(key);
                        let subCalc = this.getSubCalcOfKey(key);
                        let html = `<span class="color" style="background:${color}"></span><span>${viewText}${subCalc(key, this.info)}</span> `;

                        let li = document.createElement('li');
                        li.classList.add('ltem');
                        li.insertAdjacentHTML('beforeend', html);

                        graph_detail.append(li);

                    }

                });

                dom.append(graph_detail);

            }
        } catch (e) {
            console.error(e);
        }
        return dom;
    }

    /**
        * Y축 표시 라인 생성
        */
    #createLineYTextItem() {

        let dom = document.createDocumentFragment();

        try {

            let axis_y = document.createElement('ul');
            axis_y.classList.add('axis_y');
            axis_y.style.height = '100%';

            let viewTextFunc = this.graph_dot_view_fun;

            let createLi = () => {

                let li = document.createElement('li');
                li.classList.add('item');
                li.style.position = 'absolute';
                li.style.height = '1px';
                li.style.left = '0';
                return li;

            }

            if (this.graph_line_units_fixed.length === 0) {

                if (this.graph_line_unit > 0) {

                    let lineCount = Math.ceil(this.graph_limit / this.graph_line_unit) // 라인 생성 갯수
                    let percent = 100 / lineCount;

                    for (let i = 0; i < lineCount; i++) {

                        if ((i + 1) % 2 === 0) {

                            let li = createLi();
                            li.style.bottom = `${percent * (i + 1)}%`;
                            let html = `<span class="text" style="position: absolute;bottom: calc(100% - 10px);">${viewTextFunc(((i + 1) * this.graph_line_unit), li)}</span>`;
                            li.insertAdjacentHTML('beforeend', html);

                            axis_y.append(li);
                        }
                    }
                }

            } else {

                this.graph_line_units_fixed.forEach(num => {

                    let val = (num / this.graph_limit * 100);

                    let li = createLi();
                    li.style.bottom = `${val}%`;
                    let html = `<span class="text" style="position: absolute;bottom: calc(100% - 10px);">${viewTextFunc(num, li)}</span>`;
                    li.insertAdjacentHTML('beforeend', html);

                    axis_y.append(li);

                });

            }

            dom.append(axis_y);


        } catch (e) {
            console.error(e);
        }
        return dom;
    }

    /**
        * Y축 기준 칸 구분 선 생성
        */
    #createLineYGubun() {

        let dom = document.createDocumentFragment();

        try {

            let graph_line = document.createElement('li');
            graph_line.classList.add('graph_line');
            dom.append(graph_line);

            if (this.graph_line_units_fixed.length === 0) {

                if (this.graph_line_unit > 0) {

                    let lineCount = Math.ceil(this.graph_limit / this.graph_line_unit);
                    let percent = 100 / lineCount;
                    for (let i = 0; i < lineCount; i++) {
                        let span = document.createElement('span');
                        span.classList.add('y_span');
                        span.style.cssText = `display:inline-block; width:100%; height:1px; background-color: #ddd; position:absolute; bottom:${percent * (i + 1)}%; left:0;`;
                        graph_line.append(span);
                    }

                }
            } else {

                this.graph_line_units_fixed.forEach(num => {

                    let val = (num / this.graph_limit * 100);
                    let span = document.createElement('span');
                    span.classList.add('y_span');
                    span.style.cssText = `display:inline-block; width:100%; height:1px; background-color: #ddd; position:absolute; bottom:${val}%; left:0;`;
                    graph_line.append(span);

                });

            }

        } catch (e) {
            console.error(e);
        }
        return dom;

    }


    /**
        * 막대 그래프 하나 생성
        */
    #createLineGraph(colname, correctionNum = 0) {

        let dom = document.createDocumentFragment();
        try {

            let li = document.createElement('li');
            li.classList.add('item');
            li.classList.add(`graph_item_${this.type}`);
            li.dataset.colname = colname;

            let colViewText = this.getViewTextOfColName(colname);

            let textHtml = `<strong class="day">${colViewText}</strong>`
            let text_box = document.createElement('div');
            text_box.classList.add('text_box');
            text_box.insertAdjacentHTML('beforeend', textHtml);
            li.append(text_box);

            let graph = document.createElement('div');
            graph.classList.add('graph');
            graph.style.cursor = 'pointer';
            graph.style.background = 'unset';
            li.append(graph);

            let graph_limit = this.graph_limit;
            let keyValues = this.getValuesOfColName(colname);

            let accPercent = 0;

            Object.keys(keyValues).forEach((key, idx) => {

                let color = this.getColorOfKey(key);
                let calc = this.getCalcOfKey(key);
                let percentCalc = this.getPercentCalcOfKey(key);

                let span = document.createElement('span');
                span.classList.add('time');
                span.style.background = color;
                span.style.zIndex = idx + 1;

                let val = keyValues[key];

                if (typeof calc === 'function')
                    val = calc(val, key, idx, colname, this.info);

                val = percentCalc(val, graph_limit, true);

                accPercent += val;

                if (accPercent > 100) {
                    let bottom = 100 - Math.abs(100 - (accPercent - val));
                    span.style.position = 'absolute';
                    span.style.bottom = `${bottom}%`;
                }

                span.style.height = !correctionNum ? `${val}%` : `calc(${val}% + ${ correctionNum}px)`;
                span.style.paddingTop = '0';
                graph.append(span);

            });

            let mouseEvent = (type, e) => {

                try {

                    let target = e.target;
                    if (target.classList.contains('time')) {

                        let hexCode = rgbToHex(target.style.backgroundColor);
                        if (hexCode) {
                            let key = this.getKeyOfColor(hexCode);
                            if (key) {
                                if (type === 'click') {
                                    let func = this.getClickEventOfKey(key);
                                    if (typeof func === 'function')
                                        func(e, key, colname, this.info, this);
                                } else if (type === 'move') {
                                    let func = this.getMouseMoveEventOfKey(key);
                                    if (typeof func === 'function')
                                        func(e, key, colname, this.info, this);
                                }
                            } else if (hexCode === '#FFFFFF' || hexCode === '#000000')
                                if (typeof this.info['graph_white_area_event'] === 'function')
                                    this.info['graph_white_area_event'](e);
                        }
                    }

                } catch (e) {
                    console.error(e);
                }

            }

            if (this.hasClickEvent()) {
                graph.onclick = (e => {
                    mouseEvent('click', e);
                }).bind(this);
            }

            if (this.hasMouseMoveEvent()) {
                graph.onmousemove = (e => {
                    mouseEvent('click', e);
                }).bind(this);
            }

            dom.append(li);

        } catch (e) {
            console.error(e);
        }

        return dom;
    }

    /**
        * x축 막대 그래프
        */
    #createXLine() {
        let dom = document.createDocumentFragment();
        try {

            let colNames = this.colnames;

            let conts_box = document.createElement('div');
            conts_box.classList.add('conts_box');
            conts_box.style.cssText = 'display: flex;flex-flow: column;justify-content: center;align-items: center;width:100%;height:100%;';
            dom.append(conts_box);

            let graph_wrap = document.createElement('div');
            graph_wrap.classList.add('graph_wrap');
            graph_wrap.style.width = '100%';
            conts_box.append(graph_wrap);

            colNames.forEach(colname => graph_wrap.append(this.#createXLineGraph(colname)));
            graph_wrap.append(this.#createXLineGraphInfoBox());

        } catch (e) {
            console.error(e);
        }
        return dom;
    }

    /**
        * x축 막대 그래프 하나 생성
        * @param {any} colname
        * @returns
        */
    #createXLineGraph(colname) {

        let dom = document.createDocumentFragment();
        try {

            let graph = document.createElement('div');
            graph.classList.add('graph');
            graph.classList.add(`graph_item_${this.type}`);
            graph.style.margin = 'margin: 40px 15px 10px;';
            dom.append(graph);

            let bar = document.createElement('bar');
            bar.classList.add('bar');
            bar.style.cssText = 'position:relative;width:100%; display:inline-block; background-color: #E0E7F2; border-radius: 10px; height: 20px;'
            graph.append(bar);

            let charge = document.createElement('div');
            charge.classList.add('charge')
            charge.style.cssText = 'width:100%;height:100%;overflow:hidden;display:inline-block;position:absolute;border-radius: 20px;';
            bar.append(charge);

            let graph_limit = this.graph_limit;
            let keyValues = this.getValuesOfColName(colname);

            let keys = Object.keys(keyValues);
            keys.forEach((key, idx) => {

                let color = this.getColorOfKey(key);
                let calc = this.getCalcOfKey(key);
                let percentCalc = this.getPercentCalcOfKey(key);

                let span = document.createElement('span');
                span.classList.add('xline_time');
                span.style.display = 'inline-block';
                span.style.float = 'left';
                span.style.height = '100%'
                span.style.background = color;

                let val = keyValues[key];

                if (typeof calc === 'function')
                    val = calc(val, key, idx, colname, this.info);

                val = percentCalc(val, graph_limit, true);

                span.style.width = val ? `calc(${val}% + 15px)` : '0%';

                charge.append(span);

            });

            bar.append(this.#createXLineGubun());

            let mouseEvent = (type, e) => {

                try {

                    let target = e.target;
                    if (target.classList.contains('xline_time')) {

                        let hexCode = rgbToHex(target.style.backgroundColor);
                        if (hexCode) {
                            let key = this.getKeyOfColor(hexCode);
                            if (key) {
                                if (type === 'click') {
                                    let func = this.getClickEventOfKey(key);
                                    if (typeof func === 'function')
                                        func(e, key, colname, this.info, this);
                                } else if (type === 'move') {
                                    let func = this.getMouseMoveEventOfKey(key);
                                    if (typeof func === 'function')
                                        func(e, key, colname, this.info, this);
                                }
                            } else if (hexCode === '#FFFFFF' || hexCode === '#000000')
                                if (typeof this.info['graph_white_area_event'] === 'function')
                                    this.info['graph_white_area_event'](e);
                        }
                    }

                } catch (e) {
                    console.error(e);
                }

            }

            if (this.hasClickEvent()) {
                graph.onclick = (e => {
                    mouseEvent('click', e);
                }).bind(this);
            }

            if (this.hasMouseMoveEvent()) {
                graph.onmousemove = (e => {
                    mouseEvent('click', e);
                }).bind(this);
            }

        } catch (e) {
            console.error(e);
        }
        return dom;
    }

    /**
        * x축 막대 구분 처리
        */
    #createXLineGubun() {

        let dom = document.createDocumentFragment();
        try {
            let viewTextFunc = this.graph_dot_view_fun;

            let createDiv = () => {
                let div = document.createElement('div');
                div.classList.add('dot_div');
                div.style.bottom = 'calc(100% + 15px)';
                return div;
            };

            // 2024-08-09 BJH : #143558 이미 만들어진것들 체크
            let createDivArray = [];
            let locationCalcFun = (num, el, beforeEls) => {
                
                    // 2024-08-09 BJH : #143558 이미 만들어진것들 체크 후 이전것과 비교해서 겹칠 경우 보정 처리
                    let dotTop = 30;
                    let dotHeight = 'calc(100% + 7.5px)';
                    let currentTextBottom = '0';
                    let currentTotalTimeText = totalMinuteConvertTime(num, false, 'H', 'M', false);

                    if(beforeEls.length > 0) {

                        let prevEl = beforeEls.reverse()[0];
                        let currentLeft = pxToNum(el.style.left);
                        let prevLeft = pxToNum(prevEl.style.left);
                        let prev_totaltime_text_wrap = prevEl.querySelector('.totaltime_text_wrap');
                        let prevTotalTimeText = prev_totaltime_text_wrap.querySelector('.totaltiem_text_span').innerText;

                        if(prev_totaltime_text_wrap) {
                            let prevTextLen = prevTotalTimeText.length;
                            let curTextLen = currentTotalTimeText.length;
                            let textLen = curTextLen + prevTextLen;
                            let predicateNum = 0;
                            
                            if(textLen === 6)
                                predicateNum = 4.3
                            else if(textLen === 10)
                                predicateNum = 5.3
                            else if(textLen === 14)
                                predicateNum = 7.3

                            if(Math.abs(currentLeft - prevLeft) <= predicateNum)
                            {
                                let prev_border_dot = prevEl.querySelector('.border_dot');
                                if(prev_border_dot) {
                                    dotTop = pxToNum(prev_border_dot.style.top) - 20;
                                    dotHeight = prev_border_dot.style.height.replace(')', ' + 20px)');
                                }
  
                                if(prev_totaltime_text_wrap.style.bottom === '0')
                                    currentTextBottom = '20px';
                                else 
                                    currentTextBottom = `${(pxToNum(prev_totaltime_text_wrap.style.bottom) + 20)}px`;
         
                            }
                        }
                    }

                    let border_dot = `<span class="border_dot" style="width:1px;height: ${dotHeight};border-right: 0.5px dashed;position: absolute;top:${dotTop}px;left:50%;"></span>`;
                    let html = `
                        <span class="time" style="cursor:pointer;">
                            <span class="totaltime_text_wrap" style="position:relative;width:1px;display:inline-flex;justify-content: center;bottom:${currentTextBottom};">
                                <span class="totaltiem_text_span" style="position: absolute;top: -15px;white-space: nowrap;">${currentTotalTimeText}</span>
                            </span>
                            ${border_dot}
                        </span>
                    `;
                                
                    el.insertAdjacentHTML('beforeend', html);

            }

            if (this.graph_line_units_fixed.length === 0) {

                if (this.graph_line_unit > 0) {

                    let lineCount = Math.ceil(this.graph_limit / this.graph_line_unit) // 라인 생성 갯수
                    let percent = 100 / lineCount;

                    for (let i = 0; i < lineCount; i++) {

                        if ((i + 1) % 2 === 0) {

                            let num = ((i + 1) * this.graph_line_unit);

                            let div = createDiv();
                            div.style.left = `${percent * (i + 1)}%`;

                            locationCalcFun(num, div, [...createDivArray]);

                            let html = viewTextFunc(num, div, [...createDivArray]);

                            if(typeof html !== 'undefined') {
                                if(typeof html === 'string')
                                    div.insertAdjacentHTML('beforeend', html);
                                else if(typeof html.innerHTML !== 'undefined')
                                    div.append(html);
                            }
                            
                            createDivArray.push(div);
                            dom.append(div);
                        }
                    }

                }

            } else {

                this.graph_line_units_fixed.forEach(num => {

                    let percent = (num / this.graph_limit * 100);

                    let div = createDiv();
                    div.style.left = `${percent}%`;

                    locationCalcFun(num, div, [...createDivArray]);

                    let html = viewTextFunc(num, div, [...createDivArray]);

                    if(typeof html !== 'undefined') {
                        if(typeof html === 'string')
                            div.insertAdjacentHTML('beforeend', html);
                        else if(typeof html.innerHTML !== 'undefined')
                            div.append(html);
                    }
                            
                    createDivArray.push(div);
                    dom.append(div);

                });

            }


        } catch (e) {
            console.error(e);
        }
        return dom;
    }

    /**
        * x축 막대 그래프 정보 박스
        * @returns
        */
    #createXLineGraphInfoBox() {

        let dom = document.createDocumentFragment();
        try {
            if (this.graph_info_view) {
                let keys = this.keys;
                let graph_detail = document.createElement('div');
                graph_detail.classList.add('graph_detail');
                graph_detail.style.width = '100%';

                keys.forEach(key => {

                    if (this.isDoNotDisplayOfKey(key)) {

                        let color = this.getColorOfKey(key);
                        let viewText = this.getViewTextOfKey(key);
                        let subCalc = this.getSubCalcOfKey(key);
                        let html = `<span class="color" style="background:${color};display:inline-block; width:8px; height: 8px; border-radius:8px; margin-right:5px;"></span>`;
                        html += `<span>${viewText}${subCalc(key, this.info)}</span>`;

                        let span = document.createElement('span');
                        span.style.cssText = 'margin-right: 20px;';
                        span.insertAdjacentHTML('beforeend', html);

                        graph_detail.append(span);

                    }

                });

                dom.append(graph_detail);

            }
        } catch (e) {
            console.error(e);
        }
        return dom;
    }

    redraw(appendTarget, callback) {

        try {

            if (!this.drawing) {
                if (appendTarget)
                    this.#appendCont = appendTarget;

                this.appendContainer.innerHTML = '';
                this.draw(this.type, this.#appendCont, this.info, callback);
            }


        } catch (e) {
            console.error(e);
        }

    }

    constructor(type, info, appendTarget) {
        this.type = type || 'donut';
        this.info = info || {};
        this.#appendCont = appendTarget;
    }


}


/**
 * 랜덤 컬러
 * @returns
 */
function getRandomColor() {
    let letters = '0123456789ABCDEF';
    let color = '#';
    for (let i = 0; i < 6; i++) {
        // 2024-08-13 BJH : 보안 처리 249749
        let num = Math.floor(self.crypto.getRandomValues(new Uint32Array(1))[0] * Math.pow(2, -32) * 16);
        color += letters[num];
    }
    return color;
}

/**
 * rgb => Hex
 * @param {any} target
 * @returns
 */
function rgbToHex(target) {

    let res = '';
    try {

        let str = '';
        let hexpair = v => `${v < 16 ? '0' : ''}${v.toString(16)}`;

        if (typeof target === 'object') {
            if (typeof target.style !== 'undefined') {
                str = target.style.backgroundColor
            } else if (Array.isArray(target)) {
                res = `#${hexpair(target[0])}${hexpair(target[1])}${hexpair(target[2])}`.toUpperCase();
            }
        } else if (typeof target === 'string')
            str = target;

        if (str.indexOf('#') === 0)
            return str;
        else if (str.toLowerCase().indexOf('rgb') > -1) {

            let rgb = str.split(',').map(val => Number(val.replace(/[^0-9]/g, '')));

            res = `#${hexpair(rgb[0])}${hexpair(rgb[1])}${hexpair(rgb[2])}`.toUpperCase();
        }


    } catch (e) {
        console.error(e);
    }
    return res;
}