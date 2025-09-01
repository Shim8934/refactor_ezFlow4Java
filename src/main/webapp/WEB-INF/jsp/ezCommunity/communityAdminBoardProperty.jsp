<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t363' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
		var BoardID = "${boardID}";
		var ParentBoardID = '<c:out value="${parentBoardID}"/>';
		var BoardGroupID = '<c:out value="${boardGroupID}"/>';
		var brd_color = "${boardProp.boardColor}";
		var code = '<c:out value="${code}"/>';
		var versionuse = "${boardProp.versionUse}";
		var checkUse = "${boardProp.checkUse}";
		var iMenuNum = 1;
		var guBun = "<c:out value='${boardProp.gubun}'/>";
		var readGrade = "<c:out value='${readGrade}'/>";
		var writeGrade = "<c:out value='${writeGrade}'/>";
		
		//ShowModalDialog Chrome 적용
		(function() {
			window._smdName = window._smdName || Math.round(Math.random() * 1000000000);
			window.spawn = window.spawn || function(gen) {
				function continuer(verb, arg) {
		    		var result;
			    	
			      	try {
			        	result = generator[verb](arg);
			      	} catch (err) {
			        return Promise.reject(err);
			      	}
			      	
			      	if (result.done) {
			        	return result.value;
			      	} else {
			        	return Promise.resolve(result.value).then(onFulfilled, onRejected);
			      	}
			    }
				
		    	var generator = gen();
			    var onFulfilled = continuer.bind(continuer, 'next');
			    var onRejected = continuer.bind(continuer, 'throw');
			    
			    return onFulfilled();
			};
			  
			window.showModalDialog = window.showModalDialog || function(url, arg, opt) {
				url = url || '';                                         // URL of a dialog
			    arg = arg || null ;                                      // arguments to a dialog
			    opt = opt || 'dialogWidth: 300px; dialogHeight: 200px';  // options: dialogTop;dialogLeft;dialogWidth;dialogHeight or CSS styles
			    opt = opt
			      .replace(/dialog/gi, '')                               // remove all of dialog strings
			      .replace(/ /g, '')                                     // remove all blank characters
			      .replace(/:/g, '= ')                                   // replace all of ':' to '= '
			      .replace(/,|;/g, ', ')                                 // replace all of ',' or ';' to ', '
			      .replace(/width/gi, 'width')                           // replace all 'width' to lowercase
			      .replace(/height/gi, 'height')                         // replace all 'height' to lowercase
			      .replace(/(\d+)px/g, '$1');                            // remove all of 'px'
			    console.log(opt);
			    var caller = showModalDialog.caller.toString();
			    var dialog = window.open(url, 'smd_dialog_' + window._smdName, opt, false);
			    dialog.dialogArguments = arg;
			    dialog.addEventListener('unload', function(e) {
			    	e.preventDefault();
			    });
			    // if using yield
			    if (caller.indexOf('yield') >= 0) {
			    	return new Promise(function(resolve, reject) {
			        	dialog.addEventListener('unload', function() {
			          		var returnValue = dialog.returnValue;
			          		resolve(returnValue);
			        	});
			      	});
			    }
			    // if using eval
			    var isNext = false;
			    var nextStmts = caller
			    	.replace(/(window\.)?showModalDialog\([^)]+\)/g, 'showModalDialog(%%%%%%%)')
			      	.split('\n')
			      	.filter(function(stmt) {
			      		if (isNext || stmt.indexOf('showModalDialog(') >= 0)
			          		return isNext = true;
			        	return false;
			      	});
			    	var unloadEventHandler = function() {
			        
			    		if (dialog.location.href == 'about:blank') {
			            	return setTimeout(function() { dialog.addEventListener('unload', unloadEventHandler); }, 250);
			        	}
			        	var returnValue = dialog.returnValue;
			        	nextStmts[0] = nextStmts[0].replace(/(window\.)?showModalDialog\(%%%%%%%\)/g, JSON.stringify(returnValue));
			        	eval('{\n' + nextStmts.join('\n'));
			        };
			    	dialog.addEventListener('unload', unloadEventHandler);
			    	throw 'Execution stopped until showModalDialog is closed';
			};
		})();
		
		$(document).ready(function() {
			/* 2021-11-15 홍승비 - 게시판 일반설정 초기 로딩 시 게시판 유형별로 메알알림 옵션 설정 */
			if (guBun == "3") { // 포토게시판은 답변메일 사용불가
				document.getElementById("chkNotify").checked = false;
				document.getElementById("chkMailFGPost").disabled = false;
				document.getElementById("chkMailFGMod").disabled = false;
				document.getElementById("chkMailFGComment").disabled = false;
				document.getElementById("chkNotify").disabled = true;
			}
			else if (guBun == "2") { // 익명게시판은 모든 알림 사용불가
				document.getElementById("chkMailFGPost").checked = false;
				document.getElementById("chkMailFGMod").checked = false;
				document.getElementById("chkMailFGComment").checked = false;
				document.getElementById("chkNotify").checked = false;
				document.getElementById("chkMailFGPost").disabled = true;
				document.getElementById("chkMailFGMod").disabled = true;
				document.getElementById("chkMailFGComment").disabled = true;
				document.getElementById("chkNotify").disabled = true;
			}
			else { // 일반, 그룹게시판은 모든 알림 사용가능
				document.getElementById("chkMailFGPost").disabled = false;
				document.getElementById("chkMailFGMod").disabled = false;
				document.getElementById("chkMailFGComment").disabled = false;
				document.getElementById("chkNotify").disabled = false;
			}
			
			getGradeList();
		});
		
		function hasSpecialCharacters(str) {
			for(var i=0; i<str.length; i++) {
	            if(str.charCodeAt(i) == 40 || str.charCodeAt(i) == 41 || str.charCodeAt(i) == 91 || str.charCodeAt(i) == 93 || str.charCodeAt(i) == 38 || str.charCodeAt(i) == 47) {
	            } else {
				    if (str.charCodeAt(i) >= 33 & str.charCodeAt(i) <= 47) {
				    	return true;
				    }
				    
				    if (str.charCodeAt(i) >= 58 & str.charCodeAt(i) <= 59) {
				    	return true;
				    }
				    
				    if (str.charCodeAt(i) >= 60 & str.charCodeAt(i) <= 64) {
				    	return true;
				    }
				    
				    if (str.charCodeAt(i) >= 91 & str.charCodeAt(i) <= 95) {
				    	return true;
				    }
				    
				    if (str.charCodeAt(i) >= 123 & str.charCodeAt(i) <= 125) {
				    	return true;
				    }
				}
			}
			return false;			
		}
		
		String.prototype.trim = function() {
			return this.replace(/(^\s*)|(\s*$)/g, "");
		}

		function Save() {
			txtBoardName.value = txtBoardName.value.trim();
			txtBoardName2.value = txtBoardName2.value.trim();
			
			if(txtBoardName2.value == "" || txtBoardName2.value == null) {
			    txtBoardName2.value = txtBoardName.value;
			}
			
			if (txtBoardName.value == "") {
				alert("<spring:message code = 'ezCommunity.t366' />");
				return;
			}
			
			if (hasSpecialCharacters(txtBoardName.value)) {
				alert("<spring:message code = 'ezCommunity.t321' />");
				return;
			}
			
		    if (hasSpecialCharacters(txtBoardName2.value)) {
		        alert("<spring:message code = 'ezCommunity.t321' />");
		        return;
	        }
			
			var AttachMax = txtAttachLimit.value;
			var Description = txtBoardDescription.value;
			var Expires = "";
			var gubun = "";
			var replynotify = "";
			var mailFG_Post = "";
			var mailFG_Mod = "";
			var mailFG_Comment = "";
			
			if (chkNotify.checked) { // 답변알림
				replynotify = "1";
			} else {
				replynotify = "0";
			}
			if (document.getElementById("chkMailFGPost").checked) { // 게시알림
				mailFG_Post = "Y";
			} else {
				mailFG_Post = "N";
			}
			if (document.getElementById("chkMailFGMod").checked) { // 수정알림
				mailFG_Mod = "Y";
			} else {
				mailFG_Mod = "N";
			}
			if (document.getElementById("chkMailFGComment").checked) { // 댓글알림
				mailFG_Comment = "Y";
			} else {
				mailFG_Comment = "N";
			}

			if (chkGroupBoard.checked) {
				gubun = "1";
			} else if(chkAnonyBoard.checked) {
				gubun = "2";
			} else if(chkPhotoBoard.checked) {	
				gubun = "3";
			} else {
				gubun = "0";
			}

			if (chkPermanent.checked) {
				Expires = "-1";
			} else {
				Expires = txtExpires.value;
			}

			var iDeleteAfter = "-1";
			
			if (usedeleteafter.checked && deleteafter.value == "") {
				alert("<spring:message code = 'ezCommunity.t368' />");
				deleteafter.focus();
				return;
			}
			
			
			if (usedeleteafter.checked) {
				iDeleteAfter = deleteafter.value;
			}
			
			var url = txtURL.value;
			
			if (url != "" && url.toLowerCase().indexOf("http") == -1) url = "http://" + url;
			
			if (AttachMax == "") {
				AttachMax = "5";
			}
			
			if (Expires == "") {
				Expires = "30";
			}

			var readGrade = document.getElementById('read_Grade').value;
			var writeGrade = document.getElementById('write_Grade').value;
			
			$.ajax({
        		type : "POST",
        		url : "/ezCommunity/saveBoardProperty.do",
        		dataType : "json",
        		async : false,
        		data : {boardID : BoardID,
        				boardName : encodeURIComponent(txtBoardName.value),
        				boardName2 : encodeURIComponent(txtBoardName2.value),
        				attachSizeLimit : AttachMax,
        				boardDescription : encodeURIComponent(Description),
        				itemExpires : Expires,
        				gubun : gubun,
        				replyNotify : replynotify,
        				mailFG_Post : mailFG_Post,
        				mailFG_Mod : mailFG_Mod,
        				mailFG_Comment : mailFG_Comment,
        				deleteAfter : iDeleteAfter,
        				boardColor : encodeURIComponent(brd_color),
        				versionUse : versionuse,
        				checkUse : checkUse,
        				url: url,
						readGrade : readGrade,
						writeGrade : writeGrade
        				},
        		success : function(result) {
        			if (result["result"] == "OK") {
        				alert("<spring:message code = 'ezCommunity.t282' />");
        				
        				if (CrossYN()) {
        				    parent.window.frames.left.location.reload();
        				    parent.document.querySelector("iframe[name=right]").src = "/ezCommunity/adminBasic.do?code=" + '<c:out value="${code}"/>';
        				} else {
        				    window.parent.frames.item(0).location.reload();
        					location.href = location.href;
        				}
        			}
        		}
        	});
			window.parent.opener.location.reload();
		}

		function cancel() {
			var ret = confirm("<spring:message code = 'ezCommunity.t371' />");
			if(ret == true) window.close();
		}

		function chkPermanent_onclick() {
			if(chkPermanent.checked) {
				chkExpires.checked = false;
				txtExpires.value = "";
			} else {
				chkExpires.checked = true;
				txtExpires.value = "365";
			}		
		}

		function chkExpires_onclick() {
			if(chkExpires.checked) {
				chkPermanent.checked = false;
				txtExpires.value = "365";
			} else {
				chkPermanent.checked = true;
				txtExpires.value = "";
			}		
		}

		function chkNotifyOK_onclick() {
			if(chkNotifyOK.checked) {
				chkNotifyNO.checked = false;
			} else {
				chkNotifyNO.checked = true;
			}		
		}

		function chkNotifyNO_onclick() {
			if(chkNotifyNO.checked) {
				chkNotifyOK.checked = false;
			} else {
				chkNotifyOK.checked = true;
			}		
		}

		function movePrevious() {
			history.go(-1);
		}

		function checkboardtype(event) {
		    var target = event.target ? event.target : event.srcElement;
		    
		    if (target.id == "chkGroupBoard" && target.checked) {
		    	document.getElementById("chkAnonyBoard").checked = false;
		    	document.getElementById("chkPhotoBoard").checked = false;
		    }
		    
		    if (target.id == "chkAnonyBoard" && target.checked) {
		    	document.getElementById("chkGroupBoard").checked = false;
		    	document.getElementById("chkPhotoBoard").checked = false;
		    }
		    
		    if (target.id == "chkPhotoBoard" && target.checked) {
		    	document.getElementById("chkAnonyBoard").checked = false;
		    	document.getElementById("chkGroupBoard").checked = false;
		    }
		    
/* 			if (chkNotify.checked  && chkPhotoBoard.checked) {
				alert("<spring:message code = 'ezCommunity.t374' />");
			    target.checked = false;
				return;
			}

			if (chkNotify.checked && chkAnonyBoard.checked) {
				alert("<spring:message code = 'ezCommunity.t375' />");
			    target.checked = false;
				return;
			} */
			
			/* 2021-11-12 홍승비 - 메일알림 옵션 분리, 게시판 유형 별 사용불가 메일알림은 알러트가 아닌 disable로 처리 */
			if (target.id == "chkPhotoBoard" && target.checked) { // 포토게시판은 답변메일 사용불가
				document.getElementById("chkNotify").checked = false;
				document.getElementById("chkMailFGPost").disabled = false;
				document.getElementById("chkMailFGMod").disabled = false;
				document.getElementById("chkMailFGComment").disabled = false;
				document.getElementById("chkNotify").disabled = true;
			}
			else if (target.id == "chkAnonyBoard" && target.checked) { // 익명게시판은 모든 알림 사용불가
				document.getElementById("chkMailFGPost").checked = false;
				document.getElementById("chkMailFGMod").checked = false;
				document.getElementById("chkMailFGComment").checked = false;
				document.getElementById("chkNotify").checked = false;
				document.getElementById("chkMailFGPost").disabled = true;
				document.getElementById("chkMailFGMod").disabled = true;
				document.getElementById("chkMailFGComment").disabled = true;
				document.getElementById("chkNotify").disabled = true;
			}
			else { // 일반, 그룹게시판은 모든 알림 사용가능
				document.getElementById("chkMailFGPost").disabled = false;
				document.getElementById("chkMailFGMod").disabled = false;
				document.getElementById("chkMailFGComment").disabled = false;
				document.getElementById("chkNotify").disabled = false;
			}
		}
		
		function change_brdColor() {
			var parameter = new Array();	
			parameter[0] = brd_color;
			
			var feature = "dialogHeight:310px;dialogWidth:330px;status:no;help:no;edge:sunken;scroll:no";
			feature = feature + GetShowModalPosition(330,310);
			retValue = window.showModalDialog("/ezCommunity/colorPicker.do", parameter, feature);
			
			if (retValue != undefined) {
			    selColor.style.backgroundColor = retValue;
			    colorID.innerText = retValue;
			    brd_color = retValue;
			}
		}
			
		function OpenRightMenu(pIndex) {
			if (BoardID == "" && pIndex == 6) {
				alert("<spring:message code = 'ezCommunity.t289' />");
				return;
			}

			curMenuIndex = pIndex;

			if (BoardID == "" && pIndex != 9 && pIndex != 7 && pIndex != 6) {
				alert("<spring:message code = 'ezCommunity.t289' />");
				return;
			}
			
			if (BoardID == ParentBoardID && pIndex != 1 && pIndex != 2 && pIndex != 3 && pIndex != 4 && pIndex != 9 && pIndex != 7 && pIndex != 6) {
				alert("<spring:message code = 'ezCommunity.t290' />");
				return;
			}
			
			switch(pIndex) {
				case 1:
					window.location.href = "/ezCommunity/boardProperty.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + encodeURIComponent(code);
					break;
				case 2:
				    window.location.href = "/ezCommunity/boardCreate.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + encodeURIComponent(code);
					break;
				case 3:
					window.location.href = "/ezCommunity/boardACL.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + encodeURIComponent(code);
					break;
			    case 4:
			        if (CrossYN()) {
			            window.location.href = "/ezCommunity/boardOrder.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + encodeURIComponent(code);
			        } else {
			            window.location.href = "/ezCommunity/boardOrder.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + encodeURIComponent(code);
			        }
			        
					break;
				case 5:		
					if( BoardID==BoardGroupID ) {
						alert("<spring:message code = 'ezCommunity.t377' />");
					} else {
						window.location.href = "/ezCommunity/boardMove.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + encodeURIComponent(code);
					}
					
					break;
				case 6:	
					window.location.href = "/ezCommunity/boardDelete.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + encodeURIComponent(code);
					break;
				case 7:	
					window.location.href = "/ezCommunity/adminSearchBoardItem.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + encodeURIComponent(code);
					break;
				case 9:	
					window.location.href = "/ezCommunity/boardGroupCreate.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + encodeURIComponent(code);
					break;
				default:
					break;		
			}
		}
		
		function cherecoardtype(idx) {
			versionuse = recoard[idx].value;
		}
		
		function CheckType(nu) {
			checkUse = check[nu].value;
		}

		function getGradeList() {
			$.ajax({
				type : "GET",
				url : "/ezCommunity/getAdminMemberGrade.do",
				dataType : "json",
				data : {
					code : code
				},
				success : function(result) {
					getGradeList_after(result);
				},
				error : function(xhr, status, error) {
					console.error("Error: " + error);
				}
			});
		}
		
		var firstWriteOption = [];
		function getGradeList_after(gradeList) {
			var selectReadGrade = document.getElementById("read_Grade");
			
			if (selectReadGrade) {
				selectReadGrade.innerHTML = "";
	
				for (var i = 0; i < gradeList.length; i++) {
					var option = document.createElement("option");
	
					option.value = gradeList[i].gradeCode;
					option.textContent = gradeList[i].gradeName;
					
					if (gradeList[i].gradeCode == readGrade) {
						option.selected = true;
					}
					
					selectReadGrade.appendChild(option);
				}
	
				var selectWriteGrade = document.getElementById("write_Grade");
				selectWriteGrade.innerHTML = "";
	
				for (var i = 0; i < gradeList.length-1; i++) {
					var writeOption = document.createElement("option");
	
					writeOption.value = gradeList[i].gradeCode;
					writeOption.textContent = gradeList[i].gradeName;
	
					if (gradeList[i].gradeCode == writeGrade) {
						writeOption.selected = true;
					}

					firstWriteOption.push(writeOption.cloneNode(true));
					
					selectWriteGrade.appendChild(writeOption);
				}
			}
		}

		function selectChange() {
			var selectOption = document.getElementById('read_Grade').value;
			selectOption = parseInt(selectOption);
			var selectWriteGrade =  document.querySelector("#write_Grade");
			selectWriteGrade.innerHTML = "";

			firstWriteOption.forEach(function(option) {
				selectWriteGrade.appendChild(option.cloneNode(true));
			});
			var options = selectWriteGrade.querySelectorAll('option');
			for (i = options.length-1; i >= 0; i--) {
				if (i >= selectOption) {
					var lastOption = options[i];
					selectWriteGrade.removeChild(lastOption);
				}
			}
			var remainOptions = selectWriteGrade.querySelectorAll('option');
			remainOptions[remainOptions.length - 1].selected = true;
		}
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code = 'ezCommunity.t380' /></h1>
		
		<div id="mainmenu">
			<ul>
			    <li><span onClick="OpenRightMenu(1)"><spring:message code = 'ezCommunity.t291' /></span></li>
			    <li><span onClick="OpenRightMenu(9)"><spring:message code = 'ezCommunity.t297' /></span></li>
			    <li><span onClick="OpenRightMenu(2)"><spring:message code = 'ezCommunity.t324' /></span></li>
			    <li><span onClick="OpenRightMenu(4)"><spring:message code = 'ezCommunity.t294' /></span></li>
			    <li><span onClick="OpenRightMenu(5)"><spring:message code = 'ezCommunity.t295' /></span></li>
			    <li><span onClick="OpenRightMenu(6)"><spring:message code = 'ezCommunity.t208' /></span></li>
			    <li><span onClick="OpenRightMenu(7)"><spring:message code = 'ezCommunity.t296' /></span></li>
			    <li style="display:none"><span onClick="OpenRightMenu(3)"><spring:message code = 'ezCommunity.t293' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table class="content" style="margin-top:10px">
			<tr>
				<th><spring:message code = 'ezCommunity.t306' /></th>
				<td id="boardNameTD">&nbsp;&nbsp;<c:out value = "${multiBoardName}"/></td>
			</tr>
			<tr>
				<th><spring:message code = 'ezCommunity.t381' /></th>
				<td style="padding:0">
					<table style="width:100%;">
						<tr class="primary">
							<th>${langPrimary}</th>
							<td><input name="text" type=text id="txtBoardName" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" value="<c:out value='${boardInfo.boardName}'/>" maxlength=25></td>
						</tr>
						<tr class="secondary">
							<th>${langSecondary}</th>
							<td><input name="text2" type="text" id="txtBoardName2" style="WIDTH:100%;box-sizing:border-box;-moz-box-sizing:border-box;" value="<c:out value='${boardInfo.boardName2}'/>" maxlength=25></td>
						</tr>
					</table>
				</td>
      		</tr>
      		<tr>
		    	<th><spring:message code = 'ezCommunity.t382' /></th>
		        <td>${boardProp.boardNo}</td>
		    </tr>
			<c:if test="${parentBoardID != 'TOP'}">
				<tr>
					<th><spring:message code='ezCommunity.lyj24' /></th>
					<td colspan="2" style="padding:0">
						<select id="read_Grade" style="font-size: 13px;margin-left: 5px;vertical-align: middle;cursor: pointer;MIN-WIDTH: 80px;height: 20px;" onchange="selectChange()">
							<option value="1"><spring:message code = 'ezCommunity.t9' /></option>
							<option value="2"><spring:message code = 'ezCommunity.lyj08' /></option>
							<option value="3"><spring:message code = 'ezCommunity.lyj07' /></option>
							<option value="4"><spring:message code = 'ezCommunity.lyj08' /></option>
							<option value="10" selected><spring:message code = 'ezCommunity.lyj05' /></option>
						</select> <span style="vertical-align: middle;"><spring:message code = 'ezCommunity.lyj22' /></span>
					</td>
				</tr>
				<tr>
					<th><spring:message code='ezCommunity.lyj25' /></th>
					<td colspan="2" style="padding:0">
						<select id="write_Grade" style="font-size: 13px;margin-left: 5px;vertical-align: middle;cursor: pointer;MIN-WIDTH: 80px;height: 20px;" onchange="">
							<option value="1"><spring:message code = 'ezCommunity.t9' /></option>
							<option value="2"><spring:message code = 'ezCommunity.lyj08' /></option>
							<option value="3" selected><spring:message code = 'ezCommunity.lyj07' /></option>
							<option value="4"><spring:message code = 'ezCommunity.lyj08' /></option>
						</select> <span style="vertical-align: middle;"><spring:message code = 'ezCommunity.lyj22' /></span>
					</td>
				</tr>
			</c:if>
      		<tr style="${_style}">
		    	<th><spring:message code = 'ezCommunity.t383' /></th>
		        <td><input type=text id="txtBoardDescription" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" value="<c:out value='${boardProp.boardDescription}'/>" maxlength=99></td>
		    </tr>
      		<tr style="${_style}">
		        <th><spring:message code = 'ezCommunity.t384' /></th>
		        <td>
			        <c:choose>
			        	<c:when test="${boardProp.itemExpires == '-1' }">
							<input type="checkbox" id="chkPermanent" onClick="chkPermanent_onclick()" checked>
		      				<spring:message code = 'ezCommunity.t385' />
						    <input type="checkbox" id="chkExpires" onClick="chkExpires_onclick()">
						    <input type="text" id="txtExpires" value="365" style="width:35px" maxlength="3">
		      				<spring:message code = 'ezCommunity.t386' />
			        	</c:when>
							
			        	<c:otherwise>
			        		<input type="checkbox" id="chkPermanent" onClick="chkPermanent_onclick()">
							<spring:message code = 'ezCommunity.t385' />
							<input type="checkbox" id="chkExpires" onClick="chkExpires_onclick()" checked>
							<input type="text" id="txtExpires" style="width:35px" value="${boardProp.itemExpires}" maxlength="3">
							<spring:message code = 'ezCommunity.t386' />
			        	</c:otherwise>
			        </c:choose>
		        </td>
			</tr>
      		<tr style="${_style}">
      			<c:choose>
      				<c:when test="${boardProp.deleteAfter == '-1' }">
						<th><spring:message code = 'ezCommunity.t387' /></th>
						<td>
							<spring:message code = 'ezCommunity.t388' />
							<input type="text" id="deleteafter" style="width:50px" maxlength="3">
							<spring:message code = 'ezCommunity.t389' /><br>
							<input type="checkbox" id="usedeleteafter">
							<spring:message code = 'ezCommunity.t390' />
						</td>
      				</c:when>
      				
      				<c:otherwise>
							<th><spring:message code = 'ezCommunity.t391' /></th>
							<td>
								<spring:message code = 'ezCommunity.t388' />
								<input type="text" id="deleteafter" style="width:50px" value="${boardProp.deleteAfter}" maxlength="3">
								<spring:message code = 'ezCommunity.t389' /><br>
								<input type="checkbox" id="usedeleteafter" checked>
								<spring:message code = 'ezCommunity.t390' />
							</td>
      				</c:otherwise>
      			</c:choose>
      		</tr>
      		<tr style="${_style}">
				<th><spring:message code = 'ezCommunity.t392' /></th>
        		<td>
        			<c:choose>
        				<c:when test="${boardProp.gubun == '1' }">
        					<input type="checkbox" id="chkGroupBoard" onClick="checkboardtype(event)" checked>
      						<spring:message code = 'ezCommunity.t393' />
        				</c:when>
        				
        				<c:otherwise>
        					<input type="checkbox" id="chkGroupBoard" onClick="checkboardtype(event)">
      						<spring:message code = 'ezCommunity.t393' />
        				</c:otherwise>
        			</c:choose>
        			
        			<c:choose>
        				<c:when test="${boardProp.gubun == '2' }">
        					<input type="checkbox" id="chkAnonyBoard" onClick="checkboardtype(event)" checked>
      						<spring:message code = 'ezCommunity.t394' />
        				</c:when>
        				
        				<c:otherwise>
        					<input type="checkbox" id="chkAnonyBoard" onClick="checkboardtype(event)">
      						<spring:message code = 'ezCommunity.t394' />
        				</c:otherwise>
        			</c:choose>
        			
        			<c:choose>
        				<c:when test="${boardProp.gubun == '3' }">
        					<input type="checkbox" id="chkPhotoBoard" onClick="checkboardtype(event)" checked> 
							<spring:message code = 'ezCommunity.t395' />
        				</c:when>
        				
        				<c:otherwise>
        					<input type="checkbox" id="chkPhotoBoard" onClick="checkboardtype(event)"> 
      						<spring:message code = 'ezCommunity.t395' />
        				</c:otherwise>
        			</c:choose>
      			</td> 
        	</tr>
			<tr style="display:none">
				<th><spring:message code = 'ezCommunity.t397' /></th>
				<td>
					<c:choose>
						<c:when test="${boardProp.versionUse == '0' || boardProp.versionUse == '' }">
							<input type="radio" name="recoard" value="0" onClick="return cherecoardtype(0)" checked>
							<spring:message code = 'ezCommunity.t398' />
							<input type="radio" name="recoard" value="1" onClick="return cherecoardtype(1)">
							<spring:message code = 'ezCommunity.t399' />
							<input type="radio" name="recoard" value="2" onClick="return cherecoardtype(2)">
							<spring:message code = 'ezCommunity.t400' />
						</c:when>
						
						<c:when test="${boardProp.versionUse == '1' }">
							<input type="radio" name="recoard" value="0" onClick="return cherecoardtype(0)">
							<spring:message code = 'ezCommunity.t398' />
							<input type="radio" name="recoard" value="1" onClick="return cherecoardtype(1)" checked>
							<spring:message code = 'ezCommunity.t401' />
							<input type="radio" name="recoard" value="2" onClick="return cherecoardtype(2)">
							<spring:message code = 'ezCommunity.t400' />
						</c:when>
						
						<c:otherwise>
							<input type="radio" name="recoard" value="0" onClick="return cherecoardtype(0)">
							<spring:message code = 'ezCommunity.t398' />
							<input type="radio" name="recoard" value="1" onClick="return cherecoardtype(1)">
							<spring:message code = 'ezCommunity.t401' />
							<input type="radio" name="recoard" value="2" onClick="return cherecoardtype(2)" checked>
							<spring:message code = 'ezCommunity.t400' />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
      		<tr style="display:none">
		        <th><spring:message code = 'ezCommunity.t403' /></th>
		        <td>
			        <c:choose>
			        	<c:when test="${boardProp.checkUse == '0' || boardProp.checkUse == '' }">
							<input type="radio" name="check" value="0" checked onClick="return CheckType(0)">
			        	</c:when>
			        	
			        	<c:otherwise>
			        		<input type="radio" name="check" value="0" onClick="return CheckType(0)">
			        	</c:otherwise>
			        </c:choose>
			        
			    	<spring:message code = 'ezCommunity.t398' />
			    	
			    	<c:choose>
			        	<c:when test="${boardProp.checkUse == '1'}">
							<input type="radio" name="check" value="1" checked onClick="return CheckType(1)">
			        	</c:when>
			        	
			        	<c:otherwise>
			        		<input type="radio" name="check" value="1" onClick="return CheckType(1)">
			        	</c:otherwise>
			        </c:choose>
			        
			    	<spring:message code = 'ezCommunity.t404' />
			    </td>
      		</tr>
      		<tr style="${_style}">
		        <th><spring:message code = 'ezCommunity.t405' /></th>
		        <td><input type="text" id="txtAttachLimit" style="width:25px" value="${boardProp.attachSizeLimit}" maxlength="3">MB</td>
      		</tr>
			<tr style="${_style}">
				<th>URL</th>
				<td><input type="text" id="txtURL" style="width:100%" value="${boardProp.url}" maxlength="150"></td>
			</tr>
			<tr style="${_style}">
			<%-- 2021-11-12 홍승비 - 메일알림 옵션 분리, 게시/수정/댓글알림 추가 --%>
				<th><spring:message code = 'ezNotification.hth38' /></th>
				<td>
					<c:choose>
						<c:when test="${boardProp.mailFG_Post == 'Y' }">
							<input type=checkbox id="chkMailFGPost" checked>
							<spring:message code = 'ezBoard.HSBMail01' />
						</c:when>
						<c:otherwise>
							<input type=checkbox id="chkMailFGPost">
      						<spring:message code = 'ezBoard.HSBMail01' />
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${boardProp.mailFG_Mod == 'Y' }">
							<input type=checkbox id="chkMailFGMod" checked>
							<spring:message code = 'ezBoard.HSBMail02' />
						</c:when>
						<c:otherwise>
							<input type=checkbox id="chkMailFGMod">
      						<spring:message code = 'ezBoard.HSBMail02' />
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${boardProp.mailFG_Comment == 'Y' }">
							<input type=checkbox id="chkMailFGComment" checked>
							<spring:message code = 'ezBoard.HSBMail03' />
						</c:when>
						<c:otherwise>
							<input type=checkbox id="chkMailFGComment">
      						<spring:message code = 'ezBoard.HSBMail03' />
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${boardProp.replyNotify == '1' }">
							<input type=checkbox id="chkNotify" checked>
							<spring:message code = 'ezBoard.HSBMail04' />
						</c:when>
						<c:otherwise>
							<input type=checkbox id="chkNotify">
      						<spring:message code = 'ezBoard.HSBMail04' />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr style="${_style}">
		    	<th><spring:message code = 'ezCommunity.t408' /></th>
		        <td style="width:100%">
		        	<table style="width:300px" >
						<tr>
							<td id="selColor" style="background-color:${boardProp.boardColor};border:1px solid #ddd;">&nbsp;</td>
							<td style="width:100%">&nbsp;&nbsp;</td>
							<td style="white-space:nowrap;" id="colorID">${boardProp.boardColor}</td>
							<td style="width:100px;"><a class="imgbtn"><span onClick="change_brdColor()"><spring:message code = 'ezCommunity.t409' /></span></a></td>
						</tr>
		        	</table>
		    	</td>
			</tr>
		</table>
		
		<!-- 18-04-27 김민성 - UI 수정 -->
		<br><br><br>
		
		<div class="btnposition btnpositionNew">
			<a class="imgbtn"  onClick="return Save()"><span><spring:message code = 'ezCommunity.t108' /></span></a>
			<a class="imgbtn"  onClick="window.location.reload(false)"><span><spring:message code = 'ezCommunity.t109' /></span></a>
			<a class="imgbtn"  onclick="parent.parent.window.close()"><span><spring:message code = 'ezCommunity.t21' /></span></a>
		</div>
	</body>
</html>