
function datepicker(thisobjid, elobjid) {
    window[thisobjid] = this;
    var thisid = thisobjid;
    var element = document.getElementById(elobjid);
    this.attachEvent = function(eventname, eventhandler) {
        this['on' + eventname] = eventhandler;
    }

    this.pickerDateFormat;
    this.pickerTimeFormat;
    this.daynameLetters;

    this.elemDateButtons;
    this.elemDateInputs;
    this.inputDateFormat;

    this.elemTimeButtons;
    this.elemTimeInputs;
    this.inputTimeFormat;

    this.displayOnly;
    this.popupButton;
    this.popupType;

    this.showDaynames;
    this.isoDateUTF;
    this.isoEndDateUTF;

    this.setEndtimePicker24hours = function(a) {
        if (!a) {
            return;
        }
        return put_setEndtimePicker24hours.call(this, a);
    };
    function put_setEndtimePicker24hours(bVal) {
        m_fEndtimepicker24hours = bVal;
    }

    this.isoDateUTC = function(a) {
        if (!a) {
            return get_isoDateUTC.call(this);
        }
        return put_isoDateUTC.call(this, a);
    };
    function get_isoDateUTC() {
        return (mfGetISOdateString(m_objCurDate[0]));
    }
    function put_isoDateUTC(szIsoDate) {
        m_objCurDate[0] = mfGetISODateObj(szIsoDate);
        mfOutputDate.call(this, false, m_rgeInputDate[0], 0);
        mfOutputDate.call(this, false, m_rgeInputTime[0], 1);
    }

    this.isoEndDateUTC = function(a) {
        if (!a) {
            return get_isoEndDateUTC.call(this);
        }
        return put_isoEndDateUTC.call(this, a);
    };
    function get_isoEndDateUTC() {
        return (mfGetISOdateString(m_objCurDate[1]));
    }
    function put_isoEndDateUTC(szIsoDate) {
        m_objCurDate[1] = mfGetISODateObj(szIsoDate);
        mfOutputDate.call(this, false, m_rgeInputDate[1], 0);
        mfOutputDate.call(this, false, m_rgeInputTime[1], 1);
    }

    this.objDateLocal = function(a) {
        return get_objDateLocal.call(this, a);
    };
    function get_objDateLocal(iWhichDate) {
        return (m_objCurDate[(null == iWhichDate) ? 0 : iWhichDate]);
    }

    this.vtLocalDate = function(a) {
        if (!a) {
            return get_vtLocalDate.call(this);
        }
        return put_vtLocalDate.call(this, a);
    };
    function get_vtLocalDate() {
        return (navigator.userAgent.indexOf('MSIE') == -1 || isie9()) ?
        m_objCurDate[0] :
        m_objCurDate[0].getVarDate();
    }

    function put_vtLocalDate(oDate) {
        if ("object" != typeof (oDate)) {
            oDate = new Date(oDate);

            if (0 < oDate.getSeconds()) {
                oDate.setSeconds((30 < oDate.getSeconds()) ? 60 : 0);
            }
        }
        if (isie9())
            oDate = new Date(oDate);

        m_objCurDate[0].setTime(oDate.getTime());
        mfOutputDate.call(this, false, m_rgeInputDate[0], 0);
        mfOutputDate.call(this, false, m_rgeInputTime[0], 1);
    }

    this.vtLocalEndDate = function(a) {
        if (!a) {
            return get_vtLocalEndDate.call(this);
        }

        return put_vtLocalEndDate.call(this, a);
    };
    function get_vtLocalEndDate() {
        return (navigator.userAgent.indexOf('MSIE') == -1 || isie9()) ?
        m_objCurDate[1] :
        m_objCurDate[1].getVarDate();
    }

    function put_vtLocalEndDate(oDate) {
        if ("object" != typeof (oDate)) {
            oDate = new Date(oDate);

            if (0 < oDate.getSeconds()) {
                oDate.setSeconds((30 < oDate.getSeconds()) ? 60 : 0);
            }
        }
        if (isie9())
            oDate = new Date(oDate);

        m_objCurDate[1].setTime(oDate.getTime());
        mfOutputDate.call(this, false, m_rgeInputDate[1], 0);
        mfOutputDate.call(this, false, m_rgeInputTime[1], 1);
    }

    this.vtLocalTime = function(a) {
        if (!a) {
            return get_vtLocalTime.call(this);
        }
        return put_vtLocalTime.call(this, a);
    };
    function get_vtLocalTime() {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        m_objCurDate[0] :
        m_objCurDate[0].getVarDate();
    }
    function put_vtLocalTime(oDate) {
        if ("object" != typeof (oDate)) {
            oDate = new Date(oDate);
            if (0 < oDate.getSeconds()) {
                oDate.setSeconds((30 < oDate.getSeconds()) ? 60 : 0);
            }
        }

        m_objCurDate[0].setHours(oDate.getHours(), oDate.getMinutes(), 0, 0);
        mfOutputDate.call(this, false, m_rgeInputTime[0], 1);
    }

    this.vtLocalEndTime = function(a) {
        if (!a) {
            return get_vtLocalEndTime.call(this);
        }
        return put_vtLocalEndTime.call(this, a);
    };
    function get_vtLocalEndTime() {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        m_objCurDate[1] :
        m_objCurDate[1].getVarDate();
    }
    function put_vtLocalEndTime(oDate) {
        if ("object" != typeof (oDate)) {
            oDate = new Date(oDate);
            if (0 < oDate.getSeconds()) {
                oDate.setSeconds((30 < oDate.getSeconds()) ? 60 : 0);
            }
        }

        m_objCurDate[1].setHours(oDate.getHours(), oDate.getMinutes(), 0, 0);
        mfOutputDate.call(this, false, m_rgeInputTime[1], 1);
    }

    this.vtLocalCalDate = function(a) {
        if (!a) {
            return;
        }

        return put_vtLocalCalDate.call(this, a);
    };

    function put_vtLocalCalDate(oDate) {
        if ("object" != typeof (oDate)) {
            oDate = new Date(oDate);
        }

        m_objCurDate[0].setFullYear(oDate.getFullYear(), oDate.getMonth(), oDate.getDate());
        mfOutputDate.call(this, false, m_rgeInputDate[0], 0);
    }

    this.vtLocalEndCalDate = function(a) {
        if (!a) {
            return;
        }
        return put_vtLocalEndCalDate.call(this, a);
    };

    function put_vtLocalEndCalDate(oDate) {
        if ("object" != typeof (oDate)) {
            oDate = new Date(oDate);
        }

        m_objCurDate[1].setFullYear(oDate.getFullYear(), oDate.getMonth(), oDate.getDate());
        mfOutputDate.call(this, false, m_rgeInputDate[1], 0);
    }

    this.startHours = function(a) {
        if (!a) {
            return get_startHours.call(this);
        

        return put_startHours.call(this, a);
    };
    function get_startHours() {
        return (m_objCurDate[0].getHours());
    }
    function put_startHours(iHr) {
        m_objCurDate[0].setHours(iHr);
        mfOutputDate.call(this, false, m_rgeInputTime[0], 1);
        mfOutputDate.call(this, false, m_rgeInputDate[0], 1);
    }

    this.startMinutes = function(a) {
        if (!a) {
            return get_startMinutes.call(this);
        }

        return put_startMinutes.call(this, a);
    };
    function get_startMinutes() {
        return (m_objCurDate[0].getMinutes());
    }
    function put_startMinutes(iMin) {
        m_objCurDate[0].setMinutes(iMin, 0, 0);
        mfOutputDate.call(this, false, m_rgeInputTime[0], 1);
        mfOutputDate.call(this, false, m_rgeInputDate[0], 1);
    }

    this.endHours = function(a) {
        if (!a) {
            return get_endHours.call(this);
        }
        return put_endHours.call(this, a);
    };
    function get_endHours() {
        return (m_objCurDate[1].getHours());
    }
    function put_endHours(iHr) {
        m_objCurDate[1].setHours(iHr);
        mfOutputDate.call(this, false, m_rgeInputTime[1], 1);
        mfOutputDate.call(this, false, m_rgeInputDate[1], 1);
    }

    this.endMinutes = function(a) {
        if (!a) {
            return get_endMinutes.call(this);
        }
        return put_endMinutes.call(this, a);
    };
    function get_endMinutes() {
        return (m_objCurDate[1].getMinutes());
    }
    function put_endMinutes(iMin) {
        m_objCurDate[1].setMinutes(iMin, 0, 0);
        mfOutputDate.call(this, false, m_rgeInputTime[1], 1);
        mfOutputDate.call(this, false, m_rgeInputDate[1], 1);
    }

    this.startFullYear = function(a) {
        if (!a) {
            return get_startFullYear.call(this);
        }
        return put_startFullYear.call(this, a);
    };
    function get_startFullYear() {
        return (m_objCurDate[0].getFullYear());
    }
    function put_startFullYear(iYr) {
        m_objCurDate[0].setFullYear(iYr);
        mfOutputDate.call(this, false, m_rgeInputDate[0], 1);
    }

    this.startDate = function(a) {
        if (!a) {
            return get_startDate.call(this);
        }
        return put_startDate.call(this, a);
    };
    function get_startDate() {
        return (m_objCurDate[0].getDate());
    }
    function put_startDate(iDate) {
        m_objCurDate[0].setDate(iDate);
        mfOutputDate.call(this, false, m_rgeInputDate[0], 1);
    }

    this.startMonth = function(a) {
        if (!a) {
            return get_startMonth.call(this);
        }
        return put_startMonth.call(this, a);
    };
    function get_startMonth() {
        return (m_objCurDate[0].getMonth());
    }
    function put_startMonth(iM) {
        m_objCurDate[0].setMonth(iM);
        mfOutputDate.call(this, false, m_rgeInputDate[0], 1);
    }

    this.endFullYear = function(a) {
        if (!a) {
            return get_endFullYear.call(this);
        }
        return put_endFullYear.call(this, a);
    };
    function get_endFullYear() {
        return (m_objCurDate[1].getFullYear());
    }
    function put_endFullYear(iYr) {
        m_objCurDate[1].setFullYear(iYr);
        mfOutputDate.call(this, false, m_rgeInputDate[1], 1);
    }

    this.endDate = function(a) {
        if (!a) {
            return get_endDate.call(this);
        }
        return put_endDate.call(this, a);
    };
    function get_endDate() {
        return (m_objCurDate[1].getDate());
    }
    function put_endDate(iDate) {
        m_objCurDate[1].setDate(iDate);
        mfOutputDate.call(this, false, m_rgeInputDate[1], 1);
    }

    this.endMonth = function(a) {
        if (!a) {
            return get_endMonth.call(this);
        }
        return put_endMonth.call(this, a);
    };
    function get_endMonth() {
        return (m_objCurDate[1].getMonth());
    }
    function put_endMonth(iM) {
        m_objCurDate[0].setMonth(iM);
        mfOutputDate.call(this, false, m_rgeInputDate[0], 1);
    }

    this.unpopall = mfUnPopPicker;
    function mfUnPopPicker() {
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function() {
            if (null != m_eCalPopup) {
                if (m_eCalPopup.style.display == "") {
                    m_eCalPopup.removeEventListener("mouseover", onMouseOverDatePicker, false);
                    if (null != m_cellSelTime) {
                        m_cellSelTime.style.backgroundColor = '#FFFFE8';
                    }
                    m_eCalPopup.style.display = "none";

                    m_eCalPopup.removeEventListener("mouseover", onMouseOverDatePicker, false);
                    m_eCalPopup.removeEventListener("click", onClickDatePicker, false);
                    m_winDocBody.removeEventListener("click", mfUnPopPicker, false);
                    m_winDocBody.removeEventListener("mouseout", onMouseOutBody, false);
                    if (null != mfPopPicker.hideElements) {
                        document.getElementById(mfPopPicker.hideElements).style.display = "";
                        mfPopPicker.hideElements = null;
                    }
                }
            }
            if (null != m_eTimePopup) {
                if (m_eTimePopup.style.display == "") {
                    m_eTimePopup.style.display = "none";
                    m_eTimePopup.removeEventListener("click", onClickTimePicker, false);
                    m_winDocBody.removeEventListener("click", mfUnPopPicker, false);
                }
            }
            if (null != m_eEndTimePopup) {
                if (m_eEndTimePopup.style.display == "") {
                    m_eEndTimePopup.style.display = "none";
                    m_eEndTimePopup.removeEventListener("click", onClickTimePicker, false);
                    m_eEndTimePopup.removeEventListener("click", mfUnPopPicker, false);
                }
            }
        }).call(this)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function() {
            if (null != m_eCalPopup) {
                if (m_eCalPopup.style.display == "") {
                    m_eCalPopup.removeEventListener("mouseover", onMouseOverDatePicker, false);
                    if (null != m_cellSelTime) {
                        m_cellSelTime.style.backgroundColor = '#FFFFE8';
                    }
                    m_eCalPopup.style.display = "none";

                    m_eCalPopup.removeEventListener("mouseover", onMouseOverDatePicker, false);
                    m_eCalPopup.removeEventListener("click", onClickDatePicker, false);
                    m_winDocBody.removeEventListener("click", mfUnPopPicker, false);
                    m_winDocBody.removeEventListener("mouseout", onMouseOutBody, false);
                    if (null != mfPopPicker.hideElements) {
                        document.getElementById(mfPopPicker.hideElements).style.display = "";
                        mfPopPicker.hideElements = null;
                    }
                }
            }
            if (null != m_eTimePopup) {
                if (m_eTimePopup.style.display == "") {
                    m_eTimePopup.style.display = "none";
                    m_eTimePopup.removeEventListener("click", onClickTimePicker, false);
                    m_winDocBody.removeEventListener("click", mfUnPopPicker, false);
                }
            }
            if (null != m_eEndTimePopup) {
                if (m_eEndTimePopup.style.display == "") {
                    m_eEndTimePopup.style.display = "none";
                    m_eEndTimePopup.removeEventListener("click", onClickTimePicker, false);
                    m_eEndTimePopup.removeEventListener("click", mfUnPopPicker, false);
                }
            }
        }).call(this)
        :
        (function() {
            if (null != m_eCalPopup) {
                if (m_eCalPopup.style.display == "") {
                    m_eCalPopup.detachEvent("onmouseover", onMouseOverDatePicker);
                    if (null != m_cellSelTime) {
                        m_cellSelTime.style.backgroundColor = '#FFFFE8';
                    }
                    m_eCalPopup.style.display = "none";

                    m_eCalPopup.detachEvent("onmouseover", onMouseOverDatePicker);
                    m_eCalPopup.detachEvent("onclick", onClickDatePicker);
                    m_winDocBody.detachEvent("onclick", mfUnPopPicker);
                    m_winDocBody.detachEvent("onmouseout", onMouseOutBody);
                    if (null != mfPopPicker.hideElements) {
                        m_winDocAll[mfPopPicker.hideElements].style.display = "";
                        mfPopPicker.hideElements = null;
                    }
                }
            }
            if (null != m_eTimePopup) {
                if (m_eTimePopup.style.display == "") {
                    m_eTimePopup.style.display = "none";
                    m_eTimePopup.detachEvent("onclick", onClickTimePicker);
                    m_winDocBody.detachEvent("onclick", mfUnPopPicker);
                }
            }
            if (null != m_eEndTimePopup) {
                if (m_eEndTimePopup.style.display == "") {
                    m_eEndTimePopup.style.display = "none";
                    m_eEndTimePopup.detachEvent("onclick", onClickTimePicker);
                    m_eEndTimePopup.detachEvent("onclick", mfUnPopPicker);
                }
            }
        }).call(this)
        ;
    }

    this.getIsoDateUTC = f_getIsoDateUTC;
    function f_getIsoDateUTC(iWhichDate) {
        return ((1 == iWhichDate) ? get_isoEndDateUTC() : get_isoDateUTC());
    }

    this.setIsoDateUTC = f_setIsoDateUTC;
    function f_setIsoDateUTC(szIsoDate, iWhichDate) {
        if (1 == iWhichDate) {
            put_isoEndDateUTC(szIsoDate);
        }
        else {
            put_isoDateUTC(szIsoDate);
        }
    }

    this.firstDayOfWeek;
    this.workingStartTime;
    this.workingStopTime;
    this.textAM;
    this.textPM;
    this.textHoursAbbrev;
    this.daynamesShort;
    this.daynamesLong;
    this.monthnamesShort;
    this.monthnamesLong;
    this.textMustSpecifyValidTime;

    this.ondatechange = function() { };
    this.onenddatechange = function() { };
    this.ontimechange = function() { };
    this.onendtimechange = function() { };

    this.ready = onDocumentReady;
    function onDocumentReady() {
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function() {
            var szTemp;
            var x, y, eNode;
            m_winDocBody = window.document.body;
            if (null != this.displayOnly) {
                m_rgeInputDate[0] = this;
                m_ePopBtn[0] = null;
            }
            else {
                if (null != this.elemDateButtons) {
                    m_ePopBtn = this.elemDateButtons.split(";");
                    m_ePopBtn[0] = window.document.getElementById(m_ePopBtn[0]);
                    m_ePopBtn[0].addEventListener("click", onClickBtnDate, false);
                    if (m_ePopBtn.length > 1) {
                        m_ePopBtn[1] = window.document.getElementById(m_ePopBtn[1]);
                        m_ePopBtn[1].addEventListener("click", onClickBtnDate, false);
                    }
                }

                if (null != this.elemDateInputs) {
                    m_rgeInputDate = this.elemDateInputs.split(";");
                    m_rgeInputDate[0] = window.document.getElementById(m_rgeInputDate[0]);
                    m_rgeInputDate[0].FORMATSTRING = (null != this.inputDateFormat) ? this.inputDateFormat : "[MM]/[dd]/[yyyy]";
                    m_rgeInputDate[0].WHICHDATE = 0;
                    m_ePopBtn[0].INPUTELEMENT = m_rgeInputDate[0];
                    m_ePopBtn[0].WHICHDATE = 0;
                    if (m_rgeInputDate.length > 1) {
                        m_rgeInputDate[1] = window.document.getElementById(m_rgeInputDate[1]);
                        m_rgeInputDate[1].WHICHDATE = 1;
                        m_ePopBtn[1].INPUTELEMENT = m_rgeInputDate[1];
                        m_ePopBtn[1].WHICHDATE = 1;
                        m_rgeInputDate[1].FORMATSTRING = m_rgeInputDate[0].FORMATSTRING;
                    }
                }

                if (null != this.elemTimeButtons) {
                    m_ePopBtn = this.elemTimeButtons.split(";");
                    m_ePopBtn[0] = window.document.getElementById(m_ePopBtn[0]);
                    m_ePopBtn[0].addEventListener("click", onClickBtnTime, false);
                    if (m_ePopBtn.length > 1) {
                        m_ePopBtn[1] = window.document.getElementById(m_ePopBtn[1]);
                        m_ePopBtn[1].addEventListener("click", onClickBtnTime, false);
                    }
                }

                if (null != this.elemTimeInputs) {
                    m_rgeInputTime = this.elemTimeInputs.split(";");
                    m_rgeInputTime[0] = window.document.getElementById(m_rgeInputTime[0]);
                    m_rgeInputTime[0].FORMATSTRING = (null != this.inputTimeFormat) ? this.inputTimeFormat : "[hh]:[mm] [tt]";
                    m_rgeInputTime[0].WHICHDATE = 0;
                    m_rgeInputTime[0].addEventListener("change", onChangeTimeEntry, false);
                    m_ePopBtn[0].INPUTELEMENT = m_rgeInputTime[0];
                    m_ePopBtn[0].WHICHDATE = 0;
                    if (m_rgeInputTime.length > 1) {
                        m_rgeInputTime[1] = window.document.getElementById(m_rgeInputTime[1]);
                        m_rgeInputTime[1].FORMATSTRING = m_rgeInputTime[0].FORMATSTRING;
                        m_rgeInputTime[1].WHICHDATE = 1;
                        m_rgeInputTime[1].addEventListener("change", onChangeTimeEntry, false);
                        m_ePopBtn[1].INPUTELEMENT = m_rgeInputTime[1];
                        m_ePopBtn[1].WHICHDATE = 1;
                    }
                }

                m_iBtnHeight = m_ePopBtn[0].offsetHeight;
                m_iBtnWidth = m_ePopBtn[0].offsetWidth;
            }

            m_rgDayNameLetters = (this.daynameLetters == null || this.daynameLetters == "") ?
							"Sun;Mon;Tue;Wed;Thu;Fri;Sat".split(";") : this.daynameLetters.split(";");
            m_iCalFormat = (null == this.pickerDateFormat || "" == this.pickerDateFormat) ?
					"[MMM] [yyyy]" : this.pickerDateFormat;
            m_rgMonthNamesShort = (null == this.monthnamesShort || "" == this.monthnamesShort) ?
						   "Jan;Feb;Mar;Apr;May;Jun;Jul;Aug;Sep;Oct;Nov;Dec".split(";") :
						   this.monthnamesShort.split(";");
            m_rgMonthNamesLong = (null == this.monthnamesLong || "" == this.monthnamesLong) ?
						   "January;February;March;April;May;June;July;August;September;October;November;December".split(";") :
						   this.monthnamesLong.split(";");
            m_rgDayNamesShort = (null == this.daynamesShort || "" == this.daynamesShort) ?
						   "Sun;Mon;Tue;Wed;Thu;Fri;Sat".split(";") :
						   this.daynamesShort.split(";");
            m_rgDayNamesLong = (null == this.daynamesLong || "" == this.daynamesLong) ?
						   "Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday".split(";") :
						   this.daynamesLong.split(";");
            m_szMustSpecifyValidTime = (null == this.textMustSpecifyValidTime || "" == this.textMustSpecifyValidTime) ?
						"You must specify a valid time" : this.textMustSpecifyValidTime;
            m_szAMtext = (this.textAM == null || this.textAM == "") ? "AM" : this.textAM;
            m_szPMtext = (this.textPM == null || this.textPM == "") ? "PM" : this.textPM;
            m_szTextDecimal = (this.textDecimal == null || this.textDecimal == "") ? "." : this.textDecimal;
            m_szTextHoursAbbrev = (this.textHoursAbbrev == null || this.textHoursAbbrev == "") ? "hrs" : this.textHoursAbbrev;
            if (null == this.pickerTimeFormat || this.pickerTimeFormat == "") {
                this.pickerTimeFormat = "[hh]:[mm] [tt]";
            }

            if (this.showDaynames != null && this.showDaynames != "") {
                szTemp = this.showDaynames.toLowerCase();
                switch (szTemp) {
                    case '0':
                    case 'false':
                    case 'no':
                        m_fShowDayName = false;
                        break;
                    default:
                        m_fShowDayName = true;
                }
            }

            if (null != this.isoDateUTF && "" != this.isoDateUTF) {
                m_objCurDate[0] = mfGetISODateObj(this.isoDateUTF);
                m_objCurDate[1] = (null != this.isoEndDateUTF) ? (("" != this.isoEndDateUTF) ? mfGetISODateObj(this.isoEndDateUTF) : null) : null;
            }
            else {
                m_objCurDate[0] = new Date();
                if (m_objCurDate[0].getMinutes() < 30) {
                    m_objCurDate[0].setMinutes(30);
                    m_objCurDate[0].setSeconds(0);
                }
                else {
                    m_objCurDate[0].setMinutes(0);
                }
                m_objCurDate[1] = (null != this.isoEndDateUTF) ? (("" != this.isoEndDateUTF) ? mfGetISODateObj(this.isoEndDateUTF) : null) : null;
                if (null == m_objCurDate[1]) {
                    m_objCurDate[1] = new Date(m_objCurDate[0]);
                    m_objCurDate[1].setTime(m_objCurDate[0].getTime() + 1800000);
                }
            }

            m_objCurDate[0].setSeconds(0, 0);
            m_objCurDate[1].setSeconds(0, 0);

            for (x = 0; x < m_rgeInputDate.length; x++) {
                mfOutputDate.call(this, false, m_rgeInputDate[x], 0);
            }
            for (x = 0; x < m_rgeInputTime.length; x++) {
                mfOutputDate.call(this, false, m_rgeInputTime[x], 1);
            }
        }).call(this)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function() {
            var szTemp;
            var x, y, eNode;
            m_winDocBody = window.document.body;
            if (null != this.displayOnly) {
                m_rgeInputDate[0] = this;
                m_ePopBtn[0] = null;
            }
            else {
                if (null != this.elemDateButtons) {
                    m_ePopBtn = this.elemDateButtons.split(";");
                    m_ePopBtn[0] = window.document.getElementById(m_ePopBtn[0]);
                    m_ePopBtn[0].addEventListener("click", onClickBtnDate, false);
                    if (m_ePopBtn.length > 1) {
                        m_ePopBtn[1] = window.document.getElementById(m_ePopBtn[1]);
                        m_ePopBtn[1].addEventListener("click", onClickBtnDate, false);
                    }
                }
                if (null != this.elemDateInputs) {
                    m_rgeInputDate = this.elemDateInputs.split(";");
                    m_rgeInputDate[0] = window.document.getElementById(m_rgeInputDate[0]);
                    m_rgeInputDate[0].FORMATSTRING = (null != this.inputDateFormat) ? this.inputDateFormat : "[MM]/[dd]/[yyyy]";
                    m_rgeInputDate[0].WHICHDATE = 0;
                    m_ePopBtn[0].INPUTELEMENT = m_rgeInputDate[0];
                    m_ePopBtn[0].WHICHDATE = 0;
                    if (m_rgeInputDate.length > 1) {
                        m_rgeInputDate[1] = window.document.getElementById(m_rgeInputDate[1]);
                        m_rgeInputDate[1].WHICHDATE = 1;
                        m_ePopBtn[1].INPUTELEMENT = m_rgeInputDate[1];
                        m_ePopBtn[1].WHICHDATE = 1;
                        m_rgeInputDate[1].FORMATSTRING = m_rgeInputDate[0].FORMATSTRING;
                    }
                }

                if (null != this.elemTimeButtons) {
                    m_ePopBtn = this.elemTimeButtons.split(";");
                    m_ePopBtn[0] = window.document.getElementById(m_ePopBtn[0]);
                    m_ePopBtn[0].addEventListener("click", onClickBtnTime, false);
                    if (m_ePopBtn.length > 1) {
                        m_ePopBtn[1] = window.document.getElementById(m_ePopBtn[1]);
                        m_ePopBtn[1].addEventListener("click", onClickBtnTime, false);
                    }
                }

                if (null != this.elemTimeInputs) {
                    m_rgeInputTime = this.elemTimeInputs.split(";");
                    m_rgeInputTime[0] = window.document.getElementById(m_rgeInputTime[0]);
                    m_rgeInputTime[0].FORMATSTRING = (null != this.inputTimeFormat) ? this.inputTimeFormat : "[hh]:[mm] [tt]";
                    m_rgeInputTime[0].WHICHDATE = 0;
                    m_rgeInputTime[0].addEventListener("change", onChangeTimeEntry, false);
                    m_ePopBtn[0].INPUTELEMENT = m_rgeInputTime[0];
                    m_ePopBtn[0].WHICHDATE = 0;
                    if (m_rgeInputTime.length > 1) {
                        m_rgeInputTime[1] = window.document.getElementById(m_rgeInputTime[1]);
                        m_rgeInputTime[1].FORMATSTRING = m_rgeInputTime[0].FORMATSTRING;
                        m_rgeInputTime[1].WHICHDATE = 1;
                        m_rgeInputTime[1].addEventListener("change", onChangeTimeEntry, false);
                        m_ePopBtn[1].INPUTELEMENT = m_rgeInputTime[1];
                        m_ePopBtn[1].WHICHDATE = 1;
                    }
                }

                m_iBtnHeight = m_ePopBtn[0].offsetHeight;
                m_iBtnWidth = m_ePopBtn[0].offsetWidth;
            }

            m_rgDayNameLetters = (this.daynameLetters == null || this.daynameLetters == "") ?
							"Sun;Mon;Tue;Wed;Thu;Fri;Sat".split(";") : this.daynameLetters.split(";");
            m_iCalFormat = (null == this.pickerDateFormat || "" == this.pickerDateFormat) ?
					"[MMM] [yyyy]" : this.pickerDateFormat;
            m_rgMonthNamesShort = (null == this.monthnamesShort || "" == this.monthnamesShort) ?
						   "Jan;Feb;Mar;Apr;May;Jun;Jul;Aug;Sep;Oct;Nov;Dec".split(";") :
						   this.monthnamesShort.split(";");
            m_rgMonthNamesLong = (null == this.monthnamesLong || "" == this.monthnamesLong) ?
						   "January;February;March;April;May;June;July;August;September;October;November;December".split(";") :
						   this.monthnamesLong.split(";");
            m_rgDayNamesShort = (null == this.daynamesShort || "" == this.daynamesShort) ?
						   "Sun;Mon;Tue;Wed;Thu;Fri;Sat".split(";") :
						   this.daynamesShort.split(";");
            m_rgDayNamesLong = (null == this.daynamesLong || "" == this.daynamesLong) ?
						   "Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday".split(";") :
						   this.daynamesLong.split(";");
            m_szMustSpecifyValidTime = (null == this.textMustSpecifyValidTime || "" == this.textMustSpecifyValidTime) ?
						"You must specify a valid time" : this.textMustSpecifyValidTime;
            m_szAMtext = (this.textAM == null || this.textAM == "") ? "AM" : this.textAM;
            m_szPMtext = (this.textPM == null || this.textPM == "") ? "PM" : this.textPM;
            m_szTextDecimal = (this.textDecimal == null || this.textDecimal == "") ? "." : this.textDecimal;
            m_szTextHoursAbbrev = (this.textHoursAbbrev == null || this.textHoursAbbrev == "") ? "hrs" : this.textHoursAbbrev;
            if (null == this.pickerTimeFormat || this.pickerTimeFormat == "") {
                this.pickerTimeFormat = "[hh]:[mm] [tt]";
            }

            if (this.showDaynames != null && this.showDaynames != "") {
                szTemp = this.showDaynames.toLowerCase();
                switch (szTemp) {
                    case '0':
                    case 'false':
                    case 'no':
                        m_fShowDayName = false;
                        break;
                    default:
                        m_fShowDayName = true;
                }
            }

            if (null != this.isoDateUTF && "" != this.isoDateUTF) {
                m_objCurDate[0] = mfGetISODateObj(this.isoDateUTF);
                m_objCurDate[1] = (null != this.isoEndDateUTF) ? (("" != this.isoEndDateUTF) ? mfGetISODateObj(this.isoEndDateUTF) : null) : null;
            }
            else {
                m_objCurDate[0] = new Date();
                if (m_objCurDate[0].getMinutes() < 30) {
                    m_objCurDate[0].setMinutes(30);
                    m_objCurDate[0].setSeconds(0);
                }
                else {
                    m_objCurDate[0].setMinutes(0);
                }
                m_objCurDate[1] = (null != this.isoEndDateUTF) ? (("" != this.isoEndDateUTF) ? mfGetISODateObj(this.isoEndDateUTF) : null) : null;
                if (null == m_objCurDate[1]) {
                    m_objCurDate[1] = new Date(m_objCurDate[0]);
                    m_objCurDate[1].setTime(m_objCurDate[0].getTime() + 1800000);
                }
            }

            m_objCurDate[0].setSeconds(0, 0);
            m_objCurDate[1].setSeconds(0, 0);

            for (x = 0; x < m_rgeInputDate.length; x++) {
                mfOutputDate.call(this, false, m_rgeInputDate[x], 0);
            }
            for (x = 0; x < m_rgeInputTime.length; x++) {
                mfOutputDate.call(this, false, m_rgeInputTime[x], 1);
            }
        }).call(this)
        :
        (function() {
            var szTemp;
            var x, y, eNode;
            m_winDocBody = window.document.body;
            if (null != this.displayOnly) {
                m_rgeInputDate[0] = this;
                m_ePopBtn[0] = null;
            }
            else {
                if (null != this.elemDateButtons) {
                    m_ePopBtn = this.elemDateButtons.split(";");
                    m_ePopBtn[0] = window.document.getElementById(m_ePopBtn[0]);
                    m_ePopBtn[0].attachEvent("onclick", onClickBtnDate);
                    if (m_ePopBtn.length > 1) {
                        m_ePopBtn[1] = window.document.getElementById(m_ePopBtn[1]);
                        m_ePopBtn[1].attachEvent("onclick", onClickBtnDate);
                    }
                }

                if (null != this.elemDateInputs) {
                    m_rgeInputDate = this.elemDateInputs.split(";");
                    m_rgeInputDate[0] = window.document.getElementById(m_rgeInputDate[0]);
                    m_rgeInputDate[0].FORMATSTRING = (null != this.inputDateFormat) ? this.inputDateFormat : "[MM]/[dd]/[yyyy]";
                    m_rgeInputDate[0].WHICHDATE = 0;
                    m_ePopBtn[0].INPUTELEMENT = m_rgeInputDate[0];
                    m_ePopBtn[0].WHICHDATE = 0;
                    if (m_rgeInputDate.length > 1) {
                        m_rgeInputDate[1] = window.document.getElementById(m_rgeInputDate[1]);
                        m_rgeInputDate[1].WHICHDATE = 1;
                        m_ePopBtn[1].INPUTELEMENT = m_rgeInputDate[1];
                        m_ePopBtn[1].WHICHDATE = 1;
                        m_rgeInputDate[1].FORMATSTRING = m_rgeInputDate[0].FORMATSTRING;
                    }
                }

                if (null != this.elemTimeButtons) {
                    m_ePopBtn = this.elemTimeButtons.split(";");
                    m_ePopBtn[0] = window.document.getElementById(m_ePopBtn[0]);
                    m_ePopBtn[0].attachEvent("onclick", onClickBtnTime);
                    if (m_ePopBtn.length > 1) {
                        m_ePopBtn[1] = window.document.getElementById(m_ePopBtn[1]);
                        m_ePopBtn[1].attachEvent("onclick", onClickBtnTime);
                    }
                }

                if (null != this.elemTimeInputs) {
                    m_rgeInputTime = this.elemTimeInputs.split(";");
                    m_rgeInputTime[0] = window.document.getElementById(m_rgeInputTime[0]);
                    m_rgeInputTime[0].FORMATSTRING = (null != this.inputTimeFormat) ? this.inputTimeFormat : "[hh]:[mm] [tt]";
                    m_rgeInputTime[0].WHICHDATE = 0;
                    m_rgeInputTime[0].attachEvent("onchange", onChangeTimeEntry);
                    m_ePopBtn[0].INPUTELEMENT = m_rgeInputTime[0];
                    m_ePopBtn[0].WHICHDATE = 0;
                    if (m_rgeInputTime.length > 1) {
                        m_rgeInputTime[1] = window.document.getElementById(m_rgeInputTime[1]);
                        m_rgeInputTime[1].FORMATSTRING = m_rgeInputTime[0].FORMATSTRING;
                        m_rgeInputTime[1].WHICHDATE = 1;
                        m_rgeInputTime[1].attachEvent("onchange", onChangeTimeEntry);
                        m_ePopBtn[1].INPUTELEMENT = m_rgeInputTime[1];
                        m_ePopBtn[1].WHICHDATE = 1;
                    }
                }

                m_iBtnHeight = m_ePopBtn[0].offsetHeight;
                m_iBtnWidth = m_ePopBtn[0].offsetWidth;
            }

            m_rgDayNameLetters = (this.daynameLetters == null || this.daynameLetters == "") ?
							"Sun;Mon;Tue;Wed;Thu;Fri;Sat".split(";") : this.daynameLetters.split(";");
            m_iCalFormat = (null == this.pickerDateFormat || "" == this.pickerDateFormat) ?
					"[MMM] [yyyy]" : this.pickerDateFormat;
            m_rgMonthNamesShort = (null == this.monthnamesShort || "" == this.monthnamesShort) ?
						   "Jan;Feb;Mar;Apr;May;Jun;Jul;Aug;Sep;Oct;Nov;Dec".split(";") :
						   this.monthnamesShort.split(";");
            m_rgMonthNamesLong = (null == this.monthnamesLong || "" == this.monthnamesLong) ?
						   "January;February;March;April;May;June;July;August;September;October;November;December".split(";") :
						   this.monthnamesLong.split(";");
            m_rgDayNamesShort = (null == this.daynamesShort || "" == this.daynamesShort) ?
						   "Sun;Mon;Tue;Wed;Thu;Fri;Sat".split(";") :
						   this.daynamesShort.split(";");
            m_rgDayNamesLong = (null == this.daynamesLong || "" == this.daynamesLong) ?
						   "Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday".split(";") :
						   this.daynamesLong.split(";");
            m_szMustSpecifyValidTime = (null == this.textMustSpecifyValidTime || "" == this.textMustSpecifyValidTime) ?
						"You must specify a valid time" : this.textMustSpecifyValidTime;
            m_szAMtext = (this.textAM == null || this.textAM == "") ? "AM" : this.textAM;
            m_szPMtext = (this.textPM == null || this.textPM == "") ? "PM" : this.textPM;
            m_szTextDecimal = (this.textDecimal == null || this.textDecimal == "") ? "." : this.textDecimal;
            m_szTextHoursAbbrev = (this.textHoursAbbrev == null || this.textHoursAbbrev == "") ? "hrs" : this.textHoursAbbrev;
            if (null == this.pickerTimeFormat || this.pickerTimeFormat == "") {
                this.pickerTimeFormat = "[hh]:[mm] [tt]";
            }

            if (this.showDaynames != null && this.showDaynames != "") {
                szTemp = this.showDaynames.toLowerCase();
                switch (szTemp) {
                    case '0':
                    case 'false':
                    case 'no':
                        m_fShowDayName = false;
                        break;
                    default:
                        m_fShowDayName = true;
                }
            }

            if (null != this.isoDateUTF && "" != this.isoDateUTF) {
                m_objCurDate[0] = mfGetISODateObj(this.isoDateUTF);
                m_objCurDate[1] = (null != this.isoEndDateUTF) ? (("" != this.isoEndDateUTF) ? mfGetISODateObj(this.isoEndDateUTF) : null) : null;
            }
            else {
                m_objCurDate[0] = new Date();
                if (m_objCurDate[0].getMinutes() < 30) {
                    m_objCurDate[0].setMinutes(30);
                    m_objCurDate[0].setSeconds(0);
                }
                else {
                    m_objCurDate[0].setMinutes(0);
                }
                m_objCurDate[1] = (null != this.isoEndDateUTF) ? (("" != this.isoEndDateUTF) ? mfGetISODateObj(this.isoEndDateUTF) : null) : null;
                if (null == m_objCurDate[1]) {
                    m_objCurDate[1] = new Date(m_objCurDate[0]);
                    m_objCurDate[1].setTime(m_objCurDate[0].getTime() + 1800000);
                }
            }

            m_objCurDate[0].setSeconds(0, 0);
            m_objCurDate[1].setSeconds(0, 0);

            for (x = 0; x < m_rgeInputDate.length; x++) {
                mfOutputDate.call(this, false, m_rgeInputDate[x], 0);
            }
            for (x = 0; x < m_rgeInputTime.length; x++) {
                mfOutputDate.call(this, false, m_rgeInputTime[x], 1);
            }
        }).call(this)
        ;
    } 

    var m_ePopBtn = new Array();
    var m_iCalWidth = 0;
    var m_iCalHeight = 0;
    var m_iBtnHeight = 0;
    var m_iBtnWidth = 0;
    var m_objCurDate = new Array();
    var m_eTimePopup = null;
    var m_eEndTimePopup = null;
    var m_eCalPopup = null;
    var m_eCalTitle = null;
    var m_rgeInputDate = new Array();
    var m_rgeInputTime = new Array();
    var m_iDateFormat = 0;
    var m_fShowDayName = false;
    var m_szMustSpecifyValidTime;
    var m_fInitDisplayDate = false;
    var m_rgMonthNamesShort = new Array();
    var m_rgMonthNamesLong = new Array();
    var m_rgDayNamesShort = new Array();
    var m_rgDayNamesLong = new Array();

    var m_iFirstDayOfWeek = 0;
    var m_rgDayNameLetters;
    var m_winDocBody;
    var m_eDest;
    var m_iOutputFormat = new Array();
    var m_iCalFormat;
    var m_szAMtext;
    var m_szPMtext;
    var m_szTextDecimal;
    var m_szTextHoursAbbrev;
    var CONST_MS_IN_24HRS = 86400000;
    var m_fEndtimepicker24hours = false;

    var m_szOOOText = "#C94545"; 
    var m_szHalfText = "#4545c9"; 

    function mfCreateTimepicker() {
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function() {
            mfFormatTime.szFormat = this.pickerTimeFormat;
            var eNode = document.createElement("SELECT");
            eNode.align = 'absright';
            eNode.size = '2';
            eNode.style.textAlign = 'left';
            eNode.style.height = '170px';

            eNode.style.display = 'none';
            eNode.style.position = 'absolute';

            var eOption = document.createElement("OPTION");

            var iMin = 0;
            for (var x = 0; x < 48; x++, iMin += 30) {
                eOption.textContent = mfFormatTime.call(this, iMin);
                eOption.value = iMin;
                eNode.appendChild(eOption.cloneNode(true));
            }

            m_eTimePopup = m_winDocBody.appendChild(eNode.cloneNode(true));
            m_eTimePopup.style.width = "110px";

            if (m_ePopBtn.length > 1) {
                m_eEndTimePopup = m_winDocBody.appendChild(eNode.cloneNode(true));
                mfWriteEndtimePicker.call(this);
            }
        }).call(this)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function() {
            mfFormatTime.szFormat = this.pickerTimeFormat;

            var eNode = document.createElement("SELECT");
            eNode.align = 'absright';
            eNode.size = '2';
            eNode.style.textAlign = 'left';
            eNode.style.height = '170px';

            eNode.style.display = 'none';
            eNode.style.position = 'absolute';

            var eOption = document.createElement("OPTION");

            var iMin = 0;
            for (var x = 0; x < 48; x++, iMin += 30) {
                eOption.innerText = mfFormatTime.call(this, iMin);
                eOption.value = iMin;
                eNode.appendChild(eOption.cloneNode(true));
            }

            m_eTimePopup = m_winDocBody.insertAdjacentElement("BeforeEnd", eNode.cloneNode(true));
            m_eTimePopup.style.width = "110px";

            if (m_ePopBtn.length > 1) {
                m_eEndTimePopup = m_winDocBody.insertAdjacentElement("BeforeEnd", eNode.cloneNode(true));
                mfWriteEndtimePicker.call(this);
            }
        }).call(this)
        :
        (function() {
            mfFormatTime.szFormat = this.pickerTimeFormat;

            var eNode = document.createElement("SELECT");
            eNode.align = 'absright';
            eNode.size = '2';
            eNode.style.textAlign = 'left';
            eNode.style.height = '170px';

            eNode.style.display = 'none';
            eNode.style.position = 'absolute';

            var eOption = document.createElement("OPTION");

            var iMin = 0;
            for (var x = 0; x < 48; x++, iMin += 30) {
                eOption.innerText = mfFormatTime.call(this, iMin);
                eOption.value = iMin;
                eNode.appendChild(eOption.cloneNode(true));
            }

            m_eTimePopup = m_winDocBody.insertAdjacentElement("BeforeEnd", eNode.cloneNode(true));
            m_eTimePopup.style.width = "110px";

            if (m_ePopBtn.length > 1) {
                m_eEndTimePopup = m_winDocBody.insertAdjacentElement("BeforeEnd", eNode.cloneNode(true));
                mfWriteEndtimePicker();
            }
        }).call(this)
        ;
    }

    function mfOnSelectStartNo(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }

        if (!event) event = window.event;
        return (false);
    }

    function mfCreateCalendar() {
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function() {
            var eTR, eTD, eNode, x, y;
            var eTable = document.createElement("TABLE");
            eTable.addEventListener("selectstart", mfOnSelectStartNo, false);
            eTable.border = '0';
            eTable.cellpadding = '1';
            eTable.cellspacing = '1';
            eTable.style.cssText = "width:177px;height:124px;z-index:1;border-collapse:collapse;display:none;cursor:pointer;position:absolute;font-size:9pt;text-align:center;background-color:#FFFFE8;color:#404040;cursor:pointer;";
            eTable.style.border = "1px solid #D6E2A0";

            eTR = eTable.insertRow(-1);
            eTR.style.cssText = 'background-color:#FFFFE8;color:#404040;';
            eTD = eTR.insertCell(-1);
            eTD.prvyear = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_pprev.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";
            eTD = eTR.insertCell(-1);
            eTD.prv = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_prev.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";
            eTD = eTR.insertCell(-1);
            eTD.colSpan = '3';
            eTD.nop = '1';
            eTD.hdr = '1';
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.style.cursor = 'default'
            eTD.style.color = "#404040";
            eTD.style.fontWeight = "bolder";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.nop = '1';
            eTD.width = "85";
            eTD = eTR.insertCell(-1);
            eTD.nxt = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_next.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";
            eTD = eTR.insertCell(-1);
            eTD.nxtyear = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_nnext.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";

            eTR = eTable.insertRow(-1);
            eTR.style.cssText = 'background-color:#FFFFE8;color:threedhighlight;cursor:default;';

            for (x = 0, y = (null != this.firstDayOfWeek) ? this.firstDayOfWeek : 0; x < 7; x++, y++) {
                if (y > 6) y = 0;
                eTD = eTR.insertCell(-1);
                eTD.textContent = m_rgDayNameLetters[y];
                eTD.nop = '1';

                if (y == 0) {
                    eTD.style.color = m_szOOOText;
                    eTD.style.fontWeight = "bolder";
                }
                else if (y == 6) {
                    eTD.style.color = m_szHalfText;
                    eTD.style.fontWeight = "bolder";
                }
                else {
                    eTD.style.color = "#4F4F4F";
                    eTD.style.fontWeight = "bolder";
                }
                eTD.nop = '1';
            }

            for (x = 0; x < 6; x++) {
                eTR = eTable.insertRow(-1);
                for (y = 0; y < 7; y++) {
                    eTD = eTR.insertCell(-1);
                    if (y == 0) {
                        eTD.style.color = m_szOOOText;
                    }
                    else if (y == 6) {
                        eTD.style.color = m_szHalfText;
                    }
                    else {
                        eTD.style.color = "";
                    }
                }
            }

            for (x = 0; x < 6; x++) {
                eTR = eTable.insertRow(-1);
                for (y = 0; y < 7; y++) eTR.insertCell(-1);
            }
            m_eCalPopup = m_winDocBody.appendChild(eTable);
            m_eCalTitle = m_eCalPopup.rows[0].cells[2];
        }).call(this)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function() {
            var eTR, eTD, eNode, x, y;
            var eTable = document.createElement("TABLE");
            eTable.addEventListener("selectstart", mfOnSelectStartNo, false);
            eTable.border = '0';
            eTable.cellpadding = '1';
            eTable.cellspacing = '1';
            eTable.style.cssText = "width:177px;height:124px;z-index:1;border-collapse:collapse;display:none;cursor:pointer;position:absolute;font-size:9pt;text-align:center;background-color:#FFFFE8;color:#404040;cursor:pointer;";
            eTable.style.border = "1px solid #D6E2A0";

            eTR = eTable.insertRow(-1);
            eTR.style.cssText = 'background-color:#FFFFE8;color:#404040;';
            eTD = eTR.insertCell(-1);
            eTD.prvyear = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_pprev.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";
            eTD = eTR.insertCell(-1);
            eTD.prv = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_prev.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";
            eTD = eTR.insertCell(-1);
            eTD.colSpan = '3';
            eTD.nop = '1';
            eTD.hdr = '1';
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.style.cursor = 'default'
            eTD.style.color = "#404040";
            eTD.style.fontWeight = "bolder";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.nop = '1';
            eTD.width = "85";
            eTD = eTR.insertCell(-1);
            eTD.nxt = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_next.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";
            eTD = eTR.insertCell(-1);
            eTD.nxtyear = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_nnext.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";

            eTR = eTable.insertRow(-1);
            eTR.style.cssText = 'background-color:#FFFFE8;color:threedhighlight;cursor:default;';

            for (x = 0, y = (null != this.firstDayOfWeek) ? this.firstDayOfWeek : 0; x < 7; x++, y++) {
                if (y > 6) y = 0;
                eTD = eTR.insertCell(-1);
                eTD.innerText = m_rgDayNameLetters[y];
                eTD.nop = '1';

                if (y == 0) {
                    eTD.style.color = m_szOOOText;
                    eTD.style.fontWeight = "bolder";
                }
                else if (y == 6) {
                    eTD.style.color = m_szHalfText;
                    eTD.style.fontWeight = "bolder";
                }
                else {
                    eTD.style.color = "#4F4F4F";
                    eTD.style.fontWeight = "bolder";
                }
                eTD.nop = '1';
            }

            for (x = 0; x < 6; x++) {
                eTR = eTable.insertRow(-1);
                for (y = 0; y < 7; y++) {
                    eTD = eTR.insertCell(-1);
                    if (y == 0) {
                        eTD.style.color = m_szOOOText;
                    }
                    else if (y == 6) {
                        eTD.style.color = m_szHalfText;
                    }
                    else {
                        eTD.style.color = "";
                    }
                }
            }

            for (x = 0; x < 6; x++) {
                eTR = eTable.insertRow(-1);
                for (y = 0; y < 7; y++) eTR.insertCell(-1);
            }
            m_eCalPopup = m_winDocBody.insertAdjacentElement("BeforeEnd", eTable);
            m_eCalTitle = m_eCalPopup.rows[0].cells[2];
        }).call(this)
        :
        (function() {
            var eTR, eTD, eNode, x, y;
            var eTable = document.createElement("TABLE");
            eTable.attachEvent("onselectstart", mfOnSelectStartNo);
            eTable.border = '0';
            eTable.cellpadding = '1';
            eTable.cellspacing = '1';
            eTable.style.cssText = "width:177px;height:124px;z-index:1;border-collapse:collapse;display:none;cursor:pointer;position:absolute;font-size:9pt;text-align:center;background-color:#FFFFE8;color:#404040;cursor:pointer;";
            eTable.style.border = "1px solid #D6E2A0";

            eTR = eTable.insertRow();
            eTR.style.cssText = 'background-color:#FFFFE8;color:#404040;';
            eTD = eTR.insertCell();
            eTD.prvyear = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_pprev.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";
            eTD = eTR.insertCell();
            eTD.prv = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_prev.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";
            eTD = eTR.insertCell();
            eTD.colSpan = '3';
            eTD.nop = '1';
            eTD.hdr = '1';
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.style.cursor = 'default'
            eTD.style.color = "#404040";
            eTD.style.fontWeight = "bolder";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.nop = '1';
            eTD.width = "85";
            eTD = eTR.insertCell();
            eTD.nxt = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_next.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";
            eTD = eTR.insertCell();
            eTD.nxtyear = '1';
            eTD.innerHTML = "<img src='/images/etc/calendar_nnext.gif' width='13' height='13' border='0'>";
            eTD.style.color = "404040";
            eTD.style.borderBottom = "dotted 1px black";
            eTD.style.borderBottomColor = "#D6E2A0";
            eTD.width = "23";

            eTR = eTable.insertRow();
            eTR.style.cssText = 'background-color:#FFFFE8;color:threedhighlight;cursor:default;';

            for (x = 0, y = (null != this.firstDayOfWeek) ? this.firstDayOfWeek : 0; x < 7; x++, y++) {
                if (y > 6) y = 0;
                eTD = eTR.insertCell();
                eTD.innerText = m_rgDayNameLetters[y];
                eTD.nop = '1';

                if (y == 0) {
                    eTD.style.color = m_szOOOText;
                    eTD.style.fontWeight = "bolder";
                }
                else if (y == 6) {
                    eTD.style.color = m_szHalfText;
                    eTD.style.fontWeight = "bolder";
                }
                else {
                    eTD.style.color = "#4F4F4F";
                    eTD.style.fontWeight = "bolder";
                }
                eTD.nop = '1';
            }

            for (x = 0; x < 6; x++) {
                eTR = eTable.insertRow();
                for (y = 0; y < 7; y++) {
                    eTD = eTR.insertCell();
                    if (y == 0) {
                        eTD.style.color = m_szOOOText;
                    }
                    else if (y == 6) {
                        eTD.style.color = m_szHalfText;
                    }
                    else {
                        eTD.style.color = "";
                    }
                }
            }

            for (x = 0; x < 6; x++) {
                eTR = eTable.insertRow();
                for (y = 0; y < 7; y++) eTR.insertCell();
            }
            m_eCalPopup = m_winDocBody.insertAdjacentElement("BeforeEnd", eTable);
            m_eCalTitle = m_eCalPopup.rows[0].cells[2];
        }).call(this)
        ;
    }

    function mfWriteEndtimePicker() {
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function() {
            if (null == m_eEndTimePopup) return;
            var x, node;
            var iMin = 0;
            var oOption = document.createElement("OPTION");

            m_eEndTimePopup.style.width = "110px";

            m_eEndTimePopup.innerHTML = "";

            if (m_fEndtimepicker24hours || (m_objCurDate[1] - m_objCurDate[0] < CONST_MS_IN_24HRS)) {
                iMin = (m_objCurDate[0].getHours() * 60) + m_objCurDate[0].getMinutes();
                iSpan = iMin;
                for (x = 0; x < 48; x++, iMin += 30, iSpan += 30) 
                {
                    if (iMin >= 1440) iMin -= 1440;
                    var szPartHrs = (x % 2) ? m_szTextDecimal + "5" : "";
                    oOption.textContent = mfFormatTime.call(this, iMin);
                    oOption.value = iSpan;
                    node = oOption.cloneNode(true);
                    m_eEndTimePopup.appendChild(node);
                }
            }
            else
            {
                for (iMin = 0, x = 0; x < 48; x++, iMin += 30) {
                    oOption.textContent = mfFormatTime.call(this, iMin);
                    oOption.value = iMin;
                    node = oOption.cloneNode(true);
                    m_eEndTimePopup.appendChild(node);
                }
            }
        }).call(this)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function() {
            if (null == m_eEndTimePopup) return;
            var x, node;
            var iMin = 0;
            var oOption = document.createElement("OPTION");

            m_eEndTimePopup.style.width = "110px";
            m_eEndTimePopup.innerHTML = "";
            if (m_fEndtimepicker24hours || (m_objCurDate[1] - m_objCurDate[0] < CONST_MS_IN_24HRS)) {
                iMin = (m_objCurDate[0].getHours() * 60) + m_objCurDate[0].getMinutes();
                iSpan = iMin;
                for (x = 0; x < 48; x++, iMin += 30, iSpan += 30)
                {
                    if (iMin >= 1440) iMin -= 1440;
                    var szPartHrs = (x % 2) ? m_szTextDecimal + "5" : "";
                    oOption.innerText = mfFormatTime.call(this, iMin);
                    oOption.value = iSpan;
                    node = oOption.cloneNode(true);
                    m_eEndTimePopup.insertAdjacentElement('beforeEnd', node);
                }
            }
            else
            {
                for (iMin = 0, x = 0; x < 48; x++, iMin += 30) {
                    oOption.innerText = mfFormatTime.call(this, iMin);
                    oOption.value = iMin;
                    node = oOption.cloneNode(true);
                    m_eEndTimePopup.insertAdjacentElement('beforeEnd', node);
                }
            }
        }).call(this)
        :
        (function() {
            if (null == m_eEndTimePopup) return;
            var x, node;
            var iMin = 0;
            var oOption = document.createElement("OPTION");

            m_eEndTimePopup.style.width = "110px";
            m_eEndTimePopup.innerHTML = "";

            if (m_fEndtimepicker24hours || (m_objCurDate[1] - m_objCurDate[0] < CONST_MS_IN_24HRS)) {
                iMin = (m_objCurDate[0].getHours() * 60) + m_objCurDate[0].getMinutes();
                iSpan = iMin;
                for (x = 0; x < 48; x++, iMin += 30, iSpan += 30) 
                {
                    if (iMin >= 1440) iMin -= 1440;
                    var szPartHrs = (x % 2) ? m_szTextDecimal + "5" : "";
                    oOption.innerText = mfFormatTime.call(this, iMin);
                    oOption.value = iSpan;
                    node = oOption.cloneNode(true);
                    m_eEndTimePopup.insertAdjacentElement('beforeEnd', node);
                }
            }
            else
            {
                for (iMin = 0, x = 0; x < 48; x++, iMin += 30) {
                    oOption.innerText = mfFormatTime.call(this, iMin);
                    oOption.value = iMin;
                    node = oOption.cloneNode(true);
                    m_eEndTimePopup.insertAdjacentElement('beforeEnd', node);
                }
            }
        }).call(this)
        ;
    }

    function mfGetISODateObj(szISODate) {
        var szYear = szISODate.substring(0, 4);
        var szMonth = Number(szISODate.substring(5, 7)) - 1;
        var szDay = szISODate.substring(8, 10);
        var szHr = szISODate.substring(11, 13);
        var szMin = szISODate.substring(14, 16);
        var szSec = szISODate.substring(17, 19);
        var objD = new Date();

        objD.setFullYear(szYear, szMonth, szDay);
        objD.setHours(szHr, szMin, szSec);

        return (objD);
    }

    function mfGetISOdateString(objDate) {
        var szDay = objDate.getUTCDate();
        var szMonth = objDate.getUTCMonth() + 1;
        var szYear = objDate.getUTCFullYear();
        var szHr = objDate.getUTCHours();
        var szMin = objDate.getUTCMinutes();
        var szSec = objDate.getUTCSeconds();
        var szDate = szYear + "-" +
		((szMonth < 10) ? "0" + szMonth : szMonth) + "-" +
		((szDay < 10) ? "0" + szDay : szDay) + "T" +
		((szHr < 10) ? "0" + szHr : szHr) + ":" +
		((szMin < 10) ? "0" + szMin : szMin) + ":" +
		((szSec < 10) ? "0" + szSec : szSec) + ".000Z";
        return (szDate);
    }

    var m_fUpdateEndtimepicker = false;

    function onClickTimePicker(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function(event) {
            if (!event) event = window.event;
            event.cancelBubble = true;

            var srcElement = event.target;
            var iMinTime = srcElement.value;
            var iWhichDate = srcElement.INPUTELEMENT ? srcElement.INPUTELEMENT.WHICHDATE : event.currentTarget.INPUTELEMENT.WHICHDATE;
            var iCurDate = m_objCurDate[iWhichDate].getDate();
            if (1 == iWhichDate && CONST_MS_IN_24HRS > (m_objCurDate[1] - m_objCurDate[0])) {
                if (m_objCurDate[1].getDate() != m_objCurDate[0].getDate()) {
                }
            }
            else if (1 == iWhichDate)
            {
            }

            m_objCurDate[iWhichDate].setHours(0, iMinTime, 0, 0);
            var eDestFld = !srcElement.INPUTELEMENT ? event.currentTarget.INPUTELEMENT : srcElement.INPUTELEMENT;
            mfOutputDate.call(this, true, eDestFld, 1);

            if (iCurDate != m_objCurDate[iWhichDate].getDate())
            {
                mfOutputDate.call(this, false, m_rgeInputDate[iWhichDate], 0);
                m_fUpdateEndtimepicker = true;
            }

            if (0 == iWhichDate) {
                m_fUpdateEndtimepicker = true;
            }

            mfUnPopPicker.call(this);
        }).call(this, event)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(event) {
            if (!event) event = window.event;
            event.cancelBubble = true;

            var srcElement = event.target;
            var iMinTime = srcElement.value;
            var iWhichDate = srcElement.INPUTELEMENT ? srcElement.INPUTELEMENT.WHICHDATE : event.currentTarget.INPUTELEMENT.WHICHDATE;
            var iCurDate = m_objCurDate[iWhichDate].getDate();
            if (1 == iWhichDate && CONST_MS_IN_24HRS > (m_objCurDate[1] - m_objCurDate[0])) {
                if (m_objCurDate[1].getDate() != m_objCurDate[0].getDate()) {
                }
            }
            else if (1 == iWhichDate)
            {
            }

            m_objCurDate[iWhichDate].setHours(0, iMinTime, 0, 0);
            var eDestFld = !srcElement.INPUTELEMENT ? event.currentTarget.INPUTELEMENT : srcElement.INPUTELEMENT;
            mfOutputDate.call(this, true, eDestFld, 1);

            if (iCurDate != m_objCurDate[iWhichDate].getDate()) 
            {
                mfOutputDate.call(this, false, m_rgeInputDate[iWhichDate], 0);
                m_fUpdateEndtimepicker = true;
            }

            if (0 == iWhichDate) {
                m_fUpdateEndtimepicker = true;
            }

            mfUnPopPicker.call(this);
        }).call(this, event)
        :
        (function() {
            event.cancelBubble = true;

            var eSelect = event.srcElement;
            var iMinTime = eSelect.value;
            var iWhichDate = event.srcElement.INPUTELEMENT.WHICHDATE;
            var iCurDate = m_objCurDate[iWhichDate].getDate();
            if (1 == iWhichDate && CONST_MS_IN_24HRS > (m_objCurDate[1] - m_objCurDate[0])) {
                if (m_objCurDate[1].getDate() != m_objCurDate[0].getDate()) {
                }
            }
            else if (1 == iWhichDate) 
            {
            }

            m_objCurDate[iWhichDate].setHours(0, iMinTime, 0, 0);
            var eDestFld = event.srcElement.INPUTELEMENT;
            mfOutputDate.call(this, true, eDestFld, 1);

            if (iCurDate != m_objCurDate[iWhichDate].getDate())
            {
                mfOutputDate.call(this, false, m_rgeInputDate[iWhichDate], 0);
                m_fUpdateEndtimepicker = true;
            }

            if (0 == iWhichDate) {
                m_fUpdateEndtimepicker = true;
            }

            mfUnPopPicker.call(this);
        }).call(this)
        ;
    }

    function onChangeTimeEntry(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function(event) {
            if (!event) event = window.event;
            var srcElement = event.target;
            var iWhichDate = srcElement.WHICHDATE;
            var iTotMin = mfParseTime(srcElement.value);

            if (iTotMin > -1) {
                srcElement.value = mfFormatTime.call(this, iTotMin);
                m_objCurDate[iWhichDate].setHours(0, iTotMin);
                if (0 == iWhichDate) {
                    m_fUpdateEndtimepicker = true;
                }
                else if (m_objCurDate[0] > m_objCurDate[1])
                {
                    m_objCurDate[1].setDate(m_objCurDate[1].getDate() + 1);
                    mfOutputDate.call(this, false, m_rgeInputDate[1], 0);
                }
                fireChangeEvent.call(this, iWhichDate, 1);
            }
            else
            {
                setTimeout(document.getElementById(srcElement.id).focus, 1);
                alert(m_szMustSpecifyValidTime);
                srcElement.value = mfFormatTime.call(this, m_objCurDate[iWhichDate].getHours() * 60 + m_objCurDate[iWhichDate].getMinutes())
            }
        }).call(this, event)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(event) {
            if (!event) event = window.event;
            var srcElement = event.target;
            var iWhichDate = srcElement.WHICHDATE;
            var iTotMin = mfParseTime(srcElement.value);

            if (iTotMin > -1) {
                srcElement.value = mfFormatTime.call(this, iTotMin);
                m_objCurDate[iWhichDate].setHours(0, iTotMin);
                if (0 == iWhichDate) {
                    m_fUpdateEndtimepicker = true;
                }
                else if (m_objCurDate[0] > m_objCurDate[1])
                {
                    m_objCurDate[1].setDate(m_objCurDate[1].getDate() + 1);
                    mfOutputDate.call(this, false, m_rgeInputDate[1], 0);
                }
                fireChangeEvent.call(this, iWhichDate, 1);
            }
            else
            {
                setTimeout(document.getElementById(srcElement.id).focus, 1);
                alert(m_szMustSpecifyValidTime);
                srcElement.value = mfFormatTime.call(this, m_objCurDate[iWhichDate].getHours() * 60 + m_objCurDate[iWhichDate].getMinutes())
            }
        }).call(this, event)
        :
        (function() {
            var eSrc = event.srcElement;
            var iWhichDate = eSrc.WHICHDATE;
            var iTotMin = mfParseTime(eSrc.value);

            if (iTotMin > -1) {
                eSrc.value = mfFormatTime.call(this, iTotMin);
                m_objCurDate[iWhichDate].setHours(0, iTotMin);
                if (0 == iWhichDate) {
                    m_fUpdateEndtimepicker = true;
                }
                else if (m_objCurDate[0] > m_objCurDate[1])
                {
                    m_objCurDate[1].setDate(m_objCurDate[1].getDate() + 1);
                    mfOutputDate.call(this, false, m_rgeInputDate[1], 0);
                }
                fireChangeEvent.call(this, iWhichDate, 1);
            }
            else
            {
                setTimeout("window.document.all['" + eSrc.id + "'].focus()", 1);
                alert(m_szMustSpecifyValidTime);
                eSrc.value = mfFormatTime.call(this, m_objCurDate[iWhichDate].getHours() * 60 + m_objCurDate[iWhichDate].getMinutes())
            }
        }).call(this)
        ;
    }

    function fireChangeEvent(iWhichDate, iDateTime) {
        if (0 == iDateTime) {
            if (0 == iWhichDate) {
                this.ondatechange();
            }
            else {
                this.onenddatechange();
            }
        }
        else {
            if (0 == iWhichDate) {
                this.ontimechange();
            }
            else {
                this.onendtimechange();
            }
        }
    }

    function mfFormatDateTitle(iM, iY, szFormat) {
        if (-1 < szFormat.search(/\[M/g)) {
            szFormat = szFormat.replace(/\[MMMM\]/g, m_rgMonthNamesLong[iM]);
            szFormat = szFormat.replace(/\[MMM\]/g, m_rgMonthNamesShort[iM]);
            szFormat = szFormat.replace(/\[MM\]/g, ++iM < 10 ? "0" + iM : iM);
            szFormat = szFormat.replace(/\[M\]/g, iM);
        }
        if (-1 < szFormat.search(/\[y/g)) {
            var iY2 = iY % 100;
            szFormat = szFormat.replace(/\[yyy+\]/g, iY);
            szFormat = szFormat.replace(/\[y+\]/g, iY2 > 9 ? iY2 : "0" + iY2);
        }
        return (szFormat);
    }

    function mfFillCalendar(iWhichDate) {
        mfBuildMonth.iM = m_objCurDate[iWhichDate].getMonth();
        mfBuildMonth.iD = m_objCurDate[iWhichDate].getDate();
        mfBuildMonth.iY = m_objCurDate[iWhichDate].getFullYear();
        mfBuildMonth.call(this);
    }
    function doNextMonth() {
        if (mfBuildMonth.iM == 11) {
            mfBuildMonth.iM = 0;
            mfBuildMonth.iY++;
        }
        else {
            mfBuildMonth.iM++;
        }
        mfBuildMonth.call(this);
    }
    function doPrevMonth() {
        if (mfBuildMonth.iM == 0) {
            mfBuildMonth.iM = 11;
            mfBuildMonth.iY--;
        }
        else {
            mfBuildMonth.iM--;
        }

        mfBuildMonth.call(this);
    }
    function doNextYear() {
        mfBuildMonth.iY++;
        mfBuildMonth.call(this);
    }
    function doPrevYear() {
        mfBuildMonth.iY--;
        mfBuildMonth.call(this);
    }

    mfBuildMonth.oTempD = new Date();
    mfBuildMonth.iM;
    mfBuildMonth.iD;
    mfBuildMonth.iY;

    function mfBuildMonth() {
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function() {
            var x, y;
            var iWhichDate = m_eCalPopup.WHICHDATE;
            var iM = mfBuildMonth.iM;
            var iD = mfBuildMonth.iD;
            var iY = mfBuildMonth.iY;

            if (m_eCalTitle.iMonth != iM || m_eCalTitle.iFullYear != iY) {
                m_eCalTitle.innerHTML = mfFormatDateTitle(iM, iY, m_iCalFormat);
                m_eCalTitle.iMonth = iM;
                m_eCalTitle.iFullYear = iY;
                var iLastDayPrevMonth = (iM == 0) ? mfGetDaysInMonth(12, iY - 1) : mfGetDaysInMonth(iM, iY);
                var iLastDayThisMonth = mfGetDaysInMonth(iM + 1, iY);

                mfBuildMonth.oTempD.setFullYear(iY, iM, 1);
                var iFirstDay = mfBuildMonth.oTempD.getDay();

                if (null != m_cellSelTime) {
                    m_cellSelTime.style.backgroundColor = 'window';
                }
                var iOffset = iFirstDay - this.firstDayOfWeek;
                if (iOffset < 0) {
                    iOffset += 7;
                }
                var rgCells = m_eCalPopup.getElementsByTagName('TD');
                iOffset += 12;

                for (x = 12, y = iLastDayPrevMonth - iOffset + 13; x < iOffset; x++, y++) {
                    rgCells[x].textContent = y;
                    rgCells[x].style.backgroundColor = 'F9F9F0';
                }

                m_eCalTitle.idxDayOne = x - 1;
                for (y = 1; x < iLastDayThisMonth + iOffset; x++, y++) {
                    rgCells[x].textContent = y;
                    rgCells[x].style.backgroundColor = '#FFFFE8';
                }

                for (y = 1; x < rgCells.length; x++, y++) {
                    if (((x + 9) % 7) == 0) {
                        for (x; x < rgCells.length; x++) {
                            rgCells[x].textContent = "";
                        }
                        break;
                    }
                    rgCells[x].textContent = y;
                    rgCells[x].style.backgroundColor = '#F9F9F0';
                }
            }

            if (m_eCalTitle.iMonth == m_objCurDate[iWhichDate].getMonth() && m_eCalTitle.iFullYear == m_objCurDate[iWhichDate].getFullYear()) {
                var rgCells = m_eCalPopup.getElementsByTagName('TD');
                x = iD + m_eCalTitle.idxDayOne;
                rgCells[x].style.backgroundColor = '#F3F3B7';
                m_cellSelTime = rgCells[x];
            }
        }).call(this)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function() {
            var x, y;
            var iWhichDate = m_eCalPopup.WHICHDATE;
            var iM = mfBuildMonth.iM;
            var iD = mfBuildMonth.iD;
            var iY = mfBuildMonth.iY;

            if (m_eCalTitle.iMonth != iM || m_eCalTitle.iFullYear != iY) {
                m_eCalTitle.innerHTML = mfFormatDateTitle(iM, iY, m_iCalFormat);
                m_eCalTitle.iMonth = iM;
                m_eCalTitle.iFullYear = iY;
                var iLastDayPrevMonth = (iM == 0) ? mfGetDaysInMonth(12, iY - 1) : mfGetDaysInMonth(iM, iY);
                var iLastDayThisMonth = mfGetDaysInMonth(iM + 1, iY);

                mfBuildMonth.oTempD.setFullYear(iY, iM, 1);
                var iFirstDay = mfBuildMonth.oTempD.getDay();

                if (null != m_cellSelTime) {
                    m_cellSelTime.style.backgroundColor = 'window';
                }
                var iOffset = iFirstDay - this.firstDayOfWeek;
                if (iOffset < 0) {
                    iOffset += 7;
                }
                var rgCells = m_eCalPopup.getElementsByTagName('TD');
                iOffset += 12;
                for (x = 12, y = iLastDayPrevMonth - iOffset + 13; x < iOffset; x++, y++) {
                    rgCells[x].innerText = y;
                    rgCells[x].style.backgroundColor = 'F9F9F0';
                }

                m_eCalTitle.idxDayOne = x - 1;
                for (y = 1; x < iLastDayThisMonth + iOffset; x++, y++) {
                    rgCells[x].innerText = y;
                    rgCells[x].style.backgroundColor = '#FFFFE8';
                }

                for (y = 1; x < rgCells.length; x++, y++) {
                    if (((x + 9) % 7) == 0) {
                        for (x; x < rgCells.length; x++) {
                            rgCells[x].innerText = "";
                        }
                        break;
                    }
                    rgCells[x].innerText = y;
                    rgCells[x].style.backgroundColor = '#F9F9F0';
                }
            }

            if (m_eCalTitle.iMonth == m_objCurDate[iWhichDate].getMonth() && m_eCalTitle.iFullYear == m_objCurDate[iWhichDate].getFullYear()) {
                var rgCells = m_eCalPopup.getElementsByTagName('TD');
                x = iD + m_eCalTitle.idxDayOne;
                rgCells[x].style.backgroundColor = '#F3F3B7';
                m_cellSelTime = rgCells[x];
            }
        }).call(this)
        :
        (function() {
            var x, y;
            var iWhichDate = m_eCalPopup.WHICHDATE;
            var iM = mfBuildMonth.iM;
            var iD = mfBuildMonth.iD;
            var iY = mfBuildMonth.iY;

            if (m_eCalTitle.iMonth != iM || m_eCalTitle.iFullYear != iY) {
                m_eCalTitle.innerHTML = mfFormatDateTitle(iM, iY, m_iCalFormat);
                m_eCalTitle.iMonth = iM;
                m_eCalTitle.iFullYear = iY;
                var iLastDayPrevMonth = (iM == 0) ? mfGetDaysInMonth(12, iY - 1) : mfGetDaysInMonth(iM, iY);
                var iLastDayThisMonth = mfGetDaysInMonth(iM + 1, iY);

                mfBuildMonth.oTempD.setFullYear(iY, iM, 1);
                var iFirstDay = mfBuildMonth.oTempD.getDay();

                if (null != m_cellSelTime) {
                    m_cellSelTime.style.backgroundColor = 'window';
                }
                var iOffset = iFirstDay - this.firstDayOfWeek;
                if (iOffset < 0) {
                    iOffset += 7;
                }
                var rgCells = m_eCalPopup.cells;
                iOffset += 12;

                for (x = 12, y = iLastDayPrevMonth - iOffset + 13; x < iOffset; x++, y++) {
                    rgCells[x].innerText = y;
                    rgCells[x].style.backgroundColor = 'F9F9F0';
                }

                m_eCalTitle.idxDayOne = x - 1;
                for (y = 1; x < iLastDayThisMonth + iOffset; x++, y++) {
                    rgCells[x].innerText = y;
                    rgCells[x].style.backgroundColor = '#FFFFE8';
                }

                for (y = 1; x < rgCells.length; x++, y++) {
                    if (((x + 9) % 7) == 0) {
                        for (x; x < rgCells.length; x++) {
                            rgCells[x].innerText = "";
                        }
                        break;
                    }
                    rgCells[x].innerText = y;
                    rgCells[x].style.backgroundColor = '#F9F9F0';
                }
            }

            if (m_eCalTitle.iMonth == m_objCurDate[iWhichDate].getMonth() && m_eCalTitle.iFullYear == m_objCurDate[iWhichDate].getFullYear()) {
                var rgCells = m_eCalPopup.cells;
                x = iD + m_eCalTitle.idxDayOne;
                rgCells[x].style.backgroundColor = '#F3F3B7';
                m_cellSelTime = rgCells[x];
            }
        }).call(this)
        ;
    }

    function IsLeapYear(yr) {
        if ((yr % 4 == 0) && (yr % 100 != 0) || (yr % 400 == 0))
            return 1;
        else
            return 0;
    }

    function mfGetDaysInMonth(mo, yr) {
        if (mo == 2)
            return 28 + IsLeapYear(yr);
        else
            return 30 + ((mo + (mo > 7)) % 2);
    }

    mfFormatTime.szFormat;
    function mfFormatTime(iMin) {
        var iHr = Math.floor(iMin / 60);
        var iMn = iMin % 60;
        if (null == mfFormatTime.szFormat) mfFormatTime.szFormat = this.pickerTimeFormat;

        var szRet = mfFormatTime.szFormat;
        if (-1 < szRet.search(/\[t/g))
        {
            szRet = szRet.replace(/\[tt\]/g, (iHr > 11 && iHr < 24) ? m_szPMtext : m_szAMtext);
            szRet = szRet.replace(/\[t\]/g, (iHr > 11 && iHr < 24) ? m_szPMtext : m_szAMtext);
        }
        if (-1 < szRet.search(/\[h/g))
        {
            if (iHr > 12) iHr -= 12;
            if (iHr == 0) iHr = 12;
            szRet = szRet.replace(/\[hh\]/g, iHr > 9 ? iHr : "0" + iHr);
            szRet = szRet.replace(/\[h\]/g, iHr);
        }
        if (-1 < szRet.search(/\[H/g))
        {
            szRet = szRet.replace(/\[HH\]/g, iHr > 9 ? iHr : "0" + iHr);
            szRet = szRet.replace(/\[H\]/g, iHr);
        }
        if (-1 < szRet.search(/\[m/g)) {
            szRet = szRet.replace(/\[mm\]/g, iMn > 9 ? iMn : "0" + iMn);
            szRet = szRet.replace(/\[m\]/g, iMn);
        }
        return (szRet);
    }

    function mfFormatDate(objD, szFormat) {
        if (-1 < szFormat.search(/\[M/g)) {
            iX = objD.getMonth() + 1;
            szFormat = szFormat.replace(/\[MMMM\]/g, m_rgMonthNamesLong[iX - 1]);
            szFormat = szFormat.replace(/\[MMM\]/g, m_rgMonthNamesShort[iX - 1]);
            szFormat = szFormat.replace(/\[MM\]/g, iX < 10 ? "0" + iX : iX);
            szFormat = szFormat.replace(/\[M\]/g, iX);
        }
        if (-1 < szFormat.search(/\[d/g)) {
            iX = objD.getDay();
            szFormat = szFormat.replace(/\[dddd\]/g, m_rgDayNamesLong[iX]);
            szFormat = szFormat.replace(/\[ddd\]/g, m_rgDayNamesShort[iX]);
            iX = objD.getDate();
            szFormat = szFormat.replace(/\[dd\]/g, iX > 9 ? iX : "0" + iX);
            szFormat = szFormat.replace(/\[d\]/g, iX);
        }
        if (-1 < szFormat.search(/\[y/g)) {
            var iY = objD.getFullYear();
            var iY2 = iY % 100;

            szFormat = szFormat.replace(/\[yyy+\]/g, iY);
            szFormat = szFormat.replace(/\[y+\]/g, iY2 > 9 ? iY2 : "0" + iY2);
        }
        if (-1 < szFormat.search(/\[h/g))
        {
            iX = objD.getHours();
            if (iX > 12) iX -= 12;
            if (iX == 0) iX = 12;
            szFormat = szFormat.replace(/\[hh\]/g, iX > 9 ? iX : "0" + iX);
            szFormat = szFormat.replace(/\[h\]/g, iX);
        }
        if (-1 < szFormat.search(/\[H/g))
        {
            iX = objD.getHours();
            szFormat = szFormat.replace(/\[HH\]/g, iX > 9 ? iX : "0" + iX);
            szFormat = szFormat.replace(/\[H\]/g, iX);
        }
        if (-1 < szFormat.search(/\[m/g)) {
            iX = objD.getMinutes();
            szFormat = szFormat.replace(/\[mm\]/g, iX > 9 ? iX : "0" + iX);
            szFormat = szFormat.replace(/\[m\]/g, iX);
        }
        if (-1 < szFormat.search(/\[s/g)) {
            iX = objD.getSeconds();
            szFormat = szFormat.replace(/\[ss\]/g, iX > 9 ? iX : "0" + iX);
            szFormat = szFormat.replace(/\[s\]/g, iX);
        }
        if (-1 < szFormat.search(/\[t/g)) {
            iX = objD.getHours();
            szFormat = szFormat.replace(/\[tt\]/g, (iX > 11) ? m_szPMtext : m_szAMtext);
            szFormat = szFormat.replace(/\[t\]/g, (iX > 11) ? m_szPMtext : m_szAMtext);
        }

        return (szFormat);
    }

    function mfOutputDate(fFireChangeEvent, eDestField, iDateTime) {
        if (null == eDestField) {
            return;
        }

        var x, y;
        var iWhichDate = eDestField.WHICHDATE;
        var szFormat = eDestField.FORMATSTRING;

        if (null != szFormat) {
            eDestField.value = mfFormatDate(m_objCurDate[iWhichDate], szFormat)
        }
        else {
            eDestField.value = m_objCurDate[iWhichDate].toLocaleString();
        }

        if (fFireChangeEvent) {
            fireChangeEvent.call(this, iWhichDate, iDateTime);
        }
    }

    function onClickDatePicker(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function(event) {
            if (!event) event = window.event;
            var srcElement = event.target;
            var pDate = new Date();

            event.cancelBubble = true;

            var iWhichDate = null;
            var thisCell = null;
            if (typeof (srcElement.offsetParent.INPUTELEMENT) == "undefined") {
                iWhichDate = srcElement.offsetParent.offsetParent.INPUTELEMENT.WHICHDATE;
                thisCell = srcElement.offsetParent;
            }
            else {
                iWhichDate = srcElement.offsetParent.INPUTELEMENT.WHICHDATE;
                thisCell = srcElement;
            }

            if (null != thisCell.prv) {
                doPrevMonth.call(this);
            }
            else if (null != thisCell.nxt) {
                doNextMonth.call(this);
            }
            if (null != thisCell.prvyear) {
                doPrevYear.call(this);
            }
            else if (null != thisCell.nxtyear) {
                doNextYear.call(this);
            }
            else if (null == thisCell.nop) {
                var iDate = parseInt(srcElement.innerHTML);
                if (isNaN(iDate)) {
                    if ("#F3F3B7" == thisCell.style.backgroundColor.toUpperCase()
                    || "RGB(243, 243, 183)" == thisCell.style.backgroundColor.toUpperCase()) {
                        mfUnPopPicker.call(this);
                    }

                    return;
                }

                thisCell.style.fontWeight = "normal";

                var msDateSpan = m_objCurDate[1] - m_objCurDate[0];

                m_objCurDate[iWhichDate].setFullYear(m_eCalTitle.iFullYear, m_eCalTitle.iMonth, iDate);

                if ((thisCell.style.backgroundColor.toUpperCase() != "#FFFFE8" && thisCell.style.backgroundColor.toUpperCase() != "RGB(255, 255, 232)")
                && (thisCell.style.backgroundColor.toUpperCase() != "#F3F3B7" && thisCell.style.backgroundColor.toUpperCase() != "RGB(243, 243, 183)")) 
                {
                    if (iDate < 15)
                    {
                        m_objCurDate[iWhichDate].setMonth(m_eCalTitle.iMonth + 1, iDate);
                    }
                    else
                    {
                        m_objCurDate[iWhichDate].setMonth(m_eCalTitle.iMonth - 1, iDate);
                    }
                }

                var eDestFld = srcElement.offsetParent.INPUTELEMENT;
                mfOutputDate.call(this, true, eDestFld, 0);

                if (0 == iWhichDate) {
                    if (m_objCurDate[0] > m_objCurDate[1])
                        m_objCurDate[1].setTime(m_objCurDate[0].getTime() + msDateSpan);
                    mfOutputDate.call(this, true, m_rgeInputDate[1], 0);
                }
                else if (m_objCurDate[0] > m_objCurDate[1])
                {
                    m_objCurDate[0].setTime(m_objCurDate[1].getTime() - msDateSpan);
                    mfOutputDate.call(this, true, m_rgeInputDate[0], 0);
                }

                mfWriteEndtimePicker.call(this);
                mfUnPopPicker.call(this);
            }
        }).call(this, event)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(event) {
            if (!event) event = window.event;
            var srcElement = event.target;
            var pDate = new Date();

            event.cancelBubble = true;

            var iWhichDate = null;
            var thisCell = null;
            if (typeof (srcElement.offsetParent.INPUTELEMENT) == "undefined") {
                iWhichDate = srcElement.offsetParent.offsetParent.INPUTELEMENT.WHICHDATE;
                thisCell = srcElement.offsetParent;
            }
            else {
                iWhichDate = srcElement.offsetParent.INPUTELEMENT.WHICHDATE;
                thisCell = srcElement;
            }

            if (null != thisCell.prv) {
                doPrevMonth.call(this);
            }
            else if (null != thisCell.nxt) {
                doNextMonth.call(this);
            }
            if (null != thisCell.prvyear) {
                doPrevYear.call(this);
            }
            else if (null != thisCell.nxtyear) {
                doNextYear.call(this);
            }
            else if (null == thisCell.nop) {
                var iDate = parseInt(srcElement.innerHTML);
                if (isNaN(iDate)) {
                    if ("#F3F3B7" == thisCell.style['background-color'].toUpperCase()
                    || "RGB(243, 243, 183)" == thisCell.style['background-color'].toUpperCase()) {
                        mfUnPopPicker.call(this);
                    }

                    return;
                }

                thisCell.style.fontWeight = "normal";

                var msDateSpan = m_objCurDate[1] - m_objCurDate[0];
                m_objCurDate[iWhichDate].setFullYear(m_eCalTitle.iFullYear, m_eCalTitle.iMonth, iDate);

                if ((thisCell.style['background-color'].toUpperCase() != "#FFFFE8" && thisCell.style['background-color'].toUpperCase() != "RGB(255, 255, 232)")
                && (thisCell.style['background-color'].toUpperCase() != "#F3F3B7" && thisCell.style['background-color'].toUpperCase() != "RGB(243, 243, 183)"))
                {
                    if (iDate < 15)
                    {
                        m_objCurDate[iWhichDate].setMonth(m_eCalTitle.iMonth + 1, iDate);
                    }
                    else
                    {
                        m_objCurDate[iWhichDate].setMonth(m_eCalTitle.iMonth - 1, iDate);
                    }
                }
                var eDestFld = srcElement.offsetParent.INPUTELEMENT;
                mfOutputDate.call(this, true, eDestFld, 0);

                if (0 == iWhichDate) {
                    if (m_objCurDate[0] > m_objCurDate[1])
                        m_objCurDate[1].setTime(m_objCurDate[0].getTime() + msDateSpan);
                    mfOutputDate.call(this, true, m_rgeInputDate[1], 0);
                }
                else if (m_objCurDate[0] > m_objCurDate[1]) 
                {
                    m_objCurDate[0].setTime(m_objCurDate[1].getTime() - msDateSpan);
                    mfOutputDate.call(this, true, m_rgeInputDate[0], 0);
                }

                mfWriteEndtimePicker.call(this);
                mfUnPopPicker.call(this);
            }
        }).call(this, event)
        :
        (function() {
            var pDate = new Date();

            event.cancelBubble = true;

            var iWhichDate = null;
            var thisCell = null;
            if (typeof (event.srcElement.offsetParent.INPUTELEMENT) == "undefined") {
                iWhichDate = event.srcElement.offsetParent.offsetParent.INPUTELEMENT.WHICHDATE;
                thisCell = event.srcElement.offsetParent;
            }
            else {
                iWhichDate = event.srcElement.offsetParent.INPUTELEMENT.WHICHDATE;
                thisCell = event.srcElement;
            }

            if (null != thisCell.prv) {
                doPrevMonth.call(this);
            }
            else if (null != thisCell.nxt) {
                doNextMonth.call(this);
            }
            if (null != thisCell.prvyear) {
                doPrevYear.call(this);
            }
            else if (null != thisCell.nxtyear) {
                doNextYear.call(this);
            }
            else if (null == thisCell.nop) {
                var iDate = parseInt(event.srcElement.innerHTML);
                if (isNaN(iDate)) {
                    if ("#F3F3B7" == thisCell.style.backgroundColor.toUpperCase()) {
                        mfUnPopPicker.call(this);
                    }

                    return;
                }

                thisCell.style.fontWeight = "normal";

                var msDateSpan = m_objCurDate[1] - m_objCurDate[0];
                m_objCurDate[iWhichDate].setFullYear(m_eCalTitle.iFullYear, m_eCalTitle.iMonth, iDate);

                if ((thisCell.style.backgroundColor.toUpperCase() != "#FFFFE8" && thisCell.style.backgroundColor.toUpperCase() != "RGB(255, 255, 232)")
                && (thisCell.style.backgroundColor.toUpperCase() != "#F3F3B7" && thisCell.style.backgroundColor.toUpperCase() != "RGB(243, 243, 183)"))
                {
                    if (iDate < 15)
                    {
                        m_objCurDate[iWhichDate].setMonth(m_eCalTitle.iMonth + 1, iDate);
                    }
                    else
                    {
                        m_objCurDate[iWhichDate].setMonth(m_eCalTitle.iMonth - 1, iDate);
                    }
                }

                var eDestFld = event.srcElement.offsetParent.INPUTELEMENT;
                mfOutputDate.call(this, true, eDestFld, 0);

                if (0 == iWhichDate) {
                    if (m_objCurDate[0] > m_objCurDate[1])
                        m_objCurDate[1].setTime(m_objCurDate[0].getTime() + msDateSpan);
                    mfOutputDate.call(this, true, m_rgeInputDate[1], 0);
                }
                else if (m_objCurDate[0] > m_objCurDate[1])
                {
                    m_objCurDate[0].setTime(m_objCurDate[1].getTime() - msDateSpan);
                    mfOutputDate.call(this, true, m_rgeInputDate[0], 0);
                }

                mfWriteEndtimePicker.call(this);
                mfUnPopPicker.call(this);
            }
        }).call(this)
        ;
    }


    var lastCell = null;
    function onMouseOverDatePicker(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function(event) {
            if (!event) event = window.event;
            var thisCell = event.target;
            if (lastCell != null) {
                lastCell.style.fontWeight = "normal";
            }
            if ((thisCell.className == "datecell" || thisCell.className == "timecell") && thisCell.innerText != "") {
                thisCell.style.fontWeight = "bold";
                lastCell = thisCell;
            }
        }).call(this, event)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(event) {
            if (!event) event = window.event;
            var thisCell = event.target;
            if (lastCell != null) {
                lastCell.style.fontWeight = "normal";
            }
            if ((thisCell.className == "datecell" || thisCell.className == "timecell") && thisCell.innerText != "") {
                thisCell.style.fontWeight = "bold";
                lastCell = thisCell;
            }
        }).call(this, event)
        :
        (function() {
            var thisCell = event.srcElement;
            if (lastCell != null) {
                lastCell.style.fontWeight = "normal";
            }
            if ((thisCell.className == "datecell" || thisCell.className == "timecell") && thisCell.innerText != "") {
                thisCell.style.fontWeight = "bold";
                lastCell = thisCell;
            }
        }).call(this)
        ;
    }

    function onClickBtnDate(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function(event) {
            if (!event) event = window.event;

            mfUnPopPicker.call(this);
            if (null == m_eCalPopup) mfCreateCalendar.call(this);
            mfPopPicker.call(this, m_eCalPopup, event);
        }).call(this, event)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(event) {
            if (!event) event = window.event;

            mfUnPopPicker.call(this);
            if (null == m_eCalPopup) mfCreateCalendar.call(this);
            mfPopPicker.call(this, m_eCalPopup, event);
        }).call(this, event)
        :
        (function() {
            mfUnPopPicker.call(this);
            if (null == m_eCalPopup) mfCreateCalendar.call(this);
            mfPopPicker.call(this, m_eCalPopup);
        }).call(this)
        ;
    }
    function onClickBtnTime(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function(event) {
            if (!event) event = window.event;
            var srcElement = event.target;

            mfUnPopPicker.call(this);
            if (null == m_eTimePopup) mfCreateTimepicker.call(this);
            if (null == srcElement.WHICHDATE || 0 == srcElement.WHICHDATE) {
                mfPopPicker.call(this, m_eTimePopup, event);
            }
            else {
                if (m_fUpdateEndtimepicker) {
                    mfWriteEndtimePicker.call(this);
                    m_fUpdateEndtimepicker = false;
                }
                mfPopPicker.call(this, m_eEndTimePopup, event);
            }
        }).call(this, event)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(event) {
            if (!event) event = window.event;
            var srcElement = event.target;

            mfUnPopPicker.call(this);
            if (null == m_eTimePopup) mfCreateTimepicker.call(this);
            if (null == srcElement.WHICHDATE || 0 == srcElement.WHICHDATE) {
                mfPopPicker.call(this, m_eTimePopup, event);
            }
            else {
                if (m_fUpdateEndtimepicker) {
                    mfWriteEndtimePicker.call(this);
                    m_fUpdateEndtimepicker = false;
                }
                mfPopPicker.call(this, m_eEndTimePopup, event);
            }
        }).call(this, event)
        :
        (function() {
            mfUnPopPicker.call(this);
            if (null == m_eTimePopup) mfCreateTimepicker.call(this);
            if (null == event.srcElement.WHICHDATE || 0 == event.srcElement.WHICHDATE) {
                mfPopPicker.call(this, m_eTimePopup);
            }
            else {
                if (m_fUpdateEndtimepicker) {
                    mfWriteEndtimePicker();
                    m_fUpdateEndtimepicker = false;
                }
                mfPopPicker.call(this, m_eEndTimePopup);
            }
        }).call(this)
        ;
    }

    var m_cellSelTime;
    var m_lastDateDiv;
    mfPopPicker.hideElements;

    function mfPopPicker(ePicker, event) {
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function(ePicker, event) {
            if (!event) event = window.event;
            event.cancelBubble = true;
            var eSrc = event.target;
            var iX = 0, iY = 0;
            var iLoc;
            var szPoplocation = 'bottomright';
            if (GetAttribute(eSrc, 'popuplocation') != null && GetAttribute(eSrc, 'popuplocation') != "") {
                szPoplocation = GetAttribute(eSrc, 'popuplocation').toLowerCase();
            }
            ePicker.style.zIndex = "10000";
            switch (szPoplocation) {
                case "topright":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX + eSrc.offsetWidth + m_winDocBody.scrollLeft + 210) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY - eSrc.offsetHeight + m_winDocBody.scrollTop + 120) + 'px';

                    if (typeof (GetAttribute(eSrc, 'forceMarginTop')) != "undefined" && GetAttribute(eSrc, 'forceMarginTop') != null) {
                        ePicker.style.top = String(parseInt(ePicker.style.top) + parseInt(GetAttribute(eSrc, 'forceMarginTop'))) + 'px';
                    }

                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    break
                case "bottomright":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX + eSrc.offsetWidth + m_winDocBody.scrollLeft) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY + eSrc.offsetHeight + m_winDocBody.scrollTop - 50) + 'px';
                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    break
                case "topleft":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX + -ePicker.offsetWidth + m_winDocBody.scrollLeft) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY - ePicker.offsetHeight + m_winDocBody.scrollTop) + 'px';

                    if (typeof (eSrc.forceMarginLeft) != "undefined" && eSrc.forceMarginLeft != null) {
                        ePicker.style.left = String(ePicker.style.left + parseInt(eSrc.forceMarginLeft)) + 'px';
                    }

                    if (typeof (eSrc.forceMarginTop) != "undefined" && eSrc.forceMarginTop != null) {
                        ePicker.style.top = String(ePicker.style.top + parseInt(eSrc.forceMarginTop)) + 'px';
                    }

                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                default:
                case "bottomleft":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX - ePicker.offsetWidth + m_winDocBody.scrollLeft) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY + eSrc.offsetHeight + m_winDocBody.scrollTop) + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break
                case "topcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY - ePicker.offsetHeight + m_winDocBody.scrollTop) + 'px';
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                case "bottomcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY + eSrc.offsetHeight + m_winDocBody.scrollTop) + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
            }

            var iWhichDate = event.target.WHICHDATE;
            if (ePicker.tagName.search(/TABLE/i) == -1) 
            {
                ePicker.focus();
                var getMin = (m_objCurDate[iWhichDate].getMinutes() > 30 || m_objCurDate[iWhichDate].getMinutes() == 0) ? 0 : 30;
                iX = (m_objCurDate[iWhichDate].getHours() * 2) - ((getMin > 29) ? 0 : 1) + 1;
                iX -= ePicker.children[0].value / 30;
                if (iX < 0) {
                    iX += 48;
                }
                iY = (iX > 2) ? 2 : 0;
                ePicker.children[m_eTimePopup.children.length - 1].selected = 'true';
                ePicker.children[iX - iY].selected = 'true';
                iX = (iX > 47) ? 0 : Math.ceil(iX);
                ePicker.children[iX].selected = 'true';
                ePicker.INPUTELEMENT = event.target.INPUTELEMENT;
                ePicker.addEventListener("click", onClickTimePicker, false);
                m_winDocBody.addEventListener("click", mfUnPopPicker, false);
            }
            else {
                m_eCalPopup.INPUTELEMENT = event.target.INPUTELEMENT;
                m_eCalPopup.WHICHDATE = iWhichDate;
                mfFillCalendar.call(this, iWhichDate);
                m_eCalPopup.addEventListener("mouseover", onMouseOverDatePicker, false);
                m_eCalPopup.addEventListener("click", onClickDatePicker, false);
                m_winDocBody.addEventListener("click", mfUnPopPicker, false);
                m_winDocBody.addEventListener("mouseout", onMouseOutBody, false);
            }
            if (eSrc.HIDEELEMENTS != null && eSrc.HIDEELEMENTS != "") {
                mfPopPicker.hideElements = eSrc.HIDEELEMENTS;
                document.getElementById(eSrc.HIDEELEMENTS).style.display = "none";
            }
            ePicker.style.zIndex = "10000";
            switch (szPoplocation) {
                case "topright":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX + eSrc.offsetWidth + m_winDocBody.scrollLeft + 210) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY - eSrc.offsetHeight + m_winDocBody.scrollTop + 120) + 'px';

                    if (typeof (GetAttribute(eSrc, 'forceMarginTop')) != "undefined" && GetAttribute(eSrc, 'forceMarginTop') != null) {
                        ePicker.style.top = String(parseInt(ePicker.style.top) + parseInt(GetAttribute(eSrc, 'forceMarginTop'))) + 'px';
                    }

                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    break
                case "bottomright":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX + eSrc.offsetWidth + m_winDocBody.scrollLeft) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY + eSrc.offsetHeight + m_winDocBody.scrollTop) + 'px';
                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    break
                case "topleft":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX + -ePicker.offsetWidth + m_winDocBody.scrollLeft) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY - ePicker.offsetHeight + m_winDocBody.scrollTop) + 'px';

                    if (typeof (eSrc.forceMarginLeft) != "undefined" && eSrc.forceMarginLeft != null) {
                        ePicker.style.left = String(ePicker.style.left + parseInt(eSrc.forceMarginLeft)) + 'px';
                    }

                    if (typeof (eSrc.forceMarginTop) != "undefined" && eSrc.forceMarginTop != null) {
                        ePicker.style.top = String(ePicker.style.top + parseInt(eSrc.forceMarginTop)) + 'px';
                    }

                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                default:
                case "bottomleft":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX - ePicker.offsetWidth + m_winDocBody.scrollLeft) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY + eSrc.offsetHeight + m_winDocBody.scrollTop) + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break
                case "topcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY - ePicker.offsetHeight + m_winDocBody.scrollTop) + 'px';
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                case "bottomcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = String(event.clientX - event.layerX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft) + 'px';
                    ePicker.style.top = String(event.clientY - event.layerY + eSrc.offsetHeight + m_winDocBody.scrollTop) + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
            }
        }).call(this, ePicker, event)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(ePicker, event) {
            if (!event) event = window.event;
            event.cancelBubble = true;
            var eSrc = event.target;
            var iX = 0, iY = 0;
            var iLoc;
            var szPoplocation = 'bottomright';
            if (GetAttribute(eSrc, 'popuplocation') != null && GetAttribute(eSrc, 'popuplocation') != "") {
                szPoplocation = GetAttribute(eSrc, 'popuplocation').toLowerCase();
            }
            ePicker.style.zIndex = "10000";
            switch (szPoplocation) {
                case "topright":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + eSrc.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - eSrc.offsetHeight + m_winDocBody.scrollTop - 60 + 'px';

                    if (typeof (eSrc.forceMarginTop) != "undefined" && eSrc.forceMarginTop != null) {
                        ePicker.style.top = ePicker.style.top + parseInt(eSrc.forceMarginTop) + 'px';
                    }

                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    break
                case "bottomright":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + eSrc.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop - 50 + 'px';
                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    break
                case "topleft":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + -ePicker.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - ePicker.offsetHeight + m_winDocBody.scrollTop + 'px';

                    if (typeof (eSrc.forceMarginLeft) != "undefined" && eSrc.forceMarginLeft != null) {
                        ePicker.style.left = ePicker.style.left + parseInt(eSrc.forceMarginLeft) + 'px';
                    }

                    if (typeof (eSrc.forceMarginTop) != "undefined" && eSrc.forceMarginTop != null) {
                        ePicker.style.top = ePicker.style.top + parseInt(eSrc.forceMarginTop) + 'px';
                    }

                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                default:
                case "bottomleft":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - ePicker.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break
                case "topcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - ePicker.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                case "bottomcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
            }

            var iWhichDate = event.target.WHICHDATE;
            if (ePicker.tagName.search(/TABLE/i) == -1) 
            {
                ePicker.focus();
                var getMin = (m_objCurDate[iWhichDate].getMinutes() > 30 || m_objCurDate[iWhichDate].getMinutes() == 0) ? 0 : 30;
                iX = (m_objCurDate[iWhichDate].getHours() * 2) - ((getMin > 29) ? 0 : 1) + 1;
                iX -= ePicker.children[0].value / 30;
                if (iX < 0) {
                    iX += 48;
                }
                iY = (iX > 2) ? 2 : 0;
                ePicker.children.item(m_eTimePopup.children.length - 1).selected = 'true';
                ePicker.children.item(iX - iY).selected = 'true';
                iX = (iX > 47) ? 0 : Math.ceil(iX);
                ePicker.children.item(iX).selected = 'true';
                ePicker.INPUTELEMENT = event.target.INPUTELEMENT;
                ePicker.addEventListener("click", onClickTimePicker, false);
                m_winDocBody.addEventListener("click", mfUnPopPicker, false);
            }
            else {
                m_eCalPopup.INPUTELEMENT = event.target.INPUTELEMENT;
                m_eCalPopup.WHICHDATE = iWhichDate;
                mfFillCalendar.call(this, iWhichDate);
                m_eCalPopup.addEventListener("mouseover", onMouseOverDatePicker, false);
                m_eCalPopup.addEventListener("click", onClickDatePicker, false);
                m_winDocBody.addEventListener("click", mfUnPopPicker, false);
                m_winDocBody.addEventListener("mouseout", onMouseOutBody, false);
            }
            if (eSrc.HIDEELEMENTS != null && eSrc.HIDEELEMENTS != "") {
                mfPopPicker.hideElements = eSrc.HIDEELEMENTS;
                document.getElementById(eSrc.HIDEELEMENTS).style.display = "none";
            }
            ePicker.style.zIndex = "10000";
            switch (szPoplocation) {
                case "topright":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + eSrc.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - eSrc.offsetHeight + m_winDocBody.scrollTop - 60 + 'px';

                    if (typeof (eSrc.forceMarginTop) != "undefined" && eSrc.forceMarginTop != null) {
                        ePicker.style.top = ePicker.style.top + parseInt(eSrc.forceMarginTop) + 'px';
                    }

                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    break
                case "bottomright":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + eSrc.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    break
                case "topleft":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + -ePicker.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - ePicker.offsetHeight + m_winDocBody.scrollTop + 'px';

                    if (typeof (eSrc.forceMarginLeft) != "undefined" && eSrc.forceMarginLeft != null) {
                        ePicker.style.left = ePicker.style.left + parseInt(eSrc.forceMarginLeft) + 'px';
                    }
                    if (typeof (eSrc.forceMarginTop) != "undefined" && eSrc.forceMarginTop != null) {
                        ePicker.style.top = ePicker.style.top + parseInt(eSrc.forceMarginTop) + 'px';
                    }

                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                default:
                case "bottomleft":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - ePicker.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break
                case "topcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - ePicker.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                case "bottomcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
            }
        }).call(this, ePicker, event)
        :
        (function(ePicker, event) {
            if (!event) event = window.event;
            event.cancelBubble = true;
            var eSrc = event.srcElement;
            var iX = 0, iY = 0;
            var iLoc;
            var szPoplocation = 'bottomright';

            if (GetAttribute(eSrc, 'popuplocation') != null && GetAttribute(eSrc, 'popuplocation') != "") {
                szPoplocation = GetAttribute(eSrc, 'popuplocation').toLowerCase();
            }
            ePicker.style.zIndex = "10000";
            switch (szPoplocation) {
                case "topright":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + eSrc.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - eSrc.offsetHeight + m_winDocBody.scrollTop - 60 + 'px';

                    if (typeof (eSrc.forceMarginTop) != "undefined" && eSrc.forceMarginTop != null) {
                        ePicker.style.top = ePicker.style.top + parseInt(eSrc.forceMarginTop) + 'px';
                    }

                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    break
                case "bottomright":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + eSrc.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop - 50 + 'px';
                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    break
                case "topleft":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + -ePicker.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - ePicker.offsetHeight + m_winDocBody.scrollTop + 'px';

                    if (typeof (eSrc.forceMarginLeft) != "undefined" && eSrc.forceMarginLeft != null) {
                        ePicker.style.left = ePicker.style.left + parseInt(eSrc.forceMarginLeft) + 'px';
                    }

                    if (typeof (eSrc.forceMarginTop) != "undefined" && eSrc.forceMarginTop != null) {
                        ePicker.style.top = ePicker.style.top + parseInt(eSrc.forceMarginTop) + 'px';
                    }

                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                default:
                case "bottomleft":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - ePicker.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break
                case "topcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - ePicker.offsetHeight + m_winDocBody.scrollTop; + 'px';
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                case "bottomcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
            }

            var iWhichDate = event.srcElement.WHICHDATE;
            if (ePicker.tagName.search(/TABLE/i) == -1) 
            {
                ePicker.focus();
                iX = (m_objCurDate[iWhichDate].getHours() * 2) - ((m_objCurDate[iWhichDate].getMinutes() > 29) ? 0 : 1) + 1;
                iX -= ePicker.children[0].value / 30; 
                if (iX < 0) {
                    iX += 48;
                }
                iY = (iX > 2) ? 2 : 0;
                ePicker.children(m_eTimePopup.children.length - 1).selected = 'true';
                ePicker.children(iX - iY).selected = 'true';
                iX = (iX > 47) ? 0 : Math.ceil(iX);
                ePicker.children(iX).selected = 'true';
                ePicker.INPUTELEMENT = event.srcElement.INPUTELEMENT;
                ePicker.attachEvent("onclick", onClickTimePicker);
                m_winDocBody.attachEvent("onclick", mfUnPopPicker);
            }
            else {
                m_eCalPopup.INPUTELEMENT = event.srcElement.INPUTELEMENT;
                m_eCalPopup.WHICHDATE = iWhichDate;
                mfFillCalendar.call(this, iWhichDate);
                m_eCalPopup.attachEvent("onmouseover", onMouseOverDatePicker);
                m_eCalPopup.attachEvent("onclick", onClickDatePicker);
                m_winDocBody.attachEvent("onclick", mfUnPopPicker);
                m_winDocBody.attachEvent("onmouseout", onMouseOutBody);
            }
            if (eSrc.HIDEELEMENTS != null && eSrc.HIDEELEMENTS != "") {
                mfPopPicker.hideElements = eSrc.HIDEELEMENTS;
                m_winDocAll[eSrc.HIDEELEMENTS].style.display = "none";
            }
            ePicker.style.zIndex = "10000";
            switch (szPoplocation) {
                case "topright":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + eSrc.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - eSrc.offsetHeight + m_winDocBody.scrollTop - 80 + 'px';

                    if (typeof (eSrc.forceMarginTop) != "undefined" && eSrc.forceMarginTop != null) {
                        ePicker.style.top = ePicker.style.top + parseInt(eSrc.forceMarginTop) + 'px';
                    }

                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    break
                case "bottomright":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + eSrc.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (!fIsRoom(iX, iY, 'right')) iX -= m_iCalWidth + m_iBtnWidth;
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    break
                case "topleft":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX + -ePicker.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - ePicker.offsetHeight + m_winDocBody.scrollTop - 60 + 'px';

                    if (typeof (eSrc.forceMarginLeft) != "undefined" && eSrc.forceMarginLeft != null) {
                        ePicker.style.left = ePicker.style.left + parseInt(eSrc.forceMarginLeft) + 'px';
                    }

                    if (typeof (eSrc.forceMarginTop) != "undefined" && eSrc.forceMarginTop != null) {
                        ePicker.style.top = ePicker.style.top + parseInt(eSrc.forceMarginTop) + 'px';
                    }

                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                default:
                case "bottomleft":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - ePicker.offsetWidth + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break
                case "topcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY - ePicker.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (iY < m_winDocBody.scrollTop) iY += m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
                case "bottomcenter":
                    ePicker.style.display = "";
                    ePicker.style.left = event.clientX - event.offsetX - (ePicker.offsetWidth / 2) + m_winDocBody.scrollLeft + 'px';
                    ePicker.style.top = event.clientY - event.offsetY + eSrc.offsetHeight + m_winDocBody.scrollTop + 'px';
                    if (!fIsRoom(iX, iY, 'bottom')) iY -= m_iCalHeight + m_iBtnHeight;
                    if (iX < m_winDocBody.scrollLeft) iX += m_iCalWidth + m_iBtnWidth;
                    break;
            }
        }).call(this, ePicker, event)
        ;
    }

    function onMouseOutBody(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('Firefox') != -1) ?
        (function(event) {
            if (!event) event = window.event;
            if (null == event.originalTarget) {
                mfUnPopPicker.call(this);
            }
        }).call(this, event)
        : (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(event) {
            if (!event) event = window.event;
            if (null == event.toElement) {
                mfUnPopPicker.call(this);
            }
        }).call(this, event)
        :
        (function() {
            if (null == event.toElement) {
                mfUnPopPicker.call(this);
            }
        }).call(this)
        ;
    }

    function fIsRoom(iLeft, iTop, iWhere) {
        var fRet = true;
        switch (iWhere) {
            case 'bottom':
                if (m_winDocBody.offsetHeight - (iTop - m_winDocBody.scrollTop) < m_iCalHeight) fRet = false;
                break;
            case 'right':
                if (m_winDocBody.offsetWidth - (iLeft - m_winDocBody.scrollLeft) < m_iCalWidth) fRet = false;
                break;
        }
        return (fRet)
    }

    mfParseTime.time;
    mfParseTime.ampm;
    function mfParseTime(szTime) {
        if (null == mfParseTime.time) {
            var szExpT = "([012]?[0-9]|2[0-4])([:.]([0-5]?[0-9])([:.]([0-5]?[0-9])?)?)?";
            mfParseTime.time = new RegExp(szExpT, "gi");
            mfParseTime.ampm = new RegExp("(" + m_szAMtext + "|" + m_szAMtext.substring(0, 1) + ")|(" + m_szPMtext + "|" + m_szPMtext.substring(0, 1) + ")", "gi");
        }

        mfParseTime.time.lastIndex = 0;
        mfParseTime.ampm.lastIndex = 0;
        var hms = mfParseTime.time.exec(szTime);
        if (null == hms) {
            return (-1);
        }
        var ampm = mfParseTime.ampm.exec(szTime);
        var fIsPM = (null != ampm && "" != ampm[2]);
        var iSec = Number(hms[5]);
        var iMin = Number((iSec > 30) ? hms[3]++ : hms[3]);
        var iHr = (12 > hms[1] && fIsPM) ? (Number(hms[1]) + 12) : Number(hms[1]);
        if (iHr == 12 && !fIsPM) iHr = 0;
        return ((iHr * 60) + iMin);
    }
}

function isie9() {
    var _MSIE = 'MSIE';
    var useragentstr = navigator.userAgent;
    if (useragentstr.indexOf(_MSIE) != -1) {
        var str1 = useragentstr.substring(useragentstr.indexOf(_MSIE), useragentstr.length);
        var arr = str1.split(';');
        var verstr = arr[0].split(' ')[1];
        var version = parseFloat(verstr);
        if (version >= 9)
        {
            return true;
        }
        else {
            return false;
        }
    }
    return false;
}