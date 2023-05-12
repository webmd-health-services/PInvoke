using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Text;

namespace PureInvoke
{
	public static class AdvApi32
	{
		// ReSharper disable InconsistentNaming
		[DllImport("advapi32", CharSet = CharSet.Auto, SetLastError = true)]
		public static extern bool ConvertSidToStringSid(
			[MarshalAs(UnmanagedType.LPArray)] byte[] pSID,
			out IntPtr ptrSid);

		[DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
		public static extern bool LookupAccountName(
			string lpSystemName,
			string lpAccountName,
			[MarshalAs(UnmanagedType.LPArray)] byte[] Sid,
			ref uint cbSid,
			StringBuilder referencedDomainName,
			ref uint cchReferencedDomainName,
			out SidNameUse peUse
		);

		[DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
		public static extern bool LookupAccountSid(
			string lpSystemName,
			[MarshalAs(UnmanagedType.LPArray)] byte[] Sid,
			StringBuilder lpName,
			ref uint cchName,
			StringBuilder referencedDomainName,
			ref uint cchReferencedDomainName,
			out SidNameUse peUse
		);

		public enum SidNameUse {
			User = 1,
			Group,
			Domain,
			Alias,
			WellKnownGroup,
			DeletedAccount,
			Invalid,
			Unknown,
			Computer,
			Label,
			LogonSession
		}
	}
}
