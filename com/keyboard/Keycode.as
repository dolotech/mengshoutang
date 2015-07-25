package com.keyboard
{
	import flash.utils.Dictionary;

	public class Keycode
	{
		// Key Names -------------------------------------------------------------------------------
		private static const keyData:Dictionary=new Dictionary();


		public static function downKey(key:int):void
		{
			keyData[key]=true;
		}

		public static function upKey(key:int):void
		{
			keyData[key]=false;
		}

		public static function hasDownKey(key:int):Boolean
		{
			return keyData[key];
		}

		public static function clearKey():void
		{
			for (var key:String in keyData)
			{
				keyData[key]=false;
			}
		}

		public static const keyName:Vector.<String> = new Vector.<String>(222);

		keyName[A]="A";
		keyName[B]="B";
		keyName[C]="C";
		keyName[D]="D";
		keyName[E]="E";
		keyName[F]="F";
		keyName[G]="G";
		keyName[H]="H";
		keyName[I]="I";
		keyName[J]="J";
		keyName[K]="K";
		keyName[L]="L";
		keyName[M]="M";
		keyName[N]="N";
		keyName[O]="O";
		keyName[P]="P";
		keyName[Q]="Q";
		keyName[R]="R";
		keyName[S]="S";
		keyName[T]="T";
		keyName[U]="U";
		keyName[V]="V";
		keyName[W]="W";
		keyName[X]="X";
		keyName[Y]="Y";
		keyName[Z]="Z";

		keyName[Keyb0]="0";
		keyName[Keyb1]="1";
		keyName[Keyb2]="2";
		keyName[Keyb3]="3";
		keyName[Keyb4]="4";
		keyName[Keyb5]="5";
		keyName[Keyb6]="6";
		keyName[Keyb7]="7";
		keyName[Keyb8]="8";
		keyName[Keyb9]="9";

		keyName[Numpad0]="Numpad 0";
		keyName[Numpad1]="Numpad 1";
		keyName[Numpad2]="Numpad 2";
		keyName[Numpad3]="Numpad 3";
		keyName[Numpad4]="Numpad 4";
		keyName[Numpad5]="Numpad 5";
		keyName[Numpad6]="Numpad 6";
		keyName[Numpad7]="Numpad 7";
		keyName[Numpad8]="Numpad 8";
		keyName[Numpad9]="Numpad 9";

		keyName[NumpadStar]="Numpad *";
		keyName[NumpadPlus]="Numpad +";
		keyName[NumpadMinus]="Numpad -";
		keyName[NumpadPeriod]="Numpad .";
		keyName[NumpadSlash]="Numpad /";

		keyName[F1]="F1";
		keyName[F2]="F2";
		keyName[F3]="F3";
		keyName[F4]="F4";
		keyName[F5]="F5";
		keyName[F6]="F6";
		keyName[F7]="F7";
		keyName[F8]="F8";
		keyName[F9]="F9";
		keyName[F11]="F11";
		keyName[F12]="F12";
		keyName[F13]="F13";
		keyName[F14]="F14";
		keyName[F15]="F15";

		keyName[Backspace]="Backspace";
		keyName[Tab]="Tab";
		keyName[Enter]="Enter";
		keyName[Shift]="Shift";
		keyName[Control]="Control";
		keyName[PauseBreak]="Pause/Break";
		keyName[CapsLock]="Caps Lock";
		keyName[Esc]="Esc";
		keyName[Spacebar]="Spacebar";
		keyName[PageUp]="Page Up";
		keyName[PageDown]="Page Down";
		keyName[End]="End";
		keyName[Home]="Home";
		keyName[Left]="Left Arrow";
		keyName[Up]="Up Arrow";
		keyName[Right]="Right Arrow";
		keyName[Down]="Down Arrow";
		keyName[Insert]="Insert";
		keyName[Delete]="Delete";

		keyName[NumLck]="NumLck";
		keyName[ScrLck]="ScrLck";
		keyName[SemiColon]=";";
		keyName[Equal]="=";
		keyName[Comma]=",";
		keyName[Minus]="-";
		keyName[Period]=".";
		keyName[Question]="?";
		keyName[BackQuote]="`";
		keyName[LeftBrace]="[";
		keyName[Pipe]="|";
		keyName[RightBrace]="]";
		keyName[SingleQuote]="'";

		// Key Codes -------------------------------------------------------------------------------

		public static const A:uint=65;
		public static const B:uint=66;
		public static const C:uint=67;
		public static const D:uint=68;
		public static const E:uint=69;
		public static const F:uint=70;
		public static const G:uint=71;
		public static const H:uint=72;
		public static const I:uint=73;
		public static const J:uint=74;
		public static const K:uint=75;
		public static const L:uint=76;
		public static const M:uint=77;
		public static const N:uint=78;
		public static const O:uint=79;
		public static const P:uint=80;
		public static const Q:uint=81;
		public static const R:uint=82;
		public static const S:uint=83;
		public static const T:uint=84;
		public static const U:uint=85;
		public static const V:uint=86;
		public static const W:uint=87;
		public static const X:uint=88;
		public static const Y:uint=89;
		public static const Z:uint=90;

		public static const Keyb0:uint=48;
		public static const Keyb1:uint=49;
		public static const Keyb2:uint=50;
		public static const Keyb3:uint=51;
		public static const Keyb4:uint=52;
		public static const Keyb5:uint=53;
		public static const Keyb6:uint=54;
		public static const Keyb7:uint=55;
		public static const Keyb8:uint=56;
		public static const Keyb9:uint=57;

		public static const Numpad0:uint=96;
		public static const Numpad1:uint=97;
		public static const Numpad2:uint=98;
		public static const Numpad3:uint=99;
		public static const Numpad4:uint=100;
		public static const Numpad5:uint=101;
		public static const Numpad6:uint=102;
		public static const Numpad7:uint=103;
		public static const Numpad8:uint=104;
		public static const Numpad9:uint=105;

		public static const NumpadStar:uint=106;
		public static const NumpadPlus:uint=107;
		public static const NumpadMinus:uint=109;
		public static const NumpadPeriod:uint=110;
		public static const NumpadSlash:uint=111;

		public static const F1:uint=112;
		public static const F2:uint=113;
		public static const F3:uint=114;
		public static const F4:uint=115;
		public static const F5:uint=116;
		public static const F6:uint=117;
		public static const F7:uint=118;
		public static const F8:uint=119;
		public static const F9:uint=120;
		public static const F11:uint=122;
		public static const F12:uint=123;
		public static const F13:uint=124;
		public static const F14:uint=125;
		public static const F15:uint=126;

		public static const Backspace:uint=8;
		public static const Tab:uint=9;
		public static const Enter:uint=13;
		public static const Shift:uint=16;
		public static const Control:uint=17;
		public static const PauseBreak:uint=19;
		public static const CapsLock:uint=20;
		public static const Esc:uint=27;
		public static const Spacebar:uint=32;
		public static const PageUp:uint=33;
		public static const PageDown:uint=34;
		public static const End:uint=35;
		public static const Home:uint=36;
		public static const Left:uint=37;
		public static const Up:uint=38;
		public static const Right:uint=39;
		public static const Down:uint=40;
		public static const Insert:uint=45;
		public static const Delete:uint=46;

		public static const NumLck:uint=144;
		public static const ScrLck:uint=145;
		public static const SemiColon:uint=186;
		public static const Equal:uint=187;
		public static const Comma:uint=188;
		public static const Minus:uint=189;
		public static const Period:uint=190;
		public static const Question:uint=191;
		public static const BackQuote:uint=192;
		public static const LeftBrace:uint=219;
		public static const Pipe:uint=220;
		public static const RightBrace:uint=221;
		public static const SingleQuote:uint=222;

	/* Changelog ------------------------------------------------------------------------------
	 * 2009.08.18 Changed namespace and name to blit.data.Keycode
	 * --------------------------------------------------------------------------------------*/
	}
}