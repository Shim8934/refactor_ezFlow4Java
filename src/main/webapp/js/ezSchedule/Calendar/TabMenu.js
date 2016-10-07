var Tab1_SelectID = "";
var Tab1_flag = true;
function Tab1_MouserOver(obj) {
    obj.className = "tabover";
}
function Tab1_MouserOut(obj) {
    if (Tab1_SelectID != obj.id)
        obj.className = "";
}
function Tab1_MouseClick(obj) {
    obj.className = "tabon";
    if (obj.id != Tab1_SelectID) {
        if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
            document.getElementById(Tab1_SelectID).className = "";

        obj.className = "tabon";
        Tab1_SelectID = obj.id;
        
    }
    ChangeTab(obj);
}
function Tab1_NewTabIni(pTabNodeID) {
    for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
        if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
            if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;

                if (Tab1_flag) {
                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
                    Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
                    Tab1_flag = false;
                }

            }
        }
    }
}
var Tab2_SelectID = "";
var Tab2_flag = true;
function Tab2_MouserOver(obj) {
    obj.className = "tabover";
}
function Tab2_MouserOut(obj) {
    if (Tab2_SelectID != obj.id)
        obj.className = "";
}
function Tab2_MouseClick(obj) {
    obj.className = "tabon";
    if (obj.id != Tab2_SelectID) {
        if (Tab2_SelectID != "")
            document.getElementById(Tab2_SelectID).className = "";

        obj.className = "tabon";
        Tab2_SelectID = obj.id;
        ChangeLineTab(obj.getAttribute("divname"));
    }
}
function Tab2_NewTabIni(pTabNodeID) {
    for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
        if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
            if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab2_MouserOver(this); };;
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab2_MouserOut(this); };;
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab2_MouseClick(this); };;
                if (Tab2_flag) {
                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
                    Tab2_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
                    Tab2_flag = false;
                }
            }
        }
    }
}
var Tab3_SelectID = "";
var Tab3_flag = true;
function Tab3_MouserOver(obj) {
    obj.className = "tabover";
}
function Tab3_MouserOut(obj) {
    if (Tab3_SelectID != obj.id)
        obj.className = "";
}
function Tab3_MouseClick(obj) {
    obj.className = "tabon";
    if (obj.id != Tab3_SelectID) {
        if (Tab3_SelectID != "")
            document.getElementById(Tab3_SelectID).className = "";

        obj.className = "tabon";
        Tab3_SelectID = obj.id;
        ChangeReceptTab(obj);
    }
}
function Tab3_NewTabIni(pTabNodeID) {
    for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
        if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
            if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab3_MouserOver(this); };;
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab3_MouserOut(this); };;
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab3_MouseClick(this); };;
                if (Tab3_flag) {
                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
                    Tab3_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
                    Tab3_flag = false;
                }
            }
        }
    }
}
var Tab4_SelectID = "";
var Tab4_flag = true;
function Tab4_MouserOver(obj) {
    obj.className = "tabover";
}
function Tab4_MouserOut(obj) {
    if (Tab4_SelectID != obj.id)
        obj.className = "";
}
function Tab4_MouseClick(obj) {
    obj.className = "tabon";
    if (obj.id != Tab4_SelectID) {
        if (Tab4_SelectID != "")
            document.getElementById(Tab4_SelectID).className = "";

        obj.className = "tabon";
        Tab4_SelectID = obj.id;
    }
}
function Tab4_NewTabIni(pTabNodeID) {
    for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
        if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab4_MouserOver(this); };;
            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab4_MouserOut(this); };;
            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab4_MouseClick(this); };;
            if (Tab4_flag) {
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
                Tab4_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
                Tab4_flag = false;
            }
        }
    }
}
var Tab5_SelectID = "";
var Tab5_flag = true;
function Tab5_MouserOver(obj) {
    obj.className = "tabover";
}
function Tab5_MouserOut(obj) {
    if (Tab5_SelectID != obj.id)
        obj.className = "";
}
function Tab5_MouseClick(obj) {
    obj.className = "tabon";
    if (obj.id != Tab5_SelectID) {
        if (Tab5_SelectID != "")
            document.getElementById(Tab5_SelectID).className = "";

        obj.className = "tabon";
        Tab5_SelectID = obj.id;
    }
}
function Tab5_NewTabIni(pTabNodeID) {
    for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
        if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab5_MouserOver(this); };;
            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab5_MouserOut(this); };;
            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab5_MouseClick(this); };;
            if (Tab5_flag) {
                document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
                Tab5_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
                Tab5_flag = false;
            }
        }
    }
}