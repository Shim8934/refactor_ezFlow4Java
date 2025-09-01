package egovframework.ezEKP.ezSchedule.service.impl;

import java.util.Comparator;

import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;

public class EzScheduleCompareUtil implements Comparator<ScheduleInfoVO> {

	@Override
	public int compare(ScheduleInfoVO o1, ScheduleInfoVO o2) {
		// dateType을 DESC 정렬
		int dateTypeComparison = o2.getDateType().compareTo(o1.getDateType());
		if (dateTypeComparison != 0) {
			return dateTypeComparison;
		}

		// startDate로 ASC 정렬
		if (o1.getStartDate().compareTo(o2.getStartDate()) == 0) {
			// endDate로 ASC 정렬
			if (o1.getEndDate().compareTo(o2.getEndDate()) == 0) {
				// title로 ASC 정렬
				return o1.getTitle().compareTo(o2.getTitle());
			} else {
				return o1.getEndDate().compareTo(o2.getEndDate());
			}
		} else {
			return o1.getStartDate().compareTo(o2.getStartDate());
		}
	}	
	
}