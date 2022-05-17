package egovframework.ezMobile.ezTalk.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezTalk.vo.MTalkNotification;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository
public class MTalkDao extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<MTalkNotification> getNotifications() {
		return (List<MTalkNotification>) list("MTalkDao.getNotifications");
	}

	public void deleteNotifications() {
		delete("MTalkDao.deleteNotifications");
	}

}
