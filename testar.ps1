$url = "https://alternadordeempresa.anvy.com.br/dev/teste.php"
try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    $data = $response.Content | ConvertFrom-Json
    Write-Host "Status: $($data.status)"
    Write-Host "Pasta: $($data.folder)"
    Write-Host "Arquivos encontrados: $($data.file_count)"
    
    if ($data.file_count -gt 0) {
        foreach ($file in $data.files) {
            Write-Host "✓ $($file.name) ($($file.size) bytes)"
        }
    }
}
catch {
    Write-Host "Erro: $($_.Exception.Message)"
    Write-Host "Resposta do servidor: $($_.Exception.Response)"
}

pause