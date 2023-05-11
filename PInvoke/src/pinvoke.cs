namespace PInvoke
{
	public static class WinError
	{
		public const int Ok                       = 0x000;
		public const int NERR_Success             = 0x000;
		public const int AccessDenied             = 0x005;
		public const int InvalidHandle            = 0x006;
		public const int InvalidParameter         = 0x057;
		public const int InsufficientBuffer       = 0x07A;
		public const int AlreadyExists            = 0x0B7;
		public const int NoMoreItems              = 0x103;
		public const int InvalidFlags             = 0x3EC;
		public const int ServiceMarkedForDelete   = 0x430;
		public const int NoneMapped               = 0x534;
		public const int MemberNotInAlias         = 0x561;
		public const int MemberInAlias            = 0x562;
		public const int NoSuchMember             = 0x56B;
		public const int InvalidMember            = 0x56C;
		public const int NERR_GroupNotFound       = 0x8AC;
	}
}