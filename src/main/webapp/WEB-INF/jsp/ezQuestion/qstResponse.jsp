<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezQuestion.t315" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
		<script type="text/javascript">
		    window.onload = function (){
		        tableXML();
		    }
		    
		    function MM_reloadPage(init){
				if(init==true) with (navigator){
					if ((appName=="Netscape")&&(parseInt(appVersion)==4)){
						document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; 
					}
				}else if(innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) {
					location.reload();
				}
			}
		    
			MM_reloadPage(true);
			
			function tableXML() {
				var xmlDoc = loadXMLString('${xmlResult}');
				var DataNode = SelectSingleNode(xmlDoc, "DATA");
				var RowNode = SelectSingleNode(DataNode,"ROW");
				var nodes = GetChildNodes(DataNode);
				var tableXml="";

				for(i=0;nodes.length>i; i++){
					tableXml += "<tr>";
					tableXml += "<th>";
					tableXml += SelectSingleNodeValue(nodes[i], 'QST');
					tableXml += "</th>";
					tableXml += "</tr>";
					tableXml += SelectSingleNodeValue(nodes[i], 'SUBROW');
					
					var itemNode = SelectSingleNode(nodes[i], 'ITEM');
					var answerType = SelectSingleNodeValue(nodes[i], 'ANSWERTYPE');
					
					if (answerType == '5') {
						var itemNodes = GetChildNodes(itemNode);
						
						tableXml += SelectSingleNodeValue(itemNode, 'TAG');
					} else {
						if(itemNode != null){
							var itemNodes = GetChildNodes(itemNode);
							
							for(j=0; itemNodes.length>j; j++){
								tableXml += "<tr>";
								tableXml += "<td style='padding:3px 10px; word-wrap:break-word;'>";
								tableXml += SelectSingleNodeValue(itemNode, 'TAG'+(j+1));
								tableXml += "</td>";
								tableXml += "</tr>";
							}
						}
					}
				}
				
				$("#xmlTable").html(tableXml);
			}
		</script>
		<script type="text/javascript">
			var receve= "<c:out value='${receve}'/>";
			var brdID = "<c:out value='${qstUserPermissionVO.brdID}'/>";
			var itemNo = "<c:out value='${qstUserPermissionVO.itemNo}'/>";
			var btnSaveChk = false;
		    function fun_Save(){
		        if(form_check() == false)
		            return;
		        if(btnSaveChk == false){
		            document.frmResponse.action = "/ezQuestion/qstResponseOk.do";
		            document.frmResponse.submit();
		            btnSaveChk = true;
		        }else{
		            alert('<spring:message code="ezQuestion.t112" />');
				}
		    }
		    
		    function trim(parm_str){
		        return rtrim(ltrim(parm_str));
		    }
		    
		    function ltrim(parm_str){
		        str_temp = parm_str;
		        while(str_temp.length != 0){
		            if(str_temp.substring(0, 1) == " "){
		                str_temp = str_temp.substring(1, str_temp.length);
		            }else{
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }
		    
		    function rtrim(parm_str){
		        str_temp = parm_str;
		        while(str_temp.length != 0){
		            int_last_blnk_pos = str_temp.lastIndexOf(" ");
		            if((str_temp.length - 1) == int_last_blnk_pos){
		                str_temp = str_temp.substring(0, str_temp.length - 1);
		            }else{
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }
	
			function form_check(){
		        var cur_date = new Date();
	            //var start_date = "<c:out value='${qstUserPollItemVO.pollStartDate}'/>";
	            var start_date = "${pollStartDate}";

	            if(start_date > cur_date){
	                alert("<spring:message code='ezQuestion.t316' />" + start_date + "<spring:message code='ezQuestion.t317' />");
	                return false;
	            }
	            var iQuestonCount = 0;
	            document.frmResponse.hidEleCnt.value = document.frmResponse.length - 2;

	            var elements = document.frmResponse;
	            var inputTag = elements.getElementsByTagName("INPUT");
	            var checkTag = new Array();
	            var textAreaTag = elements.getElementsByTagName("TEXTAREA");
	            var elementName, beforeName;
	            var flag = false;
	            for(var i = 0; i < textAreaTag.length; i++){
	                if(textAreaTag[i].value == ""){
	                    alert("<spring:message code='ezQuestion.t319' />");
	                    return false;
	                    break;
	                }
	            }
	            for(var i = 0; i < inputTag.length; i++){
	                if(inputTag[i].getAttribute("type").toLowerCase() == "radio"){
	                    elementName = inputTag[i].name;
	                    if(elementName != beforeName && i != 0){
	                        for (var j = 0; j < document.getElementsByName(elementName).length; j++){
	                            if(document.getElementsByName(elementName)[j].checked)
	                                flag = true;
	                        }
	                    }else if(elementName == beforeName)
	                        flag = true;
	                    if(!flag){
	                        alert("<spring:message code='ezQuestion.t319' />");
	                        return false;
	                        break;
	                    }
	                    beforeName = elementName;
	                    flag = false;
	                }else if(inputTag[i].getAttribute("type") == "checkbox"){
	                    checkTag.push(inputTag[i]);
	                }
	            }
	            for(var i = 0 ; i < checkTag.length; i++){
	                var chkflag = false;
	                while(1){
	                    var before_lst = checkTag[i].name;
	                    var before_arrylst = before_lst.split("_");
	                    var after_lst;
	                    if (checkTag[i + 1] == undefined)
	                        after_lst = null;
	                    else
	                        after_lst = checkTag[i + 1].name;
	                    var after_arrylst = new Array();
	                    if(checkTag[i + 1] == undefined)
	                        after_arrylst[0] = null;
	                    else
	                        after_arrylst = after_lst.split("_");
	                    if (before_arrylst[0] == after_arrylst[0]){
	                        if(checkTag[i].checked){
	                            checkTag[i].value = "1";
	                            chkflag = true;
	                        }
	                        i++;
	                    }else{
	                        if(checkTag[i].checked){
	                            checkTag[i].value = "1";
	                            chkflag = true;
	                        }
	                        break;
	                    }
	                }
	                if(chkflag != true){
	                    alert("<spring:message code='ezQuestion.t319' />");
	                    return false;
	                }
                    if(checkTag[i].checked)
                        checkTag[i].value = "1";
                }
                var inputTag = elements.getElementsByTagName("INPUT");
                var tableRadioBtn = new Array();
                for(var i = 0; i < inputTag.length; i++){
                    if(inputTag[i].getAttribute("type") == "radio"){
                        tableRadioBtn.push(inputTag[i]);
                    }
                }
                var result = "";
                for(var i = 0; i < tableRadioBtn.length; i++){
                    if(tableRadioBtn[i].checked){
                        result += tableRadioBtn[i].value + ";";
                    }
                }
                document.frmResponse.tableAnswer.value = result;
            }
		
			function fun_Delete(){
		    	var result;
				result = confirm("<spring:message code='ezQuestion.t321' />");
	
				if(result){
				    document.location.href = "/ezQuestion/qstDeleteItem.do?brdID=" + brdID + "&itemNo=" + itemNo;
				}
		    }
			
		    /* function Setting_Change(vdata){
		        var feature = GetOpenPosition(380, 340);
		        window.open("changeSetting.do?brdID=" + brdID + "&itemNo=" + itemNo, "setting", "width=380px,height=340px,toolbar=no,location=no,help=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no" + feature);
			} */
			
			function menuQst_List(){
			    var szUrl = "/ezQuestion/qstList.do?"+"${receve}"+"&brdPostterm='' ";
			    window.location.href = szUrl;
			}
	
			function seqResponse(flag, objChk, objQuesNo){
		        var txtAnswer = eval(objQuesNo);
		        var ChkAnswer = eval(objChk);
		        
		        if(ChkAnswer[flag].checked){
		            txtAnswer.value = txtAnswer.value + ChkAnswer[flag].value + ";";
		        }else{
		            var currTxt = txtAnswer.value;
		            var currValue = ChkAnswer[flag].value + ";";
		            var rv = currTxt.indexOf(currValue);

		            if(rv != -1){
		                var strReplace = currTxt.replace(currValue, "");
		                txtAnswer.value = strReplace;
		            }
		        }
			}
			
			function file_open(pType, pBrdID, pItemNo, pQstNo, pAnsNo, pAttID){
			    var pUrl = "/ezQuestion/qstAttachView.do?&type=" + pType + "&boardID=" + pBrdID + "&itemNo=" + pItemNo + "&qstNo=" + pQstNo + "&ansNo=" + pAnsNo + "&attID=" + pAttID;
	
			    if(pType == "1") {
			    	openwindow(pUrl, "", "800px", "600px", "1", "1", "800");
			    } else if(pType == "3") {
			    	openwindow(pUrl, "", "420px", "410px", "0", "0", "500");
			    } else {
			        openwindow(pUrl, "", "415px", "120px", "0", "0", "500");
			    }
			}
			
			function openwindow(wfileLocation, wName, wWeigth, wHeigth, wScrollbars, wResizable, wVal) {
			    try{
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;
			        var top = (heigth - parseInt(wVal)) / 2;
			        var left = (width - parseInt(wVal)) / 2;
	
			        window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=" + wScrollbars + ",resizable=" + wResizable + ",height=" + wHeigth + ",width=" + wWeigth + ",top=" + top + ",left = " + left);
			    }catch (e){
			    }
			}
			function openUserInfo(strEmail) {
			    var compemail = strEmail
			    compemail = compemail.toUpperCase();
			    var s_pos = compemail.indexOf("@")
			    var parameter = compemail.slice(0, s_pos);  //보낸 사람 ID
			    var heigth = window.screen.availHeight;
			    var width = window.screen.availWidth;
			    var left = (width - 500) / 2;
			    var top = (heigth - 400) / 2;
			    window.open("/ezCommon/showPersonInfo.do?id=" + parameter, "", "height=460px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		    }
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
		    <td><c:out value="${qstUserPollItemVO.title}"/></td>
		  </tr>
		  <tr>
		    <th><spring:message code="ezQuestion.t265" /></th>
		    <td><a style="cursor:pointer" onclick='openUserInfo("<c:out value="${qstUserPollItemVO.userEmail}"/>")' ><c:out value="${qstUserPollItemVO.userNm}"/> (<c:out value="${qstUserPollItemVO.userEmail}"/> )</a></td>
		  </tr>
		  <tr>
		    <th><spring:message code="ezQuestion.t216" /></th>
		    <td><c:out value="${pollStartDate}"/> ~ <c:out value="${pollEndDate}"/> </td>
		  </tr>
		  <tr>
		    <th><spring:message code="ezQuestion.t231" /></th>
		    <td>
		    	<c:choose>
		    		<c:when test='${qstUserPollItemVO.postTerm=="0"}'>
		    			<spring:message code="ezQuestion.t322" />
		    		</c:when>
		    		<c:otherwise>
		    			<c:out value="${publicDate}"/> <spring:message code="ezQuestion.t323" /><c:out value="${qstUserPollItemVO.postTerm}"/> <spring:message code="ezQuestion.t324" />
		    		</c:otherwise>
		    	</c:choose>
			</td>
		  </tr>
		  <tr>
		    <th><spring:message code="ezQuestion.t325" /></th>
		    <td><c:out value="${qstUserPollItemVO.responseCnt}"/> <spring:message code="ezQuestion.t326" /><c:out value="${qstUserPollItemVO.readCnt}"/> ] </td>
		  </tr>
		  <tr>
		    <th><spring:message code="ezQuestion.t327" /></th>
		    <td><c:out value="${qstUserPollItemVO.content}"/> </td>
		  </tr>
		</table>
		
		<form name="frmResponse" method="post" onSubmit="fun_Save()">
			<input type=hidden value=<c:out value="${receve}"/> name="receve">
			<table id="xmlTable" class="poll" style="margin-top:10px">
			</table>
			<input type="hidden" name="hidEleCnt">
		  	<input type=hidden value=<c:out value="${qstUserPermissionVO.brdID}"/> name=brdID >
			<input type=hidden value=<c:out value="${qstUserPermissionVO.itemNo}"/> name=itemNo>
			<input type="hidden" name="tableAnswer" />
		</form>
		
		<div class="btnposition">
			<a class="imgbtn"> <span onClick="javascript:fun_Save();return false;"> <spring:message code="ezQuestion.t37" /> </span> </a>
			<a class="imgbtn"> <span onClick="javascript:menuQst_List();return false;"> <spring:message code="ezQuestion.t38" /> </span> </a>
		</div>
	</body>
</html>