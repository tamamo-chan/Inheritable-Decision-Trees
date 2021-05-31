package decisiontree;

import java.util.ArrayList;
import java.util.List;
public class VIPConclusion {
	
	VIPDecision vIP_decision = new VIPDecision();
	VIPParameter vIP_param = new VIPParameter();
	public List<String> begin(VIPInput vIP_input) {
	
		VIPRules vIP_rule = new VIPRules(vIP_input, vIP_param, vIP_input, vIP_param);
		List<String> vIP_nested = new ArrayList<>();
		
		String vIP_response = vIP_rule.setupRules();
		
		if (vIP_response != null) {
			vIP_nested.add(vIP_response);
			return vIP_nested;
		}
		
		if (vIP_param.getGood() < 20 ) {
			vIP_nested.add(vIP_decision.getNot_reasonable());
			return vIP_nested;
		}
		
		if (vIP_param.getGood() > 20 ) {
			vIP_nested.add(vIP_decision.getAccept());
			return vIP_nested;
		}
		
		if (vIP_nested.size() < 1) {
			vIP_nested.add("reject");
		}
		
		return vIP_nested;
	}
}
