<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t264'/></title>
		<style> 
			.IMG_BTN { behavior:url("/css/include/ImgBtn.htc") }
		</style>
		<meta http-equiv="Content-Type" content="text/html; charset=uft-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/attach_CK.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
			var pDocID = null;
			var OrderCell = "";
			var pAttachFlag	= 0;
			var pAttachSN;
			var pAttachAddFileSize = 0;
			var Resultxml		= createXmlDom();
			var FirstAttach		= createXmlDom();
			var xmlhttp			= createXMLHttpRequest();
			var chkFlag			= false;
			var arr_userinfo = new Array();
			arr_userinfo[0]  = "user";								// 사용자-부서구분
			arr_userinfo[1]  = "${userInfo.id}";              // 사용자ID
			arr_userinfo[2]  = "${userInfo.displayName}";         // 사용자명
			arr_userinfo[3]  = "${userInfo.title}";               // 사용자 직위
			arr_userinfo[4]  = "${userInfo.deptID}";              // 사용자 부서 ID 
			arr_userinfo[5]  = "${userInfo.deptName}";            // 사용자 부서 이름
			arr_userinfo[6]  = "${userInfo.jikChek}";             // 사용자 직책            
			arr_userinfo[8]  = "${userInfo.email}";               // E-Mail Address 
			arr_userinfo[9]  = "";
			arr_userinfo[10] = "${susinAdmin}";                  // 수신 접수담당자
			arr_userinfo[11]  = "${userInfo.displayName1}";		// 사용자명(P)
			arr_userinfo[12]  = "${userInfo.displayName2}";		// 사용자명(S)
			arr_userinfo[13]  = "${userInfo.title1}";				// 사용자 직위(P)
			arr_userinfo[14]  = "${userInfo.title2}";				// 사용자 직위(S)
			arr_userinfo[15]  = "${userInfo.deptName1}";			// 사용자 부서 이름(P)
			arr_userinfo[16]  = "${userInfo.deptName2}";			// 사용자 부서 이름(S)
			
			var pUserID			= arr_userinfo[1];		// 사용자 ID
			var pUserName		= arr_userinfo[2];	    // 사용자 이름
			var pUserJobTitle	= arr_userinfo[3];	// 사용자 직위
			var pDeptID			= arr_userinfo[4];		// 부서ID  
			var pDeptName		= arr_userinfo[5];		// 부서 이름 
			var optExt = "${poptExt}";
			var maxSize = "${maxSize}";
			var isBody = "${isBody}";
			var BodyAttach = "N";
			var AttachDelFlag = false;
			var NonActiveX = "YES";
			var pDraftFlag = "${draftFlag}";
			
			// 문서정보를 가져오는 함수
			function getDocInfo()
			{
			  try {
				if (isBody == "YES")
				{
					document.getElementById("BtnBodyAttach").style.display = "";
				}
				else
				{
					document.getElementById("BtnBodyAttach").style.display  = "none";
				}
			  } catch(e) {
				document.getElementById("BtnBodyAttach").style.display  = "none";
			  }
			}
			
			function CheckHistory(pFlag)
			{
				var i, j;
				var listview = new ListView();
			    listview.LoadFromID("attachList");
			        
				if (pFlag == 0)
				{
					var FirstData = SelectNodes(FirstAttach, "LISTVIEWDATA/ROWS/ROW");
					var pAttachCurSel =listview.GetDataRows();
					
					for (i=0; i<FirstData.length; i++)
					{
						var tempSN = SelectSingleNodeValue(GetChildNodes(FirstData[i])[0], "DATA2");
						var tempFileName = SelectSingleNodeValue(GetChildNodes(FirstData[i])[0], "DATA10");
						var DelFlag = true;
						
						for (j=0; j<pAttachCurSel.length; j++)
						{
						    if (GetAttribute(pAttachCurSel[j], "DATA2") == tempSN && GetAttribute(pAttachCurSel[j], "DATA10") == tempFileName)
							{
								DelFlag = false;
							}
						}
						if (DelFlag)
							UpdateAttachHistory(tempSN, "<spring:message code='ezApprovalG.t266'/>");
					}
				}
				else
				{
					var FirstData = listview.GetDataRows();
					var FileData = SelectNodes(FirstAttach,"LISTVIEWDATA/ROWS/ROW");
					for (i=0; i<FirstData.length; i++)
					{
						
						var tempSN = GetAttribute(FirstData[i], "DATA2");
						var tempFileName = GetAttribute(FirstData[i], "DATA10");
						var AddFlag = true;
						
						for (j=0; j<FileData.length; j++)
						{
			                if (getNodeText(FileData[j].getElementsByTagName("DATA2")[0]) == tempSN && getNodeText(FileData[j].getElementsByTagName("DATA10")[0]) == tempFileName)
							{
								AddFlag = false;
							}
						}
						
						if (AddFlag)
						{
							if (GetAttribute(FirstData[i], "DATA11")== "Y")
								UpdateAttachHistory(tempSN, "<spring:message code='ezApprovalG.t267'/>");
							else
								UpdateAttachHistory(tempSN, "<spring:message code='ezApprovalG.t268'/>");
						}
						else
						{
							if (GetAttribute(FirstData[i], "DATA12")== "EDITED")
								UpdateAttachHistory(tempSN, "<spring:message code='ezApprovalG.t269'/>");
						}
					}
				}
			}
			
			// 파일첨부UI 초기화
			window.onload = function()
			{
				var doc;
				var form;
				getDocInfo();
				pDocID = "${docID}";
				pBoardFileSize  =	parseInt(maxSize);
			    document.getElementById("docid").value =pDocID;
			    document.getElementById("compid").value =  "${userInfo.companyID}";
				Resultxml = InitAttach(pDocID);                     
			
				var filezisearr = new Array();
				for (var i = 0; i < SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW").length; i++) {
				    var fileSize = ReplacText(getNodeText(GetChildNodes(GetChildNodes(SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW")[i])[2])[0]));
				    filezisearr[i] = fileSize;
				    if (fileSize > 1024 * 1024) {
				        fileSize = fileSize / 1024 / 1024;
				        strSize = parseInt(fileSize) + "MB";
				    }
				    else if (fileSize > 1024) {
				        fileSize = fileSize / 1024;
				        strSize = parseInt(fileSize) + "KB";
				    }
				    else
				        strSize = parseInt(fileSize) + "B";
			
				    setNodeText(GetChildNodes(GetChildNodes(SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW")[i])[2])[0], strSize);
				}
			
			    var listview = new ListView();
			    listview.SetID("attachList");
			    listview.SetSelectFlag(false);
			    listview.SetMulSelectable(false);
			    listview.SetRowOnDblClick("ATTACH_onDblclick");
			    listview.DataSource(Resultxml);
			    listview.DataBind("ATTACH");
			    
			    FirstAttach = Resultxml;
				pAttachSN = GetAttachSN(Resultxml);
				var pAttachRow = listview.GetDataRows();
				var pAttachRowLen = pAttachRow.length;
				pAttachSN = pAttachSN + 1;
				
				//btn_AttachDel.disabled = true; 
			}
			
			
			// 파일Size Text처리 함수
			function ReplacText(f_size)
			{
				rep = /'/g;
				f_size = f_size.replace("bytes","")
				return f_size
			}
			
			function attach_Add()
			{
			    document.form.file1.click();
			}
			//  파일첨부 화면 Call function
			var g_progresswin;
			function btn_AttachAdd_onclick() 
			{
			    if(document.form.file1.value != "")
			    {        
			        document.getElementById("btn_AttachDel").disabled = false;
			        document.getElementById("attachsn").value = pAttachSN;            
			        document.getElementById("maxsize").value = pBoardFileSize * 1024 * 1024; 
			        var frm = document.getElementById('form');
			        frm.submit();
			    }
			    else
			    {
			        alert("<spring:message code='ezApprovalG.pjj01'/>");
			    }
			}
			
			function show_progress(fileinfo)
			{
				g_progresswin = window.showModelessDialog("/myoffice/common/show_progress.aspx?fileinfo=" + escape(fileinfo), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken"); 
			}
			
			function status_change(fileinfo)
			{
				try {
					g_progresswin.document.Script.fileinfo_change(fileinfo);
				} catch(e) {}
			}
			 
			//파일 첨부 화면 Close Function
			function AttachCancel_onclick()
			{
				chkFlag = true;
				if (pAttachFlag != "0")
				{
					AttachFileListCancel();
				}
			  
				if (CrossYN() || NonActiveX == "YES") {
				    parent.DivPopUpHidden();
				}
				else {
				    window.returnValue = "cancel";
				    window.close();
				}
			}
			
			// 파일첨부리스트중 파일을 삭제하는 기능
			function btn_AttachDel_onclick()
			{
			    var listview = new ListView();
			    listview.LoadFromID("attachList");
			    
			    var pAttachCurSel =listview.GetSelectedRows();
			    if (pAttachCurSel.length > 0)
				{
					var pcheckID =  GetAttribute(pAttachCurSel[0], "DATA4");
					if (pcheckID.toLowerCase() != pUserID.toLowerCase() && pDraftFlag != "REDRAFT")
					{
						var pAlertContent = "<spring:message code='ezApprovalG.t277'/>" + "<br>" + "<spring:message code='ezApprovalG.t278'/>";
						OpenAlertUI(pAlertContent);
					}
					else
					{
						var pInformationContent = "<spring:message code='ezApprovalG.t279'/>";
					    var Ans = OpenInformationUI(pInformationContent, btn_AttachDel_onclick_Complete);
			
						if(!CrossYN() && Ans)
						{
							var pAttachRow = listview.GetSelectedRows();
							var delfileSize = GetChildNodes(pAttachRow[0])[2].innerHTML;
							var Rtnval = DeleteFileAtServer(pAttachCurSel[0]);
			
							if(Rtnval == "TRUE")
							{
								DelAttachFileAtList(pAttachCurSel);
								DelfileSize(delfileSize);
			
							}
							else
							{
								var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
								OpenAlertUI(pAlertContent);
							}
						}
					}
				}
				else
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t281'/>";
					OpenAlertUI(pAlertContent);
				}
			}
			
			function btn_AttachDel_onclick_Complete(Ans) {
			    DivPopUpHidden();
			    if (Ans) {
			        var listview = new ListView();
			        listview.LoadFromID("attachList");
			        var pAttachCurSel = listview.GetSelectedRows();
			        var pAttachRow = listview.GetSelectedRows();
			        var delfileSize = GetChildNodes(pAttachRow[0])[2].innerHTML;
			        var Rtnval = DeleteFileAtServer(pAttachCurSel[0]);
			
			        if (Rtnval == "TRUE") {
			            DelAttachFileAtList(pAttachCurSel);
			            DelfileSize(delfileSize);
			
			        }
			        else {
			            var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
			            OpenAlertUI(pAlertContent);
			        }
			    }
			}
			
			function DelfileSize(delfileSize){
			}
			
			// 첨부파일리스트중에서 선택된 첨부파일을 내용을 보는 함수
			function btn_AttachOpen_onclick() {
			
			}
			
			// 첨부파일리스트중에서 선택된 첨부파일을 로컬로 복사하는 함수
			function btn_AttachSave_onclick()
			{
			
			}
			
			//   첨부파일 리스트를 DB에 저장하는 function
			function btn_AttachSaveSure_onclick()
			{
			    var listview = new ListView();
			    listview.LoadFromID("attachList");
			    
			    var Listlen =listview.GetDataRows();
				
				chkFlag = true;
				// 리스트에 리스트 목록이 있는 경우 그리고 파일추가 flag > 0 인경우 
				if(Listlen.length == 0)
				{
					CheckHistory(0);
					var RtnVal = AttachRemoveAll();
					if(RtnVal == "FALSE")
					{
						var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
						OpenAlertUI(pAlertContent);
					}
					for (i=0 ; i < pDeleteFile.length ; i++)
					{
						DeleteFileAtServer_true(pDeleteFile[i]);
					}
					if (CrossYN() || NonActiveX == "YES") {
					    parent.setAttachInfo(pDocID, "APR", parent.lstAttachLink);
					    parent.DivPopUpHidden();
					}
					else {
					    window.returnValue = "Clear";
					    window.close();
					}
				}
				else
				{
					CheckHistory(0);
					var Attachxml = APRAttachXMLParsing(ATTACH,pDocID);
					SaveAttachListInfo(Attachxml);
					for (i=0 ; i < pDeleteFile.length ; i++)
					{
						DeleteFileAtServer_true(pDeleteFile[i]);
					}
				}
			}
			   
			
			function AttachFileInfo(pFileName,pFileSize,pFileLocation)
			{
			    if (pFileName == "Error") {
			        var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
			        OpenAlertUI(pAlertContent);
			        btn_AttachAdd.disabled = false;
			    }
			    else {
			        if (CrossYN() || NonActiveX == "YES") {
			            AddAttachFileInfoXmlParsing(pFileName, pFileSize, pFileLocation);
			        }
			        else {
			            Resultxml = AddAttachFileInfoXmlParsing(pFileName, pFileSize, pFileLocation)
			            InsertAttachFileInfo(ATTACH, Resultxml);
			            pAttachFlag = pAttachFlag + 1;
			            pAttachSN = pAttachSN + 1;
			            btn_AttachAdd.disabled = false;
			        }
			    }
			}
			
			// 첨부파일 리스트 클릭시 사용자가 추가한 첨부파일인지 여부 검사
			function ATTACHonSelChange_onclick()
			{
				var pCurSelRow = window.event.result;
				var pAttachUserID = pCurSelRow.cells(0).DATA4;
				if(pAttachUserID.toLowerCase() == pUserID.toLowerCase())
				{
					btn_AttachDel.Enable = "true";
					btn_AttachDel.disabled = false;
				}
				else
				{
				    btn_AttachDel.Enable = "false";
					btn_AttachDel.disabled = true;
				}
			}
			
			window.onbeforeunload = function()
			{
				if(!chkFlag)
					AttachCancel_onclick();
			}
			
			function ATTACH_onDblclick() {
			    var CurSelList = new ListView();
			    CurSelList.LoadFromID("attachList");
			
			    var pCurSelRow = CurSelList.GetSelectedRows();
			    var pAttachUserID = GetAttribute(pCurSelRow[0], "DATA4");
			    if (pAttachUserID.toLowerCase() == pUserID.toLowerCase()) {
			        var retValue = getAttachFilePageNum(GetAttribute(pCurSelRow[0], "DATA9"), GetChildNodes(pCurSelRow[0])[1].innerHTML, ATTACH_onDblclick_Complete);
			        if (retValue != undefined) {
			            if ((!CrossYN() || NonActiveX == "NO") && retValue[0] == "OK") {
			                SetAttribute(pCurSelRow[0], "DATA9", retValue[1]);
			                pCurSelRow[0].childNodes[1].innerHTML = retValue[2];
			                pCurSelRow[0].childNodes[3].innerHTML = retValue[1];
			                SetAttribute(pCurSelRow[0], "DATA12", retValue[2]);
			            }
			        }
			    }
			    else {
			        var pAlertContent = "<spring:message code='ezApprovalG.t282'/>" + "<br>" + "<spring:message code='ezApprovalG.t283'/>";
			        OpenAlertUI(pAlertContent);
			    }
			}
			
			    function ATTACH_onDblclick_Complete(retValue) {
			        DivPopUpHidden();
			        if (retValue[0] == "OK") {
			            var CurSelList = new ListView();
			            CurSelList.LoadFromID("attachList");
			            var pCurSelRow = CurSelList.GetSelectedRows();
			            SetAttribute(pCurSelRow[0], "DATA9", retValue[1]);
			            pCurSelRow[0].childNodes[1].innerHTML = retValue[2];
			            pCurSelRow[0].childNodes[3].innerHTML = retValue[1];
			            SetAttribute(pCurSelRow[0], "DATA12", retValue[2]);
			        }
			    }
			
			function btn_AttachEdit_onclick()
			{
			    try
			    {
			        var AttachList = new ListView();
			        AttachList.LoadFromID("attachList");
			        
			        var pSelectedRow = AttachList.GetSelectedRows();
			
			    	
			        if(pSelectedRow.length != "0")
			        {
			            // 수정(2008.04.03) : 수정버튼 클릭시에도 등록자인지 여부 체크하도록 수정
			            var pAttachUserID = GetAttribute(pSelectedRow[0], "DATA4");//pSelectedRow.item(0).cells(0).DATA4;
				        if(pAttachUserID.toLowerCase() != pUserID.toLowerCase())
				        {
					        var pAlertContent = "<spring:message code='ezApprovalG.t282'/>" + "<br>" + "<spring:message code='ezApprovalG.t283'/>";
					        OpenAlertUI(pAlertContent);
					        return;
				        }
			            
			            var tempAttachFileName = GetAttribute(pSelectedRow[0], "DATA1");
					    var tempAttachFileExt = tempAttachFileName.substring(tempAttachFileName.length - 3, tempAttachFileName.length);
					    var tempAttachFileFlag = false;
					    if (tempAttachFileExt == "xml" || tempAttachFileExt == "htm" || tempAttachFileExt == "log")
						    tempAttachFileFlag = true;
			    		
					    if (tempAttachFileFlag)
					    {
						    var parameter = GetAttribute(pSelectedRow[0], "DATA1");
						    var url = "EditAttach.aspx";
						    var feature = "status:no;dialogWidth:720px;dialogHeight:630px;help:no;scroll:no";	
				            feature =  feature + GetShowModalPosition(720, 630);
						    var RtnVal = window.showModalDialog(url,parameter,feature);
			    		
						    if (RtnVal == "OK")
						    {
						        tempAttachSN = GetAttribute(pSelectedRow[0], "DATA2");
			                    EditAttachFileInfoXmlParsing(GetChildNodes(pSelectedRow[0])[1].innerHTML, GetChildNodes(pSelectedRow[0])[2].innerHTML, GetAttribute(pSelectedRow[0], "DATA1"), tempAttachSN);
						    }			
					    }
					    else
					    {    
						    var parameter = GetAttribute(pSelectedRow[0], "DATA1");
						    var url = "EditFileAttach.aspx";
						    var feature = "status:no;dialogWidth:333px;dialogHeight:205px;help:no;scroll:no";	
				            feature =  feature + GetShowModalPosition(333, 195);
						    var RtnVal = window.showModalDialog(url,parameter,feature);
			    		
						    if (RtnVal == "OK")
						    {
							    tempAttachSN = GetAttribute(pSelectedRow[0], "DATA2");
			                    EditAttachFileInfoXmlParsing(GetChildNodes(pSelectedRow[0])[1].innerHTML, GetChildNodes(pSelectedRow[0])[2].innerHTML, GetAttribute(pSelectedRow[0], "DATA1"), tempAttachSN);
						    }		
					    }
				    }
				    else
				    {
					    var pAlertContent = "<spring:message code='ezApprovalG.t284'/>";
					    OpenAlertUI(pAlertContent);
				    }
			    }
			    catch(ErrMsg)
			    {
			        alert("btn_AttachEdit_onclick : " + ErrMsg.description);  
			    }
			}
			
			function btn_AttachBodyAdd_onclick()
			{
				BodyAttach = "Y";
				var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
				ezUtil.UseUTF8 = true;
				var file = ezUtil.OpenLoadDlgMulti("", "");
			
				if (!file)
					return;
			
				g_fileList = file.split(";");
				var fileSize = 0;
				for (var i=0; i<g_fileList.length-1; i++)
				{
				    ezUtil.UseUTF8 = true;
					if (ezUtil.GetFileSize(g_fileList[i]) == 0)
					{
						alert("<spring:message code='ezApprovalG.t270'/>");
						return;
					}
					ezUtil.UseUTF8 = true;
					fileSize += ezUtil.GetFileSize(g_fileList[i]); 			
				}
			
				ezUtil = null;
				if (fileSize > pBoardFileSize * 1024 * 1024)
				{
					alert("<spring:message code='ezApprovalG.t271'/>" + pBoardFileSize + "MB" + "<spring:message code='ezApprovalG.t272'/>");
					return;
				}
			
				var fileNamelist = "";
				var fileName = "";
				show_progress(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\")+1) + "<spring:message code='ezApprovalG.t273'/>" + 1 + "/" + (g_fileList.length-1));
			
				for (var i=0; i<g_fileList.length-1; i++)
				{
					try {
						if (i > 0)
							status_change(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1) + "<spring:message code='ezApprovalG.t273'/>" + (i+1) + "/" + (g_fileList.length-1));
			
						oPoster.Clear();
						oPoster.UseUTF8 = true;
						oPoster.AddFormData("mode", "send");
						oPoster.AddFormData("UploadID", pDocID);
						oPoster.AddFormData("UploadSN", pAttachSN);
						oPoster.AddFormData("UploadMaxFileSize", pBoardFileSize);
						oPoster.AddFormData("UploadAddFileSize", pAttachAddFileSize);
						oPoster.AddFile("UploadFile", g_fileList[i], 0);
						oPoster.Host = "${serverName}";
						oPoster.PostURL = "/myoffice/ezApprovalG_Cross/ezAPRATTACH/aspx/AttachFile.aspx";
			            if (window.location.protocol == "http:")
			                oPoster.Protocol = 0;
			            else
			                oPoster.Protocol = 1;
						oPoster.Post();
			
						if (oPoster.Response.substr(0, 2) != "OK")
						{
							try {
								g_progresswin.close();
							} catch(e) {}
			
							alert(g_fileList[i] + " <spring:message code='ezApprovalG.t274'/>");
							return;
						}
						else
						{
							var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
							ezUtil.UseUTF8 = true;
							fileSize = ezUtil.GetFileSize(g_fileList[i]) + "bytes"; 			
							AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1), fileSize, oPoster.Response.substr(3, oPoster.Response.length-3));
						}
					} 
					catch (e) 
					{
						try {
							g_progresswin.close();
						} catch(e) {}
			
						if (e.number == -2147352567)
							alert("<spring:message code='ezApprovalG.t275'/>");
						else 
							alert(g_fileList[i] + " <spring:message code='ezApprovalG.t276'/>" + "\n\n" + e.number + " - " + e.description);
						return;
					}	
				}
				try {
					g_progresswin.close();
				} catch(e) {}
			}
			
			var fileSize = 0;
			function returnvalue(result, filename, filelocation, filesize)
			{
			    if(result == "true")
			    {    
			        if (filesize == 0)
				    {
					    alert("<spring:message code='ezApprovalG.t270'/>");
					    return;
			        }
			        AttachFileInfo(filename,filesize,filelocation, "")
			    }
			    else if(result == "overflow")
			    {
			        alert("<spring:message code='ezApprovalG.t271'/>" + pBoardFileSize + "MB"+ "<spring:message code='ezApprovalG.t272'/>");
			    }
			    else if (result == "denied") {
			        alert(strLang1026);
			    }
			    else
			    {
			        alert(filename + "<spring:message code='ezApprovalG.pjj07'/>" + "\n\n" + result);
			    }
			}
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t264'/></h1>
		<table>
		  <tr>
		    <td style="text-align:center;"><div class="listview" style="width:515px;">
		        <div id="ATTACH" STYLE="overflow:auto;WIDTH:510px;HEIGHT:130px;margin:1px 1px 1px 1px;"></div>					
		      </div></td>
		    <th style="display:none;width:75px;text-align:center;">
		      <input id="btn_AttachEdit" type="button" name="btn_AttachEdit" onClick="return btn_AttachEdit_onclick()" value="<spring:message code='ezApprovalG.t269'/>" class="imginput" style="margin-top:3px;display:none;" /><br />
		      <span id="BtnBodyAttach" style="display:none">
		      <input id="btn_AttachBodyAdd" type=button name="btn_AttachBodyAdd" onClick="return btn_AttachBodyAdd_onclick()" value="<spring:message code='ezApprovalG.t285'/>">
		      </span> </th>
		  </tr>
		</table>
		<iframe name="ifrm" src="about:blank" style="display:none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezApprovalG/upload.do" target="ifrm" >
		    <div class="btnposition">       
		        <a class="file-btn" style="vertical-align:top">
		          <input id="file1" name="file1" type="file" onchange="btn_AttachAdd_onclick()" style="margin-left:100px;">
		          <span for="file" id="btn_AttachAdd"><spring:message code='ezApprovalG.t268'/></span>
		        </a>
		        <a class="imgbtn"><span id="btn_AttachDel" onClick="return btn_AttachDel_onclick()"><spring:message code='ezApprovalG.t266'/></span></a>
		        <a class="imgbtn"><span id="btn_AttachSaveSure" onClick="return btn_AttachSaveSure_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
		        <a class="imgbtn"><span id="AttachCancel" onClick="return AttachCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>
		    </div>
		
		<input type="hidden" name="compid" id="compid" />
		<input type="hidden" name="docid" id="docid" />
		<input type="hidden" name="attachsn" id="attachsn" />
		<input type="hidden" name="maxsize" id="maxsize" />
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
