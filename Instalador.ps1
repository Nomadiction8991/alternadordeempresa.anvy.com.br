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
    # Usar WebClient como alternativa mais tolerante
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $zip)
    Write-Host "Download concluído."
}
catch {
    Write-Host "Erro ao baixar arquivo: $($_.Exception.Message)"
    Write-Host "Tentando método alternativo..."
    
    # Tentar com Invoke-WebRequest com headers personalizados
    try {
        $headers = @{
            'Accept' = '*/*'
            'User-Agent' = 'Mozilla/5.0 (Windows NT; Windows NT 10.0; pt-BR) WindowsPowerShell/5.1'
        }
        Invoke-WebRequest -Uri $url -OutFile $zip -Headers $headers -UseBasicParsing
        Write-Host "Download concluído com método alternativo."
    }
    catch {
        Write-Host "Falha no download: $($_.Exception.Message)"
        Pause
        exit
    }
}

# 4. Verificar se o arquivo ZIP foi baixado corretamente
if (!(Test-Path $zip) -or (Get-Item $zip).Length -eq 0) {
    Write-Host "Arquivo ZIP corrompido ou vazio!"
    Remove-Item $zip -Force -ErrorAction SilentlyContinue
    Pause
    exit
}

Write-Host "Tamanho do arquivo: $((Get-Item $zip).Length) bytes"

# 5. Descompactar
Write-Host "Extraindo arquivos..."
try {
    # Método mais robusto para extrair
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $dest)
    Write-Host "Extração concluída com sucesso."
}
catch {
    Write-Host "Erro ao extrair arquivos: $($_.Exception.Message)"
    Write-Host "Tentando método Expand-Archive..."
    
    try {
        Expand-Archive -Path $zip -DestinationPath $dest -Force
        Write-Host "Extração concluída com Expand-Archive."
    }
    catch {
        Write-Host "Falha ao extrair arquivo ZIP: $($_.Exception.Message)"
        Remove-Item $zip -Force -ErrorAction SilentlyContinue
        Pause
        exit
    }
}

# 6. Remover ZIP
Remove-Item $zip -Force

Write-Host "Instalação concluída com sucesso!"
Write-Host "Verifique se os arquivos foram extraídos em: $target"

Start-Sleep -Seconds 3
pause