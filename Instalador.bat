@echo off
setlocal enabledelayedexpansion
chcp 65001 
color 71
mode con: cols=63 lines=38
cls
echo.
echo.
echo.
echo                                 ░░░                         
echo                              ░▒▒▒▒▒▒░                       
echo                               ░▓▓▓▓▓░                       
echo                        ░      ░▒▓▓▓▓▓░                      
echo                       ░▓░      ░▓▓▓▓▓▓░                     
echo                       ░▓▒░      ░▓▓▓▓▓▒░                    
echo                      ░▓▓▓░       ░▓▓▓▓▓░                    
echo                     ░▓▓▓▓▓░      ░▒▓▓▓▓▓░                   
echo                    ░▓▓▓▓▓▓░       ░▓▓▓▓▓▓░                  
echo                   ░▒▓▓▓▓▓▒░        ░▓▓▓▓▓▒░                 
echo                  ░░▓▓▓▓▓▒░          ░▓▓▓▓▓░                 
echo                  ░▓▓▓▓▓▒░           ░▒▓▓▓▓▓░                
echo                 ░▓▓▓▓▓▒░             ░▓▓▓▓▓▓░               
echo                ░▓▓▓▓▓▒░               ░▓▓▓▓▓▒░              
echo               ░▒▓▓▓▓▒░                 ░▓▓▓▓▓░              
echo               ░▓▓▓▓▒░                  ░▓▓▓▓▓▓░             
echo              ░▓▓▓▓░░        ░░░░░       ░░░░░▓▓░            
echo             ░▓▓▓▓░        ░░▓▓▓▓░            ░░░            
echo            ░▒▓▓▒░        ░▒▓▓▓▓▓▓░░                         
echo            ░▓▓░░        ░▓▓▓▓▓▓▓▓▓▒░░                       
echo           ░▓░░        ░░▓▓▓▓▓▓▓▓▓▓▓▓▒░░                     
echo          ░▒░           ░░▒▓▓▓▓▓▓▓▓▓▓▓▓▒░░                   
echo         ░░                ░░░▒▓▓▓▓▓▓▓▓▓▓▓░░░                
echo                               ░░░░▓▓▓▓▓▓▓▓▓▒░░              
echo                                   ░░▒▓▓▓▓▓▓▓▓▓░░            
echo                                     ░░░▒▓▓▓▓▓▓▓▓░░          
echo                                        ░░▒▓▓▓▓▓▓▓▒░         
echo                                           ░▒▓▓▓▓▓▓░         
echo                                            ░░▓▓▓▓▓▓░        
echo                                              ░▓▓▓▓▓░        
echo                                               ░▓▓▓░         
echo                                               ░▓▓▓░         
echo                                               ░▓▓░          
echo                                               ░░░           
echo.
ping 127.0.0.1 -n 4 >nul                                                                                                 
cls
:: 1  Verificar se a pasta C:\Ello existe
if not exist "C:\Ello" (
    echo O sistema Ello nao esta instalado!
    pause
    exit /b
)

:: 2  Verificar e apagar a pasta C:\Ello\DBLinker se existir
if exist "C:\Ello\Altenador de Empresa" (
    echo Apagando a pasta Altenador de Empresa.   
    rmdir /s /q "C:\Ello\Altenador de Empresa."  :: /s apaga todos os arquivos e subpastas, /q faz o apagamento sem pedir confirmação
    echo Pasta Altenador de Empresa apagada com sucesso.
)

:: 3  Fazer o download da pasta DBLinker para C:\Ello
echo Baixando a pasta Altenador de Empresa de altenadorempresa.anvy.com.br/dev/   
:: Utilizando o curl para download  Se curl não estiver disponível, utilize PowerShell ou outro método alternativo 
curl -k -L -o "C:\Ello\Alternador de Empresa.zip" "http://altenadorempresa.anvy.com.br/dev/Alternador de Empresa.zip" 

:: 4  Descompactar a pasta (se o download for um arquivo ZIP)
echo Descompactando a pasta Altenador de Empresa.  
powershell -command "Expand-Archive -Path 'C:\Ello\Alternador de Empresa.zip' -DestinationPath 'C:\Ello' -Force"

:: 5  Limpar o arquivo ZIP depois de descompactado
del /f /q "C:\Ello\Alternador de Empresa.zip"
echo Arquivo ZIP apagado. 

echo Processo concluído com sucesso!
pause
