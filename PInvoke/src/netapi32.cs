using System;
using System.ComponentModel;
using System.Runtime.InteropServices;

namespace PInvoke
{
	public static class NetApi32
	{

		[DllImport("NetApi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
		public static extern int NetLocalGroupAddMembers(
			string servername, //server name
			string groupname, //group name
			UInt32 level, //info level
			ref LocalGroupMembersInfo0 buf, //Group info structure
			UInt32 totalentries //number of entries
		);

		[DllImport("NetApi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
		public static extern int NetLocalGroupDelMembers(
			string servername, //server name
			string groupname, //group name
			UInt32 level, //info level
			ref LocalGroupMembersInfo0 buf, //Group info structure
			UInt32 totalentries //number of entries
		);

		[DllImport("NetAPI32.dll", CharSet = CharSet.Unicode)]
		public extern static int NetLocalGroupGetMembers(
			[MarshalAs(UnmanagedType.LPWStr)] string servername,
			[MarshalAs(UnmanagedType.LPWStr)] string localgroupname,
			int level,
			out IntPtr bufptr,
			int prefmaxlen,
			out int entriesread,
			out int totalentries,
			IntPtr resume_handle);

		[DllImport("Netapi32.dll", SetLastError = true)]
		public static extern int NetApiBufferFree(IntPtr buffer);

		[StructLayout(LayoutKind.Sequential)]
		public struct LocalGroupMembersInfo0
		{
			[MarshalAs(UnmanagedType.SysInt)]
			public IntPtr pSID;

		}
	}
}

