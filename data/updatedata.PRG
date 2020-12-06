SET  PROCEDURE TO updatedata
Do cleanData

Function cleanData()
Use act Excl
If Vartype(emaillist) # "U"
	Alter Table act Drop Column emaillist
	Alter Table act Drop Column lplaywav
	Alter Table act Drop Column laudio
	Alter Table act Add Column webmasterpk i
Endi
Use



Use webmaster Exclusive
Delete For Empty(email)
Pack
Replace email With Lower(email) All
Set Order To email   && EMAIL
sm = 'lkjkl;j'
Scan
	If email = sm
		Delete
	Endif
	sm = email
Endscan

Use act
Replace email With Lower(email) All
Index On email To kill
Set Order To kill


TEXT TO s noshow
   ACT         C (80),;
   SLUG        M ,;
   BODY        M ,;
   VENUEPK     I ,;
   NAME        C (40),;
   ADDRESS     C (50),;
   CSZ         C (30),;
   DPREVIEW    D ,;
   DOPEN       D ,;
   DCLOSE      D ,;
   COVER       C (80),;
   COMMENTS    M ,;
   DUPDATE     T ,;
   VENDORPK    I ,;
   VENDOR      C (60),;
   TICKETS     M ,;
   PHONE       C (25),;
   COMPANY     C (80),;
   COMPANYPK   I ,;
   CO_URL      C (100),;
   GENREPK     I ,;
   LCONFIRM    L ,;
   REMARK      M ,;
   DAYPHONE    C (15),;
   AGENRE      M ,;
ENDTEXT

li=Alines(laF,s)
For x = 1 To li
	laF(x) = Alltrim(laF(x))
	laF(x) = Substr(laF(x), 1,At(' ',laF(x)))
Next


Use jcschedule Exclusive
Delete Tag All
For x = 1 To li
	=DeleteField(laF(x))
Next
Index On pk Tag pk
Index On actpk Tag actpk


TEXT TO s noshow
   URL         C (100),;
   COMMENTS    M ,;
   LPHOTOMENU  L ,;
   WEBDIR      C (10),;
   TEMPLATE    M ,;
   PAYABLE     Y ,;
   PAID        Y ,;
   LPRESS      L )
ENDte

li=ALINES(laF,s)
FOR x = 1 TO li
laf(x) = ALLTRIM(laf(x))
laf(x) = SUBSTR(laf(X), 1,AT(' ',laf(x)))
NEXT
USE webmaster excl

DELETE TAG all
FOR x = 1 TO li
=DeleteField(laf(x))
NEXT
INDEX on pk TAG pk
INDEX on email TAG email
ENDFUNC





FUNCTION DeleteField(tcF)
LOCAL x
FOR x = 1 TO FCOUNT()
IF FIELD(x) == UPPER(ALLTRIM(tcF))
ALTER table (ALIAS()) drop COLUMN &tcF
ENDIF
NEXT
endfu



