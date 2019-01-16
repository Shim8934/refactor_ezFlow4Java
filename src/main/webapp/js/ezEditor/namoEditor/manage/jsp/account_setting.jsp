<%@page contentType="text/html;charset=utf-8" %>
<%@include file = "./include/session_check.jsp"%>
<%@include file = "manager_util.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>Namo CrossEditor : Admin</title>
	<script type="text/javascript">var pe_vV="pe_Nj"; </script>
	<script type="text/javascript" src="../../lib/jquery-1.7.2.min.js"> </script>
	<script type="text/javascript">var ce$=namo$.noConflict(true); </script>
	<script type="text/javascript" src="../manage_common.js"> </script>
	<script type="text/javascript" language="javascript" src="../../js/namo_cengine.js"> </script>
	<script type="text/javascript" language="javascript" src="../manager.js"> </script>
	<link href="../css/common.css" rel="stylesheet" type="text/css">
</head>

<body>

<%@include file = "../include/top.html"%>

<div id="pe_axW" class="pe_ik">	
	<table class="pe_tK">
	  <tr>
		<td class="pe_ik">
		
			<table id="Info">
				<tr>
					<td style="padding:0 0 0 10px;height:30px;text-align:left">
					<font style="font-size:14pt;color:#3e77c1;font-weight:bold;text-decoration:none;"><span id="pe_DL"></span></font></td>
					<td id="InfoText"><span id="pe_wt"></span></td>
				</tr>
				<tr>
					<td colspan="2"><img id="pe_Dm" src="../images/title_line.jpg" alt="" /></td>
				</tr>
			</table>
		
		</td>
	  </tr>
	  <tr>
		<td class="pe_ik">
			
				<form method="post" id="pe_aBz" action="account_proc.jsp" onsubmit="return pe_ai(this);">
				<table class="pe_oE" >
				  <tr>
					<td>

						<table class="pe_eG">
						  <tr><td class="pe_hB" colspan="3"></td></tr>
						</table>
						 
						<table class="pe_eG" >
						  <tr>
							<td class="pe_fH">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_AQ"></span></b></td>
							<td class="pe_eH"></td>
							<td class="pe_fN">
								<input type="hidden" name="u_id" id="u_id" value="<%=detectXSSEx(session.getAttribute("memId").toString())%>" autocomplete="off"/>
								<input type="password" name="passwd" id="passwd" value="" class="pe_nK" autocomplete="off"/>
							</td>
						  </tr>
						  <tr>
							<td class="pe_fa" colspan="3"></td>
						  </tr>
						  <tr>
							<td class="pe_fH">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Fc"></span></b></td>
							<td class="pe_eH"></td>
							<td class="pe_fN">
								<input type="password" name="newPasswd" id="newPasswd" value="" class="pe_nK" autocomplete="off"/>
							</td>
						  </tr>
						  <tr>
							<td class="pe_fa" colspan="3"></td>
						  </tr>
						  <tr>
							<td class="pe_fH">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Gk"></span></b></td>
							<td class="pe_eH"></td>
							<td class="pe_fN">
								<input type="password" name="newPasswdCheck" id="newPasswdCheck" value="" class="pe_nK" autocomplete="off"/>
							</td>
						  </tr>
						</table>
					
						<table class="pe_eG">
						  <tr><td class="pe_hB" colspan="3"></td></tr>
						</table>
								
					</td>
				  </tr>
				  <tr id="pe_Ty">
					<td id="pe_Ue">
						<ul style="margin:0 auto;width:170px;">
							<li class="pe_iT">
								<input type="submit" id="pe_Jc" value="" class="pe_ic pe_hI" style="width:66px;height:26px;" />
							</li>
							<li class="pe_iT"><input type="button" id="pe_Ac" value="" class="pe_ic pe_hI" style="width:66px;height:26px;"></li>
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
<script>var webPageKind='<%=detectXSSEx(session.getAttribute("webPageKind").toString())%>';topInit();pe_p(); </script>

</html>

	
	

