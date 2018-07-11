var eopi = "false";
var eattach = "false";
var balsongopi = "";
var tempType;
function SendMailClick(Type, DocID, Mode) {
    var rtnVal = "";
    tempType = Type;
    if (Mode != "") {
        rtnVal = getdetails(DocID, Mode);
    }

    if ((CrossYN()) || rtnVal == "close")
        if (Mode != "")
            return;

    var bodycontent = "";
    if (Type == "FormProc") {
        bodycontent = pzFormProc.Editor.DOM.body.innerHTML + rtnVal;
    }
    else if (Type == "Cross") {
        bodycontent = message.Get_EditorBodyHTML() + rtnVal;
    }
    else if (Type == "Enforce") {
        bodycontent = message2.Get_EditorBodyHTML() + rtnVal;
    }

    PrtBodyContent = bodycontent;
}
/**
 * 작성된 '의견' 내용 불러오기
 * */
function addOpinion(DocID, pFlag) {
	var rowidx, rtnString, colidx;
	if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING") {
		pFlag = "APR";
	} else {
		pFlag = "END";
	}
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getOpinionInfo.do",
		data : {
			docID : DocID,
			mode  : pFlag
		},
		success: function(xml){
			result = xml;
		}        			
	});

    xmlrtn = loadXMLString(result);
    var Rows = SelectNodes(xmlrtn, "LISTVIEWDATA/ROWS/ROW");
    if (Rows.length == 0) {
        eopi = "false";
    }

    rtnString = "";
    for (rowidx = 0; rowidx < Rows.length; rowidx++) {
        eopi = "true";

        rtnString = rtnString + "<TR style='height:25px'>";
        for (colidx = 0; colidx < GetChildNodes(Rows[rowidx]).length; colidx++) {
            if (colidx == 0)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:60px;' bgColor=#d2e2fd align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else if (colidx == 1)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:60px' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else if (colidx == 3)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:30px' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else if (colidx == 4)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:100px' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:373px'>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
        }
        rtnString = rtnString + "</TR>";
    }

    if (balsongopi != "") {
        eopi = "true";
    }

    return rtnString;
}

var temptextOpi;
var temptextAttatch;
var tempDocID;
var temppFlag;
function getdetails(DocID, pFlag) {
    var textOpi = addOpinion(DocID, pFlag);     // 의견정보 추출
   
    
    if (CrossYN()) {
        temptextOpi = textOpi;
        tempDocID = DocID;
        temppFlag = pFlag;
    }
    var ret = OpenMailQuestionUI();
    if ((CrossYN()) || !ret)
        return;

    if (ret[0] == "0" && ret[1] == "0" && ret[2] == "0")
        return "close";
    var rtnVal = "";
    
    if (ret[0] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:" + strLang9 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='5'><P>" + "▶ " + strLan880 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + textOpi;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[1] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:" + strLang9 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='4'><P>" + "▶ " + strLang1148 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + textAttatch;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[2] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:" + strLang9 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='7'><P>" + "▶ " + strLang1149 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + addLineInfo(DocID, pFlag);
        rtnVal = rtnVal + "</table>";
    }

    return rtnVal;
}

var ezmailquestion_cross_dialogArguments = new Array();
/**
 * 범위 옵션 화면 출력(의견만)
 * */
function OpenMailQuestionUI() {
    var parameter = "";
    var url = "/ezApprovalG/ezAprOpinionSend.do";

    if (CrossYN()) {
    	ezmailquestion_cross_dialogArguments[0] = parameter;
    	ezmailquestion_cross_dialogArguments[1] = OpenMailQuestionUI_Complete;

        DivPopUpShow(380, 260, url);
    }
    else {
        var feature = "status:no;dialogWidth:380px;dialogHeight:260px;help:no;";
        feature = feature + GetShowModalPosition(380, 260);
        var RtnVal = window.showModalDialog(url, parameter, feature);

        return RtnVal;
    }
}

function OpenMailQuestionUI_Complete(ret) {
    DivPopUpHidden();

    if (ret[0] == "0")
        return;
    var rtnVal = "";
    if (ret[0] == "T") {
    	attachOpinion();
    }
    attachAppr();
}

// 메일에 의견을 첨부
var div;
function attachOpinion(){
	includeOpinion = false;
	var NodeList = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
	var p = document.createElement("p"); p.id="opTitle";
	var table = document.createElement("table");
	
	div = document.createElement("div");
	div.id ="opinionCont";
	p.append(document.createTextNode("▶ " + strLang880 + " ◀"));
	table.append(p);
	table.id="opinions";
	
	for(var i=0; i<NodeList.length; i++) {
		var tr = document.createElement("tr");
		var td1 = document.createElement("td");	td1.id="td1";
		var td2 = document.createElement("td"); td2.id="td2";
		var td3 = document.createElement("td"); td3.id="td3";
		var td4 = document.createElement("td"); td4.id="td4";
		var td5 = document.createElement("td"); td5.id="td5";
		td1.append(document.createTextNode(NodeList[i].children[0].childNodes[0].innerHTML));							//  의견종류
		td2.append(document.createTextNode(NodeList[i].children[0].childNodes[7].innerHTML.substring(9).slice(0,-3)));	// 	이름
		td3.append(document.createTextNode(NodeList[i].children[0].childNodes[3].innerHTML.substring(9).slice(0,-3)));	//	의견
		td3.id="td3";
		td4.append(document.createTextNode(NodeList[i].children[0].childNodes[9].innerHTML.substring(9).slice(0,-3)));	//	직위
		td5.append(document.createTextNode(NodeList[i].children[0].childNodes[11].innerHTML.substring(9).slice(0,-3)));	//	부서
		tr.append(td1);tr.append(td2);tr.append(td3);tr.append(td4);tr.append(td5);
		table.append(tr);
	}
	div.append(table);
	
	var sheet = document.createElement('style')
	sheet.innerHTML = "#opTitle {margin-top:60px; font-family: 굴림; font-size: 9pt; width:90px;}" +
					"#opinions {margin: 0 auto; width:628px;  border-collapse: collapse; border-spacing: 0; margin-top:20px; border-color:grey;}" + 
					"td{text-align:center; font-size:9pt; border:1px solid #000; height:25px; border-collapse: separate;}" +
					"#td1{background-color:#d2e2fd; width:60px;} #td2{width:60px;} #td3{text-align:left; width:373px;} #td4{width:30px;} #td5{width:100px;}";
	document.getElementById("message").contentWindow.document.getElementById("BodyContent").append(div);
	document.getElementById("message").contentWindow.document.body.appendChild(sheet);
} 

//메일에 전자결재 doc을 첨부
function attachAppr(bodycontent) {
	console.log(bodycontent);
	var imgUrl="";
	html2canvas(document.getElementById("message").contentWindow.document.getElementById("div_Content"), {
	background:'#fff',onrendered: function(canvas) {
	    $.ajax({
            type:"POST",
            dataType:"text",
            data : {
            	imgUrl : canvas.toDataURL("image/png"),
            	docID: pDocID
            },
            url: "/ezApprovalG/createMailImg.do",
            success: function (data) {
            }
        });
		  }
		});
	  var pheight = window.screen.availHeight;
      var conHeight = pheight * 0.8;
      var pwidth = window.screen.availWidth;
      var pTop = (pheight - conHeight) / 2;
      var pLeft = (pwidth - 890) / 2;
      var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocID + "&docHref=" + encodeURIComponent(pDocHref);
      var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
      document.getElementById("message").contentWindow.document.getElementById("opinionCont").remove();
      newwin.focus();
}