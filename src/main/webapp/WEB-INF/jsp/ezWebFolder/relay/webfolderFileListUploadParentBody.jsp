<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 웹폴더 첨부 레이어팝업을 위한 태그 추가--%>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel_sub">&nbsp;</div>
		<div class="layerpopup"  style="z-index:2000; position:absolute; display:none; overflow:hidden;" id="iFramePanel_sub">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer_sub"></iframe>
		</div>

<!-- fileFloderDrop.js에서 사용하는 태그(start) -->
		<!-- 사용하지 않지만 호출하여 필요한 것들. -->
		<div style="display:none;" id="webFolderRightPanel"></div>
		<div id="dragDropArea"  style="overflow-y:auto;white-space:nowrap;display:none;"></div>

		<span class="loading_layer" style="z-index:1500;position:absolute;top:50%;left:50%;transform: translate(-50%, -50%);display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>
		<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
			<img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
		</div>
		<div id="listload_div" class="loadingBox2" style="display:none; z-index:7500;">
			<div class="loader loader-3">
				<div class="dot dot1"></div>
				<div class="dot dot2"></div>
				<div class="dot dot3"></div>
				<div class="dot dot4"></div>
			</div>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
		</div>
<!-- end -->