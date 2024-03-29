/*
 * generated by Xtext 2.25.0
 */
package dk.sdu.tamamo.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.tamamo.moduleTree.Decision
import dk.sdu.tamamo.moduleTree.Input
import dk.sdu.tamamo.moduleTree.Rules
import dk.sdu.tamamo.moduleTree.Conclusion
import dk.sdu.tamamo.moduleTree.Start
import dk.sdu.tamamo.moduleTree.Parameter
import org.eclipse.emf.ecore.EObject
import dk.sdu.tamamo.moduleTree.ParentTree
import dk.sdu.tamamo.moduleTree.InputInt
import dk.sdu.tamamo.moduleTree.InputString
import dk.sdu.tamamo.moduleTree.TreeType
import dk.sdu.tamamo.moduleTree.ChildTree
import dk.sdu.tamamo.moduleTree.DecisionNormal
import dk.sdu.tamamo.moduleTree.DecisionNested
import java.util.List
import java.util.ArrayList
import dk.sdu.tamamo.moduleTree.RuleTypeExp
import dk.sdu.tamamo.moduleTree.RuleType
import dk.sdu.tamamo.moduleTree.Expression
import dk.sdu.tamamo.moduleTree.Plus
import dk.sdu.tamamo.moduleTree.Minus
import dk.sdu.tamamo.moduleTree.Mult
import dk.sdu.tamamo.moduleTree.Div
import dk.sdu.tamamo.moduleTree.RuleTypeID
import dk.sdu.tamamo.moduleTree.Operator
import dk.sdu.tamamo.moduleTree.RulesConclude
import dk.sdu.tamamo.moduleTree.EffectType
import dk.sdu.tamamo.moduleTree.RulesChange
import dk.sdu.tamamo.moduleTree.Subtract
import dk.sdu.tamamo.moduleTree.ConclusionNested
import dk.sdu.tamamo.moduleTree.ConclusionElse
import dk.sdu.tamamo.moduleTree.InputBool
import dk.sdu.tamamo.moduleTree.InputType
import dk.sdu.tamamo.moduleTree.RuleLogic

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class ModuleTreeGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val Start startModel = resource.allContents.filter(Start).next
		
		generateTree(fsa, startModel.parent, resource)
	}
	
	def generatePackage() {
		'''
			package decisiontree;
		'''
	}
	
	def generateTree(IFileSystemAccess2 fsa, TreeType tree, Resource resource) {
		tree.generateInputFile(fsa, resource)
		tree.generateDecisionFile(fsa, resource)
		tree.generateParameterFile(fsa, resource)
		tree.generateRulesFile(fsa, resource)
		tree.generateConclusionFile(fsa, resource)
		tree.generateStartFile(fsa, resource)
	}
	
	def void generateStartFile(TreeType tree, IFileSystemAccess2 fsa, Resource resource) {

		fsa.generateFile('''decisiontree/«tree.module_name.toFirstUpper»Main.java''', generateStart(tree, resource))
		if (tree.next !== null) tree.next.generateStartFile(fsa, resource)
	}

	def CharSequence generateStart(TreeType tree, Resource resource) {
		'''
			«generatePackage()»
			
			import java.util.ArrayList;
			import java.util.List;
			
			public class «tree.module_name.toFirstUpper»Main {
				
			    «generateHandleBool()»
			    
			    «generateMainFunc(tree, resource)»
			}  
		'''
	}
	
	def CharSequence generateMainFunc(TreeType tree, Resource resource) {
		var CharSequence chars = ''''''
		var ParentTree parent = null
		if (tree instanceof ChildTree) {
			parent = findParentClass(tree, resource)
		}
		
		switch tree {
			ParentTree:
			chars = chars + 
			'''
			public static void main(String[] args){
			
			
				assert(args.length == «getNumInputs(tree.input, 1)+""»);
			
			    «mainInput(tree.input, 0)»
			
			
			    «tree.module_name.toFirstUpper»Input input = new «tree.module_name.toFirstUpper»Input(«handleInputVariable(tree.input)»);
			    «tree.module_name.toFirstUpper»Conclusion conclusion = new «tree.module_name.toFirstUpper»Conclusion();
			    List<String> results = conclusion.begin(input);
			    
			    for (String s : results) {
			    	System.out.println(s);
			    }
			}
			'''
			
			ChildTree:
			chars = chars + 
			'''
			public static void main(String[] args){
			
			
				assert(args.length == «(getNumInputs(tree.input, 1) + getNumInputs(parent.input, 1))+""»);
			
			    «mainInput(tree.input, parent.input, 0)»
			
			
			    «tree.module_name.toFirstUpper»Input input = new «tree.module_name.toFirstUpper»Input(«handleInputVariable(tree.input, parent.input)»);
			    «tree.module_name.toFirstUpper»Conclusion conclusion = new «tree.module_name.toFirstUpper»Conclusion();
			    List<String> results = conclusion.begin(input);
			    
			    for (String s : results) {
			    	System.out.println(s);
			    }
			}
			'''
			
		}
	}
	
	def CharSequence handleInputVariable(Input child, Input parent) {
		var CharSequence chars = ''''''
		var Input current = parent
		
		do {
			
			chars = chars + '''«current.value.name»«IF current.next !== null», «ENDIF»'''
		} while ((current = current.next) !== null)
		
		current = child
		chars = chars + ''', '''
		
		do {
			chars = chars + '''«current.value.name»«IF current.next !== null», «ENDIF»'''
		} while ((current = current.next) !== null)
		
		return chars
		
	}
	
	
	def CharSequence handleInputVariable(Input input) {
		'''«input.value.name»«IF input.next !== null», «handleInputVariable(input.next)»«ENDIF»'''
	}
	
	def CharSequence mainInput(Input child, Input parent, int index) {
		'''
		«handleInput(parent.value, index)»

		«IF parent.next !== null»«mainInput(child, parent.next, index+1)»
		«ELSE»
		«mainInput(child, index+1)»
		«ENDIF»
		'''
		
	}
	
	def CharSequence mainInput(Input input, int index) {
		'''
		«handleInput(input.value, index)»

		«IF input.next !== null»«mainInput(input.next, index+1)»«ENDIF»
		'''
		
	}
	
	def CharSequence handleInput(InputType input, int index) {
		var CharSequence chars = ''''''
		switch input {
			InputInt : 
			chars = chars + 
			'''
			int «input.name» = 0;
			try {
				«input.name» = Integer.parseInt(args[«index+''»]);
			}
			catch (NumberFormatException nfe) {
				System.out.println("The first argument must be an integer.");
				System.exit(1);
			}
			'''
			
			InputBool: 
			chars = chars + 
			'''
			boolean «input.name» = handleBool(args[«index+''»]);
			'''
			
			InputString: 
			chars = chars + 
			'''
			String «input.name» = args[«index+''»];
			'''
			
		}
		return chars
	}
	
	def int getNumInputs(Input input, int number) {
		if (input.next !== null) {
			getNumInputs(input.next, number+1);
		} else {
			return number;
		}
	}
	
	def generateHandleBool() {
		'''
			private static boolean handleBool(String s) {
			     if (s.equals("true") || s.equals("1") || s.equals("True") || s.equals("TRUE")) {
			         return true;
			     } else {
			         return false;
			     }
			}
		'''
	}
	
	def void generateConclusionFile(TreeType tree, IFileSystemAccess2 fsa, Resource resource) {
		fsa.generateFile('''decisiontree/«tree.module_name.toFirstUpper»Conclusion.java''', generateConclusion(tree, resource))
		
		if (tree.next !== null) (tree.next as TreeType).generateConclusionFile(fsa, resource)
	}
	
	def CharSequence generateConclusion(TreeType tree, Resource resource) {
		var CharSequence chars = 
		'''
		«generatePackage()»
		
		import java.util.ArrayList;
		import java.util.List;
		public class «tree.module_name.toFirstUpper»Conclusion {
			
			«tree.module_name.toFirstUpper»Decision «tree.module_name.toFirstLower»_decision = new «tree.module_name.toFirstUpper»Decision();
			«tree.module_name.toFirstUpper»Parameter «tree.module_name.toFirstLower»_param = new «tree.module_name.toFirstUpper»Parameter();
			'''
			
		switch tree {
			ParentTree : 
			chars = chars + 
		'''
			public List<String> begin(«tree.module_name.toFirstUpper»Input «tree.module_name.toFirstLower»_input) {
			
				«tree.module_name.toFirstUpper»Rules «tree.module_name.toFirstLower»_rule = new «tree.module_name.toFirstUpper»Rules(«tree.module_name.toFirstLower»_input, «tree.module_name.toFirstLower»_param);
				List<String> «tree.module_name.toFirstLower»_nested = new ArrayList<>();
				
				String «tree.module_name.toFirstLower»_response = «tree.module_name.toFirstLower»_rule.setupRules();
				
				if («tree.module_name.toFirstLower»_response != null) {
					«tree.module_name.toFirstLower»_nested.add(«tree.module_name.toFirstLower»_response);
					return «tree.module_name.toFirstLower»_nested;
				}
				
				«generateBegin(tree, tree.conclusion)»
			}
		}
		'''
		
		ChildTree : 
		chars = chars + 
		'''
			public List<String> begin(«tree.module_name.toFirstUpper»Input «tree.module_name.toFirstLower»_input) {
			
				«tree.module_name.toFirstUpper»Rules «tree.module_name.toFirstLower»_rule = new «tree.module_name.toFirstUpper»Rules(«tree.module_name.toFirstLower»_input, «tree.module_name.toFirstLower»_param, «tree.module_name.toFirstLower»_input, «tree.module_name.toFirstLower»_param);
				List<String> «tree.module_name.toFirstLower»_nested = new ArrayList<>();
				
				String «tree.module_name.toFirstLower»_response = «tree.module_name.toFirstLower»_rule.setupRules();
				
				if («tree.module_name.toFirstLower»_response != null) {
					«tree.module_name.toFirstLower»_nested.add(«tree.module_name.toFirstLower»_response);
					return «tree.module_name.toFirstLower»_nested;
				}
				
				«generateBegin(tree, tree.conclusion)»
			}
		}
		'''
		} 
		
		return chars
		
	}
	
	def CharSequence generateBegin(TreeType tree, Conclusion conclusion) {
		var CharSequence chars = ''''''
		switch tree {
			ParentTree : 
			switch conclusion {
				ConclusionNested : 
				chars = chars + handleNested(conclusion, conclusion, tree).toString
				
				ConclusionElse : 
				chars = chars + 
				'''
				if («tree.module_name.toFirstLower»_nested.size() < 1) {
					«tree.module_name.toFirstLower»_nested.add("«(conclusion.left as RuleTypeID).name»");
				}
				
				return «tree.module_name.toFirstLower»_nested;'''
				
				
				default: 
				chars = chars + 
				'''
				if («generateComparison(conclusion, tree)») {
					«tree.module_name.toFirstLower»_nested.add(«tree.module_name.toFirstLower»_decision.get«conclusion.decision.toFirstUpper»());
					return «tree.module_name.toFirstLower»_nested;
				}
				
				«IF conclusion.next !== null»«generateBegin(tree, conclusion.next)»«ENDIF»
				'''
			}
			
			ChildTree : 
			switch conclusion {
				ConclusionNested : 
				chars = chars + handleNested(conclusion, conclusion, tree).toString
				
				ConclusionElse : 
				chars = chars + 
				'''
				if («tree.module_name.toFirstLower»_nested.size() < 1) {
					«tree.module_name.toFirstLower»_nested.add("«(conclusion.left as RuleTypeID).name»");
				}
				
				return «tree.module_name.toFirstLower»_nested;'''
				
				
				default: 
				chars = chars + 
				'''
				if («generateComparison(conclusion, tree)») {
					«tree.module_name.toFirstLower»_nested.add(«tree.module_name.toFirstLower»_decision.get«conclusion.decision.toFirstUpper»());
					return «tree.module_name.toFirstLower»_nested;
				}
				
				«IF conclusion.next !== null»«generateBegin(tree, conclusion.next)»«ENDIF»
				'''
			}
		}
		return chars
	}
	
	def CharSequence handleNested(Conclusion conclusion, ConclusionNested parent, TreeType tree) {
		
		var CharSequence chars = ''''''
		switch conclusion {
			
			ConclusionNested : 
			chars = chars + 
			'''
			// Nested code
					
			if ( «generateComparison(conclusion.nested, tree)» ) {
				for (String s : «tree.module_name.toFirstLower»_decision.get«parent.parent.toFirstUpper»().getNestedValues()) {
					if (s.equals("«conclusion.nested.decision»")) {
						«tree.module_name.toFirstLower»_nested.add(s);
					}
				}
			}
			
			«IF conclusion.nested.next !== null»
									«handleNested(conclusion.nested.next, parent, tree)»«ENDIF»
			'''
			
			
			ConclusionElse : 
			chars = chars + 
			'''
			if («tree.module_name.toFirstLower»_nested.size() < 1) {
				«tree.module_name.toFirstLower»_nested.add("«(conclusion.left as RuleTypeID).name»");
			}
			
			return «tree.module_name.toFirstLower»_nested;
			
			
			'''
			
			default : 
			chars = chars + 
			'''
			if ( «generateComparison(conclusion, tree)» ) {
				for (String s : «tree.module_name.toFirstLower»_decision.get«(parent as ConclusionNested).parent.toFirstUpper»().getNestedValues()) {
					if (s.equals("«conclusion.decision»")) {
						«tree.module_name.toFirstLower»_nested.add(s);
					}
				}
			}
			
			«IF conclusion.next !== null»
									«handleNested(conclusion.next, parent, tree)»«ENDIF»
			'''
			
		}
		
		return chars
		
	}
	
	def void generateRulesFile(TreeType tree, IFileSystemAccess2 fsa, Resource resource) {
		fsa.generateFile('''decisiontree/«tree.module_name.toFirstUpper»Rules.java''', generateRules(tree, resource))
		
		if (tree.next !== null) (tree.next as TreeType).generateRulesFile(fsa, resource)
	}
	
	def CharSequence generateRules(TreeType tree, Resource resource) {
		
		var ParentTree parent = null
		
		if (tree instanceof ChildTree ) {
			parent = findParentClass(tree, resource)
		}
		
		
		var CharSequence chars = ''''''
		
		switch tree {
			ParentTree : 
			chars = chars + '''
			«generatePackage()»
			
			public class «tree.module_name.toFirstUpper»Rules {
				«tree.module_name.toFirstUpper»Parameter «tree.module_name.toFirstLower»_param = null;
				«tree.module_name.toFirstUpper»Input «tree.module_name.toFirstLower»_input = null;
				«tree.module_name.toFirstUpper»Decision «tree.module_name.toFirstLower»_decision = new «tree.module_name.toFirstUpper»Decision();
				
				public «tree.module_name.toFirstUpper»Rules(«tree.module_name.toFirstUpper»Input «tree.module_name.toFirstLower»_input, «tree.module_name.toFirstUpper»Parameter «tree.module_name.toFirstLower»_param) {
					this.«tree.module_name.toFirstLower»_input = «tree.module_name.toFirstLower»_input;
					this.«tree.module_name.toFirstLower»_param = «tree.module_name.toFirstLower»_param;
				}
				
				
				public String setupRules() {
					
					«generateInputBody(tree.rules, tree)»
					
					return null;
				}
			}'''
			
			ChildTree : 
			chars = chars + '''
			«generatePackage()»
			
			public class «tree.module_name.toFirstUpper»Rules extends «tree.parent.toFirstUpper»Rules {
				«tree.module_name.toFirstUpper»Parameter «tree.module_name.toFirstLower»_param = null;
				«tree.module_name.toFirstUpper»Input «tree.module_name.toFirstLower»_input = null;
				«tree.module_name.toFirstUpper»Decision «tree.module_name.toFirstLower»_decision = new «tree.module_name.toFirstUpper»Decision();
				
				public «tree.module_name.toFirstUpper»Rules(«parent.generateConstructor», «tree.module_name.toFirstUpper»Input «tree.module_name.toFirstLower»_input, «tree.module_name.toFirstUpper»Parameter «tree.module_name.toFirstLower»_param) {
					super(«parent.module_name.toFirstLower»_input, «parent.module_name.toFirstLower»_param);
					this.«tree.module_name.toFirstLower»_input = «tree.module_name.toFirstLower»_input;
					this.«tree.module_name.toFirstLower»_param = «tree.module_name.toFirstLower»_param;
				}
				
				
				public String setupRules() {
					String «tree.module_name.toFirstLower»_super = super.setupRules();
					
					if («tree.module_name.toFirstLower»_super != null) {
						return «tree.module_name.toFirstLower»_super;
					}
					
					«generateInputBody(tree.rules, tree)»
					
					return null;
				}
			}'''
			
			}
		
		return chars
	}
	
	def CharSequence generateInputBody(Rules rule, TreeType tree) {
		'''
		if ( «generateComparison(rule, tree)» ) {
			«rule.generateEffect(tree.module_name)»
		}
		
		«IF rule.next !== null»«generateInputBody(rule.next, tree)»«ENDIF»
		'''
	}
	
	def CharSequence generateEffect(Rules rules, String name) {
		var CharSequence chars = ''''''
		val EffectType effect = rules.effect
		switch effect {
			RulesConclude : chars = chars + '''return «name.toFirstLower»_decision.get«effect.decision.toFirstUpper»();'''
			RulesChange : chars = chars  + 
			'''«name.toFirstLower»_param.set«effect.affected_parameter.toFirstUpper»(«name.toFirstLower»_param.get«
			effect.affected_parameter.toFirstUpper»() «IF effect.points instanceof Subtract»- «ELSE»+ «ENDIF»«effect.points.points»);''' 
		}
		return chars
	}
	
	def CharSequence generateComparison(EObject object, TreeType tree) {
		switch object {
			Rules : 
			compareObjects(object.rule, tree.module_name, true)
			
			Conclusion: 
			compareObjects(object.rule, tree.module_name, false)
		}
		
	}
	
	def compareObjects(RuleLogic rule, String name, boolean type) {
		val RuleType left = rule.left
		var CharSequence chars = ''''''
		switch left {
			RuleTypeExp : chars = chars + left.exp.compute.toString + ''' '''
			RuleTypeID :  chars = chars + '''«name.toFirstLower»«IF type»_input.get«ELSE»_param.get«ENDIF»«left.name.toFirstUpper»() '''
			default: println("error")
		}
		
		val Operator op = rule.operator
		if (op !== null) {
			chars = chars + op.type + ''' '''
		}
		
		val RuleType right = rule.right
		switch right {
			RuleTypeExp : chars = chars + right.exp.compute.toString + ''' '''
			RuleTypeID :  chars = chars + '''«name.toFirstLower»«IF type»_input.get«ELSE»_param.get«ENDIF»«right.name.toFirstUpper»() '''
			default: println("error")
		}
		
		
		return chars
	}
	
	def static int compute(Expression math) { 
			math.computeExp
	//		math.exp.computeExpEnv(new HashMap<String,Integer>)
		}
		
	// Normal style using xtext binding, requires a scope provider
	def static int computeExp(Expression exp) {
		switch exp {
			Plus: exp.left.computeExp+exp.right.computeExp
			Minus: exp.left.computeExp-exp.right.computeExp
			Mult: exp.left.computeExp*exp.right.computeExp
			Div: exp.left.computeExp/exp.right.computeExp
			dk.sdu.tamamo.moduleTree.Number: exp.value
			default: throw new Error("Internal error")
		}
	}	
	
	def void generateParameterFile(TreeType tree, IFileSystemAccess2 fsa, Resource resource) {
		fsa.generateFile('''decisiontree/«tree.module_name.toFirstUpper»Parameter.java''', generateParameter(tree, resource))
		
		if (tree.next !== null) tree.next.generateParameterFile(fsa, resource)
	}
	
	def CharSequence generateParameter(TreeType tree, Resource resource) {
		switch tree {
			ParentTree: generateParameterParent(tree)
			ChildTree: generateParameterChild(tree, resource)
			default: '''error'''
		}
	}
	
	def generateParameterChild(ChildTree tree, Resource resource) {
		val ParentTree parent = findParentClass(tree, resource)
		'''
		«generatePackage()»
		public class «tree.module_name.toFirstUpper»Parameter extends «tree.parent.toFirstUpper»Parameter {
			
			«generateClassVariables(tree, parent)»
			
			public «tree.module_name.toFirstUpper»Parameter(«generateConstructorParameters(tree, parent)») {
				«getSuperNames(tree, parent)»
				«tree.generateConstructor(parent)»
			}
			
			public «tree.module_name.toFirstUpper»Parameter() {
				super();
				«tree.generateConstructor(parent)»
			}
		}'''
	}
	
	def generateConstructor(ChildTree child, ParentTree parent) {
		val List<Parameter> new_params = getNewParameters(child, parent)
		var CharSequence stuff = ''''''
		
		for (i : 0 ..< new_params.size) {
			stuff = stuff + '''this.«new_params.get(i).name» = «new_params.get(i).name»;
			'''
		}
		return stuff
	}
	
	def generateConstructorParameters(ChildTree child, ParentTree parent) {
		val List<Parameter> new_params = getNewParameters(child, parent)
		var CharSequence stuff = ''''''
		
		for (i : 0 ..< new_params.size) {
			stuff = stuff + '''int «new_params.get(i).name»'''
			if (i != new_params.size - 1) {
				stuff = stuff + ''', '''
			}
		}
		
		return stuff
	}
	
	def getSuperNames(ChildTree child, ParentTree parent) {
		var Parameter current_parent = parent.parameter
		var Parameter current_child = child.parameter
		var List<Integer> array = new ArrayList
		
		do {
			var boolean found = false
			do {
				if (current_parent.name.equals(current_child.name)) {
					found = true
					array.add(current_child.value)
				}
			} while ((current_child = current_child.next) !== null && !found)
			
			if (!found) {
				array.add(current_parent.value)
			}
			
			current_child = child.parameter
		} while ((current_parent = current_parent.next) !== null)
		
		var CharSequence superNumbers = ''''''
		
		if (array.size < 1) {
			return superNumbers
		} else {
			superNumbers = superNumbers + '''super('''
		}
		
		for (i : 0 ..< array.size) {
			if (i == array.size - 1) {
				superNumbers = superNumbers + array.get(i).toString
			} else {
				superNumbers = superNumbers + array.get(i).toString + ''', '''
			}
		} return superNumbers + ''');''' 
		
	}
	
	def CharSequence generateParameterParent(ParentTree tree) {
		'''
		«generatePackage()»
		public class «tree.module_name.toFirstUpper»Parameter {
			«generateClassVariables(tree.parameter)»
			
			public «tree.module_name.toFirstUpper»Parameter(«tree.parameter.generateConstructor») {
				«generateAssignment(tree.parameter)»
			}
			
			public «tree.module_name.toFirstUpper»Parameter() {
				«generateAssignment(tree.parameter)»
			}
		}'''
	}
	
	def CharSequence generateClassVariables(Parameter param) {
		'''
		private int «param.name» = «param.value»;
		public int get«param.name.toFirstUpper»() {
			return this.«param.name»;
		}
		public void set«param.name.toFirstUpper»(int value) {
			this.«param.name» = value;
		}
		«IF param.next !== null»«generateClassVariables(param.next)»«ENDIF»'''
	}
	
	def generateClassVariables(ChildTree child, ParentTree parent) {
		var List<Parameter> new_parameters = getNewParameters(child, parent)
		var CharSequence stuff = ''''''
		for (i: 0 ..< new_parameters.size) {
			stuff = stuff + new_parameters.get(i).generateChildClassVariable
		}
		
		return stuff
	}
	
	def String generateChildClassVariable(Parameter param) {
		'''
		private int «param.name» = «param.value»;
		public int get«param.name.toFirstUpper»() {
			return this.«param.name»;
		}
		public void set«param.name.toFirstUpper»(int value) {
			this.«param.name» = value;
		}
		
		'''
	}
	
	
	def getNewParameters(ChildTree child, ParentTree parent) {
		var List<Parameter> new_params = new ArrayList
		var Parameter current_param = child.parameter
		do {
			if (!compareParams(current_param, parent.parameter)) {
				new_params.add(current_param)
			}
		} while ((current_param = current_param.next) !== null)
		
		return new_params
	}
	
	def boolean compareParams(Parameter param1, Parameter param2) {
		if (param1.name.equals(param2.name)) {
			return true
		} else {
			if (param2.next !== null) {
				compareParams(param1, param2.next)
			} else {
				return false
			}
			
		}
	}
	
	def void generateDecisionFile(TreeType tree, IFileSystemAccess2 fsa, Resource resource) {
		fsa.generateFile('''decisiontree/«tree.module_name.toFirstUpper»Decision.java''', generateDecision(tree, resource))
		
		if (tree.next !== null) (tree.next as TreeType).generateDecisionFile(fsa, resource)
	}
	
	def CharSequence generateDecision(TreeType tree, Resource resource) {
		switch tree {
			ParentTree: generateDecisionParent(tree)
			ChildTree: generateDecisionChild(tree, resource)
			default: '''error'''
		}
	}
	
	def ParentTree findParentClass(ChildTree tree, Resource resource) {
		var ParentTree parent = null
		for (ParentTree pt : resource.allContents.filter(ParentTree).toIterable) {
			if (pt.module_name.equals(tree.parent)) {
				parent = pt
			}
		} return parent
	}
	
	def generateDecisionChild(ChildTree tree, Resource resource) {
		val ParentTree parent = findParentClass(tree, resource)
		
		'''
		«generatePackage»
		
		import java.util.List;
		import java.util.ArrayList;
		public class «tree.module_name.toFirstUpper»Decision extends «parent.module_name.toFirstUpper»Decision {
			
			«tree.decision.generateDecisionVariables»
			
		}
		'''
	}
	
	def CharSequence generateDecisionParent(ParentTree tree) {
		'''
		«generatePackage»
		
		import java.util.List;
		import java.util.ArrayList;
		public class «tree.module_name.toFirstUpper»Decision {
			
			«tree.decision.generateDecisionVariables»
			
		}
		'''
	}
	
	def CharSequence generateDecisionVariables(Decision decision) {
		switch decision {
			DecisionNormal: 
			'''
			private String _«decision.text» = "«decision.text»";
			public String get«decision.text.toFirstUpper»() {
				return this._«decision.text»;
			}
			
			«IF (decision.next !== null)»«decision.next.generateDecisionVariables»«ENDIF»
			'''
			
			DecisionNested: 
			'''
			private «decision.text.toFirstUpper» «decision.text.toFirstLower» = new «decision.text.toFirstUpper»();
			
			public «decision.text.toFirstUpper» get«decision.text.toFirstUpper»() {
				return this.«decision.text.toFirstLower»;
			}
			
			public class «decision.text.toFirstUpper» {
				private List<String> nested_values;
				public List<String> getNestedValues() {
					return this.nested_values;
				}
				
				public «decision.text.toFirstUpper»() {
					nested_values = new ArrayList<>();
					«decision.nested.generateNestedValues»
				}
			}
			'''
		}
	}
	
	def CharSequence generateNestedValues(Decision decision){
		'''
		nested_values.add("«decision.text»");
		«IF (decision.next !== null)»«decision.next.generateNestedValues»«ENDIF»
		'''
	}
	
	def void generateInputFile(TreeType tree, IFileSystemAccess2 fsa, Resource resource) {
		fsa.generateFile('''decisiontree/«tree.module_name.toFirstUpper»Input.java''', generateInput(tree, resource))
		
		if (tree.next !== null) tree.next.generateInputFile(fsa, resource)
	}
	
	def CharSequence generateInput(TreeType tree, Resource resource) {
		switch tree {
			ParentTree: generateInputParent(tree)
			ChildTree: generateInputChild(tree, resource)
			default: '''error'''
		}
	}
	
	def CharSequence generateInputParent(ParentTree tree) {
		'''
		«generatePackage()»
		public class «tree.module_name.toFirstUpper»Input {
			
			«generateClassVariables(tree.input)»
			
			public «tree.module_name»Input(«generateConstructor(tree.input)») {
				«generateAssignment(tree.input)»
			}	
		}
		'''
	}
	
	def CharSequence generateInputChild(ChildTree tree, Resource resource) {
		var ParentTree parent = findParentClass(tree, resource)
		'''
		«generatePackage()»
		public class «tree.module_name.toFirstUpper»Input extends «tree.parent.toFirstUpper»Input {
			
			«generateClassVariables(tree.input)»
			
			public «tree.module_name»Input(«parent.input.generateConstructor», «tree.input.generateConstructor») {
				super(«parent.input.getSuperNames»);
				«generateAssignment(tree.input)»
			}	
		}
		'''
	}
	
	def CharSequence getSuperNames(EObject object) {
		switch object {
			Input: 
			'''
			«object.value.name»«IF (object.next !== null)», «object.next.getSuperNames»«ENDIF»'''
			
			Parameter:
			'''
			«object.value»«IF (object.next !== null)», «object.next.getSuperNames»«ENDIF»''' 
			
			
		}
	}
	
	def CharSequence generateAssignment(EObject object) {
		switch object {
			Input: '''
			this.«object.value.name» = «object.value.name»;
			«IF object.next !== null»«generateAssignment(object.next)»«ENDIF»'''
			
			Parameter: '''
			this.«object.name» = «object.name»;
			«IF object.next !== null»«generateAssignment(object.next)»«ENDIF»'''
			default: '''error'''
		}
	}
	
	def CharSequence generateConstructor(EObject object) {
		switch object {
			Input: 
			'''«object.generateConstructorType» «object.value.name»«IF (object.next !== null)», «object.next.generateConstructor»«ENDIF»'''
			Parameter: '''int «object.name»«IF (object.next !== null)», «object.next.generateConstructor»«ENDIF»'''
			ParentTree: '''«object.module_name.toFirstUpper»Input «object.module_name.toFirstLower»_input, «object.module_name.toFirstUpper»Parameter «object.module_name.toFirstLower»_param'''
		}
		
	} 
	
	def CharSequence generateConstructorType(Input input) {
		switch input.value {
			InputInt : '''int'''
			InputString: '''String'''
			default: '''boolean'''
		}
	}
	
	def CharSequence generateClassVariables(Input input) {
		'''
		private «input.generateClassVariablesType»get«input.value.name.toFirstUpper»() {
			return this.«input.value.name»;
		}
		
		«IF (input.next !== null)»«input.next.generateClassVariables»«ENDIF»''' 
	}
	
	def CharSequence generateClassVariablesType(Input input) {
		switch input.value {
			InputInt: '''
			int «input.value.name»;
			public int '''
			InputString: '''
			String «input.value.name»;
			public String '''
			default: '''
			boolean «input.value.name»;
			public boolean '''
		}
	}
}
