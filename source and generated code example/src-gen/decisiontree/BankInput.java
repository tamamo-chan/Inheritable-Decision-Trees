package decisiontree;
public class BankInput {
	
	private int credit;
	public int getCredit() {
		return this.credit;
	}
	
	private boolean previous_loans;
	public boolean getPrevious_loans() {
		return this.previous_loans;
	}
	
	
	public BankInput(int credit, boolean previous_loans) {
		this.credit = credit;
		this.previous_loans = previous_loans;
	}	
}
