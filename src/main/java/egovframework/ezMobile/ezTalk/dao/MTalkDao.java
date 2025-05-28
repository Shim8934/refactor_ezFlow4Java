package egovframework.ezMobile.ezTalk.dao;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.ezMobile.ezTalk.vo.MTalkDevice;
import egovframework.ezMobile.ezTalk.vo.MTalkNotification;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository
public class MTalkDao extends EgovAbstractDAO {

	private final SqlMapClient sqlMapClient;

	public MTalkDao(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	public List<MTalkNotification> getNotifications(Integer limit) {
		return (List<MTalkNotification>) list("MTalkDao.getNotifications", Collections.singletonMap("limit", limit));
	}

	public void deleteNotifications(int... itemSeqArray) {
		delete("MTalkDao.deleteNotifications", Collections.singletonMap("itemSeqArray", itemSeqArray));
	}
	
	public void updateBadgeCount(List<MTalkNotification> result) {

		try {
			Map<Integer, Integer> badgeCountMap = new HashMap<>();
			result.stream().map(MTalkNotification::getMgwDeviceInfo)
					.filter(devInfo -> devInfo != null && !devInfo.toString().isEmpty())
					.map(devInfo -> (MTalkDevice) devInfo).forEach(dev -> {
						try {
							sqlMapClient.update("MTalkDao.updateBadgeCount", dev.getId());
							int addCount = badgeCountMap.getOrDefault(dev.getId(), dev.getBadgeCount()) + 1;
							badgeCountMap.put(dev.getId(), addCount);
							dev.setBadgeCount(addCount);
						} catch (Exception e) {
							e.printStackTrace();
						}
					});
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
