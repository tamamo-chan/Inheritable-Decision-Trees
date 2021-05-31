package decisiontree;
public class VIPInput extends BankInput {
	
	private int age;
	public int getAge() {
		return this.age;
	}
	
	private int years_employed;
	public int getYears_employed() {
		return this.years_employed;
	}
	
	private boolean employee;
	public boolean getEmployee() {
		return this.employee;
	}
	
	private boolean boss;
	public boolean getBoss() {
		return this.boss;
	}
	
	
	public VIPInput(int credit, boolean previous_loans, int age, int years_employed, boolean employee, boolean boss) {
		super(credit, previous_loans);
		this.age = age;
		this.years_employed = years_employed;
		this.employee = employee;
		this.boss = boss;
	}	
}
