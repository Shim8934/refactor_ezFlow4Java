package egovframework.ezEKP.ezEmail.service;

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
	 * 지정한 사용자의 암호를 새암호로 설정한다.
	 * @param userEmailAddress 새암호를 설정하고자 하는 User Account의 주
	 * @param newPassword 새암호
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 * @throws Exception
	 */
	public int updateUserPassword(String userEmailAddress, String newPassword) throws Exception;
	
	/**
	 * 지정한 사용자의 암호가 맞는 지 여부를 반환한다. 
	 * @param name
	 * @param password
	 * @return 암호가 맞으면 true, 맞지 않으면 false를 반환
	 */
	boolean testUserPassword(String userEmailAddress, String password) throws Exception;
	
	/**
	 * Email Server에서 지정한 User Account를 제거한다.
	 * @param userEmailAddress 제거하고자 하는 User Account의 Email 주소
	 * @return 성공 시 0, 에러 시 음수의 에러 코드를 반환
	 */
	public int removeUser(String userEmailAddress) throws Exception;
	
}
