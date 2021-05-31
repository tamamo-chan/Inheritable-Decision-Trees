package decisiontree;

import java.util.List;
import java.util.ArrayList;
public class BankDecision {
	
	private String _accept = "accept";
	public String getAccept() {
		return this._accept;
	}
	
	private String _reject = "reject";
	public String getReject() {
		return this._reject;
	}
	
	private Maybe maybe = new Maybe();
	
	public Maybe getMaybe() {
		return this.maybe;
	}
	
	public class Maybe {
		private List<String> nested_values;
		public List<String> getNestedValues() {
			return this.nested_values;
		}
		
		public Maybe() {
			nested_values = new ArrayList<>();
			nested_values.add("get_more_credit");
			nested_values.add("customer_account_age_too_low");
			nested_values.add("recommend_reject");
			nested_values.add("unsure");
		}
	}
	
}
