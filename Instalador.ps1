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
try {
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
}
catch {
    Write-Host "Erro ao baixar arquivo: $($_.Exception.Message)"
    Pause
    exit
}

# 4. Verificar se o arquivo ZIP foi baixado corretamente
if (!(Test-Path $zip) -or (Get-Item $zip).Length -eq 0) {
    Write-Host "Arquivo ZIP corrompido ou vazio!"
    Remove-Item $zip -Force -ErrorAction SilentlyContinue
    Pause
    exit
}

# 5. Descompactar usando método mais robusto
Write-Host "Extraindo arquivos..."
try {
    # Método alternativo para extrair arquivos ZIP
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $dest)
}
catch {
    Write-Host "Erro ao extrair arquivos: $($_.Exception.Message)"
    Write-Host "Tentando método alternativo..."
    
    # Método de fallback usando Expand-Archive
    try {
        Expand-Archive -Path $zip -DestinationPath $dest -Force
    }
    catch {
        Write-Host "Falha ao extrair arquivo ZIP. O arquivo pode estar corrompido."
        Remove-Item $zip -Force -ErrorAction SilentlyContinue
        Pause
        exit
    }
}

# 6. Remover ZIP
Remove-Item $zip -Force

Write-Host "Instalação concluída com sucesso!"

Start-Sleep -Seconds 3
pause