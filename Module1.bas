Attribute VB_Name = "Module1"
'Tombol pertama untuk menjalankan program saat startup, 'sedangkan tombol kedua untuk menghapusnya dari daftar 'startup program.

Public Type SECURITY_ATTRIBUTES
  nLength As Long
  lpSecurityDescriptor As Long
  bInheritHandle As Long
End Type

Declare Function RegOpenKeyEx Lib "advapi32.dll" _
Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal _
lpSubKey As String, ByVal ulOptions As Long, _
ByVal samDesired As Long, phkResult As Long) As Long

Declare Function RegCloseKey Lib "advapi32.dll" _
(ByVal hKey As Long) As Long

Declare Function RegQueryValueEx Lib "advapi32" Alias _
"RegQueryValueExA" (ByVal hKey As Long, _
ByVal lpValueName As String, ByVal lpReserved As _
Long, ByRef lpType As Long, ByVal lpData As String, _
ByRef lpcbData As Long) As Long

Declare Function RegSetValueEx Lib "advapi32.dll" _
Alias "RegSetValueExA" (ByVal hKey As Long, ByVal _
lpValueName As String, ByVal Reserved As Long, ByVal _
dwType As Long, ByVal lpData As String, ByVal cbData _
As Long) As Long

Declare Function RegDeleteValue Lib "advapi32.dll" _
Alias "RegDeleteValueA" (ByVal hKey As Long, ByVal _
lpValueName As String) As Long

Public Enum T_KeyClasses
  HKEY_CLASSES_ROOT = &H80000000
  HKEY_CURRENT_CONFIG = &H80000005
  HKEY_CURRENT_USER = &H80000001
  HKEY_LOCAL_MACHINE = &H80000002
  HKEY_USERS = &H80000003
End Enum

Private Const SYNCHRONIZE = &H100000
Private Const STANDARD_RIGHTS_ALL = &H1F0000
Private Const KEY_QUERY_VALUE = &H1
Private Const KEY_SET_VALUE = &H2
Private Const KEY_CREATE_LINK = &H20
Private Const KEY_CREATE_SUB_KEY = &H4
Private Const KEY_ENUMERATE_SUB_KEYS = &H8
Private Const KEY_EVENT = &H1
Private Const KEY_NOTIFY = &H10
Private Const READ_CONTROL = &H20000
Private Const STANDARD_RIGHTS_READ = (READ_CONTROL)
Private Const STANDARD_RIGHTS_WRITE = (READ_CONTROL)

Private Const KEY_ALL_ACCESS = ((STANDARD_RIGHTS_ALL _
Or KEY_QUERY_VALUE Or KEY_SET_VALUE Or _
KEY_CREATE_SUB_KEY Or KEY_ENUMERATE_SUB_KEYS Or _
KEY_NOTIFY Or KEY_CREATE_LINK) And (Not SYNCHRONIZE))

Private Const KEY_READ = ((STANDARD_RIGHTS_READ Or _
  KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or _
  KEY_NOTIFY) And (Not SYNCHRONIZE))
Private Const KEY_EXECUTE = (KEY_READ)
Private Const KEY_WRITE = ((STANDARD_RIGHTS_WRITE Or _
  KEY_SET_VALUE Or KEY_CREATE_SUB_KEY) And _
     (Not SYNCHRONIZE))
Private Const REG_BINARY = 3
Private Const REG_CREATED_NEW_KEY = &H1
Private Const REG_DWORD = 4
Private Const REG_DWORD_BIG_ENDIAN = 5
Private Const REG_DWORD_LITTLE_ENDIAN = 4
Private Const REG_EXPAND_SZ = 2
Private Const REG_FULL_RESOURCE_DESCRIPTOR = 9
Private Const REG_LINK = 6
Private Const REG_MULTI_SZ = 7
Private Const REG_NONE = 0
Private Const REG_SZ = 1
Private Const REG_NOTIFY_CHANGE_ATTRIBUTES = &H2
Private Const REG_NOTIFY_CHANGE_LAST_SET = &H4
Private Const REG_NOTIFY_CHANGE_NAME = &H1
Private Const REG_NOTIFY_CHANGE_SECURITY = &H8
Private Const REG_OPTION_BACKUP_RESTORE = 4
Private Const REG_OPTION_CREATE_LINK = 2
Private Const REG_OPTION_NON_VOLATILE = 0
Private Const REG_OPTION_RESERVED = 0
Private Const REG_OPTION_VOLATILE = 1
Private Const REG_LEGAL_CHANGE_FILTER = (REG_NOTIFY_CHANGE_NAME _
  Or REG_NOTIFY_CHANGE_ATTRIBUTES Or _
  REG_NOTIFY_CHANGE_LAST_SET Or _
  REG_NOTIFY_CHANGE_SECURITY)
Private Const REG_LEGAL_OPTION = (REG_OPTION_RESERVED Or REG_OPTION_NON_VOLATILE Or REG_OPTION_VOLATILE Or REG_OPTION_CREATE_LINK Or REG_OPTION_BACKUP_RESTORE)

Public Sub DeleteValue(rClass As T_KeyClasses, _
Path As String, sKey As String)
Dim hKey As Long
Dim res As Long
  res = RegOpenKeyEx(rClass, Path, 0, KEY_ALL_ACCESS, _
        hKey)
  res = RegDeleteValue(hKey, sKey)
  RegCloseKey hKey
End Sub

Public Function SetRegValue(KeyRoot As T_KeyClasses, Path As String, sKey As String, NewValue As String) As Boolean
Dim hKey As Long
Dim KeyValType As Long
Dim KeyValSize As Long
Dim KeyVal As String
Dim tmpVal As String
Dim res As Long
Dim i As Integer
Dim x As Long
  res = RegOpenKeyEx(KeyRoot, Path, 0, KEY_ALL_ACCESS, hKey)
  If res <> 0 Then GoTo Errore
  tmpVal = String(1024, 0)
  KeyValSize = 1024
  res = RegQueryValueEx(hKey, sKey, 0, KeyValType, _
        tmpVal, KeyValSize)
  Select Case res
         Case 2
              KeyValType = REG_SZ
         Case Is <> 0
              GoTo Errore
  End Select
  Select Case KeyValType
         Case REG_SZ
              tmpVal = NewValue
         Case REG_DWORD
              x = Val(NewValue)
              tmpVal = ""
              For i = 0 To 3
                  tmpVal = tmpVal & Chr(x Mod 256)
                  x = x \ 256
              Next
  End Select
  KeyValSize = Len(tmpVal)
  res = RegSetValueEx(hKey, sKey, 0, KeyValType, tmpVal, KeyValSize)
  If res <> 0 Then GoTo Errore
  SetRegValue = True
  RegCloseKey hKey
  Exit Function
Errore:
  SetRegValue = False
  RegCloseKey hKey
End Function


