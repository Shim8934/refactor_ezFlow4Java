<%@page contentType="text/html;charset=utf-8" %>
<%@include file = "./include/session_check.jsp"%>
<%@include file = "manager_util.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>Namo CrossEditor : Admin</title>
	<script type="text/javascript">var pe_rZ="pe_AX"; </script>
	<script type="text/javascript" src="../../lib/jquery-1.7.2.min.js"> </script>
	<script type="text/javascript">var ce$=$.noConflict(true); </script>
	<script type="text/javascript" src="../manage_common.js"> </script>
	<script type="text/javascript" language="javascript" src="../../js/namo_cengine.js"> </script>
	<script type="text/javascript" language="javascript" src="../manager.js"> </script>
	<link href="../css/common.css" rel="stylesheet" type="text/css">
</head>

<body>

<%@include file = "../include/top.html"%>

<div id="pe_asO" class="pe_fM">	
	<table class="pe_qy">
	  <tr>
		<td class="pe_fM">
		
			<table id="Info">
				<tr>
					<td style="padding:0 0 0 10px;height:30px;text-align:left">
					<font style="font-size:14pt;color:#3e77c1;font-weight:bold;text-decoration:none;"><span id="pe_Cq"></span></font></td>
					<td id="InfoText"><span id="pe_vg"></span></td>
				</tr>
				<tr>
					<td colspan="2"><img id="pe_yY" src="../images/title_line.jpg" alt="" /></td>
				</tr>
			</table>
		
		</td>
	  </tr>
	  <tr>
		<td class="pe_fM">
			
				<form method="post" id="pe_avD" action="account_proc.jsp" onsubmit="return pe_p(this);">
				<table class="pe_kh" >
				  <tr>
					<td>

						<table class="pe_cO">
						  <tr><td class="pe_ft" colspan="3"></td></tr>
						</table>
						 
						<table class="pe_cO" >
						  <tr>
							<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_AC"></span></b></td>
							<td class="pe_dp"></td>
							<td class="pe_cf">
								<input type="hidden" name="u_id" id="u_id" value="<%=detectXSSEx(session.getAttribute("memId").toString())%>" autocomplete="off"/>
								<input type="password" name="passwd" id="passwd" value="" class="pe_kB" autocomplete="off"/>
							</td>
						  </tr>
						  <tr>
							<td class="pe_dR" colspan="3"></td>
						  </tr>
						  <tr>
							<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Hk"></span></b></td>
							<td class="pe_dp"></td>
							<td class="pe_cf">
								<input type="password" name="newPasswd" id="newPasswd" value="" class="pe_kB" autocomplete="off"/>
							</td>
						  </tr>
						  <tr>
							<td class="pe_dR" colspan="3"></td>
						  </tr>
						  <tr>
							<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ht"></span></b></td>
							<td class="pe_dp"></td>
							<td class="pe_cf">
								<input type="password" name="newPasswdCheck" id="newPasswdCheck" value="" class="pe_kB" autocomplete="off"/>
							</td>
						  </tr>
						</table>
					
						<table class="pe_cO">
						  <tr><td class="pe_ft" colspan="3"></td></tr>
						</table>
								
					</td>
				  </tr>
				  <tr id="pe_GJ">
					<td id="pe_Gf">
						<ul style="margin:0 auto;width:170px;">
							<li class="pe_eL">
								<input type="submit" id="pe_Bg" value="" class="pe_ec pe_eD" style="width:66px;height:26px;" />
							</li>
							<li class="pe_eL"><input type="button" id="pe_tE" value="" class="pe_ec pe_eD" style="width:66px;height:26px;"></li>
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
<script>var webPageKind='<%=detectXSSEx(session.getAttribute("webPageKind").toString())%>';topInit();pe_z(); </script>

</html>

	
	

