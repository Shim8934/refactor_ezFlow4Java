<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='ezApprovalG.t367'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/diff.js')}"></script>
	<style type="text/css">
		addsentence {
			text-decoration: none;
            background-color: #d4fcbc;
		}
        delsentence {
            text-decoration: line-through;
            background-color: #fbb6c2;
            color: #555;
        }
    </style>
    <script type="text/javascript">
	    var pDocHrefBefore = "${docHrefBefore}"; // 편집 전 문서
	    var pDocHrefAfter = "${docHrefAfter}"; // 편집 후 문서
        var ReturnFunction;
        var selectedAn = ""; //  선택된 안 index (일괄기안 B타입 문서비교를 위함)
        
        window.onload = function () {
            if (isParentCommonArgsUsed()) {
                ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
            }
            
        	ShowMailProgress();
        }
        
////////////////////////////////////////// 2023-02-08 홍승비 - 웹한글기안기 로딩 -> HWP파일 로딩 -> HTML 형식으로 변환 -> 비교 코드 순차적으로 작성 //////////////////////////////////////////

        // 1) 웹한글기안기의 로딩 이후, 편집 전 HWP 문서 로딩
        function Editor_Complete_Compare() {
			if (pDocHrefBefore != "") {
				var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHrefBefore);
                message.Open(URL, "", "", function (res) {
                    if (res.result) {
	                    message.EditMode(0);
                    } 
                }, null);   
			}
            
            if (!!opener.parent.an) {
                filterDocForAn_B(message.HwpCtrl);
            }
        }
        
        // 2) 웹한글기안기의 로딩 이후, 편집 후 HWP 문서 로딩 시 잠시 타임아웃 (1초)
        function Editor_Complete_Compare2() {
            setTimeout("Editor_Complete_Compare2Load();", 1000);
        }
        
		// 3) 편집 후 HWP 문서 로딩
        function Editor_Complete_Compare2Load() {
			if (pDocHrefAfter != "") {
				var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHrefAfter);
                message2.Open(URL, "", "", function (res) {
                    if (res.result) {
	                    message2.EditMode(0);
	                    
	                    // 수정이력 비교를 위해, DIV 태그 영역 내부에 HWP 파일을 HTML로 로드 (텍스트 데이터를 가져와 SetHtml 함수를 실행)
	                    message.GetTextFile("HTML", "", SetHtml); // 편집 전 문서부터 변환 시작
                    } 
                }, null);   
			}
            
            if (!!opener.parent.an) {
                filterDocForAn_B(message2.HwpCtrl);
            }
        }
        
        // 4) 편집 전 문서 HTML 변환 -> 편집 후 문서 HTML 변환 호출
        function SetHtml(data) {
            document.getElementById("docView").innerHTML = data;
            message2.GetTextFile("HTML", "", SetHtml2);
        }

        // 5) 편집 후 문서 HTML 변환 -> HTML 비교 함수 호출
        function SetHtml2(data) {
            document.getElementById("docView2").innerHTML = data;
            Set_EditorContentURL_Compare();
        }
        
        // 6) HTML 비교함수 동작
        // MHT 문서와 다르게, HWP파일을 HTML로 변형하면서 본문(body) 영역을 알 수 없게 되므로 전체 영역에 대해 비교가 이루어짐
        function Set_EditorContentURL_Compare() {
			try {
                var tempOrgStr = document.getElementById("docView2").innerHTML;
                var tempStr = document.getElementById("docView").innerHTML;
                  var _DocOrgHTML = tempOrgStr;
                  var _DocHTML = tempStr;

                  // 이미지는 비교하지 않는다.
                  var img_tag = /<IMG(.*?)>/gi;
                  _DocHTML = _DocHTML.replace(img_tag, ""); 
                  _DocHTML = _DocHTML.replace(/<OPTION(.*?)>/gi, ""); 
                  
                  var _OrgHTMLTag = document.createElement("DIV");
                  _OrgHTMLTag.innerHTML = _DocOrgHTML;

                  var _HTMLTag = document.createElement("DIV");
                  _HTMLTag.innerHTML = _DocHTML;
                  
                  var _DocOrgBody = "";
                  var _DocBody = "";
				_DocOrgBody = _OrgHTMLTag.innerHTML;
				_DocBody = _HTMLTag.innerHTML;
				
				_OrgHTMLTag.innerHTML = htmldiff(_DocOrgBody, _DocBody);

                // 특정 양식에서 발생하는 오류 수정 - 본문 왼쪽에 빈값인 td태그가 생성되어 본문이 오른쪽으로 밀려나는 현상 수정
                var parser = new DOMParser();
                var doc = parser.parseFromString(_OrgHTMLTag.innerHTML, 'text/html');

                var tdElements = doc.querySelectorAll('td');

                tdElements.forEach(td => {
                    if (td.innerHTML.trim() === '') {
                        td.parentNode.removeChild(td);
                    }
                });

                _OrgHTMLTag.innerHTML = doc.body.innerHTML;

				// HWP 파일이기 때문에 "ezeditor"라는 id는 존재하지 않으나, 만일을 위해 하단 코드 유지
                  for (var i = 0; i < _OrgHTMLTag.getElementsByTagName("*").length; i++) {
                      if (_OrgHTMLTag.getElementsByTagName("*")[i].id.toLocaleLowerCase() == "ezeditor" && _OrgHTMLTag.getElementsByTagName("*")[i].innerHTML.trim() == "") {
                          _OrgHTMLTag.getElementsByTagName("*")[i].parentNode.removeChild(_OrgHTMLTag.getElementsByTagName("*")[i]);
                          break;
                      }
                  }
                  
                  var _DocContentHtml = _OrgHTMLTag.innerHTML;
                  var ConXmlDiv = document.createElement("DIV");
                  ConXmlDiv.innerHTML = _DocContentHtml;
                  
                  // 전자결재 문서 내부 XML 태그는 숨김처리
                  if (ConXmlDiv.getElementsByTagName("XML").length > 0) {
                      ConXmlDiv.getElementsByTagName("XML").item(0).style.display = "none";
                      _DocContentHtml = ConXmlDiv.innerHTML;
                  }
                  
                  document.getElementById("docView2").innerHTML = "";
                  document.getElementById("docView2").innerHTML = _DocContentHtml;
                  
                  var TDRows = document.getElementById("docView2").getElementsByTagName("TD");
                  for (var i = 0; i < TDRows.length; i++) {
                      if (GetAttribute(TDRows.item(i), "id") != null) {
                          if (TDRows.item(i).childNodes.length == 0) {
                              if (TDRows.item(i).innerHTML == "" || TDRows.item(i).innerHTML == " ") {
                                  TDRows.item(i).innerHTML = "&nbsp;";
                              }
                          }
                      }
                  }
                  
                  // 사용자 입력 방지
                  BodyTagsDisabled(document.getElementById("docView2"));
                  
                  HiddenMailProgress();
            } catch (e) {
            	console.log(e);
            }
        }
        
        function BodyTagsDisabled(HtmlObject) {
            var SelectRows = HtmlObject.getElementsByTagName("SELECT");
            for (var i = 0; i < SelectRows.length; i++) {
                if (!SelectRows.item(i).disabled) {
                    SelectRows.item(i).disabled = true;
                }
            }
            
            var inputRows = HtmlObject.getElementsByTagName("INPUT");
            for (var i = 0; i < inputRows.length; i++) {
                if (!inputRows.item(i).disabled) {
                    inputRows.item(i).disabled = true;
                }
            }
            
			var textAreaElements = HtmlObject.getElementsByTagName("textarea");
			var element;
			
			for (var i = 0; i < textAreaElements.length; i++) {
				element = textAreaElements[i];

				if (!element.disabled) {
					element.disabled = true;
				}
			}
            return HtmlObject;
        }
        
 ///////////////////////////////////////////////////////////////////// HWP -> HTML 변환 및 비교기능 구현부분 완료 //////////////////////////////////////////////////////////////////////////
 
        function btnPrint_onclick() {
            if (document.getElementById("divTD1").style.display == "" && document.getElementById("divTD2").style.display == "none") {
            	message.PrintDocument(); // 편집 전 문서
            } else if (document.getElementById("divTD1").style.display == "none" && document.getElementById("divTD2").style.display == "") {
            	message2.PrintDocument(); // 편집 후 문서
            }
        }
	    
        // function btnClose_onclick() {
        //     window.close();
        // }

	    function btnSave_onclick() {
            var hwpDoctitle = "";
            
            if (document.getElementById("divTD1").style.display == "" && document.getElementById("divTD2").style.display == "none") {
            	hwpDoctitle = message.GetFieldText("doctitle").replace("\r\n", ""); // 편집 전 문서
            } else if (document.getElementById("divTD1").style.display == "none" && document.getElementById("divTD2").style.display == "") {
            	hwpDoctitle = message2.GetFieldText("doctitle").replace("\r\n", ""); // 편집 후 문서
            }
            
            hwpDoctitle = hwpDoctitle.replace(/\\/ig, '').replace(/\//ig, '').replace(/:/ig, '').replace(/\*/ig, '').replace(/\?/ig, '').replace(/“/ig, '').replace(/</ig, '').replace(/>/ig, '').replace(/|/ig, '').replace("“", "").replace("|", "");
            
            if (hwpDoctitle == "") {
            	var pAlertContent = "<spring:message code='ezApprovalG.t1395'/>";
                OpenAlertUI(pAlertContent);
            	return;
            }
            
            hwpDoctitle += ".hwp";
            
            if (document.getElementById("divTD1").style.display == "" && document.getElementById("divTD2").style.display == "none") {
				message.SaveFile(hwpDoctitle, "HWP", "");
            } else if (document.getElementById("divTD1").style.display == "none" && document.getElementById("divTD2").style.display == "") {
				message2.SaveFile(hwpDoctitle, "HWP", "");
            }
        }
	    
        function btnCompare_onclick() { // 문서비교
        	document.getElementById("saveLI").style.display = "none";
        	document.getElementById("printLI").style.display = "none";
        	document.getElementById("divTD1").style.display = "";
        	document.getElementById("divTD2").style.display = "";
        }
        
        function btnShowBefore_onclick() { // 원문보기
        	document.getElementById("saveLI").style.display = "";
        	document.getElementById("printLI").style.display = "";
        	document.getElementById("divTD1").style.display = "";
        	document.getElementById("divTD2").style.display = "none";
        }
        
        function btnShowAfter_onclick() { // 현재보기
        	document.getElementById("saveLI").style.display = "";
        	document.getElementById("printLI").style.display = "";
        	document.getElementById("divTD1").style.display = "none";
        	document.getElementById("divTD2").style.display = "";
        }
        
    	function ShowMailProgress() {
    		var CurrenWidth = document.documentElement.clientWidth;
    		
            document.getElementById("mailPanel").style.display = "";
            document.getElementById("loadingProgress").style.top = "600px";
            document.getElementById("loadingProgress").style.left = (CurrenWidth / 2) - 100 + "px";
            document.getElementById("loadingProgress").style.display = "";
	    }
    	
	    function HiddenMailProgress() {
	    	document.getElementById("mailPanel").style.display = "none";
        	document.getElementById("loadingProgress").style.display = "none";
	    }
        
        function filterDocForAn_B(HwpCtrl) {
            selectedAn = opener.parent.an.selectedIndex;
            maxAnIdx = opener.parent.an.options.length;
            // 안이 삭제되면서 각 안의 인덱스가 변동하는 것을 막기 위해 뒤에서부터 안을 거꾸로 삭제함
            for (let i = maxAnIdx - 1; i > 0; i--) {
                if (i != selectedAn) {
                    deleteAn_B(HwpCtrl, i)
                }
            }
        }
        
        // 일괄기안 B타입 비교를 위해 해당하지 않는 기안을 삭제하는 로직 
        function deleteAn_B(HwpCtrl, anIndex){
            HwpCtrl.MoveToField("headcampaign{{"+anIndex+"}}");
            HwpCtrl.DeleteCtrl(HwpCtrl.ParentCtrl);
            var now = HwpCtrl.KeyIndicator().prnpageno;
            var next = 0;
            if(HwpCtrl.MoveToField("headcampaign{{"+anIndex+"}}")){
                next = HwpCtrl.KeyIndicator().prnpageno;
            }
            if(next){
                HwpCtrl.Run("MoveDocBegin");
                for(var i = 1; i < now; i++){
                    HwpCtrl.Run("MovePageDown");
                }
                for(var i = now; i < next; i++){
                    HwpCtrl.Run("MovePageBegin");
                    HwpCtrl.Run("Select");
                    HwpCtrl.Run("MovePageEnd");
                    HwpCtrl.Run("DeleteBack");
                    HwpCtrl.Run("DeleteBack");
                }
            }else{
                HwpCtrl.Run("MovePageBegin");
                HwpCtrl.Run("Select");
                HwpCtrl.Run("MoveDocEnd");
                HwpCtrl.Run("DeleteBack");
                HwpCtrl.Run("DeleteBack");
            }
        }
	    
    </script>
</head>

<body class="popup">
    <table class="layout">
        <tr>
            <td height="20">
                <div id="menu">
	                    <ul>
							<li id="showCompareLI"><span onclick="btnCompare_onclick()"><spring:message code='ezApprovalG.hsbCo01'/></span></li>
							<li id="showBeforeLI"><span onclick="btnShowBefore_onclick()"><spring:message code='ezApprovalG.hsbCo02'/></span></li>
	                        <li id="showAfterLI"><span onclick="btnShowAfter_onclick()"><spring:message code='ezApprovalG.hsbCo03'/></span></li>
	                        <li id="saveLI" style="display:none;"><span onclick="btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="printLI" style="display:none;"><span class="icon16 popup_icon16_print" onclick="btnPrint_onclick()"></span> </li>
	                    </ul>
                </div>
                <div id="close">
                    <ul>
                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
                    </ul>
                </div>
            </td>
        </tr>
        
        <%-- 화면에 표출하지 않는 웹한글기안기 영역 (HWP 문서를 로딩하기만 함) --%>
        <tr style="display:none;">
			<td id="messageTD" style="padding-bottom: 10px;">
                <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="/ezApprovalG/WHWPEditor.do?type=compareBefore" name="message" frameborder="0" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
            </td>
			 <td id="message2TD" style="padding-bottom: 10px;">
                <iframe id="message2" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="/ezApprovalG/WHWPEditor.do?type=compareAfter" name="message2" frameborder="0" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
            </td>
        </tr>
        
        <%-- 화면에 표출하는 HTML 변환 영역 (HWP -> HTML) --%>
        <tr>
			<div style="vertical-align: top;" id="EdtorSize">
	            <table style="width: 100%; height: 100%;">
	                <tr>
	                    <td id="divTD1" style="width:50%; display:inline-block; vertical-align: top">    
	                        <div id="docView"> </div>                
	                    </td>
	                    <td id="divTD2"  style="width:50%; display:inline-block; vertical-align: top" >
	                         <div id="docView2"> </div>
	                    </td>
	                </tr>
	            </table>
        	</div>
        </tr>
    </table>
    
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	<%-- 로딩 이미지 표출 영역 --%>
	<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingProgress">
       	<img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
   	</div>
    	
    <script type="text/javascript">
        selToggleList(document.getElementById("menu"), "ul", "li", "0");
        selToggleList(document.getElementById("close"), "ul", "li", "0");
    </script>
</body>
</html>
