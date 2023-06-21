package egovframework.ezMobile.ezTalk.web;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezMobile.ezTalk.service.MTalkService;
import egovframework.ezMobile.ezTalk.vo.MTalkNotification;
import egovframework.ezMobile.ezTalk.vo.MTalkResult;

@RestController
public class MTalkGWController {

	private static final Logger logger = LoggerFactory.getLogger(MTalkGWController.class);

	private final MTalkService mTalkService;

	@Autowired
	public MTalkGWController(MTalkService mTalkService) {
		this.mTalkService = mTalkService;
	}

	@GetMapping("/rest/eztalk/notilist")
	public MTalkResult getNotifications(@RequestParam Optional<Integer> limit) {
		logger.debug("MOBILE G/W TALK [GET /rest/eztalk/notilist] started.");

		try {
			List<MTalkNotification> notifications = mTalkService.getNotificationsAndDelete(limit.orElse(null));
			return MTalkResult.success(notifications);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return MTalkResult.failure();
		} finally {
			logger.debug("MOBILE G/W TALK [GET /rest/eztalk/notilist] ended.");
		}
	}

}
