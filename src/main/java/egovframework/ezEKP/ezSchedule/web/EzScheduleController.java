package egovframework.ezEKP.ezSchedule.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 스케쥴
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.19	지정석	신규작성
 *    2016.08.10	김경식	scheduleMain 추가
 *
 * @see
 */

@Controller
public class EzScheduleController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	/**
	 * 일정관리 메인화면 호출함수
	 */
	@RequestMapping(value="/ezSchedule/scheduleMain.do")
	public String  main(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		String	funCode = "";	// 업무관리 or 일정관리(3)
		String	subCode = "";
		
        if (request.getParameter("funCode") != null) {
            funCode = request.getParameter("funCode");
        }
        
        if (request.getParameter("subfunction") != null) {
        	subCode = request.getParameter("subfunction");
        }
        
		model.addAttribute("funCode", funCode);
		model.addAttribute("subCode", subCode);

		
		return "/ezSchedule/scheduleMain";
	}

	/**
	 * 일정관리 왼쪽화면 호출함수
	 */
	@RequestMapping(value="/ezSchedule/scheduleLeft.do")
	public String  scheduleLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		String	funCode		= "";	// 일정관리 or 업무관리(3)
		String	subCode		= "";	// 아직 모름	
		int	defaultView;			// 일간, 주간, 월간
		int	startDay;				// 일요일부터 또는 월요일부터
		
        if (request.getParameter("funCode") != null) {
            funCode = request.getParameter("funCode");
        }
        
        if (request.getParameter("subfunction") != null) {
        	subCode = request.getParameter("subfunction");
        }

        LoginVO loginVO = commonUtil.userInfo(loginCookie);
		ScheduleConfigVO schConfVO = ezScheduleService.getScheduleConfig(loginVO.getId());
		defaultView = schConfVO.getDefaultView();
		startDay = schConfVO.getStartDay();
        
		model.addAttribute("funCode", funCode);
		model.addAttribute("subCode", subCode);
		model.addAttribute("defautView", defaultView);	// 임시
		model.addAttribute("startDay", startDay);	// 임시

		
		return "/ezSchedule/scheduleLeft";
	}

	/**
	 * 일정관리 휴일 함수 호출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGetHoliday.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGetHoliday(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlStr) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		List<ScheGetHolidayVO> getHoliday = ezScheduleService.getTholiday(xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().toUpperCase().trim(), userInfo.getCompanyID());
		String returnXML = "";
		for (int i=0; i<getHoliday.size(); i++ ) {
			returnXML = commonUtil.getQueryResult(getHoliday.get(i));
		}
		return returnXML;
	}
}
