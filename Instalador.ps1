# Caminhos
$dest = "C:\Ello"
$url = "http://localhost:3000/download-zip"

# Verificar se pasta existe
if (!(Test-Path $dest)) {
    Write-Host "Sistema Ello não está instalado!"
    pause
    exit
}

# Remover pasta antiga
$pasta = "$dest\Alternador de Empresa"
if (Test-Path $pasta) {
    Remove-Item $pasta -Recurse -Force
    Write-Host "Pasta antiga removida."
}

# Baixar e extrair
Write-Host "Baixando e instalando..."
try {
    # Baixar diretamente para a pasta destino
    Invoke-WebRequest -Uri $url -OutFile "$dest\Alternador.zip" -UseBasicParsing
    Expand-Archive -Path "$dest\Alternador.zip" -DestinationPath $dest -Force
    Remove-Item "$dest\Alternador.zip" -Force
    Write-Host "Instalação concluída com sucesso! ✅"
}
catch {
    Write-Host "Erro: $($_.Exception.Message)"
}

pause