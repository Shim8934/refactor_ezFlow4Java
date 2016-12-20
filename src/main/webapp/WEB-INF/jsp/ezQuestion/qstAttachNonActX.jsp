<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title><spring:message code='ezQuestion.t154' /></title>
			<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css" />
			<script type="text/javascript" src="<spring:message code='ezQuestion.e1' />"></script>
			<script type="text/javascript" src="/js/mouseeffect.js"></script>
			<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
			<script type="text/javascript">
				var pID = "${idName}";
			    var pType = "";
			    var pInitFlag = "";
			    var pAttachInfo = null;
			    var pDelAttachList = "";
			    var pAttach = "${attachInfo}";
				var pAttachType = "${attachType}";
			    var pAttachMode = "${attachMode}";
			    var pAttachModeIndex = "${attachModeIndex}";
			    var fileup = false;
			    window.onload = function () {
			        document.getElementById("tr_TypeValueE").style.display = "";
			        document.getElementById("tr_AddList").style.display = "";

			        pType = "1";
			        if (CrossYN()) {
			            if (pAttach != "") {
			                pAttachInfo = pAttach;
			                SetInfoList();
			            }
			        } else {
			            pDelAttachList = dialogArguments["m_DelAttach"];
			            if (dialogArguments["m_AttachInfo"] != null) {
			                pAttachInfo = dialogArguments["m_AttachInfo"];

			                SetInfoList();
			            }
			        }
			    }
			    function fun_QuesCancel() {
			        window.self.close();
			    }
			    function TypeDetermination() {
			        pType = document.all("sel_Type").options[document.all("sel_Type").selectedIndex].value;
			        if (pType == "3" || pType == "4" || pType == "6" || pType == "7") {
			            tr_TypeValueM.style.display = "";
			            tr_TypeValueE.style.display = "none";
			            tr_AddList.style.display = "";
			        } else {
			            tr_TypeValueM.style.display = "none";
			            tr_TypeValueE.style.display = "";
			            tr_AddList.style.display = "";
			        }
			    }
			    function AttachFile_Onclick() {
			        if (pType == "3" || pType == "4" || pType == "6" || pType == "7") {
			            if (document.all("txt_TitleM").value == "") {
			                alert("<spring:message code='ezQuestion.t155' />");
						    document.all.txt_TitleM.focus();
						    return;
						}
			        } else {
			            if (document.all("txt_TitleE").value == "") {
			                alert("<spring:message code='ezQuestion.t155' />");
						    document.all.txt_TitleE.focus();
						    return;
						}
			        }
			        if (pType == "1") {
			            document.all("cmuds").accept = "image/*";
			        } else if (pType == "2") {
			            document.all("cmuds").accept = "audio/*";
			        } else if (pType == "5") {
			            document.all("cmuds").accept = "video/*";
			        } else {
			            document.all("cmuds").accept = "";
			        }
			        document.all("cmuds").click();
			    }
			    function fun_AddAns() {
			        var pTitle = "";
			        var pPath = "";
			        selType = pType;
			        if (pType == "3" || pType == "4" || pType == "6" || pType == "7") {
			            if (document.all("txt_TitleM").value == "") {
			                alert("<spring:message code='ezQuestion.t155' />");
			                document.all.txt_TitleM.focus();
			                return;
			            }
			            if (document.all("txt_URL").value == "") {
			                alert("<spring:message code='ezQuestion.t158' />");
			                return;
			            }
			            if (CheckChar(document.all("txt_TitleM").value)) {
			                alert("<spring:message code='ezQuestion.t159' />");
			                return;
			            }
			            pTitle = document.all("txt_TitleM").value;
			            pPath = document.all("txt_URL").value;
			        } else {
			            if (document.all("txt_TitleE").value == "") {
			                alert("<spring:message code='ezQuestion.t155' />");
			                document.all.txt_TitleE.focus();
			                return;
			            }
			            if (!fileup) {
			            	//strLang5가 ezQuestion.js에 없음
			                alert("strLang5");
			                return;
			            }
			            if (document.all("AttachPath").value == "") {
			                alert("<spring:message code='ezQuestion.t160' />");
			                return;
			            }
			            if (CheckChar(document.all("txt_TitleE").value)) {
			                alert("<spring:message code='ezQuestion.t159' />");
			                return;
			            }
			            pTitle = document.all("txt_TitleE").value;
			            pPath = document.all("AttachPath").value;
			        }
			        lastindex = document.all("input_Value").length;
			        var newoption = new Option(pTitle, selType + ";" + pTitle + ";" + pPath, true);
			        if (lastindex > 0) {
			            document.all("input_Value").options[lastindex] = newoption;
			        } else {
			            document.all("input_Value").options[0] = newoption;
			        }
			        document.all("txt_TitleM").value = "";
			        document.all("txt_URL").value = "";
			        document.all("txt_TitleE").value = "";
			        document.all("txt_AttachPath").value = "";
			        document.all("AttachPath").value = "";
			        Attach_Upload.innerHTML = Attach_Upload.innerHTML;
			    }
			    function fun_AnsDelete() {
			        var idx = document.all("input_Value").selectedIndex;
			        if (idx > -1) {
			            var arrInfo = document.all("input_Value").options[idx].value.split(";");
			            if (arrInfo[0] == "1" || arrInfo[0] == "2") {
			                if (CrossYN()) {
			                    document.Delete_Upload.QstType_delFile.value = arrInfo[0];
			                    document.Delete_Upload.QstPath_delFile.value = arrInfo[2];
			                    document.Delete_Upload.QstIndex_delFile.value = idx;
			                    document.Delete_Upload.submit();
			                } else {
			                    document.all("input_Value").options[idx].removeNode(true);
			                }
			            } else {
			                if (CrossYN())
			                    DeleteAttach_Sel(idx);
			            }
			        } else {
			            alert("<spring:message code='ezQuestion.t161' />");
			         }
			     }
			    function DeleteAttach_Sel(idx) {
			        document.all("input_Value").options[idx] = null;
			    }
			    
			    function SetInfoList() {
			        if (CrossYN()) {
			            var xmlDom = createXmlDom();
			            xmlDom = loadXMLString(pAttachInfo);
			            var lastindex = SelectNodes(xmlDom, "ATTACH/ROW").length;
			            for (var count = 0; count < lastindex; count++) {
			                var selType = SelectSingleNodeValue(SelectNodes(xmlDom, "ATTACH/ROW")[count], "TYPE");
			                var pTitle = SelectSingleNodeValue(SelectNodes(xmlDom, "ATTACH/ROW")[count], "ATTACHTITLE");
			                var pPath = SelectSingleNodeValue(SelectNodes(xmlDom, "ATTACH/ROW")[count], "HREF");
			                var newoption = new Option(pTitle, selType + ";" + pTitle + ";" + pPath, true);
			                document.all("input_Value").options[count] = newoption;
			            }
			        } else {
			            var lastindex = pAttachInfo["type"].length;

			            for (var count = 0; count < lastindex; count++) {
			                var selType = pAttachInfo["type"][count];
			                var pTitle = pAttachInfo["attachTitle"][count];
			                var pPath = pAttachInfo["href"][count];

			                var newoption = new Option(pTitle, selType + ";" + pTitle + ";" + pPath, true);
			                document.all("input_Value").options[count] = newoption;
			            }
			        }
			    }
			    function Save_Onclick() {
			        if (document.all("input_Value").length > 0) {
			            if (CrossYN()) {
			                window.opener.AttachComplete_NonIE(pAttachType, pAttachMode, GetInfoList(), pAttachModeIndex);
			            } else {
			                dialogArguments["m_Return"] = "OK";
			                dialogArguments["m_DelAttach"] = pDelAttachList;
			                dialogArguments["m_AttachInfo"] = GetInfoList_IE();
			            }
			        } else {
			            if (CrossYN()) {
			                window.opener.AttachComplete_NonIE(pAttachType, pAttachMode, "", pAttachModeIndex);
			            } else {
			                dialogArguments["m_Return"] = "OK";
			                dialogArguments["m_DelAttach"] = pDelAttachList;
			                dialogArguments["m_AttachInfo"] = null;
			            }
			        }
			        window.close();
			    }
			    function GetInfoList_IE() {
			        var pValue = "";
			        var pInfoList = "";
			        var m_AttachInfo = null;

			        m_AttachInfo = { "type": new Array(), "attachTitle": new Array(), "href": new Array() };

			        var lastindex = document.all("input_Value").length;

			        for (var count = 0; count < lastindex; count++) {
			            pValue = document.all("input_Value").options[count].value;
			            pInfoList = pValue.split(";");

			            m_AttachInfo["type"][count] = pInfoList[0];
			            m_AttachInfo["attachTitle"][count] = pInfoList[1];
			            m_AttachInfo["href"][count] = pInfoList[2];
			        }
			        return m_AttachInfo;
			    }
			    function GetInfoList() {
			        var pValue = "";
			        var pInfoList = "";
			        var m_AttachInfo = null;
			        var lastindex = document.all("input_Value").length;
			        if (lastindex > 0) {
			            m_AttachInfo = "<ATTACH>";
			            for (var count = 0; count < lastindex; count++) {
			                pValue = document.all("input_Value").options[count].value;
			                pInfoList = pValue.split(";");
			                m_AttachInfo += "<ROW>";
			                m_AttachInfo += "<TYPE>" + pInfoList[0] + "</TYPE>";
			                m_AttachInfo += "<ATTACHTITLE>" + pInfoList[1] + "</ATTACHTITLE>";
			                m_AttachInfo += "<HREF>" + pInfoList[2] + "</HREF>";
			                m_AttachInfo += "</ROW>";
			            }
			            m_AttachInfo += "</ATTACH>";
			        }
			        return m_AttachInfo;
			    }
			    function CheckChar(pVal) {
			        if (pVal.indexOf(";") > -1 || pVal.indexOf("|") > -1 || pVal.indexOf("^") > -1) {
			            return true;
			        }
			        return false;
			    }
			    
			    function TempFileOpen_onClick(thisObj) {
			        Attach_Upload.QstType.value = pType;

			        var imgPath = "";
			        if (CrossYN()) {
			        	var input = document.getElementById("cmuds");
			            document.all("txt_AttachPath").value = input.value;
			        } else {
			        	thisObj.select();
				        var selectionRange = document.selection.createRangeCollection()[0];
			            imgPath = selectionRange.text.toString();
			            var input = document.getElementById("cmuds");
				        document.all("txt_AttachPath").value = imgPath;
				        
			        }
			        fileup = false;
			        
			        if (CrossYN()) {
			        	Attach_Upload.submit();			        	
			        } else {
			        	Attach_Upload.submit();
			        /*     if (document.Attach_Upload.cmuds.value != "") {
			            	var fd = new FormData();
							for (var i = 0; i < document.getElementById("Attach_Upload").cmuds.files.length; i++) {
			            		fd.append("cmuds", document.getElementById("Attach_Upload").cmuds.files[i]);
			            	}
			            	fd.append("QstType", pType);
			            	xhr = new XMLHttpRequest();
			            	xhr.addEventListener("load", UploadFilePath, false);
			            	xhr.open("POST", "/ezQuestion/attachFileNonActX.do?mode=IE");
			            	xhr.send(fd);
						} */
					}
			    }

			    function UploadFilePath(FilePath) {
			        if(CrossYN()) {
			            document.all.AttachPath.value = FilePath;
			        } else {
			        	document.all.AttachPath.value = FilePath;
			            //document.all.AttachPath.value = FilePath.target.responseText
			        }
			        fileup = true;
			    }
			    
		</script>
	</head>
	<body class="popup">
		<form id="Form1" method="post" action="">
	        <div id="menu">
	            <ul><li><span onclick="javascript:Save_Onclick();"><spring:message code='ezQuestion.t163' /></span></li></ul>
	        </div>
	        <div id="close">
	            <ul><li><span onclick="javascript:fun_QuesCancel();"><spring:message code='ezQuestion.t88' /></span></li></ul>
	        </div>
	        <script type="text/javascript">
	            selToggleList(document.getElementById("menu"), "ul", "li", "0");
	            selToggleList(document.getElementById("close"), "ul", "li", "0");
	        </script>
	        <table class="content" style="margin-bottom:4px">
	            <tr>
	                <th><spring:message code='ezQuestion.t164' /></th>
	                <td>
	                    <select id="sel_Type" onChange="TypeDetermination()">
	                        <option value="1" selected="selected"><spring:message code='ezQuestion.t165' /></option>
	                        <option value="6"><spring:message code='ezQuestion.t166' /></option>
	                        <option value="2"><spring:message code='ezQuestion.t167' /></option>
	                        <option value="7"><spring:message code='ezQuestion.t168' /></option>
	                        <option value="5"><spring:message code='ezQuestion.t169' /></option>
	                        <option value="3"><spring:message code='ezQuestion.t170' /></option>
	                        <option value="4">URL<spring:message code='ezQuestion.t171' /></option>
	                    </select>
	                </td>
	            </tr>
	        </table>
	        <div style="display:none" id="tr_TypeValueE">
	            <table class="content">
	                <tr>
	                    <th><spring:message code='ezQuestion.t172' /></th>
	                    <td colspan="2"><input type="text" size="9" maxlength="32" style="WIDTH:100%" name="txt_TitleE" id="txt_TitleE"></td>
	                </tr>
	                <tr>
	                    <th><spring:message code='ezQuestion.t154' /></th>
	                    <td class="pos1">
	                        <input type="text" size="9" maxlength="50" style="WIDTH:100%" name="txt_AttachPath" id="txt_AttachPath" readonly="readonly" />
	                        <input type="text" name="AttachPath" style="display:none" />        
	                    </td>
	                    <td class="pos2">
	                        <a class="imgbtn"><span onclick="AttachFile_Onclick()"><spring:message code='ezQuestion.t173' /></span></a>
	                    </td>
	                </tr>
	            </table>
	        </div>
	        <div style="display:none" id="tr_TypeValueM">
	            <table class="content">
	                <tr>
	                    <th>URL <spring:message code='ezQuestion.t53' /></th>
	                    <td><input type="text" size="9" maxlength="50" style="WIDTH:100%" name="txt_TitleM" id="txt_TitleM" />        </td>
	                </tr>
	                <tr>
	                    <th>URL</th>
	                    <td>
	                        <span>http://</span><input type="text" size="9" maxlength="500" style="WIDTH:90%" name="txt_URL" id="txt_URL">
	                        <br />
	                        <span class="point">* <spring:message code='ezQuestion.t174' /></span>
	                        <br />
	                        <font color="#6e6e6e">(<spring:message code='ezQuestion.t175' /></font>
	                    </td>
	                </tr>
	            </table>
	        </div>
	        <div style="display:inline" id="tr_AddList">
	            <table width="100%" class="content" style="margin-top:4px">
	                <tr>
	                    <td align="center">
	                        <a class="imgbtn"><span onclick="javascript:fun_AddAns();"><spring:message code='ezQuestion.t176' /></span></a>
	                        <a class="imgbtn"><span onclick="javascript:fun_AnsDelete();"><spring:message code='ezQuestion.t177' /></span></a>
	                    </td>
	                </tr>
	                <tr>
	                    <td>
	                        <select name="input_Value" id="input_Value" size="4"  style="WIDTH:100%;HEIGHT:100px"></select>
	                    </td>
	                </tr>
	            </table>
	        </div>
	    </form>
	    <iframe name="ifrm" src="about:blank" style="display:none"></iframe>
	    <form method="post" action="/ezQuestion/attachFileNonActX.do" name="Attach_Upload" id="Attach_Upload" target="ifrm" enctype="multipart/form-data" style="width:1px; height:1px;">
	        <input type="file" name="cmuds" id="cmuds" accept="image/*" onchange="javascript:TempFileOpen_onClick(this);" style="width:1px; height:1px;" />
	        <input type="text" name="QstType" style="display:none" />
	    </form>
	    <form method="post" action="/ezQuestion/attachFileDeleteNonActX.do" name="Delete_Upload" id="Delete_Upload" target="ifrm" enctype="multipart/form-data" style="display:none">
	        <input type="text" name="QstIndex_delFile" />
	        <input type="text" name="QstType_delFile" />
	        <input type="text" name="QstPath_delFile" />
		</form>
	</body>
</html>	
	