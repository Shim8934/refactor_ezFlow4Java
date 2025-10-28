<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t1011' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var lang = "<c:out value='${lang}'/>";
		
			/* 2019-11-15 홍승비 - 일본어 환경에서 '공통' 카테고리가 기본으로 선택되도록 수정 */
			window.onload = function () {
				if (lang == "3") {
					var selectCateA = $("select[name='cCateA']");
					if (selectCateA.length > 0) {
						selectCateA.val("AA").prop("selected", true);
					}
				}
			};
			
			/* 2018-05-15 홍승비 - 커뮤니티 만들기 팝업창으로 수정 */
			function check() {
		        var newID = "{" + GetGUID().toUpperCase() + "}";
		        var new_subID = "{" + GetGUID().toUpperCase() + "}";

		        document.make.sNewID.value = newID;
		        document.make.sNewSubID.value = new_subID;

		        if (document.make.clubName.value == "" || trim_Cross(document.make.clubName.value) == "") {
		            alert("<spring:message code='ezCommunity.t2' />");
	                document.make.clubName.focus();
	                return;
	            }

	            if (document.make.clubName.value.length > 50) {
	                alert("<spring:message code='ezCommunity.t3' />");
	                document.make.clubName.focus();
	                return;
	            }

	            if (document.make.clubName2.value.length > 50) {
	                alert("<spring:message code='ezCommunity.t3' />");
	                document.make.clubName2.focus();
	                return;
	            }

	            if (document.make.intro.value.length > 2000) {
	                alert("<spring:message code='ezCommunity.t1009' />");
	                document.make.intro.focus();
	                return;
	            }

	            selA = parseInt(document.make.cCateA[document.make.cCateA.selectedIndex].value);
	            selB = parseInt(document.make.cCateB[document.make.cCateB.selectedIndex].value);
	            selC = parseInt(document.make.cCateC[document.make.cCateC.selectedIndex].value);

	            //if (selA == 0 && selB == 0 && selC == 0) {
	            if (selA == 0) {
	                alert("<spring:message code='ezCommunity.t4' />");
	                make.cCateA.focus();
	                return;
	            }

	            if (document.make.intro.value == "") {
	                alert("<spring:message code='ezCommunity.t1010' />");
	                document.make.intro.focus();
	                return;
	            }

	            document.make.hiddenClubName.value = document.make.clubName.value;

	            if (document.make.clubName2.value != "" && trim_Cross(document.make.clubName2.value) != "") {
	                document.make.hiddenClubName2.value = document.make.clubName2.value;
	            }

	            if (document.make.intro.value != "") {
	                document.make.hiddenIntro.value = document.make.intro.value;
	            }

	            document.make.submit();
	        }
			
			function back() {
				/* 18-04-30 김민성 - 커뮤니티 만들기 취소시 메인화면으로 이동 하도록 수정 */
                parent.document.querySelector("iframe[name=right]").src = "/ezCommunity/mainPage.do";
				
				/* if("${flag}" == '1'){
		        	   window.open("/ezCommunity/mainPage.do", "right");
		        }else{ 
		               history.back(-1);
		       }   */
			}
			
	        function btn_AttachSelect_onclick(num) {
	            if (num == "1"){
	                document.getElementById("file1").click();
	            }else if (num == "2"){
	                document.getElementById("file2").click();
	            }
	        }
	        
	        /* 2020-06-10 홍승비 - 커뮤니티 만들기 시 이미지 확장자 체크 부분 수정, 미사용 c:if 분기 제거 */
	        function btn_AttachAdd_onclick(file) {
	            var fileid = file.id;
	            var fileval = document.getElementById(fileid).value;
	            var printspanid = "";
	            
	            if (fileid == "file1") {
	                printspanid = "filename";
	            } else if (fileid == "file2") {
	                printspanid = "filename2";
	            }
	            if (fileval != "") {
	                var filename = fileval.substring(fileval.lastIndexOf("\\") + 1, fileval.length);
	                var extension = filename.substring(filename.lastIndexOf(".") + 1, filename.length);
	                var check = "false";
	                check = compareExtension(check, extension);
	                
	                if (check == "false") {
	                    alert(filename + strLang40);
	                    document.getElementById(fileid).value = "";
	                    document.getElementById(printspanid).innerText = "";
	                    return;
	                }
	                
	                /* 2021-12-08 홍승비 - 커뮤니티 상단/썸네일 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
	                if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
						document.getElementById(fileid).value = "";
						document.getElementById(printspanid).innerText = "";
						alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
						return ;
					}
	                
	                document.getElementById(printspanid).innerText = filename;
	            } else {
	            	document.getElementById(printspanid).innerText = "";
	            }
	        }
	        
		    function compareExtension(check, extension) {
		        var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
		        
		        for (var i = 0; i < filterExtension.length; i++) {
		            if (extension.toLowerCase() == filterExtension[i]) {
		                check = "true";
		                break;
		            }
		        }
		    	return check;
		    }
		    
		</script>
	</head>
	<body class="popup">
	    <div id="menu" style="margin-top:7px;">
	        <ul>
	            <li><span id="btnDraft" onclick="check()"><spring:message code='ezCommunity.t1011' /></span></li>
	        </ul>
	    </div>
	    <div id="close">
	    	<ul>
	    		<li><span onclick="window.close()"></span></li>
	    	</ul>
	    </div>
	    <%-- 2018-05-16 홍승비 - 경고메세지 처리를 jsp 내부에서 보이도록 하기 위해 수정 --%>
	    <iframe name="ifrm" src="about:blank" style="display:none;"></iframe>
		<form method="post" name="make" action="/ezCommunity/commMakeOk.do" enctype="multipart/form-data" target="ifrm">
			<input type="hidden" name="makeID" value="<c:out value='${userInfo.id }' />">
            <input type="hidden" name="hiddenClubName">
            <input type="hidden" name="hiddenClubName2">
            <input type="hidden" name="hiddenIntro">
            <input type="hidden" name="sNewID">
            <input type="hidden" name="sNewSubID">
            
	    	<table class="content" style="width:100%; margin-top:19px;">
	            <tr>
	                <th><spring:message code='ezCommunity.t1012' /></th>
	                <td colspan="2">
	                    <input type="text" name="userName" value="<c:out value='${userInfoDisplayName }' />" readonly="true" size="40" style="border:1px solid white">
					</td>
	            </tr>
	            <tr>
	                <th><spring:message code='ezCommunity.t9991' /></th>
	                <td colspan="2" style="padding: 0">
	                    <table style="width:100%">
	                        <tr class="primary">
	                            <th><c:out value='${langPrimary }' /><span style="color:red"> *</span></th>
	                            <td>
	                                <input type="text" class="inputText" name="clubName" size="80" maxlength="50" style="width: 100%;box-sizing:border-box;-moz-box-sizing:border-box;">
								</td>
	                        </tr>
	                        <tr class="secondary">
	                            <th><c:out value='${langSecondary} ' /><span style="color:red"> *</span></th>
	                            <td>
	                                <input type="text" class="inputText" name="clubName2" maxlength="50" style="WIDTH: 100%;box-sizing:border-box;-moz-box-sizing:border-box;">
								</td>
	                        </tr>
	                    </table>
	                </td>
	            </tr>
	            <tr style="height:60px">
	                <th style="height:40px;"><spring:message code='ezCommunity.t11' /><span style="color:red"> *</span></th>
	                <td style="white-space:nowrap;border-right:0px"><span id="idSpan">${idSpanValue }</span></td>
	                <td style="padding: 5px;padding-right:25px;white-space:nowrap;border-left:0px">
	                	<%-- <div><spring:message code='ezCommunity.t1013' /></div> --%>
	                	<div><spring:message code='ezCommunity.t1014' /></div>
	                </td>
	            </tr>
	            <tr style="height:60px">
	                <th style="height:40px;"><spring:message code='ezCommunity.t12' /></th>
	                <td style="white-space:nowrap;border-right:0px">
						<div class="custom_radio">
							<input id="clubConfirmType1" type="radio" name="clubConfirmType" value="2" checked><label for="clubConfirmType1"><spring:message code='ezCommunity.t13' /></label>
							<input id="clubConfirmType2" type="radio" name="clubConfirmType" value="3"><label for="clubConfirmType2"><spring:message code='ezCommunity.t1015' /></label>
						</div>
	                </td>
	                <td style="padding: 5px;white-space:nowrap;border-left:0px">	                
	                	<div><spring:message code='ezCommunity.t452' /></div>
	                    <div style="margin-top:7px"><spring:message code='ezCommunity.t1016' /></div>
	                </td>
	            </tr>
	            <tr style="height:60px">
	                <th style="height:40px;"><spring:message code='ezCommunity.t15' /></th>
	                <td style="white-space:nowrap;border-right:0px">
						<div class="custom_radio">
							<input id="clubType1" type="radio" name="clubType" value="2" checked><label for="clubType1"><spring:message code='ezCommunity.t16' /></label>
							<input id="clubType2" type="radio" name="clubType" value="3"><label for="clubType2"><spring:message code='ezCommunity.t17' /></label>
						</div>
	                </td>
	                <td style="padding: 5px;white-space:nowrap;border-left:0px">
	                	<div><spring:message code='ezCommunity.t1017' /></div>
	                    <div style="margin-top:7px"><spring:message code='ezCommunity.t1018' /></div>
	                </td>
	            </tr>
	            <tr style="display: none;height:60px">
	                <th style="height:40px;"><spring:message code='ezCommunity.t1019' /></th>
	                <td style="white-space:nowrap;border-right:0px">
						<div class="custom_radio"><input type="radio" name="isIn" value="1"><spring:message code='ezCommunity.t1020' /></div>
						<div class="custom_radio"><input type="radio" name="isIn" value="2" checked><spring:message code='ezCommunity.t1021' /></div>
	                </td>
	                <td style="padding: 5px;white-space:nowrap;border-left:0px">
	                	<div><spring:message code='ezCommunity.t459' /></div>
	                    <div style="margin-top:3px"><spring:message code='ezCommunity.t1022' /></div>
	                </td>
	            </tr>	            
	            <%--상단 이미지(기존:로고 이미지) 894 * 100 --%>	            
	            <tr>
	                <th><spring:message code='ezCommunity.jjh03' /></th>
	                <td style="border-right:0px;padding-left:5px">
	                    <span style="vertical-align:middle">
	                        <a class="imgbtn imgbck"><span id="btn_AttachAdd_logo" onclick="return btn_AttachSelect_onclick(1)"><spring:message code='ezCommunity.t1177' /></span></a>
	                        <span id="filename" style="vertical-align:middle; padding-left:3px; min-height:16px; display: inline-block;"></span>
	                        <input type="file" id="file1" name="logo" accept="image/*" onchange="btn_AttachAdd_onclick(this)" style="display:none">
	                    </span>
	                </td>
	                <td style="padding: 5px;white-space:nowrap;border-left:0px">
	                	★ <spring:message code='ezCommunity.jjh03' /> : 894px * 100px
	                </td>
	            </tr>
	            <tr>
	                <th><spring:message code='ezCommunity.jjh02' /></th>
	                <td style="border-right:0px;padding-left:5px">
	                    <span style="vertical-align:middle">
	                        <a class="imgbtn imgbck"><span id="btn_AttachAdd_banner" onclick="return btn_AttachSelect_onclick(2)"><spring:message code='ezCommunity.t1177' /></span></a>
	                        <span id="filename2" style="vertical-align:middle; padding-left:3px; min-height:16px; display:inline-block;"></span>
	                        <input type="file" id="file2" accept="image/*" name="thumb" onchange="btn_AttachAdd_onclick(this)" style="display:none;">
	                    </span>
	                </td>
	                <td style="padding: 5px;white-space:nowrap;border-left:0px">
	                	★ <spring:message code='ezCommunity.jjh02' /> : 198px * 140px
	                </td>
	            </tr>
	            <tr>
	                <th style="padding-left: 5px; padding-right: 5px;"><spring:message code='ezCommunity.t1529' /> <spring:message code='ezCommunity.t18' /><span style="color:red"> *</span></th>
	                <td colspan="2">
	                    <textarea name="intro" maxlength="2000" style="height: 120px; width: 99.5%;box-sizing:border-box;-moz-box-sizing:border-box;resize:none;margin:5px"></textarea>
					</td>
	            </tr>
			</table> 
	    </form>	    
	    <script type="text/javascript">
            selToggleList(document.getElementById("menu"), "ul", "li", "0");
        </script>
	</body>
</html>