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
    Write-Host "Pasta antiga removida."
}

# Baixar arquivo
Write-Host "Baixando..."
try {
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
}
catch {
    Write-Host "Erro no download: $($_.Exception.Message)"
    pause
    exit
}

# Verificar se o arquivo é um ZIP válido
if (!(Test-Path $zip)) {
    Write-Host "Arquivo não foi baixado!"
    pause
    exit
}

$tamanho = (Get-Item $zip).Length
Write-Host "Tamanho do arquivo: $tamanho bytes"

if ($tamanho -lt 1000) {
    Write-Host "Arquivo muito pequeno - possivelmente contém mensagem de erro"
    $conteudo = Get-Content $zip -Raw
    Write-Host "Conteúdo: $conteudo"
    Remove-Item $zip -Force
    pause
    exit
}

# Tentar extrair de forma alternativa
Write-Host "Extraindo..."
try {
    # Método mais simples
    $shell = New-Object -ComObject Shell.Application
    $zipFolder = $shell.NameSpace($zip)
    $destFolder = $shell.NameSpace($dest)
    $destFolder.CopyHere($zipFolder.Items(), 16)
    Write-Host "Extração concluída!"
}
catch {
    Write-Host "Erro na extração: $($_.Exception.Message)"
    Write-Host "O arquivo ZIP pode estar corrompido."
}

# Limpar
Remove-Item $zip -Force
Write-Host "Processo concluído!"
pause