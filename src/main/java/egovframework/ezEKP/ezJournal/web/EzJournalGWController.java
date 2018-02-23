package egovframework.ezEKP.ezJournal.web;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezJournal.vo.DeptViewVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.ezEKP.ezJournal.vo.ReceiverFavoriteVO;
import egovframework.ezMobile.ezApprovalG.web.MApprovalGGWController;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzJournalGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MApprovalGGWController.class);

	@Autowired
	private EzJournalService ezJournalService;
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	/**
	 * 업무일지 G/W [GET] 일지함 조회 / 사용하는 일지함 조회
	 */
	@RequestMapping(value = "/restezjournal/types", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Object journalTypeList(HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W JOURNAL [GET /restezjournal/types] started.");
		
		JSONObject result = new JSONObject();
		
		String companyId = request.getParameter("companyId");
		String tenantId = request.getParameter("tenantId");
		String used = request.getParameter("used");
		
		LOGGER.debug("companyId : " + companyId);
		LOGGER.debug("tenantId : " + tenantId);
		
		try {
			List<JournaltypeVO> typeList = ezJournalService.getJournaltypeList(companyId, tenantId,used);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", typeList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}

		LOGGER.debug("G/W JOURNAL [GET /restezjournal/types] ended.");
		
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 일지함 사용여부 수정
	 */
	@RequestMapping(value = "/restezjournal/types", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public Object journalTypeUpdate(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W JOURNAL [PUT /restezjournal/types] started.");
		JSONObject result = new JSONObject();

		String tenantId = (String) jsonParam.get("tenantId");
		String companyId = (String) jsonParam.get("companyId");
		@SuppressWarnings("unchecked")
		ArrayList<Map<String, String>> journaltypeList = (ArrayList<Map<String, String>>) jsonParam.get("journaltypeList");
		
		try {
			ezJournalService.updateJournaltype(journaltypeList, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}

		LOGGER.debug("G/W JOURNAL [PUT /restezjournal/types] ended.");
		
		return result;
	}	
	
	/**
	 * 업무일지 G/W [GET] 양식 리스트 조회 / 부서사용가능 양식리스트 조회 / 취합가능 양식리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/restezjournal/types/{typeId}/forms", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object journalFormList(HttpServletRequest request, @PathVariable String typeId) throws Exception {
		LOGGER.debug("ezJournal G/W journalFormList started.");
		LOGGER.debug("typeId=" + typeId);

		JSONObject result = new JSONObject();
		
		try {
			String companyId = request.getParameter("companyId");
			String tenantId = request.getParameter("tenantId");
			String deptId = request.getParameter("deptId");

			List<JournalFormInfoVO> formList = ezJournalService.getFormList(typeId, deptId, companyId, tenantId);
			
			result.put("data", formList);
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezJournal G/W journalFormList ended.");
		
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 양식 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/restezjournal/types/{typeId}/forms", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject insertForm(@PathVariable String typeId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W insertForm started.");
		LOGGER.debug("typeId=" + typeId);
		
		JSONObject result = new JSONObject();
		
		try {
			
			ezJournalService.insertForm(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			
		}
		
		LOGGER.debug("ezJournal G/W insertForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 양식 수정
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/forms/{formId}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateForm(@PathVariable String typeId, @PathVariable String formId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W updateForm started.");
		LOGGER.debug("typeId=" + typeId + ",formId=" + formId);
		
		JSONObject result = new JSONObject();
		
		try {
			String companyId = request.getParameter("companyId");
			String tenantId	= request.getParameter("tenantId");
			
			ezJournalService.updateJournalForm(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch(Exception e) {
			result.put("status", "error");
			result.put("code", 1);
		}
		
		LOGGER.debug("ezJournal G/W updateForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 양식 삭제
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/forms/{formId}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteForm(@PathVariable String typeId, @PathVariable String formId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteForm started.");
		LOGGER.debug("typeId=" + typeId + ",formId=" + formId);
		
		JSONObject result = new JSONObject();
		
		try {
			String companyId = request.getParameter("companyId");
			String tenantId = request.getParameter("tenantId");
			
			ezJournalService.deleteJournalForm(formId, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W deleteForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 양식 상세 보기
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/forms/{formId}", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject viewForm(@PathVariable String typeId, @PathVariable String formId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W viewForm started.");
		LOGGER.debug("typeId=" + typeId + ",formId=" + formId);
		
		JSONObject result = new JSONObject();
		
		try {
			String tenantId = request.getParameter("tenantId");
			String companyId = request.getParameter("companyId");
			
			LOGGER.debug("tenantId : " + tenantId + ", companyId : " + companyId);
			
			JournalFormInfoVO journalFormInfoVO = ezJournalService.getJournalFormInfo(formId, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", journalFormInfoVO);
		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
		}
		
		LOGGER.debug("ezJournal G/W viewForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 열람권한 리스트
	 */
	@RequestMapping(value="/restezjournal/authors", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject authorsList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W authorsList started.");
		
		JSONObject result = new JSONObject();
		String companyId = request.getParameter("companyId");
		String tenantId = request.getParameter("tenantId");
		
		try {
			List<JournalAuthorVO> authList = ezJournalService.getAuthorList(companyId, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", authList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}
		
		LOGGER.debug("ezJournal G/W authorsList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 열람권한 상세정보
	 */
	@RequestMapping(value="/restezjournal/users/{userId}/author-depts", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject authorDepts(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W authorDepts started.");
		LOGGER.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		String tenantId = request.getParameter("tenantId");
		
		try {
			List<JournalAuthorVO> deptList = ezJournalService.getAuthDeptList(tenantId, userId);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", deptList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}
		
		LOGGER.debug("ezJournal G/W authorDepts ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 열람권한 저장
	 */
	@RequestMapping(value="/restezjournal/authors", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject insertAuthorDepts(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W insertAuthorDepts started.");
		JSONObject result = new JSONObject();
		
		try {
			ezJournalService.saveAuthDeptList(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			
		}
		LOGGER.debug("ezJournal G/W insertAuthorDepts ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 열람권한 삭제
	 */
	@RequestMapping(value="/restezjournal/authors", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteAuthorDepts(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteAuthorDepts started.");
		
		JSONObject result = new JSONObject();
		LOGGER.debug(request.getParameter("userId")+request.getParameter("tenantId"));
		try {
			ezJournalService.deleteAuthor(request.getParameter("userId"), request.getParameter("tenantId"));
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			
		}
		
		LOGGER.debug("ezJournal G/W deleteAuthorDepts ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 업무일지 리스트 (일일,주간,월간,분기,반기,연간,다른일지가져오기)
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject typeJournalList(@PathVariable String typeId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W typeJournalList started.");
		LOGGER.debug("typeId=" + typeId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W typeJournalList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 업무일지 리스트 (수신일지함, 임시보관함)
	 */
	@RequestMapping(value="/restezjournal/journals", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject folderJournalList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W folderJournalList started.");
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W folderJournalList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 업무일지 저장
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject insertJournal(@PathVariable String typeId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W insertJournal started.");
		LOGGER.debug("typeId=" + typeId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W insertJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지 취합 후 내용 리턴 (금일, 익일 부분)
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals-sum", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject journalsSumContent(@PathVariable String typeId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W journalsSumContent started.");
		LOGGER.debug("typeId=" + typeId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W journalsSumContent ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 업무일지 조회
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject viewJournal(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W viewJournal started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W viewJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 업무일지 수정
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateJournal(@PathVariable String typeId, @PathVariable String journalId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W updateJournal started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W updateJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 업무일지 삭제
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteJournal(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteJournal started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W deleteJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 업무일지 읽음 처리
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/readers/{userId}", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject readJournal(@PathVariable String typeId, @PathVariable String journalId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W readJournal started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId + ",userId=" + userId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W readJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 수신 확인 처리
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/receivers/{userId}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject receiveOKJournal(@PathVariable String typeId, @PathVariable String journalId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W receiveOKJournal started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId + ",userId=" + userId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W receiveOKJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 첨부파일 업로드
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/attachfiles", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject uploadFile(@PathVariable String typeId, @PathVariable String journalId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W uploadFile started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W uploadFile ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 첨부파일 리스트
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/attachfiles", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject attachList(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W attachList started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W attachList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 첨부파일 삭제
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/attachfiles", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteFile(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteFile started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W deleteFile ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 첨부파일 다운로드
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/attachfiles/{fileId}", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject downloadFile(@PathVariable String typeId, @PathVariable String journalId, @PathVariable String fileId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W downloadFile started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId + ",fileId=" + fileId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W downloadFile ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 일지 수신자 저장
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/receivers", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveReceiver(@PathVariable String typeId, @PathVariable String journalId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W saveReceiver started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W saveReceiver ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지 수신자 리스트 
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/receivers", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getReceiverList(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getReceiverList started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W getReceiverList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 일지 수신자 삭제
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/receivers", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteReceiver(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteReceiver started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W deleteReceiver ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 수신자 즐겨찾기 리스트
	 */
	@RequestMapping(value="/restezjournal/users/{userId}/favorites", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getFavoriteList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getFavoriteList started.");
		LOGGER.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		String tenantId = request.getParameter("tenantId");
		
		try {
			List<ReceiverFavoriteVO> favoriteList = ezJournalService.getFavoriteList(userId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", favoriteList);
			
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}
		
		LOGGER.debug("ezJournal G/W getFavoriteList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 수신자 즐겨찾기 저장
	 */
	@RequestMapping(value="/restezjournal/users/{userId}/favorites", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveFavorite(@PathVariable String userId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W saveFavorite started.");
		LOGGER.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();

		try {
			ezJournalService.saveFavorite(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			
		}
		
		LOGGER.debug("ezJournal G/W saveFavorite ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 수신자 즐겨찾기 수정
	 */
	@RequestMapping(value="/restezjournal/users/{userId}/favorites/{favoriteId}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateFavorite(@PathVariable String userId, @PathVariable String favoriteId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W updateFavorite started.");
		LOGGER.debug("userId=" + userId + ",favoriteId=" + favoriteId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W updateFavorite ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 수신자 즐겨찾기 삭제
	 */
	@RequestMapping(value="/restezjournal/users/{userId}/favorites/{favoriteId}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteFavorite(@PathVariable String userId, @PathVariable String favoriteId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteFavorite started.");
		LOGGER.debug("userId=" + userId + ",favoriteId=" + favoriteId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W deleteFavorite ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 수신자 즐겨찾기 유저 리스트
	 */
	@RequestMapping(value="/restezjournal/users/{userId}/favorites/{favoriteId}/users", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getFavoriteUserList(@PathVariable String userId, @PathVariable String favoriteId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getFavoriteUserList started.");
		LOGGER.debug("userId=" + userId + ",favoriteId=" + favoriteId);
		
		JSONObject result = new JSONObject();
		String tenantId = request.getParameter("tenantId");
		
		try {
			List<JournalAuthorVO> userList = ezJournalService.getFavoriteUserList(favoriteId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userList);
			
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}
		
		LOGGER.debug("ezJournal G/W getFavoriteUserList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 댓글 리스트 조회
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/replies", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getReplies(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getReplies started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W getReplies ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 댓글 저장
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/replies", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveReply(@PathVariable String typeId, @PathVariable String journalId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W saveReply started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W saveReply ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 댓글 수정
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/replies/{replyId}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateReply(@PathVariable String typeId, @PathVariable String journalId, @PathVariable String replyId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W updateReply started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId + ",replyId=" + replyId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W updateReply ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 댓글 삭제
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/replies/{replyId}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteReply(@PathVariable String typeId, @PathVariable String journalId, @PathVariable String replyId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteReply started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId + ",replyId=" + replyId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W deleteReply ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 댓글 수 카운트
	 */
	@RequestMapping(value="/restezjournal/types/{typeId}/journals/{journalId}/replies-count", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getReplyCount(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getReplyCount started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W getReplyCount ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지 수 카운트
	 */
	@RequestMapping(value="/restezjournal/journals-count", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getJournalsCount(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getJournalsCount started.");
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W getJournalsCount ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 환경설정 정보 저장
	 */
	@RequestMapping(value="/restezjournal/users/{userId}/options", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveOption(@PathVariable String userId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W saveOption started.");
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W saveOption ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 환경설정 정보 수정
	 */
	@RequestMapping(value="/restezjournal/users/{userId}/options", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateOption(@PathVariable String userId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W updateOption started.");
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W updateOption ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 환경설정 정보 조회
	 */
	@RequestMapping(value="/restezjournal/users/{userId}/options", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getOption(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getOption started.");
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W getOption ended.");
		return result;
	}
	
	// 공통 부분 API
	/**
	 * 업무일지 G/W [GET] 회사리스트 
	 */
	@RequestMapping(value="/restezjournal/companies", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getCompanyList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getCompanyList started.");
		
		JSONObject result = new JSONObject();
		
		String userId = request.getParameter("userId");
		String tenantId = request.getParameter("tenantId");
		String companyId = request.getParameter("companyId");
		
		try {
			List<JournalCompanyVO> compList = ezJournalService.getCompanyList(userId, tenantId,companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", compList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}
		
		LOGGER.debug("ezJournal G/W getCompanyList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 부서리스트 
	 */
	@RequestMapping(value="/restezjournal/depts", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getDeptList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getDeptList started.");
		
		JSONObject result = new JSONObject();
		
		String userId = request.getParameter("userId");
		String tenantId = request.getParameter("tenantId");
		String companyId = request.getParameter("companyId");
		
		LOGGER.debug("userId : "+userId);
		LOGGER.debug("tenantId : "+tenantId);
		LOGGER.debug("companyId : "+companyId);
		try {
			List<DeptViewVO> deptList = ezJournalService.getDeptViewList(userId,companyId,tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", deptList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}
		
		LOGGER.debug("ezJournal G/W getDeptList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 사원리스트 
	 */
	@RequestMapping(value="/restezjournal/users", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getUserList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getUserList started.");
		
		JSONObject result = new JSONObject();
		
		String tenantId = request.getParameter("tenantId");
		String key = request.getParameter("key");
		String value = request.getParameter("value");
		
		try {
			List<JournalAuthorVO> userList = ezJournalService.getDeptUserList(tenantId, key,value);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}
		
		LOGGER.debug("ezJournal G/W getUserList ended.");
		return result;
	}
}
