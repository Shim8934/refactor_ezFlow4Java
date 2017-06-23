package egovframework.ezMobile.ezApprovalG.web;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGTLVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 전자결재 모바일
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.06.01    황윤진    신규작성
 *
 * @see
 */

@Controller
public class MApprovalGController {
	private static final Logger logger = LoggerFactory.getLogger(MApprovalGController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name = "MApprovalGService")
	private MApprovalGService MApprovalGService;
	
	/**
	 * 모바일 전자결재G 결재할문서 호출 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/doApproveList.do")
	public String doApprovList(@CookieValue("loginCookie") String loginCookie, Model model, String pListType) throws Exception {
		logger.debug("doApprovList started");
		logger.debug("listType : " + pListType);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		//임시로 박고 리스트타입으로 문서리스트 종류 구분 결재할,결재한,결재진행 등등 
		pListType = "1";
		
		//결재할 문서 카운트
		int listCount = MApprovalGService.getDoApproveListCount(userInfo, pListType, "");
		List<MApprovalGDocInfoVO> approvalGDocInfoVOs = MApprovalGService.getDoApproveList(userInfo, pListType, "");
		
		model.addAttribute("listCount", listCount);
		model.addAttribute("docList", approvalGDocInfoVOs);
		
		logger.debug("doApprovList ended"); 
		
		return "mobile/ezApprovalG/mApprGdoApproveList";
	}
	
	/**
	 * 모바일 전자결재G 결재할문서 검색 표출 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/doSearchApproveList.do")
	public String doSearchApproveList(@CookieValue("loginCookie") String loginCookie, Model model, String pSearchText, String pListType) throws Exception {
		logger.debug("doSearchApproveList started");
		logger.debug("searchText : " + pSearchText);
		logger.debug("listType : " + pListType);

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		//임시 결재할문서 타입
		pListType = "1";
		
		//결재할 문서 카운트
		int listCount = MApprovalGService.getDoApproveListCount(userInfo, pListType, pSearchText);
		List<MApprovalGDocInfoVO> approvalGDocInfoVOs = MApprovalGService.getDoApproveList(userInfo, pListType, pSearchText);
		
		model.addAttribute("listCount", listCount);
		model.addAttribute("docList", approvalGDocInfoVOs);

		logger.debug("doSearchApproveList ended");
		
		return "json";
	}
	
	/**
	 * 모바일 전자결재G 문서보기 호출 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/doApprovalGDetail.do")
	public String doApprovalGDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String pDocID, String pListType) throws Exception {
		logger.debug("doApprovalGDetail started");
		logger.debug("docID : " + pDocID);
		logger.debug("listType : " + pListType);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		
		//임시 결재할문서 타입
		pListType = "1";

		//결재선
		List<MApprovalGAprLineInfoVO> approvalGAprLineInfoVOs = MApprovalGService.getAprLineInfo(pDocID, pListType, userInfo);
		String photoPath = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId());
		
		//본문
		String domain = request.getServerName() + ":" + request.getServerPort();
		String bodyHTML = MApprovalGService.getMHTBody(pDocID, pListType, realPath, domain, userInfo);
		
		//의견갯수
		String commentCount = MApprovalGService.getAprCommentCount(pDocID, pListType, userInfo);
		
		model.addAttribute("aprLineList", approvalGAprLineInfoVOs);
		model.addAttribute("photoPath", photoPath);
		model.addAttribute("bodyHTML", bodyHTML);
		model.addAttribute("commentCount", commentCount);
		model.addAttribute("docID", pDocID);

		logger.debug("doApprovalGDetail ended");
		
		return "mobile/ezApprovalG/mApprGdoApproveDetail";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/getOpinionInfo.do")
	public String getOpinionInfo(@CookieValue("loginCookie") String loginCookie, Model model, String pDocID, String pListType) throws Exception {
		logger.debug("getOpinionInfo started");
		logger.debug("docID : " + pDocID);
		logger.debug("listType : " + pListType);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		List<MApprovalGOpinionInfoVO> approvalGOpinionInfoVOs = MApprovalGService.getOpinionInfo(pDocID, pListType, userInfo);

		model.addAttribute("opinionList", approvalGOpinionInfoVOs);
		model.addAttribute("userID", userInfo.getId());
		
		logger.debug("getOpinionInfo ended");
		
		return "json";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/saveOpinionInfo.do")
	public void saveOpinionInfo(@CookieValue("loginCookie") String loginCookie, String pDocID, String pContent, String pOpinionGB, HttpServletResponse response) throws Exception {
		logger.debug("saveOpinionInfo started");
		logger.debug("docID : " + pDocID);
		logger.debug("content : " + pContent);
		logger.debug("opinionGB : " + pOpinionGB);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		MApprovalGService.saveOpinionInfo(pDocID, pContent, pOpinionGB, userInfo);

		logger.debug("saveOpinionInfo ended");
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/getTimeLineList.do")
	public String getTimeLineList(@CookieValue("loginCookie") String loginCookie, HttpSession session, Model model, String pTempFlag) throws Exception {
		logger.debug("getTimeLineList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String sessionDate = "";
		
		if (pTempFlag.equals("0")) {
			sessionDate = commonUtil.getTodayUTCTime("");
			session.setAttribute("timeLineStartDate", sessionDate);
		} else {
			sessionDate = (String) session.getAttribute("timeLineStartDate");
		}
		
		logger.debug("sessionDate : " + sessionDate);
		
		List<MApprovalGTLVO> mApprovalGTLVOs = MApprovalGService.getTimeLineList(userInfo, sessionDate);
		

		//메일 조인 부분
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
	      
		List<Map<String, String>> mailList = ezEmailService.getMailListT(userInfo, password, sessionDate, 20);
		//sender, receivedDate, title
		
		for (Map<String, String> maps : mailList) {
			MApprovalGTLVO mApprovalGTLVO = new MApprovalGTLVO();
			mApprovalGTLVO.setTitle(maps.get("subject"));
			mApprovalGTLVO.setStartDate(maps.get("receivedDate"));
			mApprovalGTLVO.setModule("메일");
			mApprovalGTLVO.setWriterName(maps.get("sender"));
			
			mApprovalGTLVOs.add(mApprovalGTLVO);
		}
		
		Collections.sort(mApprovalGTLVOs, new Comparator<MApprovalGTLVO>() {
			@Override
			public int compare(MApprovalGTLVO o1, MApprovalGTLVO o2) {
				return o2.getStartDate().compareTo(o1.getStartDate());
			}
		});
		
		sessionDate = mApprovalGTLVOs.get(mApprovalGTLVOs.size() - 1).getStartDate();
		
		if (mApprovalGTLVOs.size() > 0) {
			session.setAttribute("timeLineStartDate", sessionDate);
		}

		model.addAttribute("timeLineList", mApprovalGTLVOs);
		
		logger.debug("getTimeLineList ended");
		
		return "json";
	}
}
