<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<frameset cols="200,*" frameborder="0" border="0" frameSpacing="0">
		<frame src="/admin/ezApprovalG/apprGLeft.do" name="left" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0" id="left" frameborder="NO">  		
		<!-- TODO : 2016-05-04 장진혁과장 -- 폼프로세스 에디터(activeX) 이슈로 인한 일시적인 주석 처리  
			<frame src="/myoffice/ezApprovalG/manage/FormMaker/Form_Admin.aspx" name="right" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0" id="Frame1" frameborder="NO" /> 
		-->
		<frame src="/admin/ezApprovalG/apprGMCont.do" name="right" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0" id="right" frameborder="NO" />
	</frameset>
</html>