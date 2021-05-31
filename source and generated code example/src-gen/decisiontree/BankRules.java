package decisiontree;

public class BankRules {
	BankParameter bank_param = null;
	BankInput bank_input = null;
	BankDecision bank_decision = new BankDecision();
	
	public BankRules(BankInput bank_input, BankParameter bank_param) {
		this.bank_input = bank_input;
		this.bank_param = bank_param;
	}
	
	
	public String setupRules() {
		
		if ( bank_input.getCredit() > 6000  ) {
			bank_param.setGood(bank_param.getGood() + 21);
		}
		
		if ( bank_input.getCredit() > 5000  ) {
			bank_param.setGood(bank_param.getGood() + 50);
		}
		
		if ( bank_input.getPrevious_loans()  ) {
			return bank_decision.getReject();
		}
		
		if ( bank_input.getCredit() <= 1000  ) {
			bank_param.setBad(bank_param.getBad() + 40);
		}
		
		
		return null;
	}
}