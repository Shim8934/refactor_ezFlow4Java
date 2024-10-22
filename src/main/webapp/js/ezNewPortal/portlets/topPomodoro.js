new TopTimer();

function TopTimer() {
    var pomoID = 'pomodoro';
    var thisTimer = document.getElementById('pomodoro');

    var STATE = 'state';
    var STATE_PLAY = 'play';
    var STATE_PAUSE = 'pause';
    var STATE_STOP = 'stop';
    var TYPE = 'type';
    var TYPE_WORK = 'time-work';
    var TYPE_BREAK = 'time-break';
    var CHK_CLASS = 'checked';
    var START_TIME = 'startTime';
    var REMAIN_TIME = 'remainTime';

    var areaTimer = thisTimer.getElementsByClassName('timer-container')[0];
    var areaSet = thisTimer.getElementsByClassName('wrap-set-container')[0];

    var timerCircle = thisTimer.getElementsByClassName('timer-circle')[0];
    var timerText = thisTimer.getElementsByClassName('timer-text')[0];
    var endCircle = thisTimer.getElementsByClassName('end-circle')[0];
    var startBtn = thisTimer.getElementsByClassName('start-btn')[0];
    var resumeBtn = thisTimer.getElementsByClassName('resume-btn')[0];
    var pauseBtn = thisTimer.getElementsByClassName('pause-btn')[0];
    var resetBtn = thisTimer.getElementsByClassName('reset-btn')[0];
    var setBtn = thisTimer.getElementsByClassName('setting')[0];

    var workTimeChk = thisTimer.querySelector('.chk-pomodoro[data-type=' + TYPE_WORK + ']');
    var breakTimeChk = thisTimer.querySelector('.chk-pomodoro[data-type=' + TYPE_BREAK + ']');
    var workTimeInput = thisTimer.getElementsByClassName(TYPE_WORK)[0];
    var breakTimeInput = thisTimer.getElementsByClassName(TYPE_BREAK)[0];

    var timeFull = 25 * 60;
    var timeLeft = timeFull;
    var TIME_THICK = 200;
    var timePassed = 0;
    var FULL_DASH_ARRAY = 2 * Math.PI * 45;

    var COLOR_CODES = {
        info: {
            color: "#388CE5"
        },
        warning: {
            color: "#f1ff33",
            threshold: 30
        },
        alert: {
            color: "#FF0000",
            threshold: 10
        }
    };

    function init() {
        var pomodoroCookie = getCookie(pomoID);
        var option = getOption();
        $('.span-work').text(option.portletPomodoroNames[0].focusName);
        $('.span-break').text(option.portletPomodoroNames[0].breakName);
        workTimeInput.innerText = parseInt(option.focusTime) / 60;
        breakTimeInput.innerText = parseInt(option.breakTime) / 60;

        if (!!pomodoroCookie) {
            pomodoroCookie = JSON.parse(pomodoroCookie);
            var state = pomodoroCookie[STATE];
            if (state !== STATE_STOP) {
                var type = pomodoroCookie[TYPE];
                var isChkWork = type === TYPE_WORK;
                var isChkBreak = type === TYPE_BREAK;
                thisTimer.setAttribute('data-type', isChkWork ? TYPE_WORK : isChkBreak ? TYPE_BREAK : '');
                var duration = isChkWork ? pomodoroCookie[TYPE_WORK] : isChkBreak ? pomodoroCookie[TYPE_BREAK] : 0;
                var remain = pomodoroCookie[REMAIN_TIME];
                timeFull = parseInt(duration) / 1000;
                timeLeft = Math.floor(parseInt(remain) / 1000);
                timePassed = timeFull - timeLeft;
                if (state === STATE_PLAY) {
                    thisTimer.setAttribute('data-status', STATE_PLAY);
                    setCookie(pomoID, JSON.stringify(pomodoroCookie), 24);
                    setTimeout(updateTimer, TIME_THICK);
                } else if (state === STATE_PAUSE) {
                    thisTimer.setAttribute('data-status', STATE_PAUSE);
                    setTimerShape();
                }
            } else {
                thisTimer.setAttribute('data-status', STATE_STOP);
                resetTimer();
            }
        } else {
            thisTimer.setAttribute('data-status', STATE_STOP);
            resetTimer();
        }
        chkNotificationPermission();
        $("#floatingPomo").draggable();
    }

    function formatTime(time) {
        var minutes = Math.floor(time / 60);
        var seconds = time % 60;

        if (minutes < 10) {
            minutes = '0' + minutes;
        }
        if (seconds < 10) {
            seconds = '0' + seconds;
        }

        return minutes + ':' + seconds;
    }

    function setRemainingPathColor() {
        var alert = COLOR_CODES.alert;
        var warning = COLOR_CODES.warning;
        var info = COLOR_CODES.info;
        if (timeLeft > warning.threshold) {
            timerCircle.style.stroke = info.color;
            endCircle.style.stroke = info.color;
            timerText.setAttribute('fill', '');
        } else if (timeLeft > alert.threshold) {
            timerCircle.style.stroke = warning.color;
            endCircle.style.stroke = warning.color;
            timerText.setAttribute('fill', warning.color);
        } else {
            timerCircle.style.stroke = alert.color;
            endCircle.style.stroke = alert.color;
            timerText.setAttribute('fill', alert.color);
        }
    }

    function calculateTimeFraction() {
        if (timeFull === 0) return 0;
        var rawTimeFraction = timeLeft / (timeFull);
        return rawTimeFraction - (1 / (timeFull)) * (1 - rawTimeFraction);
    }

    function setCircleDasharray() {
        timerCircle.setAttribute("stroke-dasharray", (
            calculateTimeFraction() * FULL_DASH_ARRAY
        ) + ' ' + FULL_DASH_ARRAY);
    }

    function setPomodoroCookie(status) {
        var pomodoroCookie = {};
        pomodoroCookie[TYPE_WORK] = 0;
        pomodoroCookie[TYPE_BREAK] = 0;
        pomodoroCookie[REMAIN_TIME] = timeLeft * 1000;
        pomodoroCookie[TYPE] = '';

        if (breakTimeChk.getAttribute('class').indexOf(CHK_CLASS) > -1) {
            pomodoroCookie[TYPE_BREAK] = parseInt(breakTimeInput.innerText) * 60 * 1000;
            pomodoroCookie[TYPE] = TYPE_BREAK;
        }

        if (workTimeChk.getAttribute('class').indexOf(CHK_CLASS) > -1) {
            pomodoroCookie[TYPE_WORK] = parseInt(workTimeInput.innerText) * 60 * 1000;
            pomodoroCookie[TYPE] = TYPE_WORK;
        }

        pomodoroCookie[STATE] = status;
        thisTimer.setAttribute('data-status', status);
        pomodoroCookie[START_TIME] = new Date().getTime();

        setCookie(pomoID, JSON.stringify(pomodoroCookie), 24);
        return pomodoroCookie;
    }

    function changeStatusCookie(status) {
        var pomodoroCookie = JSON.parse(getCookie(pomoID));
        if (!pomodoroCookie) pomodoroCookie = setPomodoroCookie(status);
        pomodoroCookie[STATE] = status;
        thisTimer.setAttribute('data-status', status);
        setCookie(pomoID, JSON.stringify(pomodoroCookie), 24);
    }

    function startTimer() {
        resetTimer();
        changeStatusCookie(STATE_PLAY);
        setTimeout(updateTimer, TIME_THICK);
    }

    function resumeTimer() {
        var pomodoroCookie = getCookie(pomoID);
        if (!pomodoroCookie) return;

        pomodoroCookie = JSON.parse(pomodoroCookie);
        if (pomodoroCookie[STATE] !== STATE_PAUSE) return;

        var type = pomodoroCookie[TYPE];
        var duration = type === TYPE_WORK ? pomodoroCookie[TYPE_WORK] : type === TYPE_BREAK ? pomodoroCookie[TYPE_BREAK] : 0;
        var remain = pomodoroCookie[REMAIN_TIME];
        pomodoroCookie[START_TIME] = new Date().getTime() + remain - duration;
        pomodoroCookie[STATE] = STATE_PLAY;
        thisTimer.setAttribute('data-status', STATE_PLAY);

        setCookie(pomoID, JSON.stringify(pomodoroCookie), 24);

        setTimeout(updateTimer, TIME_THICK);
    }

    function pauseTimer() {
        updateTimer(true);
    }

    function updateTimer(isPause) {
        var pomodoroCookie = getCookie(pomoID);
        if (!!pomodoroCookie) {
            pomodoroCookie = JSON.parse(pomodoroCookie);
        } else {
            console.log('wrong pomodoroCookie');
            return;
        }

        if (pomodoroCookie[STATE] !== STATE_PLAY) return;

        var start = pomodoroCookie[START_TIME];
        var type = pomodoroCookie[TYPE];
        var duration = type === TYPE_WORK ? pomodoroCookie[TYPE_WORK] : type === TYPE_BREAK ? pomodoroCookie[TYPE_BREAK] : 0;
        var microLeft = start + duration - new Date().getTime();
        timeLeft = Math.floor(microLeft / 1000);
        timePassed = timeFull - timeLeft;
        setTimerShape();

        if (microLeft <= 0) {
            console.log(TYPE_WORK);
            console.log(pomodoroCookie[TYPE_BREAK]);
            if (type === TYPE_WORK && pomodoroCookie[TYPE_BREAK] > 0) {
                console.log('dd:' + pomodoroCookie[TYPE_BREAK]);
                pomodoroCookie[TYPE] = TYPE_BREAK;
                pomodoroCookie[REMAIN_TIME] = pomodoroCookie[TYPE_BREAK];
                pomodoroCookie[STATE] = STATE_PAUSE;
                pomodoroCookie[START_TIME] = new Date().getTime();
                setCookie(pomoID, JSON.stringify(pomodoroCookie), 24);
                thisTimer.setAttribute('data-type', TYPE_BREAK);
                resumeTimer();
                playAlarm();
                return;
            } else {
                completeTimer();
                return;
            }
        }

        if (isPause) {
            pomodoroCookie[REMAIN_TIME] = microLeft;
            pomodoroCookie[STATE] = STATE_PAUSE;
            thisTimer.setAttribute('data-status', STATE_PAUSE);
            setCookie(pomoID, JSON.stringify(pomodoroCookie), 24);
            return;
        }

        var delay = microLeft % TIME_THICK;
        setTimeout(updateTimer, delay);
    }

    function setTimerShape() {
        timeLeft = timeLeft >= 0 ? timeLeft : 0;
        timerText.textContent = formatTime(timeLeft);
        setCircleDasharray();
        setEndCircle();
        setRemainingPathColor();
    }

    function resetTimer() {
        var workTimeText = workTimeInput.innerText;
        var breakTimeText = breakTimeInput.innerText;
        if (workTimeChk.getAttribute('class').indexOf(CHK_CLASS) > -1) {
            timeFull = parseInt(workTimeText) * 60;
            thisTimer.setAttribute('data-type', TYPE_WORK);
        } else if (breakTimeChk.getAttribute('class').indexOf(CHK_CLASS) > -1) {
            timeFull = parseInt(breakTimeText) * 60;
            thisTimer.setAttribute('data-type', TYPE_BREAK);
        } else {
            timeFull = 0;
            thisTimer.setAttribute('data-type', '');
        }

        timeLeft = timeFull;
        timePassed = 0;
        setTimerShape();
        setPomodoroCookie(STATE_STOP);
    }

    function completeTimer() {
        playAlarm();
        setPomodoroCookie();
        resetTimer();
    }

    function playAlarm() {
        if (!("Notification" in window)) {
            endAlert();
            return;
        }

        if (Notification.permission === "granted") {
            const notificationOptions = {
                body: 'Your timer has ended!',
                icon: '/images/ezNewPortal/skin/dark/util_alarm_white.svg'
            };

            new Notification('Timer Ended', notificationOptions);
        } else {
            // audio.play();
            endAlert();
        }
    }

    function endAlert() {
        setTimeout(function () {
            alert('end');
        }, 100);
    }

    function chkNotificationPermission() {
        if (Notification.permission === "default") {
            var timers = document.querySelectorAll(".portlet[data-type]");
            Array.prototype.forEach.call(timers, function (el) {
                el.addEventListener('click', function () {
                    Notification.requestPermission().then(function (permission) {
                        console.log("Notification permission status:", permission);
                    });
                })
            });
        } else if (Notification.permission === "denied") {
            var mutes = document.querySelectorAll('.portletPlus.mute');
            Array.prototype.forEach.call(mutes, function (el) {
                el.style.display = "flex";
                el.addEventListener('click', function () {
                    alert(el.getAttribute('title'));
                })
            });
        }
    }

    function setEndCircle() {
        var fullDeg = 2 * Math.PI;
        var currDeg = fullDeg * calculateTimeFraction();
        var r = 45;
        var center = [50, 50];

        var coordinate = [
            center[0] + r * Math.cos(currDeg),
            center[1] + r * Math.sin(currDeg)
        ];
        endCircle.setAttribute('cx', coordinate[0]);
        endCircle.setAttribute('cy', coordinate[1]);
    }

    function setCookie(name, value, hours) {
        var expires = new Date();
        expires.setTime(expires.getTime() + hours * 60 * 60 * 1000);
        document.cookie = name + '=' + value + ';expires=' + expires.toUTCString();
    }

    function getCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) === ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
        }
        return null;
    }

    function toggleChkPomodoro(dom) {
        var type = dom.getAttribute('data-type');
        var curClass = dom.getAttribute('class');
        if (curClass.indexOf(CHK_CLASS) > -1) {
            dom.setAttribute('class', trim(curClass.replace(CHK_CLASS, '')));
            deFocusTime();
        } else {
            dom.setAttribute('class', curClass + ' ' + CHK_CLASS);
            if (type === TYPE_WORK) focusWorkTime();
            else if (type === TYPE_BREAK) focusBreakTime();
        }
    }

    function getOption() {
        var data;
        $.ajax({
            type: "get",
            dataType: "json",
            url: "/ezNewPortal/pomodoro/" + portletId,
            async: false,
            success: function (result) {
                if (result.status === 'ok') {
                    data = result.data;
                }
            }
        });
        return data;
    }

    function saveOption() {
        $.ajax({
            type: "post",
            contentType: "application/json; charset=UTF-8",
            url: "/ezNewPortal/pomodoro/" + portletId,
            data: JSON.stringify({
                focusTime: parseInt(workTimeInput.innerText) * 60,
                breakTime: parseInt(breakTimeInput.innerText) * 60
            }),
            success: function (result) {
                if (result.status === 'ok') {
                    console.log('Pomodoro settings updated successfully')
                } else {
                    console.log('updated fail, status:' + result.status);
                }
            }, error: function (error) {
                console.log('updated fail, error:' + error, error.stack);
            }
        });
    }

    function changeDigit(className, change) {
        const element = document.getElementsByClassName(className)[0];
        var value = parseInt(element.textContent);
        value = (value + change + 100) % 100;  // Ensure it stays between 0-99
        element.textContent = value.toString().length === 1 ? '0' + value.toString() : value.toString();
        saveOption();
        applyTimer();
    }

    function deFocusTime() {
        breakTimeInput.classList.remove('focus');
        workTimeInput.classList.remove('focus');
    }

    function focusWorkTime() {
        deFocusTime();
        workTimeInput.classList.add('focus');
    }

    function focusBreakTime() {
        deFocusTime();
        breakTimeInput.classList.add('focus');
    }

    function toggleSet() {
        var offClass = 'off-set';
        if (areaSet.classList.contains(offClass)) {
            areaTimer.classList.add(offClass);
            areaSet.classList.remove(offClass);
        } else {
            areaTimer.classList.remove(offClass);
            areaSet.classList.add(offClass);
        }
    }

    startBtn.attachEvent ? startBtn.attachEvent('onclick', startTimer) : startBtn.addEventListener("click", startTimer);
    resumeBtn.attachEvent ? resumeBtn.attachEvent('onclick', resumeTimer) : resumeBtn.addEventListener("click", resumeTimer);
    pauseBtn.attachEvent ? pauseBtn.attachEvent('onclick', pauseTimer) : pauseBtn.addEventListener("click", pauseTimer);
    resetBtn.attachEvent ? resetBtn.attachEvent('onclick', resetTimer) : resetBtn.addEventListener("click", resetTimer);
    setBtn.attachEvent ? setBtn.attachEvent('onclick', toggleSet) : setBtn.addEventListener("click", toggleSet);

    thisTimer.querySelector('.' + TYPE_WORK + ' ~ .btn-decrease').addEventListener('click', function () {
        focusWorkTime();
        changeDigit(TYPE_WORK, -1)
    });
    thisTimer.querySelector('.' + TYPE_WORK + ' ~ .btn-increase').addEventListener('click', function () {
        focusWorkTime();
        changeDigit(TYPE_WORK, +1)
    });
    thisTimer.querySelector('.' + TYPE_BREAK + ' ~ .btn-decrease').addEventListener('click', function () {
        focusBreakTime();
        changeDigit(TYPE_BREAK, -1)
    });
    thisTimer.querySelector('.' + TYPE_BREAK + ' ~ .btn-increase').addEventListener('click', function () {
        focusBreakTime();
        changeDigit(TYPE_BREAK, +1)
    });

    document.querySelector('.wrap-set-work > span').addEventListener('click', focusWorkTime);
    document.querySelector('.wrap-set-work > div').addEventListener('click', focusWorkTime);
    document.querySelector('.wrap-set-break > span').addEventListener('click', focusBreakTime);
    document.querySelector('.wrap-set-break > div').addEventListener('click', focusBreakTime);


    // 정지상태만 타이머에 설정 변경 반영
    function applyTimer() {
        var pomodoroCookie = JSON.parse(getCookie(pomoID));
        if (!pomodoroCookie || pomodoroCookie[STATE] === STATE_STOP) {
            resetTimer();
        }
    }

    var checkPomodoroList = document.querySelectorAll('.chk-pomodoro');
    Array.prototype.forEach.call(checkPomodoroList, function (chkNode) {
        chkNode.addEventListener('click', function () {
            toggleChkPomodoro(this);

            applyTimer();
        });
    });


    function handleKeyPress(event) {
        event = event || window.event;
        var key = event.keyCode || event.which;

        if (key >= 48 && key <= 57) {
            return String.fromCharCode(key);
        }
    }

    document.addEventListener('mousedown', function () {
        deFocusTime();
    });

    document.addEventListener('keydown', function () {
        var num = handleKeyPress(event);
        var focusNum = thisTimer.querySelector('.digit-display.focus');
        if (!!focusNum && !!num) {
            focusNum.innerText = (focusNum.innerText + num).substring(1);
            saveOption();
        }
    });
    // Initialize
    init();
}
