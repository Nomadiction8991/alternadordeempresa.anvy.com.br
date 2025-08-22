# Caminhos
$dest = "C:\Ello"
$url = "http://alternadordeempresa.anvy.com.br/dev/zip.php"

# Verificar se pasta Ello existe
if (!(Test-Path $dest)) {
    Write-Host "Sistema Ello não está instalado!"
    pause
    exit
}

# Remover pasta antiga
$pastaAlvo = "$dest\Alternador de Empresa"
if (Test-Path $pastaAlvo) {
    Remove-Item $pastaAlvo -Recurse -Force
    Write-Host "Pasta antiga removida."
}

# Criar pasta temporária
$tempDir = [System.IO.Path]::GetTempPath()
$tempZip = Join-Path $tempDir "Alternador_temp.zip"

# Baixar arquivo
Write-Host "Conectando com servidor..."
try {
    # Método mais tolerante a erros
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add('User-Agent', 'PowerShell-Download')
    $webClient.DownloadFile($url, $tempZip)
    
    Write-Host "Download concluído!"
}
catch {
    Write-Host "Erro no download: $($_.Exception.Message)"
    Write-Host "Verifique:"
    Write-Host "1. Conexão com internet"
    Write-Host "2. URL do servidor: $url"
    Write-Host "3. Se o arquivo zip.php existe no servidor"
    pause
    exit
}

# Verificar se download foi bem sucedido
if (!(Test-Path $tempZip) -or (Get-Item $tempZip).Length -eq 0) {
    Write-Host "Download falhou - arquivo vazio ou não existe"
    pause
    exit
}

# Tentar extrair
Write-Host "Extraindo arquivos..."
try {
    # Método .NET mais confiável
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($tempZip, $dest)
    Write-Host "Extração bem sucedida! ✅"
}
catch {
    Write-Host "Erro na extração: $($_.Exception.Message)"
    Write-Host "O arquivo pode estar corrompido no servidor."
    
    # Mostrar conteúdo se for pequeno (possível mensagem de erro)
    if ((Get-Item $tempZip).Length -lt 5000) {
        try {
            $conteudo = Get-Content $tempZip -Raw -Encoding UTF8
            Write-Host "Conteúdo recebido: $conteudo"
        }
        catch {
            Write-Host "Não foi possível ler o conteúdo do arquivo"
        }
    }
}

# Limpar
if (Test-Path $tempZip) {
    Remove-Item $tempZip -Force
}

Write-Host "Processo finalizado!"
pause