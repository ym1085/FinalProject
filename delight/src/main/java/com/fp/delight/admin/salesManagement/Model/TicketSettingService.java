package com.fp.delight.admin.salesManagement.Model;

import java.util.List;
import java.util.Map;

import com.fp.delight.common.SearchVO;

public interface TicketSettingService {
	int insertticket(TicketSettingVO ticketSettingVo);
	List<Map<String, Object>> selticket(SearchVO searchVo);
	int settingtotal(SearchVO searchVo);
	TicketDiscountVO seldiscountByseq(int ticketSeq);
	int discountInsert(TicketDiscountVO ticketDiscountVo);
	int discountUpdate(TicketDiscountVO ticketDiscountVo);
}
