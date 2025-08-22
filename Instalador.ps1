# Caminhos
$dest = "C:\Ello"
$zip = "$dest\Alternador.zip"
$url = "http://alternadordeempresa.anvy.com.br/dev/zip.php"

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
}

# Baixar arquivo
Write-Host "Baixando..."
Invoke-WebRequest -Uri $url -OutFile $zip

# Extrair
Write-Host "Extraindo..."
Expand-Archive -Path $zip -DestinationPath $dest -Force

# Limpar
Remove-Item $zip -Force

Write-Host "Concluído!"
pause