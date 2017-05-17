<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css">
</head>
<body class="mainbody" style="overflow:hidden;" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	    <h1><spring:message code='ezBoard.t10030'/><span id="mailBoxInfo"></span>
	        <span style="float:right;font-weight:normal;color:black;">
	          <input name="searchCheck" id="Radio1" type="radio" value="rad_Subject" checked style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezBoard.t208'/>
			  <input name="searchCheck" id="Radio2" type="radio" value="rad_Writer" style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezBoard.t223'/>
			  &nbsp;
			  <input id="txt_keyword" style="width:150px;" onkeypress="onkeydown_start_search(event)" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	          <a href="#"><img src="../../images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search('quick')"></a>
	        </span>
	    </h1>
	    <div id="mainmenu">
	        <ul>
	            <li><span onClick="NewItem_onclick()"><spring:message code='ezBoard.t321'/></span></li>
	            <li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
	            <li><span onClick="DeleteItem_onclick()"><spring:message code='ezBoard.t89'/></span></li>
	            <li id="Li1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
	            <li><span onClick="refresh_onclick()"><spring:message code='ezBoard.t205'/></span></li>
	            <li><span id="SearchOption" mode="off" onClick="doLayerPopup(this)"><spring:message code='ezBoard.t188'/></span></li>
	            <li id="right"><spring:message code='ezBoard.t10020'/><img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" /></li>      
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	    <div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
	        <div class="popupwrap1">
	            <div class="popupwrap2">
	                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width: 80px;">
	                        <col>
	                    </colgroup>
	                     <tr>
	                        <th><spring:message code='ezBoard.t10021'/></th>
	                        <td>
	                            <select id="listcount" style="WIDTH: 40px; height: 20px;" onchange="ListCount(this.value);">
	                                <option value="10">10</option>
	                                <option value="20">20</option>
	                                <option value="30">30</option>
	                                <option value="40">40</option>
	                                <option value="50">50</option>
	                            </select>    
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezBoard.t431'/></th>
	                        <td>
	                            <img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
	                            <img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onclick="PreviewRayerChange('W')">
	                            <img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')"></td>
	                    </tr>
	                </table>
	            </div>
	        </div>
	        <div class="shadow">
	        </div>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
	    <div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	    <div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
	
	    <span id="MailListRayer" style="border: 0px solid blue; width: 0px; height: 0px; vertical-align: top; overflow: hidden; display: inline-block;">
	        <div style="width:100%; overflow:AUTO;" id="divList">
	            <div id="lvBoardList"></div>
	        </div>
	        <div id='runtime' style="color:#666;padding-top:5px"></div>
	        <div id="tblPageRayer" style="text-align:center"></div>
	    </span>
	
	
	    <span id="PreviewRayerH" style="border:0px solid red; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
	        <span id="previewmail_bar_h" class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block;">
	            <p class="hbar_dotted">
	                <img src="/images/prevview_hbar_dotted.gif">
	            </p>
	        </span>
	        <span id="PreContent_RayerH" style="position: absolute; border: 0px solid blue;">
	            <span style="width: 100%; height: 100px; display: block;">
	                <span class="previewmail_info" style="display: block; width: 100%;">
	                    <div id="Preview_HeaderH" style="border-bottom: solid 1px #dadada; width: 100%; display: none;">
	                        <p class="mail_title" style="margin-left: 0px;">
	                            <span class="icon_btn"><span onclick="MailReadOpen_temp();" style="cursor: pointer; padding-right: 5px;">
	                                <img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreH_subject"><span id="PreH_sub_subject" class="title_blodtxt"></span></span>
	                        </p>
	                        <span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreH_date"><span id="PreH_sub_date" style="display: none;"></span></span></span>
	                        <dl class="mail_item">
	                            <dt><spring:message code='ezBoard.t223'/>:
	                                <span id="PreH_MailReceiver" style="display: inline-block"></span>
	                            </dt>
	                        </dl>
	                    </div>
	                </span>
	                <iframe id="ifrmPreViewH_photo" name="ifrmPreViewH_photo" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: none;"></iframe>
	                <iframe id="ifrmPreViewH" name="ifrmPreViewH" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
	            </span>
	        </span>
	    </span>
	
	
	    <span id="PreviewRayerW" style="border: 0px solid red; width: 100%; height: 300px; overflow: hidden; display: none;">
	        <span onmousedown="PreviewW_onMouserDown(event);" style="cursor: s-resize; width: 100%; display: list-item;" class="previewmail_bar" name="PreviewBar" id="PreviewBar">
	            <img src="/images/prevview_bar_dotted.gif">
	        </span>
	        <span id="PreContent_RayerW" style="display: block;">
	            <span style="width: 100%; height: 100px; display: block;">
	                <span class="previewmail_info" style="display: block; width: 100%;">
	                    <div id="Preview_HeaderW" style="border-bottom: solid 1px #dadada; display: none;">
	                        <p class="mail_title">
	                            <span class="icon_btn"><span onclick="MailReadOpen_temp();" style="cursor: pointer; padding-right: 5px;">
	                                <img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreW_subject"><span id="PreW_sub_subject"></span></span>
	                        </p>
	                        <span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreW_date"><span id="PreW_sub_date"></span></span></span>
	                        <dl class="mail_item">
	                            <dt><spring:message code='ezBoard.t223'/>:</dt>
	                            <dd><span id="PreW_MailReceiver" style="display: inline-block"></span>
	                            </dd>
	                        </dl>
	                    </div>
	                </span>
	                <iframe id="ifrmPreViewW_photo" name="ifrmPreViewW_photo" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0; display:none;"></iframe>
	                <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
	            </span>
	        </span>
	    </span>
	
	
	    <div id="layer_popup" style="width:700px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
	          <div class="popupwrap1">
	            <div class="popupwrap2">
	        <table class="content">
	        <tr>
	            <th style="text-align:center"><spring:message code='ezBoard.t208'/></th>
	            <td><input type="text" id="txtTitle" style="width:98%" value=""></td>
	        </tr>  
	         <tr>
	            <th style="text-align:center"><spring:message code='ezBoard.t209'/></th>
	            <td><input type="text" id="txtAbstract" style="width:98%" value=""></td>
	        </tr>    
	       <tr>
	            <th style="text-align:center"><spring:message code='ezBoard.t210'/></th>
	           <td><input	readonly type='text'
						class='datepicker' 
						id='idDatepicker'
						style="width:95px"
						name="text">
	      <img id=img_StartCalDisp src="../../images/i_scheduler.gif" width="19" height="15" style="CURSOR: pointer; POSITION: relative; vertical-align:middle" tabindex=0 popupLocation='bottomright'  forcemarginleft="-40"  forceMarginTop="30">
	      <input	type="text" 
						id='_T1' 
						class='datepicker_time' 
						name="textfield22522" 
						readonly style="font-size:9pt ; width:95px; display:none">
	      <img id=img_StartTime src="../../images/i_time.gif" width="17" height="15" style="CURSOR: pointer; POSITION: relative; z-index:15; display:none" popupLocation='bottomright' forcemarginleft="-40"  forceMarginTop="30"> ~
	      <input type="text" id='_D2' class='datepicker_date' name="txtPermanence" readonly style="width:95px">
	      <img id=img_EndCalDisp src="../../images/i_scheduler.gif" width="19" height="15" style="CURSOR: pointer; POSITION:  relative; z-index:15; vertical-align:middle"  tabindex=0 popupLocation='bottomright'>
	      <input id='_T2'  type = hidden class='datepicker_time' readonly="true" style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 100px" name="hidden" >
	      <img border=0 height=20 id=img_EndTime src="../../images/i_time.gif" style="CURSOR: pointer; POSITION:  relative; z-index:15; display:none" width=20 popupLocation='bottomright'> </td>
		  </tr>
		    </table>
		    <br />
		    <table style="width:100%">
		        <tr>
		            <td style="text-align:center;">
		                <a class="imgbtn"><span onClick="btn_PostDate_Clear()"><spring:message code='ezBoard.t220'/></span></a>
		                <a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezBoard.t188'/></span></a>
		                <a class="imgbtn"><span onClick="BoardSearchOptionHidden()"><spring:message code='ezBoard.t15'/></span></a>
		            </td>
		        </tr>
		    </table>
            </div>
          </div>
        <div class="shadow">
        </div>
		</div>
	</body>
</html>