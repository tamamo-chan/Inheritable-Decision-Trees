package decisiontree;

import java.util.ArrayList;
import java.util.List;

public class BankMain {
	
    private static boolean handleBool(String s) {
         if (s.equals("true") || s.equals("1") || s.equals("True") || s.equals("TRUE")) {
             return true;
         } else {
             return false;
         }
    }
    
    public static void main(String[] args){
    
    
    	assert(args.length == 2);
    
        int credit = 0;
        try {
        	credit = Integer.parseInt(args[0]);
        }
        catch (NumberFormatException nfe) {
        	System.out.println("The first argument must be an integer.");
        	System.exit(1);
        }
        
        boolean previous_loans = handleBool(args[1]);
        
    
    
        BankInput input = new BankInput(credit, previous_loans);
        BankConclusion conclusion = new BankConclusion();
        List<String> results = conclusion.begin(input);
        
        for (String s : results) {
        	System.out.println(s);
        }
    }
}  
