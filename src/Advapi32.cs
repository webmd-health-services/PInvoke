using System;
using System.Runtime.InteropServices;
using System.Text;
using PureInvoke.LsaLookup;
using PureInvoke.WinNT;

namespace PureInvoke
{
	public static class AdvApi32
	{
		[DllImport("advapi32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
		public static extern bool LookupAccountName(
			string lpSystemName,
			string lpAccountName,
			[MarshalAs(UnmanagedType.LPArray)] byte[] Sid,
			ref uint cbSid,
			StringBuilder referencedDomainName,
			ref uint cchReferencedDomainName,
			out SidNameUse peUse
		);

		[DllImport("advapi32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
		public static extern bool LookupAccountSid(
			string lpSystemName,
			[MarshalAs(UnmanagedType.LPArray)] byte[] Sid,
			StringBuilder lpName,
			ref uint cchName,
			StringBuilder referencedDomainName,
			ref uint cchReferencedDomainName,
			out SidNameUse peUse
		);

		[DllImport("advapi32.dll", CharSet=CharSet.Unicode)]
		public static extern uint LsaAddAccountRights(
			IntPtr PolicyHandle,
			IntPtr AccountSid,
			LSA_UNICODE_STRING[] UserRights,
			uint CountOfRights);

		[DllImport("advapi32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
		public static extern uint LsaClose(IntPtr ObjectHandle);

		[DllImport("advapi32.dll", SetLastError=true)]
		public static extern uint LsaEnumerateAccountRights(IntPtr PolicyHandle,
			IntPtr AccountSid,
			out IntPtr UserRights,
			out uint CountOfRights
			);

		[DllImport("advapi32.dll", SetLastError=true)]
		public static extern uint LsaFreeMemory(IntPtr pBuffer);

		[DllImport("advapi32.dll")]
		public static extern int LsaNtStatusToWinError(uint status);

		[DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
		public static extern uint LsaOpenPolicy(ref LSA_UNICODE_STRING SystemName, ref LSA_OBJECT_ATTRIBUTES ObjectAttributes, uint DesiredAccess, out IntPtr PolicyHandle );

		[DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
		public static extern uint LsaRemoveAccountRights(
			IntPtr PolicyHandle,
			IntPtr AccountSid,
			[MarshalAs(UnmanagedType.U1)]
			bool AllRights,
			LSA_UNICODE_STRING[] UserRights,
			uint CountOfRights);
	}
}
