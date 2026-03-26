<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%> --%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
 
	<style>
	   	.mainlist tr td:first-child {
	   		padding-left:15px;
	   	}
	   	/* 조직도 #SelectDeptNM(부서명[사원수]) 부분 */
	   	#spn_deptName {
	   		text-overflow: ellipsis;
	   		white-space: nowrap;
	   		overflow: hidden;
	   		display: inline-block;
	   	}
	   	#countInfo {
	   		overflow: hidden;
	   		display: inline-block;
	   	}
	   	.pt-10
	   	{
	   		padding-top:10px
	   	}
	   	.pt-5
	   	{ 
	   	
	   	} 
	   	th {
			   
			  text-align: center; bgcolor:"#00ccff";
			}
	   	.button2:hover 
	   	{
			  color:#ccffcc; 
		}
		.button1:hover 
	   	{
			  color:#ff0000; 
			  background-color: #00ccff;
		} 
		.button2
	   	{
			  //background-color: #00ccff;
			  background:none;
			  color: black;
			  border: none;
			  color: white;
			  padding: 5px 10px;
			  text-align: center;
			  text-decoration: none;
			  display: inline-block;
			  font-size: 20px; 
			  margin: 1px 2px;
			  cursor: pointer;
			  width: 100px;
		} 
	.bg-color-gray
	{
		background-color:#f2f2f2;
	}
	.bg_popup
	{
		background:url('/images/p_icon.jpg') no-repeat left top #f5f5f5;
		padding:5px 10px 10px;
		margin:0;
	}
	   </style>
	<title>Delete  Form</title>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script> 
	<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript"> 

var pDocID = '<c:out value="${docID}"/>';
var pCompanyId = '<c:out value="${companyId}"/>';
	
	window.onload = function () 
	{
		//translate();
		var xmlhttp = createXMLHttpRequest();
		var xmlpara = createXmlDom();
		var objNode;
		
		createNodeInsert(xmlpara, objNode, "PARAMETER");
		createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
		console.log(xmlpara);
		xmlhttp.open("POST","/admin/ezApprovalG/getDelDocInfo.do",false);
		xmlhttp.send(xmlpara);
	    
		var xmlDom = createXmlDom();
	    xmlDom = xmlhttp.responseXML;
	    
	   // console.log(xmlDom);
		    
	    if(SelectNodes(xmlDom, "DATA/DELFLAG")[0].childNodes.length != 0)	
	    //if(xmlDom.selectSingleNode("DATA/DELFLAG").text != "")
	    {
	    	libtn_clear.style.display = "";
	    }else
	    	{
	    	libtn_clear.style.display = "none";
	    	}
	}

function DelDocInfoSave_onclick(delflag)
{
    var pContent = document.getElementById("txt_DelDocInfo").value.trim();
    if(!pContent && delflag == "Y")
    {
    	alert("<spring:message code='ezBoard.t999067'/>");
        return;
    }
    
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "COMPANYID", pCompanyId);
	createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "DELFLAG", delflag);
	createNodeAndInsertText(xmlpara, objNode, "DELINFO", pContent);
	console.log(xmlpara)
	
	
	xmlhttp.open("POST","/admin/ezApprovalG/setDelDocInfo.do",false);
	xmlhttp.send(xmlpara);
	
	xmlresult = xmlhttp.responseXML;
	
	if( xmlresult.xml != "" && delflag == "Y") 
	{
		//console.log(xmlresult);
		//if( xmlresult.documentElement.text == "TRUE" )
		if(SelectNodes(xmlresult, "RESULT")[0].childNodes[0].nodeValue == "TRUE")
			alert("<spring:message code='ezPersonal.tt16'/>"); 
		else
			alert("<spring:message code='ezApprovalG.t805'/> : " + SelectNodes(xmlresult, "RESULT")[0].childNodes[0].nodeValue);
	}
	
	else
	{
		if(SelectNodes(xmlresult, "RESULT")[0].childNodes[0].nodeValue == "TRUE")
			alert("<spring:message code='ezPersonal.t41'/>");
	}
	
	window.opener.popupCallback({ flag: true, p_lang: '', mode: '' }); //Call callback function 
	window.close();
}
    
function close_onclick()
{ 
	window.opener.popupCallback({ flag: true, p_lang: '', mode: '' }); //Call callback function 
	window.close();
}
function translate()
{
		console.log('runs translate!')
		$("#btn_save").text('Save');
		$("#btn_clear").text('Clear');
		 
	}
</script>
</head>
<body class="popup">
	    <h1><spring:message code='ezApprovalG.kms0002'/></h1>
	    <div id="close">
            <ul><li><span onclick="return close_onclick()"></span></li></ul>
        </div>
          
	    	<textarea id="txt_DelDocInfo"name="txt_DelDocInfo" style="width:477px; height:225px; resize: none;"></textarea>
	     
	    
	    <div class="btnposition btnpositionNew">
		     <a class="imgbtn" id="libtn_save">    <span id="btn_save"  onClick="return DelDocInfoSave_onclick('Y')"><spring:message code='ezApprovalG.t1767'/></span></a>
		     <a class="imgbtn" id="libtn_clear"> <span id="btn_clear" onClick="return DelDocInfoSave_onclick('N')"><spring:message code='ezPersonal.t33'/></span></a> 
	    </div>
	    
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>