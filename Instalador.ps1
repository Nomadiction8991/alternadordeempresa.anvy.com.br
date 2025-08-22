# Caminhos
$dest = "C:\Ello"
$zip  = "$dest\Alternador.zip"
$url  = "http://alternadordeempresa.anvy.com.br/dev/zip.php"

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
    # Usar WebClient que é mais tolerante
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $zip)
    Write-Host "Download concluído com sucesso."
}
catch {
    Write-Host "Erro no download: $($_.Exception.Message)"
    Write-Host "Tentando método alternativo com Invoke-WebRequest..."
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
        Write-Host "Download concluído com método alternativo."
    }
    catch {
        Write-Host "Falha completa no download: $($_.Exception.Message)"
        Write-Host "Verifique a conexão com a internet e tente novamente."
        Pause
        exit
    }
}

# 4. Verificar se o arquivo ZIP foi baixado corretamente
if (!(Test-Path $zip)) {
    Write-Host "Arquivo ZIP não foi baixado!"
    Pause
    exit
}

$fileSize = (Get-Item $zip).Length
Write-Host "Tamanho do arquivo: $fileSize bytes"

if ($fileSize -eq 0) {
    Write-Host "Arquivo ZIP está vazio - possivel erro no servidor."
    Remove-Item $zip -Force
    Pause
    exit
}

# 5. Descompactar
Write-Host "Extraindo arquivos..."
try {
    # Método preferencial usando .NET
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $dest)
    Write-Host "Extração concluída com sucesso."
}
catch {
    Write-Host "Erro na extração: $($_.Exception.Message)"
    Write-Host "Tentando método Expand-Archive..."
    
    try {
        Expand-Archive -Path $zip -DestinationPath $dest -Force
        Write-Host "Extração concluída com Expand-Archive."
    }
    catch {
        Write-Host "Falha na extração: $($_.Exception.Message)"
        Write-Host "O arquivo ZIP pode estar corrompido."
        Remove-Item $zip -Force
        Pause
        exit
    }
}

# 6. Remover ZIP e finalizar
Remove-Item $zip -Force
Write-Host "Instalação concluída com sucesso!"
Write-Host "Arquivos extraídos em: $target"

Start-Sleep -Seconds 2
Write-Host "Pressione qualquer tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")