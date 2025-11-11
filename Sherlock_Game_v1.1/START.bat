@echo off
title Sherlock Holmes: The Pursuit Game - Setup
powershell -ExecutionPolicy Bypass -File "%~dp0Install.ps1"
```

---

##Package Structure
```
Sherlock_Game_v1.0.zip
└── Sherlock_Game/
    ├── START.bat              ← Users click this
    ├── Install.ps1            ← PowerShell script
    ├── Sherlock.exe
    ├── icon.ico
    ├── libgcc_s_dw2-1.dll
    ├── libstdc++-6.dll
    ├── resources/
    └── README.txt