<?php
$folder = "Alternador de Empresa";
$zipName = "Alternador_de_Empresa.zip";

if (!is_dir($folder)) {
    http_response_code(404);
    exit("Pasta não encontrada");
}

$zip = new ZipArchive();
$zipPath = sys_get_temp_dir() . "/" . $zipName;

if ($zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== TRUE) {
    http_response_code(500);
    exit("Erro ao criar ZIP");
}

$files = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($folder, RecursiveDirectoryIterator::SKIP_DOTS),
    RecursiveIteratorIterator::SELF_FIRST
);

$basePath = realpath($folder) . DIRECTORY_SEPARATOR;

foreach ($files as $file) {
    $filePath = $file->getRealPath();
    $relativePath = substr($filePath, strlen($basePath));
    $relativePath = str_replace('\\', '/', $relativePath);
    $zipPath_internal = "Alternador de Empresa/" . $relativePath;
    
    if ($file->isDir()) {
        $zip->addEmptyDir($zipPath_internal . '/');
    } else {
        $zip->addFile($filePath, $zipPath_internal);
    }
}

$zip->close();

// SEM Content-Length para evitar o erro
header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename="' . $zipName . '"');

readfile($zipPath);
unlink($zipPath);
?>