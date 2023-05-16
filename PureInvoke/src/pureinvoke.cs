namespace PureInvoke
{
	public enum ErrorCode : uint
	{
		Ok                       = 0x000,
		NERR_Success             = Ok,
		Success                  = Ok,
		InvalidFunction          = 0x001,
		FileNotFound             = 0x002,
		AccessDenied             = 0x005,
		InvalidHandle            = 0x006,
		HandleEof                = 0x026,  // 38
		InvalidParameter         = 0x057,
		InsufficientBuffer       = 0x07A,
		AlreadyExists            = 0x0B7,
		EnvVarNotFound           = 0x0cb,
		MoreData                 = 0x0ea,
		NoMoreItems              = 0x103,
		InvalidFlags             = 0x3EC,
		ServiceMarkedForDelete   = 0x430,
		NoneMapped               = 0x534,
		MemberNotInAlias         = 0x561,
		MemberInAlias            = 0x562,
		NoSuchMember             = 0x56B,
		InvalidMember            = 0x56C,
		NERR_GroupNotFound       = 0x8AC,
	}
}