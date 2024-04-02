using System;

namespace PureInvoke.LsaLookup
{
	[Flags]
	public enum PolicyAccessRights : uint
	{
		LocalInformation = 0x1,
		AuditInformation = 0x2,
		GetPrivateInformation = 0x4,
		TrustAdmin = 0x8,
		CreateAccount = 0x10,
		CreateSecret = 0x20,
		CreatePrivilege = 0x40,
		SetQuotaDefaultLimits = 0x80,
		SetAuditRequirements = 0x100,
		AuditLogAdmin = 0x200,
		ServerAdmin = 0x400,
		LookupNames = 0x800,
		Notification = 0x1000
	}
}
