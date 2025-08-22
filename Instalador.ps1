# Caminhos
$dest = "C:\Ello"
$url = "http://alternadordeempresa.anvy.com.br/dev/listfiles.php"

# Verificar se pasta Ello existe
if (!(Test-Path $dest)) {
    Write-Host "Sistema Ello não está instalado!"
    pause
    exit
}

# Pasta de destino
$pastaAlvo = "$dest\Alternador de Empresa"
if (Test-Path $pastaAlvo) {
    Remove-Item $pastaAlvo -Recurse -Force
    Write-Host "Pasta antiga removida."
}

# Criar pasta
New-Item -ItemType Directory -Path $pastaAlvo -Force | Out-Null

# Baixar lista de arquivos
Write-Host "Conectando com servidor..."
try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    $fileList = $response.Content | ConvertFrom-Json
}
catch {
    Write-Host "Erro ao conectar: $($_.Exception.Message)"
    pause
    exit
}

# Se recebeu mensagem de erro
if ($response.Content -eq "PASTA_NAO_ENCONTRADA") {
    Write-Host "ERRO: Pasta não encontrada no servidor"
    pause
    exit
}

# Baixar e salvar cada arquivo
Write-Host "Baixando $($fileList.Count) arquivos..."
foreach ($file in $fileList) {
    try {
        $filePath = Join-Path $pastaAlvo $file.path
        $directory = [System.IO.Path]::GetDirectoryName($filePath)
        
        # Criar pasta se não existir
        if (!(Test-Path $directory)) {
            New-Item -ItemType Directory -Path $directory -Force | Out-Null
        }
        
        # Decodificar e salvar arquivo
        $bytes = [System.Convert]::FromBase64String($file.content)
        [System.IO.File]::WriteAllBytes($filePath, $bytes)
        
        Write-Host "✓ $($file.path)"
    }
    catch {
        Write-Host "✗ Erro em $($file.path): $($_.Exception.Message)"
    }
}

Write-Host "Instalação concluída com sucesso! ✅"
Write-Host "Arquivos instalados em: $pastaAlvo"
pause