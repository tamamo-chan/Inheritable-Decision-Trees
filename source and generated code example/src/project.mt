Bank ( 
	Decisions: accept, reject, maybe(get_more_credit, customer_account_age_too_low, recommend_reject, unsure)

	Input: int credit, bool previous_loans
	
	Parameters:
	good=0
	bad = 0
	
	Rules:
	if credit > 1000 + 5000? add 21 to good  
	if credit > 5000? add 50 to good  
	if previous_loans? conclude reject  
	if credit <= 1000? add 40 to bad
	
	Conclusion:       
	if good > 70: conclude accept    
	if 20 > good: conclude reject       
	if good <= bad: conclude reject                
	if maybe(
	if good > 55: conclude get_more_credit
	if good < 45: conclude recommend_reject
	if bad > 0: conclude recommend_reject    
	else: unsure           
	)       	  
)
VIP extends Bank (
	Decisions: approve, not_reasonable 
	
	Input: int age, int years_employed, bool employee, bool boss 
	 
	Parameters:
	good = 10     
	job_exp = 0
	
	Rules: 
	if age > 30? add 30 to good 
	if years_employed > 3? add 10 to job_exp 
	if employee? add 20 to job_exp   
	if boss? conclude accept   
	
	Conclusion:
	if good < 20 : conclude not_reasonable
	if good > 20 : conclude accept   
	else: reject   
)