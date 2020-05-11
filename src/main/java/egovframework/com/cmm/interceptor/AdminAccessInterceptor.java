package egovframework.com.cmm.interceptor;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.web.LoginController;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * 인증여부 체크 인터셉터
 * @author 공통서비스 개발팀 서준식
 * @since 2011.07.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2011.07.01  서준식          최초 생성
 *  2011.09.07  서준식          인증이 필요없는 URL을 패스하는 로직 추가
 *  2014.06.11  이기하          인증이 필요없는 URL을 패스하는 로직 삭제(xml로 대체)
 *  </pre>
 */

public class AdminAccessInterceptor extends WebContentInterceptor {
	
	/** CRYPTO */
    @Resource(name="crypto")
    private EgovFileScrty egovFileScrty;
    
    @Autowired
    private CommonUtil commonUtil;
    
	@Resource(name = "loginService")
    private LoginService loginService;

    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
    
    @Resource(name="EzSystemAdminService")
    private EzSystemAdminService ezSystemAdminService;
	
	@Autowired
	private LoginController loginController;
    
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(AdminAccessInterceptor.class);

	/**
	 * 관리자 페이지 접근 제한 확인
	 * 
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
		try {
			boolean returnValue = false;
			
			String serverName = request.getServerName();
			int serverPort = request.getServerPort();
			int tenantId = loginService.getTenantId(serverName);
			logger.debug("serverName=" + serverName + ", serverPort=" + serverPort + ", tenantId=" + tenantId);
			
			// 관리자 ip 제한 사용여부 체크
			String useAdminIpAccess = ezCommonService.getTenantConfig("useAdminIPAccess", tenantId);
			logger.debug("useAdminIpAccess=" + useAdminIpAccess);
			 
			 if (useAdminIpAccess.equalsIgnoreCase("no")) {
				return true;
			} else if (useAdminIpAccess.equalsIgnoreCase("yes")) {
				String clientIP = ClientUtil.getClientIP(request);
				String clientIPArr[] = clientIP.split("\\.");
				logger.debug("clientIp=" + clientIP);
				
				List<IPBandVO> ipBandList = ezSystemAdminService.getAdminAccessIPBand(tenantId);
				
				if (ipBandList != null && ipBandList.size() != 0) {
					String ipBandAddr = "";
					String getAccess = "NO";
					int checkCnt = 0;
					
					for (IPBandVO ipBandVo : ipBandList) {
						ipBandAddr = ipBandVo.getIpAddress();
						getAccess = ipBandVo.getAccess();
						logger.debug("ipBandAddr=" + ipBandAddr + ", getAccess=" + getAccess);
						
						String ipListIp[] = ipBandAddr.split("\\."); // *(대역)이 있을 수도 있으니 하나하나 검사해야됨
	        			for (int j = 0; j < clientIPArr.length; j++) {
	        				if (ipListIp[j].equals("*") || ipListIp[j].equals(clientIPArr[j])) {
	        					checkCnt++;
	        				}
	        			}

						logger.debug("checkCnt=" + checkCnt);
	        			if (checkCnt == 4 && getAccess.equals("NO")) {
	        				returnValue = false;
	        				break;
	        			} else if (checkCnt == 4){
	        				returnValue = true;
	        			}
	        			checkCnt = 0;
					} // for_end
				} // ipbandList if_end
			}

				logger.debug("returnValue=" + returnValue);
			if (!returnValue) {
				response.sendRedirect("/admin/accessBlockToAdmin.do");
			}
			
			return returnValue;
		} catch(Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		CommonUtil.addXUACompatibleHeaderToResponse(request, response);
	}
}
