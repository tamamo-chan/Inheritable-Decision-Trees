package decisiontree;

import java.util.List;
import java.util.ArrayList;
public class VIPDecision extends BankDecision {
	
	private String _approve = "approve";
	public String getApprove() {
		return this._approve;
	}
	
	private String _not_reasonable = "not_reasonable";
	public String getNot_reasonable() {
		return this._not_reasonable;
	}
	
	
}
