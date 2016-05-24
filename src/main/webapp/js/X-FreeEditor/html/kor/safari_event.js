document.onkeydown = function (evt) {
            var e = evt;
            if (e == null) e = window.event;
            if (new RegExp(/Safari/).test(navigator.userAgent) && navigator.userAgent.indexOf("Chrome") == -1) {
                if ((e.keyCode > 47) && (e.keyCode < 58)) {
                    e.preventDefault();
                }
                else if ((e.keyCode > 95) && (e.keyCode < 106)) {
                    e.preventDefault();
                }
                else if ((e.keyCode > 64) && (e.keyCode < 91)) {
                    e.preventDefault();
                }
                else if ((e.keyCode == 106) ||
                    (e.keyCode == 107) ||
                    (e.keyCode == 109) ||
                    (e.keyCode == 110) ||
                    (e.keyCode == 111) ||
                    (e.keyCode == 186) ||
                    (e.keyCode == 187) ||
                    (e.keyCode == 188) ||
                    (e.keyCode == 189) ||
                    (e.keyCode == 190) ||
                    (e.keyCode == 191) ||
                    (e.keyCode == 192) ||
                    (e.keyCode == 219) ||
                    (e.keyCode == 220) ||
                    (e.keyCode == 221) ||
                    (e.keyCode == 222)) {
                    e.preventDefault();
                }
                else if ((e.keyCode == 229)) {
                   e.returnValue = false;
                }
            }
        }