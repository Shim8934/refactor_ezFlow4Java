<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>ChangePersonInfo</title>
		<link rel="stylesheet"  href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/datepicker.htc.js"></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/composeappt.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
		<script type="text/javascript" src="/js/rsa/asn1.js"></script>
		<script type="text/javascript">
		var rsa = new RSAKey();
		<%
		String userLang = (String)request.getAttribute("userLang"); 
		%>
		 var getBirthDay = "${birthDay}";
		    $(function () {
		        document.getElementById("TempCalImage").style.display = "none";
		        $("#txtBirth").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#txtBirth").datepicker("option", "dateFormat", "yy-mm-dd");
		        if (getBirthDay == "") {
		            var NowDate = new Date();
		            $("#txtBirth").datepicker('setDate', NowDate);
		        }
		        else
		            $("#txtBirth").datepicker('setDate', getBirthDay);
		    });

		    <% if (userLang.equals("1")) {%>
		    $(function () {
		        $.datepicker.regional['ko'] = {
		            closeText: '닫기',
		            prevText: '이전달',
		            nextText: '다음달',
		            currentText: '오늘',
		            monthNames: ['1월', '2월', '3월', '4월', '5월', '6월',
		            '7월', '8월', '9월', '10월', '11월', '12월'],
		            monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월',
		            '7월', '8월', '9월', '10월', '11월', '12월'],
		            dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		            dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		            dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            yearRange: 'c-100:c+0',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional['ko']);
		    });
		    <%}else {%>
		    $(function () {
		        $.datepicker.regional['en'] = {
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            yearRange: 'c-100:c+0',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional['en']);
		    });
		    <%}%>
		    window.onload = function () {
		    	rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		    	
		        if ("<%=userLang%>" != "1" && "<%=userLang%>" != "4") {
		            document.getElementById("RadBirthType1").style.display = "none";
		            document.getElementById("RadBirthType2").style.display = "none";
		        }
		    }
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		    var personpicture_cross_dialogArguments = new Array();
		    function btnPhoto_onclick() {
		        var wWeight = "400";
		        var wHeight = "280";

		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;

		        var left = (width - wWeight) / 2;
		        var top = (heigth - wHeight) / 2;

		        if (CrossYN()) {
		            personpicture_cross_dialogArguments[1] = btnPhoto_onclick_Complete;
		            var OpenWin = window.open("/admin/ezOrgan/personPicture.do", "PersonPicture_Cross", GetOpenWindowfeature(405, 280));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var ret;
		            ret = window.showModalDialog("/admin/ezOrgan/personPicture.do", "", "dialogWidth:405px;dialogHeight:280px;dialogleft:" + left + "px;dialogtop:" + top + "px;toolbar:no;location:no;directories:no;status:no;menubar:no;scroll:no;edge:sunken;help:no");
		            window.location.reload(true);
		        }
		    }
		    function btnPhoto_onclick_Complete() {
		        window.location.reload(true);
		    }

		    var address_zip_select_dialogArguments = new Array();
			function zip_find()
		    {
			    if (CrossYN()) {
			        address_zip_select_dialogArguments[1] = zip_find_Complete;
			        var OpenWin = window.open("/ezAddress/address_zip_select.do", "address_zip_select", GetOpenWindowfeature(655, 420));
			        try { OpenWin.focus(); } catch (e) { }
			    }
			    else {
			        var Para = window.showModalDialog("/ezAddress/address_zip_select.do", "", "dialogWidth:655px;dialogHeight:420px;toolbar:no;location:no;directories:no;status:no;menubar:no;scroll:no;edge:sunken;help:no" + GetShowModalPosition(655, 420));
			        if (typeof (Para) != "undefined" || Para == "") {
			            document.getElementById("txtZipcode").value = Para[0];
			            document.getElementById("txtAddress").value = Para[1] + " " + Para[2] + " " + Para[3];
			        }
			    }
			}
			function zip_find_Complete(Para) {
			    if (typeof (Para) != "undefined" || Para == "") {
			        document.getElementById("txtZipcode").value = Para[0];
			        document.getElementById("txtAddress").value = Para[1] + " " + Para[2] + " " + Para[3];
			    }
			}

			function change_press()
			{
				if (window.event.keyCode == "13")
				{
					event.returnValue = false;
					document.getElementById("ButtonChangePassword").click();
				}
			}
					
			//MobileSetting
			function SettingMobile()
			{
				 //20120726 모바일 푸시 수정 start
				 		     window.open("UserSetting.aspx", "User_Setting", "height=130px,width=460px,status=no,toolbar=no,menubar=no,location=no,resizable=0" + GetOpenPosition(460, 130));
				 
				 //20120726 모바일 푸시 수정 start
			}
		    function checkKey() {
		        return false;
		    }
		    
		    function ButtonDeleteClick() {
				$.ajax({
		    		type : "POST",
		    		dataType : "html",
		    		url : "/ezPersonal/deletePicture.do",
		    		success : function(result) {
		    			 if (result == "OK") {
		    				var literalPhoto = document.getElementById("LiteralPhoto"); 
		    				literalPhoto.innerHTML = "<image id=myimg <spring:message code='ezPersonal.i1'/>>";
		    			} 
					},
		    		error : function() {
		    			alert("<spring:message code='ezPersonal.t190'/>");
		    		}
		    	});
		     }
		    
		    function PassWordChange() {
		        if (document.getElementById('txtNewPassword').value != document.getElementById('txtNewPasswordConfirm').value) {
		            alert("<spring:message code='ezPersonal.t193'/>");
			        document.all['txtNewPassword'].focus();
			        return;
			    }

		        if (document.getElementById('txtOldPassword').value == document.getElementById('txtNewPassword').value) {
		            alert("<spring:message code='ezPersonal.t194'/>");
			        document.all['txtNewPassword'].focus();
			        return;
			    }
		        if (document.getElementById('txtNewPassword').value == "") {
		            alert("<spring:message code='ezPersonal.t195'/>");
			        document.all['txtNewPassword'].focus();
			        return;
			    }

		        if (document.getElementById('txtNewPassword').value.Length > 100) {
		            alert("<spring:message code='ezPersonal.t196'/>");
			        document.all['txtNewPassword'].focus();
			        return;
			    }
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlPara = createXmlDom();
		        var xmlDom = createXmlDom();
		        var objRoot, objNode, subNode;
		        var objNode;
alert(rsa.encrypt(document.getElementById('txtOldPassword').value));
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "OLDPASSWORD", rsa.encrypt(document.getElementById('txtOldPassword').value));
		        createNodeAndInsertText(xmlDom, objNode, "NEWPASSWORD", rsa.encrypt(document.getElementById('txtNewPassword').value));
		        createNodeAndInsertText(xmlDom, objNode, "NEWPASSWORDCONFIRM", rsa.encrypt(document.getElementById('txtNewPasswordConfirm').value));
		        xmlHTTP.open("POST", "/ezPersonal/changePassword.do", false);
		        xmlHTTP.send(xmlDom);
		        // 수정(2007.02.07) : 사용자 생성/수정 루틴 변경 (BE 서버)
		        //var retVal = SelectSingleNodeValueNew(xmlHTTP.responseXML, "DATA");

		        if (xmlHTTP.status == 200) {
		            if (xmlHTTP.responseText == "OK") {
		                alert("<spring:message code='ezPersonal.t197'/>");
			            window.top.location.href = '/user/login/login.do';
			        } else {
			            alert("<spring:message code='ezPersonal.t198'/>");
			        }
		        }
		    }
		    
		    function ButtonChangeClick() {
		    	var birthType = "";
		    	if ($("input:radio[id='RadBirthType1']").is(":checked") == true) {
		    		birthType = "Y";
		    	} else {
		    		birthType = "N";
		    	}
		    	
		    	var cn = "${userInfo.id}";
		    	
		    	
				$.ajax({
		    		type : "POST",
		    		dataType : "html",
		    		url : "/ezPersonal/saveUserInfo.do",
		    		async : false,
		    		data : {
		    			cn : cn,
		    			telephoneNumber : document.getElementById("txtTelePhone").value,
		    			mobile : document.getElementById("txtMobilePhone").value,
		    			homePhone : document.getElementById("txtHomePhone").value,
		    			facsimileTelephoneNumber : document.getElementById("txtFax").value,
		    			postalCode : document.getElementById("txtZipcode").value,
		    			streetAddress : document.getElementById("txtAddress").value,
		    			birth : document.getElementById("txtBirth").value,
		    			birthType : birthType,
		    			info : document.getElementById("txtInfo").value
		    		},
		    		success : function(result) {   			
		    			 if (result == "OK") {
		    				 alert("<spring:message code='ezPersonal.t191'/>");
		    			} 
					},
		    		error : function() {
		    			alert("<spring:message code='ezPersonal.t192'/>");
		    		}
		    	});
		     }
		    
		  
		</script>
	</head>
	<body class="mainbody"> 
<form method="post" runat="server" action=""> 
    <h1><spring:message code='ezPersonal.t172'/></h1>
    <h2><spring:message code='ezPersonal.t173'/></h2>
    <span class="txt"><spring:message code='ezPersonal.t174'/></span>
    <table class="popuplist" width="100%">
        <tr> 
            <td width="130" rowspan="6" align="center">
                <div> 
                    <!-- <asp:Label EnableViewState="True" ID="LiteralPhoto" Runat="server"></asp:Label>  -->
                    <span id="LiteralPhoto">
                    	${literalPhoto}
                    </span>
                </div>
            </td>
			<th><spring:message code='ezPersonal.t67'/></th> 
            <td width="100%">
                <!-- <asp:Label ID="LabelCompany" Runat="server"></asp:Label> -->${labelCompany }
            </td> 
        </tr> 
        <tr> 
            <th><spring:message code='ezPersonal.t7'/></th> 
            <td>
                <!-- <asp:Label ID="LabelDepartment" Runat="server"></asp:Label> -->${labelDepartment }
            </td> 
        </tr>
        <tr> 
            <th><spring:message code='ezPersonal.t9'/></th> 
            <td>
            	<!-- <asp:Label ID="LabelDisplayName" Runat="server"></asp:Label> -->${labelDisplayName }
            </td> 
        </tr> 
        <tr> 
            <th><spring:message code='ezPersonal.t69'/></th> 
            <td>
            	<!-- <asp:Label ID="LabelTitle" Runat="server"></asp:Label> -->${labelTitle}
            </td> 
        </tr> 
        <tr> 
            <th><spring:message code='ezPersonal.t175'/></th> 
            <td>
            	<!-- <asp:Label ID="LabelJikChek" Runat="server"></asp:Label> -->${labelJikChek}
            </td> 
        </tr> 
        <tr> 
            <th><spring:message code='ezPersonal.t176'/></th> 
            <td>
            	<!-- <asp:Label ID="LabelMail" Runat="server"></asp:Label> -->${labelMail }
            </td> 
        </tr> 
    </table> 
    <table class="content" width="100%" style="margin-top:10px;"> 
        <tr>
            <th><spring:message code='ezPersonal.t177'/></th>
            <td width="230"><input type="text" id="txtTelePhone" size="22" value="${txtTelePhone}"></td>
            <th><spring:message code='ezPersonal.t178'/></th>
            <td><input type="text" id="txtMobilePhone" size="22" value="${txtMobilePhone}"> </td> 
        </tr> 
        <tr> 
            <th><spring:message code='ezPersonal.t70'/></th> 
            <td> <input type="text" id="txtHomePhone" size="22" value="${txtHomePhone}"> </td> 
            <th><spring:message code='ezPersonal.t179'/></th> 
            <td> <input type="text" id="txtFax" size="22" value="${txtFax}"> </td> 
        </tr> 
        <tr> 
            <th rowspan="2"><spring:message code='ezPersonal.t180'/></th> 
            <td colspan="3">
                <input type="text" id="txtZipcode" size="10" value="${txtZipCode}" readonly>
                <a class="imgbtn"><span onClick="zip_find();"><spring:message code='ezPersonal.t181'/></span></a>
            </td> 
        </tr> 
        <tr> 
            <td colspan="3"> <input type="text" id="txtAddress" size="72" value="${txtAddress}"> </td> 
        </tr> 
        <tr>
            <th>
                <spring:message code='ezPersonal.t2003'/>
            </th>
            <td colspan="3">
                <input type="text" id="txtBirth" style="width:80px;text-align:center;" value="${txtBirth}" onkeydown="return checkKey()">
                <img id="TempCalImage" src="/images/ImgIcon/calendar-month.gif" style="margin-bottom:-5px"/>
                &nbsp;&nbsp;

                <c:choose>
                	<c:when test="${birthType eq 'Y'}">
                		<input type="radio" id="RadBirthType1" name="radioGroup"  checked>양력
                		<input type="radio" id="RadBirthType2" name="radioGroup"  >음력
                	</c:when>
                	<c:otherwise>
                		<input type="radio" id="RadBirthType1" name="radioGroup" >양력
                		<input type="radio" id="RadBirthType2" name="radioGroup"  checked>음력
                	</c:otherwise>
                </c:choose>
                
            </td>
        </tr>
        <tr> 
            <th><spring:message code='ezPersonal.t182'/></th> 
            <td colspan="3"><textarea id="txtInfo" style="WIDTH:100%;HEIGHT:80px">${txtInfo}</textarea></td> 
        </tr> 
    </table> 
    <div class="btnposition">
       <a class="imgbtn" onClick="SettingMobile()"><span><spring:message code='ezPersonal.t998'/></span></a>
       <a class="imgbtn" name="Submit" onClick="return btnPhoto_onclick()"><span><spring:message code='ezPersonal.t183'/></span></a>
       <%-- <a runat ="server" class="imgbtn" name="ButtonDelPic" ID="ButtonDelPic" onserverclick="ButtonDelPic_ServerClick"><span><spring:message code='ezPersonal.t184'/></span></a> --%>
       <a class ="imgbtn"  onClick="ButtonDeleteClick()" name="ButtonDelete"  id="ButtonDelete" ><span><spring:message code='ezPersonal.t184'/></span></a>
       <%-- <a runat ="server" class="imgbtn" name="ButtonChange" ID="ButtonChange" onserverclick="ButtonChange_ServerClick"><span><spring:message code='ezPersonal.t34'/></span></a> --%>
       <a class ="imgbtn"  onClick="ButtonChangeClick()" name="ButtonChange"  id="ButtonChange" ><span><spring:message code='ezPersonal.t34'/></span></a>
       <a class="imgbtn" name="Submit2" onClick="window.location.href='/ezPersonal/changePersonInfo.do'"><span><spring:message code='ezPersonal.t13'/></span></a>
    </div>
    <br/>
    <br/>
    <span class="subtxt"><spring:message code='ezPersonal.t185'/></span>-<spring:message code='ezPersonal.t186'/>
    <table class="content">
        <!-- 표준모듈 (2007.02.21) 수정 -->
        <tr>
            <th><spring:message code='ezPersonal.t187'/></th> 
            <td> <input type="password" id="txtOldPassword" size="25" value="" onkeypress="change_press()"> </td> 
        </tr> 
        <tr> 
            <th><spring:message code='ezPersonal.t188'/></th> 
            <td> <input type="password" id="txtNewPassword" size="25" value="" onkeypress="change_press()"> </td> 
        </tr> 
        <tr> 
            <th><spring:message code='ezPersonal.t189'/></th> 
            <td> <input type="password" id="txtNewPasswordConfirm" size="25" value="" onkeypress="change_press()"> </td> 
        </tr>
    </table> 
    <div class="btnposition">
        <a class="imgbtn" onclick="return PassWordChange()"><span><spring:message code='ezPersonal.t34'/></span></a>
        <a class="imgbtn" name="Submit2" onClick="window.location.href='/ezPortal/changePersonInfo.do'"><span><spring:message code='ezPersonal.t13'/></span></a>
    </div>
</form>
<br/>
<br/>
<input id="publicModulus" value="${publicModulus}" type="hidden"/>
<input id="publicExponent" value="${publicExponent}" type="hidden"/>
</body>
</html>