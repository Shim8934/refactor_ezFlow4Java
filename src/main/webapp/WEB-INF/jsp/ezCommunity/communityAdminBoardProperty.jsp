<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t363' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<c:if test="${sysopCheck != '1' }">
			<spring:message code = 'ezCommunity.t447' />
			<%
				if (true) {
					return;
				}
			 %>
		</c:if>
		
		<script type="text/javascript">
		var BoardID = "${boardID}";
		var ParentBoardID = "${parentBoardID}";
		var BoardGroupID = "${boardGroupID}";
		var brd_color = "${boardProp.boardColor}";
		var code = "${code}";
		var versionuse = "${boardProp.versionUse}";
		var checkUse = "${boardProp.checkUse }";
		var iMenuNum = 1;
		
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
		
		function ReplaceText( orgStr, findStr, replaceStr ) {
			var re = new RegExp( findStr, "gi" );
			return ( orgStr.replace( re, replaceStr ) );
		}

		function MakeXMLString(str) {
			str = ReplaceText(str, "&", "&amp;");
			str = ReplaceText(str, "<", "&lt;");
			str = ReplaceText(str, ">", "&gt;");
			return str;
		}
		
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
			
			if(chkNotify.checked) {
				replynotify = "1";
			} else {
				replynotify = "0";
			}

			if(chkGroupBoard.checked) {
				gubun = "1";
			} else if(chkAnonyBoard.checked) {
				gubun = "2";
			} else if(chkPhotoBoard.checked) {	
				gubun = "3";
			} else {
				gubun = "0";
			}

			if(chkPermanent.checked) {
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

			var strXML = "";
			strXML += "<NODES>";
			strXML += "<NODE>";
			strXML += "<BOARDNAME>" + txtBoardName.value + "</BOARDNAME>";
			strXML += "<BOARDNAME2>" + txtBoardName2.value + "</BOARDNAME2>";
			strXML += "<BOARDID>" + BoardID + "</BOARDID>";
			strXML += "<ATTACHMAX>" + AttachMax + "</ATTACHMAX>";
			strXML += "<DESCRIPTION>" + MakeXMLString(Description) + "</DESCRIPTION>";
			strXML += "<EXPIRES>" + Expires + "</EXPIRES>";
			strXML += "<URL>" + url + "</URL>";
			strXML += "<GUBUN>" + gubun + "</GUBUN>";
			strXML += "<REPLYNOTIFY>" + replynotify + "</REPLYNOTIFY>";	
			strXML += "<DELETEAFTER>" + iDeleteAfter + "</DELETEAFTER>";	
			strXML += "<BOARDCOLOR>" + brd_color + "</BOARDCOLOR>";	
			strXML += "<VERSIONUSE>" + versionuse + "</VERSIONUSE>";
			strXML += "<CHECKUSE>" + checkUse + "</CHECKUSE>";		
			strXML += "</NODE>";
			strXML += "</NODES>";

		    var xmldom = loadXMLString(strXML);

			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/ezCommunity/saveBoardProperty.do", false);
			xmlhttp.setRequestHeader("Content-Type", "text/xml;charset=UTF-8");
			xmlhttp.send(xmldom);

			alert("<spring:message code = 'ezCommunity.t282' />");

			xmldom = null;
			xmlhttp = null;
			
			if (CrossYN()) {
			    parent.window.frames.left.location.reload();
			    parent.window.frames.right.location.href = "/ezCommunity/adminBasic.do?code=${code}";
			} else {
			    window.parent.frames.item(0).location.reload();
				location.href = location.href;
			}
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
		    
			if (chkNotify.checked  && chkPhotoBoard.checked) {
				alert("<spring:message code = 'ezCommunity.t374' />");
			    target.checked = false;
				return;
			}

			if (chkNotify.checked && chkAnonyBoard.checked) {
				alert("<spring:message code = 'ezCommunity.t375' />");
			    target.checked = false;
				return;
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
					window.location.href = "/ezCommunity/boardProperty.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
					break;
				case 2:
				    window.location.href = "/ezCommunity/boardCreate.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
					break;
				case 3:
					window.location.href = "/ezCommunity/boardACL.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
					break;
			    case 4:
			        if (CrossYN()) {
			            window.location.href = "/ezCommunity/boardOrder.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
			        } else {
			            window.location.href = "/ezCommunity/boardOrder.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
			        }
			        
					break;
				case 5:		
					if( BoardID==BoardGroupID ) {
						alert("<spring:message code = 'ezCommunity.t377' />");
					} else {
						window.location.href = "/ezCommunity/boardMove.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
					}
					
					break;
				case 6:	
					window.location.href = "/ezCommunity/boardDelete.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
					break;
				case 7:	
					window.location.href = "/ezCommunity/adminSearchBoardItem.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
					break;
				case 9:	
					window.location.href = "/ezCommunity/boardGroupCreate.do?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
					break;
				default:
					break;		
			}
		}
		
		/* function searchBoard_onclick() {
		    var feature = "DialogHeight:470px;DialogWidth:340px;status:no;help:no;edge:sunken";
		    feature = feature + GetShowModalPosition(340, 470);
		    var ret = window.showModalDialog("/myoffice/ezCommunity/commhome/admin/Board/SearchBoard.aspx", "", feature);
		    
			if(typeof(ret) == "undefined") {
			} else {
				var spans = TopBoardsList.all.tags("span");
				
				for (var i=0; i<spans.length; i++) {
					if(spans.item(i).id == ret[1]) {
						loadTreeViewByPath(spans.item(i), ret[0], ret[1], ret[2], ret[3]);
					}
				}
			}
		}

		function loadTreeViewByPath(pObjSpan, pBoardID, pBoardGroupID, pBoardName, pParentBoardID) {
			var divs = TopBoardsList.all.tags("DIV");
			
			for (var i=0; i<divs.length; i++) {
				if(divs.item(i).parentElement.parentElement.id == "TreeArea") {
					divs.item(i).parentElement.parentElement.style.display = "none";
				}
			}

			pObjSpan.parentElement.parentElement.nextSibling.style.display = "";
			var TreeCtrl = pObjSpan.parentElement.parentElement.nextSibling.firstChild.firstChild;
			
			TreeCtrl.server = SS_ServerName;
			TreeCtrl.config = xmlDom_treeview;
			TreeCtrl.source = GetBoardTreeByPath(pBoardID, pBoardGroupID);
			TreeCtrl.update();

			SelectedBoardID = pBoardID;
			SelectedBoardName = pBoardName;
			SelectedBoardParentBoardID = pParentBoardID;
			SelectedBoardGroupID = pBoardGroupID;

			window.location.href = "/ezCommunity/adminBoardProperty.do?boardID=" + SelectedBoardID;
		} */
		
		function cherecoardtype(idx) {
			versionuse = recoard[idx].value;
		}
		
		function CheckType(nu) {
			checkUse = check[nu].value;
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
		
		<table class="content" >
			<tr>
				<th><spring:message code = 'ezCommunity.t306' /></th>
				<td>&nbsp;&nbsp;${boardInfo.boardName}</td>
			</tr>
			<tr>
				<th><spring:message code = 'ezCommunity.t381' /></th>
				<td style="padding:0">
					<table style="width:100%;">
						<tr class="primary">
							<th>${lang_Primary}</th>
							<td><input name="text" type=text id="txtBoardName" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" value="${boardInfo.boardName}" maxlength=25></td>
						</tr>
						<tr class="secondary">
							<th>${lang_Secondary}</th>
							<td><input name="text2" type="text" id="txtBoardName2" style="WIDTH:100%;box-sizing:border-box;-moz-box-sizing:border-box;" value="${boardInfo.boardName2}"></td>
						</tr>
					</table>
				</td>
      		</tr>
      		<tr>
		    	<th><spring:message code = 'ezCommunity.t382' /></th>
		        <td>${boardProp.boardNo}</td>
		    </tr>
      		<tr style="${_style}">
		    	<th><spring:message code = 'ezCommunity.t383' /></th>
		        <td><input type=text id="txtBoardDescription" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" value="${boardProp.boardDescription}" maxlength=99></td>
		    </tr>
      		<tr style="${_style}">
		        <th><spring:message code = 'ezCommunity.t384' /></th>
		        <td>
			        <c:choose>
			        	<c:when test="${boardProp.itemExpires == '-1' }">
							<input type=checkbox id="chkPermanent" onClick="chkPermanent_onclick()" checked>
		      				<spring:message code = 'ezCommunity.t385' />
						    <input type=checkbox id="chkExpires" onClick="chkExpires_onclick()">
						    <input type="text" id="txtExpires" value="365" style="width:35px">
		      				<spring:message code = 'ezCommunity.t386' />
			        	</c:when>
							
			        	<c:otherwise>
			        		<input type=checkbox id="chkPermanent" onClick="chkPermanent_onclick()">
							<spring:message code = 'ezCommunity.t385' />
							<input type=checkbox id="chkExpires" onClick="chkExpires_onclick()" checked>
							<input type="text" id="txtExpires" style="width:35px" value="${boardProp.itemExpires}">
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
							<input type=inputbox id="deleteafter" style="width:50px">
							<spring:message code = 'ezCommunity.t389' /><br>
							<input type=checkbox id="usedeleteafter">
							<spring:message code = 'ezCommunity.t390' />
						</td>
      				</c:when>
      				
      				<c:otherwise>
							<th><spring:message code = 'ezCommunity.t391' /></th>
							<td>
								<spring:message code = 'ezCommunity.t388' />
								<input type=inputbox id="deleteafter" style="width:50px" value="${boardProp.deleteAfter}">
								<spring:message code = 'ezCommunity.t389' /><br>
								<input type=checkbox id="usedeleteafter" checked>
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
        					<input type=checkbox id="chkGroupBoard" onClick="checkboardtype(event)" checked>
      						<spring:message code = 'ezCommunity.t393' />
        				</c:when>
        				
        				<c:otherwise>
        					<input type=checkbox id="chkGroupBoard" onClick="checkboardtype(event)">
      						<spring:message code = 'ezCommunity.t393' />
        				</c:otherwise>
        			</c:choose>
        			
        			<c:choose>
        				<c:when test="${boardProp.gubun == '2' }">
        					<input type=checkbox id="chkAnonyBoard" onClick="checkboardtype(event)" checked>
      						<spring:message code = 'ezCommunity.t394' />
        				</c:when>
        				
        				<c:otherwise>
        					<input type=checkbox id="chkAnonyBoard" onClick="checkboardtype(event)">
      						<spring:message code = 'ezCommunity.t394' />
        				</c:otherwise>
        			</c:choose>
        			
        			<c:choose>
        				<c:when test="${boardProp.gubun == '3' }">
        					<input type=checkbox id="chkPhotoBoard" onClick="checkboardtype(event)" checked> 
							<spring:message code = 'ezCommunity.t395' />
        				</c:when>
        				
        				<c:otherwise>
        					<input type=checkbox id="chkPhotoBoard" onClick="checkboardtype(event)"> 
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
		        <td><input type="text" id="txtAttachLimit" style="width:25px" value="${boardProp.attachSizeLimit}">MB</td>
      		</tr>
			<tr style="${_style}">
				<th>URL</th>
				<td><input type="text" id="txtURL" style="width:100%" value="${boardProp.url}"></td>
			</tr>
			<tr style="${_style}">
				<th><spring:message code = 'ezCommunity.t406' /></th>
				<td>
					<c:choose>
						<c:when test="${boardProp.replyNotify == '1' }">
							<input type=checkbox id="chkNotify" onClick="checkboardtype(event)" checked>
							<spring:message code = 'ezCommunity.t407' />
						</c:when>
						
						<c:otherwise>
							<input type=checkbox id="chkNotify" onClick="checkboardtype(event)">
      						<spring:message code = 'ezCommunity.t407' />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr style="${_style}">
		    	<th><spring:message code = 'ezCommunity.t408' /></th>
		        <td style="width:100%">
		        	<table style="width:300px" >
						<tr>
							<td id="selColor" style="background-color:${boardProp.boardColor};border:1px solid #b6b6b6;">&nbsp;</td>
							<td style="width:100%">&nbsp;&nbsp;</td>
							<td style="white-space:nowrap;" id="colorID">${boardProp.boardColor}</td>
							<td style="width:100px;"><a class="imgbtn"><span onClick="change_brdColor()"><spring:message code = 'ezCommunity.t409' /></span></a></td>
						</tr>
		        	</table>
		    	</td>
			</tr>
		</table>
		
		<br>
		
		<div class="btnposition">
			<a class="imgbtn"  onClick="return Save()"><span><spring:message code = 'ezCommunity.t108' /></span></a>
			<a class="imgbtn"  onClick="window.location.reload(false)"><span><spring:message code = 'ezCommunity.t109' /></span></a>
			<a class="imgbtn"  onclick="parent.parent.window.close()"><span><spring:message code = 'ezCommunity.t21' /></span></a>
		</div>
	</body>
</html>