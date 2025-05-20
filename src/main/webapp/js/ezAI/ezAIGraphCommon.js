function InitGraph() {
    GetUsageData();
}
// 사용량 조회 API 호출
function GetUsageData() {
    templeteLoading = createLoadingFun('usageInfo');
    templeteLoading(true);
    let xmlpara = createXmlDom();
    let objNode;

    let pProjectID = adminKeyInfo["ProjectID"];

    startDate = getDateTimeFormat("YYYY-MM-01", currentDate);

    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "PROJECTID", pProjectID);
    createNodeAndInsertText(xmlpara, objNode, "STARTDATE", startDate);

    xmlHTTP.open("POST", `${AdminRemoteAppPath}/GetUsageData`, true);
    xmlHTTP.send(xmlpara);
    xmlHTTP.onreadystatechange = GetUsageData_after;
}
function GetUsageData_after() {
    if (xmlHTTP == null || xmlHTTP.readyState != 4) {
        return;
    }

    if ('OK' == xmlHTTP.statusText || 200 == xmlHTTP.status) {
        var data = JSON.parse(HtmlDecode(xmlHTTP.responseText));
        if (data[0] == "ERROR") {
            let graphTarget = document.getElementById("usageInfo");
            if (!graphTarget)
                return;
            let graphController = new GraphDocument('line', null, graphTarget);
            graphController.redraw();
            templeteLoading(false);
            Alert_Message("ERROR", null, "3");
        }
        else {
            MakeLineGraph(data);
            MakeDonutGraph();
        }
    }
}
// 막대 그래프 생성
function MakeLineGraph(data) {
    try {
        totalCostsSum = 0;
        let dateArray = {};
        let modelArray = [];
        let costsArray = [];
        let costSum = [];
        let graph_info = {};

        // Y축 구분 단위
        let unit = 0.02;

        // Y축 표시 최대값
        let graph_limit = 0.5;

        // Y축 표시 함수
        let dot_view_fun = val => `$${val}`;//=> `${Math.ceil(val / unit)}$`;

        // 그래프 크기
        let height = 250;
        // 그래프 값
        let graph_values = {};

        // x축 표시
        let graph_col_views = {};

        // 막대그래프 옵션
        let graph_line_option = {};

        let graphTarget = document.getElementById("usageInfo");
        if (!graphTarget)
            return;

        let graphController = new GraphDocument('line', null, graphTarget);

        // 일자별
        data.forEach((eachDay, dayIdx) => {
            let eachDate = ToStringByFormatting(new Date(eachDay.start_time * 1000));
            eachDay.start_time = eachDate;
            let sumEachDayCost = 0;

            graph_values[eachDate] = {};

            dateArray[eachDate] = {};
            dateArray[eachDate]["date"] = eachDate;
            dateArray[eachDate]["models"] = [];
            // 모델별
            eachDay.results.forEach((eachModel, modelIdx) => {
                let eachModelCost = CostRound(eachModel.amount.value);

                sumEachDayCost = CostRound(sumEachDayCost + eachModelCost);

                if (eachModelCost < 0.001)
                    eachModelCost = "< 0.001";

                graph_values[eachDate][eachModel.line_item] = eachModelCost;

                dateArray[eachDate]["models"][modelIdx] = {};
                dateArray[eachDate]["models"][modelIdx]["name"] = eachModel.line_item;
                dateArray[eachDate]["models"][modelIdx]["cost"] = eachModelCost;

                if (modelArray.includes(eachModel.line_item)) return;

                modelArray.push(eachModel.line_item);
            });
            costSum[dayIdx] = sumEachDayCost;

            dateArray[eachDate]["totalCosts"] = sumEachDayCost < 0.001 ? "< 0.001" : sumEachDayCost;
            totalCostsSum += sumEachDayCost;
            graph_col_views[eachDate] = eachDate.substring(8, 10)
        });

        modelArray.forEach((eachModel) => {
            graph_info[eachModel] = {
                view_text: eachModel
            };
        });

        graph_limit = Math.max(...costSum);
        graph_limit = CostRound(graph_limit * 1.1);

        unit = (graph_limit / 4);

        // 막대그래프 옵션
        graph_line_option = { unit, dot_view_fun, height };

        let info = { graph_line_option, graph_limit, graph_info, graph_values, graph_col_views };
        graphController.info = info;
        graphController.redraw();
        let graph_x_line = document.querySelectorAll("li.graph_item_line");

        let createMouseEvent = (obj) => {
            let lineInfo = dateArray[obj.dataset["colname"]];
            let msg = '';
            if (lineInfo.models.length == 0)
                return;
            msg += `
                        <p class="detail" style="white-space: nowrap;">
                            <span class="txt" style="margin-right:5px;">Total</span>
                            <span>${lineInfo.totalCosts}</span>
                        </p>
                    `;
            lineInfo.models.forEach(modelInfo => {
                let modelColor = graphController.getColorOfKey(modelInfo.name);
                msg += `
                            <p class="detail" style="white-space: nowrap;">
                                <span class="txt" style="margin-right:5px;">
                                    <span class="color" style="background:${modelColor}"></span>
                                    ${modelInfo.name}
                                </span>
                                <span>${modelInfo.cost}</span>
                            </p>
                        `;
            });
            return e => timeSimpleTootipMoveEvent(graphTarget, e.currentTarget, lineInfo["date"], msg, null, true)(e);
        };

        graph_x_line.forEach((eachLine) => {
            eachLine.onmousemove = createMouseEvent(eachLine)
        });

        templeteLoading(false);
    }
    catch (e) {
        templeteLoading(false);
        console.log(e.message);
    }
}
// 원형 그래프 생성
function MakeDonutGraph() {
    try {
        let currentMonth = currentDate.getMonth() + 1;
        let costLimit = adminKeyInfo["Limit"];
        let usedCost = CostRound(totalCostsSum);
        let extraCost = CostRound(costLimit - usedCost);
        //{ useddate, extradate } = { totaldate: 26, useddate: 2, extradate: 24 };
        let graphTarget = document.getElementById("usageInfo2");
        if (!graphTarget)
            return;
        let graphObj = new GraphDocument('donut', {
            graph_info: {
                totalLimit: {
                    view_text: `제한금액`,
                    //color: '#28A960',
                    subfix_calc: (val, info) => `${info['graph_info'][val]['cost']} $`,
                    cost: costLimit
                },
                usedCost: {
                    view_text: `사용금액`,
                    color: '#8AE1D5',
                    subfix_calc: (val, info) => `${info['graph_info'][val]['cost']} $`,
                    cost: usedCost
                },
                extraCost: {
                    view_text: `남은금액`,
                    color: '#F1F1F1',
                    subfix_calc: (val, info) => `${info['graph_info'][val]['cost']} $`,
                    cost: extraCost
                }

            },
            graph_donut_option: {
                diameter: 200,
                stroke_width: 15,
                graph_donut_button: true
            },
            graph_values: { graph: { usedCost, extraCost }, cost: `${currentMonth}월 사용요금` },
            graph_white_area_event: e => {
                let simple_tooltip = graphTarget.querySelector('.simple_tooltip');
                if (simple_tooltip) {
                    simple_tooltip.style.display = 'none';
                }
            }
        }, graphTarget);
        graphObj.redraw();

        // 전체사용량 대비 퍼센트
        let costPersentage = CostRound((usedCost / costLimit) * 100);
        document.getElementById("persentage").innerText = `${costPersentage}%`;
    }
    catch (e) {
        console.log(e.message);
    }
}

//월 이동
function CalendarMove(flag) {
    currentDate = new Date(currentDate.getFullYear(), (flag.toUpperCase() == "PREV" ? currentDate.getMonth() - 1 : currentDate.getMonth() + 1), 1);

    let dateMonth = currentDate.getMonth() + 1;
    if (dateMonth < 10) dateMonth = "0" + dateMonth.toString();

    document.getElementById("currentViewText").innerText = currentDate.getFullYear().toString() + "." + dateMonth;
    GetUsageData();
}

// 사용금액 제한 저장

function setLimitCost() {
    try {
        document.getElementById("setListCostInput").style.display = "";
        document.getElementById("totalLimit").style.display = "none";

        document.getElementById("setLimt").style.display = "none";
        document.getElementById("saveLimt").style.display = "";

        document.getElementById("setListCostInput").value = adminKeyInfo["Limit"];
        document.getElementById("setListCostInput").focus();

    } catch (e) {
        console.error(e);
    }
}
function saveLimitCost() {
    try {
        let limit = Number(document.getElementById("setListCostInput").value);
        if (isNaN(limit) || limit <= 0 || !Number.isInteger(limit)) {
            document.getElementById("setListCostInput").value = adminKeyInfo["Limit"];
            Alert_Message("1 이상의 정수로 입력해 주세요.", null, "3");
            return;
        }

        if (limit < totalCostsSum) {
            document.getElementById("setListCostInput").value = adminKeyInfo["Limit"];
            Alert_Message("실제 사용금액보다 큰 정수로 입력해 주세요", null, "3");
            return;
        }

        document.getElementById("setListCostInput").style.display = "none";
        document.getElementById("totalLimit").style.display = "";

        document.getElementById("setLimt").style.display = "";
        document.getElementById("saveLimt").style.display = "none";
        
        let sendData = {
            CompanyId: adminKeyInfo["CompanyID"],
            ProjectID: adminKeyInfo["ProjectID"],
            Limit: limit
        }
        setApiKeyLimitCost(sendData, result => {
            if (result !== "OK") {
                Alert_Message("저장 중 오류가 발생했습니다.", null, "3");
                return;
            }

            Alert_Message("설정 되었습니다.", null, "2");
            adminKeyInfo["Limit"] = limit;
            MakeDonutGraph();

        });


    } catch (e) {
        console.error(e);
    }
}
function setApiKeyLimitCost(param, callback) {
    let res = 0;
    try {
        let url = `${AdminRemoteAppPath}/UpdateKeyCostLimit`;
        res = postXhr(url, JSON.stringify(param), callback);

    } catch (e) {
        console.error(e);
    }
    return res;
}

/**
 * 메시지 툴팁 이벤트 생성
 * @param {any} appendWrap
 * @param {any} eventTarget
 * @param {any} title
 * @param {any} msg
 * @param {any} posistionCalc
 */
function timeSimpleTootipMoveEvent(appendWrap, eventTarget, title, msg, posistionCalc, bottomFlag) {

    let moveEvnet = e => { };

    try {

        let usageTooltip = appendWrap.querySelector('.usageTooltip');
        if (!usageTooltip) {
            usageTooltip = createSimpleTooltip(appendWrap);
            if (!['relative', 'absolute', 'fixed'].includes(usageTooltip.style.position))
                usageTooltip.style.position = 'relative';
        }
        
        if(bottomFlag) {
            let donut_arrow = usageTooltip.querySelector('.donut_arrow');
            if(donut_arrow) {
                donut_arrow.style.bottom = '-12px';
                donut_arrow.style.top = 'unset';
                donut_arrow.style.transform = 'translateX(-50%) rotate(180deg)';
            }
        }

        let titleTag = usageTooltip.querySelector('.title');
        let msgTag = usageTooltip.querySelector('.msg');

        let leaveEvent = e => {
            eventTarget.init = false;
            let usageTooltip = appendWrap.querySelector('.usageTooltip');
            usageTooltip.style.display = 'none';
            usageTooltip.style.visibility = 'hidden';
            eventTarget.removeEventListener('mouseout', leaveEvent);
            eventTarget.removeEventListener('mouseleave', leaveEvent);
        }

        moveEvnet = e => {

            if (usageTooltip.style.display !== '')
                usageTooltip.style.display = '';

            let scaleFun = (w) => {

                if (titleTag.innerHTML !== title) 
                    titleTag.innerHTML = title;
                
                msgTag.innerHTML = '';
                if (msg) {
                    titleTag.style.marginBottom = '10px';
                    msgTag.insertAdjacentHTML('beforeend', msg);
                }
                else
                    titleTag.style.marginBottom = 0;

                if (typeof posistionCalc !== 'function') {

                    let { top, left } = offset(eventTarget, appendWrap.children[0]);
                    if(!bottomFlag)
                        top += e.offsetY + 20;
                    else {
                        top += e.offsetY - 20;
                        top -= usageTooltip.clientHeight;
                    }
                    
                    left += e.offsetX - w;
                    
                    usageTooltip.style.top = `${top}px`;
                    usageTooltip.style.left = `${left}px`;


                } else
                    posistionCalc(e, w, eventTarget, appendWrap, usageTooltip);

                usageTooltip.style.visibility = '';

            }
            if (!eventTarget.init) {

                setTimeout(() => scaleFun(usageTooltip.clientWidth / 2), 1);

                eventTarget.addEventListener('mouseout', leaveEvent);
                eventTarget.addEventListener('mouseleave', leaveEvent);

            } else
                scaleFun(usageTooltip.clientWidth / 2);

            eventTarget.init = true;

        }


    } catch (e) {
        console.error(e);
    }
    return moveEvnet;
}

/**
 * 심플 툴팁 생성
 * @param {any} appendWrap
 * @param {any} title
 * @param {any} msg
 * @returns
 */
function createSimpleTooltip(appendWrap) {

    let usageTooltip

    try {

        usageTooltip = appendWrap.querySelector('.usageTooltip');

        if (!usageTooltip) {
            usageTooltip = document.createElement('div');
            usageTooltip.classList.add('usageTooltip');
            usageTooltip.style.display = 'none';
            usageTooltip.style.position = 'absolute';
            usageTooltip.style.zIndex = '999';
            usageTooltip.style.visibility = 'hidden';

        }

        let html = `
        <span class="donut_txt" style="min-width: 125px; display:block; top:0; left: 0px;position: relative;">
            <span class="donut_arrow"></span>
            <p class="title"></p>
            <span class="msg"></span>
        </span>
        `;

        usageTooltip.innerHTML = '';
        usageTooltip.insertAdjacentHTML('beforeend', html);
        appendWrap.append(usageTooltip)

    } catch (e) {
        console.error(e);
    }

    return usageTooltip;

}

function offset(elem, stopElement) {
    
    if (!elem) elem = this;

    var x = elem.offsetLeft;
    var y = elem.offsetTop;

    while (elem = elem.offsetParent) {
        
        x += elem.offsetLeft;
        y += elem.offsetTop;

        if ((stopElement && elem === stopElement))
            break;

    }

    return { left: x, top: y };
}
function CostRound(amount) {
    return Math.round((amount) * 1000) / 1000;
}

function ToStringByFormatting(pDate, delimiter = '-') {
    var year = pDate.getFullYear();
    var month = (pDate.getMonth() + 1);
    var day = pDate.getDate();

    if (month < 10) month = "0" + month;
    if (day < 10) day = "0" + day;

    return [year, month, day].join(delimiter);
}


