<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezQuestion.t315" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script language="JavaScript">
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    }
		    function MM_reloadPage(init) {
			if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
				document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
			else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
			}
			MM_reloadPage(true);
		</script>
		<script type="text/javascript">
			var tempReceve="${receve}";
			var receve =tempReceve.replace(/amp;/g,'');
		
			var btnSaveChk = false;
		    function fun_Save() {
		        //if(
		        //tableAnswer
		        if (form_check() == false)
		            return;
	
		        if (btnSaveChk == false) {
		            document.frmResponse.action = "Qst_Response_OK.aspx";
		            document.frmResponse.submit();
		            btnSaveChk = true;
		        }
		        else {
		            alert("<spring:message code="ezQuestion.t112" />");
				}
		    }
		    <%-- function view_Result() {
		        window.location.href = "result.aspx?brd_id=" + '<%=v_brd_id%>' + "&item_no=" + '<%=v_item_no%>';
			} --%>
	
			<%-- function form_check() {
			    var cur_date = '<%=cur_date%>'
			    var start_date = '<%=poll_startdate%>'
	
			    if (start_date > cur_date) {
			        alert("<spring:message code="ezQuestion.t316" />" + start_date + "  <spring:message code="ezQuestion.t317" />");
				    return false;
				}
	
		        var iQuestonCount = 0;
		        document.frmResponse.hidEleCnt.value = document.frmResponse.length - 2;
		        for (i = 0 ; i <= document.frmResponse.length - 2; i++) {
		            if (String(document.frmResponse.item(i).name.substring(0, 3)) == "txt") {
		                iQuestonCount++;
		            }
		            else if (document.frmResponse.item(i).name.substring(0, 3) == "chk") {
		                iQuestonCount++;
		                var chkflag = false;
		                while (1) {
		                    var before_lst = document.frmResponse.item(i).name;
		                    var before_arrylst = before_lst.split("_");
		                    var after_lst = document.frmResponse.item(i + 1).name;
		                    var after_arrylst = after_lst.split("_");
		                    if (before_arrylst[0] == after_arrylst[0]) {
		                        if (document.frmResponse.item(i).checked) {
		                            document.frmResponse.item(i).value = "1";
		                            chkflag = true;
		                        }
		                        i++;
		                    }
		                    else {
		                        if (document.frmResponse.item(i).checked) {
		                            document.frmResponse.item(i).value = "1";
		                            chkflag = true;
		                        }
		                        break;
		                    }
		                }
		                if (chkflag != true) {
		                    alert('<spring:message code="ezQuestion.t319" />');
						    frmResponse.item(i).focus();
						    return false;
						}
		                if (document.frmResponse.item(i).checked)
		                    document.frmResponse.item(i).value = "1";
		            }
		            else if (document.frmResponse.item(i).name.substring(0, 3) == "rdo") {
		                iQuestonCount++;
		                var rdoflag = false;
		                while (1) {
		                    var before = document.frmResponse.item(i).name;
		                    var after = document.frmResponse.item(i + 1).name;
		                    if (before == after) {
		                        if (document.frmResponse.item(i).checked) {
		                            rdoflag = true;
		                        }
		                        i++;
		                    }
		                    else {
		                        if (document.frmResponse.item(i).checked) {
		                            rdoflag = true;
		                        }
		                        break;
		                    }
		                }
		                if (rdoflag != true) {
		                    alert('<spring:message code="ezQuestion.t319" />');
						    frmResponse.item(i).focus();
						    return false;
						}
		            }
		            else if (document.frmResponse.item(i).name.substring(0, 3) == "sel") {
		                iQuestonCount++;
		                if (frmResponse.item(i).text == "") {
		                    alert('<spring:message code="ezQuestion.t319" />');
							    frmResponse.item(i).focus();
							    return false;
							}
		                }
		}
		    if (iQuestonCount == 0) {
		        menuQst_List();
		        return false;
		    }
		} --%>
	<%-- 	function fun_Delete() {
		    var result;
	
		    result = confirm('<spring:message code="ezQuestion.t321" />');
	
				if (result) {
				    document.location.href = "Qst_Delete_Item.asp?brd_id=" + '<%=v_brd_id%>' + "&item_no=" + '<%=v_item_no%>'
				}
		    } --%>
		    <%-- function Setting_Change(vdata) {
		        var feature = GetOpenPosition(380, 340);
		        window.open("change_setting.aspx?brd_id=" + '<%=v_brd_id%>' + "&item_no=" + '<%=v_item_no%>', "setting", "width=380px,height=340px,toolbar=no,location=no,help=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no" + feature);
			} --%>
			function menuQst_List() {
<%-- 			    var szUrl = "/ezQuestion/qstList.do?"+receve+"&brd_nm=<%=v_brd_nm%>&brd_postterm=<%=v_brddefaultpostterm%>" --%>
			    window.location.href = szUrl;
			}
	
			function seqResponse(flag, objChk, objQuesNo) {
			    try {
			        var txtAnswer = eval(objQuesNo);
			        var ChkAnswer = eval(objChk);
			        if (ChkAnswer[flag].checked) {
			            txtAnswer.value = txtAnswer.value + ChkAnswer[flag].value + ";";
			        }
			        else {
			            var currTxt = txtAnswer.value;
			            var currValue = ChkAnswer[flag].value + ";";
			            var rv = currTxt.indexOf(currValue);
	
			            if (rv != -1) {
			                var strReplace = currTxt.replace(currValue, "");
			                txtAnswer.value = strReplace;
			            }
			        }
			    } catch (e) {
			    }
			}
			function file_open(pType, pBrdID, pItemID, pQstNo, pAnsNo, pAttID) {
			    var pUrl = "Qst_Attach_View.aspx?&type=" + pType + "&BOARDID=" + pBrdID + "&ITEMID=" + pItemID + "&QSTNO=" + pQstNo + "&ANSNO=" + pAnsNo + "&ATTID=" + pAttID;
	
			    if (pType == "1")
			        openwindow(pUrl, "", "800px", "600px", "1", "1", "800");
			    else if (pType == "3")
			        openwindow(pUrl, "", "420px", "410px", "0", "0", "500");
			    else
			        openwindow(pUrl, "", "415px", "120px", "0", "0", "500");
			}
			function openwindow(wfileLocation, wName, wWeigth, wHeigth, wScrollbars, wResizable, wVal) {
			    try {
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;
			        var top = (heigth - parseInt(wVal)) / 2;
			        var left = (width - parseInt(wVal)) / 2;
	
			        window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=" + wScrollbars + ",resizable=" + wResizable + ",height=" + wHeigth + ",width=" + wWeigth + ",top=" + top + ",left = " + left);
			    }
			    catch (e) { }
			}
			<%-- function openUserInfo(strEmail) {
			    var compemail = strEmail
			    compemail = compemail.toUpperCase();
			    var sDomain = "<%= Request.ServerVariables["Server_Name"].ToString() %>"
			    sDomain = sDomain.toUpperCase();
	
			    var s_pos = compemail.indexOf("@")
			    var parameter = compemail.slice(0, s_pos);  //보낸 사람 ID
			    var heigth = window.screen.availHeight;
			    var width = window.screen.availWidth;
			    var left = (width - 500) / 2;
			    var top = (heigth - 400) / 2;
			    window.open("/myoffice/common/ShowPersonInfo.aspx?id=" + parameter, "", "height=460px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		    } --%>
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezQuestion.t300" /></h1>
		
		<div id="mainmenu">
		  <ul>
		    <li><span onclick="menuQst_List()"><spring:message code="ezQuestion.t130" /></span></li>
		  </ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table class="content">
		  <tr>
		    <th><spring:message code="ezQuestion.t255" /></th>
		    <td>${userPollItemVO.title}</td>
		  </tr>
		  <tr>
		    <th><spring:message code="ezQuestion.t265" /></th>
		    <td><a style="cursor:pointer" onclick='openUserInfo("${userPollItemVO.userEmail}")' >${userPollItemVO.userNm} (${userPollItemVO.userEmail} )</a></td>
		  </tr>
		  <tr>
		    <th><spring:message code="ezQuestion.t216" /></th>
		    <td>${userPollItemVO.pollStartDate} ~ ${userPollItemVO.pollEndDate} </td>
		  </tr>
		  <tr>
		    <th><spring:message code="ezQuestion.t231" /></th>
		    <td>
		    	<c:choose>
		    		<c:when test='${userPollItemVO.postTerm=="0"}'>
		    			<spring:message code="ezQuestion.t322" />
		    		</c:when>
		    		<c:otherwise>
		    			${userPollItemVO.pollEndDate} <spring:message code="ezQuestion.t323" />${userPollItemVO.postTerm} <spring:message code="ezQuestion.t324" />
		    		</c:otherwise>
		    	</c:choose>
			</td>
		  </tr>
		  <tr>
		    <th><spring:message code="ezQuestion.t325" /></th>
		    <td>${userPermissionVO.responseCnt} <spring:message code="ezQuestion.t326" />${userPollItemVO.readCnt} ] </td>
		  </tr>
		  <tr>
		    <th><spring:message code="ezQuestion.t327" /></th>
		    <td>${userPollItemVO.content} </td>
		  </tr>
		</table>
		<%-- <form name="frmResponse" method="post" onSubmit="fun_Save()">
		  <input type=hidden value="${receve}" name="Receve_str">
		  <table class="poll" style="margin-top:10px" >
		    <% 
			XmlNodeList nodeList = xmlMainDom.DocumentElement.SelectNodes("//ROW");
		
			foreach(XmlNode myNode in nodeList)
			{
				Response.Write("<tr>\n");
				Response.Write("<th>");
				Response.Write(myNode.SelectSingleNode("QST").InnerText);
				Response.Write("</td>\n");
				Response.Write("</tr>\n");
				Response.Write(myNode.SelectSingleNode("SUBROW").InnerText);
				
				XmlNodeList subNodeList = myNode.SelectNodes("ITEM");
		
				foreach(XmlNode mySubNode in subNodeList)
				{
					int j = 0;
					for(int i=0; i<	int.Parse(mySubNode.Attributes["count"].Value); i++)
					{
						j++;
						Response.Write("<tr>\n");									
						Response.Write("<td style='padding:3px 10px'>");
						Response.Write(mySubNode.SelectSingleNode("TAG" + j.ToString()).InnerText);
						Response.Write("</td>\n");
						Response.Write("</tr>\n");
					}
				}
				
			}
			xmlMainDom = null;
		%>
		    <asp:repeater id="reList" runat="server">
		      <ItemTemplate>
		        <tr>
		          <td style="padding:3px 10px"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("QST").InnerText %></td>
		        </tr>
		        <%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("SUBROW").InnerText %>
		        <tr>
		          <td style="padding:3px 10px"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("TAG").InnerText %></td>
		        </tr>
		      </ItemTemplate>
		    </asp:repeater>
		  </table>
		  <input type="hidden" name="hidEleCnt">
		  <input type=hidden value="<%=v_brd_id%>" name=brd_id >
		  <input type=hidden value="<%=v_item_no%>" name=item_no>
		  <input type="hidden" name="tableAnswer" />
		</form> --%>
		<div class="btnposition"><a class="imgbtn"><span onClick="javascript:fun_Save();return false;"><spring:message code="ezQuestion.t37" /></span></a><a class="imgbtn"><span onClick="javascript:menuQst_List();return false;"><spring:message code="ezQuestion.t38" /></span></a></div>
	</body>
</html>