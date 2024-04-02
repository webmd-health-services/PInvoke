using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

namespace PureInvoke.LsaLookup
{
	[StructLayout(LayoutKind.Sequential)]
	// ReSharper disable once InconsistentNaming
	public struct LSA_UNICODE_STRING
	{
		public LSA_UNICODE_STRING(string inputString)
		{
			if (inputString == null)
			{
				Buffer = IntPtr.Zero;
				Length = 0;
				MaximumLength = 0;
			}
			else
			{
				Buffer = Marshal.StringToHGlobalAuto(inputString);
				Length = (ushort)(inputString.Length * UnicodeEncoding.CharSize);
				MaximumLength = (ushort)((inputString.Length + 1) * UnicodeEncoding.CharSize);
			}
		}

		public ushort Length;
		public ushort MaximumLength;
		public IntPtr Buffer;

		public static LSA_UNICODE_STRING[] PtrToLsaUnicodeStrings(IntPtr ptr, uint length)
		{
			var lsaStrings = new List<LSA_UNICODE_STRING>((int)length);

			var myLsaus = new LSA_UNICODE_STRING();
			for (ulong i = 0; i < length; i++)
			{
				var itemAddr = new IntPtr(ptr.ToInt64() + (long)(i * (ulong)Marshal.SizeOf(myLsaus)));
				myLsaus = (LSA_UNICODE_STRING)Marshal.PtrToStructure(itemAddr, myLsaus.GetType());
				lsaStrings.Add(myLsaus);
			}
			return lsaStrings.ToArray();
		}
	}
}