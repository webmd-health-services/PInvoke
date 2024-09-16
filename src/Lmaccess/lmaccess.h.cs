
using System;
using System.Runtime.InteropServices;
using PureInvoke.WinNT;

namespace PureInvoke.Lmaccess
{
	[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
	public struct LOCALGROUP_MEMBERS_INFO_0
	{
		public IntPtr SidPtr;
	}

	[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
	public struct LOCALGROUP_MEMBERS_INFO_1
	{
		public IntPtr SidPtr;

		public SidNameUse SidUsage;

		public string Name;
	}

	[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
	public struct LOCALGROUP_MEMBERS_INFO_2
	{
		public IntPtr SidPtr;

		public SidNameUse SidUsage;

		public string DomainAndName;
	}

	[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
	public struct LOCALGROUP_MEMBERS_INFO_3
	{
		public string DomainAndName;
	}

}