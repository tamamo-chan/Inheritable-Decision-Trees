package decisiontree;

public class VIPRules extends BankRules {
	VIPParameter vIP_param = null;
	VIPInput vIP_input = null;
	VIPDecision vIP_decision = new VIPDecision();
	
	public VIPRules(BankInput bank_input, BankParameter bank_param, VIPInput vIP_input, VIPParameter vIP_param) {
		super(bank_input, bank_param);
		this.vIP_input = vIP_input;
		this.vIP_param = vIP_param;
	}
	
	
	public String setupRules() {
		String vIP_super = super.setupRules();
		
		if (vIP_super != null) {
			return vIP_super;
		}
		
		if ( vIP_input.getAge() > 30  ) {
			vIP_param.setGood(vIP_param.getGood() + 30);
		}
		
		if ( vIP_input.getYears_employed() > 3  ) {
			vIP_param.setJob_exp(vIP_param.getJob_exp() + 10);
		}
		
		if ( vIP_input.getEmployee()  ) {
			vIP_param.setJob_exp(vIP_param.getJob_exp() + 20);
		}
		
		if ( vIP_input.getBoss()  ) {
			return vIP_decision.getAccept();
		}
		
		
		return null;
	}
}