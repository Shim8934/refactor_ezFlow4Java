/** new ui 전용 페이지네이션 */
class Pagination {
    /** 페이지 당 가져오기 개수 기본값 */
    static #DEFAULT_FETCH_SIZE = 10;

    #page = 1;
    #fetchSize = Pagination.#DEFAULT_FETCH_SIZE;
    /** @type number */
    #totalCount = undefined;
    /** @type number */
    #totalPage = undefined;

    /** 단 하나의 페이지 번호만 input으로 입력받을 수 있는 축소된 모드 활성화 여부 */
    #isActiveMinimalMode = true;

    /** 이벤트 리스너 */
    #eventListeners = {
        /** 페이지네이션을 통해 수동으로 전환했을 때 발생하는 이벤트 리스너
         * @type array<function> */
        pageChange: []
    }

    /** 페이지네이션이 들어갈 위치의 Element를 구하는 Promise
     * @type Promise<Element> */
    #targetElementPromise;

    /**
     * @constructor
     * @param {string} targetSelector 페이지네이션이 들어갈 위치의 Element css selector
     */
    constructor(targetSelector) {
        // 아직 dom 로드가 다 안 돼서 Element가 구해지지 않을 경우를 대비해 load 될 때 까지 기다리는 Promise
        this.#targetElementPromise = document.readyState === "complete"
            ? Promise.resolve(document.querySelector(targetSelector))
            : new Promise(resolve => {
                window.addEventListener("DOMContentLoaded", () => resolve(document.querySelector(targetSelector)));
            });
    }

    /** (미구현 상태, 기본으로 true임) 축소 모드를 활성화/비활성화 합니다.
     * @param {boolean} val 활성화 여부
     * @throws
     * @todo 추후 필요시 구현
     * @deprecated 추후 필요시 구현 */
    set activeMinimalMode(val) {
        throw "not supported yet";
        // this.isActiveMinimalMode = val;
    }

    /**
     * 페이지를 설정합니다.
     * @param {number} num
     */
    set page(num) {
        this.#page = Math.max(1, Math.min(num, this.#totalPage || 1));
        this.#draw();
    }

    /**
     * 페이지 당 가져오기 개수를 설정합니다.
     * @param {number} num
     */
    set fetchSize(num) {
        this.#fetchSize = num;
        this.#draw();
    }

    /**
     * 현재 페이지네이션을 구성하는 목록의 총 개수를 설정합니다.
     * @param {number} num
     */
    set totalCount(num) {
        this.#totalCount = num;
        this.#draw();
    }

    get page() {
        return this.#page;
    }

    get fetchSize() {
        return this.#fetchSize;
    }

    get totalCount() {
        return this.#totalCount;
    }

    /** @return number */
    get startOffset() {
        return (this.#fetchSize * (this.#page - 1));
    }

    get totalPage() {
        return this.#totalPage;
    }

    /** @param {function} func */
    addPageChangeEventListener(func) {
        this.#eventListeners.pageChange.push(func);
    }

    #triggerChangeEvent() {
        for (const listener of this.#eventListeners.pageChange) {
            listener();
        }
    }

    /**
     * 현재 설정된 값으로 페이지네이션을 HTML로 구성해서 적용합니다.
     */
    #draw() {
        // 리스트 총 개수가 설정되지 않았으면 페이지네이션 생성 보류
        if (this.#totalCount === undefined) {
            return;
        }

        // 최대 페이지 계산
        this.#totalPage = Math.max(~~(this.#totalCount / this.#fetchSize), 1);

        if (this.#totalPage * this.#fetchSize < this.#totalCount) {
            this.#totalPage++;
        }

        // 최대 페이지를 초과하지 않도록 조정
        this.#page = Math.min(this.#page, this.#totalPage);

        // 페이지네이션 Element 업데이트
        if (this.#isActiveMinimalMode) {
            this.#drawMinimal();
        } else {
            this.#drawFull();
        }
    }

    #drawMinimal() {
        // 페이지네이션 targetElement가 구해질 때 까지 대기
        this.#targetElementPromise.then(targetElem => {
            if (targetElem.querySelector(".listview-nav")) {
                targetElem.querySelector("input").value = this.#page;
                targetElem.querySelector(".page-num > span").textContent = this.#totalPage;
                return;
            }

            // first initial
            targetElem.innerHTML = `
                    <div class="listview-nav">
                        <a href="javascript:void(0);" class="prev blind">prev</a>
                        <span class="page-num">
                            <em class="input_wrap"><input type="text" value="${this.#page}"></em>&nbsp;/&nbsp;<span>${this.#totalPage}</span>
                        </span>
                        <a href="javascript:void(0);" class="next blind">next</a>
                    </div>
                `;
            targetElem.querySelector("a.prev").addEventListener("click", () => this.#setPageManually(this.page - 1));
            targetElem.querySelector("a.next").addEventListener("click", () => this.#setPageManually(this.page + 1));

            const input = targetElem.querySelector("input");
            inputUtil.makeNotAllowTyping(input, /\D/g);
            inputUtil.addOnEnterEvent(input, e => this.#setPageManually(e.target.value ? parseInt(e.target.value) : this.page));
        });
    }

    /** @todo 이후 구현할 일이 있으면 사용, 표준은 #drawMinimalHtml을 사용함 */
    #drawFull() {
    }

    /**
     * 페이지네이션을 통해 수동으로 전환할 때 사용, 이 때 이벤트를 트리거함
     * @param {number} num
     */
    #setPageManually(num) {
        const previousPage = this.page;
        this.page = num;

        if (previousPage !== this.page) {
            this.#triggerChangeEvent();
        }
    }

}