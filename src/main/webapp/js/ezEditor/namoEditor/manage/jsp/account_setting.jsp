<%@page contentType="text/html;charset=utf-8" %>
<%@include file = "./include/session_check.jsp"%>
<%@include file = "manager_util.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>Namo CrossEditor : Admin</title>
	<script type="text/javascript">var pe_vX="pe_Kg"; </script>
	<script type="text/javascript" src="../../lib/jquery-1.7.2.min.js"> </script>
	<script type="text/javascript">var ce$=namo$.noConflict(true); </script>
	<script type="text/javascript" src="../manage_common.js"> </script>
	<script type="text/javascript" language="javascript" src="../../js/namo_cengine.js"> </script>
	<script type="text/javascript" language="javascript" src="../manager.js"> </script>
	<link href="../css/common.css" rel="stylesheet" type="text/css">
</head>

<body>

<%@include file = "../include/top.html"%>

<div id="pe_aCI" class="pe_ib">	
	<table class="pe_uz">
	  <tr>
		<td class="pe_ib">
		
			<table id="Info">
				<tr>
					<td style="padding:0 0 0 10px;height:30px;text-align:left">
					<font style="font-size:14pt;color:#3e77c1;font-weight:bold;text-decoration:none;"><span id="pe_CT"></span></font></td>
					<td id="InfoText"><span id="pe_xX"></span></td>
				</tr>
				<tr>
					<td colspan="2"><img id="pe_Cr" src="../images/title_line.jpg" alt="" /></td>
				</tr>
			</table>
		
		</td>
	  </tr>
	  <tr>
		<td class="pe_ib">
			
				<form method="post" id="pe_aKb" action="account_proc.jsp" onsubmit="return pe_aC(this);">
				<table class="pe_pa" >
				  <tr>
					<td>

						<table class="pe_eU">
						  <tr><td class="pe_hJ" colspan="3"></td></tr>
						</table>
						 
						<table class="pe_eU" >
						  <tr>
							<td class="pe_ea">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_zG"></span></b></td>
							<td class="pe_fA"></td>
							<td class="pe_fs">
								<input type="hidden" name="u_id" id="u_id" value="<%=detectXSSEx(session.getAttribute("memId").toString())%>" autocomplete="off"/>
								<input type="password" name="passwd" id="passwd" value="" class="pe_nZ" autocomplete="off"/>
							</td>
						  </tr>
						  <tr>
							<td class="pe_eB" colspan="3"></td>
						  </tr>
						  <tr>
							<td class="pe_ea">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Fb"></span></b></td>
							<td class="pe_fA"></td>
							<td class="pe_fs">
								<input type="password" name="newPasswd" id="newPasswd" value="" class="pe_nZ" autocomplete="off"/>
							</td>
						  </tr>
						  <tr>
							<td class="pe_eB" colspan="3"></td>
						  </tr>
						  <tr>
							<td class="pe_ea">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_GE"></span></b></td>
							<td class="pe_fA"></td>
							<td class="pe_fs">
								<input type="password" name="newPasswdCheck" id="newPasswdCheck" value="" class="pe_nZ" autocomplete="off"/>
							</td>
						  </tr>
						</table>
					
						<table class="pe_eU">
						  <tr><td class="pe_hJ" colspan="3"></td></tr>
						</table>
								
					</td>
				  </tr>
				  <tr id="pe_OG">
					<td id="pe_Rq">
						<ul style="margin:0 auto;width:170px;">
							<li class="pe_ih">
								<input type="submit" id="pe_JW" value="" class="pe_jt pe_ho" style="width:66px;height:26px;" />
							</li>
							<li class="pe_ih"><input type="button" id="pe_Aj" value="" class="pe_jt pe_ho" style="width:66px;height:26px;"></li>
						</ul>
					</td>
				  </tr>
				</table>
				</form>
		
		</td>
	  </tr>
	</table>

</div>

<%@include file = "../include/bottom.html"%>

</body>
<script>var webPageKind='<%=detectXSSEx(session.getAttribute("webPageKind").toString())%>';topInit();pe_N(); </script>

</html>

	
	

