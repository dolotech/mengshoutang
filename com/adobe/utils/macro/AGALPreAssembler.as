package com.adobe.utils.macro
{
	import flash.utils.Dictionary;

	/*
	 * 	The AGALPreAssembler implements a pre-processing language for AGAL.
	 *  The preprocessor is interpreted at compile time, which allows
	 *  run time generation of different shader types, often from one
	 *  main shader.
	 * 
<pre>
		Language:
		#define FOO num
		#define FOO
		#undef FOO	
		
		#if <expression>
		#elif <expression>
		#else
		#endif	
</pre>
	*/
	
	public class AGALPreAssembler
	{
		public static const TRACE_VM:Boolean = false;
		public static const TRACE_AST:Boolean = false;
		public static const TRACE_PREPROC:Boolean = false;
		
		private var vm:VM = new VM();
		private var expressionParser:ExpressionParser = new ExpressionParser();
		
		public function AGALPreAssembler()
		{
		}
					
		public function processLine( tokens:Vector.<String>, types:String ):Boolean
		{
			// read per-line. Either handle:
			//	- preprocessor tags (and call the proprocessor 'vm')
			//  - check the current 'if' state and stream out tokens.
			
			var slot:String = "";
			var num:Number;
			var exp:Expression = null;
			var result:Number;
			var pos:int = 0;
			
			if ( types.charAt(pos) == "#" ) {
				slot = "";
				num = Number.NaN;
				
				if (tokens[pos] == "#define" ) {
					// #define FOO 1
					// #define FOO
					// #define FOO=1
					if ( types.length >= 3 && types.substr(pos,3) == "#in" ) {
						slot = tokens[pos+1];
						vm.vars[ slot ] = Number.NaN;

						pos += 3;
					}
					else if ( types.length >= 3 && types.substr( pos,3) == "#i=" ) {
						exp = expressionParser.parse( tokens.slice( 3 ), types.substr( 3 ) );						
						exp.exec( vm );
						result = vm.stack.pop();
						
						slot = tokens[pos+1];
						vm.vars[slot] = result;
						

					}
					else {
						exp = expressionParser.parse( tokens.slice( 2 ), types.substr( 2 ) );						
						exp.exec( vm );
						result = vm.stack.pop();

						slot = tokens[pos+1];
						vm.vars[slot] = result;
						

					}						
				}
				else if ( tokens[pos] == "#undef" ) {
					slot = tokens[pos+1];
					vm.vars[slot] = null;

					pos += 3;
				}
				else if ( tokens[pos] == "#if" ) {
					++pos;
					exp = expressionParser.parse( tokens.slice( 1 ), types.substr( 1 ) );
					
					vm.pushIf();
					
					exp.exec( vm );
					result = vm.stack.pop();
					vm.setIf( result );

				}
				else if ( tokens[pos] == "#elif" ) {
					++pos;
					exp = expressionParser.parse( tokens.slice( 1 ), types.substr( 1 ) );
					
					exp.exec( vm );
					result = vm.stack.pop();
					vm.setIf( result );

				}
				else if ( tokens[pos] == "#else" ) {
					++pos;
					vm.setIf( vm.ifWasTrue() ? 0 : 1 );

				}
				else if ( tokens[pos] == "#endif" ) {
					vm.popEndif();
					++pos;

				}
				else {
					throw new Error( "unrecognize processor directive." );
				}
				
				// eat the newlines
				while( pos < types.length && types.charAt( pos ) == "n" ) {
					++pos;
				}	
			}
			else {
				throw new Error( "PreProcessor called without pre processor directive." );
			}
			return vm.ifIsTrue();
		}
	}
}
