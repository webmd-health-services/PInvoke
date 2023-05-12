using System;
using System.ComponentModel;
using System.Runtime.InteropServices;

namespace PureInvoke
{
	public static class kernel32
	{
		[DllImport("kernel32.dll")]
		public static extern IntPtr LocalFree(IntPtr hMem);
	}
}
