@echo off
setlocal enabledelayedexpansion

:: 1. Verificar se a pasta C:\Ello existe
if not exist "C:\Ello" (
    echo O sistema Ello nao esta instalado!
    pause
    exit /b
)

:: 2. Verificar e apagar a pasta C:\Ello\DBLinker se existir
if exist "C:\Ello\DBLinker" (
    echo Apagando a pasta DBLinker...
    rmdir /s /q "C:\Ello\DBLinker"  :: /s apaga todos os arquivos e subpastas, /q faz o apagamento sem pedir confirmação
    echo Pasta DBLinker apagada com sucesso.
)

:: 3. Fazer o download da pasta DBLinker para C:\Ello
echo Baixando a pasta DBLinker de dblinker.anvy.com.br/dev/...
:: Utilizando o curl para download. Se curl não estiver disponível, utilize PowerShell ou outro método alternativo.
curl -L -o "C:\Ello\DBLinker.zip" "http://dblinker.anvy.com.br/dev/DBLinker.zip" 

:: 4. Descompactar a pasta (se o download for um arquivo ZIP)
echo Descompactando a pasta DBLinker...
powershell -command "Expand-Archive -Path 'C:\Ello\DBLinker.zip' -DestinationPath 'C:\Ello' -Force"

:: 5. Limpar o arquivo ZIP depois de descompactado
del /f /q "C:\Ello\DBLinker.zip"
echo Arquivo ZIP apagado.

echo Processo concluído com sucesso!
pause
