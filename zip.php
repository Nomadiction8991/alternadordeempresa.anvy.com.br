<?php
$folder = "Alternador de Empresa";
$zipName = "Alternador_de_Empresa.zip";

// Verificar se a pasta existe
if (!is_dir($folder)) {
    http_response_code(404);
    exit("ERRO: Pasta não encontrada");
}

// Criar arquivo ZIP
$zip = new ZipArchive();
$zipPath = sys_get_temp_dir() . '/' . $zipName;

if ($zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== TRUE) {
    http_response_code(500);
    exit("ERRO: Não foi possível criar o ZIP");
}

// Adicionar arquivos de forma simples
$iterator = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($folder, RecursiveDirectoryIterator::SKIP_DOTS),
    RecursiveIteratorIterator::SELF_FIRST
);

foreach ($iterator as $file) {
    if ($file->isFile()) {
        $localPath = substr($file->getRealPath(), strlen(realpath($folder)) + 1);
        $zip->addFile($file->getRealPath(), $localPath);
    }
}

$zip->close();

// Enviar para download
header('Content-Type: application/zip');
header('Content-Disposition: attachment; filename="' . $zipName . '"');
header('Content-Length: ' . filesize($zipPath));
readfile($zipPath);
unlink($zipPath);
exit;
?>