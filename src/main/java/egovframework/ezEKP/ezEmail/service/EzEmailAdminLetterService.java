package egovframework.ezEKP.ezEmail.service;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public interface EzEmailAdminLetterService {
	
	/**
	 * 전체 편지지함 목록 조회(기본)
	 * @param companyId, companyId
	 */
	public JSONArray selectAllLetterBox(String companyId, String tenantId) throws Exception;
	
	/**
	 * 선택한 편지지함 조회
	 * @param letterBoxNo
	 */
	public JSONObject selectOneLetterBox(String letterboxNo) throws Exception;
	
	/**
	 * 편지지함명 조회
	 * @param letterBoxNo
	 */
	public JSONObject selectLetterBoxName(String letterboxNo, String userLang) throws Exception;
	
	/**
	 * 편지지함 추가
	 * @param parentLetterboxNo, displayname, displayname2, companyId, tenantId
	 */
	public void insertLetterBox(String parentLetterboxNo, String displayname, String displayname2, String companyId, String tenantId) throws Exception;
	
	/**
	 * 편지지함 삭제 
	 * @param letterBoxNo
	 */
	public void deleteLetterBox(String letterboxNo) throws Exception;
	
	/**
	 * 편지지함 수정
	 * @param letterBoxNo, parentLetterboxNo, displayname, displayname2, companyId, tenantId
	 */
	public void updateLetterBox(String letterboxNo, String parentLetterboxNo, String displayname, String displayname2, String companyId, String tenantId) throws Exception;
	
	/**
	 * 편지지 순서 수정 (재은)
	 * @param letterOrder, letterNo
	 */
	public void updateLetterOrder(String letterOrder, String letterNo) throws Exception;
	
	/**
	 * 편지지 편지지함 이동
	 * @param letterNo, parentLetterBoxNo
	 */
	public void updateLetterMove(String letterNo, String parentLetterBoxNo) throws Exception;
	
	/**
	 * 편지지 검색 (재은)
	 * @param searchStr, companyId, tenantId, userLang
	 */
	public JSONArray searchLetter(String search, String companyId, String tenantId, String userLang) throws Exception;
	
	/**
	 * 편지지 추가 (수아)
	 * @param displayname, displayname2, letterBoxNo (편지지 이름, 편지지 이름 영문, 편지지함 번호, 편지지아이디)
	 * */
	public void addLetter(String displayname, String displayname2, String letterBoxNo, String letterId) throws Exception;
	
	/**
	 * 편지지 수정 - 편지지 이름 (수아)
	 * @param displayname, displayname2, letterNo (편지지 이름, 편지지 이름 영문, 편지지 번호)
	 */
	public void updateDisplayNameLetter(String displayname, String displayname2, String letterNo) throws Exception;

	/**
	 * 편지지 삭제 (수아)
	 * @param letterNo (편지지 번호)
	 */
	public void deleteLetter(String letterNo) throws Exception;

	/**
	 * 편지지 목록 조회 (수아)
	 * @param letterBoxNo (편지지함 번호)
	 */
	public JSONArray selectAllLeter(String letterBoxNo) throws Exception;

	/**
	 * 편지지 개별 조회 (수아)
	 * @param letterNo (편지지 번호)
	 */
	public JSONObject selectDetailLetter(String letterNo) throws Exception;
	
}
