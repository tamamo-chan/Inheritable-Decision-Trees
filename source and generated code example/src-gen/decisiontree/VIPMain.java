package decisiontree;

import java.util.ArrayList;
import java.util.List;

public class VIPMain {
	
    private static boolean handleBool(String s) {
         if (s.equals("true") || s.equals("1") || s.equals("True") || s.equals("TRUE")) {
             return true;
         } else {
             return false;
         }
    }
    
    public static void main(String[] args){
    
    
    	assert(args.length == 6);
    
        int credit = 0;
        try {
        	credit = Integer.parseInt(args[0]);
        }
        catch (NumberFormatException nfe) {
        	System.out.println("The first argument must be an integer.");
        	System.exit(1);
        }
        
        boolean previous_loans = handleBool(args[1]);
        
        int age = 0;
        try {
        	age = Integer.parseInt(args[2]);
        }
        catch (NumberFormatException nfe) {
        	System.out.println("The first argument must be an integer.");
        	System.exit(1);
        }
        
        int years_employed = 0;
        try {
        	years_employed = Integer.parseInt(args[3]);
        }
        catch (NumberFormatException nfe) {
        	System.out.println("The first argument must be an integer.");
        	System.exit(1);
        }
        
        boolean employee = handleBool(args[4]);
        
        boolean boss = handleBool(args[5]);
        
    
    
        VIPInput input = new VIPInput(credit, previous_loans, age, years_employed, employee, boss);
        VIPConclusion conclusion = new VIPConclusion();
        List<String> results = conclusion.begin(input);
        
        for (String s : results) {
        	System.out.println(s);
        }
    }
}  
