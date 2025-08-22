<?php
$folder = "Alternador de Empresa";  // mesma pasta do zip.php
$zipName = "Alternador_de_Empresa.zip";

if (!is_dir($folder)) {
    exit("Erro: pasta '$folder' não encontrada.");
}

$zip = new ZipArchive();
$zipPath = sys_get_temp_dir() . "/" . $zipName;

if ($zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== TRUE) {
    exit("Não foi possível criar o arquivo ZIP.");
}

$files = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($folder, RecursiveDirectoryIterator::SKIP_DOTS),
    RecursiveIteratorIterator::SELF_FIRST
);

// Obter o caminho base para criar caminhos relativos corretos
$basePath = realpath($folder) . DIRECTORY_SEPARATOR;

foreach ($files as $file) {
    $filePath = $file->getRealPath();
    
    // Criar caminho relativo removendo o caminho base
    $relativePath = substr($filePath, strlen($basePath));
    
    // Normalizar separadores para ZIP (sempre usar /)
    $relativePath = str_replace('\\', '/', $relativePath);
    
    // MANTER a pasta "Alternador de Empresa" no ZIP
    $zipPath = "Alternador de Empresa/" . $relativePath;
    
    if ($file->isDir()) {
        // Adicionar diretório com barra no final
        $zip->addEmptyDir($zipPath . '/');
    } else {
        // Adicionar arquivo
        $zip->addFile($filePath, $zipPath);
    }
}

$zip->close();

// Limpar buffer de saída
ob_clean();
flush();

// Enviar headers
header('Content-Type: application/zip');
header('Content-Disposition: attachment; filename="' . $zipName . '"');
header('Content-Length: ' . filesize($zipPath));

// Enviar arquivo e limpar
readfile($zipPath);
unlink($zipPath);
exit;
?>