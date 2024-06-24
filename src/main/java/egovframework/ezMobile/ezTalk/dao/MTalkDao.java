package egovframework.ezMobile.ezTalk.dao;

import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezTalk.vo.MTalkNotification;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository
public class MTalkDao extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<MTalkNotification> getNotifications(Integer limit) {
		return (List<MTalkNotification>) list("MTalkDao.getNotifications", Collections.singletonMap("limit", limit));
	}

	public void deleteNotifications(int... itemSeqArray) {
		delete("MTalkDao.deleteNotifications", Collections.singletonMap("itemSeqArray", itemSeqArray));
	}

}
