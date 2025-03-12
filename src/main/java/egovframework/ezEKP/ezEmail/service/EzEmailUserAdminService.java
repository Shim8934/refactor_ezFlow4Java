package egovframework.ezEKP.ezEmail.service;

import java.util.List;
import java.util.Locale;

/**
 * Email Server의 User Account를 관리할 수 있는 기능을 제공한다.
 * 
 * @author dhlee
 *
 */
public interface EzEmailUserAdminService {

	/**
	 * Email Server에 User Account를 생성한다. 
	 * @param userEmailAddress 생성하고자 하는 User Account의 Email 주소
	 * @param password 암호
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int addUser(String userEmailAddress, String password) throws Exception;

	/**
	 * Email Server에 특정 사용자의 계정이 있는 지 검사한다. 
	 * @param userEmailAddress 검사하고자 하는 사용자의 Email 주소
	 * @return 0은 사용자가 존재하지 않음을 의미. 1은 유효한 사용자. 2는 퇴직자를 의미.
	 */
	public int checkUserExists(String userEmailAddress) throws Exception;
	
	/**
	 * 지정한 사용자의 암호를 새암호로 설정한다.
	 * @param userEmailAddress 새암호를 설정하고자 하는 User Account의 Email 주소
	 * @param newPassword 새암호
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 * @throws Exception
	 */
	public int updateUserPassword(String userEmailAddress, String newPassword) throws Exception;

	/**
	 * 현재 암호를 확인한 후 새암호로 설정한다.
	 * @param userEmailAddress 새암호를 설정하고자 하는 User Account의 Email 주소
	 * @param curPassword 현재 암호
	 * @param newPassword 새암호
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 * @throws Exception
	 */
	public int checkAndUpdateUserPassword(String userEmailAddress, String curPassword, String newPassword) throws Exception;
	
	/**
	 * 지정한 사용자의 암호(Encrypt된)를 반환한다.
	 * @param userEmailAddress 암호를 반환하고자 하는 User Account의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 * @throws Exception
	 */
	public String getEncryptedUserPassword(String userEmailAddress) throws Exception;

	/**
	 * 지정한 사용자의 암호를 새암호로 설정한다.
	 * @param userEmailAddress 새암호를 설정하고자 하는 User Account의 Email 주소
	 * @param newPassword 새암호
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 * @throws Exception
	 */
	public int updateUserPasswordWithEncryptedPassword(String userEmailAddress, String encryptedPassword) throws Exception;
	
	/**
	 * 지정한 사용자의 암호가 맞는 지 여부를 반환한다. 
	 * @param name
	 * @param password
	 * @return 암호가 맞으면 true, 맞지 않으면 false를 반환
	 */
	boolean testUserPassword(String userEmailAddress, String password) throws Exception;
	
	/**
	 * Email Server에서 지정한 User Account를 제거한다.
	 * User Table(Retired User Table 포함)에서만 제거되고 해당 User의 메일박스는 제거되지 않는다.
	 * @param userEmailAddress 제거하고자 하는 User Account의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int removeUser(String userEmailAddress) throws Exception;

	/**
	 * Email Server에서 지정한 User의 메일박스들을 모두 제거한다.
	 * @param userEmailAddress 메일박스를 제거하고자 하는 User Account의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int removeUserAllMailboxes(String userEmailAddress) throws Exception;
	
	/**
	 * Email Server에서 지정한 User Account를 퇴직자 처리한다.
	 * @param userEmailAddress Retire 하고자 하는 User Account의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int retireUser(String userEmailAddress) throws Exception;

	/**
	 * Email Server에서 지정한 퇴직자를 복구 처리한다.
	 * @param userEmailAddress Retire 하고자 하는 User Account의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int restoreUser(String userEmailAddress) throws Exception;
	
	/**
	 * Email Server에 Group(Company or Department) Account를 생성한다. 
	 * @param groupEmailAddress 생성하고자 하는 Group Account의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int addGroup(String groupEmailAddress) throws Exception;
	
	/**
	 * Email Server에서 지정한 Group Account를 제거한다.
	 * @param groupEmailAddress 제거하고자 하는 Group Account의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int removeGroup(String groupEmailAddress) throws Exception;
	
	/**
	 * Email Server에서 Group의 멤버를 추가한다.
	 * @param groupEmailAddress 추가하고자 하는 Group의 Email 주소
	 * @param targetEmail 추가할 멤버의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int updateGroupAdd(String groupEmailAddress, String targetEmail) throws Exception;
	
	/**
	 * Email Server에서 Group의 멤버를 삭제한다.
	 * @param groupEmailAddress 삭제하고자 하는 Group의 Email 주소
	 * @param targetEmail 삭제할 멤버의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int updateGroupDel(String groupEmailAddress, String targetEmail) throws Exception;
	
	/**
	 * Email Server에서 지정한 멤버를 oldGroup에서 newGroup으로 이동한다.
	 * @param oldgroupEmailAddress oldGroup의 Email 주소
	 * @param newgroupEmailAddress newGroup의 Email 주소
	 * @param targetEmail Group을 이동할 멤버의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int updateGroupMove(String oldGroupEmailAddress, String newGroupEmailAddress, String targetEmail) throws Exception;
	
	public List<String> getUserDistributionList (String userEmailAddress) throws Exception;
	
	public int saveMailCopyright(String copyrightText, String useCopyright, int tenantId, String companyId) throws Exception;
	
	public String getCopyrightText(int tenantId, String companyId) throws Exception;

	public int deleteAllUserDistributionForMember(String targetEmail, String domain) throws Exception;

	public void setMailCancelSend(int tenantId, String primary, String pMessageId, String pUserId, String pSubject, List<String> pInnerAddresses, Locale locale, String eachCancel) throws Exception;

	public int removeUserMailSetting(String userEmailAddress) throws Exception;

	public int checkUserPrimaryMail(String userEmailAddress, int tenantId) throws Exception;

}
