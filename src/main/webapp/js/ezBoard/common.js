﻿﻿function OpenInformationUI(pInformationContent)
{
	var parameter = pInformationContent;
	var url = "/myoffice/ezCommunity/htm/ezAPROPINION.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:180px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
	return RtnVal;
}
function OpenAlertUI(pAlertContent)
{
	var parameter = pAlertContent;
	var url = "/myoffice/ezCommunity/htm/ezAPRALERT.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:180px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
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

//강민수92
function openBoardComment() {
	DivPopUpShow($('body').prop('scrollWidth') * 0.95, $('body').prop('scrollHeight') * 0.92, "/ezBoard/boardCommentPopup.do?itemID=" 
			+ encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&gubun=" + gubun + "&Reply_FG=" + Reply_FG + "&OneLineReplyFlag=" + OneLineReplyFlag);
}
//강민수92
function closePopup() {
	parent.DivPopUpHidden();
}
//강민수92
function getBoardComment() {
	$.ajax({
		type : "POST",
		async : false,
		url : "/ezBoard/getBoardComment.do",
		dataType : "json",
		data : {
			itemID : pItemID,
			boardID : pBoardID,
			gubun : gubun
		},
		success : function(result) {
			boardCommentList = "<colgroup><col width='20%' /><col width='62%' /><col width='18%' /></colgroup>";
			list = result.boardLineReplyVOList;
			var commentBgColor = 1;
			list.forEach(function(vo, index) {
				if (commentBgColor === 1) {
					boardCommentList += "<tr class='boardComment' boardUserID='" + vo.userID + "' memberID='"
						+ vo.userID + "' replyID='" + vo.replyID + "' boardCommentStatus='" 
						+ 1 + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#white;'>";
				} else {
					boardCommentList += "<tr class='boardComment' boardUserID='" + vo.userID + "' memberID='"
						+ vo.userID + "' replyID='" + vo.replyID + "' boardCommentStatus='" 
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
									+ vo.content + "&nbsp;&nbsp;";
					
				if ( typeof userInfoID == "undefined") {
				    userInfoID = "";    	
				}
				
				if (vo.userID == userInfoID) {
					boardCommentList += "<img src='/images/ImgIcon/comment_del.gif'" +
							" style='cursor:pointer;vertical-align:middle;inline-block;padding-bottom:1.6px' onclick='deleteBoardComment(this)'/>";
				} else {
					if (vo.userID == "") {
						//익명일 경우
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

    xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
    xmlhttp.send();
    getBoardComment();
    xmlhttp = null;
}
//강민수92
function deleteBoardCommentPopup() {
	DivPopUpShow2($('body').prop('scrollWidth') * 0.5, $('body').prop('scrollHeight') * 0.3, "/ezBoard/checkPassWord.do?itemID=" 
			+ encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID) + "&replyFlag=true");
}
//강민수92
function closePopup2() {
	parent.DivPopUpHidden2();
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
                var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID), "", feature);
                
                if (ret == "NO") {
                    alert("<spring:message code='ezBoard.t267' />");
                    return;
                } else if (ret == "cancel" || ret == undefined) {
                    return;
                }
                
                xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
                xmlhttp.send();
                if (xmlhttp.responseText == "FAIL") {
                    alert(strLang184);
                } 

                getBoardComment();
                xmlhttp = null;
            }
            
        } else {
            xmlhttp.open("POST", "/ezBoard/checkOneLineOwner.do?replyID=" + encodeURIComponent(delpReplyID), false);
            xmlhttp.send();
            if (xmlhttp.responseText.substr(0, 2) != "OK") {
                alert(strLang184);
                return;
            } else {
            	if (!confirm(strLang180)) return;
            	xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
            	xmlhttp.send();	
            }
            
        }
    } else {
    	if (!confirm(strLang180)) return;
    	xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
    	xmlhttp.send();	
    	
    }
    
    if (xmlhttp.responseText == "FAIL") {
        alert(strLang184);
    }
    getBoardComment();
    xmlhttp = null;
}
//강민수92
function OneLineReply_onkeydown() {
    if (event.keyCode == 13) Save_OneLineReply();
}
//강민수92
function Save_OneLineReply() {
    if (Reply_FG != "true") {
        alert(strLang173);
	    return;
	}
    if (OneLineReplyFlag == "1") {
    	var text = document.getElementById('onelinereply').value.replace(/\s|　/gi, '');
        if (text == "") {
            alert(strLang182);
	        return;
	    }
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
		dataType : "text",
		async : false,
		url : "/ezBoard/saveOneLineReply.do",
		data : { boardID    : pBoardID, 
				 itemID 	: pItemID,
				 replyID	: pReplyID,
				 content	: content,
				 password	: password
					 
			   },
		success: function(){
			getBoardComment();
			$('#txtPassWord').val("");
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("ajax error");
		}
	});
}
//2017.12.28 강민수92
function OpenUserInfo(pUserID, pDeptID) {
    var result = GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "UserInfo", 420, 450, "NO");
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

function DivPopUpHidden2() {
    try {
        document.getElementById("mailPanel2").style.display = "none";
        document.getElementById("iFramePanel2").style.display = "none";
        document.getElementById("iFrameLayer2").src = "/blank.htm";
    } catch (e) {}
}
