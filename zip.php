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
    RecursiveIteratorIterator::LEAVES_ONLY  // Alterado para LEAVES_ONLY
);

$basePath = realpath($folder);

foreach ($files as $file) {
    if (!$file->isDir()) {
        $filePath = $file->getRealPath();
        $relativePath = substr($filePath, strlen($basePath) + 1);
        $relativePath = str_replace('\\', '/', $relativePath);
        
        $zip->addFile($filePath, $relativePath);
    }
}

if (!$zip->close()) {
    http_response_code(500);
    exit("Erro ao fechar arquivo ZIP");
}

// Headers corretos
header('Content-Type: application/zip');
header('Content-Disposition: attachment; filename="' . $zipName . '"');
header('Content-Length: ' . filesize($zipPath));
header('Pragma: no-cache');
header('Expires: 0');

readfile($zipPath);
unlink($zipPath);
exit;
?>