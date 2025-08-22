@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title Instalador Automático
color 0A
mode con: cols=70 lines=20

:: Configurações
set "URL_BASE=https://alternadordeempresa.anvy.com.br/dev/"
set "PASTA_DOWNLOAD=C:\Ello\Alternador de Empresa"

:: Lista de arquivos para download (definida diretamente no batch)
set ARQUIVOS[0]=teste.txt

echo.
echo    ================================
echo         INSTALADOR AUTOMÁTICO
echo    ================================
echo.

:: Verificar se tem conexão com a internet
echo Verificando conexão com a internet...
ping -n 1 google.com >nul 2>&1
if errorlevel 1 (
    echo Erro: Nenhuma conexão com a internet detectada.
    pause
    exit /b 1
)

:: Criar pasta de download se não existir
if not exist "%PASTA_DOWNLOAD%" (
    echo Criando pasta de destino...
    mkdir "%PASTA_DOWNLOAD%"
)

:: Baixar cada arquivo da lista incorporada
set "COUNT=0"
set "SUCESSO=0"

for /l %%i in (0,1,3) do (
    set "ARQUIVO=!ARQUIVOS[%%i]!"
    echo Baixando: !ARQUIVO!
    
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; try { Invoke-WebRequest -Uri '%URL_BASE%%PASTA_DOWNLOAD%/!ARQUIVO!' -OutFile '%PASTA_DOWNLOAD%\!ARQUIVO!' -ErrorAction Stop; echo [OK] !ARQUIVO!; set /a SUCESSO+=1 } catch { echo [FALHA] !ARQUIVO! }"
    
    set /a COUNT+=1
    timeout /t 1 /nobreak >nul
)

echo.
echo Transferência concluída!
echo Arquivos baixados com sucesso: !SUCESSO! de !COUNT!
echo.
echo Os arquivos foram salvos na pasta: %PASTA_DOWNLOAD%
echo.

if !SUCESSO! == 0 (
    echo Nenhum arquivo foi baixado. Verifique sua conexão e a URL.
) else if !SUCESSO! lss !COUNT! (
    echo Alguns arquivos não puderam ser baixados.
    echo Verifique se os nomes dos arquivos estão corretos.
)

pause