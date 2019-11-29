package egovframework.ezEKP.ezApprovalG.web;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKEDService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.KEDUserInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.KEDXMLInfo;
import egovframework.ezEKP.kedCustom.util.KEDUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzApprovalGKEDController {
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGKEDController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzApprovalGKEDService ezApprovalGKEDService;
	
	@Autowired 
	private KEDUtil kedUtil;
	
	@RequestMapping(value = "/ezApprovalG/setKEDConnLayer.do", method = RequestMethod.GET)
	public String setKEDConnLayer(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) {
		logger.debug("setKEDConnLayer started");
		
		String formType = request.getParameter("formType");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		KEDUserInfoVO kedUserInfo = ezApprovalGKEDService.findKEDUserByID(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		model.addAttribute("sabun", userInfo.getSabun());
		model.addAttribute("encryptedSabun", kedUtil.getCipherTextStr(userInfo.getSabun()));
		model.addAttribute("key", kedUtil.getCipherTextStr(userInfo.getId()));
		model.addAttribute("deptName", userInfo.getDeptName());
		model.addAttribute("name", userInfo.getDisplayName());
		model.addAttribute("jikwe", userInfo.getTitle());
		model.addAttribute("mail", userInfo.getEmail());
		model.addAttribute("phoneNo", userInfo.getPhone());
		model.addAttribute("address", kedUserInfo.getAddress());
		model.addAttribute("residentNo", kedUserInfo.getResidentNo());
				
		logger.debug("setKEDConnLayer ended");
		return "ezApprovalG/kedConnLayer/" + formType;
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/findKEDUserList.do", method = RequestMethod.GET)
	public ResponseEntity<List<KEDUserInfoVO>> findKEDUserList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) {
		logger.debug("findKEDUserList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String name = request.getParameter("name");
		
		List<KEDUserInfoVO> userList = ezApprovalGKEDService.findKEDUserList(name, tenantId, companyId);
		
		ResponseEntity<List<KEDUserInfoVO>> result = new ResponseEntity<List<KEDUserInfoVO>>(userList, HttpStatus.OK);		
		logger.debug("findKEDUserList ended");
		return result;
	}
	
	// 복수의 파라미터를 넘겨서 암호화된 파라미터를 받는 함수
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/getKEDParamList.do", method = RequestMethod.POST)
	public ResponseEntity<?> getKEDParamList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) {
		logger.debug("getKEDParamList started");
		String[] params = request.getParameter("params").split(":");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		ResponseEntity<?> result;
		
		// 첫번째 파라미터는 이미 암호화된 로그인 유저의 아이디여야한다. 그렇지 않을 경우 실패 처리
		if(!params[0].equals(kedUtil.getCipherTextStr(userInfo.getId()))) {
			result = ResponseEntity.badRequest().build();
		} else {
			List<String> cipherStrList = new ArrayList<String>();
			
			for(int i = 1; i < params.length; i++) {
				cipherStrList.add(kedUtil.getCipherTextStr(params[i]));
			}
			
			result = new ResponseEntity<List<String>>(cipherStrList, HttpStatus.OK);
		}
		
		logger.debug("getKEDParamList ended");
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/saveKEDXmlInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Void> saveKEDXmlInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody KEDXMLInfo kedxmlInfo) {
		logger.debug("saveKEDXmlInfo started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		kedxmlInfo.setTenantID(userInfo.getTenantId());
		kedxmlInfo.setCompanyID(userInfo.getCompanyID());
		
		ezApprovalGKEDService.saveKEDXmlInfo(kedxmlInfo);
		logger.debug("saveKEDXmlInfo ended");
		return ResponseEntity.status(HttpStatus.CREATED).build();
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/updateKEDXmlInfoOnLoad.do", method = RequestMethod.POST)
	public ResponseEntity<Void> updateKEDXmlInfoOnLoad(@CookieValue("loginCookie") String loginCookie, @RequestBody KEDXMLInfo kedxmlInfo) {
		logger.debug("updateKEDXmlInfoOnLoad started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		kedxmlInfo.setTenantID(userInfo.getTenantId());
		kedxmlInfo.setCompanyID(userInfo.getCompanyID());
		
		ezApprovalGKEDService.updateKEDXmlInfoOnLoad(kedxmlInfo);
		logger.debug("updateKEDXmlInfoOnLoad ended");
		return ResponseEntity.status(HttpStatus.OK).build();
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/syncSingleDocWithMIS.do", method = RequestMethod.POST)
	public ResponseEntity<Void> syncSingleDocWithMIS(@CookieValue("loginCookie") String loginCookie, @RequestBody KEDXMLInfo kedxmlInfo) throws UnsupportedEncodingException {
		logger.debug("syncSingleDocWithMIS started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		kedxmlInfo.setTenantID(userInfo.getTenantId());
		kedxmlInfo.setCompanyID(userInfo.getCompanyID());
		
		ezApprovalGKEDService.syncSingleDocWithMIS(kedxmlInfo);
		logger.debug("syncSingleDocWithMIS ended");
		return ResponseEntity.status(HttpStatus.OK).build();
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/cancelKED_MIS_update.do", method = RequestMethod.POST)
	public ResponseEntity<Void> cancelKED_MIS_update(@CookieValue("loginCookie") String loginCookie, @RequestBody KEDXMLInfo kedxmlInfo) {
		logger.debug("cancelKED_MIS_update started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		kedxmlInfo.setTenantID(userInfo.getTenantId());
		kedxmlInfo.setCompanyID(userInfo.getCompanyID());
		
		ezApprovalGKEDService.cancelKED_MIS_update(kedxmlInfo);
		logger.debug("cancelKED_MIS_update ended");		
		return ResponseEntity.status(HttpStatus.OK).build();
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/selectConnFormInfo.do", method = RequestMethod.GET)
	public ResponseEntity<List<ApprGFormVO>> selectConnFormInfo(@CookieValue("loginCookie") String loginCookie) {
		logger.debug("selectConnFormInfo started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<ApprGFormVO> list = ezApprovalGKEDService.selectConnFormInfo(userInfo.getTenantId(), userInfo.getCompanyID());
		
		logger.debug("selectConnFormInfo ended");
		return new ResponseEntity<List<ApprGFormVO>>(list, HttpStatus.OK);
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/searchEndConnDocList.do", method = RequestMethod.POST)
	public ResponseEntity<List<ApprGDocListVO>> searchEndConnDocList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, String> map) {
		logger.debug("searchEndConnDocList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<ApprGDocListVO> list = ezApprovalGKEDService.searchEndConnDocList(map.get("formID"), userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getId(), map.get("sDate"), map.get("eDate"));
		
		logger.debug("searchEndConnDocList ended");
		return new ResponseEntity<List<ApprGDocListVO>>(list, HttpStatus.OK);
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/selectKEDXmlInfo.do", method = RequestMethod.GET)
	public ResponseEntity<KEDXMLInfo> selectKEDXmlInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) {
		logger.debug("selectKEDXmlInfo started");
		KEDXMLInfo kedxmlInfo = new KEDXMLInfo();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		kedxmlInfo.setTenantID(userInfo.getTenantId());
		kedxmlInfo.setCompanyID(userInfo.getCompanyID());
		kedxmlInfo.setDocID(request.getParameter("docID"));
		kedxmlInfo.setFormtype(request.getParameter("formType"));
		
		KEDXMLInfo ret = ezApprovalGKEDService.selectKEDXmlInfo(kedxmlInfo);
		logger.debug("selectKEDXmlInfo ended");
		return new ResponseEntity<KEDXMLInfo>(ret, HttpStatus.OK);
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/saveKEDCancelRequest.do", method = RequestMethod.POST)
	public ResponseEntity<Void> saveKEDCancelRequest(@CookieValue("loginCookie") String loginCookie, @RequestBody KEDXMLInfo kedxmlInfo) {
		logger.debug("saveKEDCancelRequest started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		kedxmlInfo.setTenantID(userInfo.getTenantId());
		kedxmlInfo.setCompanyID(userInfo.getCompanyID());
		
		ezApprovalGKEDService.saveKEDCancelRequest(kedxmlInfo);
		logger.debug("saveKEDCancelRequest ended");
		return ResponseEntity.status(HttpStatus.CREATED).build();
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezApprovalG/updateKEDCancelRequest.do", method = RequestMethod.POST)
	public ResponseEntity<Void> updateKEDCancelRequest(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, String> map) {
		logger.debug("updateKEDCancelRequest started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		map.put("tenantID", String.valueOf(userInfo.getTenantId()));
		
		ezApprovalGKEDService.updateKEDCancelRequest(map);
		logger.debug("updateKEDCancelRequest ended");
		return ResponseEntity.status(HttpStatus.CREATED).build();
	}
	
	@RequestMapping(value = "/ezApprovalG/confirmPopup.do", method = RequestMethod.GET)
	public String confirmPopup(){
		return "ezApprovalG/apprGConfirmPopup";
	}
}
