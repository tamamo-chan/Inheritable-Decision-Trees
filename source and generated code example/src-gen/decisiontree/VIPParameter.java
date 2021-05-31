package decisiontree;
public class VIPParameter extends BankParameter {
	
	private int job_exp = 0;
	public int getJob_exp() {
		return this.job_exp;
	}
	public void setJob_exp(int value) {
		this.job_exp = value;
	}
	
	
	public VIPParameter(int job_exp) {
		super(10, 0);
		this.job_exp = job_exp;
	}
	
	public VIPParameter() {
		super();
		this.job_exp = job_exp;
	}
}