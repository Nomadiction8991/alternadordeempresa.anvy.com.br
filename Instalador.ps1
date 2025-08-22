# Caminhos
$dest = "C:\Ello"
$zip  = "$dest\Alternador.zip"
$url  = "http://alternadordeempresa.anvy.com.br/dev/zip.php"  # PHP que gera ZIP

# 1. Garantir que a pasta base existe
if (!(Test-Path $dest)) {
    Write-Host "O sistema Ello não está instalado!"
    Pause
    exit
}

# 2. Apagar a pasta antiga se existir
$target = Join-Path $dest "Alternador de Empresa"
if (Test-Path $target) {
    Remove-Item $target -Recurse -Force
    Write-Host "Pasta antiga removida."
}

# 3. Baixar ZIP gerado pelo PHP
Write-Host "Baixando pacote do servidor..."
Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing

# 4. Descompactar
Write-Host "Extraindo arquivos..."
Expand-Archive -Path $zip -DestinationPath $dest -Force

# 5. Remover ZIP
Remove-Item $zip -Force

Write-Host "Instalação concluída com sucesso!"

Start-Sleep -Seconds 3

pause