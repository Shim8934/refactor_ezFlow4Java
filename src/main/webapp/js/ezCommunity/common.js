var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, FunctionName)
{
	var parameter = pInformationContent;
	var url = "/ezCommunity/ezAPROPINION.do";
	if (CrossYN()) {
		ezapropinion_cross_dialogArguments[0] = parameter;
		ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		ezapropinion_cross_dialogArguments[2] = FunctionName;
		
		var popUpW = 330;
		var popUpH = 197;
		
	    if (MACSAFARIYN()) {
	        popUpH = popUpH + 50;
	    }

		var heigth = window.screen.availHeight;
		var width = window.screen.availWidth;
		var pTop = (heigth - popUpH) / 2;
		var pLeft = (width - popUpW) / 2;

		var left = window.outerWidth / 2 + window.screenX - (popUpW / 2);
		var top = window.outerHeight / 2 + window.screenY - (popUpH / 2);
	    
	    var feature = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + "px ,top=" + top + "px, status = no, toolbar=no, menubar=no,location=no";
	    var result = window.open(url, "ezAPROPINION", feature);
	}
	else {
	    var feature = "status:no;dialogWidth:330px;dialogHeight:207px;help:no;scroll:no;edge:sunken";
	    var RtnVal = window.showModalDialog(url, parameter, feature);
	    return RtnVal;
	}
}

function OpenInformationUI_Complete(RtnVal, Complete_Function) {
    if (RtnVal)
        Complete_Function(RtnVal);
}

var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezCommunity/ezAprAlert.do";

    ezapralert_cross_dialogArguments[0] = parameter;
    if (CompleteFunction != undefined) {
        ezapralert_cross_dialogArguments[1] = CompleteFunction;
    } else {
        ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
    }
    DivPopUpShow(330, 205, url);
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}
function make_searchstring(orgStr)
{
	//return ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "'", "''"), "\\[", "[[]"), "%", "[%]"), "_", "[_]");
	return ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "&", "[&]"), "'", "''"), "\\[", "[[]"), "%", "[%]"), "_", "[_]");
}

function make_searchstring2(orgStr)
{
	return ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "&", "[&]"), "\\[", "[[]"), "%", "[%]"), "_", "[_]");
}

function ReplaceText( orgStr, findStr, replaceStr )
{
	var re = new RegExp( findStr, "gi" );
	return ( orgStr.replace( re, replaceStr ) );
}

function S4() {
    return ((CustomRandom() * 0x10000) | 0).toString(16).substring(1);
}

function GetGUID() {
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

function CustomRandom() {
    var now = new Date();
    var seed = now.getMilliseconds();
    return Math.random(seed) + 1;
}

// 2018-01-10 강민수92
function openCommunityBoardComment() {
	DivPopUpShow($('body').prop('scrollWidth') * 0.95, $('body').prop('scrollHeight') * 0.95, "/ezCommunity/communityCommentPopup.do?itemID=" 
			+ encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&gubun=" + gubun + "&code=" + encodeURIComponent(code));
}

//강민수92
function closePopup() {
	parent.DivPopUpHidden();
}

//강민수92
function Save_OneLineReply() {
	var pReplyID = "";
    pReplyID = "{" + GetGUID().toUpperCase() + "}";
	
	var strXML = "";

    strXML += "<DATA>";
    strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
    strXML += "<ITEMID>" + pItemID + "</ITEMID>";
    strXML += "<REPLYID>" + pReplyID + "</REPLYID>";
    if (OneLineReplyFlag == "1")
        strXML += "<CONTENT>" + encodeURIComponent(document.getElementById('onelinereply').value) + "</CONTENT>";
    else
        strXML += "<CONTENT></CONTENT>";

    if (gubun != "2") {
        strXML += "<PASSWORD></PASSWORD>";
    }
    else {
        strXML += "<PASSWORD>" + rsa.encrypt(document.getElementById('txtPassWord').value) + "</PASSWORD>";
    }
    strXML += "</DATA>";
	
    if (Reply_FG != "true") {
        alert(strLang173);
	    return;
	}
	
    var text = document.getElementById('onelinereply').value;
    if (text == "" || trim(text) == "") {
        alert(strLang182);
        return;
    }

    if (gubun == "2" && trim(document.getElementById('txtPassWord').value) == "") {
        alert(strLang183);
	    document.getElementById('txtPassWord').focus();
	    return;
	}
    var pReplyID = "";
    pReplyID = "{" + GetGUID().toUpperCase() + "}";

	var content,password;
	if (OneLineReplyFlag == "1"){
		content = MakeXMLString(document.getElementById('onelinereply').value);
	}else{
		content = "";
	}
	if (gubun != "2") {
	    password = "";
	}
	else {
	    password = rsa.encrypt(document.getElementById("txtPassWord").value);
	}

	$.ajax({
		type : "POST",
		async : false,
		url : "/ezCommunity/saveOneLineReply.do",
		data : { 
			"strXML" : strXML 
			   },
		success: function(){
			getBoardComment();
			$('#txtPassWord').val("");
			
			/* 2021-11-15 홍승비 - 게시판의 옵션에 따라 댓글 알림메일 발송 (비동기식, 백그라운드 동작) */
			 if (mailFG_Comment == "Y") {
             	sendCommBoardAlertMail("comment", pBoardID, pItemID);
             }
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("ajax error");
		}
	});
}

//강민수92
function getBoardComment() {
	$.ajax({
		type : "GET",
		async : false,
		url : "/ezCommunity/readOneLineReply.do",
		dataType : "json",
		data : {
			itemID : pItemID,
			boardID : pBoardID
		},
		success : function(result) {
			boardCommentList = "<colgroup><col width='20%' /><col width='62%' /><col width='18%' /></colgroup>";
			list = result.oneLineReplyList;
			var commentBgColor = 1;
			list.forEach(function(vo, index) {
				if (gubun == 2) {
					vo.userID = "";
				}
				if (commentBgColor === 1) {
					boardCommentList += "<tr class='boardComment' boardUserID='" + vo.userID + "' memberID='"
						+ vo.userID + "' replyID='" + vo.replyID + "'deptID='" + vo.deptID + "' boardCommentStatus='" 
						+ 1 + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#white;'>";
				} else {
					boardCommentList += "<tr class='boardComment' boardUserID='" + vo.userID + "' memberID='"
						+ vo.userID + "' replyID='" + vo.replyID + "'deptID='" + vo.deptID + "' boardCommentStatus='" 
						+ 1 + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#fafafa;'>";
				}
				commentBgColor = commentBgColor * (-1);
				if (gubun == "2") {
					boardCommentList += "<td style='padding-left:3px;line-height:1.5'>&nbsp;<span>" + vo.userName + "</span></td>";					
				} else {
					boardCommentList += "<td style='padding-left:3px;'>&nbsp;<span style='cursor:pointer'" 
										+ " onclick='OpenUserInfo(\"" + vo.userID + "\", \"" + vo.deptID + "\")'>" + vo.userName + "</span></td>";	
				}
				boardCommentList += "</td>";
				boardCommentList += "<td style='text-align:left;vertical-align:middle;padding:10px;word-wrap:break-word;line-height:1.5'>"
									+ MakeXMLString(vo.content) + "&nbsp;&nbsp;";
					
				if (typeof userInfoID == "undefined") {
				    userInfoID = "";    	
				}
				
				if (vo.userID == userInfoID) {
					boardCommentList += "<img src='/images/ImgIcon/comment_del.gif'" +
							" style='cursor:pointer;vertical-align:middle;inline-block;padding-bottom:1.6px' onclick='deleteBoardComment(this)'/>";
				} else {
					// 익명댓글인 경우
					if (vo.userID == null || vo.userID == "") {
						boardCommentList += "<img src='/images/ImgIcon/comment_del.gif'" +
								" style='cursor:pointer;vertical-align:middle;inline-block;padding-bottom:1.6px;' onclick='deleteBoardComment(this)'/>";
					} else {
						;
					}
				}
				boardCommentList += "</td>";
				boardCommentList += "<td style='text-align:right;padding-right:8px'>" + vo.writeDate.substring(0, 16) + "</td>";
				boardCommentList += "</tr>";
			}); 
			  
			if (list.length == 0) {
				boardCommentList += "<tr style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#white;'>";
				boardCommentList += "<td colspan='3' style='padding:10px;border-top:0px;border-bottom:1px solid #e2e2e2;"
									+ "border-right:0px;border-left:0px;text-align:center;background-color:white;'>" 
									+ strLang181 + "</td>";
				boardCommentList += "</tr>";
			}
			
			$("#commentList").html("");
			$("#commentList").append(boardCommentList);
			
			var updateCount ="[" + result.totalCommentCount + "]"; 
			document.getElementById('onelinereply').value = "";
			$("#headTitle").html(updateCount);
			var a = $('#commentCount', parent.document).text(strLang186 + "[" + result.totalCommentCount + "]");
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

//2018.01.02 강민수92
function DivPopUpShow2(popUpW, popUpH, URL) {
    try {
        var Position = DivPopUpPosition(popUpW, popUpH);
        document.getElementById("iFrameLayer2").src = URL;
        document.getElementById("iFramePanel2").style.top = Position[0] + "px";
        document.getElementById("iFramePanel2").style.left = Position[1] + "px";
        document.getElementById("iFramePanel2").style.height = popUpH + "px";
        document.getElementById("iFrameLayer2").style.width = popUpW + "px";
        document.getElementById("iFrameLayer2").style.height = popUpH + "px";
        document.getElementById("mailPanel2").style.display = "";
        document.getElementById("iFramePanel2").style.display = "";
    } catch (e) {}
}

//강민수92
function DivPopUpHidden2() {
    try {
        document.getElementById("mailPanel2").style.display = "none";
        document.getElementById("iFramePanel2").style.display = "none";
        document.getElementById("iFrameLayer2").src = "/blank.htm";
    } catch (e) {}
}

//강민수92
function closePopup2() {
	parent.DivPopUpHidden2();
}
//강민수92
function closePopup2() {
	parent.DivPopUpHidden2();
}
//강민수92
function deleteBoardCommentPopup() {
	DivPopUpShow2($('body').prop('scrollWidth') * 0.5, $('body').prop('scrollHeight') * 0.3, "/ezCommunity/checkPassword.do?itemID=" 
			+ encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID) + "&replyFlag=true");
}
//강민수92
function delete_onelinereply_Complete(ret) {
    var xmlhttp = createXMLHttpRequest();
    if (ret == "NO") {
        alert(strLang185);
        return;
    }
    else if (ret == "cancel" || ret == undefined) {
        return;
    }

    xmlhttp.open("POST", "/ezCommunity/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&gubun=" + gubun, false);
    xmlhttp.send();
    getBoardComment();
    xmlhttp = null;
}
//강민수92
function deleteBoardComment(obj) {
	var boardCommentID = $(obj).closest("tr").attr("replyID");
    delpReplyID = boardCommentID;
    var xmlhttp = createXMLHttpRequest();
    
    if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {
        if (gubun == "2") {
            if (CrossYN()) {
                checkpassword_dialogArguments[1] = delete_onelinereply_Complete;
                deleteBoardCommentPopup();
                try { OpenWin.focus(); } catch (e) { }
            	
            } else {		                	
            	var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
                feature = feature + GetShowModalPosition(330, 200);
                var ret = window.showModalDialog("/ezCommunity/checkPassWord.do?itemID=" + encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID), "", feature);
                
                if (ret == "NO") {
                    alert(strLang185);
                    return;
                } else if (ret == "cancel" || ret == undefined) {
                    return;
                }
                
                xmlhttp.open("POST", "/ezCommunity/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&gubun=" + gubun, false);
                xmlhttp.send();
                if (xmlhttp.responseText == "FAIL") {
                    alert(strLang184);
                } 

                getBoardComment();
                xmlhttp = null;
            }
            
        } else {
            xmlhttp.open("GET", "/ezCommunity/checkOneLineOwner.do?replyID=" + encodeURIComponent(delpReplyID), false);
            xmlhttp.send();
            if (xmlhttp.responseText.substr(0, 2) != "OK") {
                alert(strLang184);
                return;
            } else {
            	if (!confirm(strLang180)) return;
            	xmlhttp.open("POST", "/ezCommunity/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&gubun=" + gubun, false);
            	xmlhttp.send();	
            }
            
        }
    } else {
    	if (!confirm(strLang180)) return;
    	xmlhttp.open("POST", "/ezCommunity/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&gubun=" + gubun, false);
    	xmlhttp.send();	
    	
    }
    
    if (xmlhttp.responseText == "FAIL") {
        alert(strLang184);
    }
    getBoardComment();
    xmlhttp = null;
}

// 2017.12.28 강민수92
/* 2018-07-02 홍승비 - 작성자 정보 표시 시 부서정보 파라미터 추가 */
function OpenUserInfo(pUserID, pDeptID) {
    var result = GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "UserInfo", 420, 450, "NO");
}

/* 2021-11-15 홍승비 - 게시판 메일알림 함수 추가, 비동기로 백그라운드 동작 */
function sendCommBoardAlertMail(pMode, pBoardID, pItemID) {
    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezCommunity/sendCommBoardAlertMail.do",
		data : {
			mode : pMode,
			boardID : pBoardID,
			itemID : pItemID
		}
	});
}