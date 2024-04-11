using System;
using System.Runtime.InteropServices;
using System.Text;

namespace PureInvoke
{
	public static class Kernel32
	{
		[DllImport("kernel32.dll", SetLastError=true)]
		public static extern bool FindClose(IntPtr hFindFile);

		[DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
		public static extern IntPtr FindFirstFileNameW(string lpFileName, uint dwFlags, ref uint StringLength, StringBuilder LinkName);

		[DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
		public static extern bool FindNextFileNameW(IntPtr hFindStream, ref uint StringLength, StringBuilder LinkName);

		[DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
		public static extern bool GetVolumePathName(string lpszFileName, [Out] StringBuilder lpszVolumePathName, uint cchBufferLength);

		[DllImport("kernel32.dll")]
		public static extern IntPtr LocalFree(IntPtr hMem);

		public static readonly IntPtr INVALID_HANDLE_VALUE = (IntPtr)(-1); // 0xffffffff;

		public const int MAX_PATH = 65535; // Max. NTFS path length.
	}
}
