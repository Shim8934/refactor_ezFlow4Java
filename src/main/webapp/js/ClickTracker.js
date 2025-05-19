/**
 * 웹페이지 클릭 이벤트 추적
 */
(function(window) {
  'use strict';

  var defaultConfig = {
    trackIds: true,            // ID 추적 여부
    trackClasses: true,        // 클래스 추적 여부
    trackLinks: true,          // 링크 추적 여부
    trackText: true,           // 텍스트 내용 추적 여부
    trackPath: true,          // DOM 경로 추적 여부
    debounceTime: 300,         // 디바운스 시간(ms)
    apiEndpoint: '/api/track', // 데이터 전송 API 엔드포인트
    consoleLog: true,         // 콘솔에 출력 여부
    dataset: [],              // 수집 데이터
    targets: [],                 // 추적할 dom 선택자 목록
    exclude: []       // 추적에서 제외할 선택자 목록
  };

  function ClickTracker() {
    this.isActive = false;
    this.clickBuffer = [];
    this.config = defaultConfig;

    this._clickHandler = this._clickHandler.bind(this);
    this._debouncedSend = this._debounce(this._sendData, this.config.debounceTime);
  }

  ClickTracker.prototype = {
    start: function() {
      if (!this.isActive) {
        document.addEventListener('click', this._clickHandler, true);
        this.isActive = true;
        if (this.config.consoleLog) {
          console.log('ClickTracker: 추적 시작됨');
        }
      }
      return this;
    },
    stop: function() {
      if (this.isActive) {
        document.removeEventListener('click', this._clickHandler, true);
        this.isActive = false;
        if (this.config.consoleLog) {
          console.log('ClickTracker: 추적 중지됨');
        }
      }
      return this;
    },
    addTarget: function(selector) {
      this.config.targets.push(selector);
      return this;
    },
    addExclude: function(selector) {
      this.config.exclude.push(selector);
      return this;
    },
    addDataset: function(dataset) {
      this.config.dataset.push(dataset);
      return this;
    },
    updateConfig: function(newConfig) {
      for (var key in newConfig) {
        if (this.config.hasOwnProperty(key)) {
          this.config[key] = newConfig[key];
        }
      }
      return this;
    },
    flush: function() {
      this._sendData();
      return this;
    },

    _clickHandler: function(event) {
      var target = event.target;

      if (!this._isTarget(target)) return;

      // 제외 선택자 확인
      for (var i = 0; i < this.config.exclude.length; i++) {
        if (target.matches(this.config.exclude[i])) {
          return;
        }
      }

      var clickInfo = {
        timestamp: new Date().toISOString(),
        tagName: target.tagName.toLowerCase(),
        url: window.location.href
      };

      if (this.config.trackIds && target.id) {
        clickInfo.id = target.id;
      }

      if (this.config.trackClasses && target.className) {
        clickInfo.className = typeof target.className === 'string' ?
            target.className : Array.from(target.classList).join(' ');
      }

      if (this.config.trackLinks) {
        var link = target.tagName.toLowerCase() === 'a' ? target : target.closest('a');
        if (link && link.href) {
          clickInfo.href = link.href;
        }
      }

      if (this.config.trackText) {
        clickInfo.text = (target.innerText || target.textContent || '').trim().substring(0, 100);
      }

      if (this.config.trackPath) {
        clickInfo.domPath = this._getElementPath(target);
      }

      for (const data of this.config.dataset) {
        clickInfo[data] = target.dataset[data] + ''
      }

      this.clickBuffer.push(clickInfo);

      if (this.config.consoleLog) {
        console.log('ClickTracker:', clickInfo);
      }

      this._debouncedSend();
    },

    _sendData: function() {
      var self = this;

      if (this.clickBuffer.length === 0) {
        return;
      }

      var dataToSend = this.clickBuffer.pop();
      this.clickBuffer = [];

      $.ajax({
        url: '/ezStatistics/clickEvent.do',
        method: 'POST',
        data: JSON.stringify(dataToSend),
        contentType: 'application/json',
        success: function(response) {
          if (self.config.consoleLog) {
            console.log('ClickTracker: 데이터 전송 성공', response);
          }
        },
        error: function(error) {
          console.error('ClickTracker: 데이터 전송 실패', error);
        }
      });
    },

    _debounce: function(func, wait) {
      var timeout;
      var self = this;

      return function() {
        var context = self;
        var args = arguments;

        clearTimeout(timeout);

        timeout = setTimeout(function() {
          func.apply(context, args);
        }, wait);
      };
    },

    _getElementPath: function(element) {
      var path = [];
      while (element && element.nodeType === Node.ELEMENT_NODE) {
        var selector = element.nodeName.toLowerCase();
        if (element.id) {
          selector += '#' + element.id;
          path.unshift(selector);
          break;
        } else {
          var sib = element;
          var nth = 1;
          while (sib = sib.previousElementSibling) {
            if (sib.nodeName.toLowerCase() == selector) {
              nth++;
            }
          }
          if (nth != 1) {
            selector += ":nth-of-type("+nth+")";
          }
        }
        path.unshift(selector);
        element = element.parentNode;
      }
      return path.join(" > ");
    },

    _isTarget: function(element) {
      if (!element) return false;

      for (var i = 0; i < this.config.targets.length; i++) {
        if (element.matches(this.config.targets[i]) || element.closest(this.config.targets[i])) {
          return true;
        }
      }

      return false;
    }
  };

  window.ClickTracker = ClickTracker;
})(window);