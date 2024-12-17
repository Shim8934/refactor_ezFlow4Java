<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t24" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/admin/gwBoard_Post_RegBoardRightMain.js')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" id="clientEventHandlersJS" >
			g_BrdID = "<c:out value='${brdID}'/>";
			g_BrdNm = "<c:out value='${brdNm}'/>";
			g_UserID = "<c:out value='${userInfo.id}'/>";
			g_UserLang = "<c:out value='${userInfo.getLang()}'/>";

			var L_BrdGb = "<c:out value='${brdGb}'/>";
			var pCompanyID = "<c:out value='${companyID}'/>";

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
				    strMember_nam2 = acllist.options[indexV].getAttribute("Member_nam2");
				} else {
				    strMember_nam = acllist.options[indexV].getAttribute("Member_nam");
				    strMember_nam2 = acllist.options[indexV].getAttribute("Member_nam2");

				    if (strMember_nam == undefined) {
				        strMember_nam = acllist.options[indexV].Member_nam;
				    }
				}

				var AccLvl = objthis.value ;

				if (AccLvl == "1"){
					if (g_UserLang == '1') {
                        strVal = strMember_nam + " - (<spring:message code="ezResource.t104" />";
                    } else {
                        strVal = strMember_nam2 + " - (<spring:message code="ezResource.t104" />";
                    }
					
				    try {
				        acllist.options[indexV].setAttribute("Access_lvl", AccLvl);
				        acllist.options[indexV].Access_lvl = AccLvl;
				    } catch (e) {}
				    
				    acllist.options[indexV].innerHTML = strVal;
	
				}else{
					if (g_UserLang == '1') {
                        strVal = strMember_nam + " - (<spring:message code="ezResource.t105" />";
                    } else {
                        strVal = strMember_nam2 + " - (<spring:message code="ezResource.t105" />";
                    }
	
				    try {
				        acllist.options[indexV].setAttribute("Access_lvl", AccLvl);
				        acllist.options[indexV].Access_lvl = AccLvl;
				    } catch (e) {}
				    
				    acllist.options[indexV].innerHTML = strVal;
				}
			}
			
			function optDeptCopy_Click(objthis) {
				var indexV	= acllist.selectedIndex;
				var copyYN = objthis.value ;
				
				if(copyYN == "1") {
					try {
				        acllist.options[indexV].setAttribute("sda_yn", "Y");
				        acllist.options[indexV].sda_yn = "Y";
				    } catch (e) {}
				}
				else {
				 	 try {
				        acllist.options[indexV].setAttribute("sda_yn", "N");
				        acllist.options[indexV].sda_yn = "N";
				    } catch (e) {}
				}
				
			}
	
			function selAclList_Change(objthis) {
				var indexV			= objthis.selectedIndex;
				var strAclLvl;// = CrossYN() ? objthis.options[indexV].getAttribute("Access_lvl") : objthis.options[indexV].Access_lvl;
				var deptYn;
				var deptAclLvl;
	
				if (CrossYN()) {
				    strAclLvl = objthis.options[indexV].getAttribute("Access_lvl");
				    deptYn = objthis.options[indexV].getAttribute("dept_yn");
				    deptAclLvl = objthis.options[indexV].getAttribute("sda_yn");
				} else {
				    strAclLvl = objthis.options[indexV].getAttribute("Access_lvl");
				    deptYn = objthis.options[indexV].getAttribute("dept_yn");
				    deptAclLvl = objthis.options[indexV].getAttribute("sda_yn");
				    if (strAclLvl == undefined) {
				        strAclLvl = objthis.options[indexV].Access_lvl;
				    }
				    if(deptYn == undefined) {
				    	deptYn = objthis.options[indexV].dept_yn;
				    }
				    if(deptAclLvl == undefined) {
				    	deptAclLvl = objthis.options[indexV].sda_yn;
				    }
				}
	
				if ( strAclLvl == "1" ) {	
					brd_mng1.checked = true;
				} else {
					brd_mng2.checked = true;
				}
				
				if(deptYn == "D") {
					dept_copy1.disabled = false;
					dept_copy2.disabled = false;
					
					if(deptAclLvl == "Y") {
						dept_copy1.checked = true;
					}
					else {
						dept_copy2.checked = true;
					}
				}
				else {
					dept_copy1.disabled = true;
					dept_copy2.disabled = true;
				}
			}
		</script>
	</head>
	<body class="mainbody">	
		<h1><spring:message code="ezResource.t24" /></h1>
		<div style="max-width:800px;">
		<table class="content">
  			<tr>
    			<th> <spring:message code="ezResource.t44" /></th>
    			<td><c:out value='${brdNm}' /> <input type="hidden" id="UPPER_NM" name="UPPER_NM" value="<c:out value='${brdNm}' />"></td>
  			</tr>
		</table>
		<br>
		<div id="mainmenu">
			<ul>
				<li><span onClick="return cmdAdd_onclick()"><spring:message code="ezResource.t110" /></span></li>
				<li><span onClick="return cmdDel_onclick()"><spring:message code="ezResource.t65" /></span></li>
			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<div class="txt"><spring:message code="ezResource.t113" /></div>
		<div>
			<table class="box" style="width:100%">
				<tr>
					<th style="font-weight: normal;"><spring:message code="ezBoard.t606" /></th>
					<td style="height:300px;"colspan=3>
						<select id="acllist" name="acllist" style="width: 99%; height: 98.5%; background:none; margin-left:3px; overflow-y: auto; overflow-x: auto; padding-right:0px;" size="10" onChange="selAclList_Change(this);">
							${strOptions}
						</select>
					</td>
				</tr>
				<tr>
     				<th style="font-weight: normal; width: 30px;"><spring:message code="ezResource.t111" /></th>
					<td style="border-bottom: 1px solid #d2d2d2;border-top: 1px solid #d2d2d2;">
   						<table class="popuplist" style="width:100%">
        				<tr>
          					<td style="border:0px;">
          						<input type="radio" id="brd_mng1" name="brd_mng" value="1" style="vertical-align: middle; margin-bottom:5px;" onClick="optAclLvl_Click(this);" ${optAdmLvl}> <spring:message code="ezResource.t112" />
            					<input type="radio" id="brd_mng2" name="brd_mng" value="2" style="vertical-align: middle; margin-bottom:5px;" onClick="optAclLvl_Click(this);" ${optUserLvl}> <spring:message code="ezResource.t107" />
            				</td>
        				</tr>
      					</table>
       				</td>
       				<th style="font-weight: normal; width: 30px;"><spring:message code='ezBoard.t999025' /></th>
					<td style="border-bottom: 1px solid #d2d2d2;border-top: 1px solid #d2d2d2;">
   						<table class="popuplist" style="width:100%">
        				<tr>
          					<td style="border:0px;">
          						<input type="radio" id="dept_copy1" name="dept_copy" value="1" style="vertical-align: middle; margin-bottom:5px;" onClick="optDeptCopy_Click(this);" disabled checked> <spring:message code='ezBoard.t95' />
            					<input type="radio" id="dept_copy2" name="dept_copy" value="2" style="vertical-align: middle; margin-bottom:5px;" onClick="optDeptCopy_Click(this);" disabled> <spring:message code='ezBoard.t96' />
            				</td>
        				</tr>
      					</table>
       				</td>
				</tr>
			</table>
		</div>
		<%-- <table class="box" style="width:100%">
  			<tr>
    			<td style="padding:2px;"><select id="acllist" name="acllist" style="width: 830px; height: 120px; background:none;" size="10" language="javascript" onChange="selAclList_Change(this);"> ${strOptions}</select></td>
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
		</table> --%>
		<div class="btnpositionJsp">
     		<a class="imgbtn"><span onclick="cmdOk_onclick()" ><spring:message code="ezResource.t114" /></span></a>
		</div>
		<form name="brds">
  			<input type="hidden" id="proc" name="proc" value="ACL">
		</form>
		</div>
	</body>
</html>