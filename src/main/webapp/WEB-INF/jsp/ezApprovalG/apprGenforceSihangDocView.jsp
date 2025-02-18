<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html style="height:97%">
	<head>
		<title><spring:message code='ezApprovalG.t200'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/whokyulSign_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/html2canvas.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/sendMail_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprmanage_Cross.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		var initFlag = true;
		var pDocID = "<c:out value ='${docID}'/>";
		var pDocHref = "<c:out value ='${docHref}'/>";
		var pOrgDocHref = "<c:out value ='${orgDocHref}'/>";
		var orgCompanyID = "<c:out value ='${companyID}'/>";
		var PrtBodyContent;
		
		var maxwidth = 659;
		var stampFlag = false;
		var NostampFlag = false;
		
		function DocumentComplete() {
			if (initFlag) {
				initFlag = false;
				
				if (pDocHref != "") {
					message.Set_EditorContentURL(pDocHref);
				}
			}
		}
		
		function btnClose_onclick() {
			window.close();
	    }
		
		//게시판게시
		var writeboardselect_modal_dialogArguments = new Array();
		function btnBoard_onclick() {
			if (!stampFlag && !NostampFlag) {
	            var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
	            OpenAlertUI(pAlertContent);
	            return;
	        }
			writeboardselect_modal_dialogArguments[1] = btnBoard_onclick_complete;
			var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
			try { OpenWin.focus(); } catch (e) { }
		}
		function btnBoard_onclick_complete(ret) {
			if (typeof (ret) != "undefined") {
				pBoardID = ret[0];

				if (pBoardID == "" || typeof (pBoardID) == "undefined") {
					return;
				}
				
				saveEnforceSihangFile();

				var pheight = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - 720) / 2;
				var pLeft = (pwidth - 765) / 2;

				if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4" || ret[2] == "7" || ret[2] == "8" || (ret[3] != "null" && ret[3] != null && ret[3] != "")) {
					alert(strLang1031);
				} else {
					window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + pDocHref + "&orgCompanyID=" + orgCompanyID, '', GetOpenWindowJun(765, 870));
				}
			}
	    }
		
		//인쇄
		function btnPrint_onclick() {
			if (!stampFlag && !NostampFlag) {
	            var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
	            OpenAlertUI(pAlertContent);
	            return;
	        }
			PrintClick("Cross", "", "");
		}
		
		//메일발송
		function btnSendMail_onclick() {
			if (!stampFlag && !NostampFlag) {
	            var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
	            OpenAlertUI(pAlertContent);
	            return;
	        }
			attachAppr();
		}
		
		var enforceSihang_cross_dialogArguments = new Array();
		//관인
		function btnStamp_onclick() {
			var fields = message.GetFieldsList();
			var field = message.GetListItem(fields, "sealsign");
			if (!field) {
				var pAlertContent = "<spring:message code='ezApprovalG.t201'/>" + "<br>" + "<spring:message code='ezApprovalG.t191'/>";
				OpenAlertUI(pAlertContent);
				return;
			}
			
			if (!stampFlag) {
				if (!CheckSealInfo()) {
					var pAlertContent = "<spring:message code='ezApprovalG.t194'/>" + "<br>" + "<spring:message code='ezApprovalG.t195'/>";
					OpenAlertUI(pAlertContent);
					return;
				}
				
				var parameter = new Array();
		        parameter[0] = "";
		        
				enforceSihang_cross_dialogArguments[0] = parameter;
				enforceSihang_cross_dialogArguments[1] = btnStamp_onclick_complete;
				
				DivPopUpShow(510, 380, "/ezApprovalG/enforceSihangSealChoose.do");
			} else {
				field = message.GetListItem(fields, "sealsign");
				
				if (field) {
					field.innerHTML = " ";
					stampFlag = false;
				}
			}
		}
		
		function btnStamp_onclick_complete(ret) {
			DivPopUpHidden();
			
			if (ret != "cancel") {
				var SealHref = ret[0];
				var SealWidth = parseInt(ret[1]);
				var SealHeight = parseInt(ret[2]);
				
				var fields = message.GetFieldsList();
				var field = message.GetListItem(fields, "sealsign");
				if (field) {
					var signWidth = getPixel(SealWidth) + "px";
					var signHeight = getPixel(SealHeight) + "px";
					
					strimg = "<img src='" + encodeURI(SealHref) + "' border=0 embedding='1' ";
					strimg = strimg + " width=" + signWidth;
					strimg = strimg + " height=" + signHeight + ">";
					
					var field2 = message.GetListItem(fields, "chief");
					var chiefwidth = 1;
					if (field2) {
						chiefwidth = (GetByte(field2.innerText) / 2) * 20;
						field2.height = signHeight;
					}
					
					var sealwidth = (maxwidth + chiefwidth) / 2 - 5;
					var field2 = message.GetListItem(fields, "sealwidth");
					if (field2)
						field2.width = sealwidth;
					
					var field2 = message.GetListItem(fields, "noseal");
					if (field2) {
						field2.width = (maxwidth - sealwidth - getPixel(SealWidth));
						field2.innerHTML = " ";
						NostampFlag = false;
					}
					
					field.innerHTML = strimg;
					field.width = getPixel(SealWidth);
					field.height = getPixel(SealHeight);
					field.setAttribute("surl", SealHref);
					stampFlag = true;
				}
			}
		}
		
		//관인생략
		function btnNoStamp_onclick() {
			var fields = message.GetFieldsList();
			var field = message.GetListItem(fields, "sealsign");
			if (!field) {
				NostampFlag = true;
				var pAlertContent = "<spring:message code='ezApprovalG.t201'/>" + "<br>" + "<spring:message code='ezApprovalG.t221'/>";
				//var pAlertContent = "<spring:message code='ezApprovalG.t201'/>" + "<br>" + "<spring:message code='ezApprovalG.t191'/>";
				OpenAlertUI(pAlertContent);
				return;
			}
			
			if (!NostampFlag) {
				var SealHref = "/files/sealImg/nostamp.gif";
	            var SealWidth = 30;
	            var SealHeight = 30;
	            
	            field = message.GetListItem(fields, "sealsign");
	            if (field) {
	                var signWidth = getPixel(SealWidth) + "px";
	                var signHeight = getPixel(SealHeight) + "px";
	
	                strimg = "<img src='" + encodeURI(SealHref) + "' border=0 embedding='1' >";
	
	                var field2 = message.GetListItem(fields, "chief");
	                var chiefwidth = 1;
	                if (field2) {
	                    if (isNaN(chiefwidth)) {
                           chiefwidth = Number(field2.width);
                        }
	                    field2.height = signHeight;
	                }
	                
					//2019-09-09 김보미 - 관인생략은 맨 끝자의 한칸 띄고 나타나야함
	                var sealwidth = (maxwidth - chiefwidth) / 2 + chiefwidth - getPixel(SealWidth) + 20;
	                var field2 = message.GetListItem(fields, "sealwidth");
	                if (field2)
	                    field2.width = sealwidth;
	
	                var field2 = message.GetListItem(fields, "noseal");
	                // 관인 생략시 관인생략 이미지를 관인생략 필드에 보여지도록 수정함. 2019-08-13 홍대표.
	                if (field2) {
	                    if ((maxwidth - sealwidth - getPixel(SealWidth)) > 0)
	                        field2.width = (maxwidth - sealwidth - getPixel(SealWidth));
	                    else
	                        field2.width = (maxwidth - sealwidth - getPixel(SealWidth)) * (-1);
	                    field2.innerHTML = strimg;
	                    stampFlag = false;
	                }
	                
	                field.width = getPixel(SealWidth);
	                field.height = getPixel(SealHeight);
	                field.innerHTML = " ";
	                field.setAttribute("surl", SealHref);
	                NostampFlag = true;
	            }
			} else {
				field = message.GetListItem(fields, "noseal");
				
				if (field) {
					field.innerHTML = " ";
					NostampFlag = false;
				}
			}
		}
		
		function getPixel(pLength) {
			try {
				var tempLength = Number(pLength);
				tempLength = tempLength * 7 / 2;
				return tempLength;
			} catch (e) {
				return 30;
			}
	    }
		
		function GetByte(pStr) {
	        var len = pStr.length;
	        var tot = 0;
	
	        for (var i = 0 ; i < len ; i++) {
	            var temp = pStr.charAt(i);
	
	            if (escape(temp).length > 4) {
	                tot += 2;
	            }
	            else {
	                tot++;
	            }
	        }
	        return tot;
	    }
		
		function CheckSealInfo() {
			var result = "";
	    	var rtnVal = false;
	    	
    		$.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/admin/ezApprovalG/getSealList.do",
	    		data : {
	    			flag : "LIST"
	    		},
	    		success: function(xml){
	    			result = loadXMLString(xml);
	    		},
	    		error : function() {
	    			rtnVal = false;
	    		}
	    	});
    		
    		if (SelectNodes(result, "ROWS/ROW").length > 0) {
    			rtnVal = true;
    		} else {
    			rtnVal = false;
    		}
    		
    		return rtnVal;
	    }
		
		function saveEnforceSihangFile() {
			var result = "";
			var mhtBody = message.Get_EditorBodyHTML();
			
			$.ajax({
				type : "POST",
				dataType : "text",
				url : "/ezApprovalG/enforceSihangDocSave.do",
				data : {
					pMhtBody : mhtBody,
					pDocHref : pDocHref
				},
				success: function(text) {
					result = text;
				},
				error: function(jqXHR, textStatus, errorThrown) {
					console.error("enforceSihangDocSave error:", textStatus, errorThrown);
				}
			});
			
			return result;
		}
		</script>
	</head>
	<body class="popup" style="OVERFLOW:hidden;height:100%">
		<table class="layout">
			<tr>
				<td style="height: 20px;">
					<div id="menu">
						<ul>
							<li id="btnStamp"><span onclick="return btnStamp_onclick()"><spring:message code='ezApprovalG.t213'/></span></li>
							<li id="btnNoStamp"><span onclick="return btnNoStamp_onclick()"><spring:message code='ezApprovalG.t222'/></span></li>
							<li id="btnBoard"><span onclick="return btnBoard_onclick()"><spring:message code='ezApprovalG.t1514'/></span></li>
							<li id="btnPrint"><span class="icon16 popup_icon16_print" onclick="return btnPrint_onclick()"></span></li>
							<li id="btnSendMail"><span class="icon16 popup_icon16_mail_gray" onclick="return btnSendMail_onclick()"></span></li>
						</ul>
					</div>
					<div id="close">
						<ul>
							<li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
						</ul>
					</div>
				</td>
			</tr>
			<tr>
				<td style="padding-bottom:10px;height:100%">
					<iframe id="message" name="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" style="width: 100%; height:100%" src="ConDocViewContent.do" frameborder="0"></iframe>
				</td>
			</tr>
			<!-- 첨부파일 추후개발 -->
			<%-- <tr>
				<td style="height: 20px;">
					<table class="file">
						<tr>
							<th><spring:message code='ezApprovalG.t65'/></th>
							<td><div id="lstAttachLink"></div></td>
						</tr>
					</table>
				</td>
			</tr> --%>
		</table>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
		
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
	
	<xml id='LISTHEADER' style="display:none">
		<LISTVIEWDATA>
			<HEADERS>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1271' /></NAME>
					<WIDTH>100</WIDTH>
				</HEADER>
			</HEADERS>
		</LISTVIEWDATA>
	</xml>
</html>
