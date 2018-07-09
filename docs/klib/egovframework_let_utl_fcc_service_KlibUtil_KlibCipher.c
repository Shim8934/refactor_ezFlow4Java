#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "egovframework_let_utl_fcc_service_KlibUtil_KlibCipher.h"
#include "klib.h"
#include "klib_ecparams.h"

JNIEXPORT jbyteArray JNICALL Java_egovframework_let_utl_fcc_service_KlibUtil_00024KlibCipher_encrypt(JNIEnv *env, jobject obj, jbyteArray fileBytes){
	
	size_t n = (*env)->GetArrayLength(env, fileBytes);
	jbyte* pbyte = (*env)->GetByteArrayElements(env,fileBytes, 0);

	KL_CONTEXT keygenctx = {
			{KLO_CTX_SYM_KEY_GEN, NULL, 1, FALSE, FALSE},
	};
	KL_BYTE SecretKeyBuf[32] = "";
	KL_OBJECT oKey = {
			{KLO_SECRET_KEY, NULL, 0, FALSE, FALSE},
			{KLA_VALUE, SecretKeyBuf, 32, TRUE, FALSE}
	};
	KL_BYTE iv[16]="";
	KL_CONTEXT encctx = {
			{KLO_CTX_SEED_CFB, NULL, 0, FALSE, FALSE},
			{KLA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//KL_BYTE DataBuf;
	KL_OBJECT oData = {
			{KLO_DATA, NULL, 0, FALSE, FALSE},
			{KLA_VALUE, NULL, 0, TRUE, FALSE}
	};
	
	//KL_BYTE EncDataBuf[n + KL_SEED_BLOCK_BYTE_LEN] = "";
	KL_BYTE *EncDataBuf = malloc(n + KL_SEED_BLOCK_BYTE_LEN);
	KL_OBJECT oEncryptedData = {
		{KLO_DATA, NULL, 0, FALSE, FALSE},
		{KLA_VALUE, NULL, 0, FALSE, FALSE}
	};
	//KL_OBJECT oEncryptedData = {
	//		{KLO_DATA, NULL, 0, FALSE, FALSE},
	//		{KLA_VALUE, EncDataBuf, sizeof(EncDataBuf), FALSE, FALSE}
	//};

	KL_RV ret;
	KL_ULONG ulEncDataLen, i, k;
	
	//K_HexDump(DataBuf, ulDataLen, "data");


	/* 키 생성 */
	/*if((ret = K_GenerateKey(&keygenctx,(KL_OBJECT_PTR)&oKey))!=KLR_OK)
	{
			printf("K_GenerateKey fails: %s\n",K_GetErrorMsg(ret));
			goto err;
	}
*/	
	/* 암호화 */
	if((ret = K_EncryptInit(&encctx, (KL_OBJECT_PTR) &oKey)) != KLR_OK) {
		printf("K_EncryptInit fails: %s\n",K_GetErrorMsg(ret));
		goto err;
	}
	
	//if((ret = K_Encrypt(&encctx, (KL_OBJECT_PTR) &oData, (KL_OBJECT_PTR) &oEncryptedData)) != KLR_OK)
	//{
	//	printf("K_Encrypt fails: %s\n",K_GetErrorMsg(ret));
	//	goto err;
	//}
	
	//////////////////////////
	i = k = 0;
	ulEncDataLen = sizeof(EncDataBuf);
	while(i < n)
	{
		KL_ULONG rem = n - i;
		KL_ULONG chunk, tmp;

		if (rem < 100)
			chunk = rem;
		else
			chunk = 100;

		tmp = ulEncDataLen - k;

		oData[1].pValue = &(pbyte[i]);
		oData[1].ulValueLen = chunk;

		/* 암호문의 길이를 구한다. */
		oEncryptedData[1].pValue = NULL;
		if( (ret = K_EncryptUpdate(&encctx,
			(KL_OBJECT_PTR)&oData,
			(KL_OBJECT_PTR)&oEncryptedData)) != KLR_OK )
		{
			printf("K_EncryptUpdate fails: %s\n",K_GetErrorMsg(ret));
			goto err;
		}

		oEncryptedData[1].pValue = &(EncDataBuf[k]);
		if( (ret = K_EncryptUpdate(&encctx,
			(KL_OBJECT_PTR)&oData,
			(KL_OBJECT_PTR)&oEncryptedData)) != KLR_OK )
		{
			printf("K_EncryptUpdate fails: %s\n",K_GetErrorMsg(ret));
			goto err;
		}
		tmp = oEncryptedData[1].ulValueLen;

		k += tmp;
		i += chunk;
	}
	
	ulEncDataLen = k;

	/* 암호문의 길이를 구한다. */
	oEncryptedData[1].pValue = NULL;
	if( (ret = K_EncryptFinal(&encctx,
		(KL_OBJECT_PTR)&oEncryptedData)) != KLR_OK )
	{
		printf("K_EncryptFinal fails: %s\n",K_GetErrorMsg(ret));
		goto err;
	}
	
	oEncryptedData[1].pValue = &(EncDataBuf[k]);
	if( (ret = K_EncryptFinal(&encctx,
		(KL_OBJECT_PTR)&oEncryptedData)) != KLR_OK )
	{
		printf("K_EncryptFinal fails: %s\n",K_GetErrorMsg(ret));
		goto err;
	}
	
	ulEncDataLen += oEncryptedData[1].ulValueLen;

	//K_HexDump(EncDataBuf, ulEncDataLen, "encrypted data");
 ///////////////////////////////////////////////////////////
	
        //K_HexDump(oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen, "encrypted data");

	//jbyteArray javaBytes;
	//int len = oEncryptedData[1].ulValueLen;
	//javaBytes = (*env)->NewByteArray(env, len);
	//(*env)->SetByteArrayRegion(env, javaBytes, 0, len, (jbyte *)oEncryptedData[1].pValue);
	//(*env)->ReleaseByteArrayElements(env, fileBytes, pbyte, 0);	
	
	
	(*env)->ReleaseByteArrayElements(env, fileBytes, pbyte, JNI_ABORT);
	
	jbyteArray javaBytes;
	int len = ulEncDataLen;
	javaBytes = (*env)->NewByteArray(env, len);
	(*env)->SetByteArrayRegion(env, javaBytes, 0, len, (jbyte *) EncDataBuf);

	return javaBytes;

err:	;
	jbyteArray rtnJavaBytes;
	char errStr[] = "ERR:";
	char *errMessage = K_GetErrorMsg(ret);
	const char *rtnStr = strcat(errStr, errMessage);
	int rtnStrLen = strlen(rtnStr);
	rtnJavaBytes = (*env)->NewByteArray(env, rtnStrLen);
	(*env)->SetByteArrayRegion(env, rtnJavaBytes, 0, rtnStrLen, (jbyte *)rtnStr);

	
	return rtnJavaBytes;
}

JNIEXPORT jbyteArray JNICALL Java_egovframework_let_utl_fcc_service_KlibUtil_00024KlibCipher_decrypt(JNIEnv *env, jobject obj, jbyteArray fileBytes){
	
	size_t n = (*env)->GetArrayLength(env, fileBytes);
	jbyte* pbyte = (*env)->GetByteArrayElements(env,fileBytes, 0);

	KL_CONTEXT keygenctx = {
			{KLO_CTX_SYM_KEY_GEN, NULL, 1, FALSE, FALSE},
	};
	KL_BYTE SecretKeyBuf[32] = "";
	KL_OBJECT oKey = {
			{KLO_SECRET_KEY, NULL, 0, FALSE, FALSE},
			{KLA_VALUE, SecretKeyBuf, 32, TRUE, FALSE}
	};

	KL_BYTE iv[16]="";
	KL_CONTEXT encctx = {
			{KLO_CTX_SEED_CFB, NULL, 0, FALSE, FALSE},
			{KLA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	//KL_BYTE DataBuf[n];
	KL_OBJECT oData = {
			{KLO_DATA, NULL, 0, FALSE, FALSE},
			{KLA_VALUE, NULL, 0, TRUE, FALSE}
	};
	
	//KL_BYTE DecDataBuf[n] = "";
	KL_BYTE *DecDataBuf = malloc(n);
	KL_OBJECT oDecryptedData = {
		{KLO_DATA, NULL, 0, FALSE, FALSE},
		{KLA_VALUE, DecDataBuf, 0, TRUE, FALSE}
	};
	//KL_OBJECT oDecryptedData = {
	//	{KLO_DATA, NULL, 0, FALSE, FALSE},
	//	{KLA_VALUE, DecDataBuf, sizeof(DecDataBuf), TRUE, FALSE}
	//};
	
	KL_RV ret;
	KL_ULONG ulDecDataLen, i, k;
	
	//K_HexDump(DataBuf, ulDataLen, "data");

	//K_HexDump(oData[1].pValue, oData[1].ulValueLen, "source data");

        /* 키 생성 */
        /*if((ret = K_GenerateKey(&keygenctx,(KL_OBJECT_PTR)&oKey))!=KLR_OK)
        {
                          printf("K_GenerateKey fails: %s\n",K_GetErrorMsg(ret));
                                          goto err;
     	}
        */                                                
	/*복호화*/
	if( (ret = K_DecryptInit(&encctx,
		(KL_OBJECT_PTR)&oKey)) != KLR_OK )
	{
		printf("K_DecryptInit fails: %s\n",K_GetErrorMsg(ret));
		goto err;
	}	

	i = k = 0;
	ulDecDataLen = sizeof(DecDataBuf);

	while(i < n)
	{
		KL_ULONG rem = n - i;
		KL_ULONG chunk, tmp;

		if (rem < 101)
			chunk = rem;
		else
			chunk = 101;

		tmp = ulDecDataLen - k;

		oData[1].pValue = &(pbyte[i]);
		oData[1].ulValueLen = chunk;

		/* 평문의 길이를 구한다. */
		oDecryptedData[1].pValue = NULL;
		if( (ret = K_DecryptUpdate(&encctx,
			(KL_OBJECT_PTR)&oData,
			(KL_OBJECT_PTR)&oDecryptedData)) != KLR_OK )
		{
			printf("K_DecryptUpdate fails: %s\n",K_GetErrorMsg(ret));
			goto err;
		}

		oDecryptedData[1].pValue = &(DecDataBuf[k]);
		if( (ret = K_DecryptUpdate(&encctx,
			(KL_OBJECT_PTR)&oData,
			(KL_OBJECT_PTR)&oDecryptedData)) != KLR_OK )
		{
			printf("K_DecryptUpdate fails: %s\n",K_GetErrorMsg(ret));
			goto err;
		}
		tmp = oDecryptedData[1].ulValueLen;

		k += tmp;
		i += chunk;
	}
	ulDecDataLen = k;

	/* 평문의 길이를 구한다. */
	oDecryptedData[1].pValue = NULL;
	if( (ret = K_DecryptFinal(&encctx,
		(KL_OBJECT_PTR)&oDecryptedData)) != KLR_OK )
	{
		printf("K_DecryptFinal fails: %s\n",K_GetErrorMsg(ret));
		goto err;
	}

	oDecryptedData[1].pValue = &(DecDataBuf[k]);
	if( (ret = K_DecryptFinal(&encctx,
		(KL_OBJECT_PTR)&oDecryptedData)) != KLR_OK )
	{
		printf("K_DecryptFinal fails: %s\n",K_GetErrorMsg(ret));
		goto err;
	}
	ulDecDataLen += oDecryptedData[1].ulValueLen;

	(*env)->ReleaseByteArrayElements(env, fileBytes, pbyte, JNI_ABORT);
	
	//K_HexDump(DecDataBuf, ulDecDataLen, "decrypted data");

	jbyteArray javaBytes;
	int len = ulDecDataLen;
	javaBytes = (*env)->NewByteArray(env, len);
	(*env)->SetByteArrayRegion(env, javaBytes, 0, len, (jbyte *) DecDataBuf);
        
       return javaBytes;
        
err:	;
	jbyteArray rtnJavaBytes;
    char errStr[] = "ERR:";
	char *errMessage = K_GetErrorMsg(ret);
	const char *rtnStr = strcat(errStr, errMessage);
	int rtnStrLen = strlen(rtnStr);
    rtnJavaBytes = (*env)->NewByteArray(env, rtnStrLen);
    (*env)->SetByteArrayRegion(env, rtnJavaBytes, 0, rtnStrLen, (jbyte *)rtnStr);


    return rtnJavaBytes;
}
        

