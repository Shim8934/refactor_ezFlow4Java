<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t111'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezCircular.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/composeappt_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/Schedule_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/circularComment.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/circular.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPoll/stomp.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPoll/sockjs.min.js')}"></script>
		
		<style>
			#btnCircularConfirm {
				display: inline-block;
			    background: url(/images/kr/cm/btn_popup_onright.gif) no-repeat center;
			    height: 23px;
			    padding: 0px 6px 0px 6px;
			    line-height: 24px;
			    font-size: 12px;
			    color: #333;
			    cursor : pointer;
			    border: 1px solid;
			}

			#divCross p a {
				color: blue;
				text-decoration: underline;
				cursor: pointer;
			}
			
			#divCross p {
				margin-top: 0px; margin-bottom: 0px;
			}
			
			#divCross p span{
				font-size: inherit;
			}
			
			#divCross h1{
				display: block;
    			font-size: 2em;
    			margin-block-start: 0.67em;
    			margin-block-end: 0.67em;
    			margin-inline-start: 0px;
    			margin-inline-end: 0px;
    			font-weight: bold;
    			unicode-bidi: isolate;
			}
			
			#divCross h2{
				display: block;
    			font-size: 1.5em;
    			margin-block-start: 0.83em;
    			margin-block-end: 0.83em;
    			margin-inline-start: 0px;
    			margin-inline-end: 0px;
    			font-weight: bold;
    			unicode-bidi: isolate;
			}
			
			#divCross h3{
				display: block;
    			font-size: 1.17em;
    			margin-block-start: 1em;
    			margin-block-end: 1em;
    			margin-inline-start: 0px;
    			margin-inline-end: 0px;
    			font-weight: bold;
    			unicode-bidi: isolate;
			}
			
			#divCross h4{
				font-size:1em;
				display: block;
    			margin-block-start: 1.33em;
    			margin-block-end: 1.33em;
    			margin-inline-start: 0px;
    			margin-inline-end: 0px;
    			font-weight: bold;
    			unicode-bidi: isolate;
			}
			
			#divCross h5{
				display: block;
    			font-size: 0.83em;
    			margin-block-start: 1.67em;
    			margin-block-end: 1.67em;
    			margin-inline-start: 0px;
    			margin-inline-end: 0px;
    			font-weight: bold;
    			unicode-bidi: isolate;
			}
			
			#divCross h6{
				display: block;
    			font-size: 0.67em;
    			margin-block-start: 2.33em;
    			margin-block-end: 2.33em;
    			margin-inline-start: 0px;
    			margin-inline-end: 0px;
    			font-weight: bold;
    			unicode-bidi: isolate;
			}
			
			.popup h1 {
				all:unset;
			}
			
			.popup h2 {
				all:unset;
			}
			
		</style>
		
		<script type="text/javascript" >
			var circularID = "<c:out value='${result.circularID}'/>";
			var circularUserID = "<c:out value='${result.memberID}'/>";
			var updateStatus = "<c:out value='${result.updateStatus}'/>";
			var status = "<c:out value='${result.status}'/>";
			var userInfoID = "<c:out value='${userInfo.id}'/>";
			var option = "<c:out value='${result.option}'/>";
			var type = "<c:out value='${type}'/>";
			var wcompanyID = "<c:out value='${result.companyID}'/>"
			var ucompanyID = "<c:out value='${userInfo.companyID}'/>";
			var attachList = "";
			var deptID = "<c:out value='${deptID}'/>";
			var company = "<c:out value='${company}'/>"
			var tenantID = "<c:out value='${userInfo.tenantId}'/>";
			var stompClient = null;

			window.onunload = function() {
				if (stompClient !== null) {
					stompClient.disconnect();
				}
			};
			
			$(document).ready(function() {
				getCmtSockConnect(); /* 회람 상태 확인을 위해 웹소켓 연결추가 */
				stompDisConnProcess(); /* 웹소켓 끊어짐 처리 */
				
				if(circularID == "") {
					alert("<spring:message code='ezCircular.kmsc05'/>");
					window.close();
					return;
				}
				
				if(ucompanyID != wcompanyID) {
					alert("<spring:message code='ezCircular.kmsc03' /> " + company +"<spring:message code='ezCircular.kmsc04' />");
					window.close();
					return;
				}
				
	            document.getElementById("divCross").innerHTML = sigBody.innerHTML
	            document.getElementById("printDocument").innerHTML = sigBody.innerHTML;
	            
	            document.getElementById("divCross").style.height = window.innerHeight - 340 + "px";
// 	            document.getElementById("divCross").style.width = window.innerWidth - 40 + "px";
	            
				if ("<c:out value='${attachList}'/>" != "") {
					attachList = true;
				}

				// 상세보기 창에서 링크 새창으로 띄우기 위해 추가
				if ($("#divCross p a").length > 0) {
					$("#divCross p a").attr("target", "_blank")
				}
				
				//2018-07-10 김보미 - 제목이 2줄이상일 경우 공백 추가
				titleSpace();
				//2018-07-16 김보미 - 제목이길어질때 내용부분 높이 조정
				titleHeight();
				
	        });
			
			window.onresize = function () {
				var contentHeight;
				document.getElementById("divCross").style.height = window.innerHeight - 340 + "px";
// 				document.getElementById("divCross").style.width = window.innerWidth - 40 + "px";

				//2018-07-10 김보미 - 제목 공백 조절
				titleSpace();
				//2018-07-16 김보미 - 제목이길어질때 내용부분 높이 조정
				titleHeight();
			};
			
			/* 18-05-25 김민성 - 회람판 > 회람 상세정보 회람확인 시 창 새로고침 되도록 수정 */
			function circularConfirm() {
				if(!confirm("<spring:message code='ezCircular.t196' />")) {
					return;
				}
				
				$.ajax({
					type : "POST",
					url : "/ezCircular/circularConfirm.do",
					dataType : "json",
					data : {
						circularID : circularID
					},
					success : function(result) {
						//getConfirmStatus();
						window.location.reload();
						window.opener.getLeftCount();
						window.opener.refresh_onclick();
					},error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezCircular.t102' />");
					}
				});
			}
			
			function getConfirmStatus() {
				confirmStatus = "<img src='/images/ImgIcon/msg-rd.png' style='vertical-align:middle;'/>&nbsp;<spring:message code='ezCircular.t65' />";
				$("#circularConfirm").hide();
				
				$(".confirmStatus").html(confirmStatus);
				
				$("#circular_bar").hide();
			}
			
			function getCommentCount() {
				$.ajax({
					type : "POST",
					url : "/ezCircular/getCommentCount.do",
					dataType : "json",
					data : {
						circularID : circularID
					},
					success : function(result) {
// 						result.totalCommentCount;
// 						result.myCommentCount;
						
						$("#commentCount").html("<spring:message code='ezCircular.t180' />[" + result.myCommentCount + "/" + result.totalCommentCount + "]");
					},error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezCircular.t102' />");
					}
				});
			}

		    //삭제버튼 클릭시
	        function btn_delete() {
	            if (!confirm("<spring:message code='ezCircular.t46'/>")) {
	                return;
	            }
	            
	            if (updateStatus == "2" || status == "2") {
	            	$.ajax({
						type : "POST",
						dataType : "json",
						async : false,
						url : "/ezCircular/deleteCircular.do",
						data : { 
							circularID : circularID,
							memberID : circularUserID
						},
						success: function() {
							window.opener.refresh_onclick();
			                closing();
						},
						error: function(err) {
							alert("<spring:message code='ezCircular.t102' />");
						}
					});
	            } else {
	            	$.ajax({
						type : "POST",
						dataType : "json",
						async : false,
						url : "/ezCircular/circularDeleteTemp.do",
						data : { 
							circularIDList : circularID + ";"
						},
						success: function() {
							//2018-02-14 김보미 - 사용안해서 주석.
							//window.opener.getLeftCount();
							window.opener.refresh_onclick();
			                closing();
						},
						error: function(err) {
							alert("<spring:message code='ezCircular.t102' />");
						}
					});
	            }
	        }
		    
		    /* 18-05-25 김민성 - 확인자 조회 */
	        function circularConfirmList(currentPage) {
		    	if (!currentPage) {
					currentPage = "";
				}
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 620) / 2;
		        var top = (heigth - 425) / 2;
		        var szHref = url = "/ezCircular/circularConfirmList.do?circularID=" + circularID; 
	            DivPopUpShow(620, 425, szHref);
		    }
		    
	        var ezprtquestion_cross_dialogArguments = new Array();

	        //인쇄버튼 클릭시
	        function print_onClick() {
	        	var parameter = "";
	        	
	            var url = "/ezCircular/circularprtQuestion.do?attachList=" + attachList;

	            if (CrossYN()) {
	                ezprtquestion_cross_dialogArguments[0] = parameter;
	                ezprtquestion_cross_dialogArguments[1] = OpenQuestionUI_Complete;

	                DivPopUpShow(450, 210, url);
	            }
	            else {
	                var feature = "status:no;dialogWidth:450;dialogHeight:210px;help:no;";
	                feature = feature + GetShowModalPosition(450, 210);
	                var RtnVal = window.showModalDialog(url, parameter, feature);

	                return RtnVal;
	            }
	        }
	        
	        function OpenQuestionUI_Complete(ret) {
	            DivPopUpHidden();

	            if (ret[0] == "0" && ret[1] == "0") // 취소
	                return;
	            var rtnVal = "";

	            if (ret[0] == "Y" && ret[1] == "N") { // 의견만 인쇄
	            	$("#attachView").remove();
	            	getCircularPrintComment(circularID, userInfoID, status);
	            } else if (ret[0] == "N" && ret[1] == "Y") { // 첨부파일만 인쇄
	            	$("#printCommentLists").remove();
					$("#printCircularUserList").remove();
	            	SetAttachmentInfo();
	            } else if (ret[0] == "N" && ret[1]== "N") { // 문서만 인쇄
	            	$("#printCommentLists").remove();
					$("#printCircularUserList").remove();
					$("#attachView").remove();
	            } else {
	            	getCircularPrintComment(circularID, userInfoID, status);
	            	SetAttachmentInfo();
	            }

				print_onClick2();
	        }
	        
	        function print_onClick2() {
				var feature = GetOpenPosition(700, 700);
	            printWindow = window.open("", "mywindow", "width=700, height=700,location=0,status=0,scrollbars=1,resizable=1" + feature);
	            var strContent = "<html><head>";
	            strContent = strContent + "<title>" + strLangLHM02 + "</title>";
	            strContent = strContent + "<link rel=\"stylesheet\" href=\"/css/" + strLangLHM01 + ".css\" type=\"text/css\" />";
	            strContent = strContent + '<style type="text/css">p {margin-top: 0px;margin-bottom: 0px;}</style>';
	            strContent = strContent + "</head><body style='padding:10px;'onload='window.print();' >";
	            strContent = strContent + "<div style='width:100%'>";
	            strContent = strContent + "<table id='printScreen' class='layout'>";
	            strContent = strContent + document.getElementById("printScreen").innerHTML;
	            strContent = strContent + "</table></div>";
	            strContent = strContent + "</body>";
	            printWindow.document.write(strContent);
	            printWindow.document.close();
	            printWindow.focus();
	        }

	        function attach_SelectAll() {
			    var checks = document.getElementById('attachedfileDIV').getElementsByTagName("input");
			    for (var i = 0; i < checks.length; i++)
			        checks.item(i).checked = true;
			}
        
			function attach_Download() {
			    checks = document.getElementById('attachedfileDIV').getElementsByTagName("input");
			    downloadAll(checks)
			}

			var suffix = 0;
			function downloadAll(checks) {
			    if (checks.item(suffix)) {
			        if (checks.item(suffix).checked) {
			            if (GetAttribute(checks.item(suffix), "attachid") != "" && GetAttribute(checks.item(suffix), "attachid") != null) {
			                location.href = encodeURIComponent(GetAttribute(checks.item(suffix++), "filepath"));
			            } else {		            	
			                location.href = "/ezCircular/downloadAttach.do?filePath=" + encodeURIComponent(GetAttribute(checks.item(suffix), "filePath")) + "&fileName=" + GetAttribute(checks.item(suffix++), "fileName") + "&circularID=" + circularID;
			            }
			            setTimeout(function () { downloadAll(checks) }, 1000);
			        } else {
			            suffix++;
			            downloadAll(checks);
			        }
			    } else
			        suffix = 0;
			}
			
			function closing() {
	          	window.close();
			}
			
			function getCircularPrintComment(circularID, userInfoID, status) {
				if ($("#printCommentLists").length == 0) {
					$("#printDocument").html($("#printDocument").html() + '<div id = "printCommentLists" style="border-top:1px solid; height:30px; vertical-align:middle;"><p style="font-size:15px; font-weight:bold; margin-left:10px;"><spring:message code = "ezCircular.t180" /></p></div><table id="printCircularUserList" style="width:100%;margin-top:15px;table-layout: fixed;border:1px solid #e2e2e2"></table>');					
				}

				printCircularUserList = ""
	        	$.ajax({
            		type : "POST",
            		url : "/ezCircular/getCircularComment.do",
            		dataType : "json",
            		async : false,
            		data : {
            			circularID : circularID,
            			commentType : "totalComment",
            			searchValue : ""
            		},
            		success : function(result) {
            			printCircularUserList = "<colgroup><col width='20%' /><col width='60%' /><col width='20%' /></colgroup>";    			
            			list = result.circularUserList;
            			list.forEach(function(vo, index) {
            				printCircularUserList += "<tr class='printCircularUser' circularUserID='" + vo.memberID + "' style='height:40px;text-align:left;vertical-align:middle;'>";
            				printCircularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:left;background-color:white;'>";
            				
            				if (vo.status == 1) {
            					//확인 이미지
            					printCircularUserList += "<img src='/images/ImgIcon/msg-rd.png' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
            				} else {
            					//미확인 이미지
            					printCircularUserList += "<img src='/images/ImgIcon/msg-unrd.png' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
            				}
            				
            				printCircularUserList += "</th>";
            				printCircularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:right;background-color:white;' colspan='2'>";
            				//확인일
            				if (vo.status == 1) {
            					printCircularUserList += vo.confirmDate.substring(0, 16);
            				}
            				
            				printCircularUserList += "</th>";
            				printCircularUserList += "</tr>";
            			});

            			$("#printCircularUserList").html("");
            			$("#printCircularUserList").append(printCircularUserList);
            			
            			var now = new Date();

            			printCircularCommentList = "";
            			list = result.circularCommentList ;
            			list.forEach(function(vo, index) {
            				printCircularCommentList  = "<tr class='printCircularComment' circularUserID='" + vo.circularUserID + "' memberID='" + vo.memberID + "' circularCommentID='" + vo.circularCommentID + "' circularCommentStatus='" + vo.status + "'>";
            				printCircularCommentList += "<td style='padding-left:3px; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>&nbsp;&nbsp;<img src='/images/ImgIcon/commentRe.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "</td>";
            				printCircularCommentList += "<td style='text-align:left;padding:8px; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>" + vo.circularComment + "&nbsp;&nbsp;";
            				
            				printCircularCommentList += "</td>";
            				printCircularCommentList += "<td style='text-align:right; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>" + vo.regDate.substring(0, 16) + "</td>";
            				printCircularCommentList += "</tr>";
            				
            				if (vo.status == 0) {
            					if ($(".printCircularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
            						$(".printCircularUser[circularUserID='" + vo.circularUserID + "']").after(printCircularCommentList);
            					} else {
            						$(".printCircularComment[circularUserID='" + vo.circularUserID + "']:last").after(printCircularCommentList);
            					}
            				} else {//비공개
            					if (vo.memberID == userInfoID || vo.circularUserID == userInfoID) {
            						if ($(".printCircularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
            							$(".printCircularUser[circularUserID='" + vo.circularUserID + "']").after(printCircularCommentList);
            						} else {
            							$(".printCircularComment[circularUserID='" + vo.circularUserID + "']:last").after(printCircularCommentList);
            						}
            					}
            				}
            			});
            		},
            		error : function(jqXHR, textStatus, errorThrown) {
            			
            		}
            	});
			}

			function SetAttachmentInfo() {
				var xmlhttp = createXMLHttpRequest();
		        var xmldom = createXmlDom();
		        xmlhttp.open("GET", "/ezCircular/getItemAttachments.do?pcircularId=" + circularID, false);
		        xmlhttp.send();
		        xmldom = loadXMLString(xmlhttp.responseText);
		        xmlhttp = null;
		        var filename = "";
		        var filetype = "";
		        var imagePath = "";
		        var strAttachView = "";
		        var strAttach = new Array();

		        strAttachView += "<table id='attachView' class='layout' style='margin-top:5px; height:66px;'>";
		        strAttachView += "<tr><td class='pad1'><table class='file2'>";
		        strAttachView += "<tr><th><spring:message code='ezBoard.t292'/></th>";
		        strAttachView += "<td style='width:100%;'><div id='lstAttachLink' style='padding-top:3px;padding-bottom:3px;padding-left:3px;OVERFLOW:visible;background-color:white; text-align:left'></div></td>";
		        strAttachView += "<td id='ItemLevel' style='display:none;'></td>";
		        strAttachView += "</tr></table></td></tr></table>";

		        if ($("#attachView").length == 0) {
			        $(".content2").after(strAttachView);		        	
		        }

		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        for (var i = 0; i < xmldomNodes.length; i++) {
		            filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
		            filename = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
		            filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
		            filetype = getNodeText(SelectSingleNode(xmldomNodes[i], "FileType"));
           
		            if (filetype == "jpg" || filetype == "jpeg" || filetype == "bmp" || filetype == "gif" || filetype == "png" || filetype == "tif" || filetype == "tiff") {
		            	imagePath = "/images/image.png";
		            } else if (filetype == "doc" || filetype == "docx") {
		            	imagePath = "/images/doc.png";
		            } else if (filetype == "xls" || filetype == "xlsx") {
		            	imagePath = "/images/xls.png";
		            } else if (filetype == "ppt" || filetype == "pptx" || filetype == "pps" || filetype == "ppsx") {
		            	imagePath = "/images/ppt.png";
		            } else if (filetype == "txt") {
		            	imagePath = "/images/txt.png";
		            } else if (filetype == "zip") {
		            	imagePath = "/images/zip.png";
		            } else if (filetype == "pdf") {
		            	imagePath = "/images/pdf.png";
		            } else if (filetype == "ecm") {
		            	imagePath = "/images/ecm.png";
		            //2018-02-13 주홍선 mht파일 아이콘 표시되지 않던 것 수정
		            } else {
		            	imagePath = "/images/file.gif";
		            }

		            strAttach[i] = "<img src='" + imagePath + "'/>&nbsp;" + filename + "&nbsp;(" + filesize + ")<br>";
		        }

		        $("#lstAttachLink").html("");
		        for (var i = 0; i<strAttach.length; i++) {
		        	$("#lstAttachLink").append(strAttach[i]);
		        }
		    }
			
			function circularModify() {
				window.location.href = "/ezCircular/circularWrite.do?circularID=" + circularID + "&mode=modify" + "&updateStatus=" + updateStatus;
			}
			
			var xhr = new XMLHttpRequest();
			function circularReUse() {
// 				xhr.open("POST","/ezCircular/circularWrite.do?circularID=" + circularID + "&mode=reuse");
				window.location.href = "/ezCircular/circularWrite.do?circularID=" + circularID + "&mode=reuse";
			}
			
			// 18-05-02 김민성 - 작성자 이름 클릭 시 사원정보보기 팝업
			function OpenUserInfo() {
	        	var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 450);
	            window.open("/ezCommon/showPersonInfo.do?id=" + circularUserID + "&dept=" + deptID, "", feature);
	        }
			
			function CircularClose_onclick() {
				if(confirm("<spring:message code='ezCircular.t170'/>")) {
					$.ajax({
						type : "POST",
						dataType : "json",
						async : false,
						url : "/ezCircular/circularClose.do",
						data : {
							circularIDList : circularID
						},
						success: function(){
							window.location.reload();
							window.opener.getLeftCount();
							window.opener.refresh_onclick();
						}, error: function() {
							alert("<spring:message code='ezCircular.t102'/>");
						}
		        	});	
				}
			}
			
			//2018-07-10 김보미 - title부분 길이를 비교해 2줄 이상이면 공백을 더 준다.
			function titleSpace() {
				var text = $("#titleTd").html();
				var res;
				var cont = $('<div>' + text + '</div>').css("display", "table")
								.css("z-index", "-1").css("position", "absolute")
								.css("font-family", $("#titleTd").css("font-family"))
								.css("font-size", $("#titleTd").css("font-size"))
								.css("font-weight", $("#titleTd").css("font-weight")).appendTo('body');
				res = (cont.width() > $("#titleTd").width());
				cont.remove();
				
				if (res) {
					$("#titleTd").css("padding","6px 4px 6px 6px");
				} else {
					$("#titleTd").css("padding","");
					$("#titleTd").css("padding-left","4px");
				}
			}
			
			//2018-07-16 김보미 - 타이틀 높이에 따라 content부분 높이 조절
			function titleHeight() {
				var titleHeight = $("#titleTd").height();
				var tdHeight = 26; //한줄일때의 td 높이
				
				var res = (titleHeight - tdHeight);
				res = ($("#divCross").css("height").replace(/[^-\d\.]/g, '') - res) + "px";
				
				$("#divCross").css("height", res);
			}
			
			function addRelatedCabinet() {
				window.open("/ezCabinet/cabinetAddRelated.do?module=option", "addRelated", getOpenWindowfeature(480, 505));
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}

			/* 문서 열람 시 수정 이벤트 수신을 위한 WebSocket subscribe 설정 */
			function getCmtSockConnect() {
				var socket = new SockJS('/hello');
				stompClient = Stomp.over(socket);
				stompClient.connect({}, function (frame) {
					stompClient.subscribe('/reply/getSeenUpdateForCircular' + circularID + "+" + tenantID, function (updatedInfo) {
						var status = JSON.parse(updatedInfo.body).status;
						var updatedCircularId = JSON.parse(updatedInfo.body).circuralrId;

						if (status == "MODIFY" && updatedCircularId == circularID) {
							alert("<spring:message code='ezCircular.t199' />");
							window.location.reload();
						}
					});
				});
			}			
			function stompDisConnProcess() {
				setInterval(function(){
					if(stompClient.connected === false){
						window.location.reload();
					}
				}, 10000);
			}
		</script>
	</head>
	<style>
		.content td{ 
			width:160px;
		}
	</style>
 	<xmp id="sigBody" style="display: none;">${result.content}</xmp>
 	
 	<!-- 18-05-25 김민성 - 회람판 조회 상단 부분 수정-->
	<body id="mainbodytag" class="popup">
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	    <table id="normalScreen" class="layout">
    	    <tr>
        	    <td style="height: 20px">
            	    <div id="menu">
                	    <ul>
                	    	<!-- 2018-06-04 김민성 - 회람 상세정보 상단 버튼 수정 -->
                	    	<!-- 회람확인이 뜨는 사람 - 회람 작성자 이외의 사람 -->
                	    	<c:if test="${result.confirmStatus == '0'}">
								<li id="circularConfirm"><span onclick="circularConfirm()"><spring:message code='ezCircular.t195' /></span></li>
                	    	</c:if>
                	    	
                	    	<!-- 회람종료가 뜨는 사람 - 회람 작성자 -->
                	    	<c:if test="${result.memberID == userInfo.id && result.status == '0'}">
		                        <li><span onClick="CircularClose_onclick()"><spring:message code='ezCircular.t57'/></span></li>
		                    </c:if>

               	    		<li><span onclick="openCircularComment()" id="commentCount"><spring:message code='ezCircular.t180' />[<c:out value='${myCommentCount}'/>/<c:out value='${totalCommentCount }'/>]</span></li>
	                        
	                        <li><span onclick="circularConfirmList()"><spring:message code='ezCircular.kmsc01' /></span></li>
	                        <c:if test="${result.memberID == userInfo.id}">
	                        	<c:if test="${result.status == '0'}">
		                        	<li><span onclick="circularModify()"><spring:message code='ezCircular.t184' /></span></li>
		                        </c:if>		                       
	                        </c:if>
	                        <c:if test="${result.memberID == userInfo.id}">
	                        	 <li><span onclick="circularReUse()"><spring:message code='ezCircular.t183' /></span></li>
	                        </c:if>
							<c:if test="${type != 'new'}">
	                        	<li id="deletebtbn"><span class="icon16 popup_icon16_delete" onclick="btn_delete()"></span></li>
	                        </c:if>
	                        <li><span class="icon16 popup_icon16_print" onclick="print_onClick()"></span></li>	                        
                    		<c:if test="${useCabinet == 'YES'}">
								<li><span onclick="addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
                    		</c:if>
                    	</ul>
                	</div>
                	<div id="close">
	                    <ul>
    	                    <li><span onclick="closing();"></span></li>
        	            </ul>
            	    </div>
            	    
            	    <script type="text/javascript" >
		      			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		  			</script>
            	    
            	    <!-- 18-05-24 김민성 - 회람판 > 회람 본문 작성일 단어 등록일로 수정 -->
					<table class="content" style="width:100%;">
	                    <tr>
    	                    <th style="width: 10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t32' /></th>
    	                    <!-- 2018-07-10 김보미 - td에 id값 추가 -->
        	                <td colspan="3" id="titleTd" style="padding-left: 4px;"><c:out value = '${result.title}' /></td>
                    	</tr>
                    	<tr>
							<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t122' /></th>
	       					<td style="padding-left: 4px;" ><div id="writer"  onclick="OpenUserInfo()" style="vertical-align: middle; cursor: pointer;"> <c:out value='${result.memberName }'/></div></td>
							<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezBoard.t5007' /></th> 
 							<td style="padding-left: 6px;"><div id="printStatus"><c:out value='${result.regDate }'/></div></td>
						</tr>
                    	<tr>
	                        <th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t115' /></th>
    	                    <td id="Td_Importance" style="padding-left: 4px;">
    	                    	<c:if test="${result.importance == '0' }">
	    	                    	<span><spring:message code='ezCircular.t185' /></span>  	                    	
    	                    	</c:if>
    	                    	<c:if test="${result.importance == '1' }">
	    	                    	<span><spring:message code='ezCircular.t116' /></span>  	                    	
    	                    	</c:if>
    	                    	<c:if test="${result.importance == '2' }">
	    	                    	<span><spring:message code='ezCircular.t117' /></span>  	                    	
    	                    	</c:if>
    	                    </td>
		            		<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t118' /></th>
		            		<td>
		                		<c:choose>
		                			<c:when test="${result.option eq '1'}">
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t119' /></span>
		                			</c:when>
		                			<c:when test="${result.option eq '2'}">
		                				<span id="AllDay" style="padding-left: 4px;"><spring:message code='ezCircular.t120' /></span>
		                			</c:when>
		                			<c:when test="${result.option eq '3'}">
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t119' /></span>,  
										<span id="AllDay"><spring:message code='ezCircular.t120' /></span>
		                			</c:when>
		                			<c:otherwise>
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t121' /></span>
		                			</c:otherwise>
		                		</c:choose>
							</td>
                    	</tr>
						<tr>
		        			<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t74' /></th>
	       					<td><div id="statusNum" style="padding-left: 4px;"><c:out value='${result.confirmCount}'/> / <c:out value='${result.confirmTotalCount}'/></div></td>
	         				<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t124' /></th>
		            		<td>
		            			<c:choose>
			            			<c:when test="${result.status eq '0'}">
			            				<div id="status" style="padding-left: 4px;"><spring:message code='ezCircular.t125' /></div>
			            			</c:when>
			            			<c:when test="${result.status eq '1'}">
			            				<div id="status" style="padding-left: 4px;"><spring:message code='ezCircular.t126' /></div>
			            			</c:when>
			            			<c:otherwise>
			            				<div id="status" style="padding-left: 4px;"><spring:message code='ezCircular.t127' /></div>
			            			</c:otherwise>
		                		</c:choose>
		            		</td>
		        		</tr>
		        		<tr>
		        		<!-- 2018-06-01 김민성 - 종료일 탭 추가 -->
		            		<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezCircular.t86' /></th>
		            		<td class="confirmStatus" style="padding-left: 4px; vertical-align: middle;">
		            			<c:choose>
		            				<c:when test="${result.confirmStatus == '0'}">
		            					<img src='/images/ImgIcon/msg-unrd.png' style='vertical-align:middle;'/>&nbsp;<spring:message code='ezCircular.t143' />
		            				</c:when>
		            				
		            				<c:when test="${result.confirmStatus == '1'}">
		            					<img src='/images/ImgIcon/msg-rd.png' style='vertical-align:middle;'/>&nbsp;<spring:message code='ezCircular.t65' />
		            				</c:when>
		            			</c:choose>
		            		</td>
		            		<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezPoll.t161' /></th>
		            		<td>
		            			<div id="endDate" style="padding-left: 4px;"><c:out value='${fn:substring(result.endDate,0,16) }'/></div>
		            		</td>
		        		</tr>
	        		</table>
	        		<br/>
	        		<table class="content" style="width:100%; table-layout: fixed;">
	        			<tr>
	            			<td colspan="4"><div id="divCross" style="margin:8px; overflow:auto;"></div></td>
	        			</tr>
	        		</table>
	        		<br/>
                    <table class="file">
                        <tr>
                            <th>
                                <spring:message code='ezCircular.t108' />
                            </th>
                            <td>
                                <div id="attachedfileDIV" style="margin-top: 0px; overflow: auto; padding-top: 0px;height: 70px; border-top-width: 0px;" align="left">
                                    <c:forEach var="item" items="${attachList}" varStatus="status">
                                    	<div style="margin-top:3px;height:auto;">
											<div class="custom_checkbox">
												<c:set var="imagePath" value="/images/file.gif" />
													<input id="fileSelect${status.index}" type="checkbox" filename="${item.fileEncodeName}" filepath="${item.filePath}">
												<label for="fileSelect${status.index}">
													<c:if test="${item.fileType == 'jpg' || item.fileType == 'jpeg' || item.fileType == 'bmp' || item.fileType == 'gif' || item.fileType == 'png' || item.fileType == 'tif' || item.fileType == 'tiff'}">
														<c:set var="imagePath" value="/images/image.png" />
													</c:if>
													<c:if test="${item.fileType == 'doc' || item.fileType == 'docx'}">
														<c:set var="imagePath" value="/images/doc.png" />
													</c:if>
													<c:if test="${item.fileType == 'xls' || item.fileType == 'xlsx'}">
														<c:set var="imagePath" value="/images/xls.png" />
													</c:if>
													<c:if test="${item.fileType == 'ppt' || item.fileType == 'pptx' || item.fileType == 'pps' || item.fileType == 'ppsx'}">
														<c:set var="imagePath" value="/images/ppt.png" />
													</c:if>
													<c:if test="${item.fileType == 'txt'}">
														<c:set var="imagePath" value="/images/txt.png" />
													</c:if>
													<c:if test="${item.fileType == 'zip'}">
														<c:set var="imagePath" value="/images/zip.png" />
													</c:if>
													<c:if test="${item.fileType == 'pdf'}">
														<c:set var="imagePath" value="/images/pdf.png" />
													</c:if>
													<c:if test="${item.fileType == 'ecm'}">
														<c:set var="imagePath" value="/images/ecm.png" />
													</c:if>	                    
													<img src="${imagePath}" style="vertical-align: middle" />&nbsp;<a href="/ezCircular/downloadAttach.do?circularFileID=${item.circularFileID}" id="regData_${status.count}" style="vertical-align:text-bottom;"><c:out value='${item.fileName}'/> (<c:out value='${item.fileTranSize}'/>)</a>
												</label>
                                    		</div>
										</div>
                                    </c:forEach>
                                </div>
                            </td>
                            <td class="pos2">	                                
                                <a class="imgbtn imgbck">
                                	<span style="width:57px;" onclick="attach_SelectAll()"><spring:message code='ezCircular.t112' /></span>
                                </a><br/>	                                
                                <a class="imgbtn imgbck">
                                	<span style="width:57px;" onclick="attach_Download()"><spring:message code='ezCircular.t25' /></span>
                                </a>
                            </td>
                        </tr>
                    </table>
	        	</td>
        	</tr>
		</table>
		
		<!-- 18-05-24 김민성 - 회람 인쇄 시 작성일 > 등록일로 수정 -->
		<table id="printScreen" style="display: none;">
			<tr style="text-align:center">
				<td style="vertical-align:top">
					<table style="width:100%; border:0px; padding:1px; border-collapse:collapse; border-spacing:0px; " class="content2">
						<tr style="height:25px"> 
 							<th style="padding-left:10px"><spring:message code='ezCircular.t32' /></th> 
 							<td style="padding-left:4px; width:100%" colspan="3">
 								<div id="printTitle">
 									<c:out value='${result.title}'/>
 								</div>
 							</td> 
						</tr>
						<tr style="height:25px">
							<th style="padding-left: 10px;"><spring:message code='ezCircular.t122' /></th>
	       					<td style="padding-left: 4px;">								
	         					<div id="writer" ><c:out value='${result.memberName }'/></div>
	         				</td>
							<th style="padding-left:10px"><spring:message code='ezBoard.t5007' /></th> 
 							<td style="padding-left:6px">
 								<div id="printStatus"><c:out value='${result.regDate }'/></div>
 							</td> 
						</tr>
						<tr style="height:25px"> 
 							<th style="padding-left:10px"><spring:message code='ezCircular.t115' /></th> 
 							<td style="padding-left: 4px; width:200px">
    	                    	<c:if test="${result.importance == '0' }">
	    	                    	<span><spring:message code='ezCircular.t185' /></span>  	                    	
    	                    	</c:if>
    	                    	<c:if test="${result.importance == '1' }">
	    	                    	<span><spring:message code='ezCircular.t116' /></span>  	                    	
    	                    	</c:if>
    	                    	<c:if test="${result.importance == '2' }">
	    	                    	<span><spring:message code='ezCircular.t117' /></span>  	                    	
    	                    	</c:if>
    	                    </td>
    	                    <th style="padding-left:10px;"><spring:message code='ezCircular.t118' /></th>
		            		<td style="width:200px;">
		                		<c:choose>
		                			<c:when test="${result.option eq '1'}">
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t119' /></span>
		                			</c:when>
		                			<c:when test="${result.option eq '2'}">
		                				<span id="AllDay" style="padding-left: 4px;"><spring:message code='ezCircular.t120' /></span>
		                			</c:when>
		                			<c:when test="${result.option eq '3'}">
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t119' /></span>,  
										<span id="AllDay"><spring:message code='ezCircular.t120' /></span>
		                			</c:when>
		                			<c:otherwise>
		                				<span id="option" style="padding-left: 4px;"><spring:message code='ezCircular.t121' /></span>
		                			</c:otherwise>
		                		</c:choose>
							</td>
						</tr>
						<tr style="height:25px">
							<th style="padding-left:10px"><spring:message code='ezCircular.t74' /></th>
	       					<td style="padding-left: 4px;">								
	         					<div id="statusNum"><c:out value='${result.confirmCount}'/> / <c:out value='${result.confirmTotalCount}'/></div>
	         				</td>
							<th style="padding-left:10px"><spring:message code='ezCircular.t124' /></th> 
 							<td style="padding-left:4px">
 								<div id="printStatus">
 									<c:choose>
				            			<c:when test="${result.status eq '0'}">
				            				<div id="status"><spring:message code='ezCircular.t125' /></div>
				            			</c:when>
				            			<c:when test="${result.status eq '1'}">
				            				<div id="status"><spring:message code='ezCircular.t126' /></div>
				            			</c:when>
				            			<c:otherwise>
				            				<div id="status"><spring:message code='ezCircular.t127' /></div>
				            			</c:otherwise>
		                			</c:choose>
 								</div>
 							</td> 
						</tr>
						<tr style="height:25px"> 
 							<th style="padding-left:10px"><spring:message code='ezCircular.t86' /></th>
		            		<td class="confirmStatus" style="padding-left: 4px; vertical-align: middle;">
		            			<c:choose>
		            				<c:when test="${result.confirmStatus == '0'}">
		            					<img src='/images/ImgIcon/msg-unrd.png' style='vertical-align:middle;'/>&nbsp;<spring:message code='ezCircular.t143' />
		            				</c:when>
		            				
		            				<c:when test="${result.confirmStatus == '1'}">
		            					<img src='/images/ImgIcon/msg-rd.png' style='vertical-align:middle;'/>&nbsp;<spring:message code='ezCircular.t65' />
		            				</c:when>
		            			</c:choose>
		            		</td>
		            		<th style="width:10%; -webkit-column-width:15%;"><spring:message code='ezPoll.t161' /></th>
		            		<td>
		            			<div id="endDate" style="padding-left: 4px;"><c:out value='${fn:substring(result.endDate,0,16) }'/></div>
		            		</td>
						</tr>
					</table>
					<br/>
					<table class="content" style="width:100%; table-layout: fixed;">
	        			<tr>
 							<td colspan="4"><div align="left" id="printDocument" style="padding: 5px; margin: 8px; overflow:auto;"></div></td> 
						</tr>
	        		</table>
				</td>
			</tr>
		</table>
	</body>
</html>
