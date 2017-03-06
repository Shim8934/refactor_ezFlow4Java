<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t134'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezPortal/functionLib.js"></script>
		<script type="text/javascript" src="/js/ezPortal/string_component.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	
		<script type="text/javascript">
		var portlet_type = "${prop.portlet_Type}";
		var view_type = "${prop.showTitleBar}";
		var uid = "${uID}";
		var menuindex = "${menuIndex}";
		var pmode = "${mode}";
		var pDocPath = "${pDocPath}";
		var image_type = "${pImageType}";
		var pImagePath = "${pImagePath}";
		var pImageWidth = "${pImageWidth}";
		var pImageHeight = "${pImageHeight}";
		var pCreatorid = "${pCreatorID}";
		var pUsertype = TrimText("${pUserType}"); //창을 열었을때 기본 셋팅값이 안들어와서 TrimText("${pUserType}")으로 변경해줌 2007-08-28
		var pBoardid = "${pBoardID}";
		var pItemfields = "${pItemFields}";
		var g_bSaved = false;
		var g_PortletCategoryXML = "${portletCategoryXML}";
		var g_PortalPageCategoryXML = "${portalPageCategoryXML}";
		var portal_type = "${prop.gubunFlag}";   // 포탈페이지 구분
		
		function window_onload()
		{
		    var xmldom = createXmlDom();
			
			if(txtDisplayName2.value == "")
			{
			    txtDisplayName2.value = "New portlet";
			}
			
			// 포틀릿 카테고리 정보
			var portletHTML = "";
			if (g_PortletCategoryXML != "") {
			    xmldom = loadXMLString(g_PortletCategoryXML);
				
				for (var i=0; i<xmldom.getElementsByTagName("CATEGORY").length; i++) {
					if (getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)) == 't4075') {
						portletHTML += "<input type=radio name=selectType value=\"" + getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)) + "\" onclick=\"selectTypeChange('" + getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)) + "')\"> " + "<spring:message code='ezPortal.jjs01'/>" + "&nbsp;";	
					} else if (getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)) == 't4076') {
						portletHTML += "<input type=radio name=selectType value=\"" + getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)) + "\" onclick=\"selectTypeChange('" + getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)) + "')\"> " + "<spring:message code='ezPortal.jjs02'/>" + "&nbsp;";
					} else if (getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)) == 't4077') {
						portletHTML += "<input type=radio name=selectType value=\"" + getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)) + "\" onclick=\"selectTypeChange('" + getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)) + "')\"> " + "<spring:message code='ezPortal.jjs03'/>" + "&nbsp;";
					} else if (getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)) == 't4078') {
						portletHTML += "<input type=radio name=selectType value=\"" + getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)) + "\" onclick=\"selectTypeChange('" + getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)) + "')\"> " + "<spring:message code='ezPortal.jjs04'/>" + "&nbsp;";
					}
					portletHTML.replace("포틀릿", "portlet").replace("이미지", "Image").replace("게시판", "Board");
				    //portletHTML += "<input type=radio name=selectType value=\"" + getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)) + "\" onclick=\"selectTypeChange('" + getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)) + "')\"> " + getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)).replace("<spring:message code='ezPortal.t147'/>", ""); + " &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				}
			}
			td_PortletType.innerHTML = portletHTML;
			

			xmldom = null;
			
			toggle_menu(menuindex);
			
			SetURLPortlet();
			SetImagePortlet();
			SetBoardPortlet();
			SetFramePortlet();
        }

        function SetFramePortlet() {
            if("${portletFrameType}" == "iFrame") {
                document.getElementsByName("td_PortletDiv")[0].checked = true;
                document.getElementsByName("td_PortletDiv")[1].checked = false;
	        } else {
                document.getElementsByName("td_PortletDiv")[0].checked = false;
                document.getElementsByName("td_PortletDiv")[1].checked = true;
	        }
	    }
		
	    window.onbeforeunload = function()
	    {
	        if (g_bSaved == true)
	        {
	            try{
	                window.opener.location.reload();
	            } catch(e) {}
	        }
	            // 신규이면서 저장하지 않은 경우 저장된 정보 삭제
	        else if (pmode == "new" && g_bSaved == false)
	        {
	            Delete();
	        }
	    }
		
		
		// 삭제
		function Delete()
		{
		    var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/deletePortlet.do?uID=" + uid, false);
			xmlhttp.send();
			xmlhttp = null;
		}
		
		function toggle_menu(pIndex) {
			if (pmode == "new" && g_bSaved == false) {
				if (pIndex.toString() != "1")
				{
					alert("<spring:message code='ezPortal.t83'/>");
					return;
				}
			}
			
			switch(pIndex.toString()) {
				case "1":
					menu_1.src = "/images/tap_portal01o.gif";
					menu_2.src = "/images/tap_portal02.gif";
					menu_3.src = "/images/tap_portal03.gif";
					toggle_tbl1.style.display = "";
					toggle_tbl2_1.style.display = "none";
					toggle_tbl2_2.style.display = "none";
					toggle_tbl2_3.style.display = "none";
					toggle_tbl3_1.style.display = "none";
					toggle_tbl3_2.style.display = "none";
					toggle_tbl3_3.style.display = "none";
					SetType();
					selectTypeChange(portlet_type.toString());
					break;
				case "2":
					menu_1.src = "/images/tap_portal01.gif";
					menu_2.src = "/images/tap_portal02o.gif";
					menu_3.src = "/images/tap_portal03.gif";
					toggle_tbl1.style.display = "none";
					toggle_tbl2_1.style.display = "";
					toggle_tbl2_2.style.display = "";
					toggle_tbl2_3.style.display = "";
					toggle_tbl3_1.style.display = "none";
					toggle_tbl3_2.style.display = "none";
					toggle_tbl3_3.style.display = "none";
					selectType_1.style.display = "none";
					selectType_2.style.display = "none";
					selectType_3.style.display = "none";
					selectType_4.style.display = "none";
					break;
				case "3":
					menu_1.src = "/images/tap_portal01.gif";
					menu_2.src = "/images/tap_portal02.gif";
					menu_3.src = "/images/tap_portal03o.gif";
					toggle_tbl1.style.display = "none";
					toggle_tbl2_1.style.display = "none";
					toggle_tbl2_2.style.display = "none";
					toggle_tbl2_3.style.display = "none";
					toggle_tbl3_1.style.display = "";
					toggle_tbl3_2.style.display = "";
					toggle_tbl3_3.style.display = "";
					selectType_1.style.display = "none";
					selectType_2.style.display = "none";
					selectType_3.style.display = "none";
					selectType_4.style.display = "none";
					break;
			}
		}
		
		function MakeXMLString(str) {
		    str = ReplaceText(str, "&", "&amp;");
		    str = ReplaceText(str, "<", "&lt;");
		    str = ReplaceText(str, ">", "&gt;");
		    return str;
	    }
		
		function SaveProperty() {
			var displayname = ReplaceValidString(txtDisplayName.value);
			var displayname2 = ReplaceValidString(txtDisplayName2.value);
			var url = ReplaceValidString(txtURL.value);
			var maxurl = ReplaceValidString(txtMaxURL.value);
			var pNewUserType = "1";
			var pFrameType = "iFrame";
			
			if (txtWidth.value == "" || !is_num(txtWidth.value))
			{
			    alert("<spring:message code='ezPortal.t990032'/>");
			    return;
			}
			if (txtHeight.value == "" || !is_num(txtHeight.value))
			{
				alert("<spring:message code='ezPortal.t148'/>");
				return;
			}
			
			//유효성검사 특수문자
			if (specialChk(document.getElementById("txtDisplayName").value) || specialChk(document.getElementById("txtDisplayName2").value)) {
		    	alert("<spring:message code='ezResource.special' />");
		    	return;
		    }
			
			// 포틀릿 종류
		    for (var i=0; i<document.getElementsByName("selectType").length; i++) {
		        if (document.getElementsByName("selectType")[i].checked == true)
				{
		            portlet_type = document.getElementsByName("selectType")[i].value;
					break;
				}
			}
			
			// 타이틀바
		    for (var i=0; i<document.getElementsByName("selectViewType").length; i++) {
		        if (document.getElementsByName("selectViewType")[i].checked == true)
				{
		            view_type = document.getElementsByName("selectViewType")[i].value;
					break;
				}
			}
			
			// 게시판 포틀릿인 경우
			if (portlet_type == "1") {
				// 관리자 or 사용자
				for (var i=0; i<document.getElementsByName("URLUserType").length; i++) {
				    if (document.getElementsByName("URLUserType")[i].checked == true) {
				        pNewUserType = document.getElementsByName("URLUserType")[i].value;
						break; 
					}
				}
			} else if (portlet_type == "4") {
				// 관리자 or 사용자
			    for (var i=0; i<document.getElementsByName("UserType").length; i++) {
			        if (document.getElementsByName("UserType")[i].checked == true) {
			            pNewUserType = document.getElementsByName("UserType")[i].value;
						break; 
					}
				}
			}
		    // 프레임 종류를 선택(frame, div)
			for (var i=0; i< document.getElementsByName("td_PortletDiv").length; i++) {
			    if ( document.getElementsByName("td_PortletDiv")[i].checked == true) {
			        pFrameType =  document.getElementsByName("td_PortletDiv")[i].value;
			        break;
			    }
			}
			
			var strXML = "<DATA>";
			strXML += "<UID>" + uid + "</UID>";
			strXML += "<DISPLAYNAME>" + displayname + "</DISPLAYNAME>";
			strXML += "<DISPLAYNAME2>" + displayname2 + "</DISPLAYNAME2>";
			strXML += "<PORTLETTYPE>" + portlet_type.toString() + "</PORTLETTYPE>";
			strXML += "<URL>" + url + "</URL>";
			strXML += "<MAXURL>" + maxurl + "</MAXURL>";
			strXML += "<SHOWTITLEBAR>" + view_type.toString() + "</SHOWTITLEBAR>";
			strXML += "<USERTYPE>" + pNewUserType + "</USERTYPE>";
			strXML += "<WIDTH>" + txtWidth.value + "</WIDTH>";
			strXML += "<HEIGHT>" + txtHeight.value + "</HEIGHT>";
			strXML += "<GUBUNFLAG>0</GUBUNFLAG>"; // 포틀릿 구분을 두지 않기로 하여 공통인 0로 무조건 저장
			strXML += "<FRAMETYPE>" + pFrameType + "</FRAMETYPE>";
			strXML += "</DATA>";
			
			
			var strXML2 = "";
			
			if (portlet_type == "1") {	
				if (pNewUserType == "1") {
					if (document.getElementById("txtMoveURL").value == "") {
						alert("<spring:message code='ezPortal.t123'/>");
						return;
					}
				} else if (pNewUserType == "2") {
				    document.getElementById("txtMoveURL").value = "";
				}
				
				strXML2 = "<DATA>";
				strXML2 += "<UID>" + uid + "</UID>";
				strXML2 += "<OLDCREATORID>" + pCreatorid + "</OLDCREATORID>";
				strXML2 += "<OLDUSERTYPE>" + pUsertype + "</OLDUSERTYPE>";
				strXML2 += "<USERTYPE>" + pNewUserType + "</USERTYPE>";
				strXML2 += "<MOVEURL>" + ReplaceValidString(document.getElementById("txtMoveURL").value) + "</MOVEURL>";
				strXML2 += "</DATA>";
			}
			// html 포틀릿
			else if (portlet_type == "2") {
				strXML2 = "<DATA>";
				strXML2 += "<UID>" + uid + "</UID>";
				strXML2 += "<DISPLAYNAME>" + displayname + "</DISPLAYNAME>";
				strXML2 += "<DISPLAYNAME2>" + displayname2 + "</DISPLAYNAME2>";

				var strBody = message.GetEditorContent();
///////converHTMLtoMHT
				strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + strBody + "</BODY>" + "</HTML>");
				//strXML2 += "<CONTENT>" +pidCryptUtil.encodeBase64(strBody, 64) + "</CONTENT>";
				//2019-10-09 strBody 수정
				strXML2 += "<CONTENT>" + strBody + "</CONTENT>";
				strXML2 += "</DATA>";												
				// 폼프로세스가 로드가 끝난 상태에서만 저장
				//if( bEditorLoaded!=true) strXML2 = "";
				
			}
			// 이미지 포틀릿
			else if (portlet_type == "3") {
			    var normalImgPath = txtImage.src.substr(txtImage.src.indexOf("${uploadPortalPath}"));
				if (normalImgPath.indexOf("${uploadPortalPath}") == -1) normalImgPath = "";
				
				// 이미지 타입
				image_type = "1";
				for (var i=0; i<document.getElementsByName("ImageType").length; i++) {
				    if (document.getElementsByName("ImageType")[i].checked == true) {
				        image_type = document.getElementsByName("ImageType")[i].value;
						break;
					}
				}
				
				// 새창여부
				var pOpenMode = "0";
				if (document.getElementsByName("OpenMode").checked == true)
					pOpenMode = "1";
				
				if (pImageWidth == "") pImageWidth = "0";
				if (pImageHeight == "") pImageHeight = "0";
				
				strXML2 = "<DATA>";
				strXML2 += "<UID>" + uid + "</UID>";
				strXML2 += "<IMAGEPATH>" + normalImgPath + "</IMAGEPATH>";
				strXML2 += "<IMAGEWIDTH>" + pImageWidth + "</IMAGEWIDTH>";
				strXML2 += "<IMAGEHEIGHT>" + pImageHeight + "</IMAGEHEIGHT>";
				strXML2 += "<IMAGETYPE>" + image_type + "</IMAGETYPE>";
				strXML2 += "<OPENMODE>" + pOpenMode + "</OPENMODE>";
				strXML2 += "<WINDOWOPTION>" + ReplaceValidString(document.getElementById("txtWindowOption").value) + "</WINDOWOPTION>";
				strXML2 += "</DATA>";
			}
			// 게시판 포틀릿
			else if (portlet_type == "4") {
				var pItemFields = "";
				
				// 관리자 지정인 경우에만 체크
				if (pNewUserType == "1") {
					if (document.getElementById("txtBoardID").value == "") {
						alert("<spring:message code='ezPortal.t124'/>");
						return;
					}
					
					if (document.getElementById("txtItemCount").value == "") {
						alert("<spring:message code='ezPortal.t125'/>");
						return;
					} else {
					    if (!is_num(document.getElementById("txtItemCount").value)) {
							alert("<spring:message code='ezPortal.t126'/>");
							return;
						}
						
					    if (parseInt(document.getElementById("txtItemCount").value, 10) > 100) {
							alert("<spring:message code='ezPortal.t127'/>");
							return;
						}
					}
					
					for (var i=0; i<document.getElementsByName("ItemField").length; i++) {
					    if (document.getElementsByName("ItemField")[i].checked == true) {
							if (pItemFields == "")
							    pItemFields = document.getElementsByName("ItemField")[i].value;
							else
							    pItemFields += "," + document.getElementsByName("ItemField")[i].value;
						}
					}
					
					if (pItemFields == "") {
						alert("<spring:message code='ezPortal.t128'/>");
						return;
					}
				}
				
				strXML2 = "<DATA>";
				strXML2 += "<UID>" + uid + "</UID>";
				strXML2 += "<OLDCREATORID>" + pCreatorid + "</OLDCREATORID>";
				strXML2 += "<OLDUSERTYPE>" + pUsertype + "</OLDUSERTYPE>";
				strXML2 += "<OLDBOARDID>" + pBoardid + "</OLDBOARDID>";
				strXML2 += "<USERTYPE>" + pNewUserType + "</USERTYPE>";
				strXML2 += "<BOARDID>" + document.getElementById("txtBoardID").value + "</BOARDID>";
				strXML2 += "<ITEMCOUNT>" + document.getElementById("txtItemCount").value + "</ITEMCOUNT>";
				strXML2 += "<ITEMFIELDS>" + pItemFields + "</ITEMFIELDS>";
				strXML2 += "</DATA>";						
			}
			
			// 기본정보 저장
		    var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/savePortletProperty.do", false);
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.send(strXML);
			if (xmlhttp.responseText != "OK")
			{
				alert("<spring:message code='ezPortal.t149'/>");
				return;
			}
			xmlhttp = null;

			if (strXML2 != "") {			    
			    xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezPortal/savePortletSubProperty.do?portletType=" + portlet_type, false);
				xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
				xmlhttp.send(strXML2);
				xmlhttp = null;
			}
			
			alert("<spring:message code='ezPortal.t84'/>");
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/portletEdit.do?mode=edit&uID=" + uid + "&menuIndex=1";
		}
		
		
		function RemoveParameter(pParamName) {
			if(!confirm("<spring:message code='ezPortal.t54'/>")) return;
			
		    var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/removeParameter.do?mode=1&uID=" + uid + "&paramName=" + pParamName, false);
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.send();
			xmlhttp = null;
			
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/portletEdit.do?mode=edit&uID=" + uid + "&menuIndex=2";
		}
		
		function CheckDuplicate(paramname) {
			for (var i=0; i<document.all.tags("input").length; i++) {
				if (typeof(document.all.tags("input").item(i).utype) == "undefined") continue;
				if (document.all.tags("input").item(i).value.toLowerCase() == paramname) return true;
			}
			return false;
		}
		
		function AddParameter() {
			var paramname = ReplaceValidString(newParamName.value);
			var paramvalue = ReplaceValidString(newParamValue.value);
			var paramtype = ReplaceValidString(SelectParamType.value);
			if (paramname == "")  {
				alert("<spring:message code='ezPortal.t111'/>");
				return;
			}
			
			var strXML = "<DATA>";
			strXML += "<UID>" + uid + "</UID>";
			strXML += "<PARAMNAME>" + paramname + "</PARAMNAME>";
			strXML += "<PARAMVALUE>" + paramvalue + "</PARAMVALUE>";
			strXML += "<PARAMTYPE>" + paramtype + "</PARAMTYPE>";
			strXML += "</DATA>";
			
			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/addParameter.do?mode=1", false);
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.send(strXML);
			xmlhttp = null;
			
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/portletEdit.do?mode=edit&uID=" + uid + "&menuIndex=2";
		}
		
	    // 포틀릿타입 변경
	    var FlagOneSelect = false;
		function selectTypeChange(pFlag) {
			if (pFlag == "1") {			
				txtURL.value = "/ezPortal/urlPortlet.do?uID=" + uid;
				txtURL.disabled = true;
				selectType_1.style.display = "";

				if (navigator.userAgent.indexOf("Firefox") != -1 && !FlagOneSelect) {
				    selectType_2.style.display = "";
				    setTimeout(ckLoding, 150);
				    FlagOneSelect = true;
				} else {
					selectType_2.style.display = "none";
				}
				    
				selectType_3.style.display = "none";
				selectType_4.style.display = "none";
				//window.resizeTo(530, 420);
			} else if (pFlag == "2") {
				txtURL.value = "/ezPortal/htmlPortlet.do?uID=" + uid;
				txtURL.disabled = true;
				selectType_1.style.display = "none";
				selectType_2.style.display = "";
				selectType_3.style.display = "none";
				selectType_4.style.display = "none";
				//window.resizeTo(530, 650);
			} else if (pFlag == "3") {
				txtURL.value = "/ezPortal/imagePortlet.do?uID=" + uid;
				txtURL.disabled = true;
				selectType_1.style.display = "none";
				selectType_2.style.display = "none";
				selectType_3.style.display = "";
				selectType_4.style.display = "none";
				//window.resizeTo(530, 520);
			} else if (pFlag == "4") {
				txtURL.value = "/ezPortal/boardPortlet.do?uID=" + uid;
				txtURL.disabled = true;
				selectType_1.style.display = "none";
				selectType_2.style.display = "none";
				selectType_3.style.display = "none";
				selectType_4.style.display = "";
				//window.resizeTo(530, 500);
			}
		}
		function ckLoding() {
		    selectType_2.style.display = "none";
		}
		function SetType() {
			for (var i=0; i<document.getElementsByName("selectType").length; i++) {
			    if(parseInt(document.getElementsByName("selectType")[i].value) == portlet_type) {
			        document.getElementsByName("selectType")[i].checked = true;
					break;
				}
			}
			
			for (var i=0; i<document.getElementsByName("selectViewType").length; i++) {
			    if(parseInt(document.getElementsByName("selectViewType")[i].value) == view_type) {
			        document.getElementsByName("selectViewType")[i].checked = true;
					break;
				}
			}
		}
		
		function AddRight() {
			if (newAccessID.value == "") {
				alert("<spring:message code='ezPortal.t85'/>");
				return;
			}
			
			// 1: 불가, 2: 가능
			var editRight = "1";
			var viewRight = "1";
			
			if (document.getElementsByName("SelectEditRight")[1].checked == true)
				editRight = "2";
			
			if (document.getElementsByName("SelectViewRight")[1].checked == true)
				viewRight = "2";
			
			var strXML = "<DATA>";
			strXML += "<UID>" + uid + "</UID>";
			strXML += "<ACCESSID>" + newAccessID.value + "</ACCESSID>";
			// 수정(2007.07.11) : 부서명 & 처리
			strXML += "<ACCESSNAME><![CDATA[" + newAccessName.value + "]]></ACCESSNAME>";
			strXML += "<EDIT_RIGHT>" + editRight + "</EDIT_RIGHT>";
			strXML += "<VIEW_RIGHT>" + viewRight + "</VIEW_RIGHT>";
			strXML += "</DATA>";
			
			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/addRight.do", false);
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.send(strXML);
			xmlhttp = null;
			
			location.href = "/admin/ezPortal/portletEdit.do?mode=edit&uID=" + uid + "&menuIndex=3";
			
		}
	    var selecttarget_dialogArguments = new Array();
		function SelectID()
		{
		    var config = "status:false;dialogWidth:690px;dialogHeight:630px;scroll:no;status:no;edge:sunken" + GetShowModalPosition(690, 630);
		    if (CrossYN()) {
		        selecttarget_dialogArguments[1] = SelectID_Complete;
		        var OpenWin = window.open("/admin/ezPortal/selectTarget.do", "SelectTarget", GetOpenWindowfeature(690, 630));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    else {
		        var ret = window.showModalDialog("/admin/ezPortal/selectTarget.do","",config); 
			
		        if (typeof(ret) != "undefined")
		        {
		            newAccessID.value = ret.split(";")[0];
		            newAccessName.value = ret.split(";")[1];
		        }
		    }
		}
		function SelectID_Complete(ret)
		{
		    if (typeof(ret) != "undefined")
		    {
		        newAccessID.value = ret.split(";")[0];
		        newAccessName.value = ret.split(";")[1];
		    }
		}
		
		function DeleteRight(pAccessID)
		{
			if(!confirm("<spring:message code='ezPortal.t54'/>")) return;
			
			var strXML = "<DATA>";
			strXML += "<UID>" + uid + "</UID>";
			strXML += "<ACCESSID>" + pAccessID + "</ACCESSID>";
			strXML += "</DATA>";
			
			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/removeACL.do", false);
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.send(strXML);
			xmlhttp = null;
			
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/portletEdit.do?mode=edit&uID=" + uid + "&menuIndex=3";
		}
		
		// 지정된 값인 경우에만 작성 가능하도록 설정
		function Param_Change()
		{
			if (SelectParamType.value != "0")
				newParamValue.disabled = true;
			else
				newParamValue.disabled = false;
		}
		
		// URL 포틀릿 설정
		function SetURLPortlet()
		{
		
			if (portlet_type.toString() == "1")
			{
			 	// 관리자 or 사용자
			    for (var i=0; i<document.getElementsByName("URLUserType").length; i++)
				{ 				        
			        if (document.getElementsByName("URLUserType")[i].value == pUsertype) 
			        {  	
			            document.getElementsByName("URLUserType")[i].checked = true;
						break;
					}
				}
		
				SetURLUserType(pUsertype);
			}
			else
			{
			    document.getElementsByName("URLUserType")[0].checked = true;
			}
		}
		
		// 이미지 포틀릿 설정
		function SetImagePortlet()
		{
			if (portlet_type.toString() == "3")
			{
				if (pImagePath != "")
					txtImage.src = pImagePath;
				else
					txtImage.style.display = "none";
				
				for (var i=0; i<document.getElementsByName("ImageType").length; i++)
				{
				    if(document.getElementsByName("ImageType")[i].value == image_type)
					{
				        document.getElementsByName("ImageType")[i].checked = true;
						break;
					}
				}
			}
			else
			{
				txtImage.style.display = "none";
				document.getElementsByName("ImageType")[0].checked = true;
			}
		}
		
		// 게시판 포틀릿 설정
		function SetBoardPortlet() {
			if (portlet_type.toString() == "4") {
				// 관리자 or 사용자
				for (var i=0; i<document.getElementsByName("UserType").length; i++) {
				    if (document.getElementsByName("UserType")[i].value == pUsertype)
					{
				        document.getElementsByName("UserType")[i].checked = true;
						break; 
					}
				}
				
				// 관리자
				if (pUsertype == "1") {	
					// 게시물 필드
					var arrFields = pItemfields.split(",");
					for (var i=0; i<arrFields.length; i++)
					{
					    for (var j=0; j<document.getElementsByName("ItemField").length; j++)
						{
					        if (document.getElementsByName("ItemField")[j].value.toUpperCase() == arrFields[i].toUpperCase())
							{
					            document.getElementsByName("ItemField")[j].checked = true;
								break;
							}
						}
					}
				}
				// 사용자
				else {
					SetUserType(pUsertype);
				}
			} else {
			    document.getElementsByName("UserType")[0].checked = true;
			    document.getElementById("txtItemCount").value = "5";
			}
		}
		
		var g_xmlhttp = null;
		function changeNormalImage() {
			if (CrossYN()) {
				document.getElementById('mode').value = "PHOTO";
			    document.form.file1.click();	
			} else {
				var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
				var filepath = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "");
				if (filepath == "") return;			
				
				var strBase64 = ezUtil.DownloadToBase64(filepath);
				ezUtil = null;
				
				var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
				var temp = ezUtil.GetImageSize(filepath);
				ezUtil = null;
				
				pImageWidth = temp.split("*")[0];
				pImageHeight = temp.split("*")[1];			
				
				var strXML = "<IMAGE><OLDFILENAME>" + txtImage.src.substr(txtImage.src.lastIndexOf("/")+1) + "</OLDFILENAME><FILENAME>" + filepath.substr(filepath.lastIndexOf("\\")+1) + "</FILENAME><DATA>" + strBase64 + "</DATA></IMAGE>";
				
				g_xmlhttp = createXMLHttpRequest();
				g_xmlhttp.open("POST", "/admin/ezPortal/uploadMenuImage.do?mode=Image", true);
				g_xmlhttp.onreadystatechange = changeNormalImage_end;
				g_xmlhttp.send(strXML);				
			}
		}
		
		function changeNormalImage_end() {
			//if (g_xmlhttp.readystate != 4) return;
			txtImage.src = g_xmlhttp.responseText;
			txtImage.style.display = "";
			g_xmlhttp = null;
		}
		var boardselect_cross_dialogArguments = new Array();
		function SelectBoard() {		    
		    if (CrossYN()) {
		        boardselect_cross_dialogArguments[1] = SelectBoard_Complete;
		        var OpenWin = window.open("/ezBoard/boardSelect.do", "BoardSelect_Cross", GetOpenWindowfeature(275, 435));
		        try { OpenWin.focus(); } catch (e) { }
		    } else {
		        var ret = window.showModalDialog("/ezBoard/boardSelect.do", "", "DialogHeight:435px;DialogWidth:275px;status:no;help:no;edge:sunken" + GetShowModalPosition(275, 435));
		        if (typeof(ret) != "undefined") {
		            document.getElementById("txtBoardID").value = ret[0];
		            document.getElementById("txtBoardName").value = ret[2];
		        }
		    }
		}
		function SelectBoard_Complete(ret) {
		    if (typeof(ret) != "undefined") {
		        document.getElementById("txtBoardID").value = ret[0];
		        document.getElementById("txtBoardName").value = ret[2];
		    }
		}
		
		// URL 포틀릿 설정
		function SetURLUserType(pFlag) {
			if (pFlag == "1")
			{
				tr_url1.style.display = "";
			} else if (pFlag == "2") {
				tr_url1.style.display = "none";
			}
		}
		
		// 게시판 포틀릿 설정
		function SetUserType(pFlag) {
			if (pFlag == "1") {
				tr_board1.style.display = "";
				tr_board2.style.display = "";
				tr_board3.style.display = "";
			} else if (pFlag == "2") {
				tr_board1.style.display = "none";
				tr_board2.style.display = "none";
				tr_board3.style.display = "none";
			}
		}
		
		// 이미지 미리보기
		function UserImage_Preview() {
			var ImgPath = txtImage.src.substr(txtImage.src.indexOf("${uploadPortalPath}"));
			if (ImgPath.indexOf("${uploadPortalPath}") == -1) ImgPath = "";
			
			if (ImgPath == "") return;
			
			window.open("/admin/ezPortal/imageView.do?imageName=" + encodeURI(ImgPath), "", "width=300,height=300,resizable=1"+GetOpenPosition(300, 300));
		}
		
		var FormEditor	= null;
		var bEditorLoaded = false;
		function objFormEditor_DocumentComplete() {
			if (bEditorLoaded == true) return;
			
			FormEditor	= objFormEditor.object;
			FormEditor.Editor.DOM.body.topMargin = "7px";	// 에디터의 상단 여백
			FormEditor.Editor.DOM.body.leftMargin = "7px";	// 에디터의 좌측 여백

			FormEditor.Editor.DOM.body.free = "";			// 에디터의 편집 가능 설정 (초기값 : 편집불가)
			
			if (portlet_type.toString() == "2" && pDocPath != "") {
				FormEditor.LoadURL(document.location.protocol+"//" + location.hostname + pDocPath);				
			}
			
			bEditorLoaded = true;
		}
		var isComplete = false;
		function DocumentComplete() {
		        //var fullPath = document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(pDocPath);				
		        //var htmlData = message.SetEditorContentURL2(fullPath);
		        //2016-10-09 mht파일 저장경로 수정
				
		        //2017-03-06 null처리 추가
		        if (pDocPath != null && pDocPath != "") {
		        	var htmlData = message.SetEditorContentURL2(escape(pDocPath));
		        	message.SetEditorContent(htmlData);
		        }
 
            }
		
		function newWindowClick() {
		    if(document.getElementsByName("OpenMode").checked==true) {
		        txtWindowOptionID.style.display = "";
		    }  else {
		        txtWindowOptionID.style.display = "none";
		    }
		}
		
		function btn_AttachAdd_onclick() {
		    if (document.form.file1.value != "") {
		        if (document.getElementById('mode').value == "PHOTO") {
		            if (document.getElementById("form").file1.files.length < 2) {
		            }
		            else
		                alert("<spring:message code='ezPortal.t414'/>");
		        }
		        document.getElementById("cnt").value = $("input[name=file1]")[0].files[0].length;
		        var frm = document.getElementById('form');
		        frm.action = "/admin/ezPortal/portletImageUpload.do?mode=Portlet";
		        frm.submit();
		        document.form.file1.value = "";
		    }
		}
		
		function returnvalue(strXML) {
		    var xml = loadXMLString(strXML);
		    var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
		    for (i = 0; i < nodes.length; i++) {
		        if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
		            if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) {
		                alert(strLang6);
		                return;
		            }
		            if (document.getElementById('mode').value == "PHOTO")
		            {
		                if (navigator.userAgent.indexOf("Firefox") != -1)
		                    txtImage.src = "${uploadPortalPath}" + getNodeText(GetChildNodes(nodes[i])[4]);
		                else
		                    txtImage.src = "${uploadPortalPath}" + getNodeText(GetChildNodes(nodes[i])[4]);
		                txtImage.style.display = "";
		            }
		        }
		        else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
		            alert(strLang8 + AttachLimit + "MB" + strLang9);
		            return;
		        }
		        else {
		            alert(filename + "<spring:message code='ezPortal.t990007'/>" + "\n\n" + result);
		        }
		    }
		}
    </script>
	
	<script language="javascript" type="text/javascript" FOR="objFormEditor" EVENT="DocumentComplete">
	</script>
	</head>
	<body class="popup" onload="javascript:window_onload()">
		<div id="menu">
  			<ul>
    			<li><span onClick="SaveProperty()"><spring:message code='ezPortal.t62'/></span></li>
  			</ul>
		</div>
		<div id="close">
  			<ul>
    			<li><span onClick="window.close()"><spring:message code='ezPortal.t8'/></span></li>
  			</ul>
		</div>
		<div id="tabnav">
  			<ul>
    			<li id="menu_1"><span onClick="toggle_menu(1)" ><spring:message code='ezPortal.t86'/></span></li>
    			<li id="menu_2"><span onClick="toggle_menu(2)" ><spring:message code='ezPortal.t150'/></span></li>
    			<li id="menu_3"><span onClick="toggle_menu(3)"><spring:message code='ezPortal.t87'/></span></li>
  			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
			selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
		</script>
		<!-- 일반설정 -->
		<table id="toggle_tbl1" class="content">
  			<tr>
    			<th><spring:message code='ezPortal.t130'/></th>
    			<td>
        			<table style="width:100%;">
            			<tr class="primary">
	            			<th>${langPrimary}</th>
	            			<td><input type="text" id="txtDisplayName" style="width:100%" value="${prop.displayName}" maxLength="255"></td>	
            			</tr>
            			<tr class="secondary">
	            			<th>${langSecondary}</th>
	            			<td><input type="text" id="txtDisplayName2" style="width:100%" value="${prop.displayName2}" maxLength="255"></td>	
            			</tr>
        			</table>
    			</td>
  			</tr>
  			<tr>
    			<th ><spring:message code='ezPortal.t151'/></th>
    			<td><input type="text" id="txtURL" style="width:384px" value="${prop.url}" maxLength="512"></td>
  			</tr>  
    		<tr>
    			<th ><spring:message code='ezPortal.t990025'/></th>
    			<td>
    				<input type="text" id="txtWidth" value="${prop.width}" maxLength="10">
      					<spring:message code='ezPortal.t990026'/>
      			</td>
  			</tr>
  			<tr>
    			<th ><spring:message code='ezPortal.t153'/></th>
    			<td>
    				<input type="text" id="txtHeight" value="${prop.height}" maxLength="10"> px
    			</td>
  			</tr>
  			<tr>
    			<th ><spring:message code='ezPortal.t154'/></th>
    			<td>
    				<input type="radio" name="selectViewType" value="0">
      					<spring:message code='ezPortal.t155'/>
      				<input type="radio" name="selectViewType" value="1">
      					<spring:message code='ezPortal.t156'/>
      			</td>
  			</tr>
  			<tr>
    			<th ><spring:message code='ezPortal.t157'/></th>
    			<td id="td_PortletType"></td>
  			</tr>
			<tr>
    			<th ><spring:message code='ezPortal.t990027'/></th>
    			<td id="">
					<input name="td_PortletDiv" type="radio" value="iFrame" checked/>iFrame
					<input name="td_PortletDiv" type="radio" value="DIV"/>DIV
    			</td>
  			</tr>
		</table>
		<br>
		<table id="selectType_1" class="content"  >
			<tr>
    			<th colspan="2">
        			URL&nbsp;<spring:message code='ezPortal.t134'/>
    			</th>
			</tr>
  			<tr style="display:none">
    			<th><spring:message code='ezPortal.t160'/></th>
    			<td>
    				<input type="radio" name="URLUserType" value="1" onClick="SetURLUserType('1')"><spring:message code='ezPortal.t161'/>
      				<input type="radio" name="URLUserType" value="2" onClick="SetURLUserType('2')"><spring:message code='ezPortal.t162'/></td>
  			</tr>
  			<tr id="tr_url1">
    			<th ><spring:message code='ezPortal.t135'/></th>
    			<td>
    				<input type="text" name="txtMoveURL" id="txtMoveURL" style="width:384px" value="${pMoveURL}">
    			</td>
  			</tr>
		</table>
		<!-- html 포틀릿 -->
		<table id="selectType_2" class="content"  style="display:none"> 
			<tr>
				<th>HTML<spring:message code='ezPortal.t163'/></th> 
			</tr>
			<tr> 
				<td>
					<%--<SCRIPT language='JavaScript'>FormProc_ActiveX();</SCRIPT>--%>
                    <iframe id="message" class="viewbox"  name="message" src="/admin/ezPortal/portletEditCKContent.do" frameborder="0" style="padding:0; height:450px; width:495px; overflow:auto;"></iframe>
				</td>
			</tr> 
		</table>
		 
		<!-- 이미지 포틀릿 -->
		<table id="selectType_3" class="content" style="display:none">
  			<tr>
    			<th colspan="2" ><spring:message code='ezPortal.t164'/></th>
  			</tr>
  			<tr>
    			<th><spring:message code='ezPortal.t165'/></th>
    			<td>
    				<table width="100%" >
      				  	<tr>
          					<td style="width:340;HEIGHT:50"><div style="OVERFLOW:auto;width:340;HEIGHT:50"> <img id="txtImage" src="">&nbsp; </div>
              					<iframe name="ifrm" src="about:blank" style="display:none"></iframe>
	              				<form method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezPortal/portletImageUpload.do?mode=Portlet" target="ifrm" >
              						<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width:1px; height:1px;" multiple="true" />
              						<input type="hidden" name="boardid" id="boardid" />
              						<input type="hidden" name="maxsize" id="maxsize" />
              						<input type="hidden" name="mode" id="mode" />
              						<input type="hidden" name="cnt" id="cnt" />
              						<input type="hidden" name="mailgubun" id="mailgubun" />
              					</form>
          					</td>
          					<td width="65" align="center">             
	              				<a class="imgbtn"><span onClick="changeNormalImage()"><spring:message code='ezPortal.t66'/></span></a>
		      					<a class="imgbtn"><span  onClick="UserImage_Preview()"><spring:message code='ezPortal.t63'/></span></a>
		      				</td>
        				</tr>
      				</table>
      			</td>
  			</tr>
  			<tr>
    			<th ><spring:message code='ezPortal.t166'/></th>
    			<td>
    				<input type="radio" name="ImageType" value="1">
      					<spring:message code='ezPortal.t167'/><br>
      				<input type="radio" name="ImageType" value="2">
      					<spring:message code='ezPortal.t168'/><br>
      				<input type="radio" name="ImageType" value="3">
      					<spring:message code='ezPortal.t169'/></td>
  			</tr>
  			<tr>
    			<th >URL</th>
    			<td><input type="text" id="txtMaxURL" style="width:100%" value="${prop.maxUrl}"></td>
  			</tr>
  			<tr>
    			<th ><spring:message code='ezPortal.t170'/></th>
    			<td>
    				<c:choose>
    					<c:when test="${pOpenMode == '1'}">
    						<input type="checkbox" name="OpenMode" onclick="newWindowClick()" checked>	
    					</c:when>
    					<c:otherwise>
    						<input type="checkbox" name="OpenMode" onclick="newWindowClick()">
    					</c:otherwise>
    				</c:choose>
      				(<spring:message code='ezPortal.t171'/>
				</td>
  			</tr>
  			<tr id="txtWindowOptionID" style="display:none">
    			<th ><spring:message code='ezPortal.t172'/></th>
    			<td><input type="text" name="txtWindowOption" id="txtWindowOption" style="width:100%" value="${pWindowOption}">    </td>
  			</tr>
		</table>
		<!-- 게시판 포틀릿 -->
			<table id="selectType_4" class="content" style="display:none">
  				<tr>
    				<th colspan="2" ><spring:message code='ezPortal.t173'/></th>
  				</tr>
  				<tr>
    				<th width="90" ><spring:message code='ezPortal.t160'/></th>
    				<td>
    					<input type="radio" name="UserType" value="1" onClick="SetUserType('1')">
      						<spring:message code='ezPortal.t161'/>
      					<input type="radio" name="UserType" value="2" onClick="SetUserType('2')">
      						<spring:message code='ezPortal.t162'/></td>
  				</tr>
  				<tr id="tr_board1">
    				<th width="90" ><spring:message code='ezPortal.t137'/></th>
    				<td>
    					<table width="100%" >
        					<tr>
          						<td>
          							<input type="hidden" name="txtBoardID" id="txtBoardID" style="width:100%" value="${pBoardID}">
            						<input type="text" name="txtBoardName" id="txtBoardName" style="width:100%" value="${pBoardName}" readonly>          
            					</td>
          						<td width="99" align="center">
		  							<a class="imgbtn"><span onClick="SelectBoard()"><spring:message code='ezPortal.t138'/></span></a>
		  						</td>
        					</tr>
      					</table>
					</td>
  				</tr>
  				<tr id="tr_board2">
    				<th ><spring:message code='ezPortal.t139'/></th>
    				<td>
    					<input type="text" name="txtItemCount" id="txtItemCount" value="${pItemCount}">
      						<spring:message code='ezPortal.t140'/></td>
  				</tr>
  				<tr id="tr_board3">
    				<th ><spring:message code='ezPortal.t141'/></th>
    				<td>
    					<input type="checkbox" name="ItemField" value="TITLE">
      						<spring:message code='ezPortal.t145'/>
      					<input type="checkbox" name="ItemField" value="STARTDATE">
      						<spring:message code='ezPortal.t143'/></td>
  				</tr>
			</table>
			<!-- 인자설정 -->
			<table id="toggle_tbl2_1" class="popuplist"  width="100%" style="display:none">
  				<tr>
    				<th><spring:message code='ezPortal.t115'/></th>
    				<th ><spring:message code='ezPortal.t116'/></th>
    				<th ></th>
  				</tr>
				${paramHtml}
			</table>
			<table id="toggle_tbl2_2" class="content" style="display:none">
  				<tr>
    				<th width="85" ><spring:message code='ezPortal.t117'/></th>
    				<td><input type="text" id="newParamName" style="width:100%"></td>
  				</tr>
  				<tr>
    				<th ><spring:message code='ezPortal.t118'/></th>
    				<td>
    					<table width="100%" >
        					<tr>
          						<td style="width:125px; ">
          	 						<select id="SelectParamType" onChange="Param_Change()" width="100%">
            	  						<c:forEach items="${paramType}" var="item">
              								<option value="${item.paramType}"><spring:message code='ezPortal.${item.shortName}'/></option>
              							</c:forEach>
            						</select> 
								</td>
          						<td>
          							<input type="text" id="newParamValue" style="width:100%">
          						</td>
        					</tr>
      					</table>
      				</td>
  				</tr>
			</table>
			<div class="btnposition" id="toggle_tbl2_3"  style="display:none">
				<a class="imgbtn"><span onClick="AddParameter()"><spring:message code='ezPortal.t62'/></span></a>
			</div>
			<!-- 권한설정 -->
				<table id="toggle_tbl3_1" class="popuplist" style="display:none" width="100%">
  					<tr>
						<th width="80" ><spring:message code='ezPortal.t91'/></th>
						<th width="80" ><spring:message code='ezPortal.t92'/></th>
						<th width="80" ><spring:message code='ezPortal.t93'/></th>
						<th width="80" ><spring:message code='ezPortal.t94'/></th>
						<th>&nbsp;</th>
  					</tr>
		  			<c:forEach items="${aclList}" var="item">
  	  					<tr>
    						<td>${item.accessID}</td>
    						<td>${item.accessName}</td>
    						<td>
    							<c:choose>
    								<c:when test="${item.edit_Right == 2}">
    									<spring:message code='ezPortal.t95'/>
    								</c:when>
    								<c:otherwise>
    									<spring:message code='ezPortal.t96'/>
    								</c:otherwise>
    							</c:choose>
    						</td>
    						<td>
    							<c:choose>
    								<c:when test="${item.view_Right == 2}">
    									<spring:message code='ezPortal.t95'/>
    								</c:when>
    								<c:otherwise>
    									<spring:message code='ezPortal.t96'/>
    								</c:otherwise>
    							</c:choose>
    						</td>
    						<td width="39" align="center"><a class="imgbtn"><span onClick="DeleteRight('${item.accessID}')" ><spring:message code='ezPortal.t67'/></span></a></td>
  						</tr>
  					</c:forEach>
				</table>
				<table id="toggle_tbl3_2" class="content" style="display:none">
  					<tr>
    					<th><spring:message code='ezPortal.t91'/></th>
    					<td>
    						<table width="100%" >
        						<tr>
          							<td>
          								<input type="text" id="newAccessID" style="width:100%" readonly>
          							</td>
          							<td width="39" align="center"><a class="imgbtn"><span onClick="SelectID()" ><spring:message code='ezPortal.t45'/></span></a></td>
        						</tr>
      						</table>
      					</td>
  					</tr>
  					<tr>
    					<th ><spring:message code='ezPortal.t92'/></th>
    					<td><input type="text" id="newAccessName" style="width:100%" readonly></td>
  					</tr>
  					<tr>
    					<th ><spring:message code='ezPortal.t93'/></th>
    					<td>
    						<input type="radio" name="SelectEditRight" value="1" checked>
      							<spring:message code='ezPortal.t97'/>
      						<input type="radio" name="SelectEditRight" value="2">
      							<spring:message code='ezPortal.t174'/></td>
  					</tr>
  					<tr>
    					<th ><spring:message code='ezPortal.t94'/></th>
    					<td>
    						<input type="radio" name="SelectViewRight" value="1" checked>
      							<spring:message code='ezPortal.t97'/>
      						<input type="radio" name="SelectViewRight" value="2">
      							<spring:message code='ezPortal.t174'/></td>
  					</tr>
				</table>
				<div id="toggle_tbl3_3" class="btnposition" style="display:none">
    				<a class="imgbtn"><span onClick="AddRight()"><spring:message code='ezPortal.t62'/></span></a>
				</div>
	</body>
</html>