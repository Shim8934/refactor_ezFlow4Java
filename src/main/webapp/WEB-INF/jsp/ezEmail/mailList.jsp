<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>mail_list</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="/css/default_kr.css"> 
	<link rel="stylesheet" type="text/css" href="/css/previewmail.css">
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezEmail/lang/ezEmail_ko.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/ezEmail/js/NewMailList.js"></script>
	<script type="text/javascript" src="/js/ezEmail/js/Newemail.js"></script>
	<script type="text/javascript" src="/js/ezEmail/js_cross/string_component_utf8.js"></script>
	<script type="text/javascript" src="/js/Common.js"></script>
	<script type="text/javascript" src="/js/NameControl.js"></script>		
</head>
<body style="overflow:hidden;" id="theBody" class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);"  onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	<h1>${folderName}<span id="mailBoxInfo"></span>
      <span style="float:right;font-weight:normal;color:black;">
          <input name="searchCheck" id="Radio1" type="radio" value="SUBJECT" checked style="margin:0px;padding:0px;width:13px;height:13px;"><spring:message code="ezEmail.t98" />
          <c:if test="${isSentItems == true}">
          <input name="searchCheck" id="Radio2" type="radio" value="RECEIVE" style="margin:0px;padding:0px;width:13px;height:13px;"><spring:message code="ezEmail.t66" />
          </c:if>
          <c:if test="${isSentItems != true}">
		  <input name="searchCheck" id="Radio3" type="radio" value="FROM" style="margin:0px;padding:0px;width:13px;height:13px;"><spring:message code="ezEmail.t161" />
		  </c:if>
		  &nbsp;
		  <input name="keyword" class="Mail_Input" style="width:150px;ime-mode: active;" onKeyPress="onkeydown_start_search(event);"  onmousedown="keyword_Clear();" /> 
          <a href="#"><img src="../../images/sub/bsearch.gif" border="0" align="absmiddle" onClick="start_search()"></a>
      </span>
    </h1>	
        <div id="mainmenu">
        <ul id="tb_Parent">
          <li><span onClick="new_mail_onclick()"><spring:message code="ezEmail.t510" /></span></li>
          <li id="reply"><span onClick="reply_mail_onclick()"><spring:message code="ezEmail.t511" /></span></li>
          <li><span onClick="all_reply_mail_onclick()"><spring:message code="ezEmail.t512" /></span></li>
          <li><span onClick="transmission_mail_onclick()"><spring:message code="ezEmail.t513" /></span></li>
          <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
          <li><span onClick="Read_StatusChange('R');" ><spring:message code="ezEmail.t99000006" /></span></li>
          <li><span onClick="Read_StatusChange('U');"><spring:message code="ezEmail.t99000007" /></span></li>
          <li onClick="mail_export();" id="EmailPCSave"><span><spring:message code="ezEmail.t378" /></span></li>
          <li onClick="toggle_flag();" ><span class="img_Newbtn"><spring:message code="ezEmail.t550" /></span></li>
          <li><span onClick="move_mail_onclick()"><spring:message code="ezEmail.t482" /></span></li>
          <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
          <li><span onClick="deleteWork(false)"><spring:message code="ezEmail.t95" /></span></li>
          <li id="deleteone"><span onClick="deleteWork(true)"><spring:message code="ezEmail.t156" /></span></li>
          <li id="deleteall" style="display:none"><span onClick="delAllFile()"><spring:message code="ezEmail.t514" /></span></li>
          <li onClick="MailListRefresh()"><span class="img_Newbtn"><spring:message code="ezEmail.t515" /></span></li>
		  <li id="receivecheck" style="display:none" ><span onClick="receiveCheck_onClick()"><spring:message code="ezEmail.t516" />/<spring:message code="ezEmail.t549" /></span></li>
          <li id="btnReject" style="display:none"><span onClick="reject_onclick()"><spring:message code="ezEmail.t270" /></span></li>
		  <li id="right"><spring:message code="ezEmail.t99000034" /><img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" /> <!-- 레이어나왔을경우btn_arrow_up.gif --></li>
          </ul>
        </div>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
        <div id="layer_popup" style="width:250px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
          <div class="popupwrap1">
            <div class="popupwrap2">
            <table style="width:100%;border-spacing:0px;border-collapse:collapse;border:none;"  class="list_element">
	          <colgroup>
              <col style="width:80px;">
	            <col>
              </colgroup>
              <tr>
                <th><spring:message code="ezEmail.t179" /></th>
                <td> 
                   <select id="listcount" style="WIDTH:40px;height:20px;" onChange="ListCount(this.value);">
                        <option value=10 <c:if test="${listCount == '10'}">selected</c:if>>10</option>
                        <option value=20 <c:if test="${listCount == '20'}">selected</c:if>>20</option>
                        <option value=30 <c:if test="${listCount == '30'}">selected</c:if>>30</option>
                        <option value=40 <c:if test="${listCount == '40'}">selected</c:if>>40</option>
                        <option value=50 <c:if test="${listCount == '50'}">selected</c:if>>50</option>
                    </select>
	        </td>
              </tr>
                <tr>
                <th style="vertical-align:middle;"><spring:message code="ezEmail.t487" /></th>
                <td>
                    <img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onClick="PreviewRayerChange('NONE')"> 
                    <img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onClick="PreviewRayerChange('W')">
                    <img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onClick="PreviewRayerChange('H')"></td>
              </tr>
                <tr>
                <th><spring:message code="ezEmail.t99000035" /></th>
                <td>
                     <select name="select" id="select" onChange="on_changeView(this.value)" style="height:20px;width:120px;">       
                      <option VALUE="BASE" selected><spring:message code="ezEmail.t518" /></option>
                      <option VALUE="PREVIEW"><spring:message code="ezEmail.t843" /></option>
                      <option VALUE="UNREAD"><spring:message code="ezEmail.t519" /></option>
                      <option VALUE="RECEIV"><spring:message code="ezEmail.t66" /></option>
                    </select>
	        </td>
              </tr>
              </table>
            </div>
          </div>
	        <div class="shadow">
            </div>
        </div>  
        <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" onclick="ContextMenuHidden();" >&nbsp;</div>
        <div style="width:8px;height:100%;background-color:#808080;position:absolute;z-index:10000;display:none;" id="ResizeBarH"></div>
        <div style="width:100px;height:8px;background-color:#808080;position:absolute;z-index:10000;display:none;" id="ResizeBarW"></div>
        <div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
        </div>
        <span id="MailListRayer" style="border:0px solid blue;width:500px;height:100%;vertical-align:top;overflow:hidden;" > 
            <table style="width:100%;border:1px solid #B6B6B6;" id="MailHeader" class="mainlist" >               
            </table>
            <div id="contentlist" name="contentlist" style="border:0px solid blue;height:350px;width:100%;overflow-y:auto;" onblur  onscroll="ContextMenuHidden()">
                <table class="mainlist" style="width:100%;" id="MailList"  listpageCount="${listCount}" curPage="1" MaxCount="0" MaxPage="0" oncontextmenu="event_listContextMenu(event); return false;">
                </table>
            </div>
            <div id="tblPageRayer"  style="width:450px; margin:6px auto;"></div>
        </span>
        <span id="PreviewRayerH" style="border:0px solid red;width:500px;height:100%;overflow:hidden;vertical-align:top;display:none;margin-left:-5px;">
            <span class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor:w-resize;display:inline-block;">
				<p class="hbar_dotted"><img src="/images/prevview_hbar_dotted.gif"></p>
            </span>
            <span id="PreContent_RayerH" style="position:absolute; border:0px solid red;">
                <span style="width:100%;height:100px;display:block;">            
	                <span class="previewmail_info" style="display:block;width:100%;">
                        <div id="Preview_HeaderH" style="border: solid 0px black;width:100%;display:none;">
		                    <p class="mail_title" style="margin-left:0px;"><span class="icon_btn"><span onclick="MailReadOpen();" style="cursor:pointer;padding-right:5px;"><img src="/images/kr/cm/btn_newpopup.gif" alt="<spring:message code="ezEmail.t99000001" />" border="0"></span></span><span id="PreH_subject" style="display:none;"><span id="PreH_sub_subject" class="title_blodtxt"></span></span></p>
		                    <span class="mail_date" style="margin-right:10px;display:inline-block;"><span id="PreH_date"><span id="PreH_sub_date" style="display:none;"></span></span></span>
		                    <dl class="mail_item">
		                    <dt><spring:message code="ezEmail.t693" /></dt>
		                    <dd><span id="PreH_MailSender"><span id="PreH_sub_MailSender"></span></span></dd>
		                    <dt><spring:message code="ezEmail.t527" /></dt>
		                    <dd><span id="PreH_MailReceiver" style="display:inline-block"></span><span id="PreH_MailReceiver_sub"></span><span class="icon_graydown" onclick="ReceiverDetail_view(this);" id="PreH_ReceiverDetail"></span>
		                    <p class="hidden_area" id="PreH_MailReceiverDetail_Rayer" style="display:none;"><span id="PreH_MailReceiverDetail"></span></p>
                            </dd>
                            
                            <dt id="PreH_CCMain" style="display:none;"><spring:message code="ezEmail.t526" /></dt>
		                    <dd><span id="PreH_MailCC" style="display:inline-block"></span><span id="PreH_MailCC_sub"></span><span class="icon_graydown" onclick="CCDetail_view(this);" id="PreH_CCDetail" style="display:none;"></span>
		                    <p class="hidden_area" id="PreH_MailCC_Rayer" style="display:none;"><span id="PreH_MailCCDetail"></span></p>

		                    </dl>
                        </div>
	                </span>
                    <iframe id="ifrmPreViewH" name="ifrmPreViewH" src="/blank.htm" frameborder="0" style="width:100%;height:100%;border:solid 0px green;display:inline-block;">
                    </iframe>
                </span>
            </span>
        </span>        
        <span id="PreviewRayerW" style="border:0px solid red;width:100%;height:300px;overflow:hidden;display:none;">
            <span onmousedown="PreviewW_onMouserDown(event);" style="cursor: s-resize; width:100%;display:list-item;" class="previewmail_bar" name="PreviewBar" id="PreviewBar">
			<img src="/images/prevview_bar_dotted.gif">
            </span>
            <span id="PreContent_RayerW" style="display:block;border:0px solid red;">
                <span style="width:100%;height:100px;display:block;">
	                <span class="previewmail_info" style="display:block;width:100%;">
                        <div id="Preview_HeaderW" style="border: solid 0px black;display:none;">
		                    <p class="mail_title"><span class="icon_btn"><span onclick="MailReadOpen();" style="cursor:pointer;padding-right:5px;"><img src="/images/kr/cm/btn_newpopup.gif" alt="<spring:message code="ezEmail.t99000001" />" border="0"></span></span><span id="PreW_subject" ><span id="PreW_sub_subject" class="title_blodtxt"></span></span></p>
		                    <span class="mail_date" style="margin-right:10px;display:inline-block;"><span id="PreW_date" ><span id="PreW_sub_date"></span></span></span>
		                    <dl class="mail_item">
		                    <dt><spring:message code="ezEmail.t693" /></dt>
		                    <dd><span id="PreW_MailSender"><span id="PreW_sub_MailSender"></span></span></dd>
                            <dt><spring:message code="ezEmail.t527" /></dt>
		                    <dd><span id="PreW_MailReceiver" style="display:inline-block"></span><span id="PreW_MailReceiver_sub"></span><span class="icon_graydown" onclick="ReceiverDetail_view(this);" id="PreW_ReceiverDetail" style="display:inline-block;"></span>
		                    <p class="hidden_area" id="PreW_MailReceiverDetail_Rayer" style="display:none;"><span id="PreW_MailReceiverDetail"></span></p>
		                    </dd>

                            <dt id="PreW_CCMain" style="display:none;"><spring:message code="ezEmail.t526" /></dt>
                            <dd><span id="PreW_MailCC" style="display: inline-block"></span><span id="PreW_MailCC_sub"></span><span class="icon_graydown" onclick="CCDetail_view(this);" id="PreW_CCDetail" style="display:none;"></span>
                                <p class="hidden_area" id="PreW_MailCCDetail_Rayer" style="display: none;"><span id="PreW_MailCCDetail"></span></p>
                            </dd>

		                    </dl>
                        </div>
	                </span>
                    <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="/blank.htm" frameborder="0" style="width:100%;height:100%;border:0px solid black;z-index:0;">
                    </iframe>
                </span>
            </span>
        </span>   
<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>  
<div id="GroupSubObject" style="display:none;">
<table style="width:100%;" id="GroupSubHeader" class="mainlist_depth" >               
</table>
<div id="GroupSubContentlist"  style="border:0px solid red;height:auto;width:100%;overflow-y:auto;">
    <table class="mainlist" style="width:100%;" id="GroupSubList" oncontextmenu="event_listContextMenu(event); return false;">
    </table>
</div>
</div>
<div id="ContextMenuDiv" style="position:absolute;top:180px;z-index:6000;display:none;">
    <table cellpadding=2 cellspacing=1 border=0 style="width:150px;" class="popuplist">
    <tr>
        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="all_reply_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_reall.gif" alt=""  align="absmiddle" hspace="5"><spring:message code="ezEmail.t512" /></span></td>
    </tr>
    <tr>
        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="transmission_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_fw.gif" alt="" align="absmiddle" border="0" hspace="5"><spring:message code="ezEmail.t513" /></span></td>
    </tr>
    <tr>
        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="reply_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_mailreply.gif" alt="" align="absmiddle"  border="0" hspace="5"><spring:message code="ezEmail.t511" /></span></td>
    </tr>
    <tr>
        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="Read_StatusChange('R');HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/msg-rd.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t99000006" /></span></td>
    </tr>
    <tr>
        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="Read_StatusChange('U');HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/msg-unrd.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t99000007" /></span></td>
    </tr>
    <tr>
        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="move_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/move.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t482" /></span></td>
    </tr>
    <tr>
        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="MailListRefresh();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/recur.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t515" /></span></td>
    </tr>
    <tr>
        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="toggle_flag();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/icon-flag.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t550" /></span></td>
    </tr>
    </table>
</div>
<form name="PrevViewFormH" action="mail_Previewcontent.aspx" method="post" target="ifrmPreViewH" >
<input  type="hidden"  name="iptURL" value="">
<input  type="hidden" name="iSecurity" value="">
</form>
    <form name="PrevViewFormW" action="mail_Previewcontent.aspx" method="post" target="ifrmPreViewW">
<input  type="hidden"  name="iptURL" value="">
<input  type="hidden" name="iSecurity" value="">
</form>               
</body>
</html>