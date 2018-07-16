<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t143" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
	    <script type="text/javascript" src="/js/ezPersonal/ListView_list.js"></script>
		<script type="text/javascript" language="javascript">
			var BoardID = "<c:out value='${model.boardID}'/>";
	        var brd_color = "<c:out value='${model.boardColor}'/>";
	        var portlet =  $.trim("<c:out value='${model.portlet}'/>");
	        var background = $.trim("<c:out value='${model.backGround}'/>");
	        var pAdminType = $.trim("<c:out value='${adminType}'/>");
	        var FormFlag =  $.trim("<c:out value='${model.formFlag}'/>");
	        var APPRFLAG = $.trim("<c:out value='${model.apprFlag}'/>");
	        var APPRMAILFLAG = $.trim("<c:out value='${model.apprMailFlag}'/>");
	        var orgAPPRFLAG = $.trim("<c:out value='${model.apprFlag}'/>");
	        var xmlhttp = createXMLHttpRequest();
	        var ApprUserList = "";
	        var selectTargetListXML = "";
			var selecttarget_cross_dialogArguments = new Array();
			var manycolor_dialogArguments = new Array();
			var BoardExtension_dialogArguments = new Array();
			
	        document.onselectstart = function (){
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
	                return false;
	            }
	            else {
	                return true;
	            }
	    	};
        
			$(document).ready(function(){
				if ("${use_portal}" != "YES") {
	                $("#trPortlet").css("display","none");
				}
	            if (portlet == "Y") {
	                $("#chkPortletBoard").prop("checked",true);
	            }
	            if (background == "Y") {
	                $("#chkbackgroundimage").prop("checked",true);
	            }
	            if(FormFlag == "Y") {
	                $("#chkform").prop("checked",true);
	            }
	            if (pAdminType == "y") {
	                parent.document.getElementsByTagName("h1")[0].innerHTML = "<spring:message code='ezBoard.t60' />";
	            }
	            if (APPRFLAG == "Y") {
	                $("#chkApprBoard").prop("checked",true);
	                document.getElementById("chkApprList").style.display = "";
	                document.getElementById("chkApprListMail").style.display = "";

	                getApprUserList();
	            }
	            if (APPRMAILFLAG == "Y") {
	                $("#chkApprBoardMail").prop("checked",true);
	            }
	            
	            /* 2018-06-29 홍승비 - 기존 승인여부가 null인 게시판은 'N'값으로 처리 */
	            if (orgAPPRFLAG.trim() == "") {
	            	orgAPPRFLAG = "N";
	            }
	            if (APPRFLAG.trim() == "") {
	            	APPRFLAG = "N";
	            }
	            
	            if ($("#chkQnABoard").is(":checked") || $("#chkAnonyBoard").is(":checked")) {
	                if ($("#chkApprBoard").is(":checked")) {
	                	$("#chkApprBoard").prop("checked",false);	                    
	                    checkApprBoard();
	                    $("#chkApprBoard").prop("disabled",true);
	                } else {
	                	$("#chkApprBoard").prop("disabled",true);
	                }
	            }

	            /* 2018-07-11 홍승비 - 포토, 썸네일, 익명, URL 게시판 선택 시 답변메일발송 tr 보이지 않도록 수정 */
	            //추가항목
	            if ("${style}" == "") {
	                if ($("#chkPhotoBoard").is(":checked") || $("#chkThumbBoard").is(":checked")) {
	                    document.getElementById("trAttribute").style.display = "none";
	                    document.getElementById("chkNotifyTr").style.display = "none";
	                    document.getElementById("tr1").style.display = "none";
	                    document.getElementById("tr2").style.display = "none";
	                }
	                else if ($("#chkAnonyBoard").is(":checked")) {
	                	document.getElementById("chkNotifyTr").style.display = "none";
	                }
	                else if ($("#chkPortletBoard").is(":checked")) {
	                	document.getElementById("trAttribute").style.display = "none";
	                }
	                /* 2018-07-13 홍승비 - URL게시판 구분 추가 */
	                else if ($("#chkURLBoard").is(":checked")) {
		            	document.getElementById("txtURL").style.display = "";
		            	document.getElementById("trAttribute").style.display = "none";
	                    document.getElementById("chkNotifyTr").style.display = "none";
	                    document.getElementById("tr1").style.display = "none";
	                    document.getElementById("tr2").style.display = "none";
	                    document.getElementById("tr3").style.display = "none";
	                    document.getElementById("expireTr").style.display = "none";
	                    document.getElementById("deleteAfterTr").style.display = "none";
	                    document.getElementById("attachLimitTr").style.display = "none";
	                    document.getElementById("oneLineTr").style.display = "none";
	                }
	                
	                if (!$("#chkURLBoard").is(":checked")) {
	                	document.getElementById("txtURL").style.display = "none";
	                }
	            }
			});
			
			function Save() {
	            if ($.trim($("#txtBoardName").val()) == "") {
	                alert("<spring:message code='ezBoard.t144'/>");
	                return;
	            }
	            if ($.trim($("#txtBoardName2").val()) == "") {
	            	$("#txtBoardName2").val($("#txtBoardName").val());
	            }
	            //승인게시판
	            if (APPRFLAG == "Y") {
	                if (ApprUserList == "") {
	                    alert("<spring:message code='ezBoard.t999018'/>");
	                    return;
	                }
	            } else {
	                ApprUserList = "";
	            }

	            var AttachMax = $("#txtAttachLimit").val();
	            var Description = $("#txtBoardDescription").val();
	            var Expires = "";
	            var gubun = "";
	            var replynotify = "";

	            if ($("#chkNotify").is(":checked")) {
	                replynotify = "1"
	            } else {
	                replynotify = "0";
	            }

	            if ($("#chkGroupBoard").is(":checked")) {
	                gubun = "1"
	            } else if ($("#chkAnonyBoard").is(":checked")) {
	                gubun = "2";
	            } else if ($("#chkPhotoBoard").is(":checked")) {
	                gubun = "3";
	            } else if ($("#chkThumbBoard").is(":checked")) {
	                gubun = "4";
	            } else if ($("#chkGeneralBoard").is(":checked")) {
	                gubun = "0";
	            } else if ($("#chkQnABoard").is(":checked")) {
	                gubun = "5";
	            } else if ($("#chkURLBoard").is(":checked")) {
	                gubun = "0";
	            }
	            
	            if ($("#chkbackgroundimage").is(":checked")) {
	                background = "Y";
	            } else {
	                background = "N";
	            }
	            
	            if ($("#chkform").is(":checked")) {
	                FormFlag = "Y";
	            } else {
	                FormFlag = "N";
				}
	            
	            if ($("#chkPermanent").is(":checked")) {
	                Expires = "-1"
	            } else {
	                Expires = $("#txtExpires").val();
	            }

	            var iDeleteAfter = "-1";
	            if ($("#usedeleteafter").is(":checked") && $("#deleteafter").val() == "") {
	                alert("<spring:message code='ezBoard.t146'/>");
	                $("#deleteafter").focus();
	                return;
	            }
	            
	            var url = $("#txtURL").val().trim();
	             if ($("#chkURLBoard").is(":checked") && url == "") {
	                alert("<spring:message code='ezPortal.t123'/>");
	                $("#txtURL").focus();
	                return;
	            } else if (!$("#chkURLBoard").is(":checked")) {
	            	url = "";            
	            }
	             
	             if ($("#chkURLBoard").is(":checked") && url != "" && url.toLowerCase().indexOf("http") == -1) {
	            	url = "http://" + url;
	            }
	             
				if ($("#chkPortletBoard").is(":checked") && url == "") {
					portlet = "Y";
				} else {
					portlet = "N";
				}

	            if (orgAPPRFLAG != APPRFLAG) {
	                if (orgAPPRFLAG == "N") {
	                    if (!confirm("<spring:message code='ezBoard.t999013'/>")) {
	                        return;
	                    }
	                } else {
	                    if (!confirm("<spring:message code='ezBoard.t999012'/>")) {
	                        return;
	                    }
	                }
	            }

	            if ($("#usedeleteafter").is(":checked")) {
	                iDeleteAfter = $("#deleteafter").val();
	            }
	            
	            if (AttachMax == "") {
	            	AttachMax = "5";
	            }
	            if (Expires == "") {
	            	Expires = "30";
	            }
	            
	            var oneLineReply = "";            
	            if ($("#chkOneLine").is(":checked") == false) {
	            	oneLineReply = 0;
	            } else {
	            	oneLineReply = 1;
	            }
	            
	            $.ajax({
	            	type : "POST",
	            	dataType : "text",
	            	url : "/admin/ezBoard/saveBoardProperty.do",
	            	async : false,
	            	data : { boardName:$("#txtBoardName").val(), boardName2:$("#txtBoardName2").val(), boardID:BoardID, attachSizeLimit:AttachMax, boardDescription:Description,
	            		     itemExpires:Expires, url:url, guBun:gubun, replyNotify:replynotify, deleteAfter:iDeleteAfter, boardColor:brd_color, portlet:portlet, backGround:background,
	            		     formFlag:FormFlag, oneLineReply:oneLineReply, apprFlag:APPRFLAG, orgApprFlag:orgAPPRFLAG, apprUserList:ApprUserList, apprMailFlag:APPRMAILFLAG},
	            	success : function(){
	            		alert("<spring:message code='ezBoard.t79'/>");
	            		
	            		if ("${adminType}" == "y") {
	            			parent.parent.board_menu.location = "/admin/ezBoard/boardLeft.do?boardID=" + BoardID;	            			
	            			return;	            			
	            		} else {
	            			parent.frames.location = parent.frames.location;
	            		}
	            		
	            		location.href = location.href;
	            	}	            		
	            });
	        }
			function chkPermanent_onclick() {
	            if (chkPermanent.checked) {
	                chkExpires.checked = false;
	                txtExpires.value = "";
	            } else {
	                chkExpires.checked = true;
	                txtExpires.value = "365";
	            }
	        }			
			function chkExpires_onclick() {
	            if (chkExpires.checked) {
	                chkPermanent.checked = false;
	                txtExpires.value = "365";
	            } else {
	                chkPermanent.checked = true;
	                txtExpires.value = "";
	            }
	        }
			
			function checkboardtype() {
	        	if (event.srcElement.id == "chkGeneralBoard" && event.srcElement.checked) {
	                chkGroupBoard.checked = false;
	                chkAnonyBoard.checked = false;
	                chkPhotoBoard.checked = false;
	                chkThumbBoard.checked = false;
	                chkQnABoard.checked = false;
	                chkURLBoard.checked = false;
	            }
	            if (event.srcElement.id == "chkGroupBoard" && event.srcElement.checked) {
	                chkGeneralBoard.checked = false;
	                chkAnonyBoard.checked = false;
	                chkPhotoBoard.checked = false;
	                chkThumbBoard.checked = false;
	                chkQnABoard.checked = false;
	                chkURLBoard.checked = false;
	            }
	            if (event.srcElement.id == "chkAnonyBoard" && event.srcElement.checked) {
	                chkGeneralBoard.checked = false;
	                chkGroupBoard.checked = false;
	                chkPhotoBoard.checked = false;
	                chkThumbBoard.checked = false;
	                chkQnABoard.checked = false;
	                chkURLBoard.checked = false;

	                if (chkQnABoard.checked || chkAnonyBoard.checked) {
	                    if (chkApprBoard.checked) {
	                        chkApprBoard.checked = false;
	                        checkApprBoard();
	                      	chkApprBoard.disabled = true;
	                    }
	                }
	            } else {
	                if (chkQnABoard.checked || chkAnonyBoard.checked) {
	                    chkApprBoard.disabled = true;
	                } else {
	                    chkApprBoard.disabled = false;
	                }
	            }
	            if (event.srcElement.id == "chkPhotoBoard" && event.srcElement.checked) {
	                chkGeneralBoard.checked = false;
	                chkGroupBoard.checked = false;
	                chkAnonyBoard.checked = false;
	                chkThumbBoard.checked = false;
	                chkQnABoard.checked = false;
	                chkURLBoard.checked = false;
	            }
	            if (event.srcElement.id == "chkThumbBoard" && event.srcElement.checked) {
	                chkGeneralBoard.checked = false;
	                chkGroupBoard.checked = false;
	                chkAnonyBoard.checked = false;
	                chkPhotoBoard.checked = false;
	                chkQnABoard.checked = false;
	                chkURLBoard.checked = false;
	            }
	            if (event.srcElement.id == "chkQnABoard" && event.srcElement.checked) {
	                chkGeneralBoard.checked = false;
	                chkGroupBoard.checked = false;
	                chkAnonyBoard.checked = false;
	                chkPhotoBoard.checked = false;
	                chkThumbBoard.checked = false;
	                chkURLBoard.checked = false;

	                if (chkQnABoard.checked || chkAnonyBoard.checked) {
	                    if (chkApprBoard.checked) {
	                        chkApprBoard.checked = false;
	                        checkApprBoard();
	                        chkApprBoard.disabled = true;
	                    }
	                }
	            } else { 
	                if (chkQnABoard.checked || chkAnonyBoard.checked) {
	                    chkApprBoard.disabled = true;
	                }
	                else {
	                    chkApprBoard.disabled = false;
	                }
	            }
	            /* 2018-07-13 홍승비 - URL게시판 구분 추가 */
                if (event.srcElement.id == "chkURLBoard" && event.srcElement.checked) {
                	chkGeneralBoard.checked = false;
	                chkGroupBoard.checked = false;
	                chkAnonyBoard.checked = false;
	                chkPhotoBoard.checked = false;
	                chkThumbBoard.checked = false;
	                chkQnABoard.checked = false;
	            }
	            
	             if (chkURLBoard.checked == true) {
                    document.getElementById("txtURL").style.display = "";
                    document.getElementById("tr1").style.display = "none";
                    document.getElementById("tr2").style.display = "none";
                    document.getElementById("tr3").style.display = "none";
                    document.getElementById("expireTr").style.display = "none";
                    document.getElementById("deleteAfterTr").style.display = "none";
                    document.getElementById("attachLimitTr").style.display = "none";
                    document.getElementById("oneLineTr").style.display = "none";
                    document.getElementById("trAttribute").style.display = "none";
                    document.getElementById("chkNotifyTr").style.display = "none";
                    
                    document.getElementById("chkApprBoard").checked = false;
                    checkApprBoard();                   
                    document.getElementById("chkExpires").checked = false;
                    document.getElementById("chkPermanent").checked = true;
                    document.getElementById("usedeleteafter").checked = false;
                    document.getElementById("chkbackgroundimage").checked = false;
                    document.getElementById("chkform").checked = false;
                    document.getElementById("chkNotify").checked = false;
                    document.getElementById("chkOneLine").checked = false;
	            } else {
					document.getElementById("txtURL").style.display = "none";
                    document.getElementById("tr1").style.display = "";
                    document.getElementById("tr2").style.display = "";
                    document.getElementById("tr3").style.display = "";
                    document.getElementById("expireTr").style.display = "";
                    document.getElementById("deleteAfterTr").style.display = "";
                    document.getElementById("attachLimitTr").style.display = "";
                    document.getElementById("oneLineTr").style.display = "";
                    document.getElementById("trAttribute").style.display = "";
                    document.getElementById("chkNotifyTr").style.display = "";
	            }

	            /* 2018-07-11 홍승비 - 포토, 썸네일, 익명게시판 선택 시 답변메일발송 tr 보이지 않도록 수정 */
	             if (chkPhotoBoard.checked == true || chkThumbBoard.checked == true || chkAnonyBoard.checked == true) {
	                document.getElementById("chkNotifyTr").style.display = "none";
	                document.getElementById("chkNotify").checked = false;
	            } else if (chkURLBoard.checked == false) {
	                document.getElementById("chkNotifyTr").style.display = "";
	            }
	            
	            if (chkPhotoBoard.checked == true || chkThumbBoard.checked == true || chkPortletBoard.checked == true) {
	                document.getElementById("trAttribute").style.display = "none";
	            } else if (chkURLBoard.checked == false) {
	                document.getElementById("trAttribute").style.display = "";
	            }
	            
	            if (chkPhotoBoard.checked == true || chkThumbBoard.checked == true) {
	            	document.getElementById("tr1").style.display = "none";
	            	document.getElementById("tr2").style.display = "none";
	                document.getElementById("chkbackgroundimage").checked = false;
	                document.getElementById("chkform").checked = false;
	            } else if (chkURLBoard.checked == false) {
	            	document.getElementById("tr1").style.display = "";
	            	document.getElementById("tr2").style.display = "";
	            }
	            
	            /*
	            // chkNotify, chkform 등의 TR 표출을 상단에서 제어하도록 수정했으므로 주석처리
	            if (chkNotify.checked && (chkPhotoBoard.checked || chkThumbBoard.checked)) {
	                alert("<spring:message code='ezBoard.t150'/>");
	                event.srcElement.checked = false;
	                return;
	            }
	            if (chkbackgroundimage.checked && (chkPhotoBoard.checked || chkThumbBoard.checked)) {
	                alert("<spring:message code='ezBoard.t6000'/>");
	                event.srcElement.checked = false;
	                return;
	            }
	            if (chkform.checked && (chkPhotoBoard.checked || chkThumbBoard.checked)) {
	                alert("<spring:message code='ezBoard.t6001'/>");
	                event.srcElement.checked = false;
	                return;
	            }
	             if (chkNotify.checked && chkAnonyBoard.checked) {
	                alert("<spring:message code='ezBoard.t151'/>");
	                event.srcElement.checked = false;
	                return;
	            } */
			}
			
			function checkApprBoard() {
			    if (chkApprBoard.checked == true) {
			        document.getElementById("chkApprList").style.display = "";
			        document.getElementById("chkApprListMail").style.display = "";
			        APPRFLAG = "Y";
			    } else {
			        document.getElementById("chkApprList").style.display = "none";
			        document.getElementById("chkApprListMail").style.display = "none";
			        APPRFLAG = "N";
			    }
			}			
			function checkApprMail() {
			    if (chkApprBoardMail.checked == true) {
			        APPRMAILFLAG = "Y";
			    } else {
			        APPRMAILFLAG = "N";
			    }
			}			
			function SelectTarget() {
			    var receiverData = new Array();
			    receiverData["window"] = this;
			    receiverData["selectTargetListXML"] = selectTargetListXML;
			    
			    selecttarget_cross_dialogArguments[0] = receiverData;
			    selecttarget_cross_dialogArguments[1] = SelectTarget_Complete;
			    var SelectTarget_Cross = window.open("/admin/ezBoard/selectTarget2.do", "SelectTarget_Cross2", GetOpenWindowfeature(1144, 590));
			    try { SelectTarget_Cross.focus(); } catch (e) {}
			}
			function SelectTarget_Complete(ret) {
			    if (typeof (ret) != "undefined") {
			        selectTargetListXML = ret;
			        document.getElementById("AccessList").innerHTML = "";

			        var listview = new ListView();
			        listview.SetID("AccessListView");
			        listview.SetSelectFlag(false);
			        listview.SetMulSelectable(true);
			        listview.DataSource(document.getElementById("listviewheader"));
			        listview.DataBind("AccessList");
			        var xmldom = loadXMLString(selectTargetListXML);
			        var xmldomNode = SelectNodes(xmldom, "DATA/NAME");
			        for (i = 0; i < xmldomNode.length; i++) {
			            var listTR = listview.AddRow(listview.GetRowCount());
			            var listTD = document.createElement("TD");
			            listTD.style.paddingBottom = "0px";
			            listTD.style.paddingTop = "0px";
			            var listTDText = document.createTextNode(getNodeText(xmldomNode[i]));
			            listTD.appendChild(listTDText);
			            listTR.appendChild(listTD);
			        }

			        var xmldomNode2 = SelectNodes(xmldom, "DATA/CN");
			        ApprUserList = "";
			        for (var i = 0; i < xmldomNode2.length; i++) {
			            ApprUserList += getNodeText(xmldomNode2[i]);
			            if (i != xmldomNode2.length - 1) {
			                ApprUserList += ";";
			            }
			        }
			    }
			}			
			function getApprUserList() {
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/ezBoard/get_apprUserList.do",
					async : true,
					data : {pBoardID : BoardID},
					success : function(result){
						makeApprUserList(loadXMLString(result));
					}
				});
			}			
			function makeApprUserList(getApprXml){
			    document.getElementById("AccessList").innerHTML = "";

			    var listview = new ListView();
			    listview.SetID("AccessListView");
			    listview.SetSelectFlag(false);
			    listview.SetMulSelectable(true);
			    listview.DataSource(document.getElementById("listviewheader"));
			    listview.DataBind("AccessList");

			    var xmldom = getApprXml;
			    var xmldomNode = SelectNodes(xmldom, "NODES/NODE");
			    for (i = 0; i < xmldomNode.length; i++) {
			        var listTR = listview.AddRow(listview.GetRowCount());
			        var listTD = document.createElement("TD");
			        listTD.style.paddingBottom = "0px";
			        listTD.style.paddingTop = "0px";

			        var UserName = SelectSingleNodeValue(xmldomNode[i], "DISPLAYNAME");
			        if ("${lang}" != "1")
			            UserName = SelectSingleNodeValue(xmldomNode[i], "DISPLAYNAME2");

			        var DeptName = SelectSingleNodeValue(xmldomNode[i], "DESCRIPTION");
			        if("${lang}" != "1")
			            DeptName  = SelectSingleNodeValue(xmldomNode[i], "DESCRIPTION2");

			        var listTDText = document.createTextNode(UserName + "(" + DeptName + ")");
			        listTD.appendChild(listTDText);
			        listTR.appendChild(listTD);
			    }
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "DATA");
			    var strxml = "<DATA>";
			    var xmldomNode2 = SelectNodes(xmldom, "NODES/NODE");
			    ApprUserList = "";
			    for (var i = 0; i < xmldomNode2.length; i++) {
			        ApprUserList += SelectSingleNodeValue(xmldomNode[i], "APPRUSERID");
			        if (i != xmldomNode2.length - 1) {
			            ApprUserList += ";";
			        }
			        strxml += "<CN><![CDATA[" + SelectSingleNodeValue(xmldomNode[i], "APPRUSERID") + "]]></CN>";
			        strxml += "<NAME><![CDATA[" + SelectSingleNodeValue(xmldomNode[i], "DISPLAYNAME") + "(" + SelectSingleNodeValue(xmldomNode[i], "DESCRIPTION") + ")" + "]]></NAME>";
			        strxml += "<NAME2><![CDATA[" + SelectSingleNodeValue(xmldomNode[i], "DISPLAYNAME2") + "(" + SelectSingleNodeValue(xmldomNode[i], "DESCRIPTION2") + ")" + "]]></NAME2>";
			        strxml += "<DEPT><![CDATA[PERSON]]></DEPT>";
			        strxml += "<GROUP><![CDATA[N]]></GROUP>";
			    }
			    strxml += "</DATA>";
			    selectTargetListXML = strxml;
			}			
			function change_brdColor() {
			    if (CrossYN()) {
			        manycolor_dialogArguments[1] = change_brdColor_Complete;
			        var manyColor = window.open("/ezCommon/manyColor.do", "manyColor", GetOpenWindowfeature(286, 290));
			        try { manyColor.focus(); } catch (e) {}
			    }
			    else {
			        var color = showModalDialog("/ezCommon/manyColor.do", null, "dialogHeight:290px; dialogWidth:286px; status:no;scroll:no; help:no; edge:sunken");
			        if (typeof (color) != "undefined") {
			            document.getElementById("selColor").style.backgroundColor = color;
			            document.getElementById("colorID").innerText = color;
			            brd_color = color;
			        }
			    }
			}       
			function change_brdColor_Complete(color) {
			    if (typeof (color) != "undefined") {
			        document.getElementById("selColor").style.backgroundColor = color;
			        document.getElementById("colorID").innerText = color;
			        brd_color = color;
			    }
			}			
		    function ExtensionAttribute_onClick() {
		        if (chkGroupBoard.checked) {
		            gubun = "1"
		        } else if (chkAnonyBoard.checked) {
		            gubun = "2";
		        } else if (chkPhotoBoard.checked) {
		            gubun = "3";
		        } else if (chkThumbBoard.checked) {
		            gubun = "4";
		        } else if (chkGeneralBoard.checked) {
		            gubun = "0";
		        } else if (chkQnABoard.checked) {
		            gubun = "5";
		        }

		        var para = new Array();
		        para[0] = BoardID;
		        para[1] = gubun;
		        var url = "/admin/ezBoard/boardExtensionAttribute.do";

		        /* 2018-07-12 홍승비 - 확장칼럼 설정 팝업창 width 조절 */
		        if (CrossYN()) {
		            BoardExtension_dialogArguments[0] = para;
		            var ExtensionAttribute = window.open(url, "ExtensionAttribute", GetOpenWindowfeature(770, 750));
		            try { ExtensionAttribute.focus(); } catch (e) { }
		        } else {
		            var retVal = window.showModalDialog(url, para, "dialogWidth:770px;dialogHeight:750px;status:no;help:no;scroll:yes;edge:sunken");
		        }
		    }
		    
		    //파일첨부크기 넘버값만 입력받기
		    function onlyNumber(event) {
		    	event = event || window.event;
				var keyID = (event.which) ? event.which : event.keyCode;
				
				if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
					return;
				else
					return false;
		    }
		    
		    function removeChar(event) {
				event = event || window.event;
				var keyID = (event.which) ? event.which : event.keyCode;
				
				if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
					return;
				else
					event.target.value = event.target.value.replace(/[^0-9]/g, "");
				
				var v_AttachSize = $("#txtAttachLimit").val();
		    	
		    	if (v_AttachSize > 2048) {
		    		alert("<spring:message code='ezBoard.hyj10'/>");
		    		$("#txtAttachLimit").val(2048);
		    	}
			}
	    </script>
	    <style type="text/css">
	    	.mainlist tr {
	    		height : 0px;
	    	} 
	    </style>
	</head>	
	<c:if test="${adminType != 'y'}">
		<body class="mainbody"><h1><spring:message code="ezBoard.t60"/></h1>
	</c:if>	
	<c:if test="${adminType == 'y'}">
		<body class="tabbody" style="margin-top:10px; overflow-y:auto;">
	</c:if>		
		<xml id="listviewheader" style ="display:none"></xml>
		<div style="max-width: 800px;">
		<table class="content">
	        <tr>
	            <th style="min-width: 88px;"><spring:message code="ezBoard.t114"/></th>
	            <td style="padding: 0;">
	            	<c:if test="${use_multiData == 'YES'}">
		                <table style="width: 100%">
		                    <tr class="primary">
		                        <th><c:out value='${lang_primary}' /></th>
		                        <td style="border-bottom:1px solid #ddd;"><c:out value='${model.boardName}' /></td>
		                    </tr>
		                    <tr class="secondary">
		                        <th><c:out value='${lang_secondary}' /></th>
		                        <td><c:out value='${model.boardName2}' /></td>
		                    </tr>
		                </table>
		            </c:if>
		            <c:if test="${use_multiData != 'YES'}"><c:out value='${model.boardName}' /></c:if>
	            </td>
	        </tr>
	    </table>
	    </div>
	    <br/>
	    <div style="max-width : 800px;">
	    <table class="content">
	        <tr>
	            <th style="min-width: 88px;"><spring:message code="ezBoard.t111"/></th>
	            <td style="padding: 0;">
	                <c:if test="${use_multiData == 'YES'}">
		                <table style="width: 100%;">
		                    <tr class="primary">
		                        <th><c:out value='${lang_primary}' /></th>
		                        <td style="border-bottom:1px solid #ddd;">
		                            <input type="text" id="txtBoardName" style="width: 100%" value="<c:out value='${model.boardName}' />" maxlength="20" />
		                        </td>
		                    </tr>
		                    <tr class="secondary">
		                        <th><c:out value='${lang_secondary}' /></th>
		                        <td>
		                            <input type="text" id="txtBoardName2" style="width: 100%" value="<c:out value='${model.boardName2}' />" maxlength="20" />
		                        </td>
		                    </tr>
		                </table>
		            </c:if>    
	          		<c:if test="${use_multiData != 'YES'}">
	                	<input type="text" id="txtBoardName" style="width: 100%" value="<c:out value='${model.boardName}' />" maxlength="20" />
	                </c:if>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code="ezBoard.t154"/></th>
	            <td><c:out value='${model.boardNo}' /></td>
	        </tr>
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t155"/></th>
	            <td>
	                <input type="text" id="txtBoardDescription" style="width: 100%" value="<c:out value='${model.boardDescription}' />" maxlength="99" />
	            </td>
	        </tr>
	        <tr id="expireTr" style="${style}">
	            <th><spring:message code="ezBoard.t156"/></th>
	            <td>
	            	<c:if test="${model.itemExpires == '-1'}">	            
		                <input type="checkbox" id="chkPermanent" onclick="chkPermanent_onclick()" checked />
		                <spring:message code="ezBoard.t157"/>
		                <input type="checkbox" id="chkExpires" onclick="chkExpires_onclick()" />
		                <input type="text" id="txtExpires" value="365" style="width: 35px" />
		                <spring:message code="ezBoard.t158"/>
	            	</c:if>
	                <c:if test="${model.itemExpires != '-1'}">   
		                <input type="checkbox" id="chkPermanent" onclick="chkPermanent_onclick()" />
		                <spring:message code="ezBoard.t157"/>
		                <input type="checkbox" id="chkExpires" onclick="chkExpires_onclick()" checked />
		                <input type="text" id="txtExpires" style="width: 35px" value="<c:out value='${model.itemExpires}' />" />
		                <spring:message code="ezBoard.t158"/>
	                </c:if> 
				</td>
	        </tr>
	        <tr id="deleteAfterTr" style="${style}">	        
	        	<c:if test="${model.deleteAfter == '-1'}">
		            <th><spring:message code="ezBoard.t159"/></th>
		            <td>
		            	<spring:message code="ezBoard.t160"/>
	                	<input type="inputbox" id="deleteafter" style="width: 50px;height:20px;margin-top:3px"/>
	                	<spring:message code="ezBoard.t161"/><br/>
	                	<input type="checkbox" id="usedeleteafter"/>
	                	<spring:message code="ezBoard.t162"/>
	                </td>
	            </c:if>
	            <c:if test="${model.deleteAfter != '-1'}">
	            	<th><spring:message code="ezBoard.t159"/></th>
	            	<td>
	            		<spring:message code="ezBoard.t160"/>
	                	<input type="inputbox" id="deleteafter" style="width: 50px;height:20px;margin-top:3px" value="<c:out value='${model.deleteAfter}' />"/>
	                	<spring:message code="ezBoard.t161"/><br/>
	                	<input type="checkbox" id="usedeleteafter" checked />
	                	<spring:message code="ezBoard.t162"/>
	                </td>
	            </c:if>
	        </tr>
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t163"/></th>
	            <td>
	            	<c:if test="${model.guBun == '0'}">
	                	<input type="checkbox" id="chkGeneralBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t00053" />
	                </c:if>
	                <c:if test="${model.guBun != '0'}">
	                	<input type="checkbox" id="chkGeneralBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t00053"/>
	                </c:if>
	                <c:if test="${model.guBun == '1'}">	                   
	                	<input type="checkbox" id="chkGroupBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t164"/>
	                </c:if>
	                <c:if test="${model.guBun != '1'}">
	                	<input type="checkbox" id="chkGroupBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t164"/>
	                </c:if>
	                <c:if test="${model.guBun == '2'}">	                   
	                	<input type="checkbox" id="chkAnonyBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t165"/>
	                </c:if>
	                <c:if test="${model.guBun != '2'}">	                   
	                	<input type="checkbox" id="chkAnonyBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t165"/>
	                </c:if>
	                <c:if test="${model.guBun == '3'}">	                   
	                	<input type="checkbox" id="chkPhotoBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t166"/>
	                </c:if>
	                <c:if test="${model.guBun != '3'}">
	                	<input type="checkbox" id="chkPhotoBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t166"/>
	                </c:if>
	                <c:if test="${model.guBun == '4'}">	                   
	                	<input type="checkbox" id="chkThumbBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t3000"/>
	                </c:if>
	                <c:if test="${model.guBun != '4'}">
	                	<input type="checkbox" id="chkThumbBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t3000"/>
	                </c:if>
	                
	                <br>
	                <c:if test="${model.guBun == '5'}">	                   
	                	<input type="checkbox" id="chkQnABoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t00054" />
	                </c:if>
					<c:if test="${model.guBun != '5'}">	                   
	                	<input type="checkbox" id="chkQnABoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t00054" />
	                </c:if>
	                <%-- 2018-07-13 홍승비 - URL게시판 구분 추가 --%>
	                <c:if test="${model.guBun == '6' }">
	                	<input type="checkbox" id="chkURLBoard" onclick="checkboardtype()" checked />
	                	URL<spring:message code="ezBoard.t0006" />
	                </c:if>
	                <c:if test="${model.guBun != '6'}">
	                	<input type="checkbox" id="chkURLBoard" onclick="checkboardtype()" />
	                	URL<spring:message code="ezBoard.t0006"/>
	                </c:if>
	                 <input type="text" id="txtURL" style="width: 74%;margin-left: 1.5px;margin-bottom: 1px;" value="<c:out value='${model.url}' />" />                
	            </td>
	        </tr>
	        <tr id="tr3" style="${style}">
	            <th><spring:message code="ezBoard.t999020" /></th>
	            <td>
	                <input type="checkbox" id="chkApprBoard" onclick="checkApprBoard()"><spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr id="chkApprListMail" style="display:none;">
	            <th><spring:message code="ezBoard.t999019" /></th>
	            <td>
	                <input type="checkbox" id="chkApprBoardMail" onclick="checkApprMail()"><spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr id="chkApprList" style="display:none;">
	            <th>
	            	<a class="imgbtn"><span onclick="SelectTarget()"><spring:message code="ezBoard.t999003" /></span></a>
	            </th>
	            <td>
	                <span id="selectedTarget" style="vertical-align: middle;display:none;"></span>
	                <div class="listview" style="height:100px;overflow-y:auto;overflow-x:hidden;" id="AccessList"></div>
	            </td>
	        </tr>
	        <tr id="trPortlet" style="${style}">
	            <th><spring:message code="ezBoard.t481" /></th>
	            <td>
	                <input type="checkbox" id="chkPortletBoard" onclick="checkboardtype()" />
	                <spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr id="tr1" style="${style}">
	            <th><spring:message code="ezBoard.t5011" /></th>
	            <td>
	                <input type="checkbox" id="chkbackgroundimage" onclick="checkboardtype()" />
	                <spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr id="tr2" style="${style}">
	            <th><spring:message code="ezBoard.t999027" /></th>
	            <td>
	                <input type="checkbox" id="chkform" onclick="checkboardtype()" />
	                <spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr id="attachLimitTr" style="${style}">
	            <th><spring:message code="ezBoard.t167" /></th>
	            <td>
	                <input type="text" id="txtAttachLimit" style="width: 30px" onkeydown="onlyNumber()" onkeyup="removeChar()" value="<c:out value='${model.attachSizeLimit}'/>" maxlength="4"/>&nbsp;MB
	            </td>
	        </tr>
	        
	        <%-- URL 필드를 게시판 구분 필드로 이동 --%>
	   <%--      
	        <tr style="${style}">
	            <th>URL</th>
	            <td>
	                <input type="text" id="txtURL" style="width: 100%" value="<c:out value='${model.url}' />" />
	            </td>
	        </tr>
	         --%>
	        
	        <tr id="chkNotifyTr" style="${style}">
	            <th><spring:message code="ezBoard.t168" /></th>
	            <td>
	            	<c:if test="${model.replyNotify == '1'}">	            	
	                	<input type="checkbox" id="chkNotify" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t95" />
	                </c:if>
	                <c:if test="${model.replyNotify != '1'}">	                   
	                	<input type="checkbox" id="chkNotify" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t95" />
	                </c:if>		                 
	            </td>
	        </tr>
	        <%--2011-04 : 한줄 답변 옵션화 처리.--%>
	        <tr id="oneLineTr" style="${style}">
	            <th><spring:message code="ezBoard.t81" /></th>
	            <td>
	            	<c:if test="${model.oneLineReply == '1'}">	                
	                	<input type="checkbox" id="chkOneLine" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t496" />
	                </c:if>
	                <c:if test="${model.oneLineReply != '1'}">	                  
	                	<input type="checkbox" id="chkOneLine" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t496" />
	                </c:if>
	            </td>
	        </tr>	
	        <tr id="trAttribute" style="${style}">
	            <th><spring:message code="ezBoard.t999028" /></th>
	            <td>
	            	<a class="imgbtn imgbck"><span onClick="ExtensionAttribute_onClick()"><spring:message code="ezBoard.t999029" /></span></a>
	            </td>
	        </tr>	
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t169" /></th>
	            <td style="height: 100%">
	                <table style="width: 300px">
	                    <tr>
	                        <td style="width: 100px;">
	                            <div id="selColor" style="width: 100px; height: 100%; background-color: <c:out value='${model.boardColor}' />; border: 1px solid #686868;"></div>
	                        </td>
	                        <td style="width: 100px;">
	                            <span id="colorID" style="width: 80px;"><c:out value='${model.boardColor}' /></span>
	                        </td>
	                        <td style="text-align: right; width: 100px">
	                            <a class="imgbtn imgbck"><span onclick="change_brdColor()"><spring:message code="ezBoard.t170" /></span></a>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
		</table>
	    <div class="btnpositionJsp">
	        <a class="imgbtn" href="javascript:Save()"><span><spring:message code="ezBoard.t98" /></span></a>
	    </div>
	    </div>
	</body>
</html>