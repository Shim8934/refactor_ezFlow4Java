<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t24" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezResource.e1' />" ></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js" ></script>
		<script type="text/javascript" src="/js/ezResource/admin/gwBoard_Post_RegBoardRightMain.js" ></script>
		<script type="text/javascript" id="clientEventHandlersJS" >
			g_BrdID = "${brdID}";
			g_BrdNm = "${brdNm}";
			g_UserID = "${userInfo.id}";

			var L_BrdGb = "${brdGb}";
			var pCompanyID = "${companyID}";

			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
		    };

		    window.onload = function () {
			    if (acllist.length > 0){		
				}
			    return;
		    }

		function optAclLvl_Click(objthis){
			if (acllist.selectedIndex < 0) return;
			
			var indexV			= acllist.selectedIndex;
			var strMember_nam;// = CrossYN() ? acllist.options[indexV].getAttribute("Member_nam") : acllist.options[indexV].Member_nam;
			if (CrossYN()) {
			    strMember_nam = acllist.options[indexV].getAttribute("Member_nam");
			} else {
			    strMember_nam = acllist.options[indexV].getAttribute("Member_nam");
			    if (strMember_nam == undefined) {
			        strMember_nam = acllist.options[indexV].Member_nam;
			    }
			}

			var AccLvl = objthis.value ;

			if (AccLvl == "1"){
				strVal = strMember_nam + " - (<spring:message code="ezResource.t104" />";
				
			    try {
			        acllist.options[indexV].setAttribute("Access_lvl", AccLvl);
			        acllist.options[indexV].Access_lvl = AccLvl;
			    } catch (e) {}
			    
				acllist.options[indexV].text = strVal;

			}else{
				strVal = strMember_nam + " - (<spring:message code="ezResource.t105" />";

			    try {
			        acllist.options[indexV].setAttribute("Access_lvl", AccLvl);
			        acllist.options[indexV].Access_lvl = AccLvl;
			    } catch (e) {}
			    
				acllist.options[indexV].text = strVal;
			}
		}


		function selAclList_Change(objthis) {
			var indexV			= objthis.selectedIndex;
			var strAclLvl;// = CrossYN() ? objthis.options[indexV].getAttribute("Access_lvl") : objthis.options[indexV].Access_lvl;

			if (CrossYN()) {
			    strAclLvl = objthis.options[indexV].getAttribute("Access_lvl");
			} else {
			    strAclLvl = objthis.options[indexV].getAttribute("Access_lvl");
			    if (strAclLvl == undefined) {
			        strAclLvl = objthis.options[indexV].Access_lvl;
			    }
			}

			if ( strAclLvl == "1" ) {	
				brd_mng1.checked = true;
			} else {
				brd_mng2.checked = true;
			}
		}
		</script>
	</head>
	<body class="mainbody">	
		<h1><spring:message code="ezResource.t24" /></h1>
		<table class="content">
  			<tr>
    			<th> <spring:message code="ezResource.t44" /></th>
    			<td>${brdNm} <input type="hidden" id="UPPER_NM" name="UPPER_NM" value="${brdNm}"></td>
  			</tr>
		</table>
		<br>
		<table class="box" style="width:100%">
  			<tr>
    			<td><select id="acllist" name="acllist" style="width: 830px; height: 120px" size="10" language="javascript" onChange="selAclList_Change(this);"> ${strOptions}</select></td>
    			<td style="width:80px; text-align:center; vertical-align:middle">
        			<a class="imgbtn"><span onClick="return cmdAdd_onclick()"><spring:message code="ezResource.t110" /></span></a><br>
        			<a class="imgbtn"><span onClick="return cmdDel_onclick()"><spring:message code="ezResource.t65" /></span></a>
        		</td>
    			<td style="padding:2px; vertical-align:top;width:49%;">
    				<table class="popuplist" style="width:100%">
        				<tr>
          					<th> <spring:message code="ezResource.t111" /></th>
        				</tr>
        				<tr>
          					<td style="height:90px">
          						<input type="radio" id="brd_mng1" name="brd_mng" value="1" onClick="optAclLvl_Click(this);" ${optAdmLvl}> <spring:message code="ezResource.t112" /><br>
            					<input type="radio" id="brd_mng2" name="brd_mng" value="2" onClick="optAclLvl_Click(this);" ${optUserLvl}> <spring:message code="ezResource.t107" />
            				</td>
        				</tr>
      				</table>
      			</td>
  			</tr>
		</table>
		<br>
		<div class="txt">(<spring:message code="ezResource.t113" /></div>
		<div class="btnposition">
     		<a class="imgbtn"><span onclick="cmdOk_onclick()" ><spring:message code="ezResource.t114" /></span></a>
		</div>
		<form name="brds">
  			<input type="hidden" id="proc" name="proc" value="ACL">
		</form>
	</body>
</html>