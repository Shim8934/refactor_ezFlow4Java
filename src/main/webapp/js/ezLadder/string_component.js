function TrimText( orgStr )
{
	var copyStr = "";
	var strIndex;

	for ( strIndex = 0; strIndex < orgStr.length; strIndex ++ ) {
		if ( orgStr.charAt(strIndex) == ' ' ) continue;
		else {
			copyStr = orgStr.substr( strIndex );
			break;
		}
	}
	for ( strIndex = copyStr.length - 1; strIndex >= 0; strIndex -- ) {
		if ( copyStr.charAt(strIndex) == ' ' ) continue;
		else {
			copyStr = copyStr.substr( 0, strIndex + 1 );
			break;
		}
	}
	return copyStr;
}