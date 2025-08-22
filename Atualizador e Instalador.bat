@echo off
chcp 65001 >nul
title Atualizador - Alternador de Empresa
color 0A

echo.
echo    ============================================
echo         ATUALIZADOR ALTERNADOR DE EMPRESA
echo    ============================================
echo.

:: Verificar se o PHP está disponível
where php >nul 2>nul
if errorlevel 1 (
    echo Erro: PHP não encontrado no sistema.
    echo.
    echo Para usar este atualizador, você precisa:
    echo 1. Instalar PHP ou usar a versão portátil
    echo 2. Adicionar o PHP ao PATH do sistema
    echo.
    echo Solução alternativa: use o XAMPP ou PHP portable
    echo.
    pause
    exit /b 1
)

:: Executar o script PHP de atualização
echo Iniciando processo de atualização...
echo.
php atualizador.php
echo.
pause