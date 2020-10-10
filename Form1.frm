VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Membuat Program Dijalankan pada StarUp"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6900
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   6900
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command2 
      Caption         =   "Nonaktifkan"
      Height          =   375
      Left            =   3720
      TabIndex        =   1
      Top             =   2280
      Width           =   1695
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Aktifkan"
      Height          =   375
      Left            =   1920
      TabIndex        =   0
      Top             =   2280
      Width           =   1575
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

'Created by Rizky Khapidsyah
'Source code dimulai dari sini

Option Explicit

Private Sub Command1_Click()
  'Ganti kedua kata 'NotePad' di bawah dengan nama
  'aplikasi Anda, dan c:\windows\notepad.exe' di bawah
  'dengan file aplikasi Anda...

  SetRegValue HKEY_LOCAL_MACHINE, _
  "Software\Microsoft\Windows\CurrentVersion\Run", _
  "Game", "G:\Buat Program\MY PROGRAM 1\DAFTAR GAME DAN FILM\GAME.exe"
End Sub

Private Sub Command2_Click()
  DeleteValue HKEY_LOCAL_MACHINE, _
     "Software\Microsoft\Windows\CurrentVersion\Run", _
     "NotePad"
End Sub


