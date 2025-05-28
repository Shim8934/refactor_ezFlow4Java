package egovframework.ezEKP.ezApprovalG.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGHistoryAttachVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGHistoryDocVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

/**
 * KlibService에서 전자결재문서 정보를 간단하게 가져오기 위한 DAO 클래스
 * 
 * @NOTE 기존의 DAO와 KLIB 전용 DAO 소스코드를 구분하면서 헷갈리지 않기 위한 것도 있고, KLIB로 암호화를 할 때 필요한
 *       컬럼만 뽑아서 자원을 효율적으로 쓰도록 만들었습니다.<br>
 *       <i>혹여나 파일을 나눌 필요 없이 기존의 DAO에 넣는다거나, 개선 사항이 있다면 수정해주시길 바랍니다.</i>
 * 
 * */
@Repository("EzApprovalGKlibDAO")
public class EzApprovalGKlibDAO extends EgovAbstractDAO {

	public String getEndDocHref(Map<String, Object> parameterMap) {
		return (String) select("EzApprovalGKlib.getEndDocHref", parameterMap);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGAttachInfoVO> getEndAttachInfoList(Map<String, Object> parameterMap) {
		return (List<ApprGAttachInfoVO>) list("EzApprovalGKlib.getEndAttachInfoList", parameterMap);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGHistoryDocVO> getHistoryDocList(Map<String, Object> parameterMap) {
		return (List<ApprGHistoryDocVO>) list("EzApprovalGKlib.getHistoryDocList", parameterMap);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGHistoryAttachVO> getHistoryAttachList(Map<String, Object> parameterMap) {
		return (List<ApprGHistoryAttachVO>) list("EzApprovalGKlib.getHistoryAttachList", parameterMap);
	}

	public void updateEndDocHref(Map<String, Object> parameterMap) {
		update("EzApprovalGKlib.updateEndDocHref", parameterMap);
	}

	public void updateEndAttachInfoHref(Map<String, Object> parameterMap) {
		update("EzApprovalGKlib.updateEndAttachInfoHref", parameterMap);
	}
	
	public void updateAprAttachInfoHref(Map<String, Object> parameterMap) {
		update("EzApprovalGKlib.updateAprAttachInfoHref", parameterMap);
	}

	public void updateTmpAttachInfoHref(Map<String, Object> parameterMap) {
		update("EzApprovalGKlib.updateTmpAttachInfoHref", parameterMap);
	}

	public void updateHistoryDocHref(Map<String, Object> parameterMap) {
		update("EzApprovalGKlib.updateHistoryDocHref", parameterMap);
	}

	public void updateHistoryAttachHref(Map<String, Object> parameterMap) {
		update("EzApprovalGKlib.updateHistoryAttachHref", parameterMap);
	}
}
