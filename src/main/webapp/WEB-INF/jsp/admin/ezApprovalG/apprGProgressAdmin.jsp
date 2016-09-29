<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Component Download</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<script type="text/javascript">
			var i_totalDownload;
			var i_currentDownload = 0;
			var i_totalSize = 0;
			var i_downSize = 0;
			/* var i_icd = new ActiveXObject("EzIcd2.ezLauncher"); */
			
			function StartOn()
			{
				var nvista = 0;
				nvista = i_icd.nCheckVista;
				
				if(nvista==0)
				{	
					i_icd.SetDocumentDisp( window.document );
					// 일반 OS의 경우
					i_icd.OpenProgress();
					i_icd.xmlURL = "http://" + document.location.hostname + ":" + location.port + "/admin/ezApprovalG/componentListTransfer.do?admin=Y";
					i_icd.CheckVersion();
					i_totalSize = i_icd.nTotalKByte;
					i_totalDownload = i_icd.nNeedDownload;
					
					if ( i_totalDownload ) {	
						i_icd.UpdateComponent();
					}
					else {
						i_icd.CloseProgress();
						i_icd = null;
						window.close();		
					}
				}
				else if(nvista==6)
				{
					// VISTA의 경우
					i_icd.SetDocumentDispVista( window.document );
					i_icd.OpenProgressVista();
					i_icd.xmlURLVista = "http://" + document.location.hostname + ":" + location.port + "/admin/ezApprovalG/componentListTransfer.do?admin=Y";
					//체크버전비스타에서 제대로 동작 X
					i_icd.CheckVersionVista();
					i_totalSize = i_icd.nTotalKByteVista;
					i_totalDownload = i_icd.nNeedDownloadVista;
				  		  
					if ( i_totalDownload ) {
						i_icd.UpdateComponentVista();
					}
					else {
						i_icd.CloseProgress();
						i_icd = null;
						window.close();
					}
				}
				else{
					// 실행이 취소되거나 값을 잘못 받은 경우.
					alert("<spring:message code = 'ezApprovalG.lhj05' />");
					i_icd.CloseProgress();
					i_icd = null;
					window.close();
				}
			}
			
			function icd_completeAllComponent()
			{
				parent.document.Script.finish_download();
			}
		</script>
	</head>

	<body id=theBody bgcolor="#dedede" leftmargin="0" topmargin="0">
		<OBJECT id="i_icd" style="DISPLAY: none" codeBase="/files/ezIcd2.cab#version=1,0,0,13" data="data:application/x-oleobject;base64,GvFdR8IrqUGKl+mJ4CPlFwADAADYEwAA2BMAAA=="classid="CLSID:9E1C0C21-48B8-455a-9005-48C8D78B7900" VIEWASTEXT></OBJECT>
		<table width="390" border="0" cellspacing="0" cellpadding="3" vspace="0" hspace="0">
  			<tr> 
    			<td colspan="2"> 
    			</td>
  			</tr>
  			<tr> 
  			</tr>
		</table>
	</body>
</html>
