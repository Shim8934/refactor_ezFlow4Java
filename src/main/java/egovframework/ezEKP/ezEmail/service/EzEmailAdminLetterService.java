package egovframework.ezEKP.ezEmail.service;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public interface EzEmailAdminLetterService {
	
	/**
	 * 전체 편지지함 목록 조회(기본)
	 */
	public JSONArray selectAllLetterBox() throws Exception;
	
	/**
	 * 선택한 편지지함 조회
	 * @param letterbox_no
	 */
	public JSONObject selectOneLetterBox(String letterbox_no) throws Exception;
	
	/**
	 * 편지지함 추가
	 * @param parent_letterbox_no, displayname, displayname2, company_id
	 */
	public void insertLetterBox(String parent_letterbox_no, String displayname, String displayname2, String company_id) throws Exception;
	
	/**
	 * 편지지함 삭제 
	 * @param letterbox_no
	 */
	public void deleteLetterBox(String letterbox_no) throws Exception;
	
	/**
	 * 편지지함 수정
	 * @param String letterbox_no, String parent_letterbox_no, String displayname, String displayname2, String company_id
	 */
	public void updateLetterBox(String letterbox_no, String parent_letterbox_no, String displayname, String displayname2, String company_id) throws Exception;
	
	/**
	 * 편지지 순서 조회 (재은)
	 */
	public JSONArray selectLetterOrder() throws Exception;
	
	/**
	 * 편지지 검색 (재은)
	 * @param searchStr
	 */
	public JSONArray searchLetter(String search) throws Exception;
	
	/**
	 * 편지지 추가 (수아)
	 * @param displayname, displayname2, letterBoxNo (편지지 이름, 편지지 이름 영문, 편지지함 번호)
	 * */
	public void addLetter(String displayname, String displayname2, String letterBoxNo) throws Exception;
	
	/**
	 * 편지지 수정 - 편지지 이름 (수아)
	 * @param displayname, displayname2, letterNo (편지지 이름, 편지지 이름 영문, 편지지 번호)
	 */
	public void updateDisplayNameLetter(String displayname, String displayname2, String letterNo) throws Exception;

	/**
	 * 편지지 수정 - 편지지 순서 (수아)
	 * @param letterOrder, letterNo (편지지 순서, 편지지 번호)
	 */
	public void updateOrderLetter(String letterOrder, String letterNo) throws Exception;

	/**
	 * 편지지 수정 - 편지지함 (수아)
	 * @param letterNo, letterBoxNo (편지지 번호, 편지지함 번호)
	 */
	public void updateBoxLetter(String letterNo, String letterBoxNo) throws Exception;
	
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
