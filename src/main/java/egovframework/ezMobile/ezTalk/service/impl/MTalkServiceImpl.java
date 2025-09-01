package egovframework.ezMobile.ezTalk.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezMobile.ezTalk.dao.MTalkDao;
import egovframework.ezMobile.ezTalk.service.MTalkService;
import egovframework.ezMobile.ezTalk.vo.MTalkNotification;

@Service
public class MTalkServiceImpl extends EgovAbstractServiceImpl implements MTalkService {

	private final MTalkDao mTalkDao;

	@Autowired
	public MTalkServiceImpl(MTalkDao mTalkDao) {
		this.mTalkDao = mTalkDao;
	}

	@Override
	public List<MTalkNotification> getNotificationsAndDelete(Integer limit) {
		List<MTalkNotification> result = mTalkDao.getNotifications(limit);
		if (!result.isEmpty()) {
			mTalkDao.updateBadgeCount(result);
			mTalkDao.deleteNotifications(result.stream().mapToInt(MTalkNotification::getId).toArray());
		}
		return result;
	}

}
