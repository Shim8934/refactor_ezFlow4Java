package egovframework.ezEKP.ezPersonal.web;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.rest.Result;

@RestController
public class EzPersonalGWController {

	private static final Logger logger = LoggerFactory.getLogger(EzPersonalGWController.class);

	@Autowired
	private EzPersonalService ezPersonalService;

	@Autowired
	private LoginService loginService;

	/**
	 * 특정 사용자의 알림환경설정에서 특정 모듈의 비활성화킨 플랫폼 목록을 구한다. (jgw-server에서 사용)<br>
	 * code가 -1인 경우는 사용자가 알림을 받지 않는 시간이거나 받지않음으로 설정한 상태값이다.<br>
	 * @param mainType {@link NotiType} 참고
	 * @param subType {@link NotiType} 참고
	 */
	@GetMapping("/rest/ezPersonal/{userId:.+}/disable-notifications/platforms")
	public Result getPlatformsWithDisableNotification(@RequestHeader("x-user-host") String serverName, @PathVariable String userId, @RequestParam int mainType, @RequestParam int subType) {
		logger.debug("getPlatformsWithDisableNotification started. userId: {}, mainType: {}, subType: {}", userId, mainType, subType);
		Result result;

		try {
			int tenantId = loginService.getTenantId(serverName);

			NotiType notiType = NotiType.valueOf(mainType, subType);
			logger.debug("notiType: {}", notiType);
			List<Integer> disableItemList = ezPersonalService.getAllPlatformFromNotiDisableItem(userId, notiType, tenantId);
			if (!ezPersonalService.canReceiveNotification(userId, tenantId)) {
				if (disableItemList != null && disableItemList.contains(3)) {
					disableItemList.remove(disableItemList.indexOf(3));
				}
				
				disableItemList.add(3);
				
			}
			
			result = Result.success(disableItemList);
			
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result = Result.failure();
		}

		logger.debug("getPlatformsWithDisableNotification ended. result: {}", result);
		return result;
	}

}
