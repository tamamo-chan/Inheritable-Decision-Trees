package decisiontree;

import java.util.ArrayList;
import java.util.List;
public class BankConclusion {
	
	BankDecision bank_decision = new BankDecision();
	BankParameter bank_param = new BankParameter();
	public List<String> begin(BankInput bank_input) {
	
		BankRules bank_rule = new BankRules(bank_input, bank_param);
		List<String> bank_nested = new ArrayList<>();
		
		String bank_response = bank_rule.setupRules();
		
		if (bank_response != null) {
			bank_nested.add(bank_response);
			return bank_nested;
		}
		
		if (bank_param.getGood() > 70 ) {
			bank_nested.add(bank_decision.getAccept());
			return bank_nested;
		}
		
		if (20 > bank_param.getGood() ) {
			bank_nested.add(bank_decision.getReject());
			return bank_nested;
		}
		
		if (bank_param.getGood() <= bank_param.getBad() ) {
			bank_nested.add(bank_decision.getReject());
			return bank_nested;
		}
		
		// Nested code
				
		if ( bank_param.getGood() > 55  ) {
			for (String s : bank_decision.getMaybe().getNestedValues()) {
				if (s.equals("get_more_credit")) {
					bank_nested.add(s);
				}
			}
		}
		
		if ( bank_param.getGood() < 45  ) {
			for (String s : bank_decision.getMaybe().getNestedValues()) {
				if (s.equals("recommend_reject")) {
					bank_nested.add(s);
				}
			}
		}
		
		if ( bank_param.getBad() > 0  ) {
			for (String s : bank_decision.getMaybe().getNestedValues()) {
				if (s.equals("recommend_reject")) {
					bank_nested.add(s);
				}
			}
		}
		
		if (bank_nested.size() < 1) {
			bank_nested.add("unsure");
		}
		
		return bank_nested;
		
		
	}
}
